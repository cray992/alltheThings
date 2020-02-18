# !/usr/bin/env python
"""
Test for cli_utils
"""

from hadoopimport.db_table_persister import DbTablePersister, PersistableTableConf
from hadoopimport.hive_schema_manager import HiveSchemaManager, HiveChangeTracking
from hadoopimport.query_utils import QueryUtils
from hadoopimport.tests.base_test_case import BaseTestCase


class TestSparkDBTablePersister(BaseTestCase):

    def setUp(self):
        # Class attributes
        self.mock_config = self.get_mock("hadoopimport.db_table_persister.Config")
        self.mock_hive_schema_mgr_class = self.get_mock_class("hadoopimport.db_table_persister.HiveSchemaManager")
        self.mock_hive_schema_mgr_class.MODIFIED_ON_COLUMN = "_ModifiedOn"
        self.mock_hive_schema_mgr_class.INGESTION_JOB_ID_COLUMN = "_IngestionJobId"
        self.mock_hive_schema_mgr = self.mock_hive_schema_mgr_class.return_value
        self.mock_hive_schema_mgr_class.qualify_table_name.side_effect = lambda table_name, db_name: "%s.%s" % (db_name, table_name)
        self.mock_hive_schema_mgr_class.get_temp_table_name.side_effect = lambda table_name: table_name + HiveChangeTracking.TEMP_SUFFIX

        self.mock_hive_db_mgr = self.get_mock("hadoopimport.db_table_persister.HiveDbManager")
        self.mock_ingestion_job_repo = self.get_mock("hadoopimport.db_table_persister.IngestionJobRepository")

        # Default DTOs
        self.persistable_conf = PersistableTableConf(target_db_name="target_db_name", table_name="customer_partitioned",
                                                     partition_by_field="signup", partition_values=[1, 2],
                                                     column_names=["name", "email", "state"], job_ids=[4, 5],
                                                     merge_match_fields=["merge_match_field"])

        self.persis_conf_many_merge_fields = PersistableTableConf(target_db_name="target_db_name",
                                                                  table_name="customer_partitioned",
                                                                  partition_by_field="signup", partition_values=[1, 2],
                                                                  column_names=["name", "email", "state"],
                                                                  job_ids=[4, 5],
                                                                  merge_match_fields=["merge_match_field_1",
                                                                                      "merge_match_field_2",
                                                                                      "merge_match_field_3"])

        self.persis_conf_no_merge_fields = PersistableTableConf(target_db_name="target_db_name",
                                                                  table_name="customer_partitioned",
                                                                  partition_by_field="signup", partition_values=[1, 2],
                                                                  column_names=["name", "email", "state"],
                                                                  job_ids=[4, 5],
                                                                  merge_match_fields=None)

        # Instance to test
        self.db_table_persister = DbTablePersister()

    def test_generate_persist_query(self):
        # Given
        target_table = HiveSchemaManager.qualify_table_name(self.persistable_conf.table_name,
                                                            self.persistable_conf.target_db_name).upper()
        temp_table = HiveSchemaManager.get_temp_table_name(target_table).upper()

        merge_match_field = ",".join(self.persistable_conf.merge_match_fields).upper()

        # When
        self.db_table_persister.persist_batch([self.persistable_conf])

        # Then
        hive_queries = map(lambda call: call[0][0].upper(), self.mock_hive_db_mgr.execute_query.call_args_list)
        self.assertEquals(len(hive_queries), 1)
        first_query = hive_queries[0].upper()
        self.assertIn("INSERT INTO TABLE %s" % target_table, first_query)
        self.assertIn("FROM %s" % temp_table, first_query)
        self.assertIn("DISTRIBUTE BY `%s`" % merge_match_field, first_query)

    def test_generate_persist_query_many_merge_fields(self):
        # Given
        target_table = HiveSchemaManager.qualify_table_name(self.persis_conf_many_merge_fields.table_name,
                                                            self.persis_conf_many_merge_fields.target_db_name).upper()
        temp_table = HiveSchemaManager.get_temp_table_name(target_table).upper()

        merge_match_field = ", ".join(
            QueryUtils.escape_column_list(column_list=self.persis_conf_many_merge_fields.merge_match_fields, prefix="`",
                                          suffix="`")).upper()

        # When
        self.db_table_persister.persist_batch([self.persis_conf_many_merge_fields])

        # Then
        hive_queries = map(lambda call: call[0][0].upper(), self.mock_hive_db_mgr.execute_query.call_args_list)
        self.assertEquals(len(hive_queries), 1)
        first_query = hive_queries[0].upper()
        self.assertIn("INSERT INTO TABLE %s" % target_table, first_query)
        self.assertIn("FROM %s" % temp_table, first_query)
        self.assertIn("DISTRIBUTE BY %s" % merge_match_field, first_query)


    def test_generate_persist_query_no_merge_fields(self):
        # Given
        target_table = HiveSchemaManager.qualify_table_name(self.persis_conf_no_merge_fields.table_name,
                                                            self.persis_conf_no_merge_fields.target_db_name).upper()
        temp_table = HiveSchemaManager.get_temp_table_name(target_table).upper()

        # When
        self.db_table_persister.persist_batch([self.persis_conf_no_merge_fields])

        # Then
        hive_queries = map(lambda call: call[0][0].upper(), self.mock_hive_db_mgr.execute_query.call_args_list)
        self.assertEquals(len(hive_queries), 1)
        first_query = hive_queries[0].upper()
        self.assertIn("INSERT INTO TABLE %s" % target_table, first_query)
        self.assertIn("FROM %s" % temp_table, first_query)
        self.assertNotIn("DISTRIBUTE BY", first_query)

