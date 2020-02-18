#!/usr/bin/env python
"""
This is a tool to backup and restore hive dbs
"""
import argparse
from datetime import datetime, timedelta
import getpass
import re
import sys

from config import Config
from ConfigParser import ConfigParser
from subprocess import Popen, PIPE

from impala.dbapi import connect
from impala.error import HiveServer2Error

# we will export the database tables to /user/user1/target_database_todays_date
# if target dir exists we will error out

# hive export
# export table department to 'hdfs_exports_location/department';
export_sql = """export table %s to '%s/%s'"""

# import from 'hdfs_exports_location/department';
import_sql = """import from '%s/%s'"""

# rename source db table to target db
# alter table claim rename to glball_rename_test.claim
rename_sql = """ALTER TABLE %s RENAME TO %s.%s"""

datetime_pattern = """%Y_%m_%d_%H_%M"""

HIVE_DB_BACKUP_PATTERN = re.compile("[(a-zA-Z|_)]+_(\d\d\d\d)_(\d\d)_(\d\d)_(\d\d)_(\d\d)")


class HiveTools:
    def __init__(self, hive_cursor):
        self.hive_cursor = hive_cursor
        self.config = Config()
        self.logger = self.config.get_logger(__package__)

    def validate_user_input(self, prompt_user, target_database):
        self.logger.info("Validate user input")
        self.logger.debug("Prompt user: %s, target database: %s" % (prompt_user, target_database))

        if prompt_user:
            user_input = raw_input("Going to drop database: %s, do you want to continue (Y/N)" % target_database)
            if user_input.lower() != 'y':
                print("User does not wants to continue")
                sys.exit(1)

    def import_hive_db(self, target_database, source_dir, hive_tables, prompt_user):
        self.logger.debug("Import Hive DB")
        self.logger.debug("Tables: %s from source dir: %s to target db: %s" % (
            str(hive_tables), source_dir, target_database))

        self.validate_user_input(prompt_user, target_database)

        # drop the target database and all its table
        self.hive_cursor.execute('DROP DATABASE IF EXISTS %s CASCADE' % target_database)

        # create database
        self.hive_cursor.execute('CREATE DATABASE IF NOT EXISTS %s' % target_database)

        # change db to the target_database
        self.hive_cursor.execute('USE %s' % target_database)

        for table in hive_tables:
            table = table.strip()
            if table.startswith('values__tmp__'):
                continue

        sql = import_sql % (source_dir, table)
        self.logger.debug("Import table: %s using sql: %s" % (table, sql))

        self.hive_cursor.execute(sql)

    def export_hive_db(self, source_database, target_dir):
        self.logger.info("Export Hive DB")
        self.logger.debug("Source database: %s to target dir: %s" % (source_database, target_dir))

        # Get list of tables in Hive from source_database
        self.hive_cursor.execute('USE %s' % source_database)
        self.hive_cursor.execute('SHOW TABLES')
        hive_tables = [x[0] for x in self.hive_cursor.fetchall()]

        for table in hive_tables:
            table = table.strip()
            sql = export_sql % (table, target_dir, table)
            self.logger.debug("exporting table: %s using sql: %s" % (table, sql))

            self.hive_cursor.execute(sql)

        return hive_tables

    def rename_hive_db_tables(self, source_database, target_database, prompt_user):
        self.logger.info("Rename Hive DB tables")
        self.logger.debug("Source database: %s, Target database: %s, Prompt user: %s" % (
        source_database, target_database, prompt_user))
        try:
            self.validate_user_input(prompt_user, target_database)

            # Get list of tables in Hive from source_database
            self.hive_cursor.execute('USE %s' % source_database)
            self.hive_cursor.execute('SHOW TABLES')
            hive_tables = [x[0] for x in self.hive_cursor.fetchall()]

            # drop the target database and all its table
            self.hive_cursor.execute('DROP DATABASE IF EXISTS %s CASCADE' % target_database)

            # create database
            self.hive_cursor.execute('CREATE DATABASE IF NOT EXISTS %s' % target_database)

            self.logger.debug(
                "Renaming tables in source database: %s to target db: %s" % (source_database, target_database))
            self.logger.debug("source db: %s tables are: %s" % (source_database, str(hive_tables)))

            for table in hive_tables:
                table = table.strip()
                if table.startswith('values__tmp__'):
                    continue

                sql = rename_sql % (table, target_database, table)
                self.logger.debug("Renaming table: %s using sql: %s" % (table, sql))

                self.hive_cursor.execute(sql)
        except HiveServer2Error:
            print "HIVE database %s does not exist, nothing to backup" % source_database

    @staticmethod
    def get_db_datetime(db_name):
        """
        Obtains the datetime of a backup DB

        :param db_name: A backup DB ending in YYYY_MM_DD_HH_MI
        :type db_name: str
        :return: The corresponding datetime
        :rtype: datetime
        """
        dt_tokens = db_name.split('_')
        dt_str = '_'.join(dt_tokens[-5:])
        return datetime.strptime(dt_str, datetime_pattern)

    def filter_db_backups_to_drop(self, db_names, threshold_dt):
        """
        Filters a list of backup DBs older than the threshold datetime

        :param db_names: A list of DB names
        :type db_names: list of str
        :param threshold_dt: The threshold datetime
        :type threshold_dt: datetime
        :return: Filtered list of DB names older than the threshold datetime
        :rtype: list of str
        """
        self.logger.info('Filter DBs to drop')
        self.logger.debug('Filter DBs to drop Threshold Dt: %s' % threshold_dt)
        now = datetime.now()
        dbs_to_drop = []
        for db_name in db_names:
            db_dt = HiveTools.get_db_datetime(db_name)
            if db_dt is not None and db_dt < threshold_dt:
                    dbs_to_drop.append(db_name)
        self.logger.debug('Filtered Hive DB backups to drop: %s' % dbs_to_drop)
        return dbs_to_drop

    def drop_hive_dbs(self, dbs_to_drop):
        """
        Drops multiple Hive DBs

        :param dbs_to_drop: A list of DB names to drop
        :type dbs_to_drop: list of str
        :return: A list of DB names that were successfully dropped
        :rtype: list of str
        """
        self.logger.info('Drop Hive DBs')
        dropped_dbs = []
        for db_name in dbs_to_drop:
            try:
                self.logger.debug("Dropping db %s" % db_name)
                self.hive_cursor.execute('DROP DATABASE IF EXISTS %s CASCADE' % db_name)
                dropped_dbs.append(db_name)
            except HiveServer2Error as err:
                print "Unable to drop Hive DB %s" % db_name
                print err
        return dropped_dbs

    def get_hive_backup_dbs(self, source_db):
        """
        Obtains a list of backup DBs for a given source DB

        :param source_db: Source DB Name
        :type source_db: str
        :return: List of backup DBs
        :rtype: list of str
        """
        self.logger.info('Get Hive DBs')
        self.logger.debug('Get Hive DBs for source DB: %s' % source_db)
        try:
            # Get list of tables in Hive from source_database
            self.hive_cursor.execute('SHOW DATABASES')
            result = self.hive_cursor.fetchall()
            hive_backup_dbs = []
            for db in result:
                db_name = db[0]
                if HIVE_DB_BACKUP_PATTERN.match(db_name) and db_name.startswith(source_db):
                    hive_backup_dbs.append(db_name)
            self.logger.debug('Got Hive backup DBs: %s' % hive_backup_dbs)
            return hive_backup_dbs
        except HiveServer2Error as err:
            print "Unable to get list of Hive DBs"
            print err
            raise Exception("Unable to list of Hive DBs")

    def drop_old_hive_db_backups(self, source_db, backup_days):
        self.logger.info("Drop Hive DB backups")
        self.logger.debug("Drop Hive HB backups source DB: %s older than days: %s days" % (source_db, backup_days))

        threshold_dt = datetime.now() - timedelta(days=backup_days)
        hive_dbs = self.get_hive_backup_dbs(source_db)
        dbs_to_drop = self.filter_db_backups_to_drop(hive_dbs, threshold_dt)
        dropped_dbs = self.drop_hive_dbs(dbs_to_drop)

        failed_dbs = list(set(dbs_to_drop)-set(dropped_dbs))
        assert len(failed_dbs) == 0, 'Failed to drop some DBs: %s' % failed_dbs

    def delete_hdfs_dir(self, target_dir):
        self.logger.info("Delete HDFS dir")
        command = 'hdfs dfs -rm -r %s' % target_dir
        self.logger.debug('Delete target dir: %s using command: %s' % (target_dir, command))

        p = Popen(command.split(' '), stdout=PIPE, stderr=PIPE)
        stdout, stderr = p.communicate()
        self.logger.debug(stdout)
        self.logger.error(stderr)

    def backup_hive_db(self, source_database, target_dir, target_database, prompt_user):
        self.logger.info("Backup Hive DB")
        self.logger.debug("Source database: %s, target dir: %s, target database: %s, prompt user: %s" % (
            source_database, target_dir, target_database, prompt_user))
        try:
            hive_tables = self.export_hive_db(source_database, target_dir)
            self.import_hive_db(target_database, target_dir, hive_tables, prompt_user)
        finally:
            self.delete_hdfs_dir(target_dir)

    def restore_hive_db(self, source_database, target_dir, target_database, prompt_user):
        self.logger.info("Restore Hive DB")
        self.logger.debug("Source database: %s, target dir: %s, target database: %s, prompt user: %s" % (
            source_database, target_dir, target_database, prompt_user))
        try:
            hive_tables = self.export_hive_db(source_database, target_dir)
            self.import_hive_db(target_database, target_dir, hive_tables, prompt_user)
        finally:
            self.delete_hdfs_dir(target_dir)

    def get_table_names(self, source_dir, command):
        self.logger.debug("Get table names")
        self.logger.debug("Source dir: %s, command: %s" % (source_dir, command))

        p = Popen(command.split(' '), stdout=PIPE, stderr=PIPE)
        stdout, stderr = p.communicate()
        self.logger.debug(stdout)
        self.logger.error(stderr)

    def is_db_exists(self, db):
        self.logger.info("Is DB exists")
        self.logger.debug("DB: %s" % db)

        sql = """show databases like '%s' """ % db
        self.hive_cursor.execute(sql)
        hive_dbs = [x[0] for x in self.hive_cursor.fetchall()]

        if len(hive_dbs) == 1:
            return True
        else:
            return False


