class QueryType:
    """
        Utility class for query types
    """
    ALTER = "ALT"
    CREATE = "CRE"
    DROP = "DRO"
    DELETE = "DEL"
    INSERT = "INS"
    MERGE = "MER"
    SELECT = "SEL"
    SHOW = "SHO"
    TRUNCATE = "TRU"
    UPDATE = "UPD"
    OTHER = "OTHER"

    @staticmethod
    def get_query_type(query):
        """
        Returns the query type

        :param query: The query
        :type query: str
        :return: The query type
        :rtype: QueryType
        """
        return query.strip()[0:3].upper()
