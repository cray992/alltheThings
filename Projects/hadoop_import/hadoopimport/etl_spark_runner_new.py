#!/usr/bin/env python
from __future__ import print_function

import sys
import argparse
from config import Config

from pyspark.sql import SparkSession

from hive_schema_manager import HiveSchemaManager
from hive_db_manager import HiveDbManager, HiveDbName

config = Config()
logger = config.get_logger(__package__)

def get_spark_session():
    """
    Returns a SparkSession with hive support enabled
    :rtype: SparkSession
    """
    logger.debug("Get Spark Session")
    hive_metastore = HiveSchemaManager.get_metastore()
    spark_session = SparkSession \
        .builder \
        .appName("data_import") \
        .config("spark.ui.enabled", "false") \
        .config("hive.metastore.uris", "thrift://%s:9083" % hive_metastore) \
        .config("hive.exec.dynamic.partition", "true") \
        .config("hive.exec.dynamic.partition.mode", "nonstrict") \
        .enableHiveSupport() \
        .getOrCreate()
    return spark_session


def run_sql(sql, spark_session):
    logger.info("Run SQL")
    query = sql.strip()
    logger.debug('Now running SQL %s' % query)
    spark_session.sql(query)
    logger.info('Query executed successfully')


def main(etl_script_file):
    logger.info("ETL Spark runner main")
    logger.debug("ETL script file: %s" % etl_script_file)

    hive_db_mgr = HiveDbManager()
    etl_db_conn_conf = hive_db_mgr.get_db_conn_conf_for_conn_name(HiveDbName.ETL)

    spark_session = get_spark_session()
    logger.debug("USE %s" % etl_db_conn_conf.db_name)
    spark_session.sql("USE %s" % etl_db_conn_conf.db_name)

    try:
        with open(etl_script_file, 'r') as etl_file:
            logger.debug("Running etl script- %s" % etl_script_file)

            content = etl_file.read()
            etl_content = ' '.join(content.splitlines())

            logger.debug("ETl content: %s" % etl_content)

            # extract sql statements from script file
            script = etl_content.split(';')

            for sql in script:
                if sql and not sql.isspace():
                    logger.debug("SQL: %s" % sql)
                    run_sql(sql, spark_session)
                    logger.debug("Finished running SQL")

            logger.info("End of running ETL script")
    except Exception as err:
        logger.error("Error running ETL script error: %s" % err.message)
        sys.exit(1)


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description='Spark ETL runner')
    parser.add_argument('etl_script_file', help='ETL file to execute')
    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())
