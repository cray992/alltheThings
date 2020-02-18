import unittest
import uuid
import bin.setup_hive_db as setup_hive_db
from hadoopimport.db_import_definitions import ImportTableDef, DatabaseType
from mock import patch, Mock, ANY

patch.object = patch.object

class TestAppManager(unittest.TestCase):
    def test_generate_create_table_query(self):
        # Given
        test_columns = [
            {u'NUMERIC_PRECISION': 10, u'COLUMN_NAME': u'col1',
             u'TABLE_NAME': u'InsurancePolicyAuthorization', u'DATA_TYPE': u'int',
             u'NUMERIC_SCALE': 0},
            {u'NUMERIC_PRECISION': None, u'COLUMN_NAME': u'col2',
             u'TABLE_NAME': u'InsurancePolicyAuthorization', u'DATA_TYPE': u'varchar',
             u'NUMERIC_SCALE': None},
            {u'NUMERIC_PRECISION': None, u'COLUMN_NAME': u'col3',
             u'TABLE_NAME': u'InsurancePolicyAuthorization', u'DATA_TYPE': u'varchar',
             u'NUMERIC_SCALE': None}
        ]

        test_def = ImportTableDef(table_name= 'test_table', column_definitions=test_columns, merge_match_buckets=['col1'], partition_fields=['customer_id'], num_buckets=2)
        expected_query = 'CREATE TABLE `test_table` (`col1` int,`col2` string,`col3` string) PARTITIONED BY (customer_id int) clustered by (col1) into 2 buckets STORED AS ORC TBLPROPERTIES ("orc.compress"="SNAPPY" , "transactional"="true")'

        test_table_query = setup_hive_db.generate_create_table_query(test_def)
        self.assertEquals(expected_query, test_table_query)
