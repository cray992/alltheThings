#!/usr/bin/env python

import argparse
import sys
from string import Template

import hadoopimport.cli_utils as cli_utils

from hadoopimport.db_import_helper import DbImportHelper
from hadoopimport.config import Config

config = Config()
logger = config.get_logger('bin')

SINGLE_DB_HDP_MEMORY = 12288
SINGLE_DB_HDP_REDUCERS = 1


def get_hdp_db_import_conf(import_group):
    logger.info("Get HDP DB import conf")
    logger.debug("Import group: %s" % import_group)
    # These are individual databases so there' no need to store the
    # configuration in the database (for now).
    if import_group == "shared" or import_group == "salesforce":
        return {"memory": SINGLE_DB_HDP_MEMORY, "reducers": SINGLE_DB_HDP_REDUCERS}
    else:
        helper = DbImportHelper()
        return helper.get_import_group_conf(import_group)


def launch_map_reduce_db_import(import_group, memory, reducers, hdp_ingestion_dir, hdp_import_home):
    logger.info("Launch map reduce DB import")
    logger.debug("Import group: %s, memory: %s, reducers: %s, hdp ingestion dir: %s, hdp import home: %s" %
        (import_group, memory, reducers, hdp_ingestion_dir, hdp_import_home))
    hadoop_streaming_command = Template("""
            hadoop jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar
            -files $hadoop_import_home/jars/jtds-1.3.1.jar
            -archives $hadoop_import_home/target/hadoopimport.zip#hadoopimport
            -Dmapred.reduce.tasks=$reducers
            -Dmapreduce.reduce.memory.mb=$memory
            -Dmapreduce.task.timeout=0
            -Dmapreduce.map.maxattempts=1
            -Dmapreduce.reduce.maxattempts=1
            -input $hadoop_ingestion_dir/input.txt
            -output $hadoop_ingestion_dir/data-import-results                         
            -mapper "hadoopimport/db_import_mapper.py $import_group"
            -reducer "hadoopimport/db_import_reducer.py $import_group -r $memory" """)

    prepared_command = hadoop_streaming_command.substitute(reducers=reducers, memory=memory,
                                                           import_group=import_group,
                                                           hadoop_ingestion_dir=hdp_ingestion_dir,
                                                           hadoop_import_home=hdp_import_home)

    prepared_command = prepared_command.replace("\n", " ")
    logger.debug("Hadoop streaming command:\n %s" % prepared_command)

    exit_code = cli_utils.execute_shell_command(prepared_command)
    sys.exit(exit_code)

def main(import_group):
    logger.info("Executing Import DB main")
    logger.debug("Import group: %s" % import_group)

    hdp_ingestion_dir = cli_utils.create_hdp_unique_job_folder("ingestion")
    hdp_import_home = cli_utils.get_hadoopimport_home()
    import_group_hadoop_conf = get_hdp_db_import_conf(import_group)

    cli_utils.build_hadoopimport()

    launch_map_reduce_db_import(import_group,
                                import_group_hadoop_conf["memory"], import_group_hadoop_conf["reducers"],
                                hdp_ingestion_dir, hdp_import_home)


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description="Imports all the databases required for a given import group")
    parser.add_argument("import_group",
                        choices=["shared", "salesforce", "kareo_analytics", "kmb"],
                        help="The data group to be imported")
    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())
