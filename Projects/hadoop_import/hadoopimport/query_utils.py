from abc import ABCMeta
import re

ESCAPING_PREFIX = "["
ESCAPING_SUFFIX = "]"

class QueryUtils:
    """
    Helper class for preparing query column lists
    """

    __metaclass__ = ABCMeta

    @staticmethod
    def extract_column_list(column_defs):
        """

        :type column_defs: list of dict
        :rtype: list of str
        """
        return [column_def["COLUMN_NAME"] for column_def in column_defs]

    @staticmethod
    def alias_identifier(identifier, alias):
        """

        :type identifier: str
        :type alias: str
        :rtype: str
        """
        return "%s AS %s" % (identifier, alias)

    @staticmethod
    def escape_identifier(identifier, prefix=ESCAPING_PREFIX, suffix=ESCAPING_SUFFIX):
        """

        :type identifier: str
        :type prefix: str
        :type suffix: str
        :rtype: str
        """
        return "%s%s%s" % (prefix, identifier, suffix)

    @staticmethod
    def escape_column_list(column_list, prefix=ESCAPING_PREFIX, suffix=ESCAPING_SUFFIX):
        """

        :type column_list: list of str
        :type prefix: str
        :type suffix: str
        :rtype: list of str
        """
        return [QueryUtils.escape_identifier(column, prefix, suffix) for column in column_list] if column_list else []

    @staticmethod
    def filter_primary_keys(column_defs):
        """
        :type column_defs: list of dict
        :rtype: list of dict
        """
        return [column_def for column_def in column_defs if column_def["isMergeMatch"]]

    @staticmethod
    def qualify_column_list(column_list, relation_alias):
        """

        :type column_list: list of str
        :type relation_alias: str
        :rtype: list of str
        """
        return [QueryUtils.qualify_identifier(relation_alias, column) for column in column_list]

    @staticmethod
    def qualify_identifier(namespace, identifier):
        """

        :type namespace: str
        :type identifier: str
        :rtype: str
        """
        return "%s.%s" % (namespace, identifier)

    @staticmethod
    def prepare_select_column_list(column_list, relation_alias, prefix=ESCAPING_PREFIX, suffix=ESCAPING_SUFFIX):
        """
        It escapes a column list with the given prefix and suffix. And it qualifies them with the relation alias.

        :type column_list: list of str
        :type relation_alias: str
        :type prefix: str
        :type suffix: str
        :rtype: list of str
        """
        escaped_columns = QueryUtils.escape_column_list(column_list, prefix, suffix)
        prepared_columns = QueryUtils.qualify_column_list(escaped_columns, relation_alias)
        return prepared_columns

    @staticmethod
    def clean_query(query):
        """
        :type query: str
        :return: str
        """
        query = query.replace("\n", " ").strip()
        clean_query = re.sub('\s+', ' ', query).strip()

        return clean_query
