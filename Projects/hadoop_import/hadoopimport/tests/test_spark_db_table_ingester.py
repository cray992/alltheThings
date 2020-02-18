import random
import sys
from mock import patch, call, MagicMock
sys.modules["hadoopimport.config"] = MagicMock()
from hadoopimport.database_type import DatabaseType
from hadoopimport.hive_schema_manager import HiveChangeTracking
from hadoopimport.tests.base_test_case import BaseTestCase


from hadoopimport.spark_db_table_ingester import SparkDbTableIngester
from hadoopimport.ingestion_group import IngestionGroup
from hadoopimport.ingestion_type import IngestionType
from hadoopimport.ingestion_job_type import IngestionJobType

patch.multiple = patch.multiple
patch.object = patch.object


class SparkDbTableIngesterTest(BaseTestCase):
    INGESTION_JOB_TYPES = [IngestionJobType.FULL, IngestionJobType.INCREMENTAL]
    INGESTION_TYPES = [IngestionType.FULL, IngestionType.INCREMENTAL]

    def setUp(self):
        self.ingestion_group = IngestionGroup.KA
        self.db_type = DatabaseType.CUSTOMER
        self.db_metastore = "db-metastore"
        self.previous_ct_version = random.randint(1, 1000)
        self.ct_version = random.randint(1001, 2000)
        self.ingestion_job_type = self.INGESTION_JOB_TYPES[random.randint(0, 1)]
        self.ingestion_type = self.INGESTION_TYPES[random.randint(0, 1)]

        # DTOs
        self.ingestion_job = self.build_ingestion_job()
        self.ingestible_def = self.build_ingestible_def(ingestion_type=self.ingestion_type)
        self.ingestible_conf = self.build_ingestible_db_table_conf()

        # Mocks
        self.mock_ingestible_db_conf_repo = self.get_mock(
            "hadoopimport.spark_db_table_ingester.IngestibleDbConfRepository")
        self.mock_ingestible_db_conf_repo.get_ingestible_db_types.return_value = [self.db_type]
        self.mock_config = self.get_mock("hadoopimport.db_categorizer.Config")
        self.mock_logger = self.get_mock("logging.Logger")
        self.mock_lit = self.get_mock("hadoopimport.spark_db_table_ingester.lit")
        self.mock_current_timestamp = self.get_mock("hadoopimport.spark_db_table_ingester.current_timestamp")
        self.mock_mssql_db_mgr = self.get_mock("hadoopimport.spark_db_table_ingester.MsSqlDbManager")
        self.mock_hive_db_mgr = self.get_mock("hadoopimport.spark_db_table_ingester.HiveDbManager")
        self.mock_hive_schema_mgr_class = self.get_mock_class("hadoopimport.spark_db_table_ingester.HiveSchemaManager")
        self.mock_hive_schema_mgr_class.get_temp_table_name.side_effect = lambda table: table + HiveChangeTracking.TEMP_SUFFIX
        self.mock_hive_schema_mgr_class.get_ct_table_name.side_effect = lambda table_name: table_name + HiveChangeTracking.TABLE_SUFFIX
        self.mock_hive_schema_mgr_class.qualify_table_name.side_effect = lambda table_name, db_name: db_name + "." + table_name

        self.mock_hive_schema_mgr = self.mock_hive_schema_mgr_class.return_value

        self.mock_spark_session_class = self.get_mock_class("hadoopimport.spark_db_table_ingester.SparkSession")
        self.mock_spark_session_builder = self.get_mock("pyspark.sql.SparkSession.Builder")
        self.mock_spark_session = self.get_mock("pyspark.sql.SparkSession")

        self.mock_ingestion_job_repo = self.get_mock(
            "hadoopimport.spark_db_table_ingester.IngestionJobRepository")
        self.mock_ingestion_job_repo.create_job.return_value = self.ingestion_job
        self.mock_db_definition_repo = self.get_mock("hadoopimport.spark_db_table_ingester.DbDefinitionRepository")


        # Patch
        self.mock_data_frame = self.get_mock("pyspark.sql.DataFrame")

        self.mock_data_frame_reader = self.get_mock("pyspark.sql.DataFrameReader")
        self.mock_data_frame_reader.format.return_value = self.mock_data_frame_reader
        self.mock_data_frame_reader.options.return_value = self.mock_data_frame_reader
        self.mock_data_frame_reader.load.return_value = self.mock_data_frame

        self.mock_spark_session_class.builder = self.mock_spark_session_builder
        self.mock_spark_session_builder.appName.return_value = self.mock_spark_session_builder
        self.mock_spark_session_builder.config.return_value = self.mock_spark_session_builder
        self.mock_spark_session_builder.enableHiveSupport.return_value = self.mock_spark_session_builder
        self.mock_spark_session_builder.getOrCreate.return_value = self.mock_spark_session
        self.mock_spark_session.read = self.mock_data_frame_reader

        self.mock_hive_schema_mgr_class.get_metastore.return_value = self.db_metastore
        self.mock_db_definition_repo.get_db_definition.return_value = {
            self.ingestible_def.table_name: self.ingestible_def}

        # Object to test
        self.ingester = SparkDbTableIngester(self.ingestion_group, self.ingestion_job_type)

    def test_ingestion_job_created_properly(self):
        # Given
        self.mock_mssql_db_mgr.execute_query.return_value = [{"CT_Version": self.ct_version}]
        self.mock_ingestion_job_repo.get_last_successful_job.return_value = self.build_ingestion_job(
            version=self.previous_ct_version)

        # When
        self.ingester.ingest([self.ingestible_conf])

        # Then
        self.mock_ingestion_job_repo.create_job.assert_called_once_with(customer_id=self.ingestible_conf.customer_id,
                                                                        db_type=self.ingestible_conf.db_type,
                                                                        db_name=self.ingestible_conf.db_name,
                                                                        table_name=self.ingestible_conf.table_name,
                                                                        ingestion_type=self.ingestible_def.ingestion_type,
                                                                        ingestion_job_type=self.ingestion_job_type,
                                                                        version=self.ct_version,
                                                                        previous_version=self.previous_ct_version)

    def test_data_frame_creation(self):
        # Given
        table_name = self.ingestible_conf.table_name

        # When
        self.ingester.ingest([self.ingestible_conf])

        # Then
        self.mock_data_frame_reader.format.assert_called_once_with("jdbc")
        self.mock_data_frame_reader.load.assert_called_once()
        self.mock_data_frame_reader.options.assert_called_once()

        select_query = self.mock_data_frame_reader.options.call_args[1]["dbtable"]
        self.assertIn(table_name, select_query)

    def test_ct_current_version(self):
        # Given
        # When
        self.ingester.ingest([self.ingestible_conf])

        # Then
        mssql_queries = map(lambda call: call[0][0].upper(), self.mock_mssql_db_mgr.execute_query.call_args_list)
        self.assertEquals(len(mssql_queries), 1)
        self.assertIn("CHANGE_TRACKING_CURRENT_VERSION", mssql_queries[0].upper())

    def test_ct_current_version(self):
        # Given
        self.ingestible_def.ingestion_type = IngestionType.INCREMENTAL
        self.ingestion_job_type = IngestionJobType.INCREMENTAL
        self.ingester = SparkDbTableIngester(self.ingestion_group, self.ingestion_job_type)

        # When
        self.ingester.ingest([self.ingestible_conf])

        # Then
        select_query = self.mock_data_frame_reader.options.call_args[1]["dbtable"]
        self.assertIn("CHANGETABLE", select_query)
        self.assertIn("CASE WHEN", select_query)
        self.assertIn("sys_change_operation", select_query)
        self.assertIn("'D'", select_query)
        self.assertIn("'U'", select_query)
