import random
import unittest

from mock import patch

from hadoopimport.query_utils import QueryUtils

patch.object = patch.object


class QueryUtilsTest(unittest.TestCase):
    def test_extract_column_list(self):
        # Given
        num_cols = random.randint(2, 10)
        column_list = ["Column%s" % i for i in xrange(num_cols)]
        column_defs = [{"COLUMN_NAME": column} for column in column_list]

        # When
        got_column_list = QueryUtils.extract_column_list(column_defs)

        # Then
        self.assertListEqual(got_column_list, column_list)

    def test_escape_column_list(self):
        # Given
        num_cols = random.randint(2, 10)
        prefix = "["
        suffix = "]"
        column_list = ["Column%s" % i for i in xrange(num_cols)]

        # When
        got_escaped_column_list = QueryUtils.escape_column_list(column_list, prefix, suffix)

        # Then
        escaped_column_list = ["%sColumn%s%s" % (prefix, i, suffix) for i in xrange(num_cols)]
        self.assertListEqual(got_escaped_column_list, escaped_column_list)

    def test_filter_primary_keys(self):
        # Given
        num_cols = random.randint(2, 10)
        column_list = ["Column%s" % i for i in xrange(num_cols)]
        column_defs = [{"COLUMN_NAME": column, "isMergeMatch": 0} for column in column_list]
        pk1 = random.randint(0, num_cols / 2 - 1)
        pk2 = random.randint(num_cols / 2, num_cols - 1)
        column_defs[pk1]["isMergeMatch"] = 1
        column_defs[pk2]["isMergeMatch"] = 1

        # When
        got_primary_keys = QueryUtils.filter_primary_keys(column_defs)

        # Then
        self.assertListEqual(got_primary_keys, [column_defs[pk1], column_defs[pk2]])

    def test_qualify_column_list(self):
        # Given
        num_cols = random.randint(2, 10)
        relation_alias = "ra"
        column_list = ["Column%s" % i for i in xrange(num_cols)]
        qualified_columns = ["ra.Column%s" % i for i in xrange(num_cols)]

        # When
        got_qualified_columns = QueryUtils.qualify_column_list(column_list, relation_alias)

        # Then
        self.assertListEqual(got_qualified_columns, qualified_columns)

    @patch.object(QueryUtils, "escape_column_list")
    @patch.object(QueryUtils, "extract_column_list")
    @patch.object(QueryUtils, "qualify_column_list")
    def test_prepare_select_column_list(self, mock_qualify_column_list, mock_extract_column_list,
                                        mock_escape_column_list):
        # Given
        num_cols = random.randint(2, 10)
        relation_alias = "ra"
        prefix = "["
        suffix = "]"
        column_list = ["Column%s" % i for i in xrange(num_cols)]
        escaped_column_list = ["%sColumn%s%s" % (prefix, i, suffix) for i in xrange(num_cols)]
        prepared_columns = ["ra.%sColumn%s%s" % (prefix, i, suffix) for i in xrange(num_cols)]

        # Patch
        mock_extract_column_list.return_value = column_list
        mock_escape_column_list.return_value = escaped_column_list
        mock_qualify_column_list.return_value = prepared_columns

        # When
        got_prepared_columns = QueryUtils.prepare_select_column_list(column_list, relation_alias, prefix, suffix)


        # Then
        mock_escape_column_list.assert_called_once_with(column_list, prefix, suffix)
        mock_qualify_column_list.assert_called_once_with(escaped_column_list, relation_alias)
        self.assertListEqual(got_prepared_columns, prepared_columns)