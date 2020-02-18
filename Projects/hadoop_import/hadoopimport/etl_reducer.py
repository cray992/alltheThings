#!/usr/bin/env python

from __future__ import print_function

import argparse
import logging
import sys

from config import Config
from db_manager import DbManager, SQLException

# Name of the connection to the global database that aggregates all  customer data
HIVE_GLOBAL = "hive_global"

# Name of the connection to the database that houses the ETL tables
HIVE_ETL = "hive_etl"

config = Config()
logger = config.get_logger(__package__)

db_manager = DbManager()
hive_global_conf = db_manager.get_db_conn_properties(HIVE_GLOBAL)


def prepare_etl_script(etl_script):
    logger.info("Prepare ETL script")
    logger.debug("ETL Script:\n%s" % etl_script)
    script_statements = etl_script.split(";")
    return script_statements


def is_blank_statement(statement):
    return statement is None or statement.isspace()


def execute_statement(statement):
    logger.info("Execute statement")
    query = statement.strip()
    logger.debug("Query: %s" % query)
    db_manager.execute_query_with_connection(HIVE_ETL, query)


def main():
    logger.info("ETL Reducer main")
    reducer_input = sys.stdin.readlines()

    for etl_script in reducer_input:
        script_name, script_content = etl_script.split('|')
        script_statements = prepare_etl_script(script_content)
        logger.debug("Script name: %s\nStatements:%s" % (script_name, script_statements))

        for statement in script_statements:
            if not is_blank_statement(statement):
                try:
                    execute_statement(statement)
                except SQLException:
                    sys.exit(1)


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description='Reducer to run ETLs.')
    return vars(parser.parse_args())

if __name__ == "__main__":
    main(**parse_command_line_arguments())

