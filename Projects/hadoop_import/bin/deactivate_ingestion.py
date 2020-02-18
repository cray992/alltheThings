#!/usr/bin/env python

import argparse
import sys

from hadoopimport.config import Config
from hadoopimport.customer_subscription_repository import CustomerSubscriptionRepository
from hadoopimport.hive_customer_repository import HiveCustomerRepository
from hadoopimport.ingestion_group import IngestionGroup
from hadoopimport.ingestion_job_repository import IngestionJobRepository

config = Config()
logger = config.get_logger('bin')


def main(ingestion_group_name):
    logger.info("Deactivate Ingestion")
    logger.debug("Ingestion group: %s" % ingestion_group_name)
    try:
        ingestion_group = IngestionGroup.get_ingestion_group(ingestion_group_name)

        # get active customers
        customer_repo = CustomerSubscriptionRepository(ingestion_group)
        subscriptions = customer_repo.get_customer_subscriptions()
        active_customer_ids = [subscription.customer_id for subscription in subscriptions]

        # get the customer ids of last non-cleanup ingestion job
        ingestion_job_repo =IngestionJobRepository()
        ingestion_customer_ids = ingestion_job_repo.get_last_non_cleanup_job_customers()

        diff_customer_ids = ingestion_customer_ids - active_customer_ids

        # remove global hive customer partitions
        hive_customer_repo =HiveCustomerRepository(ingestion_group)
        failed_customer_ids = hive_customer_repo.remove_deactivated_customer_data(diff_customer_ids)

        # insert cleanup job entries
        ingestion_job_repo.create_customer_cleanup_jobs(diff_customer_ids, failed_customer_ids)

        if len(failed_customer_ids) > 0:
            raise Exception("Failed to remove customer ingestion data for the customer %s" % failed_customer_ids)

    except Exception as ex:
        logger.error('Failed to execute Deactivate Ingestion')
        logger.exception(ex)
        sys.exit(1)

    logger.debug("Finished Deactivate Ingestion!")


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description="Run an Ingestion Deactivation Script")
    parser.add_argument("ingestion_group_name",
                        choices=["kareo_analytics", "kmb"],
                        help="The data group to be imported")
    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())
