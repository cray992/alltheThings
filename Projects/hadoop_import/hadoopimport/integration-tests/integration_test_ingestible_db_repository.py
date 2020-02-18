# !/usr/bin/env python

import unittest

from hadoopimport.ingestible_db_repository import IngestibleDbConfRepository
from hadoopimport.ingestion_group import IngestionGroup


class IngestibleDbRepositoryTest(unittest.TestCase):
    def test_ingestible_db_conf(self):
        ingestion_group = IngestionGroup.KA
        ingestible_db_repo = IngestibleDbConfRepository(ingestion_group)
        ingestible_db_config_list = ingestible_db_repo.get_ingestible_db_types()

        self.assertIsNotNone(ingestible_db_config_list)
        self.assertEqual(len(ingestible_db_config_list), 2)

    def test_ingestible_db_types(self):
        ingestion_group = IngestionGroup.KMB
        ingestible_db_repo = IngestibleDbConfRepository(ingestion_group)
        ingestible_db_type_list = ingestible_db_repo.get_ingestible_db_types()

        self.assertIsNotNone(ingestible_db_type_list)
        self.assertEqual(len(ingestible_db_type_list), 3)


if __name__ == '__main__':
    unittest.main()
