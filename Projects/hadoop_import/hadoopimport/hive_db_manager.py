from impala import dbapi
from impala.hiveserver2 import HiveServer2Connection, HiveServer2Cursor
from db_conn_conf import DbConnConf
from db_manager_new import DbConnType, DbManager, DbName
from query_category import QueryCategory


class HiveDbName:
    ETL = "etl"


class HiveConfigProperty:
    DB_METASTORE = "db_metastore"


class HiveDbConnConf(DbConnConf):

    def __init__(self, db_name, db_server, db_metastore, db_port=None, db_user=None, db_password=None):
        """

        :type db_name: str
        :type db_server: str
        :type db_metastore: str
        :type db_port: str
        :type db_user: str
        :type db_password: str
        """
        DbConnConf.__init__(self, db_name, db_server, db_port, db_user, db_password)
        self.db_metastore = db_metastore


class HiveDbManager(DbManager):
    """
    A DbManager for Hive
    """
    CREATE_DB_IF_NOT_EXISTS_QUERY = "CREATE DATABASE IF NOT EXISTS %s"
    HIVE_AUTH_MECHANISM = "PLAIN"

    def __init__(self, db_name=None):
        DbManager.__init__(self, DbConnType.HIVE, db_name)

    def get_db_conn_conf_for_conn_name(self, db_conn_name=DbName.DEFAULT):
        """
        :type db_conn_name: str
        :rtype: HiveDbConnConf
        """
        return self._get_db_conn_conf_for_db_conn_props(self._get_db_conn_props_from_config_file(db_conn_name))

    def get_db_cursor(self, conn=None):
        """

        :type conn: HiveServer2Connection
        :rtype: HiveServer2Cursor
        """
        if conn is None:
            conn = self.get_db_connection()
        return conn.cursor(dictify=False)

    def _get_query_result(self, cursor, query):
        """
        Returns a query result according to the db type and query type

        :type cursor: HiveServer2Cursor
        :param query: str
        :rtype: list of dict
        """
        if QueryCategory.get_query_category(query) == QueryCategory.DQL:
            return cursor.fetchall()
        else:
            return None

    def _create_connection(self, db_conn_conf):
        """
        Creates a Hive connection

        :type db_conn_conf: DbConnConf
        :rtype: HiveServer2Connection
        :raises Exception: If reaches max number of retries
        """
        self.logger.debug("Create Hive Connection: %s" % db_conn_conf.db_name)
        return dbapi.connect(host=db_conn_conf.db_server,
                             port=db_conn_conf.db_port,
                             database=db_conn_conf.db_name,
                             user=db_conn_conf.db_user,
                             auth_mechanism=HiveDbManager.HIVE_AUTH_MECHANISM)

    def _get_db_conn_conf_for_db_conn_props(self, db_config):
        """

        :type db_config: dict of str:str
        :rtype: HiveDbConnConf
        """
        return HiveDbConnConf(db_name=db_config.get("db_name"),
                              db_server=db_config["db_server"],
                              db_metastore=db_config["db_metastore"],
                              db_port=db_config.get("db_port"),
                              db_user=db_config["db_user"],
                              db_password=db_config["db_password"])

