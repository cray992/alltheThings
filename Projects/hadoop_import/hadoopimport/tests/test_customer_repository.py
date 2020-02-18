import sys

from base_test_case import BaseTestCase
from mock import MagicMock
from hadoopimport.ingestion_group import IngestionGroup

sys.modules['hadoopimport.config'] = MagicMock()
from hadoopimport.customer_subscription_repository import CustomerSubscriptionRepository

class CustomerRepositoryTest(BaseTestCase):
    def setUp(self):
        self.mock_mssql_db_mgr = self.get_mock("hadoopimport.customer_subscription_repository.MsSqlDbManager")
        self.mock_config = self.get_mock("hadoopimport.customer_subscription_repository.Config")

    def test_customer_subscription(self):
        # Given
        self.mock_config.is_debug_enabled.return_value = False
        self.mock_mssql_db_mgr.execute_query.return_value = [
            {"customer_id": 12345, "db_server": "dbserver", "db_name": "dbname"}
        ]

        # When
        customer_repo = CustomerSubscriptionRepository(IngestionGroup.KA)
        cusotmer_subscription = customer_repo.get_customer_subscriptions()

        # Then
        self.assertIsNotNone(cusotmer_subscription)
        self.assertTrue(len(cusotmer_subscription) > 0)

