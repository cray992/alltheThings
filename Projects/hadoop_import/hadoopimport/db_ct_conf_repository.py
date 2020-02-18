from config import Config
from db_ct_conf import DbCTConf
from mssql_db_manager import MsSqlDbManager, MsSqlDbName

class DbCTConfRepository:
    DBS_CT_CONF_QUERY = """
                    SELECT DatabaseId, HostServer, DatabaseName, DbEnabled, CreatedDate, ModifiedDate
                    FROM HDP_DatabasesToImport
                """

    DBS_CT_CONF_BY_ID_QUERY = DBS_CT_CONF_QUERY + " WHERE DatabaseID={0}"

    CREATE_DB_TO_IMPORT_INSERT = "INSERT INTO HDP_DatabasesToImport (HostServer, DatabaseName, DbEnabled, CreatedDate, ModifiedDate, LastImported) VALUES('{0}', '{1}', 0, getdate(), getdate(), getdate())"


    DB_CT_CONF_UPDATE = """
                    UPDATE HDP_DatabasesToImport SET HostServer={0}, DbEnabled={1}, ModifiedDate=getdate()
                    WHERE DatabaseId={2}
               """

    def __init__(self):
        self.config = Config()
        self.logger = self.config.get_logger(__package__)
        self.mssql_db_mgr = MsSqlDbManager(db_name=MsSqlDbName.CHANGE_TRACKING)

    def get_db_ct_confs(self):
        """
        Return list of all db ct confs

        :rtype: list of DbCTConf
        """
        self.logger.info("Get DB CT Confs ")
        db_ct_conf_rows = self.mssql_db_mgr.execute_query(self.DBS_CT_CONF_QUERY)
        self.logger.debug("Obtained # of DB CT confs: %s" % len(db_ct_conf_rows))
        return map(self._db_ct_conf_row_mapper, db_ct_conf_rows)

    def get_db_ct_conf_by_id(self, db_id):
        """
        Return the db ct conf for the given database id or None if it doesnt exist

        :type db_id: int
        :rtype: DbCTConf
        """
        self.logger.info("Get DB CT Confs for Database ID: %s" % db_id)
        query = self.DBS_CT_CONF_BY_ID_QUERY.format(int(db_id))
        db_ct_conf_row = self.mssql_db_mgr.execute_query(query)
        self.logger.debug("Obtained DB CT confs: %s" % db_ct_conf_row)
        if db_ct_conf_row:
            return self._db_ct_conf_row_mapper(db_ct_conf_row[0])
        else:
            raise Exception("No row found with Database ID: %s" % db_id)

    def create_db_ct_conf(self, db_name, db_server):
        """

        :type db_name: str
        :type db_server: str
        :returns: DatabaseId
        :rtype: int
        """
        self.logger.debug("Creating Db CT Conf, Db Server: %s, Db Name: %s" % (db_server, db_name))
        create_job_insert = self.CREATE_DB_TO_IMPORT_INSERT.format(db_server, db_name)
        return self.mssql_db_mgr.execute_query(create_job_insert)

    def update_db_ct_conf(self, db_id, db_server, db_enabled):
        """

        :type db_server: str
        :type db_enabled: bool
        :return: Number of updated rows
        :rtype: int
        """
        self.logger.debug("Updating Db CT Conf, Db Id %s, Db Server: %s, Db Enabled %s" % (db_id, db_server, db_enabled))
        create_job_update = self.DB_CT_CONF_UPDATE.format(db_id, db_server, db_enabled)
        return self.mssql_db_mgr.execute_query(create_job_update)

    def _db_ct_conf_row_mapper(self, db_ct_conf_row):
        """
        :type db_ct_conf_row: dict
        :rtype: DbCTConf
        """
        self.logger.debug("Map db CT conf row: %s" % db_ct_conf_row)
        return DbCTConf(db_id = db_ct_conf_row["DatabaseId"],
                        db_server = db_ct_conf_row["HostServer"],
                        db_name = db_ct_conf_row["DatabaseName"],
                        db_enabled = db_ct_conf_row["DbEnabled"],
                        create_time = db_ct_conf_row["CreatedDate"],
                        modified_time = db_ct_conf_row["ModifiedDate"])
