import random

from mock import Mock

from hadoopimport.database_type import DatabaseType
from hadoopimport.ingestible_db_repository import IngestibleDbConfRepository
from hadoopimport.ingestion_group import IngestionGroup
from hadoopimport.tests.base_test_case import BaseTestCase


class IngestibleDbConfRecordBuilder:
    def __init__(self):
        self.ingestible_db_conf_id = random.randint
        self.target_db_name = "hive_test"
        self.db_name = "sql_db_name"
        self.db_server = "sql_server"
        self.db_port = "1"
        self.ingestion_group = IngestionGroup.KA

    def build(self, db_type):
        return {
            "IngestibleDbId": self.ingestible_db_conf_id,
            "DbTypeId": db_type,
            "SourceDbName": self.db_name,
            "SourceDbServer": self.db_server,
            "SourceDbPort": self.db_port,
            "TargetDbName": self.target_db_name
        }

    def with_ingestion_group(self, ingestion_group):
        self.ingestion_group = ingestion_group


class IngestibleDbConfTest(BaseTestCase):

    def setUp(self):
        self.ingestion_group = IngestionGroup.KA
        self.db_type = DatabaseType.CUSTOMER

        # Classes / attributes to mock
        self.mock_mssql_db_mgr = self.get_mock("hadoopimport.ingestible_db_repository.MsSqlDbManager")

    def test_get_ingestible_db_conf_by_ingestion_group(self):
        # Given
        ingestible_db_builder = IngestibleDbConfRecordBuilder()

        ingestible_dbs = [ingestible_db_builder.build(DatabaseType.CUSTOMER), ingestible_db_builder.build(DatabaseType.SHARED)]

        ingestible_db_repo = IngestibleDbConfRepository(self.ingestion_group)
        self.mock_mssql_db_mgr.execute_query.return_value = ingestible_dbs

        # When
        results = ingestible_db_repo.get_ingestible_dbs()

        # Then
        self.mock_mssql_db_mgr.execute_query.assert_called_once()
        self.assertEquals(len(results), 2)
        self.assertEquals(results[0].db_conf_id, ingestible_dbs[0]['IngestibleDbId'])