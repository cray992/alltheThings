from config import Config
from mssql_db_manager import MsSqlDbManager
from ingestible_db_repository import IngestibleDbConfRepository
from ingestible_db_table_conf import IngestibleDbTableConf
from ingestible_db_conf import IngestibleDbConf
from ingestion_group import IngestionGroup
from database_type import DatabaseType
from environment import Environment
from customer_subscription import CustomerSubscription
from customer_subscription_repository import CustomerSubscriptionRepository
from ingestion_job_repository import IngestionJobRepository
from ingestion_job_status import IngestionJobStatus
from ingestion_job_type import IngestionJobType
from db_definition_repository import DbDefinitionRepository


class IngestibleDbTableListGenerator:

    def __init__(self, ingestion_group, ingestion_job_type):
        self.ingestion_group = ingestion_group
        self.ingestion_job_type = ingestion_job_type
        self.config = Config()
        self.environment = self.config.get_global_environment()
        self.logger = self.config.get_logger(__package__)
        self.customer_db_repo = CustomerSubscriptionRepository(self.ingestion_group)
        self.ingestible_db_conf_repo = IngestibleDbConfRepository(self.ingestion_group)
        self.ingestion_job_repo = IngestionJobRepository()
        self.all_last_jobs = self.ingestion_job_repo.get_last_job_all_db_tables()
        self.db_definition_repo = DbDefinitionRepository()
        self.mssql_db_mgr = MsSqlDbManager()
        self.default_db_conn_conf = self.mssql_db_mgr.get_db_conn_conf_for_conn_name()
        self.target_db_names = self.ingestible_db_conf_repo.get_target_db_names()
        self.tables_to_import_by_db_type = self._get_tables_to_import_by_db_type()

    def get_ingestible_db_tables(self):
        self.logger.info("##### STARTING TO GENERATE DB TABLES #####")
        self.logger.debug("Get Ingestible Db Tables, Ingestion Group: %s" % self.ingestion_group)
        ingestible_db_table_confs = self.get_all_db_tables()
        return filter(self._is_eligible_for_ingestion, ingestible_db_table_confs)


    def get_all_dbs(self):
        """

        :rtype: list of IngestibleDbconf
        """

        customer_subscriptions = self.customer_db_repo.get_customer_subscriptions(
            include_children=(self.ingestion_group == IngestionGroup.KA))
        customer_dbs = [self._build_customer_ingestible_db_conf(subscription)
                        for subscription in customer_subscriptions]

        non_customer_dbs = [ingestible_db_conf
                            for ingestible_db_conf in
                            self.ingestible_db_conf_repo.get_ingestible_dbs()
                            if ingestible_db_conf.db_type != DatabaseType.CUSTOMER]
        return customer_dbs + non_customer_dbs

    def get_all_db_tables(self):
        """
        :rtype: list of IngestibleDbTableConf
        """
        all_ingestible_db_confs = self.get_all_dbs()
        return [self._build_ingestible_db_table_conf(ingestible_db_conf, table_name)
                for ingestible_db_conf in all_ingestible_db_confs
                for table_name in self.tables_to_import_by_db_type[ingestible_db_conf.db_type]]

    def _build_customer_ingestible_db_conf(self, subscription):
        """
        :type subscription: CustomerSubscription
        :rtype: dict of IngestibleDbConf
        """
        self.logger.debug("Build Ingestible Db Conf from Customer Subscription: %s" % subscription)
        return IngestibleDbConf(customer_id=subscription.customer_id,
                                db_name=subscription.db_name,
                                db_server=self._add_domain_to_db_server(subscription.db_server),
                                db_port=self._get_db_port(subscription.db_server),
                                target_db_name=self.target_db_names[DatabaseType.CUSTOMER],
                                db_type=DatabaseType.CUSTOMER)

    def _add_domain_to_db_server(self, db_server):
        """
        :type db_server: str
        :rtype: str
        """
        self.logger.debug("Add domain to db server: %s" % db_server)
        return db_server.lower() + "." + self.default_db_conn_conf.db_domain

    def _build_ingestible_db_table_conf(self, ingestible_db_conf, table_name):
        """

        :type ingestible_db_conf: IngestibleDbConf
        :type table_name: str
        :rtype: IngestibleDbTableConf
        """
        return IngestibleDbTableConf(db_conf_id=ingestible_db_conf.db_conf_id,
                                     db_name=ingestible_db_conf.db_name,
                                     db_server=ingestible_db_conf.db_server,
                                     target_db_name=ingestible_db_conf.target_db_name,
                                     db_type=ingestible_db_conf.db_type,
                                     db_port=ingestible_db_conf.db_port,
                                     customer_id=ingestible_db_conf.customer_id,
                                     table_name=table_name)

    def _get_db_port(self, db_server):
        """
        :type db_server: str
        :rtype: int
        """
        self.logger.debug("Get DB port for DB server: %s" % db_server)
        if not Environment.is_production_environment(self.environment):
            return int(self.default_db_conn_conf.db_port)
        else:
            return 4700 + int(db_server[-2:])

    def _get_tables_to_import_by_db_type(self):
        """

        :type ingestion_group: int
        :rtype: dict of int:list of str
        """
        self.logger.debug("Get Tables to Import by DB Type")
        return dict(map(lambda db_type: (db_type, self.db_definition_repo.get_db_definition(db_type).keys()),
                        self.ingestible_db_conf_repo.get_ingestible_db_types()))

    def _is_eligible_for_ingestion(self, ingestible_db_table_conf):
        """

        :type ingestible_db_table_conf: IngestibleDbTableConf
        :rtype: bool
        """
        last_job = self.all_last_jobs.get(
            "{0}.{1}".format(ingestible_db_table_conf.db_name, ingestible_db_table_conf.table_name))
        if self.ingestion_job_type == IngestionJobType.FULL:
            if last_job:
                if last_job.status == IngestionJobStatus.STALE:
                    return True
                elif last_job.ingestion_job_type == IngestionJobType.FULL and \
                    last_job.status != IngestionJobStatus.SUCCESS:
                    return True
                else:
                    return False
            else:
                return True
        elif self.ingestion_job_type == IngestionJobType.INCREMENTAL:
            if last_job:
                if last_job.ingestion_job_type in [IngestionJobType.PERSIST] and \
                        last_job.status in [IngestionJobStatus.SUCCESS]:
                    return True
                if last_job.ingestion_job_type in [IngestionJobType.MERGE, IngestionJobType.INCREMENTAL]:
                    return True
                else:
                    return False
            else:
                return False
