import random
import sys
from mock import ANY, patch, MagicMock
sys.modules['hadoopimport.config'] = MagicMock()
from hadoopimport.database_type import DatabaseType
from hadoopimport.db_categorizer import DbCategorizer
from hadoopimport.ingestible_db_table_conf import IngestibleDbTableConf
from hadoopimport.ingestion_group import IngestionGroup
from hadoopimport.tests.base_test_case import BaseTestCase

patch.object = patch.object


class DbCategorizerTest(BaseTestCase):
    def mock_db_categories(self):
        return {1: self.build_db_category(db_category_id=1, min_table_size_mb=0, max_table_size_mb=10),
                2: self.build_db_category(db_category_id=2, min_table_size_mb=10, max_table_size_mb=100)}

    def setUp(self):
        self.ingestion_group = IngestionGroup.KA
        self.db_type = DatabaseType.CUSTOMER
        self.ingestible_def = self.build_ingestible_def()
        self.ingestible_conf = self.build_ingestible_db_table_conf()

        # Classes / attributes to mock
        self.mock_config = self.get_mock("hadoopimport.db_categorizer.Config")
        self.mock_ingestible_db_conf_repo = self.get_mock(
            "hadoopimport.db_categorizer.IngestibleDbConfRepository")
        self.mock_ingestible_db_conf_repo.get_ingestible_db_types.return_value = [self.db_type]
        self.mock_logger = self.get_mock("logging.Logger")
        self.mock_mssql_db_mgr = self.get_mock("hadoopimport.db_categorizer.MsSqlDbManager")
        self.mock_db_category_repo = self.get_mock("hadoopimport.db_categorizer.DbCategoryRepository")
        self.mock_db_category_repo.get_all_db_categories.return_value = self.mock_db_categories()

        self.mock_db_definition_repo = self.get_mock("hadoopimport.db_categorizer.DbDefinitionRepository")
        self.mock_db_definition_repo.get_db_definition.return_value = {
            self.ingestible_def.table_name: self.ingestible_def}

        # Instance to test
        self.categorizer = DbCategorizer(self.ingestion_group)

    def test_get_fixed_length_column_size_bytes(self):
        # Given
        fixed_size_data_types = DbCategorizer.FIXED_LENGTH_COLUMN_SIZE_BYTES.keys()
        data_type = fixed_size_data_types[random.randint(0, len(fixed_size_data_types) - 1)]

        # Then
        got_byte_size = DbCategorizer._get_fixed_length_column_size_bytes(data_type)

        # When
        self.assertEquals(got_byte_size, DbCategorizer.FIXED_LENGTH_COLUMN_SIZE_BYTES[data_type])

    def test_get_decimal_column_size_bytes(self):
        # Given
        decimal_data_types = ["decimal", "numeric"]
        data_type = decimal_data_types[random.randint(0, 1)]
        precisions = [1, 9, 10, 19, 20, 28, 29, 38]

        # When
        got_byte_sizes = [DbCategorizer._get_precision_based_column_size_bytes(data_type, precision)
                          for precision in precisions]

        # Then
        self.assertEquals(got_byte_sizes, [5, 5, 9, 9, 13, 13, 17, 17])

    def test_get_float_column_size_bytes(self):
        # Given
        decimal_data_types = ["float", "real"]
        data_type = decimal_data_types[random.randint(0, 1)]
        precisions = [1, 24, 25, 53]

        # When
        got_byte_sizes = [DbCategorizer._get_precision_based_column_size_bytes(data_type, precision)
                          for precision in precisions]

        # Then
        self.assertEquals(got_byte_sizes, [4, 4, 8, 8])

    def test_get_decimal_column_size_bytes_invalid_precision(self):
        # Given
        decimal_data_types = ["decimal", "numeric"]
        data_type = decimal_data_types[random.randint(0, 1)]
        precisions = [-1, 0, 39]

        # When / Then
        for precision in precisions:
            with self.assertRaises(ValueError):
                DbCategorizer._get_precision_based_column_size_bytes(data_type, precision)

    def test_get_float_column_size_bytes_invalid_precision(self):
        # Given
        decimal_data_types = ["float", "real"]
        data_type = decimal_data_types[random.randint(0, 1)]
        precisions = [-1, 0, 54]

        # When / Then
        for precision in precisions:
            with self.assertRaises(ValueError):
                DbCategorizer._get_precision_based_column_size_bytes(data_type, precision)

    def test_get_custom_length_column_size_bytes(self):
        # Given
        max_length = DbCategorizer.MAX_ESTIMATED_CUSTOM_LENGTH_COLUMN_SIZE_BYTES
        lengths = [1, max_length - 1, max_length, max_length + 1]

        # When
        got_byte_sizes = [DbCategorizer._get_custom_length_column_size_bytes(length) for length in lengths]

        # Then
        self.assertListEqual(got_byte_sizes, [1, max_length - 1, max_length, max_length])

    def test_get_custom_length_size_bytes_invalid_length(self):
        # Given
        length = -1

        # When
        got_byte_size = DbCategorizer._get_custom_length_column_size_bytes(length)

        # Then
        self.assertEquals(got_byte_size, DbCategorizer.DEFAULT_COLUMN_SIZE_BYTES)

    def test_get_column_def_size_fixed_length(self):
        # Given
        column_def = {"DATA_TYPE": "int"}

        # When
        got_byte_size = DbCategorizer._get_column_def_size_bytes(column_def)

        # Then
        self.assertEquals(got_byte_size, 4)

    def test_get_column_def_size_precision_based(self):
        # Given
        column_def = {"DATA_TYPE": "decimal", "NUMERIC_PRECISION": 19}

        # When
        got_byte_size = DbCategorizer._get_column_def_size_bytes(column_def)

        # Then
        self.assertEquals(got_byte_size, 9)

    def test_get_column_def_xml(self):
        # Given
        column_def = {"DATA_TYPE": "xml", "NUMERIC_PRECISION": 19}

        # When
        got_byte_size = DbCategorizer._get_column_def_size_bytes(column_def)

        # Then
        self.assertEquals(got_byte_size, DbCategorizer.DEFAULT_COLUMN_SIZE_BYTES)

    def test_get_column_def_size_custom_length(self):
        # Given
        column_def = {"DATA_TYPE": "varchar", "CHARACTER_MAXIMUM_LENGTH": 10}

        # When
        got_byte_size = DbCategorizer._get_column_def_size_bytes(column_def)

        # Then
        self.assertEquals(got_byte_size, 10)

    def test_get_row_size_bytes(self):
        # Given
        column_defs = [{"DATA_TYPE": "int"},
                       {"DATA_TYPE": "decimal", "NUMERIC_PRECISION": 19},
                       {"DATA_TYPE": "varchar", "CHARACTER_MAXIMUM_LENGTH": 10}
                       ]

        # When
        got_row_size_bytes = DbCategorizer._get_row_size_bytes(column_defs)

        # Then
        self.assertEquals(got_row_size_bytes, 23)

    def test_get_table_row_count(self):
        # Given
        row_count = random.randint(0, 100)
        table_name = "TableName"
        ingestible_db_tabe_conf = IngestibleDbTableConf(ANY, ANY, ANY, ANY, table_name)

        # Patch
        self.mock_mssql_db_mgr.execute_query.return_value = [{"num_rows": row_count}]

        # When
        got_row_count = self.categorizer._get_table_row_count(ingestible_db_tabe_conf)

        # Then
        self.assertEquals(got_row_count, row_count)

    def test_estimated_import_data_set_size_mb(self):
        # Given
        row_count = 1000000 * random.randint(0, 100)
        row_size_bytes = 23
        table_name = "TableName"
        column_defs = [{"DATA_TYPE": "int"},
                       {"DATA_TYPE": "decimal", "NUMERIC_PRECISION": 19},
                       {"DATA_TYPE": "varchar", "CHARACTER_MAXIMUM_LENGTH": 10}
                       ]
        ingestible_db_tabe_conf = IngestibleDbTableConf(ANY, ANY, ANY, ANY, table_name)

        # Patch
        self.mock_mssql_db_mgr.execute_query.return_value = [{"num_rows": row_count}]

        # When
        got_data_set_size_mb = self.categorizer._estimate_import_data_set_size_mb(ingestible_db_tabe_conf, column_defs)

        # Then
        data_set_size_mb = int(row_count / 1000000.0 * row_size_bytes)
        self.assertEquals(got_data_set_size_mb, data_set_size_mb)

    def test_get_column_definitions(self):
        # Given
        db_type = self.ingestible_conf.db_type
        table_name = self.ingestible_conf.table_name
        ingestible_db_tabe_conf = IngestibleDbTableConf(ANY, ANY, ANY, db_type, table_name)

        # When
        got_column_defs = self.categorizer._get_column_definitions(ingestible_db_tabe_conf)

        # Then
        self.assertListEqual(got_column_defs, self.ingestible_def.column_definitions)

    def test_get_column_definitions_missing_table_def(self):
        # Given
        db_type = self.ingestible_conf.db_type
        table_name = "NonExistingTable"

        # When
        with self.assertRaises(Exception):
            self.categorizer._get_column_definitions(db_type, table_name)

    def test_get_column_definitions_invalid_db_type(self):
        # Given
        db_types = [self.db_type]
        invalid_db_type = [min(db_types) - 1, max(db_types) + 1]
        table_name = self.ingestible_conf.table_name

        # When
        for db_type in invalid_db_type:
            with self.assertRaises(Exception):
                self.categorizer._get_column_definitions(db_type, table_name)

    def test_get_db_category_for_size_mb(self):
        # Given
        data_set_sizes = [1, 9, 10, 99]

        # When
        got_db_category_ids = [self.categorizer._get_db_category_for_size_mb(data_set_size)
                               for data_set_size in data_set_sizes]

        # Then
        self.assertListEqual(got_db_category_ids, [1, 1, 2, 2])

    def test_invalid_get_db_category_for_size_mb(self):
        # Given
        data_set_sizes = [-1, 100]

        # When
        for data_set_size in data_set_sizes:
            with self.assertRaises(Exception):
                self.categorizer._get_db_category_for_size_mb(data_set_size)
