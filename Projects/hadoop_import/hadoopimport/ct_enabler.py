from config import Config, ConfigNamespace
from mssql_db_manager import MsSqlDbManager
from ingestion_type import IngestionType
from ingestible_db_table_list_generator import IngestibleDbTableListGenerator
from ingestible_db_table_conf import IngestibleDbTableConf


class CTConfigProperty:
    RETENTION_HOURS_CONFIG = "change_tracking_retention_hours"


class CTEnabler:
    IS_DB_CT_ENABLED_QUERY = """
                SELECT DATABASE_ID FROM SYS.CHANGE_TRACKING_DATABASES WHERE DATABASE_ID = DB_ID()
            """
    IS_TABLE_CT_ENABLED_QUERY = """
                SELECT T.OBJECT_ID as TABLE_ID FROM SYS.TABLES T 
                JOIN SYS.CHANGE_TRACKING_TABLES CTT ON T.OBJECT_ID = CTT.OBJECT_ID 
                WHERE LTRIM(RTRIM(LOWER(T.NAME))) = '{0}'
            """
    ENABLE_DB_CT_QUERY = """
                ALTER DATABASE CURRENT SET CHANGE_TRACKING = ON (AUTO_CLEANUP = ON, CHANGE_RETENTION = {0} HOURS);
            """
    ENABLE_TABLE_CT_QUERY = """
                ALTER TABLE [dbo].[{0}] ENABLE CHANGE_TRACKING WITH(TRACK_COLUMNS_UPDATED = OFF)
            """

    def __init__(self):
        self.config = Config()
        self.logger = self.config.get_logger(__package__)
        self.mssql_db_mgr = MsSqlDbManager()
        self.retention_hours = int(self.config.get(ConfigNamespace.INGESTION, CTConfigProperty.RETENTION_HOURS_CONFIG))

    def _is_db_ct_enabled(self, db_conn_conf):
        """

        :type db_conn_conf: DbConnConf
        :rtype: bool
        """
        self.logger.debug("Get DBs with CT enabled, Db Conn Conf: %s" % db_conn_conf)
        result = self.mssql_db_mgr.execute_query(CTEnabler.IS_DB_CT_ENABLED_QUERY, db_conn_conf=db_conn_conf)
        return len(result) == 1

    def _is_table_ct_enabled(self, ingestible_db_table_conf):
        """

        :type ingestible_db_table_conf: IngestibleDbTableConf
        :rtype: bool
        """
        query = CTEnabler.IS_TABLE_CT_ENABLED_QUERY.format(ingestible_db_table_conf.table_name)
        result = self.mssql_db_mgr.execute_query(query, db_conn_conf=ingestible_db_table_conf)
        return len(result) == 1

    def _enable_db_ct(self, db_conn_conf):
        """

        :type db_conn_conf: DbConnConf
        :rtype: None
        """
        self.logger.debug("Enable DB CT, Db Conn Conf: %s" % db_conn_conf)
        enable_table_db_query = CTEnabler.ENABLE_DB_CT_QUERY.format(self.retention_hours)
        try:
            self.mssql_db_mgr.execute_query(enable_table_db_query, db_conn_conf=db_conn_conf)
        except Exception as ex:
            self.logger.error("Failed to enable DB CT, Db Conn Conf: %s" % db_conn_conf)
            self.logger.error(ex)
            self.logger.exception(ex)

    def _enable_table_ct(self, ingestible_db_table_conf):
        """

        :type ingestible_db_table_conf: IngestibleDbTableConf
        :rtype: None
        """
        self.logger.debug("Enable Table CT, Ingestible Db Table Conf: %s" % ingestible_db_table_conf)
        enable_table_ct_query = CTEnabler.ENABLE_TABLE_CT_QUERY.format(ingestible_db_table_conf.table_name)
        try:
            self.mssql_db_mgr.execute_query(enable_table_ct_query, db_conn_conf=ingestible_db_table_conf)
        except Exception as ex:
            self.logger.error("Failed to enable CT, Ingestible Db Table Conf: %s" % ingestible_db_table_conf)
            self.logger.error(ex)
            self.logger.exception(ex)

    def enable_ct_for_all_dbs(self, ingestion_group):
        """

        :type: ingestion_group: int
        :return: None
        """
        self.logger.info("Enable Change Tracking for all DB")
        self.logger.debug("Enable Change Tracking for all DBs, Ingestion Group: %s" % ingestion_group)
        ingestible_db_list_generator = IngestibleDbTableListGenerator(ingestion_group, IngestionType.INCREMENTAL)

        ingestible_db_table_confs = ingestible_db_list_generator.get_all_db_tables()

        for ingestible_db_table_conf in ingestible_db_table_confs:
            self.logger.debug("Enable CT, Ingestible DB Table Conf: %s" % ingestible_db_table_conf)
            # Enable DB CT if disabled
            if not self._is_db_ct_enabled(ingestible_db_table_conf):
                self._enable_db_ct(ingestible_db_table_conf)

            # Enable CT for tables with CT disabled
            if not self._is_table_ct_enabled(ingestible_db_table_conf):
                self._enable_table_ct(ingestible_db_table_conf)