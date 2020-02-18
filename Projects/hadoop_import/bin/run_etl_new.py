#!/usr/bin/env python

import argparse
import os
import sys
from string import Template

import hadoopimport.cli_utils as cli_utils

from hadoopimport.etl_helper import EtlHelper
from hadoopimport.database_type import DatabaseType
from hadoopimport.config import Config
from hadoopimport.hive_db_manager import HiveDbManager, HiveDbName
from hadoopimport.ingestible_db_repository import IngestibleDbConfRepository
from hadoopimport.ingestion_group import IngestionGroup

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
        -reducer "hadoopimport/etl_reducer_new.py" """)

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
    deploy_mode = config.get("SPARK", "deploy_mode")
    spark_version = config.get("SPARK", "spark_major_version")

    spark_submit_command = Template("""
        SPARK_MAJOR_VERSION=${spark_version} spark-submit --master yarn 
            --files $hdp_import_home/hadoopimport/config.ini,$hdp_import_home/hadoopimport/logging.conf,$etl_script
            --driver-memory $driver_memory 
            --num-executors $executors
            --executor-memory $executor_memory 
            --deploy-mode ${deploy_mode}
            --conf spark.driver.extraJavaOptions=-Dhdp.version=2.3.4.0-3485 
            --conf spark.yarn.am.extraJavaOptions=-Dhdp.version=2.3.4.0-3485            
            --py-files $hdp_import_home/target/hadoopimport.zip
            --driver-class-path $hdp_import_home/jars/jtds-1.3.1.jar
            --jars /usr/hdp/current/spark-client/lib/datanucleus-api-jdo-3.2.6.jar,/usr/hdp/current/spark-client/lib/datanucleus-rdbms-3.2.9.jar,/usr/hdp/current/spark-client/lib/datanucleus-core-3.2.10.jar   
            $hdp_import_home/hadoopimport/etl_spark_runner_new.py $script_name """)

    prepared_command = spark_submit_command.substitute(spark_version=spark_version,
                                                       hdp_import_home=hdp_import_home,
                                                       hdp_dir=hdp_dir,
                                                       etl_script=etl_script,
                                                       script_name=script_name,
                                                       executors=spark_conf["executors"],
                                                       driver_memory=spark_conf["driver_memory"],
                                                       executor_memory=spark_conf["executor_memory"],
                                                       deploy_mode=deploy_mode)

    prepared_command = prepared_command.replace("\n", " ")
    logger.info("Spark submit command:\n %s" % prepared_command)

    exit_code = cli_utils.execute_shell_command(prepared_command)
    sys.exit(exit_code)


def launch_tez_etl(etl_script_file, hdp_import_home, hdp_etl_dir):
    logger.info("Launch Tez ETL")
    with open(etl_script_file, "r") as script_file:
        hive_db_mgr = HiveDbManager()
        hive_db_mgr.execute_script(script_file.read())


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


def create_etl_database_tables(engine, ingestion_group, etl_database, hdp_import_home, etl_suffix, launch):
    logger.info("Create user defined ETL database and tables: %s" % etl_database)
    hive_db_mgr = HiveDbManager()
    hive_etl = "%s_%s" % (etl_database, ingestion_group)
    create_etl_database_script = "CREATE DATABASE IF NOT EXISTS %s" % hive_etl
    hive_db_mgr.execute_script(create_etl_database_script)

    # create etl tables
    etl_file = "etl/hive/create_tables_etl.hive"
    etl_name = get_etl_name(etl_file)
    hdp_etl_dir = cli_utils.create_hdp_unique_job_folder(etl_name)
    prepared_script = prepare_etl_script(etl_file, hdp_import_home, ingestion_group, etl_suffix, etl_database)
    logger.debug(
        "HDP ETL dir: %s, HDP import home: %s\nPrepared script: %s" % (hdp_etl_dir, hdp_import_home, prepared_script))

    launch[engine](prepared_script, hdp_import_home, hdp_etl_dir)

    logger.info("End of create user defined ETL DB tables")


def prepare_etl_script(script, hdp_import_home, ingestion_group, etl_suffix='', etl_database=None):
    logger.info("Prepare ETL script")
    logger.debug("Script: %s, HDP import home: %s, Ingestion Group %s" % (script, hdp_import_home, ingestion_group))
    ingestion_group_id = IngestionGroup.get_ingestion_group(ingestion_group)

    ingestible_db_conf_repo = IngestibleDbConfRepository(ingestion_group_id)
    target_db_names = ingestible_db_conf_repo.get_target_db_names()

    hive_db_mgr = HiveDbManager()
    etl_db_name = etl_database if etl_database else HiveDbName.ETL
    etl_db_conn_conf = hive_db_mgr.get_db_conn_conf_for_conn_name(etl_db_name)

    with open(script, "r") as script_file:
        script_content = Template(script_file.read())
        hive_global = target_db_names[DatabaseType.CUSTOMER]
        hive_etl = "%s_%s" % (etl_db_conn_conf.db_name, ingestion_group)
        hive_shared = target_db_names[DatabaseType.SHARED]

        prepared_script = script_content.substitute(hive_global=hive_global,
                                                    hive_etl=hive_etl,
                                                    hive_shared=hive_shared,
                                                    etl_suffix=etl_suffix,
                                                    staging_suffix='',
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


def main(engine, etl_file, ingestion_group, etl_database):
    logger.info("Executing Run ETL main")
    logger.debug("Engine: %s, ETL file: %s" % (engine, etl_file))
    logger.debug("etl_database: %s" % etl_database)

    etl_name = get_etl_name(etl_file)
    # for now we still keep etl suffix and will remove it later
    etl_suffix = '_all'

    cli_utils.build_hadoopimport()

    hdp_etl_dir = cli_utils.create_hdp_unique_job_folder(etl_name)
    hdp_import_home = cli_utils.get_hadoopimport_home()
    launch = {
        "mapreduce": launch_map_reduce_etl,
        "spark": launch_spark_etl,
        "pig": launch_pig_etl,
        "hive": launch_hive_etl,
        "tez": launch_tez_etl
    }

    if etl_database:
        create_etl_database_tables(engine, ingestion_group, etl_database, hdp_import_home, etl_suffix, launch)
    prepared_script = prepare_etl_script(etl_file, hdp_import_home, ingestion_group, etl_suffix, etl_database)
    logger.debug(
        "HDP ETL dir: %s, HDP import home: %s\nPrepared script: %s" % (hdp_etl_dir, hdp_import_home, prepared_script))

    launch[engine](prepared_script, hdp_import_home, hdp_etl_dir)


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description="Runs an ETL script")
    parser.add_argument("engine", choices=["mapreduce", "spark", "pig", "hive", "tez"],
                        help="The engine that will be used to run this file")
    parser.add_argument("etl_file", help="The file containing the ETL to run")
    parser.add_argument("ingestion_group",
                        choices=["kareo_analytics", "kmb"],
                        help="The data group to be imported")
    parser.add_argument("-d", "--etl_database", required=False, default="",
                        help="The ETL database name")

    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())
