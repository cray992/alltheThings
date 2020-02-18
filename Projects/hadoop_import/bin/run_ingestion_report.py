#!/usr/bin/env python
# TODO: incremental ingestion cleanup
import argparse

from hadoopimport.config import Config
from hadoopimport.ingestion_reporter import IngestionReporter

config = Config()
logger = config.get_logger('bin')


def main():
    try:
        ir = IngestionReporter()
        ir.execute()
    except Exception as ex:
        logger.error('Failed to execute Ingestion Reporter')
        logger.exception(ex)
def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description="Runs the Data Ingestion Reporter")
    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())
