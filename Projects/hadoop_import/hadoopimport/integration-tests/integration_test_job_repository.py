# !/usr/bin/env python

import unittest
from hadoopimport.db_import_definitions import DatabaseType
from hadoopimport.ingestion_job_status import IngestionJobStatus
from hadoopimport.ingestion_type import IngestionType
from hadoopimport.ingestion_job_repository import IngestionJobRepository, IngestionJob
from hadoopimport.ingestion_job_type import IngestionJobType
import copy


class TestHiveTools(unittest.TestCase):
    def test_ingestion_job_repo(self):
        ingest_repo = IngestionJobRepository()
        # testing insert
        test_job_a = ingest_repo.create_job(customer_id=12345,
                                            db_type=DatabaseType.CUSTOMER,
                                            db_name="customer",
                                            table_name="ClaimTransaction",
                                            ingestion_type=IngestionType.INCREMENTAL,
                                            ingestion_job_type=IngestionJobType.FULL,
                                            version=3,
                                            previous_version=1)

        expected_job_a = IngestionJob(ingestion_job_id=test_job_a.ingestion_job_id,
                                      customer_id=12345,
                                      db_type=DatabaseType.CUSTOMER,
                                      db_name="customer",
                                      table_name="ClaimTransaction",
                                      ingestion_type=IngestionType.INCREMENTAL,
                                      ingestion_job_type=IngestionJobType.FULL,
                                      status=IngestionJobStatus.CREATED,
                                      start_time=test_job_a.start_time,
                                      update_time=test_job_a.start_time,
                                      version=3,
                                      previous_version=1)

        self.assertEqual(str(expected_job_a), str(test_job_a))

        test_job_b = ingest_repo.create_job(customer_id=12345,
                                            db_type=DatabaseType.CUSTOMER,
                                            db_name="shared",
                                            table_name="Country",
                                            ingestion_type=IngestionType.FULL,
                                            ingestion_job_type=IngestionJobType.FULL)

        expected_job_b = IngestionJob(ingestion_job_id=test_job_b.ingestion_job_id,
                                  customer_id=12345,
                                  db_type=DatabaseType.CUSTOMER,
                                  db_name="shared",
                                  table_name="Country",
                                  ingestion_type=IngestionType.FULL,
                                  ingestion_job_type=IngestionJobType.FULL,
                                  status=IngestionJobStatus.CREATED,
                                  start_time=test_job_b.start_time,
                                  update_time=test_job_b.start_time,
                                  version=0,
                                  previous_version=0)

        self.assertEqual(str(expected_job_b), str(test_job_b))

    def test_non_cleanup_ingestion_job_query(self):
        ingest_repo = IngestionJobRepository()
        test_customer_id_list = ingest_repo.get_last_non_cleanup_job_customers()
        self.assertIsNotNone(test_customer_id_list)
        self.assertTrue(len(test_customer_id_list) > 0)

    def test_cleanup_ingestion_job_insert(self):
        ingest_repo = IngestionJobRepository()
        customer_ids = set([10590, 19631])
        failed_customer_ids = set([10590])
        ingest_repo.create_customer_cleanup_jobs(customer_ids, failed_customer_ids)


if __name__ == '__main__':
    unittest.main()
