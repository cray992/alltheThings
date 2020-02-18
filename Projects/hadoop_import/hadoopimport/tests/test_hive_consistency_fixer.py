from base_test_case import BaseTestCase
from hadoopimport.hive_consistency_fixer import HiveConsistencyFixer
from hadoopimport.ingestion_group import IngestionGroup
from hadoopimport.database_type import DatabaseType


class HiveConsistencyFixerTest(BaseTestCase):

    def setUp(self):
        self.mock_consistency_checker = self.get_mock("hadoopimport.hive_consistency_fixer.HiveConsistencyChecker")
        self.mock_schema_manager = self.get_mock("hadoopimport.hive_consistency_fixer.HiveSchemaManager")
        self.mock_config = self.get_mock("hadoopimport.hive_consistency_fixer.Config", autospec=False)
        self.mock_db_definition_repo = self.get_mock("hadoopimport.hive_consistency_fixer.DbDefinitionRepository")
        self.mock_ingestible_db_conf_repo = self.get_mock(
            "hadoopimport.hive_consistency_fixer.IngestibleDbConfRepository")

    def test_fix_all_return(self):
        # Given
        self.mock_ingestible_db_conf_repo.get_ingestible_dbs.return_value = [
            self.build_ingestible_db_conf(db_type=DatabaseType.CUSTOMER, target_db_name="customer"),
            self.build_ingestible_db_conf(db_type=DatabaseType.SHARED, target_db_name="shared")]

        self.mock_consistency_checker.get_unused_tables.return_value = ["Test.Table1"]
        self.mock_consistency_checker.get_new_tables.return_value = {"Test.Table4": {}}
        self.mock_consistency_checker.get_inconsistent_tables.side_effect = [
            {"Test.Table5": {}},
            {"Test.Table6": {}, "Test.Table7": {}}
        ]

        # When
        hive_consistency_fixer = HiveConsistencyFixer(IngestionGroup.KA)
        response = hive_consistency_fixer.fix_all()

        # Then
        self.assertIsNotNone(response)
        self.assertEqual(2, len(response))
        self.assertIsNotNone(response[DatabaseType.CUSTOMER])
        self.assertIsNotNone(response[DatabaseType.SHARED])
        self.assertEqual(2, len(response[DatabaseType.CUSTOMER]))
        self.assertEqual(3, len(response[DatabaseType.SHARED]))
        self.assertTrue(response[DatabaseType.CUSTOMER])
