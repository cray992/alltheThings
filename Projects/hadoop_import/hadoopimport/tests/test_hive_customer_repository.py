from base_test_case import BaseTestCase
from hadoopimport.database_type import DatabaseType
from hadoopimport.hive_customer_repository import HiveCustomerRepository
from hadoopimport.ingestion_group import IngestionGroup


class HiveCustomerRepositoryTest(BaseTestCase):
    def setUp(self):
        self.ingestion_group = IngestionGroup.KA
        self.mock_ingestible_db_conf_repo = self.get_mock("hadoopimport.hive_customer_repository.IngestibleDbConfRepository")
        self.mock_hive_db_mgr = self.get_mock("hadoopimport.hive_customer_repository.HiveDbManager")
        self.mock_db_definition_repo = self.get_mock("hadoopimport.hive_customer_repository.DbDefinitionRepository")
        self.mock_config = self.get_mock("hadoopimport.hive_customer_repository.Config")


    def test_hive_customer_remove(self):
        # Given
        target_db_name = "TargetDbName"
        self.mock_db_definition_repo.get_db_definition.return_value = ["practice"]

        # Patch
        self.mock_ingestible_db_conf_repo.get_target_db_names.return_value = {DatabaseType.CUSTOMER: target_db_name}

        # When
        hive_customer_repo = HiveCustomerRepository(IngestionGroup.KA)
        hive_customer_repo.remove_deactivated_customer_data(set([10590]))

        # Then
        self.mock_ingestible_db_conf_repo.get_target_db_names.assert_called_once()
        self.mock_hive_db_mgr.execute_query.assert_called_once()
        execute_query_args = self.mock_hive_db_mgr.execute_query.call_args_list[0]
        query_arg = execute_query_args[0][0].lower()
        db_name_arg = execute_query_args[1]['db_name']
        self.assertIn("alter table", query_arg)
        self.assertIn("drop", query_arg)
        self.assertIn("partition", query_arg)
        self.assertEqual(db_name_arg, target_db_name)