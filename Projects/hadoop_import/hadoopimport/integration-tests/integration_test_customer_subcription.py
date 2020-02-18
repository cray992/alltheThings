import unittest

from hadoopimport.customer_subscription_repository import CustomerSubscriptionRepository
from hadoopimport.ingestion_group import IngestionGroup


class CustomerRepositoryTest(unittest.TestCase):
    def test_customer_subscription(self):
        ingstion_group = IngestionGroup.KA
        customer_repo = CustomerSubscriptionRepository(ingstion_group)
        cusotmer_subscription = customer_repo.get_customer_subscriptions()

        self.assertIsNotNone(cusotmer_subscription)
        self.assertTrue(len(cusotmer_subscription) > 0)


if __name__ == '__main__':
    unittest.main()
