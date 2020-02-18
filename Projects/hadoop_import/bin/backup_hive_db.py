#!/usr/bin/env python

import argparse
import datetime

from hadoopimport.db_manager import DbManager
from hadoopimport.hive_tools import HiveTools
from hadoopimport.config import Config

config = Config()
logger = config.get_logger('bin')     # __package__ is None

def main(source_db):
    logger.info("Executing backup Hive DB main")
    logger.debug("Source DB: %s" % source_db)
    db_manager = DbManager()
    hive_cursor = db_manager.get_hive_cursor()
    hive_tools = HiveTools(hive_cursor)

    current_date = datetime.datetime.now().strftime("%Y_%m_%d_%H_%M_%S")[:-3]

    if source_db == "all":
        hive_dbs = db_manager.get_hive_dbs()
        for db in hive_dbs:
            hive_tools.rename_hive_db_tables(db["db_name"], "%s_%s" % (db["db_name"], current_date), False)
    else:
        source_db_name = db_manager.get_db_conn_properties(source_db)["db_name"]
        target_db = '%s_%s' % (source_db, current_date)
        hive_tools.rename_hive_db_tables(source_db_name, target_db, False)


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description='Backup a HIVE database')
    parser.add_argument('source_db')
    return vars(parser.parse_args())

if __name__ == '__main__':
    main(**parse_command_line_arguments())
