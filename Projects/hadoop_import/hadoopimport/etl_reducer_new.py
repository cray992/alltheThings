#!/usr/bin/env python

from __future__ import print_function

import argparse
import logging
import sys

from config import Config
from hive_db_manager import HiveDbManager, HiveDbName

config = Config()
logger = config.get_logger(__package__)

hive_db_mgr = HiveDbManager(db_name=HiveDbName.ETL)


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
    hive_db_mgr.execute_query(query)


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
                except Exception:
                    sys.exit(1)


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description='Reducer to run ETLs.')
    return vars(parser.parse_args())

if __name__ == "__main__":
    main(**parse_command_line_arguments())

