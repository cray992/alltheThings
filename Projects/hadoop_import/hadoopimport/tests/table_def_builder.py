from hadoopimport.table_def import TableDef
from hadoopimport.ingestion_type import IngestionType


class TableDefBuilder:

    def __init__(self):
        self.merge_match_buckets = []
        self.partition_fields = {}
        self.column_definitions = {}
        self.table_name = "test.test_table"
        self.num_buckets = 1
        self.ingestion_type = IngestionType.FULL

    def with_ingestion_type(self, ingestion_type):
        self.ingestion_type = ingestion_type
        return self

    def with_merge_match_buckets(self, merge_match_buckets):
        self.merge_match_buckets = merge_match_buckets
        return self

    def build(self):
        return TableDef(self.column_definitions,
                        self.table_name,
                        self.merge_match_buckets,
                        self.partition_fields,
                        self.num_buckets,
                        self.ingestion_type)

