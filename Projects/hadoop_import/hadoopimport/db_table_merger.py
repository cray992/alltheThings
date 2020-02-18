#!/usr/bin/env python

import time
from abc import ABCMeta
from string import Template

from config import Config
from hive_db_manager import HiveDbManager
from hive_schema_manager import HiveChangeTracking, HiveSchemaManager
from ingestion_job_repository import IngestionJobRepository
from ingestion_job_status import IngestionJobStatus
from logging_utils import LoggingUtils
from query_utils import QueryUtils


class MergeConfigProperty:
    NUM_WORKERS = "num_workers"
    BATCH_SIZE = "batch_size"


class MergeableTableConf:
    def __init__(self, target_db_name, table_name, partition_by_field, partition_values, column_names, job_ids,
                 merge_match_fields):
        """
        :type target_db_name: str
        :type table_name: str
        :type partition_by_field: str
        :type partition_values: list of str
        :type column_names: list of str
        :type job_ids: list of int
        :type merge_match_fields: list of str
        """
        self.target_db_name = target_db_name
        self.table_name = table_name
        self.partition_by_field = partition_by_field
        self.partition_values = partition_values
        self.column_names = column_names
        self.job_ids = job_ids
        self.merge_match_fields = merge_match_fields

    def __hash__(self):
        sorted_dict = ', '.join("%s: %s" % item for item in sorted(self.__dict__.items(), key=lambda i: i[0]))
        return hash(sorted_dict)

    def __eq__(self, other):
        return self.__hash__() == other.__hash__()

    def __ne__(self, other):
        return not self.__eq__(other)


