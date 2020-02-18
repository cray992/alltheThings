from mssql_db_manager import MsSqlDbManager, MsSqlDbName
from ingestion_job_type import IngestionJobType
from config import Config
import itertools
from datetime import datetime
from ingestion_job_status import IngestionJobStatus

DEFAULT_VERSION = 0


class IngestionJob:
    def __init__(self, ingestion_job_id, customer_id, db_type, db_name, table_name, ingestion_type, ingestion_job_type,
                 status, create_time, start_time, update_time, version, previous_version=None):
        """
        :type ingestion_job_id: int
        :type customer_id: int
        :type db_type: str
        :type db_name: str
        :type table_name: str
        :type ingestion_type: int
        :type ingestion_job_type: int
        :type status: int
        :type start_time: datetime
        :type update_time: datetime
        :type version: int
        :type previous_version: int
        """
        self.ingestion_job_id = ingestion_job_id
        self.customer_id = customer_id
        self.db_type = db_type
        self.db_name = db_name
        self.table_name = table_name
        self.ingestion_type = ingestion_type
        self.ingestion_job_type = ingestion_job_type
        self.status = status
        self.start_time = start_time
        self.create_time = create_time
        self.update_time = update_time
        self.version = version
        self.previous_version = previous_version

    def __str__(self):
        return "%s(%s)" % (type(self).__name__, ", ".join("%s=%s" % item for item in vars(self).items()))
        cls.__str__ = __str__
        return cls

    def __repr__(self):
        return self.__str__()

    def __hash__(self):
        return hash(str(self.__dict__))

    def __eq__(self, other):
        return self.__dict__ == other.__dict__

    def __ne__(self, other):
        return not self.__eq__(other)


