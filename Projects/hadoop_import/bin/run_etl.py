#!/usr/bin/env python

import argparse
import os
import sys
from string import Template

import hadoopimport.cli_utils as cli_utils
from bin.setup_hive_db import create_etl_db_tables

from hadoopimport.etl_helper import EtlHelper
from hadoopimport.db_manager import DbManager
from hadoopimport.config import Config

config = Config()
logger = config.get_logger('bin')


def launch_map_reduce_etl(etl_script, hdp_import_home, hdp_dir):
    logger.info("Launch map reduce")
    logger.debug("ETL script: %s, HDP import home: %s, HDP dir: %s" % (etl_script, hdp_import_home, hdp_dir))
    etl_helper = EtlHelper()
    script_name = get_etl_name(etl_script, include_extension=True)
    map_reduce_conf = etl_helper.get_map_reduce_conf(script_name)

    hadoop_streaming_command = Template("""
        hadoop jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar 
        -Dmapred.reduce.tasks=$reducers 
        -Dmapreduce.reduce.memory.mb=$memory 
        -Dmapreduce.task.timeout=0 
        -files $etl_script
        -archives $hdp_import_home/target/hadoopimport.zip#hadoopimport 
        -input $hdp_dir/input.txt 
        -output $hdp_dir/data-import-results 
        -mapper "hadoopimport/etl_mapper.py $script_name" 
        -reducer "hadoopimport/etl_reducer.py" """)

    prepared_command = hadoop_streaming_command.substitute(reducers=map_reduce_conf["reducers"],
                                                           memory=map_reduce_conf["memory"],
                                                           hdp_import_home=hdp_import_home, hdp_dir=hdp_dir,
                                                           etl_script=etl_script, script_name=script_name)

    prepared_command = prepared_command.replace("\n", " ")
    logger.info("Hadoop streaming command:\n %s" % prepared_command)

    exit_code = cli_utils.execute_shell_command(prepared_command)
    sys.exit(exit_code)


def launch_spark_etl(etl_script, hdp_import_home, hdp_dir):
    logger.info("Launch Spark ETL")
    logger.debug("ETL script: %s, HDP import home: %s, HDP dir: %s" % (etl_script, hdp_import_home, hdp_dir))
    etl_helper = EtlHelper()
    script_name = get_etl_name(etl_script, include_extension=True)
    spark_conf = etl_helper.get_spark_conf(script_name)

    spark_submit_command = Template("""
        spark-submit --master yarn 
            --files $hdp_import_home/hadoopimport/config.ini,$hdp_import_home/hadoopimport/logging.conf,$etl_script
            --driver-memory $driver_memory 
            --num-executors $executors
            --executor-memory $executor_memory 
            --deploy-mode cluster 
            --conf spark.driver.extraJavaOptions=-Dhdp.version=2.3.4.0-3485 
            --conf spark.yarn.am.extraJavaOptions=-Dhdp.version=2.3.4.0-3485            
            --py-files $hdp_import_home/target/hadoopimport.zip
            --driver-class-path $hdp_import_home/jars/jtds-1.3.1.jar
            --jars /usr/hdp/current/spark-client/lib/datanucleus-api-jdo-3.2.6.jar,/usr/hdp/current/spark-client/lib/datanucleus-rdbms-3.2.9.jar,/usr/hdp/current/spark-client/lib/datanucleus-core-3.2.10.jar   
            $hdp_import_home/hadoopimport/etl_spark_runner.py $script_name """)

    prepared_command = spark_submit_command.substitute(hdp_import_home=hdp_import_home, hdp_dir=hdp_dir,
                                                       etl_script=etl_script, script_name=script_name,
                                                       executors=spark_conf["executors"],
                                                       driver_memory=spark_conf["driver_memory"],
                                                       executor_memory=spark_conf["executor_memory"])

    prepared_command = prepared_command.replace("\n", " ")
    logger.info("Spark submit command:\n %s" % prepared_command)

    exit_code = cli_utils.execute_shell_command(prepared_command)
    sys.exit(exit_code)


# create the method launch_hive_etl since hive_db_manager has trouble executing the Add JAR command
def launch_hive_etl(etl_script, hdp_import_home, hdp_dir):
    logger.info("Launch Hive ETL")
    hive_submit_command = Template("""
        hive 
        -f $etl_script""")

    prepared_command = hive_submit_command.substitute(hdp_import_home=hdp_import_home, etl_script=etl_script,
                                                      hdp_dir=hdp_dir)

    prepared_command = prepared_command.replace("\n", " ")
    logger.debug("Hive submit command:\n %s" % prepared_command)

    exit_code = cli_utils.execute_shell_command(prepared_command)
    sys.exit(exit_code)


