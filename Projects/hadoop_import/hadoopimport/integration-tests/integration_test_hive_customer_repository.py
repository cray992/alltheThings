# !/usr/bin/env python

import unittest
from hadoopimport.hive_customer_repository import  HiveCustomerRepository
from hadoopimport.ingestion_group import IngestionGroup


class HiveCustomerRepositoryTest(unittest.TestCase):
    def test_remove_hive_customer_data(self):
        customer_ids = set([10590, 19631])
        hive_customer_repo = HiveCustomerRepository(IngestionGroup.KA)
        hive_customer_repo.remove_deactivated_customer_data(customer_ids)


if __name__ == '__main__':
        unittest.main()