class IngestionJobRepository:
    def __init__(self):
        self.mssql_db_mgr = MsSqlDbManager(db_name=MsSqlDbName.APPLICATION_METADATA)
        self.config = Config()
        self.logger = self.config.get_logger(__package__)
        self.CREATE_JOB_INSERT = """
        INSERT INTO HDP_IngestionJob 
            (CustomerId, 
            DbTypeId, 
            DbName, 
            TableName, 
            IngestionType,
            IngestionJobType, 
            Status, 
            Version, 
            PreviousVersion) 
        VALUES ({0}, {1}, '{2}', '{3}', {4}, {5}, {6}, {7}, {8})
        """

        self.GET_LAST_JOB_BY_DB_TABLE_QUERY = """
                    SELECT 
                        TOP 1 IngestionJobID, 
                        CustomerId, 
                        DbTypeId, 
                        DbName, 
                        TableName, 
                        IngestionType,
                        IngestionJobType, 
                        Status, 
                        CreateTime, 
                        StartTime, 
                        UpdateTime, 
                        Version, 
                        PreviousVersion 
                    FROM HDP_IngestionJob 
                    WHERE DbName = '{0}' AND TableName='{1}'
                    ORDER BY UpdateTime DESC
                """

        self.GET_LAST_JOB_BY_DB_NAME_AND_STATUS_QUERY = """
            SELECT 
                TOP 1 IngestionJobID, 
                CustomerId, 
                DbTypeId, 
                DbName, 
                TableName,
                IngestionType,
                IngestionJobType, 
                Status, 
                CreateTime,
                StartTime, 
                UpdateTime, 
                Version, 
                PreviousVersion 
            FROM HDP_IngestionJob WITH (NOLOCK)
            WHERE DbName = '{0}' AND TableName='{1}' AND Status={2}
            ORDER BY UpdateTime DESC
        """

        self.GET_JOB_BY_JOB_ID_QUERY = """
            SELECT 
                IngestionJobID, 
                CustomerId, 
                DbTypeId,
                DbName, 
                TableName, 
                IngestionType,
                IngestionJobType, 
                Status, 
                CreateTime, 
                StartTime, 
                UpdateTime, 
                Version, 
                PreviousVersion 
            FROM HDP_IngestionJob WITH (NOLOCK)
            WHERE IngestionJobID in ({0})
        """

        self.GET_LAST_JOB_FOR_ALL_DB = """
           SELECT 
                IngestionJobID, 
                CustomerId, 
                DbTypeId, 
                h2.DbName, 
                h2.TableName, 
                IngestionType,
                IngestionJobType, 
                Status, 
                CreateTime, 
                StartTime, 
                UpdateTime,
                Version, 
                PreviousVersion 
            FROM HDP_IngestionJob h1 WITH (NOLOCK)
            INNER JOIN (SELECT DbName, TableName, Max(UpdateTime) AS MaxDateTime 
            FROM HDP_IngestionJob GROUP BY DbName, TableName) h2 
            ON h1.DbName = h2.DbName 
            AND h1.TableName = h2.TableName
            AND h1.UpdateTime = h2.MaxDateTime
        """

        self.GET_LAST_JOB_FOR_CUSTOMER_DB = """
            SELECT 
                IngestionJobID, 
                CustomerId, 
                DbTypeId,
                h2.DbName, 
                h2.TableName, 
                IngestionType,
                IngestionJobType, 
                Status, 
                CreateTime, 
                StartTime, 
                UpdateTime,
                Version, 
                PreviousVersion 
            FROM HDP_IngestionJob h1 WITH (NOLOCK)
            INNER JOIN (SELECT DbName, TableName, Max(UpdateTime) AS MaxDateTime  
            FROM HDP_IngestionJob GROUP BY DbName, TableName) h2 
            ON h1.DbName = h2.DbName 
            AND h1.TableName = h2.TableName 
            AND h1.UpdateTime = h2.MaxDateTime 
            WHERE h1.DbTypeId = 1
        """

        self.INSERT_CLEANUP_JOBS_BY_CUSTOMERS = """
            INSERT INTO HDP_IngestionJob
            (CustomerId, 
            DbTypeId, 
            DbName, 
            TableName, 
            IngestionType, 
            IngestionJobType, 
            StartTime,
            Status, 
            Version, 
            PreviousVersion) 
            SELECT 
                CustomerId, 
                DbTypeId,
                h2.DbName, 
                h2.TableName, 
                h1.IngestionType,
                4,
                GETDATE(),
                {1}, 
                Version, 
                PreviousVersion 
            FROM HDP_IngestionJob h1 
            INNER JOIN (SELECT DbName, TableName, Max(UpdateTime) AS MaxDateTime  
            FROM HDP_IngestionJob GROUP BY DbName, TableName) h2 
            ON h1.DbName = h2.DbName 
            AND h1.TableName = h2.TableName 
            AND h1.UpdateTime = h2.MaxDateTime 
            WHERE h1.DbTypeId = 1 AND h1.CustomerId IN ({0})
        """

        self.LAST_JOBS_BY_STATUS_QUERY = """ 
                 SELECT DISTINCT                 	  
                      HIJ.DbName,
                      HIJ.TableName, 
                      HIJ.IngestionJobType,
                      HIJ.status,
                      HIJ.Version
                    FROM                                                                                      
                      dbo.HDP_IngestionJob HIJ WITH (NOLOCK)
                    JOIN 
                      (SELECT DbName, TableName, MAX(CreateTime) as CreateTime
                       FROM dbo.HDP_IngestionJob
                       GROUP BY DbName, TableName) AS LIJ
                    ON HIJ.CreateTime = LIJ.CreateTime AND HIJ.DbName = LIJ.DbName AND HIJ.TableName = LIJ.TableName                                                                                 
                    WHERE HIJ.Status = {0}
                    ORDER BY HIJ.DbName                                                              
        """

        # Status,

        self.UPDATE_STATUS_QUERY = """UPDATE HDP_IngestionJob 
                                      SET Status = {0}, UpdateTime = getdate() 
                                      WHERE IngestionJobID in ({1})"""

        self.UPDATE_STARTED_QUERY = """UPDATE HDP_IngestionJob 
                                              SET Status = {0}, UpdateTime = getdate(), StartTime = getdate() 
                                              WHERE IngestionJobID in ({1})"""

    def parse_job_record(self, job_record):
        """
        :type job_record: list
        :rtype: IngestionJob
        """
        # self.logger.debug("Parsing Ingestion Job Record For Table %s" % job_record.get("TableName"))

        return IngestionJob(ingestion_job_id=job_record.get("IngestionJobID"),
                            customer_id=job_record.get("CustomerId"),
                            db_type=job_record.get("DbTypeId"),
                            db_name=job_record.get("DbName"),
                            table_name=job_record.get("TableName"),
                            ingestion_type=job_record.get("IngestionType"),
                            ingestion_job_type=job_record.get("IngestionJobType"),
                            status=job_record.get("Status"),
                            create_time=job_record.get("CreateTime"),
                            start_time=job_record.get("StartTime"),
                            update_time=job_record.get("UpdateTime"),
                            version=job_record.get("Version"),
                            previous_version=job_record.get("PreviousVersion"))

    def create_job(self, customer_id, db_type, db_name, table_name, ingestion_type, ingestion_job_type, version=DEFAULT_VERSION,
                   previous_version=DEFAULT_VERSION):
        """

        :type customer_id: int
        :type db_type: int
        :type db_name: str
        :type table_name: str
        :type ingestion_type: int
        :type ingestion_job_type: int
        :type version: int
        :type previous_version: int
        :rtype: IngestionJob
        """

        if customer_id in [None, ""]:
            customer_id = "NULL"

        self.logger.debug("Creating Job For: " + db_name + table_name)
        create_job_insert = self.CREATE_JOB_INSERT.format(customer_id,
                                                          db_type,
                                                          db_name,
                                                          table_name,
                                                          ingestion_type,
                                                          ingestion_job_type,
                                                          IngestionJobStatus.CREATED,
                                                          version,
                                                          previous_version).replace("None", "NULL")
        returned_id = self.mssql_db_mgr.execute_query(create_job_insert)
        ingestion_job = self.get_ingestion_job_by_id(returned_id)
        return ingestion_job

    def create_customer_cleanup_jobs(self, customer_ids, failed_customer_ids=set()):
        """

        :type customer_ids: set
        :type failed_customer_ids: set
        :rtype: int
        """

        self.logger.debug("Create cleanup jobs for the customer: " + ', '.join(map(str, customer_ids)))
        success_customer_ids = customer_ids - failed_customer_ids

        if len(success_customer_ids) > 0:
            success_placeholders = ', '.join(map(str, success_customer_ids))
            create_success_cleanup_job_insert = \
                self.INSERT_CLEANUP_JOBS_BY_CUSTOMERS.format(success_placeholders, str(IngestionJobStatus.SUCCESS))
            self.mssql_db_mgr.execute_query(create_success_cleanup_job_insert)

        if len(failed_customer_ids) > 0:
            fail_placeholders = ', '.join(map(str, failed_customer_ids))
            create_fail_cleanup_job_insert = \
                self.INSERT_CLEANUP_JOBS_BY_CUSTOMERS.format(fail_placeholders, str(IngestionJobStatus.FAIL))
            self.mssql_db_mgr.execute_query(create_fail_cleanup_job_insert)

    def get_last_job(self, db_name, table_name):
        """
        :type db_name: str
        :type table_name: str
        :rtype: IngestionJob
        """
        self.logger.debug("Getting last job of: " + db_name + "." + table_name)
        get_last_job = self.GET_LAST_JOB_BY_DB_TABLE_QUERY.format(db_name, table_name)
        results = self.mssql_db_mgr.execute_query(get_last_job)
        if len(results) > 0:
            job_record = results[0]
            ingestion_job = self.parse_job_record(job_record)
            return ingestion_job
        else:
            return None

    def get_last_successful_job(self, db_name, table_name):
        """
        :type db_name: str
        :type table_name: str
        :rtype: IngestionJob
        """
        self.logger.debug("Getting last job of: " + db_name + "." + table_name)
        get_last_success = self.GET_LAST_JOB_BY_DB_NAME_AND_STATUS_QUERY.format(db_name, table_name,
                                                                                IngestionJobStatus.SUCCESS)
        results = self.mssql_db_mgr.execute_query(get_last_success)
        if len(results) > 0:
            job_record = results[0]
            ingestion_job = self.parse_job_record(job_record)
            return ingestion_job
        else:
            return None

    def get_ingestion_job_by_id(self, job_id):
        """
        Gets ingestion job by id
        :type job_id: int
        :rtype: IngestionJob
        :raises Exception: If no record or multiple records were found for the job id
        """

        self.logger.debug("Getting Ingestion Job: " + str(job_id))
        get_ingestion_job = self.GET_JOB_BY_JOB_ID_QUERY.format(job_id)
        result = self.mssql_db_mgr.execute_query(get_ingestion_job)
        if len(result) == 1:
            job_record = result[0]
            ingestion_job = self.parse_job_record(job_record)
            return ingestion_job
        elif len(result) == 0:
            raise Exception("Expected only one record with ID: %s but found %s" % (job_id, len(result)))

    def update_status(self, ingestion_job_status, ingestion_job_id):
        """
        Updates job with the given status
        :type ingestion_job_status: IngestionJobStatus
        :type ingestion_job_id: str
        :return: Number of updated rows
        :rtype: int
        """

        self.logger.debug("Updating Job Status For Job: " + str(ingestion_job_id))
        job_update_query = self.UPDATE_STATUS_QUERY.format(ingestion_job_status, ingestion_job_id)
        return self.mssql_db_mgr.execute_query(job_update_query)

    def update_multiple_status(self, ingestion_job_status, ingestion_job_ids):
        """
        Updates multiple job records with the given status

        :type ingestion_job_status: IngestionJobStatus
        :type ingestion_job_ids: list of str
        :return: Number of updated rows
        :rtype: int
        """
        job_ids_str = ", ".join(map(lambda job_id: str(job_id), ingestion_job_ids))
        self.logger.debug("Updating Job Status for Multiple Jobs: %s" % job_ids_str)
        job_update_query = self.UPDATE_STATUS_QUERY.format(ingestion_job_status, job_ids_str)
        return self.mssql_db_mgr.execute_query(job_update_query)

    def update_started(self, ingestion_job_id):
        """
        Updates a job with status STARTED and start time to DB current time

        :type ingestion_job_id: str
        :return: Number of updated rows
        :rtype: int
        """

        self.logger.debug("Updating Job Status For Job: " + str(ingestion_job_id))
        job_update_query = self.UPDATE_STARTED_QUERY.format(IngestionJobStatus.STARTED, ingestion_job_id)
        return self.mssql_db_mgr.execute_query(job_update_query)

    def update_multiple_started(self, ingestion_job_ids):
        """
        Updates multiple job records with status STARTED and start time to DB current time

        :type ingestion_job_ids: list of str
        :return: Number of updated rows
        :rtype: int
        """
        job_ids_str = ", ".join(map(lambda job_id: str(job_id), ingestion_job_ids))
        self.logger.debug("Updating Started Time and Status STARTED for Multiple Jobs: %s" % job_ids_str)
        job_update_query = self.UPDATE_STARTED_QUERY.format(IngestionJobStatus.STARTED, job_ids_str)
        return self.mssql_db_mgr.execute_query(job_update_query)

    def get_last_job_all_db_tables(self):
        """
        Returns a dictionary of all ingestion jobs
        :rtype: dict of list
        """

        self.logger.debug("Getting All Latest Jobs.")
        last_jobs = {}
        job_record = self.mssql_db_mgr.execute_query(self.GET_LAST_JOB_FOR_ALL_DB)
        for db_table_name, jobs in itertools.groupby(job_record,
                                                     lambda returned_column: "{0}.{1}".format(returned_column["DbName"],
                                                                                              returned_column[
                                                                                                  "TableName"])):
            last_jobs[db_table_name] = self.parse_job_record(list(jobs)[0])

        return last_jobs

    def get_last_non_cleanup_job_customers(self):
        """
        Returns a set of the customer ids of all non-cleanup ingestion jobs
        :rtype: set of int
        """

        self.logger.debug("Getting The CustomerIds of All Latest Non-Cleanup Jobs.")
        get_last_job_query = self.GET_LAST_JOB_FOR_CUSTOMER_DB
        non_cleanup_customers = set()
        job_records = self.mssql_db_mgr.execute_query(get_last_job_query)

        for job_record in job_records:
            job = self.parse_job_record(job_record)
            if job.ingestion_job_type != IngestionJobType.CLEANUP or job.status != IngestionJobStatus.SUCCESS:
                non_cleanup_customers.add(job.customer_id)

        return non_cleanup_customers

    def get_last_ingestion_jobs_by_status(self, status):
        """
        Returns a list of a dictionary maps of ingestion job status

        :param status: ingestion job status
        :type status: IngestionJobStatus
        :return: A list of a dictionary maps of ingestion job status
        :rtype: list of dict
        """
        results = self.mssql_db_mgr.execute_query(self.LAST_JOBS_BY_STATUS_QUERY.format(status))
        return results

