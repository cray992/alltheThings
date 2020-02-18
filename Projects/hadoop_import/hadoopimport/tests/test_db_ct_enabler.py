import random

from hadoopimport.db_ct_enabler import DbCTEnabler
from hadoopimport.ingestion_group import IngestionGroup
from hadoopimport.tests.base_test_case import BaseTestCase


class CTEnablerTest(BaseTestCase):



    def setUp(self):
        self.ingestion_group = IngestionGroup.KA

        # Mock config
        self.mock_config_class = self.get_mock_class("hadoopimport.db_ct_enabler.Config")
        self.mock_msql_db_mgr = self.get_mock("hadoopimport.db_ct_enabler.MsSqlDbManager")
        self.mock_db_ct_conf_repo = self.get_mock("hadoopimport.db_ct_enabler.DbCTConfRepository")
        self.mock_customer_subscription_repo = self.get_mock("hadoopimport.db_ct_enabler.CustomerSubscriptionRepository")

        # Instance to test
        self.ct_enabler = DbCTEnabler()


    def _get_executed_queries(self):
        return map(lambda call: call[0][0].upper(), self.mock_mssql_db_mgr.execute_query.call_args_list)


    def test_enable_ct_for_all_dbs(self):
        # Given

        # HDP_DatabasesToImport as a list of tuples: (db server, db name, db enabled)
        db_ct_confs = [("host1", "db1", 1), ("host2", "db2", 0), ("host2", "db3", 1)]

        # Customer Subscriptions as a list of tuples: (db server, db name)
        subscriptions = [("host1", "db1"), ("host2", "db2"), ("host3", "db3"), ("host2", "db4")]


        # Patch
        self.mock_customer_subscription_repo.get_customer_subscriptions.return_value = [
            self.build_customer_subscription(db_server=db[0], db_name=db[1]) for db in subscriptions]

        self.mock_db_ct_conf_repo.get_db_ct_confs.return_value = [
            self.build_db_ct_conf(db_server=db[0], db_name=db[1], db_enabled=[2]) for db in db_ct_confs]

        # When
        self.ct_enabler.enable_ct_for_all_dbs(self.ingestion_group)

        # Then
        # Ensure new db records were created
        create_db_ct_conf_calls = self.mock_db_ct_conf_repo.create_db_ct_conf.call_args_list
        actual_args_list = map(lambda call: call[1], create_db_ct_conf_calls)
        expected_args_list = [{"db_server": "host3", "db_name": "db3"}, {"db_server": "host2", "db_name": "db4"}]
        self.assertListEqual(expected_args_list, actual_args_list)


        # Ensure CT store procedure was called
        execute_query_calls = self.mock_msql_db_mgr.execute_query.call_args_list
        self.assertGreater(execute_query_calls, 0)
        query = execute_query_calls[0][0][0].upper()
        self.assertIn("EXEC", query)
        self.assertIn(self.ct_enabler.ENABLE_TABLE_CT_SPROC.upper(), query)


