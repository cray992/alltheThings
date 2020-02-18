import random

from mock import Mock

from base_test_case import BaseTestCase
from hadoopimport.db_ct_conf_repository import DbCTConfRepository


class DbCTConfRepositoryTest(BaseTestCase):

    def setUp(self):
        self.mock_mssql_db_mgr = self.get_mock("hadoopimport.db_ct_conf_repository.MsSqlDbManager")
        self.mock_config = self.get_mock("hadoopimport.db_ct_conf_repository.Config")

        # DTO mocks
        self.db_ct_conf = self.build_db_ct_conf()

        # Instance to test
        self.db_ct_conf_repo= DbCTConfRepository()

    def _get_executed_queries(self):
        return map(lambda call: call[0][0].upper(), self.mock_mssql_db_mgr.execute_query.call_args_list)

    def _first_executed_query(self):
        executed_queries = self._get_executed_queries()
        if executed_queries:
            return executed_queries[0]
        else:
            return None

    def test_get_db_confs(self):
        # Given
        num_dbs=3
        db_ct_conf_rows = [{"DatabaseName":"DbName%s" % db_id, "HostServer": "DbServer%s" % db_id}
                    for db_id in xrange(0, num_dbs)]

        # Patch
        self.db_ct_conf_repo._db_ct_conf_row_mapper = Mock()
        self.mock_mssql_db_mgr.execute_query.return_value = db_ct_conf_rows

        # When
        self.db_ct_conf_repo.get_db_ct_confs()

        # Then
        query = self._first_executed_query()
        self.assertEquals(self.db_ct_conf_repo.DBS_CT_CONF_QUERY.upper(), query)
        self.assertEqual(len(self.db_ct_conf_repo._db_ct_conf_row_mapper.call_args_list), num_dbs)

    def test_get_db_ct_conf_by_id(self):
        # Given
        db_id = self.db_ct_conf.db_id

        # When
        self.db_ct_conf_repo.get_db_ct_conf_by_id(db_id)

        # Then
        query = self._first_executed_query()
        self.assertIn("WHERE", query)
        self.assertIn("DATABASEID", query)
        self.assertIn("%s" % db_id, query)

    def test_create_db_ct_conf(self):
        # Given
        db_server = "some-host.kareoprod.ent"
        db_name = "some_db"

        # When
        self.db_ct_conf_repo.create_db_ct_conf(db_server, db_name)

        # Then
        query = self._first_executed_query()
        self.assertIn("INSERT", query)
        self.assertIn("DATABASENAME", query)
        self.assertIn("HOSTSERVER", query)
        self.assertIn(db_server.upper(), query)
        self.assertIn(db_name.upper(), query)


    def test_update_db_ct_conf(self):
        # Given
        db_id = random.randint(0, 100)
        db_server = "some-host.kareoprod.ent"
        db_enabled = random.randint(0,1)

        # When
        self.db_ct_conf_repo.update_db_ct_conf(db_id, db_server, db_enabled)

        # Then
        query = self._first_executed_query()
        self.assertIn("UPDATE", query)
        self.assertIn("HOSTSERVER", query)
        self.assertIn("DBENABLED", query)
        self.assertIn(db_server.upper(), query)
        self.assertIn("%s" % db_enabled, query)