def main(arguments):
    parser = argparse.ArgumentParser(description='import export hive databases')
    parser.add_argument('action', help='what action to execute, ex: rename_backup|rename_restore|backup|restore')
    parser.add_argument('--prompt-user', dest='prompt_user', action='store_true',
                        help='prompt user when certain actions could be dangerous')
    parser.add_argument('--no-prompt_user', dest='prompt_user', action='store_false',
                        help='do not prompt user when certain actions could be dangerous')
    parser.set_defaults(prompt_user=True)

    parser.add_argument('-tdb', '--target_database', help='which database to import tables to')
    parser.add_argument('-sdb', '--source_database', help='which database to export or import tables from')
    parser.add_argument('-sdir', '--source_dir', help='which source dir to import tables from')
    args = parser.parse_args(arguments)
    action = args.action
    prompt_user = args.prompt_user
    target_database = args.target_database
    source_database = args.source_database
    config = Config()
    logger = config.get_logger(__package__)

    logger.info("Hive tools main")
    logger.debug("Action: %s target_database: %s source_database: %s" % (action, target_database, source_database))

    # Load configuration data from config.ini
    cfg = ConfigParser()
    try:
        cfg.read('config.ini')
        hive_server = cfg.get('hive', 'server')
        hive_port = cfg.get('hive', 'port')
        hive_auth = cfg.get('hive', 'auth')
        hive_db = cfg.get('hive', 'database')
    except Exception as err:
        print "Error while loading configuration file"
        print err
        sys.exit(1)

    user = getpass.getuser()
    logger.debug("User is: %s" % user)

    hive_conn = connect(host=hive_server, port=hive_port, auth_mechanism=hive_auth)
    hive_cursor = hive_conn.cursor()

    try:

        hive_cli = HiveTools(hive_cursor)

        if action == 'rename_backup':

            if source_database is None:
                logger.error('source database must be specified')
                sys.exit(1)

            if not hive_cli.is_db_exists(source_database):
                logger.error('source database : %s does not exists' % source_database);
                sys.exit(0)

            sqlserver_date = datetime.datetime.now().strftime(datetime_pattern)[:-3]
            target_database = '%s_%s' % (source_database, sqlserver_date)

            logger.debug('Going to %s database from source db: %s to target db: %s' % (
                action.upper(), source_database, target_database))
            hive_cli.rename_hive_db_tables(source_database, target_database, prompt_user)

        elif action == 'rename_restore':

            if source_database is None:
                logger.error('source database must be specified')
                sys.exit(1)

            if target_database is None:
                logger.error('target database must be specified')
                sys.exit(1)

            logger.debug('Going to %s database from source db: %s to target db: %s' % (
                action.upper(), source_database, target_database))
            hive_cli.rename_hive_db_tables(source_database, target_database, prompt_user)

        elif action == 'backup':

            if source_database is None:
                logger.error('source database must be specified')
                sys.exit(1)

            if not hive_cli.is_db_exists(source_database):
                logger.error('source database : %s does not exists' % source_database);
                sys.exit(0)

            sqlserver_date = datetime.datetime.now().strftime(datetime_pattern)[:-3]
            target_dir = '/user/%s/hive_backups/%s' % (user, sqlserver_date)
            target_database = '%s_%s' % (source_database, sqlserver_date)

            logger.debug('Going to %s database from source db: %s to target db: %s' % (
                action.upper(), source_database, target_database))
            hive_cli.backup_hive_db(source_database, target_dir, target_database, prompt_user)

        elif action == 'restore':

            if source_database is None:
                logger.error('source database must be specified')
                sys.exit(1)

            if target_database is None:
                logger.error('target database must be specified')
                sys.exit(1)

            sqlserver_date = datetime.datetime.now().strftime(datetime_pattern)[:-3]
            target_dir = '/user/%s/hive_restores/%s' % (user, sqlserver_date)

            logger.debug('Going to %s database from source db: %s to target db: %s' % (
                action.upper(), source_database, target_database))
            hive_cli.restore_hive_db(source_database, target_dir, target_database, prompt_user)

        else:
            logger.error("Unsupported action  %s " % action)
            sys.exit(1)

    finally:
        hive_cursor.close()
        hive_conn.close()


if __name__ == '__main__':
    logger.debug("Args are: %s " % sys.argv[1:])
    main(sys.argv[1:])
