#!/usr/bin/env python

import argparse
import time

from config import Config
from pyspark import SparkConf, SparkContext
from pyspark.sql import HiveContext
from pyspark.sql.functions import regexp_replace, col

from db_import_definitions import DbImportDefinition
from db_import_definitions import ImportTableDef
from db_import_definitions import ImportGroup
from db_manager import DbManager

db_manager = DbManager()
hive_conn_conf = db_manager.get_db_conn_properties("hive")
shared_conn_conf = db_manager.get_db_conn_properties("shared")


conf = (SparkConf().setAppName("data_import").setMaster("local"))
conf.set('spark.ui.enabled', 'false')
sc = SparkContext(conf=conf)

hive_sql_ctx = HiveContext(sc)
# TODO: Configure for HA
hive_sql_ctx.setConf("hive.metastore.uris", "thrift://%s:9083" % hive_conn_conf["db_metastore"])
hive_sql_ctx.setConf("hive.exec.dynamic.partition", "true")
hive_sql_ctx.setConf("hive.exec.dynamic.partition.mode", "nonstrict")


config = Config()
logger = config.get_logger(__package__)

STAGING_SUFFIX = '_staging'


def generate_column_list(table_columns):
    logger.debug("Generate column list")
    logger.debug("Table columns: %s" % table_columns)
    columns_string = ""
    for column in table_columns:
        columns_string += "%s," % ("[" + column["COLUMN_NAME"] + "]")

    # Remove the trailing comma at the end of the string
    return columns_string[:-1]


def generate_select_query(table, fields, db_conf, import_group):
    logger.info("Generate select query")
    logger.debug("Table: %s, fields: %s, db conf: %s, import group: %s" %
                 (table, fields, db_conf, import_group))
    select_columns = generate_column_list(fields)

    if import_group[ImportGroup.PARTITION_FIELD] is None:
        query = "(SELECT %s FROM %s WITH (NOLOCK)) t" % (select_columns, table)
    else:
        query = "(SELECT %s, %s as %s FROM %s WITH (NOLOCK)) t" % (select_columns, db_conf["customer_id"],
                                                                  import_group[ImportGroup.PARTITION_FIELD], table)
    logger.debug("Query: %s" % query)
    return query


def replace_line_terminators(data_frame):
    logger.info("Replace line terminators")
    logger.debug("Data frame: %s" % data_frame)
    ct_dict = dict(data_frame.dtypes)
    return data_frame.select(
        *[regexp_replace(col(column), "\r\n|\r|\n|\01", "").alias(column) if ct_dict[column] == 'string' else column for column in
          data_frame.columns])


def import_table(table, fields, db_conf, import_group):
    logger.info("Import table")
    logger.debug("Table: %s, fields: %s, db conf: %s, import group: %s" %
                 (table, fields, db_conf, import_group))
    select_query = generate_select_query(table, fields, db_conf, import_group)
    logger.debug("Select query: %s" % select_query)

    connection_string = db_manager.get_mssql_connection_string(db_conf["src_db_host"], db_conf["src_db_name"])
    logger.debug("Connection string: %s" % connection_string)

    start = time.time()

    data_frame = hive_sql_ctx.read.format('jdbc').options(url=connection_string, dbtable=select_query).load()
    data_frame = replace_line_terminators(data_frame)

    hive_sql_ctx.sql("use %s" % db_conf["target_db_name"])

    data_frame.write.mode('append').format('orc')\
        .saveAsTable("%s" % table + STAGING_SUFFIX, partitionBy=import_group[ImportGroup.PARTITION_FIELD])

    end = time.time()
    elapsed = elapsed_time(start, end)
    logger.info("End importing table: %s, elapsed: %s" % (table, elapsed))

