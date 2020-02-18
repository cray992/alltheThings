import unittest

from hadoopimport.database_type import DatabaseType
from hadoopimport.db_import_definitions import DbImportDefinition
from hadoopimport.tests.base_test_case import BaseTestCase


class TestDBImportDefinitions(BaseTestCase):
    def setUp(self):
        # Class attributes
        self.mock_config = self.get_mock("hadoopimport.db_import_definitions.Config")
        self.mock_db_mgr = self.get_mock("hadoopimport.db_import_definitions.DbManager")

    def test_load_db_definition(self):
        # Given
        self.mock_db_mgr.execute_query_with_connection.return_value = [{"TABLE_NAME": "TableName",
                                                                       "COLUMN_NAME": "ColumnName",
                                                                       "DATA_TYPE": "varhar",
                                                                       "CHARACTER_MAXIMUM_LENGTH": 255,
                                                                       "NUMERIC_PRECISION": 0,
                                                                       "NUMERIC_SCALE": 0,
                                                                       "isMergeMatch": 0,
                                                                       "isPartition": 0}]

        test_import_definition = DbImportDefinition(DatabaseType.CUSTOMER)
        test_import_definition.load_db_definition()

        table_defs = test_import_definition.get_db_definition().items()
        authorization_name, import_table = table_defs[0]  # type: ImportTableDef
        self.assertIsNotNone(authorization_name)
        self.assertEqual(import_table.partition_fields, ['partitioncustomerid'])
        self.assertIsNotNone(import_table.merge_match_buckets)
        self.assertIsNotNone(import_table.column_definitions[0]['COLUMN_NAME'])


if __name__ == '__main__':
    unittest.main()
