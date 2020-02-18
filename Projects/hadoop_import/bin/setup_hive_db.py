#!/usr/bin/env python

"""
This should be only be run ONCE to create the Initial HIVE Databases and Tables
"""
import argparse
import os

from hadoopimport.config import Config
from hadoopimport.db_import_definitions import DbImportDefinition
from hadoopimport.db_import_definitions import ImportTableDef
from hadoopimport.db_import_definitions import DatabaseType
from hadoopimport.db_manager import DbManager

config = Config()
logger = config.get_logger('bin')

db_manager = DbManager()


def create_etl_db_tables(etl_database='hive_etl'):
    logger.info("Create ETL DB tables")
    script_file = os.path.join(os.path.abspath(os.path.dirname(__file__)), '../setup_scripts/create_etl_tables.hive')
    db_manager.execute_hive_script_file(etl_database, script_file)
    logger.info("End of create ETL DB tables")


def create_customer_db_tables():
    logger.info("Create Customer DB tables")
    customer_db_import_definition = DbImportDefinition(DatabaseType.CUSTOMER)
    create_tables(customer_db_import_definition, "hive_global")
    logger.info("End of create Customer DB tables")


def create_salesforce_db_tables():
    logger.info("Create Salesforce DB tables")
    salesforce_db_import_definition = DbImportDefinition(DatabaseType.SALESFORCE)
    create_tables(salesforce_db_import_definition, "hive_salesforce")
    logger.info("End of create Salesforce DB tables")


def create_shared_db_tables():
    logger.info("Create Shared DB tables")
    shared_db_import_definition = DbImportDefinition(DatabaseType.SHARED)
    create_tables(shared_db_import_definition, "hive_shared")
    logger.info("End of create Shared DB tables")


def generate_create_table_query(import_table_def):
    '''
    :type import_table_def: ImportTableDef
    :rtype:  str
    '''
    logger.info("Generate create table query")

    column_names = generate_column_list(import_table_def.column_definitions)
    partition_fields = import_table_def.partition_fields
    merge_match_buckets = import_table_def.merge_match_buckets
    table_name = import_table_def.table_name
    num_buckets = import_table_def.num_buckets

    buckets_settings = ''
    transactional_setting = ''
    partition_settings = ''

    # Separating parts of the create table query settings
    if len(partition_fields) != 0:
        partition_fields_str = " ,".join(partition_fields)
        partition_settings = "PARTITIONED BY ({0} int)".format(partition_fields_str)

    if len(merge_match_buckets) != 0:
        merge_match_buckets_str = " ,".join(merge_match_buckets)
        buckets_settings = 'clustered by ({0}) into {1} buckets'.format(merge_match_buckets_str, num_buckets)
        transactional_setting = ', "transactional"="true"'

    tbl_properties = '("orc.compress"="SNAPPY" {0})'.format(transactional_setting)

    create_table_query = 'CREATE TABLE `{0}` ({1}) {2} {3} STORED AS ORC TBLPROPERTIES {4}'.format(
        table_name, column_names, partition_settings, buckets_settings, tbl_properties)

    logger.debug("Table name: %s, table column: %s, partition field: %s, bucketing_columns: %s" %
                 (table_name, column_names, partition_fields, merge_match_buckets))
    logger.debug("Create table query:\n %s" % create_table_query)
    return create_table_query


def generate_column_list(table_columns):
    logger.info("Generate column list")
    logger.debug("Table columns: %s" % table_columns)
    columns_string = ""
    for column in table_columns:
        columns_string += "`%s` %s," % (column["COLUMN_NAME"], sql_data_type_to_hive(column))

    logger.debug("Column string:\n %s" % columns_string[:-1])
    # Remove the trailing comma at the end of the string
    return columns_string[:-1]


def sql_data_type_to_hive(column_definition):
    logger.info("SQL data type to Hive")
    logger.debug("Column definition: %s" % column_definition)
    data_type = column_definition["DATA_TYPE"]
    precision = column_definition["NUMERIC_PRECISION"]
    scale = column_definition["NUMERIC_SCALE"]

    if data_type.endswith("char") or data_type == "text" or data_type == "ntext" or data_type == "uniqueidentifier":
        hive_type = "string"
    elif data_type == "money" or data_type == "decimal" or data_type == "numeric":
        hive_type = "decimal(%s,%s)" % (precision, scale)
    elif data_type == "datetime" or data_type == "smalldatetime":
        hive_type = "timestamp"
    elif data_type == "timestamp" or data_type == "varbinary" or data_type == "image":
        hive_type = "binary"
    elif data_type == "bit":
        hive_type = "boolean"
    elif data_type == "xml":
        hive_type = "string"
    else:
        hive_type = data_type

    logger.debug("Sql type: %s to Hive type: %s" % (data_type, hive_type))
    return hive_type


def create_tables(import_definition, target_db):
    logger.info("Create tables")
    logger.debug("Import definition: %s, target db: %s" %
                 (import_definition, target_db))
    table_definitions = import_definition.get_db_definition()

    for table_name, table_to_import in table_definitions.items():  # type: ImportTableDef

        create_table_query = generate_create_table_query(table_to_import)

        table_to_import.table_name = table_to_import.table_name + "_staging"

        create_staging_table_query = generate_create_table_query(table_to_import)

        logger.debug("Create table query: %s" % create_table_query)
        logger.debug("Create Staging table query: %s" % create_staging_table_query)

        db_manager.execute_query_with_connection(target_db, create_table_query)
        db_manager.execute_query_with_connection(target_db, create_staging_table_query)


def main(db):
    logger.info("Executing set up Hive DB main")
    imp = {
        "shared": create_shared_db_tables,
        "customer": create_customer_db_tables,
        "salesforce": create_salesforce_db_tables,
        "etl": create_etl_db_tables
    }

    imp[db]()


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description="Setup HIVE Database")
    parser.add_argument("db", choices=["shared", "salesforce", "customer", "etl"], help="the database to be setup")
    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())
