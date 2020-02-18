import random
import unittest

from datetime import datetime
from mock import patch

from hadoopimport.customer_subscription import CustomerSubscription
from hadoopimport.database_type import DatabaseType
from hadoopimport.db_category_repository import DbCategory
from hadoopimport.db_ct_conf import DbCTConf
from hadoopimport.table_def import TableDef
from hadoopimport.ingestion_type import IngestionType
from hadoopimport.ingestion_job_type import IngestionJobType
from hadoopimport.ingestible_db_table_conf import IngestibleDbTableConf
from hadoopimport.ingestible_db_conf import IngestibleDbConf
from hadoopimport.ingestion_job_repository import IngestionJob
from hadoopimport.ingestion_job_status import IngestionJobStatus

class BaseTestCase(unittest.TestCase):

    def get_mock_class(self, class_path, autospec=True):
        """

        :type class_path: str
        :type autospec: bool
        :rtype:
        """
        patcher = patch(class_path, spec=autospec)
        mock_class = patcher.start()
        self.addCleanup(patcher.stop)
        return mock_class

    def get_mock(self, class_path, autospec=True):
        """

        :type class_path: str
        :type autospec: bool
        :rtype:
        """
        return self.get_mock_class(class_path, autospec).return_value

    def build_column_definitions(self, table_name, partition_fields, merge_match_buckets, column_list = None, data_types = None):
        """

        :type table_name: str
        :type partition_fields: list of str
        :type merge_match_buckets: list of str
        :rtype: list of dict
        """
        num_cols = random.randint(2, 10)
        if column_list == None:
            column_list = ["Column%s" % i for i in xrange(num_cols)]

        if data_types == None:
            data_types = ["string"] * num_cols

        return [{"TABLE_NAME": table_name,
                 "COLUMN_NAME": column,
                 "DATA_TYPE": data_type,
                 "isMergeMatch": 1 if column in merge_match_buckets else 0,
                 "isPartition": 1 if column in partition_fields else 0,
                 "NUMERIC_PRECISION": None,
                 "NUMERIC_SCALE": None
                 } for column, data_type in zip(column_list,data_types)]

    def build_ingestible_def(self, table_name="TableName", merge_match_buckets=["Column0"],
                             partition_fields=["partitioncustomerid"], num_buckets=random.randint(0, 50),
                             ingestion_type=IngestionType.INCREMENTAL):
        """

        :type table_name: str
        :type partition_fields: list of str
        :type merge_match_buckets: list of str
        :type num_buckets: int
        :type ingestion_type: int
        :rtype: TableDef
        """
        column_definitions = self.build_column_definitions(table_name, partition_fields, merge_match_buckets)
        return TableDef(column_definitions, table_name, merge_match_buckets, partition_fields, num_buckets,
                        ingestion_type)

    def build_ingestible_defs(self, table_name):
        """

        :rtype: dict of str:TableDef
        """
        return {table_name: self.mock_ingestible_def(table_name=table_name)}

    def build_ingestible_db_conf(self, db_name="DbName",
                                       db_server="DbServer",
                                       target_db_name="HiveDbName",
                                       db_type=DatabaseType.CUSTOMER,
                                       db_conf_id=random.randint(1, 10000),
                                       db_port=random.randint(8000, 10000),
                                       customer_id=random.randint(1, 10000)):
        """

        :rtype: IngestibleDbTableConf
        """
        return IngestibleDbConf(db_name,
                                     db_server,
                                     target_db_name,
                                     db_type,
                                     db_conf_id=db_conf_id,
                                     db_port=db_port,
                                     customer_id=customer_id)

    def build_ingestible_db_table_conf(self, db_name="DbName",
                                       table_name="TableName",
                                       db_server="DbServer",
                                       target_db_name="HiveDbName",
                                       db_type=DatabaseType.CUSTOMER,
                                       db_conf_id=random.randint(1, 10000),
                                       db_port=random.randint(8000, 10000),
                                       customer_id=random.randint(1, 10000)):
        """
        :rtype: IngestibleDbTableConf
        """
        return IngestibleDbTableConf(db_name,
                                     db_server,
                                     target_db_name,
                                     db_type,
                                     table_name=table_name,
                                     db_conf_id=db_conf_id,
                                     db_port=db_port,
                                     customer_id=customer_id)

    def build_ingestion_job(self, ingestion_job_id=random.randint(0, 10000),
                            customer_id=random.randint(0, 10000),
                            db_type=DatabaseType.CUSTOMER,
                            db_name="HiveDbName",
                            table_name="TableName",
                            ingestion_type=IngestionType.INCREMENTAL,
                            ingestion_job_type=IngestionJobType.FULL,
                            status=IngestionJobStatus.CREATED,
                            create_time=datetime.now(),
                            start_time=datetime.now(),
                            update_time=datetime.now(),
                            version=random.randint(0, 10000),
                            previous_version=random.randint(10000, 20000)):
        """
        :rtype: IngestionJob
        """
        return IngestionJob(ingestion_job_id, customer_id, db_type, db_name, table_name, ingestion_type,
                            ingestion_job_type, status, create_time, start_time,
                            update_time, version, previous_version=previous_version)

    def build_db_category(self, db_category_id=random.randint(1, 10),
                        db_category_name=None,
                        min_table_size_mb=random.randint(1, 1024),
                        max_table_size_mb=random.randint(1025, 2048),
                        num_workers=random.randint(1, 10),
                        num_executors=random.randint(1, 10),
                        executor_memory=1024*random.randint(1, 5),
                        executor_cores=random.randint(1, 5),
                        driver_memory=1024 * random.randint(1, 5),
                        driver_cores=random.randint(1, 5),
                        create_time=datetime.now(),
                        update_time=datetime.now()):
        if db_category_name is None:
            db_category_name = "Category%s" % db_category_id,
        return DbCategory(db_category_id,
                          db_category_name,
                          min_table_size_mb,
                          max_table_size_mb,
                          num_workers,
                          num_executors,
                          executor_memory,
                          executor_cores,
                          driver_memory,
                          driver_cores,
                          create_time,
                          update_time)

    def build_db_ct_conf(self, db_id=random.randint(1, 10),
                         db_name="DbName",
                         db_server="DbServer",
                         db_enabled=False,
                         create_time=datetime.now(),
                         modified_time=datetime.now()):
        """

        :type db_id: int
        :type db_name: str
        :type db_server: str
        :type db_enabled: bool
        :type create_time: datetime
        :type modified_time: datetime
        :return rtype: DbCTConf
        """
        return DbCTConf(db_id, db_server, db_name, db_enabled, create_time, modified_time)

    def build_customer_subscription(self, customer_id=random.randint(1, 10), db_server="DbServer", db_name="DbName"):
        """

        :type customer_id: int
        :type db_name: str
        :type db_server: str
        :rtype: CustomerSubscription
        """
        return CustomerSubscription(customer_id, db_server, db_name)