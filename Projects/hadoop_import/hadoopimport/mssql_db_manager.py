import pymssql as ms_sql
from pymssql import Connection, Cursor

from db_manager_new import DbConnNamespace, DbConnType, DbManager, DbName
from db_conn_conf import DbConnConf
from query_type import QueryType
from query_category import QueryCategory


class MsSqlDbName:
    APPLICATION_METADATA = "APPLICATION_METADATA"
    CHANGE_TRACKING = "CHANGE_TRACKING"
    SUBSCRIPTIONS = "SUBSCRIPTIONS"


class MsSqlDbConfigProperty:
    MAX_RETRIES = "max_retries"
    DB_DOMAIN = "db_domain"


class MsSqlDbConnConf(DbConnConf):
    def __init__(self, db_name, db_server, db_domain=None, db_port=None, db_user=None, db_password=None):
        """

        :type db_name: str
        :type db_server: str
        :type db_domain: str
        :type db_port: str
        :type db_user: str
        :type db_password: str
        """
        DbConnConf.__init__(self, db_name, db_server, db_port, db_user, db_password)
        self.db_domain = db_domain


class MsSqlDbManager(DbManager):
    """
    A DbManager for MS SQL
    """
    JDBC_JTDS_CONNECTION_STRING = "jdbc:jtds:sqlserver://%s:%s/%s;user=%s;password=%s;domain=%s"

    def __init__(self, db_name=None):
        DbManager.__init__(self, DbConnType.MSSQL, db_name)

    def _get_query_result(self, cursor, query):
        """
        Returns a query result according to the db type and query type

        :type cursor: Cursor
        :param query: str
        :rtype: list of dict
        """
        if QueryType.get_query_type(query) == QueryType.INSERT:
            return cursor.lastrowid
        elif QueryCategory.get_query_category(query) == QueryCategory.DQL:
            return cursor.fetchall()
        elif QueryCategory.get_query_category(query) == QueryCategory.DML:
            return cursor.rowcount
        else:
            return None

    def _create_connection(self, db_conn_conf):
        """
        Creates a MS SQL connection

        :type db_conn_conf: DbConnConf
        :rtype: Connection
        :raises Exception: If reaches max number of retries
        """

        config_section = self.config.get_section_name(DbConnNamespace.DBCONN, DbConnType.MSSQL)
        retry = int(self.config.get(config_section, MsSqlDbConfigProperty.MAX_RETRIES))
        ex = None
        while retry > 0:
            try:
                conn = ms_sql.connect(host=db_conn_conf.db_server,
                                      port=db_conn_conf.db_port,
                                      user=db_conn_conf.db_user,
                                      password=db_conn_conf.db_password,
                                      database=db_conn_conf.db_name,
                                      autocommit=True)
                return conn
            except Exception as exception:
                retry = retry - 1
                ex = exception
        raise Exception("Reached max number of MS SQL conn retries. Original exception: %s" % ex)

    def get_db_conn_conf_for_conn_name(self, db_conn_name=DbName.DEFAULT):
        """
        :type db_conn_name: str
        :rtype: MsSqlDbConnConf
        """
        return self._get_db_conn_conf_for_db_conn_props(self._get_db_conn_props_from_config_file(db_conn_name))

    def get_db_cursor(self, conn=None):
        """

        :type conn: Connection
        :rtype: Cursor
        """
        if conn is None:
            conn = self.get_db_connection()
        return conn.cursor(as_dict=True)

    def _get_db_conn_conf_for_db_conn_props(self, db_config):
        """

        :type db_config: dict of str:str
        :rtype: MsSqlDbConnConf
        """
        return MsSqlDbConnConf(db_name=db_config["db_name"],
                               db_server=db_config["db_server"],
                               db_domain=db_config["db_domain"],
                               db_port=db_config["db_port"],
                               db_user=db_config["db_user"],
                               db_password=db_config["db_password"])

    def get_jdbc_conn_string(self, mssql_db_conn_conf):
        """

        :type mssql_db_conf: MsSqlDbConnConf
        :rtype: str
        """
        self._add_credentials(mssql_db_conn_conf)
        db_user_domain, db_user = mssql_db_conn_conf.db_user.split("\\")

        return MsSqlDbManager.JDBC_JTDS_CONNECTION_STRING % (mssql_db_conn_conf.db_server,
                                                             mssql_db_conn_conf.db_port,
                                                             mssql_db_conn_conf.db_name,
                                                             db_user,
                                                             mssql_db_conn_conf.db_password,
                                                             db_user_domain)
