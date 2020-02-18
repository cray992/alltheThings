#!/usr/bin/env python

import argparse
import os
from config import Config

config = Config()
logger = config.get_logger(__package__)


def main(etl_path):
    logger.info("ETL mapper main")
    etl_script_file = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), etl_path)
    file_name = os.path.split(etl_path)[1]

    with open(etl_script_file, 'r') as content_file:
        content = content_file.read()

        # replace new line with space
        script_content = ' '.join(content.splitlines())
        stream_output = "%s|%s" % (file_name, script_content)
        logger.debug("Command: %s" % stream_output)
        print stream_output


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description='Mapper for running an ETL')
    parser.add_argument('etl_path', help='ETL file to execute')
    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())
