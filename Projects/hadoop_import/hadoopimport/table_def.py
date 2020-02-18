class TableDef:
    def __init__(self, column_definitions, table_name, merge_match_buckets, partition_fields, num_buckets,
                 ingestion_type):
        """
        :type column_definitions: list
        :type table_name: str
        :type merge_match_buckets: list
        :type partition_fields: list
        :type num_buckets: int
        """

        self.merge_match_buckets = merge_match_buckets
        self.partition_fields = partition_fields
        self.column_definitions = column_definitions
        self.table_name = table_name
        self.num_buckets = num_buckets
        self.ingestion_type = ingestion_type

    def __str__(self):
        return str(self.__dict__)

    def __repr__(self):
        return self.__str__()

    def __hash__(self):
        sorted_dict = ', '.join("%s: %s" % item for item in sorted(self.__dict__.items(), key=lambda i: i[0]))
        return hash(sorted_dict)

    def __eq__(self, other):
        return self.__hash__() == other.__hash__()

    def __ne__(self, other):
        return not self.__eq__(other)