import sys
import datetime

from mock import ANY, patch, MagicMock

from hadoopimport.ingestion_job_status import IngestionJobStatus

sys.modules['hadoopimport.config'] = MagicMock()
from decimal import Decimal
from base_test_case import BaseTestCase
from hadoopimport.ingestion_job_repository import IngestionJobRepository


class IngestionJobRepositoryTest(BaseTestCase):
    def setUp(self):
        self.mock_mssql_db_mgr = self.get_mock("hadoopimport.ingestion_job_repository.MsSqlDbManager")
        self.mock_config = self.get_mock("hadoopimport.ingestion_job_repository.Config")

    def test_non_cleanup_ingestion_job_query(self):
        # Given
        self.mock_mssql_db_mgr.execute_query.return_value = [
            {u'Status': Decimal('1'), u'UpdateTime': datetime.datetime(2018, 4, 12, 15, 49, 39, 43000), u'DbType': Decimal('1'), u'TableName': u'PaymentType', u'PreviousVersion': 0, u'CustomerId': 10590, u'IngestionJobID': 126, u'Version': 0, u'CreateTime': datetime.datetime(2018, 4, 12, 15, 49, 39, 43000), u'StartTime': datetime.datetime(2018, 4, 12, 15, 49, 39, 43000), u'IngestionType': Decimal('1'), u'IngestionJobType': Decimal('3'), u'DbName': u'christiancustomer'}
        ]

        # When
        ingest_repo = IngestionJobRepository()
        test_customer_id_list = ingest_repo.get_last_non_cleanup_job_customers()

        # Then
        self.assertIsNotNone(test_customer_id_list )
        self.assertTrue(len(test_customer_id_list ) > 0)

    def test_cleanup_ingestion_job_insert(self):
        # Given
        self.mock_mssql_db_mgr.execute_query.return_value = 123
        customer_ids = set([10590, 19631])
        failed_customer_ids = set([10590])

        # When
        ingest_repo = IngestionJobRepository()
        ingest_repo.create_customer_cleanup_jobs(customer_ids, failed_customer_ids)

        # Then
        self.assertEqual(self.mock_mssql_db_mgr.execute_query.call_count, 2)

    def test_failure_ingestion_job_query(self):
        # Given
        self.mock_mssql_db_mgr.execute_query.return_value = [
            {u'TableName': u'PatientCaseDate', u'CustomerId': 10590, u'IngestionType': Decimal('1')}
        ]

        # When
        ingest_repo = IngestionJobRepository()
        test_failure_job_list = ingest_repo.get_last_ingestion_jobs_by_status(IngestionJobStatus.FAIL)

        # Then
        self.assertIsNotNone(test_failure_job_list)
        self.assertTrue(len(test_failure_job_list) > 0)