def launch_pig_etl(etl_script, hdp_import_home, hdp_dir):
    logger.info("Launch Pig ETL")
    pig_submit_command = Template("""
        pig
        -useHCatalog 
        -Dpig.additional.jars=$hdp_import_home/jars/hdp-data-import-1.0.0.1.jar 
        -f $etl_script""")

    prepared_command = pig_submit_command.substitute(hdp_import_home=hdp_import_home, etl_script=etl_script,
                                                     hdp_dir=hdp_dir)

    prepared_command = prepared_command.replace("\n", " ")
    logger.debug("Pig submit command:\n %s" % prepared_command)

    exit_code = cli_utils.execute_shell_command(prepared_command)
    sys.exit(exit_code)


def create_etl_database_tables(etl_database):
    logger.info("Create ETL database and tables: %s" % etl_database)
    db_manager = DbManager()
    db_manager.add_hive_db(etl_database)
    create_etl_db_tables(etl_database)
    logger.info("End of create ETL DB tables")


def prepare_etl_script(script, hdp_import_home, etl_suffix, staging_suffix, etl_database=None):
    logger.info("Prepare ETL script")
    logger.debug("Script: %s, HDP import home: %s" % (script, hdp_import_home))
    db_manager = DbManager()
    hive_global_conf = db_manager.get_db_conn_properties("hive_global")
    hive_etl_conf = db_manager.get_db_conn_properties("hive_etl")
    hive_shared_conf = db_manager.get_db_conn_properties("hive_shared")
    hive_etl_database = etl_database if etl_database else hive_etl_conf["db_name"]

    with open(script, "r") as script_file:
        script_content = Template(script_file.read())
        prepared_script = script_content.substitute(hive_global=hive_global_conf["db_name"],
                                                    hive_etl=hive_etl_database,
                                                    hive_shared=hive_shared_conf["db_name"],
                                                    etl_suffix=etl_suffix,
                                                    staging_suffix=staging_suffix,
                                                    hdp_import_home=hdp_import_home)

        target_folder = hdp_import_home + "/target"
        prepared_file_name = target_folder + "/" + get_etl_name(script, include_extension=True)

        logger.debug("ETL script file: %s" % prepared_file_name)
        logger.debug("Script:\n %s" % prepared_script)

        with open(prepared_file_name, "w") as prepared_file:
            prepared_file.write(prepared_script)
            return prepared_file.name


def get_etl_name(etl_file, include_extension=False):
    logger.info("Get ETL name")
    logger.debug("ETL file: %s, include extension: %s" % (etl_file, include_extension))
    file_path, file_name = os.path.split(etl_file)

    if include_extension:
        return file_name
    else:
        return file_name.split(".")[0]


def main(engine, etl_file, etl_database):
    logger.info("Executing Run ETL main")
    logger.debug("Engine: %s, ETL file: %s" % (engine, etl_file))
    logger.debug("etl_database: %s" % etl_database)

    etl_name = get_etl_name(etl_file)
    etl_suffix = '_all'
    staging_suffix = '_staging'

    cli_utils.build_hadoopimport()

    hdp_etl_dir = cli_utils.create_hdp_unique_job_folder(etl_name)
    hdp_import_home = cli_utils.get_hadoopimport_home()
    if etl_database:
        create_etl_database_tables(etl_database)
    prepared_script = prepare_etl_script(etl_file, hdp_import_home, etl_suffix, staging_suffix, etl_database)
    logger.debug(
        "HDP ETL dir: %s, HDP import home: %s\nPrepared script: %s" % (hdp_etl_dir, hdp_import_home, prepared_script))

    launch = {
        "hive": launch_hive_etl,
        "mapreduce": launch_map_reduce_etl,
        "spark": launch_spark_etl,
        "pig": launch_pig_etl
    }

    launch[engine](prepared_script, hdp_import_home, hdp_etl_dir)


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description="Runs an ETL script")
    parser.add_argument("engine", choices=["hive", "mapreduce", "spark", "pig"],
                        help="The engine that will be used to run this file")
    parser.add_argument("etl_file", help="The file containing the ETL to run")
    parser.add_argument("-d", "--etl_database", required=False, default="",
                        help="The database ETL name")

    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())
