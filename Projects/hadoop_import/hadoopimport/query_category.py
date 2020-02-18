from query_type import QueryType


class QueryCategory:
    """
    Utility class for classifying queries
    """

    DDL = 'DDL'
    DML = 'DML'
    DQL = 'DQL'
    OTHER = 'Other'

    @staticmethod
    def get_query_types(query_category):
        """
        Returns a list of query types for the given category

        :param query_category: A query category
        :type query_category: QueryCategory
        :return: List of QueryTypes
        :rtype: list
        """
        if QueryCategory.DDL == query_category:
            return [QueryType.CREATE,
                    QueryType.DROP,
                    QueryType.TRUNCATE,
                    QueryType.ALTER]
        elif QueryCategory.DML == query_category:
            return [QueryType.DELETE,
                    QueryType.INSERT,
                    QueryType.UPDATE,
                    QueryType.MERGE]
        elif QueryCategory.DQL == query_category:
            return [QueryType.SELECT,
                    QueryType.SHOW]
        else:
            return []

    @staticmethod
    def get_all_categories():
        """
        Returns all query categories defined.

        :return: List of query categories
        :rtype: list
        """
        return [QueryCategory.DDL,
                QueryCategory.DML,
                QueryCategory.DQL]

    @staticmethod
    def get_query_category(query):
        """
        Returns the query category

        :param query: The query
        :type query: str
        :return: The query category
        :rtype: QueryCategory
        """
        query_type = QueryType.get_query_type(query)
        for category in QueryCategory.get_all_categories():
            if query_type in QueryCategory.get_query_types(category):
                return category
        return QueryCategory.OTHER
