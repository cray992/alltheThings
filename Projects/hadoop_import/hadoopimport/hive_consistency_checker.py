from db_definition_repository import DbDefinitionRepository
from hive_db_manager import HiveDbManager
from hive_schema_manager import HiveChangeTracking


class HiveConsistencyChecker:
    def __init__(self, db_name, db_type):
        self.db_name = db_name
        self.db_type = db_type
        self.hive_db_mgr = HiveDbManager(db_name=self.db_name)
        self.db_definition_repo = DbDefinitionRepository()
        self.source_db_definition = self._get_db_import_definition()

    def get_inconsistent_tables(self):
        changed_tables = self._get_tables_with_staged_changes()

        inconsistent_tables = {}
        for table_name in changed_tables:
            inconsistent_tables[self._qualify_table_name(table_name)] = self.source_db_definition[table_name]
        return inconsistent_tables

    def get_unused_tables(self):
        unused_tables = []
        target_tables = self._get_target_db_tables()

        for table in target_tables:
            if table not in self.source_db_definition:
                unused_tables.append(table)

        return [self._qualify_table_name(table_name) for table_name in unused_tables]

    def get_new_tables(self):
        new_tables = []
        target_tables = self._get_target_db_tables()

        for table in self.source_db_definition:
            if table not in target_tables:
                new_tables.append(table)

        new_table_defs = {}
        for table_name in new_tables:
            new_table_defs[self._qualify_table_name(table_name)] = self.source_db_definition[table_name]
        return new_table_defs

    def _get_target_db_tables(self):
        with self.hive_db_mgr.get_db_cursor() as hive_cursor:
            hive_cursor.get_tables(self.db_name)
            tables = hive_cursor.fetchall()
        return [HiveConsistencyChecker._normalize_table_name(table[2])
                for table in tables if not table[2].endswith(HiveChangeTracking.TABLE_SUFFIX) and\
                                        not table[2].endswith(HiveChangeTracking.TEMP_SUFFIX)
                ]

    def _get_source_db_tables(self):
        return [HiveConsistencyChecker._normalize_table_name(table_name)
                for table_name in self.source_db_definition.keys()]

    def _qualify_table_name(self, table_name):
        return "%s.%s" % (self.db_name, table_name)

    def _get_db_import_definition(self):

        db_import_definition = self.db_definition_repo.get_staged_db_definition(self.db_type)

        table_defs = {}
        for table_name in db_import_definition.keys():
            table_defs[HiveConsistencyChecker._normalize_table_name(table_name)] = db_import_definition[table_name]
        return table_defs

    def _get_tables_with_staged_changes(self):
        tables_with_staged_changes = self.db_definition_repo.get_tables_with_staged_changes(self.db_type)

        return [HiveConsistencyChecker._normalize_table_name(table_name) for table_name in tables_with_staged_changes]

    @staticmethod
    def _normalize_table_name(table_name):
        return table_name.lower()