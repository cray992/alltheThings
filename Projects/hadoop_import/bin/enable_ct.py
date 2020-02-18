#!/usr/bin/env python
import argparse

from hadoopimport.config import Config
from hadoopimport.ct_enabler import CTEnabler
from hadoopimport.ingestion_group import IngestionGroup

config = Config()
logger = config.get_logger('bin')


def main(ingestion_group):
    try:
        ce = CTEnabler()
        ingestion_group_id = IngestionGroup.get_ingestion_group(ingestion_group)
        ce.enable_ct_for_all_dbs(ingestion_group_id)
    except Exception as ex:
        logger.error('Failed to execute CT Enabler')
        logger.exception(ex)

def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description="Enbles Change Tracking for all ingestible DBs")
    parser.add_argument("ingestion_group",
                        choices=["kareo_analytics", "kmb"],
                        help="The data group to be enabled Change Tracking")
    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())
