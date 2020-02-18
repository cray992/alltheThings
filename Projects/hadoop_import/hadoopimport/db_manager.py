import pymssql as mssql
import impala.dbapi as hive

from config import Config


class SQLException(Exception):
    pass

class DbManager:
    db_conn_pool = {}

    MSSQL_TYPE = "mssql"
    HIVE_TYPE = "hive"
    HIVE_AUTH_MECHANISM = "PLAIN"
    MSSQL_DB_SERVER_DOMAIN = "mssql_db_server_domain"

    CREATE_DB_IF_NOT_EXISTS_QUERY = "CREATE DATABASE IF NOT EXISTS %s"

    JDBC_JTDS_CONNECTION_STRING = "jdbc:jtds:sqlserver://%s/%s;user=%s;password=%s;domain=%s"

    def __init__(self):
        self.config = Config()
        self.logger = self.config.get_logger(__package__)
        self.initialize_db_connections(self.config.get_all_db_configurations())

    def get_db_conn_properties(self, conn_name):
        self.logger.info("Get DB conn properties")
        self.logger.debug("Conn name %s" % conn_name)
        if self.db_conn_pool[conn_name] is not None:
            return dict(self.db_conn_pool[conn_name])

        return None

    def get_hive_dbs(self):
        self.logger.info("Get Hive DBs")
        hive_dbs = []
        for conn in self.db_conn_pool.itervalues():
            if conn["db_name"] and (conn["db_type"] == self.HIVE_TYPE):
                hive_dbs.append(dict(conn))

        self.logger.debug("Hive DBs: %s" % hive_dbs)
        return hive_dbs

    def execute_query_with_connection(self, connection_name, query, query_params=None):
        """

        :type connection_name: str
        :type query: str
        :type query_params: dict
        :rtype: list of dict
        """
        self.logger.info("Execute query with connection")
        self.logger.debug("Connection name: %s \nquery: %s \nquery params: %s" % (connection_name, query, query_params))

        query = query.strip()
        if connection_name in self.db_conn_pool:
            if self.db_conn_pool[connection_name]["db_type"] == self.HIVE_TYPE:
                return self.execute_hive_query(connection_name, query, query_params)
            else:
                return self.execute_mssql_query(connection_name, query, query_params)
        else:
            raise ValueError("The connection name must match the name of the connection in the configuration file")

    def execute_mssql_query(self, connection_name, query, query_params=None):
        self.logger.info("Execute mssql query")
        query = query.strip()
        self.logger.debug("Connection name: %s\n\tquery: %s\n\tquery params: %s" % (connection_name, query, query_params))
        try:
            with self.get_db_conn(connection_name).cursor(as_dict=True) as cursor:
                if query_params is not None:
                    cursor.execute(query, query_params)
                else:
                    cursor.execute(query)
                return self.mssql_query_result(cursor, query)

        except Exception as ex:
            self.logger.error("Failed to execute mssql query %s", query)
            self.logger.error(ex)
            raise SQLException(ex)

    def execute_hive_query(self, connection_name, query, query_params=None):
        self.logger.info("Execute Hive query")
        self.logger.debug("Connection name: %s\n\tquery: %s\n\tquery params: %s" % (connection_name, query, query_params))
        try:
            with self.get_db_conn(connection_name).cursor() as cursor:
                if query_params is not None:
                    cursor.execute(query, query_params)
                else:
                    cursor.execute(query)

                return self.hive_query_result(cursor, query)
        except Exception as ex:
            self.logger.error("Failed to execute hive query %s", query)
            self.logger.error(ex)
            raise SQLException(ex)

    def execute_hive_script_file(self, connection_name, f):
        self.logger.info("Execute Hive script file")
        self.logger.debug("Connection name: %s, file: %s" % (connection_name, f))
        with open(f, 'r') as script_file:
            self.execute_hive_script(connection_name, script_file.read())

    def execute_hive_script(self, connection_name, script):
        self.logger.info("Execute Hive script")
        self.logger.debug("Connection name: %s\nScript: %s" % (connection_name, script))
        prepared_script = self.prepare_script_for_execution(script)

        for sql in prepared_script:
            if sql and not sql.isspace():
                sql = sql.strip()
                self.execute_hive_query(connection_name, sql)

    @staticmethod
    def get_mssql_db_server_domain():
        config = Config()
        return config.get("DB_COMMON", DbManager.MSSQL_DB_SERVER_DOMAIN)

    @staticmethod
    def get_mssql_connection_string(db_host, db_name):
        config = Config()
        db_user = config.get("DB_COMMON", "mssql_user")
        db_pass = config.get("DB_COMMON", "mssql_passwd")

        db_user_domain, db_user = db_user.split("\\")

        return DbManager.JDBC_JTDS_CONNECTION_STRING % (db_host, db_name, db_user, db_pass, db_user_domain)

    @staticmethod
    def prepare_script_for_execution(script):
        script = ' '.join(script.splitlines())
        return script.split(';')

    @staticmethod
    def mssql_query_result(cursor, query):
        statement_type = query[0:3].upper()

        # If the query is an INSERT return the id of the row that was just inserted
        if statement_type == "ALT" or statement_type == "UPD" or statement_type == "DRO" or statement_type == "CRE" or statement_type == "TRU":
            return None
        elif statement_type == "INS":
            return cursor.lastrowid
        else:
            return cursor.fetchall()

    @staticmethod
    def hive_query_result(cursor, query):
        statement_type = query[0:3].upper()

        # If the query is an INSERT return the id of the row that was just inserted
        if statement_type == "UPD" or statement_type == "DRO" or statement_type == "CRE" \
                or statement_type == "TRU" or statement_type == "MER" or statement_type == "ALT":
            return None
        elif statement_type == "INS":
            return None
        else:
            return cursor.fetchall()

    def get_hive_cursor(self):
        return self.get_db_conn("hive").cursor()

    def get_conn_name(self, server, port, db_name):
        """

        :type server:
        :type port:
        :type db_name:
        :rtype: str
        """
        return server + str(port) + db_name

    def add_mssql_db_conn_to_pool(self, server, port, db_name):
        """
        Adds a new MS SQL conn to the pool

        :type server: str
        :type port: str
        :type db_name: str
        :returns: Connection name
        :rtype: str
        """
        conn_name = self.get_conn_name(server, port, db_name)
        mssql_user = self.config.get("DB_COMMON", "mssql_user")
        mssql_passwd = self.config.get("DB_COMMON", "mssql_passwd")
        self.add_db_conf_to_pool(server, port, db_name, mssql_user, mssql_passwd, DbManager.MSSQL_TYPE, conn_name)
        return conn_name

    # 'Private' members. Cannot block these methods from being called in Python, but these
    # are meant for internal use of this class only.
    def add_db_conf_to_pool(self, server, port, db_name, user, passwd, db_type, conn_name=None):
        self.logger.info("Add DB conf to pool")
        self.logger.debug("Server: %s, port: %s, db name: %s, user: %s, db type: %s, conn name: %s" % (
            server, port, db_name, user, db_type, conn_name))

        if conn_name is None:
            conn_name = self.get_conn_name(server, port, db_name)

        if conn_name in self.db_conn_pool:
            pass
        else:
            self.db_conn_pool[conn_name] = {}
            self.db_conn_pool[conn_name]["db_conn"] = None
            self.db_conn_pool[conn_name]["db_type"] = db_type
            self.db_conn_pool[conn_name]["db_server"] = server
            self.db_conn_pool[conn_name]["db_port"] = port
            self.db_conn_pool[conn_name]["db_name"] = db_name
            self.db_conn_pool[conn_name]["db_user"] = user
            self.db_conn_pool[conn_name]["db_passwd"] = passwd

    def get_db_conn(self, conn_name):
        self.logger.info("Get DB conn")
        self.logger.debug("Conn name: %s" % conn_name)
        if not conn_name:
            raise ValueError("A valid connection name is required")

        if conn_name not in self.db_conn_pool:
            raise ValueError("Database Connection '%s' cannot be found in config.ini" % conn_name)

        if self.db_conn_pool[conn_name]["db_conn"] is None:
            server = self.db_conn_pool[conn_name]["db_server"]
            port = self.db_conn_pool[conn_name]["db_port"]
            db_name = self.db_conn_pool[conn_name]["db_name"]
            user = self.db_conn_pool[conn_name]["db_user"]
            passwd = self.db_conn_pool[conn_name]["db_passwd"]
            db_type = self.db_conn_pool[conn_name]["db_type"]

            self.db_conn_pool[conn_name]["db_conn"] = self.db_connection_factory(server, port, db_name,
                                                                                 user, passwd, db_type)

        return self.db_conn_pool[conn_name]["db_conn"]

    def initialize_db_connections(self, db_configurations):
        self.logger.info("Initialize DB connections")

        for db_conf in db_configurations:
            self.add_db_conf_to_pool(db_conf["server"], db_conf["port"], db_conf["db_name"],
                                     db_conf["user"], db_conf["passwd"],
                                     db_conf["db_type"], db_conf["conn_name"])

        self.add_hive_db_conf_to_pool()

    def add_hive_db_conf_to_pool(self, hive_db=None):
        self.logger.info("Add Hive DB conf to pool")
        # Add direct HIVE conf to pool. A direct HIVE connection with no database specified is required
        # by utilities that backup the database.
        hive_server = self.config.get("DB_COMMON", "hive_server")
        hive_port = self.config.get("DB_COMMON", "hive_port")
        hive_user = self.config.get("DB_COMMON", "hive_user")
        hive_passwd = self.config.get("DB_COMMON", "hive_passwd")
        hive_metastore = self.config.get("DB_COMMON", "hive_metastore")

        conn_name = hive_db if hive_db else "hive"

        self.add_db_conf_to_pool(hive_server, hive_port, hive_db, hive_user, hive_passwd, self.HIVE_TYPE, conn_name)
        self.db_conn_pool[conn_name]["db_metastore"] = hive_metastore

    def db_connection_factory(self, server, port, db_name, user, passwd, db_type):
        self.logger.info("DB connection factory")
        self.logger.debug("Server: %s, port: %s, db name: %s, user: %s, db type: %s" % (
            server, port, db_name, user, db_type))

        if db_type == self.MSSQL_TYPE:
            return mssql.connect(host=server, port=port,
                                 user=user, password=passwd, database=db_name, autocommit = True)
        elif db_type == self.HIVE_TYPE:
            if db_name:
                self.create_hive_db_if_not_exists(db_name)

            return hive.connect(host=server, port=port, database=db_name,
                                user=user, auth_mechanism=self.HIVE_AUTH_MECHANISM)
        else:
            return None

    def create_hive_db_if_not_exists(self, db_name):
        self.logger.info("Create Hive DB if not exists")
        self.logger.debug("DB name: %s" % db_name)
        with self.get_db_conn("hive").cursor() as hive_cursor:
            hive_cursor.execute(self.CREATE_DB_IF_NOT_EXISTS_QUERY % db_name)

    def add_hive_db(self, hive_db):
        self.logger.info("Add a Hive DB")
        self.create_hive_db_if_not_exists(hive_db)
        self.add_hive_db_conf_to_pool(hive_db)

