from config import Config
from database_type import DatabaseType
from db_definition_repository import DbDefinitionRepository
from ingestible_db_repository import IngestibleDbConfRepository
from hive_db_manager import HiveDbManager


class HiveCustomerRepository:
    DROP_HIVE_CUSTOMER_PARTITION = """
      ALTER TABLE 
        {0}
      DROP IF EXISTS PARTITION(partitioncustomerid={1})
    """

    def __init__(self, ingestion_group):
        """

        :type ingestion_group: int
        """
        self.ingestion_group = ingestion_group
        self.config = Config()
        self.hive_db_mgr = HiveDbManager()
        self.db_definition_repo = DbDefinitionRepository()
        self.ingestible_db_repo = IngestibleDbConfRepository(self.ingestion_group)
        self.target_db_names = self.ingestible_db_repo.get_target_db_names()
        self.logger = self.config.get_logger(__package__)

    def remove_deactivated_customer_data(self, customer_ids):
        """
        Returns a set of the customer ids that fail the remove operation
        :type customer_ids: set of int
        :rtype: set of int
        """

        self.logger.debug(
            "HiveCustomerRepository - Remove hive customer partitions: %s" % customer_ids)
        failed_customer_ids = set()
        table_names = self.db_definition_repo.get_db_definition(DatabaseType.CUSTOMER)
        target_db_name = self.target_db_names[DatabaseType.CUSTOMER]

        for table_name in table_names:
            table_name = table_name.lower()
            for customer_id in customer_ids:
                try:
                    customer_data_delete = self.DROP_HIVE_CUSTOMER_PARTITION.format(table_name, str(customer_id))
                    self.hive_db_mgr.execute_query(customer_data_delete, db_name=target_db_name)

                except Exception as ex:
                    failed_customer_ids.add(customer_id)
                    self.logger.error('Failed to remove customer %s from the table %s', str(customer_id), table_name)
                    self.logger.exception(ex)

        return failed_customer_ids
