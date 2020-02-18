from config import Config

from db_category_repository import DbCategoryRepository
from db_definition_repository import DbDefinitionRepository
from mssql_db_manager import MsSqlDbManager
from ingestible_db_table_list_generator import IngestibleDbTableConf
from ingestible_db_repository import IngestibleDbConfRepository


class DbCategorizer:
    """
    Class to classify ImportDbTableConf based on the table data volume.

    """

    CUSTOM_LENGTH_COLUMN_DATA_TYPES = ["binary", "char", "image", "nchar", "nvarchar", "ntext", "text", "varbinary",
                                       "varchar"]

    DEFAULT_COLUMN_SIZE_BYTES = 1024

    FIXED_LENGTH_COLUMN_SIZE_BYTES = {
        "bigint": 8,
        "binary": 1,
        "bit": 1,
        "date": 3,
        "datetime": 8,
        "datetime2": 6,
        "datetimeoffset": 10,
        "int": 4,
        "money": 8,
        "smalldatetime": 4,
        "smallint": 1,
        "smallmoney": 4,
        "time": 5,
        "timestamp": 8,
        "tinyint": 1,
        "uniqueidentifier": 16
    }

    MAX_ESTIMATED_CUSTOM_LENGTH_COLUMN_SIZE_BYTES = 10000

    PRECISION_BASED_COLUMN_DATA_TYPES = ["decimal", "decimal2", "float", "numeric", "real"]

    def __init__(self, ingestion_group):
        """

        :type ingestion_group: int
        """
        self.ingestion_group = ingestion_group
        self.config = Config()
        self.logger = self.config.get_logger(__package__)
        self.mssql_db_mgr = MsSqlDbManager()
        self.db_categories = DbCategoryRepository().get_all_db_categories()
        self.ingestible_db_conf_repo = IngestibleDbConfRepository(self.ingestion_group)
        self.db_definition_repo = DbDefinitionRepository()
        self.db_import_definitions = self._get_db_import_definitions()

    def _get_db_import_definitions(self):
        """
        :rtype: dict of int:dict of str:TableDef
        """
        self.logger.debug("Get Db Import definitions")
        db_definitions_by_db_type = {}
        for db_type in self.ingestible_db_conf_repo.get_ingestible_db_types():
            db_definitions_by_db_type[db_type] = self.db_definition_repo.get_db_definition(db_type)
        return db_definitions_by_db_type

    @staticmethod
    def _get_fixed_length_column_size_bytes(data_type):
        """
        :type data_type: str
        :rtype: int
        """
        if data_type in DbCategorizer.FIXED_LENGTH_COLUMN_SIZE_BYTES:
            return DbCategorizer.FIXED_LENGTH_COLUMN_SIZE_BYTES[data_type]
        raise ValueError("Invalid fixed length column type: %s" % data_type)

    @staticmethod
    def _get_precision_based_column_size_bytes(data_type, precision):
        """
        :type data_type: str
        :type precision: int
        :rtype: int
        """
        if data_type in ["decimal", "numeric"]:
            if 0 < precision < 10:
                return 5
            elif 9 < precision < 20:
                return 9
            elif 19 < precision < 29:
                return 13
            elif 28 < precision < 39:
                return 17
        elif data_type in ["float", "real"]:
            if 0 < precision < 25:
                return 4
            elif 24 < precision < 54:
                return 8
        raise ValueError("Invalid precision based column type: %s precision: %s" % (data_type, precision))

    @staticmethod
    def _get_custom_length_column_size_bytes(length):
        """
        :rtype length: int
        :rtype: int
        """
        if 0 < length <= DbCategorizer.MAX_ESTIMATED_CUSTOM_LENGTH_COLUMN_SIZE_BYTES:
            return length
        elif length > DbCategorizer.MAX_ESTIMATED_CUSTOM_LENGTH_COLUMN_SIZE_BYTES:
            return DbCategorizer.MAX_ESTIMATED_CUSTOM_LENGTH_COLUMN_SIZE_BYTES
        else:
            return DbCategorizer.DEFAULT_COLUMN_SIZE_BYTES

    @staticmethod
    def _get_column_def_size_bytes(column_def):
        """
        :type column_def: dict
        :rtype: int
        """
        data_type = column_def["DATA_TYPE"]
        if data_type in DbCategorizer.FIXED_LENGTH_COLUMN_SIZE_BYTES.keys():
            return DbCategorizer._get_fixed_length_column_size_bytes(data_type)
        elif data_type in DbCategorizer.PRECISION_BASED_COLUMN_DATA_TYPES:
            precision = column_def["NUMERIC_PRECISION"]
            return DbCategorizer._get_precision_based_column_size_bytes(data_type, precision)
        elif data_type in DbCategorizer.CUSTOM_LENGTH_COLUMN_DATA_TYPES:
            length = column_def["CHARACTER_MAXIMUM_LENGTH"]
            return DbCategorizer._get_custom_length_column_size_bytes(length)
        else:
            return DbCategorizer.DEFAULT_COLUMN_SIZE_BYTES

    @staticmethod
    def _get_row_size_bytes(column_defs):
        """
        :type column_defs: list of dict
        :rtype: int
        """
        return sum([DbCategorizer._get_column_def_size_bytes(column_def) for column_def in column_defs])

    def _get_table_row_count(self, ingestible_db_table_conf):
        """
        :type ingestible_db_table_conf: IngestibleDbTableConf
        :rtype: int
        """
        self.logger.debug("Get table row count, Ingestible Db Table Conf: %s" % ingestible_db_table_conf)
        results = self.mssql_db_mgr.execute_query(
            "select count(*) as num_rows from %s" % ingestible_db_table_conf.table_name,
            db_conn_conf=ingestible_db_table_conf)

        row_count = results[0]["num_rows"]
        self.logger.debug("Got row count %s, Ingestible Db Table Conf:" % ingestible_db_table_conf)
        return row_count

    def _estimate_import_data_set_size_mb(self, ingestible_db_table_conf, column_defs):
        """
        :type ingestible_db_table_conf: IngestibleDbTableConf
        :type table: str
        :rtype: int
        """
        self.logger.debug("Estimate Import Data Size in MB, Ingestible Db Table Conf: %s" % ingestible_db_table_conf)
        row_size = self._get_row_size_bytes(column_defs)
        self.logger.debug("Row size %s" % row_size)

        row_count = self._get_table_row_count(ingestible_db_table_conf)
        self.logger.debug("Row count %s" % row_count)

        data_set_size_mb = int(row_count / 1000000.0 * row_size)
        self.logger.debug("Table: %s, Data set size MB: %s" % (ingestible_db_table_conf.table_name, data_set_size_mb))
        return data_set_size_mb

    def _get_column_definitions(self, ingestible_db_table_conf):
        """
        Returns the column definitions for an IngestibleDbTableConf

        :type ingestible_db_table_conf: IngestibleDbTableConf
        :return: List of column definitions
        :rtype: list of dict
        :raises Exception: If the table is not present in the db import definition
        """
        self.logger.debug("Get column definitions, Ingestible Db table Conf: %s" % ingestible_db_table_conf)
        db_type = ingestible_db_table_conf.db_type
        table_name = ingestible_db_table_conf.table_name
        if db_type in self.db_import_definitions:
            table_defs = self.db_import_definitions[db_type]
            if table_name in table_defs:
                table_def = table_defs[table_name]
                self.logger.debug(
                    "Table %s Column definitions: %s" % (table_def.table_name, table_def.column_definitions))
                return table_def.column_definitions
            else:
                raise Exception("Missing definition for table %s DB type %s" % (table_name, db_type))
        else:
            raise Exception("Invalid DB type: %s" % db_type)

    def _get_db_category_for_size_mb(self, data_set_size_mb):
        """
        Returns DB Category ID the corresponding DB category given a data set size in MB, if exists.

        :type data_set_size_mb: int
        :rtype: int
        :raises Exception: If there is no DB category for the given data set size MB
        """
        for db_category_id, db_category in self.db_categories.items():
            if db_category.min_table_size_mb <= data_set_size_mb < db_category.max_table_size_mb:
                return db_category_id
        raise Exception("Unable to find db category for data set size: %s" % data_set_size_mb)

    def categorize_db(self, ingestible_db_table_conf):
        """
        :type ingestible_db_table_conf: IngestibleDbTableConf
        :rtype: int
        :raises Exception: If there is no DB category for the given data set size MB
        :raises Exception: If the table for categorization is not present in the db import definition
        """
        self.logger.debug("Categorize Ingestible DB Table Conf: %s" % ingestible_db_table_conf)
        column_defs = self._get_column_definitions(ingestible_db_table_conf)
        data_set_size = self._estimate_import_data_set_size_mb(ingestible_db_table_conf, column_defs)
        db_category = self._get_db_category_for_size_mb(data_set_size)
        self.logger.debug("Categorized as %s Ingestible DB Table Conf: %s" % (db_category, ingestible_db_table_conf))
        return db_category

    def categorize_dbs(self, ingestible_db_table_confs):
        """
        Groups a list of Ingestible DB Table Confs into categories

        :type ingestible_db_table_confs: list of IngestibleDbTableConf
        :returns: Dictionary of DB Category ID to List of IngestibleDbTableConf
        :rtype: dict of int:list of IngestibleDbTableConf
        """
        self.logger.info("##### CATEGORIZING DBS #####")
        self.logger.info("Number of Ingestible Db Table Confs: %s" % len(ingestible_db_table_confs))
        categorized_dbs = {}
        for db_table_conf in ingestible_db_table_confs:
            db_category_id = self.categorize_db(db_table_conf)
            if db_category_id in categorized_dbs:
                categorized_dbs[db_category_id].append(db_table_conf)
            else:
                categorized_dbs[db_category_id] = [db_table_conf]

        self.logger.info(
            "Categorized DB counters: %s" % dict(map(lambda category: (category, len(categorized_dbs[category])), categorized_dbs)))
        return categorized_dbs
