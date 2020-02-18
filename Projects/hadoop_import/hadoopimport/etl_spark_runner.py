#!/usr/bin/env python
from __future__ import print_function

import sys
import argparse
from config import Config

from pyspark import SparkConf, SparkContext
from pyspark.sql import HiveContext

from db_manager import DbManager

config = Config()
logger = config.get_logger(__package__)

def get_spark_context(job_name):
    logger.info("Get Spark context")
    logger.debug("Job name: %s" % job_name)
    conf = (SparkConf()
            .setAppName("ETL on Spark Engine"))
    conf.set('spark.ui.enabled', 'true')
    spark_context = SparkContext(conf=conf)
    spark_context.setJobGroup("ETL", job_name)

    return spark_context


def get_sql_context(spark_context, hive_metastore):
    logger.info("Get SQL context")
    logger.debug("Spark context: %s, Hive metastore: %s" % (spark_context, hive_metastore))
    sql_context = HiveContext(spark_context)
    sql_context.setConf("hive.metastore.uris", "thrift://%s:9083" % hive_metastore)
    sql_context.setConf("hive.exec.dynamic.partition", "true")
    sql_context.setConf("hive.exec.dynamic.partition.mode", "nonstrict")
    sql_context.setConf("spark.sql.hive.convertMetastoreOrc", "false")

    return sql_context


def run_sql(sql, sql_context):
    logger.info("Run SQL")
    query = sql.strip()
    logger.debug('Now running SQL %s' % query)
    sql_context.sql(query)
    logger.info('Query executed successfully')


def main(etl_script_file):
    logger.info("ETL Spark runner main")
    logger.debug("ETL script file: %s" % etl_script_file)
    db_manager = DbManager()
    hive_conf = db_manager.get_db_conn_properties("hive")

    spark_context = get_spark_context(etl_script_file)
    sql_context = get_sql_context(spark_context, hive_conf["db_metastore"])

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
                    run_sql(sql, sql_context)
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