def cleanup_table(table, db_conf, import_group):
    logger.info("Cleanup table")
    logger.debug("Table: %s,  db conf: %s, import group: %s" %
                (table, db_conf, import_group))
    target_table_name = "%s.%s%s" % (db_conf["target_db_name"], table, STAGING_SUFFIX)

    # CLEANUP BEFORE EACH ATTEMPT
    if import_group[ImportGroup.PARTITION_FIELD] is None:
        cleanup_query = "TRUNCATE TABLE {0}".format(target_table_name)
    else:
        cleanup_query = "ALTER TABLE {0} DROP IF EXISTS PARTITION (partitioncustomerid={1})".format(
            target_table_name, db_conf["customer_id"])

    logger.debug("Executing Cleanup Query: %s" % cleanup_query)
    db_manager.execute_hive_query("hive_global", cleanup_query)

def import_table_with_retries(table_name, columns_definition, db_conf, import_group):
    success = False
    retry = int(config.get("INGESTION", "max_retries"))
    ex = None
    while retry > 0 and not success:
        try:
            logger.debug("Importing table %s, attempts left: %s" % (table_name, retry))
            import_table(table_name, columns_definition, db_conf, import_group)
            success = True
        except Exception as exception:
            logger.error("Failed to import Table: %s, db conf: %s, import group: %s" %
                         (table_name, db_conf, import_group))
            retry = retry - 1
            ex = exception
            cleanup_table(table_name, db_conf, import_group)

    if not success:
        logger.error(
            "Reached max number of retries, Table Name: %s, DB conf: %s,  imporg group: %s, original exception: %s" %
            (table_name, db_conf, import_group, ex))
        raise Exception("Reached max number of retries: %s" % ex)

def import_db(db_conf, db_import_definition, import_group):
    logger.info("Import DB")
    logger.debug("DB conf: %s, db import definition %s, imporg group: %s" %
                 (db_conf, db_import_definition, import_group))
    table_definitions = db_import_definition.get_db_definition()

    for table_name, table_to_import in table_definitions.items():  #type: ImportTableDef

        columns_definition = table_to_import.column_definitions
        table_name = table_name.strip()
        start = time.time()
        logger.info("Begin importing table: %s" % table_name)
        import_table_with_retries(table_name, columns_definition, db_conf, import_group)
        end = time.time()
        elapsed = elapsed_time(start, end)
        logger.info("End importing table: %s, elapsed: %s" % (table_name, elapsed))


def get_db_import_definition(import_group):
    logger.info("Get DB import definition")
    logger.debug("Import group: %s" % import_group)
    return DbImportDefinition(import_group[ImportGroup.IMPORTABLE_DB])


def get_dbs_to_import_from_file(dbs_to_import_file):
    logger.info("Get DBs to import from file")
    logger.debug("DBs to import file: %s" % dbs_to_import_file)
    with open(dbs_to_import_file) as f:
        import_file_lines = f.readlines()
        dbs_to_import = []

        for line in import_file_lines:
            line = line.strip()

            logger.debug("Line: %s" % line)
            db_conf = line.split('\t')[1]
            (db_host, db_name, customer_id, hive_db_name) = db_conf.split('|')
            dbs_to_import.append({"src_db_host": db_host, "src_db_name": db_name,
                                  "target_db_name": hive_db_name, "customer_id": customer_id})

        return dbs_to_import


def elapsed_time(start,end):
    hours, rem = divmod(end-start, 3600)
    minutes, seconds = divmod(rem, 60)
    if hours > 0:
        return "%2dhrs %2dmin %2dsec" % (hours, minutes, seconds)
    elif minutes > 0:
        return "%2dmin %2dsec" % (minutes, seconds)
    else:
        return "%2dsec" % seconds


def main(import_group_name, dbs_to_import_file):
    logger.debug("Spark DB importer main")
    logger.debug("Group: %s, file: %s" % (import_group_name, dbs_to_import_file))
    import_group = ImportGroup.get_by_name(import_group_name)
    db_import_definition = get_db_import_definition(import_group)
    dbs_to_import = get_dbs_to_import_from_file(dbs_to_import_file)

    for db_conf in dbs_to_import:
        logger.debug("Calling import db, db conf: %s" % db_conf)
        import_db(db_conf, db_import_definition, import_group)


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description="Imports a group of databases using spark")
    parser.add_argument("import_group_name", choices=ImportGroup.IMPORT_GROUPS,
                        help="The group of databases to be imported")
    parser.add_argument("dbs_to_import_file", help="File containing all the dbs to be imported")

    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())