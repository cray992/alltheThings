import unittest
from datetime import datetime, timedelta

from impala.error import HiveServer2Error
from mock import Mock, patch, call, ANY

from hadoopimport.hive_tools import HiveTools
from hadoopimport.tests.base_test_case import BaseTestCase

datetime_pattern = '%Y_%m_%d_%H_%M'


class TestHiveToolsDropBackups(BaseTestCase):
    def setUp(self):

        # Classes / attributes to mock
        self.mock_config = self.get_mock("hadoopimport.hive_tools.Config")


    def test_get_db_datetime(self):
        # Given
        db_names = ['somename_2018_01_01_00_00',
                    'some_other_2018_01_01_12_00'] # multiple word db name

        # When
        got_db_dts = [HiveTools.get_db_datetime(db_name) for db_name in db_names]

        # Then
        db_dts = [datetime.strptime('2018_01_01_00_00', datetime_pattern),
                  datetime.strptime('2018_01_01_12_00', datetime_pattern),]
        self.assertListEqual(got_db_dts, db_dts)

    @patch('impala.interface.Cursor')
    def test_filter_db_backups_to_drop(self, mock_cursor_class):
        # Given
        threshold_dt = datetime.strptime('2018_01_16_00_00', datetime_pattern)
        db_names = ['somename_2018_01_%s_00_00' % d for d in xrange(10, 21)]

        # Patch
        mock_cursor = Mock()
        mock_cursor_class.return_value = mock_cursor

        # When
        ht = HiveTools(mock_cursor)
        got_dbs_to_drop = ht.filter_db_backups_to_drop(db_names, threshold_dt)

        # Then
        dbs_to_drop = db_names[:6]
        self.assertListEqual(got_dbs_to_drop, dbs_to_drop)

    @patch('impala.interface.Cursor')
    def test_get_hive_backup_dbs(self, mock_cursor_class):
        # Given
        source_db = 'db_two'
        db_names = ['db_one', 'db_two', 'db_two_2018_01_30_12_00', 'db_two_2018_02_01_12_00']
        dbs = [(db, None) for db in db_names]

        # Patch
        mock_cursor = Mock()
        mock_cursor_class.return_value = mock_cursor
        mock_cursor.fetchall.return_value = dbs

        # When
        ht = HiveTools(mock_cursor)
        got_dbs = ht.get_hive_backup_dbs(source_db)

        # Then
        self.assertListEqual(got_dbs, db_names[2:])

    @patch('impala.interface.Cursor')
    def test_drop_hive_dbs(self, mock_cursor_class):
        # Given
        dbs_to_drop = ['db1', 'db2', 'db3']

        # Patch
        mock_cursor = Mock()
        mock_cursor_class.return_value = mock_cursor
        mock_cursor.execute.side_effect = [None, HiveServer2Error, None]

        # When
        ht = HiveTools(mock_cursor)
        got_dropped_dbs = ht.drop_hive_dbs(dbs_to_drop)

        # Then
        self.assertListEqual(got_dropped_dbs, ['db1', 'db3'])
        self.assertListEqual(mock_cursor.execute.call_args_list, [call('DROP DATABASE IF EXISTS %s CASCADE' % db)
                                                                  for db in dbs_to_drop])

    @patch.object(HiveTools, 'drop_hive_dbs')
    @patch.object(HiveTools, 'filter_db_backups_to_drop')
    @patch.object(HiveTools, 'get_hive_backup_dbs')
    @patch('hadoopimport.hive_tools.datetime')
    def test_drop_old_hive_db_backups(self, mock_dt, mock_get_hive_backup_dbs, mock_filter_db_backups_to_drop, mock_drop_hive_dbs):
        # Given
        now = datetime.now()
        source_db = 'db2'
        backup_days = 2
        threshold_dt = now - timedelta(days=backup_days)
        db_names = ['db1', 'db2', 'db2_2018_01_01_12_00']
        dbs_to_drop = dropped_dbs = ['db2_2018_01_01_12_00']

        # Patch
        mock_dt.now.return_value = now

        mock_get_hive_backup_dbs.return_value = db_names
        mock_filter_db_backups_to_drop.return_value = dbs_to_drop
        mock_drop_hive_dbs.return_value = dropped_dbs

        # When
        ht = HiveTools(ANY)
        ht.drop_old_hive_db_backups(source_db, backup_days)

        # Then
        mock_get_hive_backup_dbs.assert_called_once()
        mock_filter_db_backups_to_drop.assert_called_once_with(db_names, threshold_dt)
        mock_drop_hive_dbs.assert_called_once_with(dbs_to_drop)

    @patch.object(HiveTools, 'drop_hive_dbs')
    @patch.object(HiveTools, 'filter_db_backups_to_drop')
    @patch.object(HiveTools, 'get_hive_backup_dbs', new=Mock())
    def test_drop_old_hive_db_backup_with_failures(self, mock_filter_db_backups_to_drop, mock_drop_hive_dbs):
        # Given
        backup_days = 2
        source_db = 'db2'
        dbs_to_drop = ['db2_2018_01_01_12_00']
        dropped_dbs = []

        # Patch
        mock_filter_db_backups_to_drop.return_value = dbs_to_drop
        mock_drop_hive_dbs.return_value = dropped_dbs

        # When
        ht = HiveTools(ANY)
        with self.assertRaises(AssertionError):
            ht.drop_old_hive_db_backups(source_db, backup_days)