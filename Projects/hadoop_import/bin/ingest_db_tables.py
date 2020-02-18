#!/usr/bin/env python

import argparse
import math
import os
import re
from string import Template
from subprocess import PIPE, Popen

import hadoopimport.cli_utils as cli_utils

from hadoopimport.config import Config
from hadoopimport.db_categorizer import DbCategorizer
from hadoopimport.db_category_repository import DbCategoryRepository, DbCategory
from hadoopimport.hive_consistency_fixer import HiveConsistencyFixer
from hadoopimport.ingestible_db_table_conf import IngestibleDbTableConf
from hadoopimport.ingestible_db_table_list_generator import IngestibleDbTableListGenerator
from hadoopimport.ingestible_db_repository import IngestibleDbConfRepository
from hadoopimport.ingestion_group import IngestionGroup
from hadoopimport.ingestion_job_repository import IngestionJobRepository
from hadoopimport.ingestion_job_type import IngestionJobType
from hadoopimport.table_def import TableDef
from hadoopimport.ingestion_job_repository import IngestionJob
from hadoopimport.ingestion_job_status import IngestionJobStatus

config = Config()
logger = config.get_logger(__package__)


def mb_to_gb(mb):
    g = mb / 1000
    if g == 0:
        g = 1
    return g


def chunk_configs(ingestible_db_confs, num_chunks):
    """
    :type ingestible_db_confs: list of IngestibleDbTableConf
    :type num_chunks: int
    :rtype: list of list
    """
    num_chunks = max(1, num_chunks)
    chunk_size = float(len(ingestible_db_confs)) / num_chunks
    chunk_size = int(math.ceil(chunk_size))

    return list(ingestible_db_confs[i:i + chunk_size] for i in xrange(0, len(ingestible_db_confs), chunk_size))


def normalize_cli_command_str(prepared_command):
    prepared_command = prepared_command.replace("\n", " ")
    return re.sub(' +', ' ', prepared_command)


def run_asynch_command(prepared_command):
    try:
        p = Popen(prepared_command, shell=True, stdout=PIPE, stderr=PIPE)
        return p
    except Exception as ex:
        logger.error("Ingestion Failed! " + ex)


def write_ingestible_batch_to_hdfs(ingestible_db_batch_jobs):
    '''
    :type ingestible_db_batch_jobs: list of IngestibleDbTableConf
    :rtype: boolean
    '''

    serialized_db_configs = [ingestion_job_db.serialize() for ingestion_job_db in ingestible_db_batch_jobs]

    file = cli_utils.create_temp_file(prefix="db_batch_", lines=serialized_db_configs)
    file_path = file.name
    file_name = os.path.basename(file.name)

    db_batch_hdfs_dir = cli_utils.create_hdp_unique_job_folder("ingestible_batch")

    cli_utils.copy_file_to_hdfs(file_path=file_path, hdfs_path=db_batch_hdfs_dir)

    db_batch_hdfs_file_path = db_batch_hdfs_dir + "/" + file_name

    file.close()

    logger.debug("HDFS FILE CREATED: " + db_batch_hdfs_file_path)

    return db_batch_hdfs_file_path


def map_dbs_to_workers(categorized_dbs, ingestion_group, ingestion_job_type):
    """
    :type categorized_dbs: dict
    :type ingestion_group: int
    :type ingestion_job_type: int
    :rtype: None
    """
    logger.info("##### MAPPING DBS TO WORKERS #####")
    db_category_repo =DbCategoryRepository()
    processes = []
    categories = db_category_repo.get_all_db_categories()  # type: dict

    for category, ingestible_db_table_confs in categorized_dbs.iteritems():
        spark_config = categories.get(category)  # type: DbCategory

        if (spark_config == None):
            raise Exception("Invalid Category!")

        num_workers = min(spark_config.num_workers, len(ingestible_db_table_confs))

        # Split into evenly split chunk_configs for import
        ingestible_db_table_batchs = chunk_configs(ingestible_db_table_confs, num_workers)

        # Ingest data
        logger.info("##### LAUNCHING SPARK JOBS #####")
        for ingestible_db_table_batch in ingestible_db_table_batchs:
            executed_spark_command, p = launch_spark_ingestion(ingestible_db_table_batch, spark_config, ingestion_group,
                                                               ingestion_job_type)
            processes.append(p)
            logger.info("Launched Process ID %s, Spark Job command: %s" % (p.pid, executed_spark_command,))

    logger.info("##### WAITING FOR SPARK JOBS #####")
    for p in processes:
        p.communicate()
        logger.info("Process ID %s, Spark Job Finished!" % p.pid)


