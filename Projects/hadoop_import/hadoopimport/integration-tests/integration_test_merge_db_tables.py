#!/usr/bin/env python

"""
Test for cli_utils
"""
import unittest

import bin.merge_db_tables as merge_db_tables
from hadoopimport.db_import_definitions import DatabaseType
from hadoopimport.mssql_db_manager import MsSqlDbManager, MsSqlDbName
from hadoopimport.hive_db_manager import HiveDbManager
from hadoopimport.hive_schema_manager import HiveSchemaManager
from hadoopimport.ingestion_job_repository import IngestionJobRepository
from hadoopimport.ingestion_type import IngestionType
from hadoopimport.ingestion_job_status import IngestionJobStatus
from hadoopimport.ingestion_job_type import IngestionJobType
from hadoopimport.table_def import TableDef
from hadoopimport.tests.base_test_case import BaseTestCase


class TestSparkDBTableMerger(BaseTestCase):
    hive_schema_manager = HiveSchemaManager()

    TEST_TABLE_NAME = "PaymentType"
    TEST_CT_TABLE_NAME = "PaymentType_ct"
    TEST_DB_NAME = "customer_ka"

    def setUp(self):
        print("##### SETTING UP #####")

        payment_type_columns = self.build_column_definitions(table_name=self.TEST_TABLE_NAME,
                                                             partition_fields=["partitioncustomerid"],
                                                             merge_match_buckets=["paymenttypeid"],
                                                             column_list=["description", "name", "payertypecode",
                                                                          "paymenttypeid", "sortorder"],
                                                             data_types=["string", "string", "string", "int", "int"])

        paymenttype_table_def = TableDef(column_definitions=payment_type_columns, table_name=self.TEST_TABLE_NAME,
                                         merge_match_buckets=["paymenttypeid"],
                                         partition_fields=["partitioncustomerid"], num_buckets=20,
                                         ingestion_type=IngestionType.FULL)

        self.create_table_query = self.hive_schema_manager._generate_create_table_query(table_name=self.TEST_TABLE_NAME,
                                                                                        table_def=paymenttype_table_def)
        self.create_table_query_ct = self.hive_schema_manager._generate_create_table_query(table_name=self.TEST_CT_TABLE_NAME,
                                                                                           table_def=paymenttype_table_def,
                                                                                           ct_table=True)

        self.insert_initial = """INSERT INTO {0} partition(partitioncustomerid = 10590)
        (description, name, payertypecode, paymenttypeid, sortorder) Values
        ("test description", "test name", "test payer type code", 1, 1),
        ("test description", "test name", "test payer type code", 2, 1)""".format(self.TEST_TABLE_NAME)
        self.mssql_db_mgr = MsSqlDbManager(db_name=MsSqlDbName.APPLICATION_METADATA)
        self.hive_db_mgr = HiveDbManager(db_name=TestSparkDBTableMerger.TEST_DB_NAME)
        self.ingestion_job_repo = IngestionJobRepository()

        self.initialize_dbs()

    def initialize_dbs(self):

        print("##### INITIALIZING DBS #####")

        self.reset_test_tables()
        self.hive_schema_manager.create_database_if_not_exists(self.TEST_DB_NAME)
        set_up_queries = ";".join([self.create_table_query,
                                   self.create_table_query_ct,
                                   self.insert_initial])
        self.hive_db_mgr.execute_script(set_up_queries)

        self.reset_all_jobs()
        test_job_a = self.ingestion_job_repo.create_job(customer_id=10590,
                                                        db_type=DatabaseType.CUSTOMER,
                                                        db_name=self.TEST_DB_NAME,
                                                        table_name=self.TEST_TABLE_NAME,
                                                        ingestion_type=IngestionType.INCREMENTAL,
                                                        ingestion_job_type=IngestionJobType.INCREMENTAL)
        self.ingestion_job_repo.update_status(IngestionJobStatus.SUCCESS, test_job_a.ingestion_job_id)

    def reset_all_jobs(self):
        try:
            self.mssql_db_mgr.execute_query(
                "DELETE FROM HDP_IngestionJob WHERE DbName = '{0}'".format(self.TEST_DB_NAME))
        except Exception as ex:
            print("Job Table Clean")

    def reset_test_tables(self):
        try:
            self.hive_schema_manager.remove_table(table_name=self.TEST_TABLE_NAME, db_name=self.TEST_DB_NAME)
            self.hive_schema_manager.remove_table(table_name=self.TEST_TABLE_NAME, db_name=self.TEST_CT_TABLE_NAME)

        except Exception as e:
            print("no tables to remove" + str(e))

    def test_merge_insert(self):

        print("##### TESTING MERGE INSERT #####")

        # When
        insert_ct = """INSERT INTO {0} partition(partitioncustomerid = 10590)
        (sys_change_version, sys_change_operation, description, name, payertypecode, paymenttypeid, sortorder) Values
        (3, "I", "my description 3", "name_3", "payer type code 3", 3, 1)""".format(self.TEST_CT_TABLE_NAME)
        self.hive_db_mgr.execute_query(insert_ct)

        merge_db_tables.main("kareo_analytics")

        # Then
        returned_data = self.hive_db_mgr.execute_query(
            "select * from {0}.{1}".format(self.TEST_DB_NAME, self.TEST_TABLE_NAME))
        self.assertEqual(["test description", "test name", "test payer type code", 1, 1, 10590], list(returned_data[0]))
        self.assertEqual(["test description", "test name", "test payer type code", 2, 1, 10590], list(returned_data[1]))
        self.assertEqual(['my description 3', 'name_3', 'payer type code 3', 3, 1, 10590], list(returned_data[2]))
        self.assertEqual(3, len(returned_data))

        # check to see jobs updated successfully
        returned_job = self.ingestion_job_repo.get_last_job(db_name=self.TEST_DB_NAME, table_name=self.TEST_TABLE_NAME)
        self.assertEqual(IngestionJobStatus.SUCCESS, returned_job.status)
        self.assertEqual(self.TEST_TABLE_NAME, returned_job.table_name)

    def test_merge_delete(self):

        print("##### TESTING MERGE DELETE #####")

        # Given
        delete_query = """INSERT INTO {0} partition(partitioncustomerid = 10590) 
        (sys_change_version, sys_change_operation, description, name, payertypecode, paymenttypeid, sortorder) 
        Values(4, "D", NULL, NULL, NULL, 1, NULL)""".format(self.TEST_CT_TABLE_NAME)
        self.hive_db_mgr.execute_query(delete_query)

        # When
        merge_db_tables.main("kareo_analytics")

        # Then
        returned_data = self.hive_db_mgr.execute_query(
            "select * from {0}.{1}".format(self.TEST_DB_NAME, self.TEST_TABLE_NAME))

        self.assertEqual(["test description", "test name", "test payer type code", 2, 1, 10590], list(returned_data[0]))
        self.assertEqual(1, len(returned_data))

        # check to see jobs updated successfully
        returned_job = self.ingestion_job_repo.get_last_job(db_name=self.TEST_DB_NAME, table_name=self.TEST_TABLE_NAME)
        self.assertEqual(IngestionJobStatus.SUCCESS, returned_job.status)
        self.assertEqual(self.TEST_TABLE_NAME, returned_job.table_name)

    def test_merge_update(self):

        print("##### TESTING MERGE UPDATE #####")

        # Given
        update_query = """INSERT INTO {0} partition(partitioncustomerid = 10590)
         (sys_change_version, sys_change_operation, description, name, payertypecode, paymenttypeid, sortorder)
         Values(4, "U", "my description 11", "name_11", "payer type code 11", 1, 1)""".format(self.TEST_CT_TABLE_NAME)
        self.hive_db_mgr.execute_query(update_query)

        # When
        merge_db_tables.main("kareo_analytics")

        # Then
        returned_data = self.hive_db_mgr.execute_query("select * from {0}.{1}".format(self.TEST_DB_NAME, self.TEST_TABLE_NAME))
        self.assertEqual(['my description 11', 'name_11', 'payer type code 11', 1, 1, 10590], list(returned_data[0]))
        self.assertEqual(["test description", "test name", "test payer type code", 2, 1, 10590], list(returned_data[1]))
        self.assertEqual(2, len(returned_data))

        # check to see jobs updated successfully
        returned_job = self.ingestion_job_repo.get_last_job(db_name=self.TEST_DB_NAME, table_name=self.TEST_TABLE_NAME)
        self.assertEqual(IngestionJobStatus.SUCCESS, returned_job.status)
        self.assertEqual(self.TEST_TABLE_NAME, returned_job.table_name)

    def tearDown(self):
        self.reset_test_tables()
        self.reset_all_jobs()


if __name__ == '__main__':
    unittest.main()
