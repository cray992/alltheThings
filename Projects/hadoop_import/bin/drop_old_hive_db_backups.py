#!/usr/bin/env python

import argparse
import datetime

from hadoopimport.db_manager import DbManager
from hadoopimport.hive_tools import HiveTools
from hadoopimport.config import Config

config = Config()
logger = config.get_logger('bin')     # __package__ is None

def main(source_db, backup_days):
    backup_days = int(backup_days)
    logger.info("Executing drop old Hive DB backups main")
    logger.debug("Source DB: %s, Backup Days: %s" % (source_db, backup_days))
    db_manager = DbManager()
    hive_cursor = db_manager.get_hive_cursor()
    hive_tools = HiveTools(hive_cursor)

    if source_db == "all":
        hive_dbs = db_manager.get_hive_dbs()
        for db in hive_dbs:
            hive_tools.drop_old_hive_db_backups(db["db_name"], backup_days)
    else:
        source_db_name = db_manager.get_db_conn_properties(source_db)["db_name"]
        hive_tools.drop_old_hive_db_backups(source_db_name, backup_days)


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description='Drop old HIVE database backups')
    parser.add_argument('source_db')
    parser.add_argument('backup_days')
    return vars(parser.parse_args())

if __name__ == '__main__':
    main(**parse_command_line_arguments())