def launch_spark_ingestion(ingestible_db_table_batch, spark_config, ingestion_group, ingestion_job_type):
    """
    :type ingestible_db_table_batch: list of IngestibleDbTableConf
    :type spark_config: DbCategory
    :type ingestion_group: int
    :type ingestion_job_type: str
    :rtype: boolean
    """
    db_batch_hdfs_path = write_ingestible_batch_to_hdfs(ingestible_db_table_batch)
    hdp_import_home = cli_utils.get_hadoopimport_home()
    ingestion_job_type = IngestionJobType.get_ingestion_job_type_name(ingestion_job_type)
    ingestion_group_name = IngestionGroup.get_ingestion_group_name(ingestion_group)
    deploy_mode = config.get("SPARK", "deploy_mode")
    spark_version = config.get("SPARK", "spark_major_version")

    spark_submit_command = Template("""
                        SPARK_MAJOR_VERSION=${spark_version} spark-submit --master yarn 
                            --files $hdp_import_home/hadoopimport/config.ini,$hdp_import_home/hadoopimport/logging.conf
                            --driver-memory ${driver_memory}g
                            --driver-cores ${driver_cores}
                            --num-executors ${num_executors}
                            --executor-memory ${executor_memory}g
                            --executor-cores ${executor_cores}
                            --deploy-mode ${deploy_mode}
                            --conf spark.driver.extraJavaOptions=-Dhdp.version=2.3.4.0-3485 
                            --conf spark.yarn.am.extraJavaOptions=-Dhdp.version=2.3.4.0-3485            
                            --py-files $hdp_import_home/target/hadoopimport.zip
                            --driver-class-path $hdp_import_home/jars/jtds-1.3.1.jar
                            --conf spark.executor.extraClassPath=jtds-1.3.1.jar
                            --jars $hdp_import_home/jars/jtds-1.3.1.jar,/usr/hdp/current/spark-client/lib/datanucleus-api-jdo-3.2.6.jar,/usr/hdp/current/spark-client/lib/datanucleus-rdbms-3.2.9.jar,/usr/hdp/current/spark-client/lib/datanucleus-core-3.2.10.jar   
                            $hdp_import_home/hadoopimport/spark_db_table_ingester.py $ingestion_group $ingestion_job_type $db_batch_hdfs_path""")

    prepared_command = spark_submit_command.substitute(spark_version=spark_version,
                                                       hdp_import_home=hdp_import_home,
                                                       db_batch_hdfs_path=db_batch_hdfs_path,
                                                       driver_memory=mb_to_gb(spark_config.driver_memory),
                                                       driver_cores=spark_config.driver_cores,
                                                       num_executors=spark_config.num_executors,
                                                       executor_memory=mb_to_gb(spark_config.executor_memory),
                                                       executor_cores=spark_config.executor_cores,
                                                       deploy_mode=deploy_mode,
                                                       ingestion_group=ingestion_group_name,
                                                       ingestion_job_type=ingestion_job_type)

    prepared_command = normalize_cli_command_str(prepared_command)
    logger.debug("Launching Spark Job Command: %s" % prepared_command)
    p = run_asynch_command(prepared_command)
    return prepared_command, p


