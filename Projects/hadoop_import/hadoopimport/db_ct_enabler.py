from config import Config
from customer_subscription_repository import CustomerSubscriptionRepository
from db_ct_conf_repository import DbCTConfRepository
from ingestion_group import IngestionGroup
from mssql_db_manager import MsSqlDbManager, MsSqlDbName


class DbCTEnabler:

    def __init__(self):
        self.config = Config()
        self.logger = self.config.get_logger(__package__)
        self.ct_db_mgr = MsSqlDbManager(db_name=MsSqlDbName.CHANGE_TRACKING)
        self.db_ct_conf_repo = DbCTConfRepository()
        self.ENABLE_TABLE_CT_SPROC = "sp_enablect_com03"

    def _run_enable_ct_sproc(self):
        """
        This stored procedure (SPROC) takes the cross product of:
        a) HDP_DatabasesToImport with dbEnabled=0
        b) HDP_TablesToImport

        NOTE: dbEnabled is used by the SPROC to keep track of dbs that had been enabled.
        The SPROC only processes entries with dbEnabled=0, and for each one it sets dbEnabled=1 once it enables it.
        This dbEnabled flag is meant to be reset to 0 in case the set of tables to be imported changes.

        :return: None
        """
        self.ct_db_mgr.execute_query("EXEC %s" % self.ENABLE_TABLE_CT_SPROC)

    def _get_db_key(self, db_name, db_server):
        """

        :return: A string hash key for a db name and db server
        :rtype: str
        """
        return "{0}|{1}".format(db_name, db_server.upper())


    def _create_db_ct_confs(self, ingestion_group):
        """

        :type: ingestion_group: int
        :return: None
        """
        self.logger.info("Enable Change Tracking for new DBs, Ingestion Group: %s" % ingestion_group)
        customer_subscriptions_repo = CustomerSubscriptionRepository(ingestion_group)
        customer_subscriptions = customer_subscriptions_repo.get_customer_subscriptions(include_children=(ingestion_group == IngestionGroup.KA))

        db_ct_confs = self.db_ct_conf_repo.get_db_ct_confs()
        enabled_customers = dict(
            map(lambda db_ct_conf: (self._get_db_key(db_ct_conf.db_name, db_ct_conf.db_server), db_ct_conf), db_ct_confs)
        )
        dbs_to_enable = filter(lambda s: self._get_db_key(s.db_name, s.db_server) not in enabled_customers, customer_subscriptions)

        self.logger.info("Number of Customer DBs to enable: %s" % len(dbs_to_enable))
        map(lambda db: self.db_ct_conf_repo.create_db_ct_conf(db_server=db.db_server, db_name=db.db_name), dbs_to_enable)


    def enable_ct_for_all_dbs(self, ingestion_group):
        self._create_db_ct_confs(ingestion_group)
        self._run_enable_ct_sproc()