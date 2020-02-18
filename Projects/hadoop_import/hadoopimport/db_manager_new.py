from abc import ABCMeta, abstractmethod

from config import Config
from db_conn_conf import DbConnConf


class SQLException(Exception):
    pass


class DbConnNamespace:
    DBCONN = "DB"


class DbConnType:
    MSSQL = "MSSQL"
    HIVE = "HIVE"


class DbName:
    DEFAULT = "default"


class DbManager:
    __metaclass__ = ABCMeta

    def __init__(self, db_type, db_name=None):
        self.db_type = db_type
        self.db_name = db_name
        self.db_conn_pool = {}
        self.config = Config()
        self.logger = Config.get_logger(__package__)

    def __del__(self):
        for db_conn in self.db_conn_pool.values():
            db_conn.close()

    def get_db_connection(self, db_conn_conf=None, db_name=None):
        """
        Creates a connection for a DB and adds it to the pool

        :type db_conn_conf: DbConnConf
        :type db_name: str
        :rtype: Connection
        """
        db_conn_conf = self._resolve_db_conn_conf(db_conn_conf, db_name)
        db_conn_conf_key = self._get_db_conn_conf_pool_key(db_conn_conf)
        if db_conn_conf_key not in self.db_conn_pool:
            self.db_conn_pool[db_conn_conf_key] = self._create_connection(db_conn_conf)
        return self.db_conn_pool[db_conn_conf_key]

    def _get_db_conn_conf_pool_key(self, db_conn_conf):
        """

        :type db_conn_conf: DbConnConf
        :rtype: str
        """
        return "{0}|{1}|{2}".format(db_conn_conf.db_server, db_conn_conf.db_port, db_conn_conf.db_name)

    def get_db_conn_conf_for_conn_name(self, db_conn_name=DbName.DEFAULT):
        """
        :type db_conn_name: str
        :rtype: DbConnConf
        """
        return self._get_db_conn_conf_for_db_conn_props(self._get_db_conn_props_from_config_file(db_conn_name))

    def _get_db_conn_props_from_config_file(self, db_name):
        """

        :type db_name:
        :rtype: dict of str:str
        """
        section_name = self.config.get_section_name(DbConnNamespace.DBCONN, self.db_type, db_name)
        config_section = self.config.get_section_with_common(section_name)
        if "db_name" not in config_section:
            config_section["db_name"] = db_name
        return config_section

    def _add_credentials(self, db_conn_conf):
        """

        :type db_conn_conf: DbConnConf
        :rtype: DbConnConf
        """
        default_db_conn_conf = self.get_db_conn_conf_for_conn_name()
        if not db_conn_conf.db_user:
            db_conn_conf.db_user = default_db_conn_conf.db_user
        if not db_conn_conf.db_password:
            db_conn_conf.db_password = default_db_conn_conf.db_password
        return db_conn_conf

    def _resolve_db_conn_conf(self, db_conn_conf=None, db_name=None):
        """

        :type db_conn_conf: DbConnConf
        :type db_name: str
        :rtype: DbConnConf
        """
        if db_conn_conf:
            self._add_credentials(db_conn_conf)
            return db_conn_conf
        elif db_name:
            return self.get_db_conn_conf_for_conn_name(db_name)
        elif self.db_name:
            return self.get_db_conn_conf_for_conn_name(self.db_name)
        else:
            return self.get_db_conn_conf_for_conn_name()

    def execute_query(self, query, query_params=None, db_conn_conf=None, db_name=None):
        """
        Executes a query

        :type query: str
        :type query_params: dict
        :type db_conn_conf: DbConnConf
        :type db_name: str
        :rtype: list of dict
        :raises: SQLException
        """
        try:
            db_conn = self.get_db_connection(db_conn_conf=db_conn_conf, db_name=db_name)
            with self.get_db_cursor(db_conn) as cursor:
                self.logger.debug("Execute query %s, params %s, DB Conn Conf %s" % (query, query_params, db_conn_conf))
                cursor.execute(query, query_params)
                return self._get_query_result(cursor, query)
        except Exception as ex:
            self.logger.error("Failed to execute query, Db Conn Conf: %s, Query: %s", (db_conn_conf, query))
            self.logger.exception(ex)
            raise SQLException(ex)

    def execute_script(self, script, db_conn_conf=None, db_name=None):
        """
        Executes a sql script semicolon separated. It takes care of stripping out spaces.
        Internally it reuses a single db cursor and executes the statements sequentially.

        :type query: str
        :type query_params: dict
        :type db_conn_conf: DbConnConf
        :type db_name: str
        :rtype: list of dict
        :raises: SQLException
        """
        self.logger.debug("Execute SQL Script: %s" % script)

        # Prepare script
        prepared_script = " ".join(script.splitlines()).split(";")
        last_query = None
        try:
            db_conn = self.get_db_connection(db_conn_conf=db_conn_conf, db_name=db_name)
            with self.get_db_cursor(db_conn) as cursor:
                for sql in prepared_script:
                    if sql and not sql.isspace():
                        sql = sql.strip()
                        last_query = sql
                        self.logger.debug("Executing query %s" % sql)
                        cursor.execute(sql)
        except Exception as ex:
            self.logger.error("Failed to execute query, Db Conn Conf: %s, Query: %s", (db_conn_conf, last_query))
            self.logger.exception(ex)
            raise SQLException(ex)

    @abstractmethod
    def get_db_cursor(self, conn=None):
        """

        :type conn: Connection
        :rtype: Cursor
        """
        raise NotImplementedError

    @abstractmethod
    def _get_db_conn_conf_for_db_conn_props(self, db_config):
        """
        Returns the DB connection config from config.ini for the given DB name

        :type db_config: dict of str:str
        :rtype: DbConnConf
        """
        raise NotImplementedError

    @abstractmethod
    def _get_query_result(self, cursor, query):
        """

        :type cursor: Cursor
        :type query: str
        :rtype: list of dict
        """
        raise NotImplementedError

    @abstractmethod
    def _create_connection(self, db_config):
        """

        :type db_config: dict
        :rtype: Connection
        """
        raise NotImplementedError
