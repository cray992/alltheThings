from config import Config
from db_definition_repository import DbDefinitionRepository
from hive_consistency_checker import HiveConsistencyChecker
from hive_schema_manager import HiveSchemaManager
from ingestible_db_repository import IngestibleDbConfRepository
from table_def import TableDef



class HiveConsistencyFixer:

    def __init__(self, ingestion_group):
        self.ingestion_group = ingestion_group
        self.hive_schema_manager = HiveSchemaManager()
        self.config = Config()
        self.db_definition_repo = DbDefinitionRepository()
        self.ingestible_db_conf_repo = IngestibleDbConfRepository(self.ingestion_group)
        self.logger = self.config.get_logger(__package__)

    def fix_all(self):
        """
        Returns a list of existing tables that were affected by the fixer
        :rtype: dict of int:list of str
        """

        altered_tables = {}

        for ingestible_db_conf in self.ingestible_db_conf_repo.get_ingestible_dbs():
            target_db= ingestible_db_conf.target_db_name
            db_type = ingestible_db_conf.db_type
            self.logger.info("Fixing consistency for DB Type: %s, Target DB: %s" % (db_type, target_db))
            self.prepare_database(target_db)
            consistency_checker = HiveConsistencyChecker(target_db, db_type)

            unused_tables = consistency_checker.get_unused_tables()
            self.remove_unused_tables(unused_tables)

            new_tables = consistency_checker.get_new_tables()
            self.create_new_tables(new_tables)

            inconsistent_tables = consistency_checker.get_inconsistent_tables()
            self.fix_inconsistent_tables(inconsistent_tables, db_type)

            # Combine lists of inconsistent and unused tables
            altered_tables[db_type] = map(lambda qualified_table: qualified_table.split(".")[1],
                                          inconsistent_tables.keys() + unused_tables)

        self.logger.debug("Altered Tables: %s" % altered_tables)
        return altered_tables

    def remove_unused_tables(self, unused_tables):
        """
        :param unused_tables: List of tables to be removed
        :type unused_tables: list of str
        """
        self.logger.info("Unused tables to remove %s" % len(unused_tables))
        self.logger.debug(unused_tables)

        for table in unused_tables:
            self.hive_schema_manager.remove_table(table)

    def create_new_tables(self, new_tables):
        """
        :param new_tables: Tables to create
        :type new_tables: dictionary of TableDef
        """
        self.logger.info("New tables to create %s" % len(new_tables))
        self.logger.debug(new_tables)

        for table_name, table_def in new_tables.iteritems():
            self.hive_schema_manager.create_table(table_name, table_def)

    def fix_inconsistent_tables(self, inconsistent_tables, db_type):
        """
        :param inconsistent_tables: Tables that do not match the staged definition
        :type inconsistent_tables: dictionary of TableDef
        :param db_type: The type of database to get the database definition for
        :type db_type: DatabaseType
        """
        self.logger.info("Inconsistent tables to be recreated %s" % len(inconsistent_tables))
        self.logger.debug(inconsistent_tables)

        for table_name, table_def in inconsistent_tables.iteritems():
            self.hive_schema_manager.remove_table(table_name)
            self.hive_schema_manager.create_table(table_name, table_def)
            self.update_database_definition(table_name, db_type)

    def prepare_database(self, db_name):
        self.hive_schema_manager.create_database_if_not_exists(db_name)

    def update_database_definition(self, table_name, db_type):
        db, table = table_name.split(".")
        self.db_definition_repo.commit_staged_table_definition(db_type, table)

