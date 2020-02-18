#!/usr/bin/env python
import argparse

from hadoopimport.config import Config
from hadoopimport.ingestion_failure_reporter import IngestionFailureReporter
from hadoopimport.ingestion_group import IngestionGroup

config = Config()
logger = config.get_logger('bin')


def main(ingestion_group):
    try:
        ingestion_group_type = IngestionGroup.get_ingestion_group(ingestion_group)
        fir = IngestionFailureReporter()
        fir.send_failure_job_summary(ingestion_group_type)

    except Exception as ex:
        logger.error('Failed to execute Failure Ingestion Reporter')
        logger.exception(ex)


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description="Runs a Failure Ingestion Reporter")
    parser.add_argument("ingestion_group",
                        choices=["kareo_analytics", "kmb"],
                        help="The ingested data group to be repored")
    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())