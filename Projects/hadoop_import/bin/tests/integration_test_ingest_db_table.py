import unittest
from datetime import datetime

from mock import patch, Mock, call

from bin.ingest_db_tables import *
from hadoopimport.db_category_repository import DbCategory
from hadoopimport.ingestion_type import IngestionType
from hadoopimport.tests.base_test_case import BaseTestCase
from hadoopimport.db_import_definitions import DatabaseType
from hadoopimport.ingestion_job_status import IngestionJobStatus


class ImportDbSparkTest(BaseTestCase):

    def setUp(self):
        self.mock_ingestion_job_repo =self.get_mock("bin.ingest_db_tables.IngestionJobRepository")
        self.ingestion_job = self.build_ingestion_job()
        self.mock_hive_consistency_fixer = self.get_mock("bin.ingest_db_tables.HiveConsistencyFixer")
        test_job_1 = self.build_ingestion_job(ingestion_job_id=1, table_name="table_1")
        test_job_2 = self.build_ingestion_job(ingestion_job_id=2, table_name="table_2")
        self.test_jobs = {1: test_job_1, 2: test_job_2}
        self.mock_fixed_tables = {DatabaseType.CUSTOMER: {
            "table_1": self.build_ingestible_def(table_name="table_1"),
            "table_2": self.build_ingestible_def(table_name="table_2")},
            DatabaseType.SHARED: {"table_3": self.build_ingestible_def(table_name="table_3")}}
        self.mock_write_ingestible_batch_to_hdfs = self.get_mock("bin.ingest_db_tables.write_ingestible_batch_to_hdfs")

    # Given
    test_ingestible_db_1 = IngestibleDbTableConf(db_name="superbill_22109_dev",
                                                 db_server='stage_customer.kareoprod.ent',
                                                 db_port=4400, target_db_name="customer", customer_id=22109,
                                                 table_name="table_1", db_conf_id=1, db_type=DatabaseType.CUSTOMER)

    test_ingestible_db_2 = IngestibleDbTableConf(db_name="superbill_shared", db_server='sna-sgw-db-01.kareoprod.ent',
                                                 table_name="table_2", db_conf_id=2, db_port=1100,
                                                 target_db_name="shared",
                                                 db_type=DatabaseType.SHARED)

    test_ingestible_db_3 = IngestibleDbTableConf(db_name="db_salesforce", db_server='sna-sgw-db-01.kareoprod.ent',
                                                 table_name="table_3", db_conf_id=3, db_port=1100,
                                                 target_db_name="salesforce",
                                                 db_type=DatabaseType.SALESFORCE)

    test_ingestible_db_4 = IngestibleDbTableConf(db_name="superbill_7830_dev", db_server='stage_customer.kareoprod.ent',
                                                 db_port=4400, target_db_name="customer", customer_id=7830,
                                                 table_name="table_4", db_conf_id=4, db_type=DatabaseType.CUSTOMER)

    test_ingestible_db_5 = IngestibleDbTableConf(db_name="superbill_23_dev", db_server='stage_customer.kareoprod.ent',
                                                 db_port=4400, target_db_name="customer", customer_id=23,
                                                 table_name="table_5", db_conf_id=5, db_type=DatabaseType.CUSTOMER)

    test_ingestible_db_6 = IngestibleDbTableConf(db_name="superbill_81_dev", db_server='stage_customer.kareoprod.ent',
                                                 db_port=4400, target_db_name="customer", customer_id=81,
                                                 table_name="table_6", db_conf_id=6, db_type=DatabaseType.CUSTOMER)

    test_ingestible_dbs = [test_ingestible_db_1, test_ingestible_db_2]

    test_spark_config_1 = DbCategory(db_category_id=2, db_category_name='S', max_table_size_mb=2500,
                                     min_table_size_mb=None, num_workers=2, num_executors=1, executor_cores=1, executor_memory=4096,
                                     create_time=datetime.now().time(), update_time=datetime.now().time())

    test_spark_config_2 = DbCategory(db_category_id=2, db_category_name='S', max_table_size_mb=2500,
                                     min_table_size_mb=None, num_workers=8, num_executors=1, executor_cores=1, executor_memory=4096,
                                     create_time=datetime.now().time(), update_time=datetime.now().time())

    test_categories = {1: test_spark_config_1, 2: test_spark_config_2}

    def test_fix_inconsistent_tables(self):
        # Patch
        self.mock_ingestion_job_repo.update_status.return_value = self.ingestion_job
        self.mock_ingestion_job_repo.get_last_job_all_db_tables.return_value = self.test_jobs
        self.mock_hive_consistency_fixer.fix_all.return_value = self.mock_fixed_tables

        fix_inconsistent_tables(IngestionGroup.KA)
        self.mock_ingestion_job_repo.update_status.assert_has_calls(
            [call(1, IngestionJobStatus.STALE), call(2, IngestionJobStatus.STALE)])

    @patch("bin.ingest_db_tables.write_ingestible_batch_to_hdfs", return_value="/my/test/path")
    @patch("hadoopimport.cli_utils.get_hadoopimport_home", return_value="/my_import_home")
    @patch("bin.ingest_db_tables.run_asynch_command", return_value=Popen("pwd"))
    def test_spark_import_on_db(self, mock_run_asynch_command, mock_hadoopimport_home,
                                mock_write_ingestible_batch_to_hdfs):
        # Given
        # expected_command = " spark-submit --master yarn --files /my_import_home/hadoopimport/config.ini,/my_import_home/hadoopimport/logging.conf,/my_import_home/hadoopimport/summary.conf --driver-memory 4g --driver-cores 1 --deploy-mode cluster --conf spark.driver.extraJavaOptions=-Dhdp.version=2.3.4.0-3485 --conf spark.yarn.am.extraJavaOptions=-Dhdp.version=2.3.4.0-3485 --py-files /my_import_home/target/hadoopimport.zip --driver-class-path /my_import_home/jars/jtds-1.3.1.jar --conf spark.executor.extraClassPath=jtds-1.3.1.jar --jars /my_import_home/jars/jtds-1.3.1.jar,/usr/hdp/current/spark-client/lib/datanucleus-api-jdo-3.2.6.jar,/usr/hdp/current/spark-client/lib/datanucleus-rdbms-3.2.9.jar,/usr/hdp/current/spark-client/lib/datanucleus-core-3.2.10.jar /my_import_home/hadoopimport/spark_full_db_import.py /my/test/path"
        launch_spark_ingestion(self.test_ingestible_dbs, self.test_spark_config_1, IngestionGroup.KA,
                               IngestionType.FULL)

        mock_run_asynch_command.assert_called_once()

    @patch("hadoopimport.db_category_repo.DbCategoryRepository.get_all_db_categories",
           return_value=test_categories)
    @patch("bin.ingest_db_tables.run_asynch_command", return_value=(Popen("pwd")))
    def test_map_dbs_to_workers(self, mock_run_asynch_command, mock_get_all_db_categories):
        test_categorized_dbs = {1: [self.test_ingestible_db_1, self.test_ingestible_db_2, self.test_ingestible_db_3],
                                2: [self.test_ingestible_db_4, self.test_ingestible_db_5, self.test_ingestible_db_6]}
        self.mock_write_ingestible_batch_to_hdfs.return_value = "testpath"
        test = map_dbs_to_workers(test_categorized_dbs, IngestionGroup.KA, IngestionType.FULL)
        self.assertEqual(1, mock_get_all_db_categories.call_count)
        self.assertEqual(5, mock_run_asynch_command.call_count)


if __name__ == '__main__':
    unittest.main()
