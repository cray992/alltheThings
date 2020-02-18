#!/usr/bin/env python

"""
Script launches Pyspark code via spark-submit
Data is received via stdin from mappers (when launched with Hadoop streaming)
This is a workaround to pass data to spark-submit via temp file since spark-submit does not read from stdin
"""

import argparse
import sys

from string import Template
from tempfile import NamedTemporaryFile
from subprocess import Popen, PIPE
from config import Config

config = Config()
logger = config.get_logger(__package__)


def mb_to_gb(mb):
    g = mb / 1000
    if g == 0:
        g = 1
    return g


def write_stdin_to_file():
    ntf = NamedTemporaryFile()
    ntf.write(sys.stdin.read())
    ntf.flush()

    return ntf


def launch_spark_db_import(dbs_to_import, import_group, memory):
    logger.info("Launch Spark DB Import")
    logger.debug("DBs to import %s, import group %s, memory %s" % (dbs_to_import, import_group, memory))

    spark_command = Template("""
                        SPARK_MAJOR_VERSION=1 spark-submit                         
                        --driver-memory ${memory}g 
                        --driver-class-path jtds-1.3.1.jar 
                        hadoopimport/spark_db_importer.py $import_group 
                        $dbs_to_import""")

    prepared_spark_command = spark_command.substitute(memory=mb_to_gb(memory), dbs_to_import=dbs_to_import.name,
                                                      import_group=import_group)
    prepared_spark_command = prepared_spark_command.replace("\n", " ")
    prepared_spark_command = prepared_spark_command.strip()
    logger.debug("Prepared Spark command: %s" % prepared_spark_command)

    p = Popen(prepared_spark_command, shell=True, stdout=PIPE, stderr=PIPE)
    stdout, stderr = p.communicate()
    logger.debug(stdout)
    logger.debug(stderr)

    if p.poll() != 0:
        sys.exit(p.poll())


def main(import_group, memory):
    logger.info("DB import reducer main")
    logger.debug("Import group %s, memory %s" % (import_group, memory))

    dbs_to_import = write_stdin_to_file()
    launch_spark_db_import(dbs_to_import, import_group, memory)

    dbs_to_import.close()


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description="Reducer to import a group of database")
    parser.add_argument("import_group", choices=["shared", "salesforce", "kareo_analytics", "kmb"],
                        help="The database(s) to be imported")
    parser.add_argument("-r", "--memory", type=int, default=1024,
                        nargs="?", help="Memory for this reducer in mb")
    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())
