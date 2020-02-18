import random

from hadoopimport.ct_enabler import CTEnabler, CTConfigProperty
from hadoopimport.ingestion_group import IngestionGroup
from hadoopimport.tests.base_test_case import BaseTestCase


class CTEnablerTest(BaseTestCase):

    def mock_config_get(self, section, option):
        """

        :type section: str
        :type option: str
        :rtype: object
        """
        if option == CTConfigProperty.RETENTION_HOURS_CONFIG:
            return self.retention_hours
        else:
            return None

    def mock_db_mgr_execute_query(self, query, query_params=None, db_conn_conf=None, db_name=None):
        """

        :type query: str
        :type query_params: dict
        :type db_conn_conf: DbConnConf
        :type db_name: str
        :rtype: list of dict
        """
        if query == CTEnabler.IS_DB_CT_ENABLED_QUERY:
            if db_conn_conf.db_name in self.enabled_db_tables:
                return [{"DATABASE_ID": random.randint(0, 1000)}]
            else:
                return []
        elif query == CTEnabler.IS_TABLE_CT_ENABLED_QUERY.format(db_conn_conf.table_name):
            if db_conn_conf.db_name in self.enabled_db_tables and \
                    db_conn_conf.table_name in self.enabled_db_tables[db_conn_conf.db_name]:
                return [{"TABLE_ID": random.randint(0, 1000)}]
            else:
                return []
        elif query == CTEnabler.ENABLE_DB_CT_QUERY.format(self.retention_hours):
            if db_conn_conf.db_name not in self.enabled_db_tables:
                self.enabled_db_tables[db_conn_conf.db_name] = []
            else:
                raise Exception("DB already has CT enabled")
            return []
        elif query == CTEnabler.ENABLE_TABLE_CT_QUERY.format(db_conn_conf.table_name):
            if db_conn_conf.db_name in self.enabled_db_tables:
                if db_conn_conf.table_name not in self.enabled_db_tables[db_conn_conf.db_name]:
                    self.enabled_db_tables[db_conn_conf.table_name].append(db_conn_conf.table_name)
                else:
                    raise Exception("Table already has CT enabled")
            else:
                raise Exception("DB doesnt have CT enabled")
            return []
        else:
            raise NotImplementedError

    def setUp(self):
        self.ingestion_group = IngestionGroup.KA

        # Mock config
        self.mock_config_class = self.get_mock_class("hadoopimport.ct_enabler.Config")
        self.mock_config = self.mock_config_class.return_value
        self.mock_config.get.side_effect = self.mock_config_get

        # Mock DB Manager
        self.mock_msql_db_mgr = self.get_mock("hadoopimport.ct_enabler.MsSqlDbManager")
        self.mock_msql_db_mgr.execute_query.side_effect = self.mock_db_mgr_execute_query

        # Mock DB Table List Generator
        self.mock_ingestible_db_table_list_generator = self.get_mock(
            "hadoopimport.ct_enabler.IngestibleDbTableListGenerator")

        # Dict of db name to list of tables that have enabled Change Tracking
        self.enabled_db_tables = {}

        # CT Retention hours
        self.retention_hours = 10

    def test_enable_ct_for_all_dbs(self):
        # Given
        ingestible_db_tables = [("db1", "table1"),
                                ("db1", "table2"),
                                ("db2", "table2"),
                                ("db2", "table3")]
        self.enabled_db_tables = {"db2": ["table2"]}

        # Patch
        self.mock_ingestible_db_table_list_generator.get_all_db_tables.return_value = [
            self.build_ingestible_db_table_conf(db_name=ingestible[0], table_name=ingestible[1])
            for ingestible in ingestible_db_tables]

        # When
        self.ct_enabler = CTEnabler()
        self.ct_enabler.enable_ct_for_all_dbs(self.ingestion_group)

        # Then
        self.mock_ingestible_db_table_list_generator.get_all_db_tables.assert_called_once()
        db_queries = map(lambda call: call[0][0].lower(), self.mock_msql_db_mgr.execute_query.call_args_list)
        alter_ct_queries = filter(lambda query: "alter" in query and "change_tracking" in query, db_queries)
        enable_db_ct_queries = filter(lambda query: "database" in query, alter_ct_queries)
        enable_db_table_queries = filter(lambda query: "table" in query, alter_ct_queries)

        self.assertEquals(len(enable_db_ct_queries), 1)
        self.assertEquals(len(enable_db_table_queries), 3)