from mssql_db_manager import MsSqlDbManager, MsSqlDbName
from ingestible_db_conf import IngestibleDbConf


class IngestibleDbConfRepository:
    GET_INGESTIBLE_DBS_QUERY = """
        SELECT idb.IngestibleDbId, idb.TargetDbName, idb.DbTypeId, sdb.SourceDbName,
        sdb.SourceDbServer, sdb.SourceDbPort
        FROM dbo.HDP_IngestibleDb idb
        LEFT JOIN dbo.HDP_SourceDbConf sdb 
        ON idb.SourceDbConfId = sdb.SourceDbConfId 
        WHERE idb.IngestionGroupId = {0}
    """

    def __init__(self, ingestion_group):
        self.ingestion_group = ingestion_group
        self.mssql_db_mgr = MsSqlDbManager(db_name=MsSqlDbName.APPLICATION_METADATA)

    def get_ingestible_dbs(self):
        """
        :rtype: list of IngestibleDbConf
        :raises SQLException: If the query fails
        """
        db_records = self.mssql_db_mgr.execute_query(self.GET_INGESTIBLE_DBS_QUERY.format(self.ingestion_group))
        return map(self._ingestible_db_conf_row_mapper, db_records)

    def get_target_db_names(self):
        """

        :returns: A dictionary of DbType to target db name
        :rtype: dict of int:str
        """
        target_db_names = {}
        for ingestible_db in self.get_ingestible_dbs():
            target_db_names[ingestible_db.db_type] = ingestible_db.target_db_name
        return target_db_names

    def get_ingestible_db_types(self):
        """

        :rtype: lsit of int
        """
        return list(set([ingestible_db.db_type for ingestible_db in self.get_ingestible_dbs()]))

    def _ingestible_db_conf_row_mapper(self, ingestible_db_table_conf_row):
        """

        :type ingestible_db_table_conf_row: dict
        :rtype: IngestibleDbConf
        """
        return IngestibleDbConf(db_conf_id=ingestible_db_table_conf_row['IngestibleDbId'],
                                db_name=ingestible_db_table_conf_row['SourceDbName'],
                                db_server=ingestible_db_table_conf_row['SourceDbServer'],
                                db_port=ingestible_db_table_conf_row['SourceDbPort'],
                                target_db_name=ingestible_db_table_conf_row['TargetDbName'],
                                db_type=ingestible_db_table_conf_row['DbTypeId'])