class DbTableMerger:
    __metaclass__ = ABCMeta
    """
    Class to merge_batch tables in Hive.
    It processes sequentially a list of tables, as specified by IngestibleDbTableDef objects.
    For each table it uses the ImportTableDefs, for the corresponding DatabaseType.
    """

    def __init__(self):
        self.config = Config()
        self.logger = self.config.get_logger(__package__)
        self.hive_schema_mgr = HiveSchemaManager()
        self.hive_db_mgr = HiveDbManager()
        self.ingestion_job_repo = IngestionJobRepository()

    def _generate_merge_query(self, merge_conf):
        """
        :type merge_conf: MergeableTableConf
        :rtype: str
        """

        target_table = merge_conf.target_db_name + "." + merge_conf.table_name
        target_table_ct = target_table + HiveChangeTracking.TABLE_SUFFIX

        # Insert Fields
        incremental_merge_query = Template("""MERGE INTO $target_table AS H
                                                    USING (${using_statement}) AS CT
                                                    ON ${matched_on_statement}
                                                    WHEN MATCHED AND CT.`${operation_column_name}` IN ('U','I') THEN UPDATE SET
                                                    ${updated_fields}
                                                    WHEN MATCHED AND CT.`${operation_column_name}` = 'D' THEN DELETE
                                                    WHEN NOT MATCHED AND CT.`${operation_column_name}` IN ('U','I') THEN INSERT
                                                    ${insert_fields}
                                                    """)

        using_statement = self._using_statement_for_merge(merge_conf, target_table_ct)

        matched_on_statement = self._on_statement_for_merge(merge_conf)

        # Removing merge match field
        updatable_fields = filter(lambda name: name.lower() not in map(lambda field: field.lower(), merge_conf.merge_match_fields),
                                   merge_conf.column_names) if merge_conf.merge_match_fields else []

        updated_fields = self._updated_fields_for_merge(updatable_fields)

        insert_fields = self._insert_fields(merge_conf)

        # Final Merge Statement
        final_merge_statement = incremental_merge_query.substitute(target_table=target_table,
                                                                   using_statement=using_statement,
                                                                   updated_fields=updated_fields,
                                                                   matched_on_statement=matched_on_statement,
                                                                   insert_fields=insert_fields,
                                                                   operation_column_name=HiveChangeTracking.CT_COLUMN_OPERATION)

        clean_merge_statement = QueryUtils.clean_query(final_merge_statement)

        return clean_merge_statement

    def _insert_fields(self, merge_conf):
        """
        Fields we want to insert into the final table in hive.
        :type merge_conf: MergeableTableConf
        :rtype: str
        """
        insert_fields_ct = QueryUtils.escape_column_list(column_list=merge_conf.column_names, prefix="CT.`", suffix="`")
        insert_fields_ct.append("CT.`%s`" % HiveSchemaManager.MODIFIED_ON_COLUMN)
        insert_fields_ct.append("CT.`%s`" % HiveSchemaManager.INGESTION_JOB_ID_COLUMN)
        if merge_conf.partition_by_field is not None:
            insert_fields_ct.append("CT.`%s`" % merge_conf.partition_by_field)

        insert_fields_str = ", ".join(insert_fields_ct)
        insert_fields = "Values({0})".format(insert_fields_str)

        return insert_fields

    def _updated_fields_for_merge(self, updatable_fields):
        """
        Fields to update during merge
        :type updatable_fields: list of str
        :rtype: str
        """
        # if merge_conf.partition_by_value is not None:
        #    updatable_fields.append(merge_conf.partition_by_field)

        matched_statement = Template('''`${field_name}`=CT.`${field_name}`''')
        matched_field_list = [matched_statement.substitute(field_name=field_name) for field_name in updatable_fields]

        matched_field_list.append(
            "`%s`= CT.`%s`" % (HiveSchemaManager.MODIFIED_ON_COLUMN, HiveSchemaManager.MODIFIED_ON_COLUMN))
        matched_field_list.append(
            "`%s`= CT.`%s`" % (HiveSchemaManager.INGESTION_JOB_ID_COLUMN, HiveSchemaManager.INGESTION_JOB_ID_COLUMN))

        updated_fields = ", ".join(matched_field_list)
        return updated_fields

    def _on_statement_for_merge(self, merge_conf):
        """
        Merge Match Condition
        :type merge_conf: MergeableTableConf
        :rtype: str
        """
        matched_on_statement_list = []
        if merge_conf.merge_match_fields:
            matched_on_statement_list = \
                map(lambda field: Template("H.`${merge_match_field}` = CT.`${merge_match_field}`").substitute(
                    merge_match_field=field), merge_conf.merge_match_fields)

        matched_on_statement = " AND ".join(matched_on_statement_list)

        if merge_conf.partition_by_field:
            # Matched on Statement
            matched_on_statement += Template(
                " ${_and}H.`${partition_by_field}` = CT.`${partition_by_field}`").substitute(
                _and="AND " if matched_on_statement else "",
                partition_by_field=merge_conf.partition_by_field)

        return matched_on_statement

    def _using_statement_for_merge(self, merge_conf, target_table_ct):
        """
        :type merge_conf: MergeableTableConf
        :type target_table_ct: str
        :rtype: str
        """

        # Using Statement
        all_fields = merge_conf.column_names + [
            merge_conf.partition_by_field] if merge_conf.partition_by_field is not None else merge_conf.column_names

        all_fields_ct = all_fields + [HiveChangeTracking.CT_COLUMN_OPERATION]
        field_name_list = ["TOTALCT.`{0}`".format(field) for field in all_fields_ct]

        field_name_list.append("TOTALCT.`%s`" % HiveSchemaManager.MODIFIED_ON_COLUMN)
        field_name_list.append("TOTALCT.`%s`" % HiveSchemaManager.INGESTION_JOB_ID_COLUMN)

        field_names = ", ".join(field_name_list)

        escaped_merge_match_fields = ", ".join(
            QueryUtils.escape_column_list(column_list=merge_conf.merge_match_fields, prefix="`", suffix="`"))

        if merge_conf.partition_by_field:
            using_statement = Template(
                """SELECT * FROM 
                (
                    SELECT ${field_names}, 
                        ROW_NUMBER() OVER (PARTITION BY `${partition_by_field}`, ${merge_match_fields} ORDER BY `${modified_on_column}` DESC) as rowNum
                    FROM ${target_table_ct} AS TOTALCT
                ) as TWRN
                WHERE rowNum=1""").substitute(
                target_table_ct=target_table_ct,
                modified_on_column=HiveSchemaManager.MODIFIED_ON_COLUMN,
                merge_match_fields=escaped_merge_match_fields,
                partition_by_field=merge_conf.partition_by_field,
                field_names=field_names)
        else:
            using_statement = Template(
                """SELECT * FROM 
                (
                    SELECT ${field_names}, 
                        ROW_NUMBER() OVER (PARTITION BY ${merge_match_fields} ORDER BY `${hive_change_version}` DESC) as rowNum
                    FROM ${target_table_ct} AS TOTALCT
                ) as TWRN
                WHERE rowNum=1""").substitute(
                target_table_ct=target_table_ct,
                hive_change_version=HiveChangeTracking.CT_COLUMN_VERSION,
                merge_match_fields=escaped_merge_match_fields,
                field_names=field_names)

        return using_statement

    def _cleanup_ct_table(self, merge_conf):
        """

        :type persistable_table_conf: PersistableTableConf
        :rtype: None
        """
        ct_table = HiveSchemaManager.get_ct_table_name(merge_conf.table_name)
        self.hive_schema_mgr.truncate_table(ct_table, db_name=merge_conf.target_db_name)

    def _merge_table(self, mergeable_table_conf):
        """
        :type mergeable_table_conf: MergeableTableConf
        :rtype: int
        """
        try:

            self.logger.info("Merging Table: " + mergeable_table_conf.table_name)

            start = time.time()

            merge_query = self._generate_merge_query(mergeable_table_conf)
            self.logger.debug("Executing insert query: %s" % merge_query)

            self.hive_db_mgr.execute_query(merge_query, db_name=mergeable_table_conf.target_db_name)

            end = time.time()
            elapsed = LoggingUtils.elapsed_time(start, end)
            self.logger.debug("End merging table: %s, elapsed: %s" % (mergeable_table_conf.table_name, elapsed))
            return IngestionJobStatus.SUCCESS
        except Exception as ex:
            self.logger.error("Failed to persist with query: %s" % merge_query)
            self.logger.exception(ex)
            return IngestionJobStatus.FAIL

    def merge_batch(self, mergeable_table_confs):
        """
        :type mergeable_table_confs: list of MergeableTableConf
        :rtype: None
        """
        for mergeable_table_conf in mergeable_table_confs:

            try:
                self.ingestion_job_repo.update_multiple_started(mergeable_table_conf.job_ids)
                self._merge_table(mergeable_table_conf)
                self._cleanup_ct_table(mergeable_table_conf)
                self.ingestion_job_repo.update_multiple_status(IngestionJobStatus.SUCCESS,
                                                               mergeable_table_conf.job_ids)
            except Exception as ex:
                self.logger.error("Failed to merge")
                self.logger.exception(ex)
                self.ingestion_job_repo.update_multiple_status(IngestionJobStatus.FAIL, mergeable_table_conf.job_ids)
