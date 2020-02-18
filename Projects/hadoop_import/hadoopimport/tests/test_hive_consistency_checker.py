from base_test_case import BaseTestCase

from hadoopimport.hive_consistency_checker import HiveConsistencyChecker
from hadoopimport.database_type import DatabaseType


class HiveConsistencyCheckerTest(BaseTestCase):

    def setUp(self):
        self.mock_hive_db_mgr = self.get_mock("hadoopimport.hive_consistency_checker.HiveDbManager")
        self.mock_db_cursor = self.mock_hive_db_mgr.get_db_cursor().__enter__()
        self.mock_db_def_repo = self.get_mock("hadoopimport.hive_consistency_checker.DbDefinitionRepository")

    def test_unused_table_generation(self):
        # Given
        tables = [('', 'Test', 'Table1', 'TABLE', None),
                  ('', 'Test', 'Table2', 'TABLE', None),
                  ('', 'Test', 'Table3', 'TABLE', None)]
        # Patch
        self.mock_db_cursor.fetchall.return_value = tables

        self.mock_db_def_repo.get_staged_db_definition.return_value = {"table1": {}, "tAblE2": {}}

        # Then
        hive_consistency_checker = HiveConsistencyChecker("Test", DatabaseType.CUSTOMER)

        unused_tables = hive_consistency_checker.get_unused_tables()
        unused_table_qualified_name = "Test.table3"

        self.assertIsNotNone(unused_tables)
        self.assertEqual(1, len(unused_tables))
        self.assertIn(unused_table_qualified_name, unused_tables)

    def test_new_table_generation(self):
        # Given
        db_name = "Test"
        tables = [('', 'Test', 'Table1', 'TABLE', None),
                  ('', 'Test', 'Table2', 'TABLE', None),
                  ('', 'Test', 'Table3', 'TABLE', None)]
        # Patch
        self.mock_db_cursor.fetchall.return_value = tables
        self.mock_db_def_repo.get_staged_db_definition.return_value = {"table1": {}, "tAblE4": {}}

        # Then
        hive_consistency_checker = HiveConsistencyChecker(db_name, DatabaseType.CUSTOMER);

        new_tables = hive_consistency_checker.get_new_tables()
        new_table_qualified_name = "Test.table4"

        self.mock_db_cursor.get_tables.assert_called_once_with(db_name)
        self.assertIsNotNone(new_tables)
        self.assertEqual(1, len(new_tables))
        self.assertIsNotNone(new_tables[new_table_qualified_name])

    def test_inconsistent_table_generation(self):
        # Given

        # When
        self.mock_db_def_repo.get_staged_db_definition.return_value = {"tAblE1": {},
                                                                       "Table2": {},
                                                                       "table3": {}}

        self.mock_db_def_repo.get_tables_with_staged_changes.return_value = ["TABLE1", "table3"]

        # Then
        hive_consistency_checker = HiveConsistencyChecker("Test", DatabaseType.CUSTOMER)

        inconsistent_tables = hive_consistency_checker.get_inconsistent_tables()
        inconsistent_table1_name = "Test.table1"
        inconsistent_table3_name = "Test.table3"

        self.assertIsNotNone(inconsistent_tables)
        self.assertEqual(2, len(inconsistent_tables))
        self.assertIn(inconsistent_table1_name, inconsistent_tables)
        self.assertIn(inconsistent_table3_name, inconsistent_tables)
