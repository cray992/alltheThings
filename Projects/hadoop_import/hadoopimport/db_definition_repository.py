import itertools

from mssql_db_manager import MsSqlDbManager, MsSqlDbName
from config import Config, ConfigNamespace
from database_type import DatabaseType
from table_def import TableDef


class DbDefinitionRepositoryConfigProperty:
    NUM_BUCKETS = "num_buckets"


class DbDefinitionRepository:
    DEFAULT_PARTITION_FIELDS = {
        DatabaseType.CUSTOMER: ["partitioncustomerid"],
        DatabaseType.SHARED: [],
        DatabaseType.SALESFORCE: []
    }

    GET_IMPORTABLE_TABLES_QUERY = """
      SELECT TableID, TableName, ImportTypeID, SourceID
      FROM 
        HDP_TablesToImport
      WHERE 
        ImportTypeID > 0 AND SourceID = %(sourceId)s
    """

    GET_COLUMNS_FOR_TABLES_QUERY = """
      SELECT
        TableID,  
        ColumnName AS COLUMN_NAME, 
        ColumnType AS DATA_TYPE, 
        ColumnLength AS CHARACTER_MAXIMUM_LENGTH,
        ColumnPrecision AS NUMERIC_PRECISION, 
        ColumnScale AS NUMERIC_SCALE, 
        isMergeMatch AS isMergeMatch,
        isPartition AS isPartition
      FROM
        HDP_ColumnsToImport
      WHERE
        ColumnImportFlag = 1
        AND TableID IN (%s)  
        ORDER BY TableID, ColumnName
    """

    GET_STAGED_COLUMNS_FOR_TABLES_QUERY = """
      SELECT
        TableID,  
        ColumnName AS COLUMN_NAME, 
        ColumnType AS DATA_TYPE, 
        ColumnLength AS CHARACTER_MAXIMUM_LENGTH,
        ColumnPrecision AS NUMERIC_PRECISION, 
        ColumnScale AS NUMERIC_SCALE, 
        isMergeMatch AS isMergeMatch,
        isPartition AS isPartition
      FROM
        HDP_ColumnsToImport
      WHERE
        StagedImportFlag = 1
        AND TableID IN (%s)  
        ORDER BY TableID, ColumnName
        """

    UPDATE_TABLE_COLUMN_IMPORT_FLAG_QUERY = """
      UPDATE
        HDP_ColumnsToImport
      SET
        columnImportFlag=stagedImportFlag
      WHERE
        TableID IN 
          (SELECT 
              TableID 
           FROM HDP_TablesToImport 
           WHERE 
            lower(TableName)=lower(%(tableName)s)
            AND SourceID=%(sourceId)s)
    """

    GET_TABLES_WITH_STAGED_CHANGES = """
      SELECT 
          TableName 
      FROM 
          HDP_TablesToImport 
      WHERE 
        TableID IN
          (SELECT TableID FROM HDP_ColumnsToImport 
           WHERE ColumnImportFlag != StagedImportFlag 
           GROUP BY  TableID)
        AND SourceID = %(sourceId)s
        AND ImportTypeID > 0
    """

    def __init__(self):
        self.config = Config()
        self.logger = self.config.get_logger()
        self.database_type = DatabaseType()
        self.mssql_db_mgr = MsSqlDbManager(db_name=MsSqlDbName.APPLICATION_METADATA)

    def get_db_definition(self, db_type):
        """
        :param db_type: the type for which to get the db definition
        :type db_type: DatabaseType
        :rtype: dict of str:TableDef
        """
        tables = self.get_importable_tables(db_type)
        columns_by_table = self._get_columns_by_table_id([table["TableID"] for table in tables])

        return self._build_db_definition(db_type, tables, columns_by_table)

    def get_staged_db_definition(self, db_type):
        """
        :type db_type: DatabaseType
        :rtype: dict of str:TableDef
        """
        tables = self.get_importable_tables(db_type)
        columns_by_table = self._get_staged_columns_by_table_id([table["TableID"] for table in tables])

        return self._build_db_definition(db_type, tables, columns_by_table)

    def get_importable_tables(self, db_type):
        return self.mssql_db_mgr.execute_query(DbDefinitionRepository.GET_IMPORTABLE_TABLES_QUERY,
                                         query_params={"sourceId": db_type})

    def get_tables_with_staged_changes(self, db_type):
        """
        :param db_type: the type for which to get the db definition
        :type db_type: DatabaseType
        :rtype list of str
        """
        results = self.mssql_db_mgr.execute_query(DbDefinitionRepository.GET_TABLES_WITH_STAGED_CHANGES,
                                            query_params={"sourceId": db_type})

        return [row["TableName"] for row in results]

    def commit_staged_table_definition(self, db_type, table_name):
        """

        :param db_type: the type for which to get the db definition
        :type db_type: DatabaseType
        :param table_name: The name of the table to update
        :type table_name: str
        :rtype: None
        """
        self.mssql_db_mgr.execute_query(DbDefinitionRepository.UPDATE_TABLE_COLUMN_IMPORT_FLAG_QUERY,
                                  query_params={"tableName": table_name, "sourceId": db_type})

    def _build_db_definition(self, db_type, tables_def, columns_by_table):
        db_definition = {}
        for table in tables_def:

            table_id = table["TableID"]
            table_name = table["TableName"]
            ingestion_type = table["ImportTypeID"]

            cols_def = columns_by_table[table_id]
            partition_columns = self._get_partition_cols(columns_by_table[table_id], db_type)
            bucket_columns = self._get_bucket_columns(columns_by_table[table_id])
            num_buckets = int(
                self.config.get(ConfigNamespace.INGESTION, DbDefinitionRepositoryConfigProperty.NUM_BUCKETS))

            db_definition[table_name] = TableDef(column_definitions=cols_def,
                                                 partition_fields=partition_columns,
                                                 num_buckets=num_buckets,
                                                 ingestion_type=ingestion_type,
                                                 table_name=table_name,
                                                 merge_match_buckets=bucket_columns)

        return db_definition

    def _get_staged_columns_by_table_id(self, table_ids):
        table_ids_list = self._comma_separated_id_list(table_ids)

        columns = self.mssql_db_mgr.execute_query(DbDefinitionRepository.GET_STAGED_COLUMNS_FOR_TABLES_QUERY % table_ids_list)

        column_defs = {}
        for table_id, col_def in itertools.groupby(columns, lambda cols: cols["TableID"]):
            column_defs[table_id] = list(col_def)
        return column_defs

    def _get_columns_by_table_id(self, table_ids):
        table_ids_list = self._comma_separated_id_list(table_ids)

        columns = self.mssql_db_mgr.execute_query(DbDefinitionRepository.GET_COLUMNS_FOR_TABLES_QUERY % table_ids_list)
        column_defs = {}
        for table_id, col_def in itertools.groupby(columns, lambda cols: cols["TableID"]):
            column_defs[table_id] = list(col_def)
        return column_defs

    def _comma_separated_id_list(self, id_list):
        """

        :type id_list: list of int
        :rtype: str
        """
        if id_list is None:
            return ""

        return ",".join(str(element) for element in id_list)

    def _get_partition_cols(self, cols_def, db_type):
        if db_type in DbDefinitionRepository.DEFAULT_PARTITION_FIELDS:
            return DbDefinitionRepository.DEFAULT_PARTITION_FIELDS[db_type]
        else:
            return [col_def["COLUMN_NAME"] for col_def in cols_def if col_def["isPartition"]]


    def _get_bucket_columns(self, cols_def):
        return [col_def["COLUMN_NAME"] for col_def in cols_def if col_def["isMergeMatch"]]