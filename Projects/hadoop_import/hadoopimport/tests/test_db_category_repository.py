import random

from datetime import datetime

from hadoopimport.db_category_repository import DbCategory, DbCategoryRepository
from base_test_case import BaseTestCase


class DbCategoryRepositoryTest(BaseTestCase):

    def setUp(self):
        # Classes / attributes to mock
        self.mock_config = self.get_mock("hadoopimport.db_category_repository.Config")
        self.mock_mssql_db_mgr = self.get_mock("hadoopimport.db_category_repository.MsSqlDbManager")

    def test_get_all_db_categories(self):
        # Given
        num_categories = random.randint(1, 3)
        multiplier = random.randint(1, 3)
        category_ids_range = xrange(1, num_categories * multiplier + 1, multiplier)
        now = datetime.now()
        query_result = [{"DbCategoryId": i,
                         "DbCategoryName": "Category %s" % i,
                         "MinTableSizeMB": i,
                         "MaxTableSizeMB": i,
                         "NumWorkers": i,
                         "NumExecutors": i,
                         "ExecutorMemory": i,
                         "ExecutorCores": i,
                         "DriverMemory": i,
                         "DriverCores": i,
                         "CreateTime": now,
                         "UpdateTime": now
                         } for i in category_ids_range]
        db_categories = dict(map(lambda i: (i, DbCategory(i, "Category %s" % i, i, i, i, i, i, i, i, i, now, now)), category_ids_range))

        # Patch
        self.mock_mssql_db_mgr.execute_query.return_value = query_result

        # When
        db_category_repo = DbCategoryRepository()
        got_db_categories = db_category_repo.get_all_db_categories()

        # Then
        self.assertDictEqual(got_db_categories, db_categories)
