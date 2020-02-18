#!/usr/bin/env python

import argparse
from multiprocessing import Pool

from hadoopimport.config import Config, ConfigNamespace
from hadoopimport.db_table_persister import PersistableTableConf, DbTablePersister, PersistConfigProperty
from hadoopimport.ingestion_job_repository import IngestionJobRepository, IngestionJob
from hadoopimport.ingestible_db_repository import IngestibleDbConfRepository
from hadoopimport.ingestion_group import IngestionGroup
from hadoopimport.ingestion_job_type import IngestionJobType
from hadoopimport.ingestion_job_status import IngestionJobStatus
from hadoopimport.db_definition_repository import DbDefinitionRepository

######################## Initialization Block Begin #########################
from hadoopimport.ingestion_type import IngestionType

config = Config()
logger = config.get_logger(__package__)
ingestion_job_repo =IngestionJobRepository()
NUM_WORKERS = int(config.get(ConfigNamespace.INGESTION, PersistConfigProperty.NUM_WORKERS))
BATCH_SIZE = int(config.get(ConfigNamespace.INGESTION, PersistConfigProperty.BATCH_SIZE))


######################### Initialization Block End ##########################


def batch(persistable_tables, batch_size):
    """Yield successive n-sized chunks from l."""
    return [persistable_tables[i:i + batch_size] for i in range(0, len(persistable_tables), batch_size)]


def _create_persist_job(ingestion_job):
    """
    :type ingestion_job: IngestionJob
    :rtype: IngestionJob
    """

    persist_job = ingestion_job_repo.create_job(customer_id=ingestion_job.customer_id,
                                                    db_type=ingestion_job.db_type,
                                                    db_name=ingestion_job.db_name,
                                                    table_name=ingestion_job.table_name,
                                                    ingestion_type=ingestion_job.ingestion_type,
                                                    ingestion_job_type=IngestionJobType.PERSIST,
                                                    version=ingestion_job.version,
                                                    previous_version=ingestion_job.previous_version)
    return persist_job.ingestion_job_id


def _fail_persist_job(ingestion_job_ids):
    """
    :type ingestion_job_ids: list of int
    """
    for ingestion_job_id in ingestion_job_ids:
        ingestion_job_repo.update_status(ingestion_job_id=ingestion_job_id,
                                           ingestion_job_status=IngestionJobStatus.FAIL)


def _is_eligible_for_persist(job, all_db_definitions):
    """

    :type job:
    :rtype: boolean
    """
    ingestion_type = all_db_definitions[job.db_type][job.table_name].ingestion_type
    if ingestion_type == IngestionType.FULL and job.ingestion_job_type == IngestionJobType.INCREMENTAL and \
            job.status == IngestionJobStatus.SUCCESS:
        return True
    elif job.ingestion_job_type == IngestionJobType.FULL and job.status == IngestionJobStatus.SUCCESS:
        return True
    # It should retry in next run, in case it did not succeed.
    elif job.ingestion_job_type == IngestionJobType.PERSIST and job.status != IngestionJobStatus.SUCCESS:
        return True
    else:
        return False

def _group_jobs_by_db_type_and_table_name(jobs):
    """
    Groups the jobs in a 2 level hierarchy by db type and then by table name


    :type jobs: list of IngestionJob
    :return: dict of dict:list of IngestionJob
    """
    jobs_by_db_type = {}
    for job in jobs:
        if job.db_type in jobs_by_db_type:
            jobs_by_table_name = jobs_by_db_type[job.db_type]
        else:
            jobs_by_table_name = {}
            jobs_by_db_type[job.db_type] = jobs_by_table_name

        if job.table_name in jobs_by_table_name:
            jobs_by_table_name[job.table_name].append(job)
        else:
            jobs_by_table_name[job.table_name] = [job]

    return jobs_by_db_type

def generate_persistable_tables(ingestion_group):
    """
    :type ingestion_group: int
    """


    db_definition_repo = DbDefinitionRepository()
    ingestible_db_conf_repo = IngestibleDbConfRepository(ingestion_group)

    all_db_definitions = dict(map(lambda db_type: (db_type, db_definition_repo.get_db_definition(db_type)),
                                  ingestible_db_conf_repo.get_ingestible_db_types()))

    all_ingestion_jobs = ingestion_job_repo.get_last_job_all_db_tables().values()

    successful_jobs = filter(lambda job: job.table_name in all_db_definitions[job.db_type] and \
                                         _is_eligible_for_persist(job, all_db_definitions), all_ingestion_jobs)

    jobs_by_db_type = _group_jobs_by_db_type_and_table_name(successful_jobs)

    target_db_names = ingestible_db_conf_repo.get_target_db_names()

    persistable_table_confs = []
    for db_type, jobs_by_table_name in jobs_by_db_type.items():

        for table_name, jobs_for_table in jobs_by_table_name.items():

            job_ids = map(lambda job: _create_persist_job(job), jobs_for_table)

            # Generate Table Definitions
            table_definitions = all_db_definitions[db_type]  # type: ImportTableDef

            if table_name not in table_definitions:
                logger.error("Missing Table From Definitions! For Table: " + table_name)
                _fail_persist_job(job_ids)
                continue

            table_definition = table_definitions[table_name]

            # Extract Partion Field and Value
            column_names = [column["COLUMN_NAME"] for column in table_definition.column_definitions]

            if len(table_definition.partition_fields) > 0:
                partition_by_field = table_definition.partition_fields[0]
                partition_values = map(lambda job: job.customer_id, jobs_for_table)
            else:
                partition_by_field = None
                partition_values = None

            # Create Persistable Conf
            persistable_conf = PersistableTableConf(
                target_db_name=target_db_names[db_type],
                table_name=table_name,
                partition_by_field=partition_by_field,
                partition_values=partition_values,
                column_names=column_names,
                job_ids=job_ids,
                merge_match_fields=table_definition.merge_match_buckets)

            persistable_table_confs.append(persistable_conf)

    return persistable_table_confs


def persist_table(table_conf_batch):
    """
    :type table_conf_batch: list of PersistableTableConf
    :rtype:
    """

    db_table_persister = DbTablePersister()
    db_table_persister.persist_batch(table_conf_batch)


def map_tables_to_workers(batched_table_confs):
    '''
    :type categorized_dbs: dict
    :return:
    '''

    logger.info("Starting threadpool for persiting!")

    worker_pool = Pool(NUM_WORKERS)
    worker_pool.map(persist_table, batched_table_confs)


def launch_asynch_persist(ingestion_group):
    '''
    :type job_batch: list of IngestionJob
    :rtype: boolean
    '''
    logger.info("Launching Asynch Persist!")

    persistable_table_confs = generate_persistable_tables(ingestion_group)
    logger.info("Number of tables to persist: %s" % len(persistable_table_confs))
    if len(persistable_table_confs) == 0:
        return
    batched_table_confs = batch(persistable_table_confs, BATCH_SIZE)
    map_tables_to_workers(batched_table_confs)


def main(import_group):
    import_group = IngestionGroup.get_ingestion_group(import_group)
    launch_asynch_persist(import_group)

    logger.info("Finished Persist!")


def parse_command_line_arguments():
    parser = argparse.ArgumentParser(description="Runs an Spark Reporting Script")
    parser.add_argument("import_group",
                        choices=["kareo_analytics", "kmb"],
                        help="The data group to be imported")
    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())