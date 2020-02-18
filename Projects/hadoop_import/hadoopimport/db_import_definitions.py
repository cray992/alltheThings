import itertools

from config import Config
from db_manager import DbManager
from database_type import DatabaseType

class ImportTableDef:

    def __init__(self, column_definitions, table_name, merge_match_buckets, partition_fields, num_buckets):
        '''
        :type column_definitions: list of dict
        :type table_name: str
        :type merge_match_buckets: list of str
        :type partition_fields: list of str
        :type num_buckets: int
        '''

        self.column_definitions = column_definitions
        self.table_name = table_name
        self.num_buckets = num_buckets
        self.partition_fields = partition_fields
        self.merge_match_buckets = merge_match_buckets

    def __str__(self):
        return "%s(%s)" % (type(self).__name__, ", ".join("%s=%s" % item for item in vars(self).items()))

    def __repr__(self):
        return self.__str__()

    def __hash__(self):
        return hash(str(self.__dict__))

    def __eq__(self, other):
        return self.__dict__ == other.__dict__

    def __ne__(self, other):
        return not self.__eq__(other)


class ImportGroup:
    IMPORTABLE_DB = "importable_db"
    PARTITION_FIELD ="partition_field"
    TARGET_HIVE_DB = "target_hive_db"

    DEFAULT_TABLE_PARTITION = {DatabaseType.CUSTOMER: "partitioncustomerid",
                               DatabaseType.SHARED: None,
                               DatabaseType.SALESFORCE: None}

    SHARED = {"importable_db": DatabaseType.SHARED,
              "partition_field": DEFAULT_TABLE_PARTITION[DatabaseType.SHARED],
              "target_hive_db": "hive_shared"}

    SALESFORCE = {"importable_db": DatabaseType.SALESFORCE,
                  "partition_field": DEFAULT_TABLE_PARTITION[DatabaseType.SALESFORCE],
                  "target_hive_db": "hive_salesforce"}

    KMB = {"importable_db": DatabaseType.CUSTOMER,
           "partition_field": DEFAULT_TABLE_PARTITION[DatabaseType.CUSTOMER],
           "target_hive_db": "hive_global"}

    KAREO_ANALYTICS = {"importable_db": DatabaseType.CUSTOMER,
                       "partition_field": DEFAULT_TABLE_PARTITION[DatabaseType.CUSTOMER],
                       "target_hive_db": "hive_global"}

    IMPORT_GROUPS = {"shared": SHARED, "salesforce": SALESFORCE,
                     "kareo_analytics": KAREO_ANALYTICS, "kmb": KMB}

    @staticmethod
    def import_groups():
        return ImportGroup.IMPORT_GROUPS.keys()

    @staticmethod
    def get_by_name(import_group):
        '''
        :type import_group: str
        :rtype: dict
        '''
        import_group = import_group.lower()
        return ImportGroup.IMPORT_GROUPS[import_group]


class DbImportDefinition:
    GET_DB_TABLES_AND_COLUMNS_QUERY = """SELECT 
                                            a.TableName AS TABLE_NAME, 
                                            b.ColumnName AS COLUMN_NAME, 
                                            b.ColumnType AS DATA_TYPE, 
                                            b.ColumnLength AS CHARACTER_MAXIMUM_LENGTH,
                                            b.ColumnPrecision AS NUMERIC_PRECISION, 
                                            b.ColumnScale AS NUMERIC_SCALE, 
                                            b.isMergeMatch AS isMergeMatch,
                                            b.isPartition AS isPartition
                                         FROM 
                                            dbo.HDP_TablesToImport a WITH (NOLOCK) 
                                            LEFT JOIN dbo.HDP_ColumnsToImport b WITH (NOLOCK) ON b.TableID = a.TableID 
                                         WHERE 
                                            a.ImportTypeID > 0 
                                            AND a.SourceID = %s 
                                            AND b.ColumnImportFlag = 1 
                                            ORDER BY TABLE_NAME, COLUMN_NAME"""

    def __init__(self, db_type):
        self.db_type = db_type
        self.table_definitions = {}
        self.merge_column_defs = {}

        self.config = Config()
        self.logger = self.config.get_logger(__package__)

        self.load_db_definition()

    def load_db_definition(self):
        self.logger.info("Load DB definition For DB: " + str(self.db_type))
        prepared_col_query = self.GET_DB_TABLES_AND_COLUMNS_QUERY % self.db_type

        self.logger.debug("Prepared query: %s" % prepared_col_query)

        db_manager = DbManager()
        table_definitons = db_manager.execute_query_with_connection("enterprise_reports", prepared_col_query)

        default_partition = ImportGroup.DEFAULT_TABLE_PARTITION[self.db_type]
        if default_partition != None:

            partition_fields = [default_partition]
        else:
            partition_fields = []

        ## Set table definitions
        for table, columns in itertools.groupby(table_definitons,
                                                lambda column_definition: column_definition["TABLE_NAME"]):
            column_definitions = list(columns)
            merge_match_buckets = self.extract_merge_match(column_definitions)
            if len(partition_fields) == 0:
                partition_fields = self.extract_isPartition(column_definitions)

            self.table_definitions[table] = ImportTableDef(column_definitions=column_definitions,
                                                           merge_match_buckets=merge_match_buckets,
                                                           partition_fields=partition_fields,
                                                           table_name=table.strip(),
                                                           num_buckets=int(self.config.get_hive_conf()["num_buckets"]))

    @staticmethod
    def extract_merge_match(column_definitions):
        merge_match_buckets = []
        for column_definition in column_definitions:  # type: dict
            if column_definition['isMergeMatch']:
                merge_match_buckets.append(column_definition['COLUMN_NAME'])
        return merge_match_buckets

    @staticmethod
    def extract_isPartition(column_definitions):
        '''
        :type column_definitions: list of dict
        :rtype: list
        '''

        partition_fields = []
        for column_definition in column_definitions:
            if column_definition['isPartition']:
                partition_fields.append(column_definition['COLUMN_NAME'])
        return partition_fields

    def get_db_definition(self):

        table_names = [table.table_name for table in self.table_definitions.values()]
        self.logger.debug("Getting Table Definitions For Tables: %s" % table_names)

        return self.table_definitions