import argparse
import time

from pyspark.sql import SparkSession
from pyspark.sql.functions import regexp_replace, lit, current_timestamp

from config import Config
from db_definition_repository import DbDefinitionRepository, TableDef
from ingestible_db_table_conf import IngestibleDbTableConf
from ingestible_db_repository import IngestibleDbConfRepository
from ingestion_group import IngestionGroup
from ingestion_job_type import IngestionJobType
from ingestion_job_repository import IngestionJob, IngestionJobRepository
from ingestion_job_status import IngestionJobStatus
from ingestion_type import IngestionType
from hive_db_manager import HiveDbManager
from hive_schema_manager import HiveChangeTracking, HiveSchemaManager
from logging_utils import LoggingUtils
from mssql_db_manager import MsSqlDbManager
from query_utils import QueryUtils
import cli_utils


class SparkDbTableIngester:
    """
    Ingests DB tables from MS SQL into Hive.
    It processes sequentially a list of tables, as specified by IngestibleDbTableConf objects.
    For each table it uses the TableDefs, for the corresponding DatabaseType.
    """
    CHANGE_TRACKING_VERSION_QUERY = "SELECT CHANGE_TRACKING_CURRENT_VERSION() AS CT_Version"
    JDTS_DRIVER_CLASS = "net.sourceforge.jtds.jdbc.Driver"
    SELECT_QUERY = "(SELECT %s FROM %s WITH (NOLOCK)) t"
    INCREMENTAL_CHANGES_QUERY = "(SELECT %s FROM CHANGETABLE (CHANGES %s, %s) AS %s " \
                                "LEFT JOIN %s AS %s WITH (NOLOCK) ON (%s) WHERE %s <= %s) t"
    CT_OPERATION_COL = "CASE WHEN {0} IS NOT NULL AND {1}='D' THEN 'U' ELSE {1} END as {1}"

    CHANGE_TRACKING_COLUMNS = [ct_col["column_name"] for ct_col in HiveChangeTracking.COLUMNS]

    SOURCE_TABLE_ALIAS = "ST"
    ORIGINAL_TABLE_ALIAS = "OT"
    CHANGE_TRACKING_TABLE_ALIAS = "CT"

    def __init__(self, ingestion_group, ingestion_job_type):
        """

        :type ingestion_group: int
        :type ingestion_job_type: int
        """
        self.logger = Config.get_logger(__package__)
        self.ingestion_group = ingestion_group
        self.ingestion_job_type = ingestion_job_type
        self.mssql_db_mgr = MsSqlDbManager()
        self.hive_schema_mgr = HiveSchemaManager()
        self.hive_db_mgr = HiveDbManager()
        self.ingestion_job_repo = IngestionJobRepository()
        self.db_definition_repo = DbDefinitionRepository()
        self.ingestible_db_conf_repo = IngestibleDbConfRepository(self.ingestion_group)
        self.db_import_definitions = self._get_db_import_definitions()
        self.spark_session = self._get_spark_session()

    def _get_db_import_definitions(self):
        """
        :rtype: dict of int:dict of str:TableDef
        """
        self.logger.debug("Get Db Import definitions")
        db_definitions_by_db_type = {}
        for db_type in self.ingestible_db_conf_repo.get_ingestible_db_types():
            db_definitions_by_db_type[db_type] = self.db_definition_repo.get_db_definition(db_type)
        return db_definitions_by_db_type

    def _get_spark_session(self):
        """
        Returns a SparkSession with hive support enabled
        :rtype: SparkSession
        """
        self.logger.debug("Get Spark Session")
        hive_metastore = HiveSchemaManager.get_metastore()
        spark_session = SparkSession \
            .builder \
            .appName("data_import") \
            .config("spark.ui.enabled", "false") \
            .config("hive.metastore.uris", "thrift://%s:9083" % hive_metastore) \
            .config("hive.exec.dynamic.partition", "true") \
            .config("hive.exec.dynamic.partition.mode", "nonstrict") \
            .enableHiveSupport() \
            .getOrCreate()
        return spark_session

    def _ingest_table(self, ingestible_conf, ingestible_def, ingestion_job):
        """

        :type ingestible_conf: IngestibleDbTableConf
        :type ingestible_def: TableDef
        :type ingestion_job: IngestionJob
        :rtype: IngestionJobStatus
        """
        self.logger.info("Ingest to temp table")
        self.logger.debug("Ingest to temp Table with Ingestible Conf: %s" % ingestible_conf)

        start = time.time()
        table_name = self._get_target_table_name(ingestible_conf, ingestible_def)

        mssql_jdbc_string = self.mssql_db_mgr.get_jdbc_conn_string(ingestible_conf)
        select_query = self._generate_select_query(ingestible_def, ingestion_job)

        self.logger.debug("Loading data with MS SQL conn string: %s, Query: %s" % (mssql_jdbc_string, select_query))
        data_frame = self.spark_session.read.format("jdbc").options(url=mssql_jdbc_string, dbtable=select_query,
                                                                    driver=self.JDTS_DRIVER_CLASS).load()

        data_frame = data_frame.withColumn(HiveSchemaManager.INGESTION_JOB_ID_COLUMN,
                                           lit(ingestion_job.ingestion_job_id))
        data_frame = data_frame.withColumn(HiveSchemaManager.MODIFIED_ON_COLUMN, current_timestamp())


        self.logger.debug("Replacing line terminators")
        self._replace_line_terminators(data_frame)

        if ingestible_def.ingestion_type == IngestionType.INCREMENTAL and \
                self.ingestion_job_type == IngestionJobType.INCREMENTAL:
            self.logger.debug("Write DataFrame to table: %s" % table_name)
            data_frame.write \
                .mode('append') \
                .format('hive') \
                .saveAsTable(table_name, partitionBy=ingestible_def.partition_fields)

            if data_frame.count() > 0:
                job_status = IngestionJobStatus.SUCCESS
            else:
                job_status = IngestionJobStatus.NO_CHANGE
        else:
            temp_table = HiveSchemaManager.get_temp_table_name(table_name)

            self.logger.debug("Write DataFrame to table: %s" % temp_table)
            data_frame.write \
                .mode('append') \
                .format('hive') \
                .saveAsTable(temp_table, partitionBy=ingestible_def.partition_fields)

            job_status = IngestionJobStatus.SUCCESS

        end = time.time()
        elapsed = LoggingUtils.elapsed_time(start, end)
        self.logger.info("End ingesting to target table: %s, elapsed: %s" % (table_name, elapsed))
        return job_status

    def _process_ingestion_job(self, ingestible_conf, ingestible_def, ingestion_job):
        """

        :type ingestible_conf: IngestibleDbTableConf
        :type ingestion_job: IngestionJob
        :rtype: IngestionJobStatus
        """
        try:
            self.logger.info("Process Ingestion Job")
            self.logger.debug("Process Ingestion Job: %s, Ingestible Conf: %s" % (ingestion_job, ingestible_conf))
            self.ingestion_job_repo.update_started(ingestion_job.ingestion_job_id)
            job_status = self._ingest_table(ingestible_conf, ingestible_def, ingestion_job)
        except Exception as ex:
            self.logger.exception(ex)
            job_status = IngestionJobStatus.FAIL

        return job_status

    def ingest(self, ingestible_confs):
        """
        :type ingestible_confs: list of IngestibleDbTableConf
        :rtype: list of IngestionJob
        """
        self.logger.info("Create Ingestion Jobs")
        self.logger.debug("Create Ingestion Jobs for Ingestible DB Table Confs: %s" % ingestible_confs)
        ingestible_job_tuples = []
        for ingestible_conf in ingestible_confs:
            ingestible_defs = self.db_import_definitions[ingestible_conf.db_type]
            ingestible_def = ingestible_defs[ingestible_conf.table_name]
            ingestion_job = self._create_ingestion_job(ingestible_conf, ingestible_def)
            ingestible_job_tuple = (ingestible_conf, ingestible_def, ingestion_job)
            ingestible_job_tuples.append(ingestible_job_tuple)

        job_statuses = {}
        for ingestible_job_tuple in ingestible_job_tuples:
            ingestion_job = ingestible_job_tuple[2]
            job_status = self._process_ingestion_job(ingestible_job_tuple[0], ingestible_job_tuple[1], ingestion_job)
            self.ingestion_job_repo.update_status(job_status, ingestion_job.ingestion_job_id)
            job_statuses[ingestion_job.ingestion_job_id] = job_status

        return job_statuses

    def _replace_line_terminators(self, data_frame):
        """

        :type data_frame: DataFrame
        :rtype: DataFrame
        """
        self.logger.debug("Replace line terminators for data frame")
        ct_dict = dict(data_frame.dtypes)
        return data_frame.select(*[regexp_replace(data_frame[column], "\r\n|\r|\n|\01", "")
                                   if ct_dict[column] == "string" else column
                                   for column in data_frame.columns])

    def _get_target_table_name(self, ingestible_conf, ingestible_def):
        """

        :type ingestible_conf: IngestibleDbTableConf
        :type ingestible_def: TableDef
        :rtype: str
        """
        self.logger.debug("Get target table name, Ingestible Conf: %s" % ingestible_conf)
        if ingestible_def.ingestion_type == IngestionType.INCREMENTAL and \
                self.ingestion_job_type == IngestionJobType.INCREMENTAL:
            table_name = HiveSchemaManager.get_ct_table_name(ingestible_conf.table_name)
        else:
            table_name = ingestible_conf.table_name
        return HiveSchemaManager.qualify_table_name(table_name, ingestible_conf.target_db_name)

    def _get_change_tracking_version(self, ingestible_conf):
        """
        :type ingestible_conf: IngestibleDbTableConf
        :rtype: int
        """
        self.logger.info("Get Change Tracking version")
        self.logger.debug("Get Change Tracking version for Ingestible DB Table Conf: %s" % ingestible_conf)

        ct_query = self.CHANGE_TRACKING_VERSION_QUERY
        results = self.mssql_db_mgr.execute_query(ct_query, db_conn_conf=ingestible_conf)

        ct_version = results[0]["CT_Version"]
        if ct_version is not None:
            self.logger.debug("Got Change Tracking version: %s" % ct_version)
            return ct_version
        else:
            raise Exception("Unable to get CT version, possibly CT is disabled. Ingestible conf: %s" % ingestible_conf)

    def _create_ingestion_job(self, ingestible_conf, ingestible_def):
        """

        :type ingestible_conf: IngestibleDbTableConf
        :type ingestible_def: TableDef
        :rtype: IngestionJob
        """
        self.logger.debug("Crete ingestion job, Ingestible Conf: %s" % ingestible_conf)
        version = self._get_change_tracking_version(ingestible_conf)
        last_successful_job = self.ingestion_job_repo.get_last_successful_job(ingestible_conf.db_name,
                                                                              ingestible_conf.table_name)
        previous_version = 0
        if last_successful_job is not None and last_successful_job.previous_version is not None:
            previous_version = last_successful_job.version
        return self.ingestion_job_repo.create_job(customer_id=ingestible_conf.customer_id,
                                                  db_type=ingestible_conf.db_type,
                                                  db_name=ingestible_conf.db_name,
                                                  table_name=ingestible_conf.table_name,
                                                  ingestion_type=ingestible_def.ingestion_type,
                                                  ingestion_job_type=self.ingestion_job_type,
                                                  version=version,
                                                  previous_version=previous_version)

    def _generate_change_tracking_join_criteria(self, column_defs):
        """
        :type column_defs: list of dict
        :rtype: str
        """
        self.logger.debug("Generate change tracking join criteria")
        pk_column_defs = QueryUtils.filter_primary_keys(column_defs)
        pk_columns = QueryUtils.escape_column_list(QueryUtils.extract_column_list(pk_column_defs))
        join_criteria = []
        for pk_column in pk_columns:
            qualified_original_pk_column = QueryUtils.qualify_identifier(
                self.ORIGINAL_TABLE_ALIAS, pk_column)
            qualified_ct_pk_column = QueryUtils.qualify_identifier(
                self.CHANGE_TRACKING_TABLE_ALIAS, pk_column)
            join_criteria.append("%s = %s" % (qualified_ct_pk_column, qualified_original_pk_column))
        return " AND ".join(join_criteria)

    def _get_table_alias(self, column_def):
        """

        :type column_def: dict
        :return: str
        """
        if column_def["isMergeMatch"]:
            return self.CHANGE_TRACKING_TABLE_ALIAS
        else:
            return self.ORIGINAL_TABLE_ALIAS

    def _generate_select_query(self, ingestible_def, ingestion_job):
        """
        :type ingestible_def: TableDef
        :type ingestion_job
        :rtype: list of str
        """
        self.logger.debug("Generate select query, Ingestion Job: %s" % ingestion_job)
        if ingestible_def.ingestion_type == IngestionType.INCREMENTAL and \
                self.ingestion_job_type == IngestionJobType.INCREMENTAL:
            if len(ingestible_def.merge_match_buckets) == 0:
                raise Exception(
                    "Incremental ingestion, no merge match col for table: %s" % ingestible_def.table_name)
            else:
                column_defs = ingestible_def.column_definitions

                # original table columns
                column_list = [QueryUtils.qualify_identifier(self._get_table_alias(column_def),
                                                             QueryUtils.escape_identifier(column_def["COLUMN_NAME"]))
                               for column_def in column_defs]

                # CT columns
                # Due to SQL Server issue of Change Tracking view reporting incorrectly Deletes in some cases
                # where it actually should have reported an update, we override the sys_change_operation from 'D' to 'U'
                # when we detect the record still exists in the original table. Follow up ticket NET-24255.
                first_pk_col = QueryUtils.qualify_identifier(self.ORIGINAL_TABLE_ALIAS,
                                                             QueryUtils.escape_identifier(
                                                                 ingestible_def.merge_match_buckets[0]))

                sys_change_operation = self.CT_OPERATION_COL.format(first_pk_col,
                                                                    HiveChangeTracking.CT_COLUMN_OPERATION)

                sys_change_version = QueryUtils.qualify_identifier(self.CHANGE_TRACKING_TABLE_ALIAS,
                                                                     QueryUtils.escape_identifier(
                                                                         HiveChangeTracking.CT_COLUMN_VERSION))

                ct_columns = [sys_change_version, sys_change_operation]

                all_columns = ct_columns + column_list

                if ingestible_def.partition_fields is not None and len(ingestible_def.partition_fields) > 0:
                    all_columns.append(str(ingestion_job.customer_id) + " as " + ingestible_def.partition_fields[0])

                join_criteria = self._generate_change_tracking_join_criteria(column_defs)
                table_name_escaped = QueryUtils.escape_identifier(ingestible_def.table_name)
                ct_version_column_escaped = QueryUtils.escape_identifier(
                    HiveChangeTracking.CT_COLUMN_VERSION)

                return self.INCREMENTAL_CHANGES_QUERY % (
                    ", ".join(all_columns),
                    table_name_escaped,
                    ingestion_job.previous_version,
                    self.CHANGE_TRACKING_TABLE_ALIAS,
                    table_name_escaped,
                    self.ORIGINAL_TABLE_ALIAS,
                    join_criteria,
                    ct_version_column_escaped,
                    ingestion_job.version)
        else:
            select_columns = QueryUtils.escape_column_list(
                QueryUtils.extract_column_list(ingestible_def.column_definitions))

            if ingestible_def.partition_fields is not None and len(ingestible_def.partition_fields) > 0:
                select_columns.append(str(ingestion_job.customer_id) + " as " + ingestible_def.partition_fields[0])
            select_relation = QueryUtils.escape_identifier(ingestible_def.table_name)
            return self.SELECT_QUERY % (", ".join(select_columns), select_relation)


def main(ingestion_group, ingestion_job_type, hdfs_file_path):
    ingestion_group = IngestionGroup.get_ingestion_group(ingestion_group)
    ingestion_job_type = IngestionJobType.get_ingestion_job_type(ingestion_job_type)
    ingester = SparkDbTableIngester(ingestion_group, ingestion_job_type)
    ingestible_lines = cli_utils.read_file_from_hdfs(hdfs_file_path)
    ingestible_confs = []
    for line in ingestible_lines:
        ingestible_confs.append(IngestibleDbTableConf.deserialize(line))
    ingester.ingest(ingestible_confs)


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description="Ingests DB tables from MS SQL into Hive")
    parser.add_argument("ingestion_group", choices=["kareo_analytics", "kmb"])
    parser.add_argument("ingestion_job_type", choices=["full", "incremental"],
                        help="Whether to perform full or incremental ingestion")
    parser.add_argument("hdfs_file_path", help="HDFS File path containing all the dbs to be fully ingested")
    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())