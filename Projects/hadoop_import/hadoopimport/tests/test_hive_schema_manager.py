from base_test_case import BaseTestCase
from table_def_builder import TableDefBuilder

from hadoopimport.hive_schema_manager import HiveSchemaManager, TableDoesNotExistException, TableAlreadyExistsException
from hadoopimport.ingestion_type import IngestionType


class HiveSchemaManagerTest(BaseTestCase):

    def setUp(self):
        self.mock_config = self.get_mock("hadoopimport.hive_schema_manager.Config", autospec=False)
        self.mock_hive_db_mgr = self.get_mock("hadoopimport.hive_schema_manager.HiveDbManager")
        self.mock_db_cursor = self.mock_hive_db_mgr.get_db_cursor().__enter__()

    def test_drop_partition(self):
        # Given
        mock_hive_cursor = self.mock_hive_db_mgr.get_db_cursor().__enter__()
        mock_hive_cursor.table_exists.return_value = True
        hive_schema_manager = HiveSchemaManager()
        test_table = "test.test_table"
        partition_pairs = [("partitioncustomer_id", 123)]

        # When
        hive_schema_manager.drop_partition(test_table, partition_pairs)

        # Then
        hive_queries = map(lambda call: call[0][0].upper(), self.mock_db_cursor.execute.call_args_list)
        self.assertEquals(len(hive_queries), 1)
        first_query = hive_queries[0].upper()
        self.assertIn("ALTER TABLE", first_query)
        self.assertIn("%s" % test_table.upper(), first_query)
        self.assertIn("DROP IF EXISTS PARTITION", first_query)
        self.assertIn("(%s=%s)" % (partition_pairs[0][0].upper(), partition_pairs[0][1]), first_query)

    def test_remove_table(self):
        # Given
        mock_hive_cursor = self.mock_hive_db_mgr.get_db_cursor().__enter__()
        mock_hive_cursor.table_exists.return_value = True
        hive_schema_manager = HiveSchemaManager()
        test_table = "test.test_table"

        # When
        hive_schema_manager.remove_table(test_table)

        # Then
        self.assertTrue(2, mock_hive_cursor.execute.call_count)

    def test_remove_non_existent_table(self):
        # Given
        mock_hive_cursor = self.mock_hive_db_mgr.get_db_cursor().__enter__()
        mock_hive_cursor.table_exists.return_value = False
        hive_schema_manager = HiveSchemaManager()
        test_table = "test.test_table"

        # Then
        self.assertRaises(TableDoesNotExistException, hive_schema_manager.remove_table, test_table)

    def test_create_existent_table(self):
        # Given
        mock_hive_cursor = self.mock_hive_db_mgr.get_db_cursor().__enter__()
        mock_hive_cursor.table_exists.return_value = True
        hive_schema_manager = HiveSchemaManager()
        test_table = "test.test_table"

        # Then
        self.assertRaises(TableAlreadyExistsException,
                          hive_schema_manager.create_table,
                          test_table, TableDefBuilder().build())

    def test_create_tables_for_incremental(self):
        # Given
        mock_hive_cursor = self.mock_hive_db_mgr.get_db_cursor().__enter__()
        mock_hive_cursor.table_exists.return_value = False
        test_table = "test.test_table"
        merge_match_buckets=["col1"]

        hive_schema_manager = HiveSchemaManager()
        hive_schema_manager.create_table(test_table, TableDefBuilder()
                                         .with_ingestion_type(IngestionType.INCREMENTAL)
                                         .with_merge_match_buckets(merge_match_buckets).build())

        self.assertEquals(3, mock_hive_cursor.execute.call_count)
        call_args = map(lambda call_args: call_args[0][0].lower(), mock_hive_cursor.execute.call_args_list)
        ct_table_args = filter(lambda query: "_ct" in query, call_args)
        temp_table_args = filter(lambda query: "_temp" in query, call_args)
        target_table_args = filter(lambda query: "_ct" not in query and "_temp" not in query, call_args)

        self.assertEquals(1, len(ct_table_args))
        self.assertEquals(1, len(temp_table_args))
        self.assertEquals(1, len(target_table_args))

        self.assertIn("cluster", target_table_args[0])
        self.assertNotIn("cluster", ct_table_args[0])
        self.assertNotIn("cluster", temp_table_args[0])

        self.assertIn("transactional", target_table_args[0])
        self.assertNotIn("transactional", ct_table_args[0])
        self.assertNotIn("transactional", temp_table_args[0])

        self.assertEquals(3, mock_hive_cursor.execute.call_count)

    def test_create_table_for_full(self):
        # Given
        mock_hive_cursor = self.mock_hive_db_mgr.get_db_cursor().__enter__()
        mock_hive_cursor.table_exists.return_value = False
        test_table = "test.test_table"

        hive_schema_manager = HiveSchemaManager()
        hive_schema_manager.create_table(test_table,
                                         TableDefBuilder().with_ingestion_type(IngestionType.FULL).build())

        self.assertEquals(2, mock_hive_cursor.execute.call_count)

