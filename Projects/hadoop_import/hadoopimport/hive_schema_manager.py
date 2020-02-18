from hive_db_manager import HiveDbManager
from config import Config

from ingestion_type import IngestionType
from table_def import TableDef

class TableAlreadyExistsException(Exception):
    pass


class TableDoesNotExistException(Exception):
    pass


class DatabaseAlreadyExistsException(Exception):
    pass


class HiveChangeTracking:
    TABLE_SUFFIX = "_ct"
    TEMP_SUFFIX = "_temp"
    CT_COLUMN_VERSION = "sys_change_version"
    CT_COLUMN_OPERATION = "sys_change_operation"

    COLUMNS = [
        {"column_name": CT_COLUMN_VERSION, "data_type": "int"},
        {"column_name": CT_COLUMN_OPERATION, "data_type": "string"}
    ]

    def __init__(self):
        pass


class HiveSchemaManager:
    CREATE_DATABASE_QUERY = "CREATE DATABASE IF NOT EXISTS %s"
    DROP_TABLE_QUERY = "DROP TABLE IF EXISTS %s"
    DROP_PARTITION_QUERY = "ALTER TABLE {0} DROP IF EXISTS PARTITION ({1})"
    TRUNCATE_TABLE_QUERY = "TRUNCATE TABLE {0}"
    MODIFIED_ON_COLUMN = "_ModifiedOn"
    INGESTION_JOB_ID_COLUMN = "_IngestionJobId"

    def __init__(self):
        self.hive_db_mgr = HiveDbManager()
        self.config = Config()
        self.logger = self.config.get_logger(__package__)

    def create_database_if_not_exists(self, db_name):
        self.hive_db_mgr.execute_query(HiveSchemaManager.CREATE_DATABASE_QUERY % db_name)

    def drop_partition(self, table_name, partition_pairs, db_name=None):
        """

        :type table_name: str
        :type partition_pairs: list of (str, str)
        :type db_name: str
        :rtype: None
        :raises TableDoesNotExistException: If the table does not exist
        """
        partition_spec = ", ".join(map(lambda pair: "{0}={1}".format(pair[0], pair[1]), partition_pairs))
        table_name = HiveSchemaManager.qualify_table_name(table_name, db_name)
        self.logger.debug("Dropping partition. Table: %s, Partition: %s" % (table_name, partition_spec))

        if self.table_exists(table_name):
            with self.hive_db_mgr.get_db_cursor() as hive_cursor:
                drop_partition_query = HiveSchemaManager.DROP_PARTITION_QUERY.format(table_name, partition_spec)
                self.logger.debug("Drop partition, query: %s" % drop_partition_query)
                hive_cursor.execute(drop_partition_query)
        else:
            self.logger.error("Cannot drop partition, table %s does not exist" % table_name)
            raise TableDoesNotExistException("Cannot drop partition, table %s does not exist" % table_name)

    def remove_table(self, table_name, db_name=None):
        """
        Removes a table from hive and also removes the corresponding change tracking table if it exists

        :param table_name: The name of the table to remove
        :type table_name: str
        :param db_name: Optional parameter to specify the database where the table is, otherwise default will be used.
        It is also possible to specify a qualified name for the table, so that it is something like
        "my_database.my_table" and leave the db_name param empty
        :type db_name: str
        :raises TableDoesNotExistException: If the table does not exist, it doesn't check for the existence of the
        change tracking table though.
        """
        self.logger.debug("Removing table %s" % table_name)

        table_name = HiveSchemaManager.qualify_table_name(table_name, db_name)
        change_tracking_table = table_name + HiveChangeTracking.TABLE_SUFFIX

        if self.table_exists(table_name):
            with self.hive_db_mgr.get_db_cursor() as hive_cursor:
                hive_cursor.execute(HiveSchemaManager.DROP_TABLE_QUERY % table_name)
                hive_cursor.execute(HiveSchemaManager.DROP_TABLE_QUERY % self.get_temp_table_name(table_name))
                hive_cursor.execute(HiveSchemaManager.DROP_TABLE_QUERY % change_tracking_table)
        else:
            self.logger.error("Cannot remove table %s because it does not exist" % table_name)
            raise TableDoesNotExistException("Cannot remove table %s because it does not exist" % table_name)

    def create_table(self, table_name, table_definition, db_name=None):
        self.logger.debug("Creating table %s" % table_name)

        table_name = HiveSchemaManager.qualify_table_name(table_name, db_name)

        if self.table_exists(table_name):
            self.logger.error("Table %s already exists and cannot be created" % table_name)
            raise TableAlreadyExistsException("Table %s already exists and cannot be created" % table_name)

        create_query = self._generate_create_table_query(table_name, table_definition)
        create_temp_query = self._generate_create_table_query(self.get_temp_table_name(table_name), table_definition, temp_table=True)
        self.logger.debug("Create table query: %s" % create_query)
        self.logger.debug("Create temp table query: %s" % create_temp_query)

        with self.hive_db_mgr.get_db_cursor() as hive_cursor:
            hive_cursor.execute(create_query)
            hive_cursor.execute(create_temp_query)

        # If the import type is incremental we need to create a CT table too
        if table_definition.ingestion_type == IngestionType.INCREMENTAL:
            create_ct_query = self._generate_create_table_query(table_name + HiveChangeTracking.TABLE_SUFFIX,
                                                             table_definition, ct_table=True)

            self.logger.debug("Create CT table query: %s" % create_ct_query)
            with self.hive_db_mgr.get_db_cursor() as hive_cursor:
                hive_cursor.execute(create_ct_query)

    def table_exists(self, table_name):
        """
        :type table_name: str
        :rtype: bool
        """
        db, table = table_name.split(".")

        with self.hive_db_mgr.get_db_cursor() as hive_cursor:
            return hive_cursor.table_exists(table, db)

    def truncate_table(self, table_name, db_name=None):
        """
        :type table_name:
        :type db_name:
        :rtype: None
        :raises TableDoesNotExistException: If the table does not exist
        """
        self.logger.debug("Truncating table %s" % table_name)
        table_name = HiveSchemaManager.qualify_table_name(table_name, db_name)
        if self.table_exists(table_name):
            with self.hive_db_mgr.get_db_cursor() as hive_cursor:
                hive_cursor.execute(HiveSchemaManager.TRUNCATE_TABLE_QUERY.format(table_name))
        else:
            self.logger.error("Cannot truncate table, table %s does not exist" % table_name)
            raise TableDoesNotExistException("Cannot truncate table, table %s does not exist" % table_name)

    def _generate_create_table_query(self, table_name, table_def, ct_table=False, temp_table=False):
        """
        Generates a CREATE query string for a table based on the definition object

        :param table_name: The name of the table
        :type table_name: str
        :param table_def: The definition object with all the metadata for the table
        :type table_def: TableDef
        :rtype:  str
        """
        self.logger.debug("Generate create table query")

        column_specs = self._generate_column_str(table_def.column_definitions) + self._generate_meta_columns()

        if ct_table:
            column_specs = self._generate_ct_column_str() + column_specs

        query_columns = ",".join(column_specs)
        query_partitions = self._generate_partition_str(table_def.partition_fields)
        is_transactional = table_def.ingestion_type == IngestionType.INCREMENTAL and not ct_table and not temp_table
        table_properties = self._generate_table_properties_str(is_transactional)
        query_buckets = self._generate_bucket_str(table_def, is_transactional)

        create_table_query = "CREATE TABLE `{0}` ({1}) {2} {3} STORED AS ORC {4}".format(
            table_name, query_columns, query_partitions, query_buckets, table_properties)

        return create_table_query

    def _generate_table_properties_str(self, is_transactional=False):
        """

        :type is_transactional: bool
        :rtype: str
        """
        self.logger.debug("Generate table properties")

        table_prop_list = [("orc.compress", "SNAPPY")]

        if is_transactional:
            table_prop_list.append(("transactional", "true"))

        table_prop_pairs = map(lambda prop_pair: "'%s'='%s'" % (prop_pair[0], prop_pair[1]), table_prop_list)

        table_props = ", ".join(table_prop_pairs)
        self.logger.debug("Table properties %s" % table_props)

        return "TBLPROPERTIES (%s)" % table_props

    def _generate_bucket_str(self, table_def, is_transactional):
        """

        :type table_def: TableDef
        :type is_transactional: bool
        :rtype: str
        """
        self.logger.debug("Generate bucket str")
        bucket_str = ""

        if not is_transactional:
            self.logger.debug("No buckets generated for non transactional table %s" % table_def.table_name)
        else:
            buckets = table_def.merge_match_buckets
            num_buckets = table_def.num_buckets
            if len(buckets) > 0:
                bucket_str = 'CLUSTERED BY ({0}) INTO {1} BUCKETS'.format(" ,".join(buckets), num_buckets)
                self.logger.debug("Cluster str %s" % bucket_str)
            else:
                self.logger.debug("No buckets for table %s" % table_def.table_name)
        return bucket_str

    def _generate_partition_str(self, partitions):
        self.logger.debug("Generate partition query string")

        partition_str = ""

        if len(partitions) > 0:
            partition_str = "PARTITIONED BY ({0} int)".format(" ,".join(partitions))

        self.logger.debug("Partition str %s" % partition_str)
        return partition_str

    def _generate_column_str(self, column_definitions):
        """
        :type column_definitions: list of dict
        :rtype: list of str
        """
        self.logger.debug("Generate column list")

        columns_str = ["`%s` %s" % (col_def["COLUMN_NAME"], self._get_hive_data_type(col_def))
                               for col_def in column_definitions]

        self.logger.debug("Column string:\n %s" % columns_str)

        return columns_str

    def _generate_meta_columns(self):
        """
        :rtype: list of str
        """
        return ["`%s` timestamp" % self.MODIFIED_ON_COLUMN, "`%s` int" % self.INGESTION_JOB_ID_COLUMN]

    def _generate_ct_column_str(self):
        """
        :rtype: list of str
        """
        self.logger.debug("Generate CT columns list")

        columns_str = ["`%s` %s" % (ct_col["column_name"], ct_col["data_type"])
                               for ct_col in HiveChangeTracking.COLUMNS]

        self.logger.debug("Column string:\n %s" % columns_str)

        return columns_str

    @staticmethod
    def _get_hive_data_type(col_def):
        data_type = col_def["DATA_TYPE"]
        precision = col_def["NUMERIC_PRECISION"]
        scale = col_def["NUMERIC_SCALE"]

        if data_type.endswith("char") or data_type == "text" or data_type == "ntext" or data_type == "uniqueidentifier":
            hive_type = "string"
        elif data_type == "money" or data_type == "decimal" or data_type == "numeric":
            hive_type = "decimal(%s,%s)" % (precision, scale)
        elif data_type == "datetime" or data_type == "smalldatetime":
            hive_type = "timestamp"
        elif data_type == "timestamp" or data_type == "varbinary" or data_type == "image":
            hive_type = "binary"
        elif data_type == "bit":
            hive_type = "boolean"
        elif data_type == "xml":
            hive_type = "string"
        else:
            hive_type = data_type

        return hive_type

    @staticmethod
    def qualify_table_name(table_name, db_name=None):
        if db_name is not None:
            return "%s.%s" % (db_name, table_name)
        else:
            return table_name

    @staticmethod
    def get_metastore():
        """

        :rtype: str
        """
        hive_db_mgr = HiveDbManager()
        default_db_conn_conf = hive_db_mgr.get_db_conn_conf_for_conn_name()
        return default_db_conn_conf.db_metastore

    @staticmethod
    def get_ct_table_name(table_name):
        """

        :type table_name: str
        :rtype: str
        """
        return table_name + HiveChangeTracking.TABLE_SUFFIX

    @staticmethod
    def get_temp_table_name(table_name):
        """

        :type table_name: str
        :rtype: str
        """
        return table_name + HiveChangeTracking.TEMP_SUFFIX