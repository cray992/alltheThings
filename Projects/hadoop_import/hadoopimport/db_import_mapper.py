#!/usr/bin/env python

import argparse
import re

from config import Config
from customer_generator import KareoAnalyticsCustomerListGenerator
from customer_generator import KmbCustomerListGenerator
from db_manager import DbManager

config = Config()
logger = config.get_logger(__package__)

CUSTOMER_DATABASE = re.compile("[a-zA-Z]+_(\d+)_[a-zA-Z]+")

db_manager = DbManager()


def import_kareo_analytics_customer_dbs():
    logger.info("Import Kareo analytics customer DBs")
    customers = KareoAnalyticsCustomerListGenerator().get_flat_customer_list()
    hive_global = db_manager.get_db_conn_properties("hive_global")
    import_customer_databases(customers, hive_global["db_name"])
    logger.info("End of importing Kareo analytics customer DBs")


def import_kmb_customer_dbs():
    logger.info("Import KMB customer DBs")
    customers = KmbCustomerListGenerator().get_flat_customer_list()
    hive_global = db_manager.get_db_conn_properties("hive_global")
    import_customer_databases(customers, hive_global["db_name"])
    logger.info("End of importing KMB customer DBs")


def import_shared_db():
    logger.info("Import Shared DB")
    shared_db_conf = db_manager.get_db_conn_properties("shared")
    hive_shared = db_manager.get_db_conn_properties("hive_shared")
    import_database(shared_db_conf, hive_shared["db_name"])
    logger.info("End of importing Shared DB")


def import_salesforce_db():
    logger.info("Import SalesForce DB")
    salesforce_db_conf = db_manager.get_db_conn_properties("salesforce")
    hive_salesforce = db_manager.get_db_conn_properties("hive_salesforce")
    import_database(salesforce_db_conf, hive_salesforce["db_name"])
    logger.info("End of importing SalesForce DB")


def import_database(src_db, target_db):
    logger.info("Import database, source %s, target %s" % (src_db, target_db))
    import_customer_databases([src_db], target_db)
    logger.info("End of importing database")


def import_customer_databases(src_dbs, target_db):
    logger.info("Import customer databases")
    logger.debug("Src Dbs: %s, target DB: %s" % (src_dbs, target_db))

    i = 1
    for db_conf in src_dbs:
        db_port = db_conf['db_port']
        db_server = db_conf['db_server']
        db_name = db_conf['db_name']

        logger.debug("Import db: %s" % db_name)

        if CUSTOMER_DATABASE.match(db_name):
            customer_id = int(db_conf['db_name'].split('_')[1])
        else:
            customer_id = -1

        output_stream = "%d\t%s:%s|%s|%s|%s" % (i, db_server, db_port, db_name, customer_id, target_db)
        logger.debug(output_stream)
        print(output_stream)
        i += 1


def main(db):
    logger.info("DB import manager main")
    logger.debug("DB: %s" % db)

    imp = {
        "shared": import_shared_db,
        "salesforce": import_salesforce_db,
        "kareo_analytics": import_kareo_analytics_customer_dbs,
        "kmb": import_kmb_customer_dbs
    }

    imp[db]()


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description="Gets the list of databases to import for a given DB group")
    parser.add_argument("db", choices=["shared", "salesforce", "kareo_analytics", "kmb"],
                        help="The database(s) to be imported")
    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())
