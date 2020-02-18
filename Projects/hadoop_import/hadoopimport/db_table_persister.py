#!/usr/bin/env python

import time
from abc import ABCMeta
from string import Template

from config import Config
from hive_db_manager import HiveDbManager
from hive_schema_manager import HiveSchemaManager
from ingestion_job_repository import IngestionJobRepository
from ingestion_job_status import IngestionJobStatus
from logging_utils import LoggingUtils
from query_utils import QueryUtils


class PersistConfigProperty:
    NUM_WORKERS = "num_workers"
    BATCH_SIZE = "batch_size"


class PersistableTableConf:
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


class DbTablePersister:
    __metaclass__ = ABCMeta
    """
    Class to persist temp tables to target tables in Hive.
    It processes sequentially a list of tables, as specified by IngestibleDbTableDef objects.
    For each table it uses the ImportTableDefs, for the corresponding DatabaseType.
    """

    def __init__(self):
        self.config = Config()
        self.logger = self.config.get_logger(__package__)
        self.hive_schema_mgr = HiveSchemaManager()
        self.hive_db_mgr = HiveDbManager()
        self.ingestion_job_repo = IngestionJobRepository()

    def _generate_insert_query(self, persistable_conf):
        """

        :type persistable_conf: PersistableTableConf
        :rtype: str
        """
        self.logger.debug("Generate insert query")
        table_name = HiveSchemaManager.qualify_table_name(persistable_conf.table_name, persistable_conf.target_db_name)

        temp_table = HiveSchemaManager.get_temp_table_name(table_name)
        column_list = QueryUtils.escape_column_list(persistable_conf.column_names, prefix="`", suffix="`")

        column_list.append("`%s`" % HiveSchemaManager.MODIFIED_ON_COLUMN)
        column_list.append("`%s`" % HiveSchemaManager.INGESTION_JOB_ID_COLUMN)

        if persistable_conf.partition_by_field is not None:
            partition_part = "PARTITION(%s)" % (persistable_conf.partition_by_field)
            column_list.append("`%s`" % persistable_conf.partition_by_field)
        else:
            partition_part = ""

        if persistable_conf.merge_match_fields:
            escaped_columns = QueryUtils.escape_column_list(column_list=persistable_conf.merge_match_fields, prefix="`", suffix="`")
            distribute_part = "DISTRIBUTE BY %s" % ", ".join(escaped_columns)
        else:
            distribute_part = ""

        select_part = ", ".join(column_list)
        query = "INSERT INTO TABLE %s %s SELECT %s FROM %s %s" % (
            table_name, partition_part, select_part, temp_table, distribute_part)
        return query

    def _cleanup_temp_table(self, persistable_table_conf):
        """

        :type persistable_table_conf: PersistableTableConf
        :rtype: None
        """
        temp_table = HiveSchemaManager.get_temp_table_name(persistable_table_conf.table_name)
        self.hive_schema_mgr.truncate_table(temp_table, db_name=persistable_table_conf.target_db_name)

    def _persist_table(self, persistable_table_conf):
        """
        :type persistable_table_conf: PersistableTableConf
        :rtype: int
        """
        try:
            self.logger.info("Persisting Table: " + persistable_table_conf.table_name)
            start = time.time()

            persist_query = self._generate_insert_query(persistable_table_conf)

            self.logger.debug("Executing insert query: %s" % persist_query)
            self.hive_db_mgr.execute_query(persist_query, db_name=persistable_table_conf.target_db_name)

            end = time.time()
            elapsed = LoggingUtils.elapsed_time(start, end)
            self.logger.debug("End persisting table: %s, elapsed: %s" % (persistable_table_conf.table_name, elapsed))
            return IngestionJobStatus.SUCCESS
        except Exception as ex:
            self.logger.error("Failed to persist with query: %s" % persist_query)
            self.logger.exception(ex)
            return IngestionJobStatus.FAIL

    def persist_batch(self, persistable_table_confs):
        """
        :type persistable_table_confs: list of PersistableTableConf
        :rtype: None
        """
        for persistable_table_conf in persistable_table_confs:

            try:
                self.ingestion_job_repo.update_multiple_started(persistable_table_conf.job_ids)
                self._persist_table(persistable_table_conf)
                self._cleanup_temp_table(persistable_table_conf)
                self.ingestion_job_repo.update_multiple_status(IngestionJobStatus.SUCCESS,
                                                               persistable_table_conf.job_ids)
            except Exception as ex:
                self.logger.error("Failed to persit")
                self.logger.exception(ex)
                self.ingestion_job_repo.update_multiple_status(IngestionJobStatus.FAIL, persistable_table_conf.job_ids)