def fix_inconsistent_tables(ingestion_group):
    """
    :type ingestion_group: int
    :rtype dict
    """
    logger.info("##### Fixing Inconsistent Tables #####")

    ingestion_job_repo = IngestionJobRepository()

    fixed_tables = HiveConsistencyFixer(ingestion_group).fix_all()
    if len(fixed_tables) == 0:
        return

    ingestible_db_conf_repo = IngestibleDbConfRepository(ingestion_group)
    database_types = ingestible_db_conf_repo.get_ingestible_db_types()
    all_db_table_jobs = ingestion_job_repo.get_last_job_all_db_tables().values()

    # Get Flat List of inconsistent tables
    modified_tables = []  # type: TableDef
    jobs_to_update = []
    for database_type in database_types:
        if database_type in fixed_tables:
            modified_tables_for_db = fixed_tables[database_type]

            modified_table_names = [table.lower() for table in modified_tables_for_db]
            all_jobs_for_db = filter(lambda job: job.db_type == database_type, all_db_table_jobs)
            existing_table_jobs = filter(lambda job: job.table_name.lower() in modified_table_names, all_jobs_for_db)
            jobs_to_update.extend(existing_table_jobs)

    for job in jobs_to_update:  # type: IngestionJob
        ingestion_job_repo.update_status(ingestion_job_status=IngestionJobStatus.STALE,
                                               ingestion_job_id=job.ingestion_job_id)


def full_ingestion(ingestion_group):
    """
    :type ingestion_group: int
    """
    logger.info("##### STARTING FULL INGESTION #####")

    # fix inconsistent tables
    fix_inconsistent_tables(ingestion_group=ingestion_group)

    # get imortable_dbs
    ingestible_db_table_list_generator = IngestibleDbTableListGenerator(ingestion_group, IngestionJobType.FULL)
    ingestible_db_tables = ingestible_db_table_list_generator.get_ingestible_db_tables()

    # categorize dbs
    categorizer = DbCategorizer(ingestion_group=ingestion_group)
    categorized_db_tables = categorizer.categorize_dbs(ingestible_db_tables)

    # do_imports
    map_dbs_to_workers(categorized_db_tables, ingestion_group, IngestionJobType.FULL)

    logger.debug("Finished %s Ingestion!" % IngestionJobType.get_ingestion_job_type_name(IngestionJobType.FULL))


def incremental_ingestion(ingestion_group):
    """
    :type ingestion_group: int
    """
    logger.info("##### STARTING INCREMENTAL INGESTION #####")

    # get imortable_dbs
    ingestible_db_table_list_generator = IngestibleDbTableListGenerator(ingestion_group, IngestionJobType.INCREMENTAL)
    ingestible_db_tables = ingestible_db_table_list_generator.get_ingestible_db_tables()

    if len(ingestible_db_tables) > 0:
        # categorize dbs
        categorized_db_tables = {IngestionJobType.INCREMENTAL: ingestible_db_tables}

        # do_imports
        map_dbs_to_workers(categorized_db_tables, ingestion_group, IngestionJobType.INCREMENTAL)

    logger.debug("Finished %s Ingestion!" % IngestionJobType.get_ingestion_job_type_name(IngestionJobType.INCREMENTAL))


def main(ingestion_group, ingestion_job_type):
    logger.info("##### STARTING INGESTION #####")
    cli_utils.build_hadoopimport()

    ingestion_group = IngestionGroup.get_ingestion_group(ingestion_group)
    ingestion_job_type = IngestionJobType.get_ingestion_job_type(ingestion_job_type)
    if ingestion_job_type == IngestionJobType.FULL:
        full_ingestion(ingestion_group)
    elif ingestion_job_type == IngestionJobType.INCREMENTAL:
        incremental_ingestion(ingestion_group)
    else:
        raise Exception("Unrecognized Ingestion Job Type! : " + str(ingestion_job_type))


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description="Runs an Spark Reporting Script")
    parser.add_argument("ingestion_group",
                        choices=["kareo_analytics", "kmb"],
                        help="The data group to be imported")
    parser.add_argument("ingestion_job_type",
                        choices=["full", "incremental"],
                        help="The data group to be imported")
    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())
