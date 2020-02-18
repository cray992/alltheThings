#!/usr/bin/env python
"""
Test for db backup tool
"""

import unittest
#from backup.hive_tools import HiveTools
from unittest import skip

from hadoopimport.hive_tools import HiveTools
import tempfile
import os
import sys
from ConfigParser import ConfigParser

from collections import defaultdict

from impala.dbapi import connect
import argparse
import atexit
import getpass
import datetime
from subprocess import Popen, PIPE, STDOUT

@skip
class TestHiveTools(unittest.TestCase):

    def setUp(self):
        # Load configuration data from config.ini
        cfg = ConfigParser()
        try:
            cfg.read('config.ini')
            self.hive_server = cfg.get('hive', 'server')
            self.hive_port = cfg.get('hive', 'port')
            self.hive_auth = cfg.get('hive', 'auth')
            self.hive_db = cfg.get('hive', 'database')
        except Exception as err:
            print "Error while loading configuration file"
            print err
            sys.exit(1)

        self.user = getpass.getuser()
        print("user is: %s" % self.user)
        self.hive_conn = connect(host=self.hive_server, port=self.hive_port, auth_mechanism=self.hive_auth)
        self.hive_cursor = self.hive_conn.cursor()


    def tearDown(self):
        self.hive_cursor.close()
        self.hive_conn.close()

    def assert_table_data(self,  table_name):
        count_sql = """select count(*) from %s"""
        self.hive_cursor.execute(count_sql % table_name)
        table_data = [x[0] for x in self.hive_cursor.fetchall()]
        print(table_data)
        self.assertEquals(table_data[0], 2)

    def assert_db_tables(self, target_database):
        #verification check that new database is created and has same number of tables as source database
        self.hive_cursor.execute('USE %s' % target_database)
        self.hive_cursor.execute('SHOW TABLES')
        hive_tables = [x[0] for x in self.hive_cursor.fetchall()]
        print(hive_tables)
        self.assertEquals(2, len(hive_tables))

        #make sure each two tables have expected number of records

        self.assert_table_data('table1')
        self.assert_table_data('table2')


    def create_test_db(self, source_database):
        #drop database if exist
        self.hive_cursor.execute('DROP DATABASE IF EXISTS %s CASCADE' % source_database)

        #create database
        self.hive_cursor.execute('CREATE DATABASE IF NOT EXISTS %s' % source_database)

        # change db to the target_database
        self.hive_cursor.execute('USE %s' % source_database)

        #create two tables
        table_sql = """CREATE TABLE %s (`customerid` int, `practiceid` int, `notes` string)
                COMMENT 'Table in ORC format'
                PARTITIONED BY(partitionCustomerId int)
                ROW FORMAT DELIMITED 
                FIELDS TERMINATED BY '\001'
                STORED AS ORC"""

        self.hive_cursor.execute(table_sql % 'table1')
        self.hive_cursor.execute(table_sql % 'table2')

        table_data_sql = """insert into  table  %s partition (partitioncustomerid=%s) values( %s, %s, '%s')"""

        self.hive_cursor.execute(table_data_sql % ('table1', 1, 1, 1, 'test1') )
        self.hive_cursor.execute(table_data_sql % ('table1', 1, 1, 2, 'test2') )

        self.hive_cursor.execute(table_data_sql % ('table2', 11, 11, 1, 'test11') )
        self.hive_cursor.execute(table_data_sql % ('table2', 12, 11, 2, 'test12') )



    def test_rename_hive_db_tables(self):
        sqlserver_date = datetime.datetime.now().strftime('%Y_%m_%d_%H_%M_%S')[:-3]

        #create a source database which we will use for backup
        source_database = 'unit_test_backdb'
        target_database = '%s_%s' % (source_database, sqlserver_date)

        try:

            self.create_test_db(source_database)

            hive_tools = HiveTools(self.hive_cursor)
            target_dir = '/user/%s/test_hive_backups/%s' % (self.user, sqlserver_date)

            print('Going to RENAME_BACKUP database from source db: %s to target db: %s' % (source_database, target_database))
            hive_tools.rename_hive_db_tables(source_database,  target_database, False)

            self.assert_db_tables(target_database)

        #finally drop the target database
        finally:
            self.hive_cursor.execute('DROP DATABASE IF EXISTS %s CASCADE' % target_database)

    def test_backup_hive_db(self):
        sqlserver_date = datetime.datetime.now().strftime('%Y_%m_%d_%H_%M_%S')[:-3]

        #create a source database which we will use for backup
        source_database = 'unit_test_backdb'
        target_database = '%s_%s' % (source_database, sqlserver_date)

        try:

            self.create_test_db(source_database)

            hive_tools = HiveTools(self.hive_cursor)
            target_dir = '/user/%s/test_hive_backups/%s' % (self.user, sqlserver_date)

            print('Going to BACKUP database from source db: %s to target db: %s' % (source_database, target_database))
            hive_tools.backup_hive_db(source_database, target_dir, target_database, False)

            self.assert_db_tables(target_database)

        #finally drop the target database
        finally:
            self.hive_cursor.execute('DROP DATABASE %s CASCADE' % target_database)

    def test_restore_hive_db(self):
        sqlserver_date = datetime.datetime.now().strftime('%Y_%m_%d_%H_%M_%S')[:-3]

        #create a source database which we will use for backup
        source_database = 'unit_test_restoredb'
        target_database = '%s_%s' % (source_database, sqlserver_date)

        try:

            self.create_test_db(source_database)

            hive_tools = HiveTools(self.hive_cursor)
            target_dir = '/user/%s/test_hive_restores/%s' % (self.user, sqlserver_date)

            print('Going to RESTORE database from source db: %s to target db: %s' % (source_database, target_database))
            hive_tools.backup_hive_db(source_database, target_dir, target_database, False)

            self.assert_db_tables(target_database)

        #finally drop the target database
        finally:
            self.hive_cursor.execute('DROP DATABASE IF EXISTS %s CASCADE' % target_database)




if __name__ == '__main__':
    unittest.main()
