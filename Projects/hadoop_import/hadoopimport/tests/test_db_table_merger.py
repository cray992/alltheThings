# !/usr/bin/env python
"""
Test for cli_utils
"""

from hadoopimport.db_table_merger import DbTableMerger, MergeableTableConf
from hadoopimport.tests.base_test_case import BaseTestCase
import re

class TestSparkDBTableMerger(BaseTestCase):
    def setUp(self):
        # Class attributes
        self.mock_config = self.get_mock("hadoopimport.db_table_merger.Config")
        self.mock_hive_schema_mgr_class = self.get_mock_class("hadoopimport.db_table_merger.HiveSchemaManager")
        self.mock_hive_schema_mgr_class.MODIFIED_ON_COLUMN = "_ModifiedOn"
        self.mock_hive_schema_mgr_class.INGESTION_JOB_ID_COLUMN = "_IngestionJobId"

        self.mock_hive_schema_mgr = self.mock_hive_schema_mgr_class.return_value
        self.mock_hive_db_mgr = self.get_mock("hadoopimport.db_table_merger.HiveDbManager")

        self.mock_ingestion_job_repository = self.get_mock("hadoopimport.db_table_merger.IngestionJobRepository")

    def test_generate_merge_query(self):
        spark_db_table_merger = DbTableMerger()
        test_merge_conf = MergeableTableConf(target_db_name = "target_db_name", table_name = "customer_partitioned", partition_by_field = "partitioncustomerid", partition_values = [1, 2], column_names = ["name","email","state"], job_ids = [3,4], merge_match_fields = ["merge_match_field"])
        expected_query = "MERGE INTO target_db_name.customer_partitioned AS H USING (SELECT * FROM ( SELECT TOTALCT.`name`, TOTALCT.`email`, TOTALCT.`state`, TOTALCT.`partitioncustomerid`, TOTALCT.`sys_change_operation`, TOTALCT.`_ModifiedOn`, TOTALCT.`_IngestionJobId`, ROW_NUMBER() OVER (PARTITION BY `partitioncustomerid`, `merge_match_field` ORDER BY `_ModifiedOn` DESC) as rowNum FROM target_db_name.customer_partitioned_ct AS TOTALCT ) as TWRN WHERE rowNum=1) AS CT ON H.`merge_match_field` = CT.`merge_match_field` AND H.`partitioncustomerid` = CT.`partitioncustomerid` WHEN MATCHED AND CT.`sys_change_operation` IN ('U','I') THEN UPDATE SET `name`=CT.`name`, `email`=CT.`email`, `state`=CT.`state`, `_ModifiedOn`= CT.`_ModifiedOn`, `_IngestionJobId`= CT.`_IngestionJobId` WHEN MATCHED AND CT.`sys_change_operation` = 'D' THEN DELETE WHEN NOT MATCHED AND CT.`sys_change_operation` IN ('U','I') THEN INSERT Values(CT.`name`, CT.`email`, CT.`state`, CT.`_ModifiedOn`, CT.`_IngestionJobId`, CT.`partitioncustomerid`)"
        merge_query = spark_db_table_merger._generate_merge_query(test_merge_conf)
        self.assertEqual(expected_query, merge_query)
        pass

    def test_generate_merge_query_many_match_fields(self):
        spark_db_table_merger = DbTableMerger()
        test_merge_conf = MergeableTableConf(target_db_name = "target_db_name", table_name = "customer_partitioned", partition_by_field = "partitioncustomerid", partition_values = [1, 2], column_names = ["name","email","state"], job_ids = [3,4], merge_match_fields = ["merge_match_field_1","merge_match_field_2","merge_match_field_3"])
        expected_query = "MERGE INTO target_db_name.customer_partitioned AS H USING (SELECT * FROM ( SELECT TOTALCT.`name`, TOTALCT.`email`, TOTALCT.`state`, TOTALCT.`partitioncustomerid`, TOTALCT.`sys_change_operation`, TOTALCT.`_ModifiedOn`, TOTALCT.`_IngestionJobId`, ROW_NUMBER() OVER (PARTITION BY `partitioncustomerid`, `merge_match_field_1`, `merge_match_field_2`, `merge_match_field_3` ORDER BY `_ModifiedOn` DESC) as rowNum FROM target_db_name.customer_partitioned_ct AS TOTALCT ) as TWRN WHERE rowNum=1) AS CT ON H.`merge_match_field_1` = CT.`merge_match_field_1` AND H.`merge_match_field_2` = CT.`merge_match_field_2` AND H.`merge_match_field_3` = CT.`merge_match_field_3` AND H.`partitioncustomerid` = CT.`partitioncustomerid` WHEN MATCHED AND CT.`sys_change_operation` IN ('U','I') THEN UPDATE SET `name`=CT.`name`, `email`=CT.`email`, `state`=CT.`state`, `_ModifiedOn`= CT.`_ModifiedOn`, `_IngestionJobId`= CT.`_IngestionJobId` WHEN MATCHED AND CT.`sys_change_operation` = 'D' THEN DELETE WHEN NOT MATCHED AND CT.`sys_change_operation` IN ('U','I') THEN INSERT Values(CT.`name`, CT.`email`, CT.`state`, CT.`_ModifiedOn`, CT.`_IngestionJobId`, CT.`partitioncustomerid`)"
        merge_query = spark_db_table_merger._generate_merge_query(test_merge_conf)
        self.assertEqual(expected_query, merge_query)
        pass

    def test_generate_merge_query_dont_update_merge_fields(self):
        spark_db_table_merger = DbTableMerger()
        test_merge_conf = MergeableTableConf(target_db_name = "target_db_name", table_name = "customer_partitioned", partition_by_field = "partitioncustomerid", partition_values = [1, 2], column_names = ["name","email","state"], job_ids = [3,4], merge_match_fields = ["merge_match_field_1","merge_match_field_2","merge_match_field_3"])
        merge_query = spark_db_table_merger._generate_merge_query(test_merge_conf)
        update_statement = re.search('UPDATE SET(.*)THEN DELETE', merge_query)
        self.assertIsNotNone(update_statement.group(1))
        self.assertNotIn("merge_match_field_1", update_statement.group(1))
        self.assertNotIn("merge_match_field_2", update_statement.group(1))
        self.assertNotIn("merge_match_field_3", update_statement.group(1))
        pass


