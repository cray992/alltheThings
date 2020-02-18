from unittest import skip

from mock import patch

from hadoopimport.ingestible_db_conf import IngestibleDbConf
from hadoopimport.ingestible_db_table_conf import IngestibleDbTableConf
from hadoopimport.ingestible_db_table_list_generator import IngestibleDbTableListGenerator
from hadoopimport.ingestion_job_repository import IngestionJob
from hadoopimport.ingestion_type import IngestionType
from hadoopimport.ingestion_job_type import IngestionJobType
from hadoopimport.database_type import DatabaseType
from hadoopimport.ingestion_job_status import IngestionJobStatus


# Given
from hadoopimport.tests.base_test_case import BaseTestCase

get_customer_dbs_result_1 = IngestibleDbConf(db_name="db_ka_1", db_server='customer_db_host:4400',
                                             db_port=4400,
                                             target_db_name="customer", customer_id=11111,
                                             db_type=DatabaseType.CUSTOMER)
get_customer_dbs_result_2 = IngestibleDbConf(db_name="db_ka_2", db_server='customer_db_host:4400',
                                             db_port=4400,
                                             target_db_name="customer", customer_id=22222,
                                             db_type=DatabaseType.CUSTOMER)
get_customer_dbs_result_3 = IngestibleDbConf(db_name="child_db_1", db_server='customer_db_host:4400',
                                             db_port=4400,
                                             target_db_name="customer", customer_id=33333,
                                             db_type=DatabaseType.CUSTOMER)
get_customer_dbs_result_4 = IngestibleDbConf(db_name="child_db_2", db_server='customer_db_host:4400',
                                             db_port=4400,
                                             target_db_name="customer", customer_id=44444,
                                             db_type=DatabaseType.CUSTOMER)
test_result_5_shared = IngestibleDbConf(db_name="db_shared", db_server='shared_db_host:1100',
                                        db_conf_id=1, db_port=1100, target_db_name="shared",
                                        db_type=DatabaseType.SHARED)
test_result_6_salesforce = IngestibleDbTableConf(db_name="db_salesforce", db_server='shared_db_host:1100',
                                                 db_conf_id=2, db_port=1100, target_db_name="salesforce",
                                                 db_type=DatabaseType.SALESFORCE, table_name="Table_6")
test_result_7 = IngestibleDbTableConf(db_name="db_kmb_1", db_server='shared_db_host:4400', db_port=4400,
                                      db_conf_id=1, target_db_name="customer", customer_id=33333,
                                      db_type=DatabaseType.CUSTOMER, table_name="Table_7")
test_result_8 = IngestibleDbTableConf(db_name="db_kmb_2", db_server='shared_db_host:4400', db_port=4400,
                                      db_conf_id=1, target_db_name="customer", customer_id=44444,
                                      db_type=DatabaseType.CUSTOMER, table_name="Table_8")
test_result_9 = IngestibleDbTableConf(db_name="db_kmb3", db_server='customer_db_host:4400', db_port=4400,
                                      db_conf_id=1, target_db_name="customer", customer_id=12345,
                                      db_type=DatabaseType.CUSTOMER, table_name="Table_9")

# Given Test Tables
table_result_ka_1_1 = IngestibleDbTableConf(db_name="db_ka_1", db_server='customer_db_host:4400', db_port=4400,
                                            target_db_name="customer", customer_id=11111,
                                            db_type=DatabaseType.CUSTOMER, table_name="customer_table_1")
table_result_ka_1_2 = IngestibleDbTableConf(db_name="db_ka_1", db_server='customer_db_host:4400', db_port=4400,
                                            target_db_name="customer", customer_id=11111,
                                            db_type=DatabaseType.CUSTOMER, table_name="customer_table_2")

table_result_ka_2_1 = IngestibleDbTableConf(db_name="db_ka_2", db_server='customer_db_host:4400', db_port=4400,
                                            target_db_name="customer", customer_id=22222,
                                            db_type=DatabaseType.CUSTOMER, table_name="customer_table_1")
table_result_ka_2_2 = IngestibleDbTableConf(db_name="db_ka_2", db_server='customer_db_host:4400', db_port=4400,
                                            target_db_name="customer", customer_id=22222,
                                            db_type=DatabaseType.CUSTOMER, table_name="customer_table_2")

table_result_kmb_1_1 = IngestibleDbTableConf(db_name="db_kmb_1", db_server='customer_db_host:4400', db_port=4400,
                                             target_db_name="customer", customer_id=33333,
                                             db_type=DatabaseType.CUSTOMER, table_name="customer_table_1")
table_result_kmb_1_2 = IngestibleDbTableConf(db_name="db_kmb_1", db_server='customer_db_host:4400', db_port=4400,
                                             target_db_name="customer", customer_id=33333,
                                             db_type=DatabaseType.CUSTOMER, table_name="customer_table_2")
table_result_kmb_2_1 = IngestibleDbTableConf(db_name="db_kmb_2", db_server='customer_db_host:4400', db_port=4400,
                                             target_db_name="customer", customer_id=44444,
                                             db_type=DatabaseType.CUSTOMER, table_name="customer_table_1")
table_result_kmb_2_2 = IngestibleDbTableConf(db_name="db_kmb_2", db_server='customer_db_host:4400', db_port=4400,
                                             target_db_name="customer", customer_id=44444,
                                             db_type=DatabaseType.CUSTOMER, table_name="customer_table_2")
table_result_shared_1 = IngestibleDbTableConf(db_name="db_shared", db_server='shared_db_host:1100',
                                              db_conf_id=1, db_port=1100, target_db_name="shared",
                                              db_type=DatabaseType.SHARED, table_name="shared_table_1")
table_result_shared_2 = IngestibleDbTableConf(db_name="db_shared", db_server='shared_db_host:1100',
                                              db_conf_id=1, db_port=1100, target_db_name="shared",
                                              db_type=DatabaseType.SHARED, table_name="shared_table_2")
table_result_salesforce_1 = IngestibleDbTableConf(db_name="db_salesforce", db_server='shared_db_host:1100',
                                                  db_conf_id=2, db_port=1100, target_db_name="salesforce",
                                                  db_type=DatabaseType.SALESFORCE, table_name="sales_force_table_1")
table_result_salesforce_2 = IngestibleDbTableConf(db_name="db_salesforce", db_server='shared_db_host:1100',
                                                  db_conf_id=2, db_port=1100, target_db_name="salesforce",
                                                  db_type=DatabaseType.SALESFORCE, table_name="sales_force_table_2")

db_ka_1customer_table_1_job = IngestionJob(ingestion_job_id=1, customer_id=33333, db_type=DatabaseType.CUSTOMER,
                                           db_name="db_ka_1", table_name="customer_table_1",
                                           ingestion_type=IngestionType.INCREMENTAL,
                                           ingestion_job_type=IngestionJobType.FULL,
                                           status=IngestionJobStatus.SUCCESS, create_time=None, start_time=None,
                                           update_time=None, version=1)
db_ka_1customer_table_2_job = IngestionJob(ingestion_job_id=2, customer_id=44444, db_type=DatabaseType.CUSTOMER,
                                           db_name="db_ka_1", table_name="customer_table_2",
                                           ingestion_type=IngestionType.INCREMENTAL,
                                           ingestion_job_type=IngestionJobType.INCREMENTAL,
                                           status=IngestionJobStatus.SUCCESS,
                                           create_time=None,
                                           start_time=None,
                                           update_time=None, version=1)
db_ka_2customer_table_1_job = IngestionJob(ingestion_job_id=3, customer_id=11111, db_type=DatabaseType.CUSTOMER,
                                           db_name="db_ka_2", table_name="customer_table_1",
                                           ingestion_type=IngestionType.INCREMENTAL,
                                           ingestion_job_type=IngestionJobType.FULL,
                                           status=IngestionJobStatus.FAIL, create_time=None, start_time=None,
                                           update_time=None, version=1)
db_ka_2customer_table_2_job = IngestionJob(ingestion_job_id=4, customer_id=22222, db_type=DatabaseType.CUSTOMER,
                                           db_name="db_ka_2", table_name="customer_table_2",
                                           ingestion_type=IngestionType.INCREMENTAL,
                                           ingestion_job_type=IngestionJobType.CLEANUP,
                                           status=IngestionJobStatus.CREATED,
                                           create_time=None,
                                           start_time=None,
                                           update_time=None, version=1)
db_kmb_1customer_table_1_job = IngestionJob(ingestion_job_id=5, customer_id=77777, db_type=DatabaseType.CUSTOMER,
                                            db_name="db_kmb_1", table_name="customer_table_1",
                                            ingestion_type=IngestionType.INCREMENTAL,
                                            ingestion_job_type=IngestionJobType.INCREMENTAL,
                                            status=IngestionJobStatus.FAIL,
                                            create_time=None,
                                            start_time=None,
                                            update_time=None, version=1)
db_kmb_1customer_table_2_job = IngestionJob(ingestion_job_id=6, customer_id=88888, db_type=DatabaseType.CUSTOMER,
                                            db_name="db_kmb_1", table_name="customer_table_2",
                                            ingestion_type=IngestionType.INCREMENTAL,
                                            ingestion_job_type=IngestionJobType.FULL,
                                            status=IngestionJobStatus.FAIL, create_time=None, start_time=None,
                                            update_time=None, version=1)

ka_customer_response = [get_customer_dbs_result_1, get_customer_dbs_result_2]

generate_customer_databases_result = [get_customer_dbs_result_1, get_customer_dbs_result_2, get_customer_dbs_result_3]

get_last_job_all_db_tables_response = {"db_ka_1.customer_table_1": db_ka_1customer_table_1_job,
                                       "db_ka_1.customer_table_2": db_ka_1customer_table_2_job,
                                       "db_ka_2.customer_table_1": db_ka_2customer_table_1_job,
                                       "db_ka_2.customer_table_2": db_ka_2customer_table_2_job,
                                       "db_kmb_1.customer_table_1": db_kmb_1customer_table_1_job,
                                       "db_kmb_1.customer_table_2": db_kmb_1customer_table_2_job}


@skip
class IngestibleDbTableListGeneratorTest(BaseTestCase):
    def setUp(self):
        # Classes / attributes to mock
        self.mock_config = self.get_mock("hadoopimport.ingestible_db_table_list_generator.Config")
        self.mock_customer_subscription_repo = self.get_mock(
            "hadoopimport.ingestible_db_table_list_generator.CustomerSubscriptionRepository")
        self.mock_ingestion_job_repo = self.get_mock(
            "hadoopimport.ingestible_db_table_list_generator.IngestionJobRepository")
        self.mock_ingestible_db_conf_repo = self.get_mock(
            "hadoopimport.ingestible_db_table_list_generator.IngestibleDbConfRepository")
        self.mock_db_import_repo = self.get_mock(
            "hadoopimport.ingestible_db_table_list_generator.DbDefinitionRepository")
        self.mock_mssql_db_mgr = self.get_mock(
            "hadoopimport.ingestible_db_table_list_generator.MsSqlDbManager")


    # Given
    salesforce_tables = ['sales_force_table_1', 'sales_force_table_2']
    shared_tables = ['shared_table_1', 'shared_table_2']
    customer_tables = ['customer_table_1', 'customer_table_2']
    db_import_defs = {DatabaseType.CUSTOMER: customer_tables, DatabaseType.SHARED: shared_tables,
                      DatabaseType.SALESFORCE: salesforce_tables}

    def side_effect_db_definitions(self, db_type):
        return dict(map(lambda table: (table, self.build_ingestible_def(table_name=table)), self.db_import_defs[db_type]))

    def side_effect_extract_full_db_tables(param):

        set_1 = set(param)

        set_2 = set(
            [table_result_ka_1_1, table_result_ka_1_2, table_result_ka_2_1, table_result_ka_2_2, table_result_shared_1,
             table_result_shared_2])  # , table_result_ka_2_1, table_result_ka_2_2, table_result_shared_1, table_result_shared_2])

        matches = set_1.intersection(set_2)

        if len(matches) == 6 and len(set_2) == 6:
            return [table_result_ka_1_1, table_result_ka_2_2]
        else:
            raise Exception("Wrong Import!")

    def side_effect_extract_incr_db_tables(param):

        set_1 = set(param)

        set_2 = set(
            [table_result_ka_1_1, table_result_ka_1_2, table_result_ka_2_1, table_result_ka_2_2, table_result_shared_1,
             table_result_shared_2])  # , table_result_ka_2_1, table_result_ka_2_2, table_result_shared_1, table_result_shared_2])

        matches = set_1.intersection(set_2)

        if len(matches) == 6 and len(set_2) == 6:
            return [table_result_ka_1_2, table_result_ka_2_1]
        else:
            raise Exception("Wrong Import!")

    @patch('hadoopimport.ingestible_db_table_list_generator.IngestibleDbTableListGenerator.generate_customer_databases',
           return_value=ka_customer_response)
    @patch('hadoopimport.ingestible_db_table_list_generator.IngestibleDbTableListGenerator.get_ingestible_dbs',
           return_value=[test_result_5_shared])
    @patch('hadoopimport.ingestible_db_table_list_generator.IngestibleDbTableListGenerator._extract_full_db_tables',
           side_effect=side_effect_extract_full_db_tables)
    @patch('hadoopimport.ingestible_db_table_list_generator.IngestibleDbTableListGenerator._extract_incr_db_tables',
           side_effect=side_effect_extract_incr_db_tables)
    @patch('hadoopimport.ingestible_db_repository.IngestibleDbConfRepository.get_ingestible_db_types',
           side_effect=[[1, 2], [1, 2, 3]])
    def test_get_importable_tables_ka(self, mock_get_customer_dbs, mock_get_ingestible_dbs,
                                      side_effect_full_db_extract,
                                      side_effect_incr_db_extract, side_effect_db_types_by_ingestion_group):

        self.mock_ingestion_job_repo.get_last_job_all_db_tables.return_value = get_last_job_all_db_tables_response
        self.mock_ingestible_db_conf_repo.get_ingestible_db_types.return_value = [DatabaseType.CUSTOMER, DatabaseType.SHARED]
        self.mock_db_import_repo.get_db_definition.side_effect = lambda db_type: self.side_effect_db_definitions(db_type)

        test_db_generator_ka_full = IngestibleDbTableListGenerator().get_ingestible_db_tables(IngestionType.FULL);
        self.assertEqual(2, len(test_db_generator_ka_full))
        set1 = set([table_result_ka_1_1, table_result_ka_2_2])
        set2 = set(test_db_generator_ka_full)
        self.assertEqual(2, len(set(test_db_generator_ka_full)))
        self.assertEqual(2, len(set1.intersection(set2)))

        test_db_generator_ka_incr = IngestibleDbTableListGenerator().get_ingestible_db_tables(IngestionType.INCREMENTAL);
        self.assertEqual(2, len(test_db_generator_ka_incr))
        set1 = set([table_result_ka_1_2, table_result_ka_2_1])
        set2 = set(test_db_generator_ka_incr)
        self.assertEqual(2, len(set(test_db_generator_ka_incr)))
        self.assertEqual(2, len(set1.intersection(set2)))

    def test_extract_incr_db_tables(self):
        self.mock_ingestion_job_repo.get_last_job_all_db_tables.return_value=get_last_job_all_db_tables_response

        all_tables_for_import = [table_result_ka_1_1, table_result_ka_1_2, table_result_ka_2_1, table_result_ka_2_2,
                                 table_result_kmb_1_1, table_result_kmb_1_2, table_result_kmb_2_1, table_result_kmb_2_2]

        incr_tables = IngestibleDbTableListGenerator()._extract_incr_db_tables(all_tables_for_import);
        set1 = set([table_result_ka_1_1])
        self.assertEqual(set1, set(incr_tables))

    def test_extract_full_db_tables(self):
        self.mock_ingestion_job_repo.get_last_job_all_db_tables.return_value = get_last_job_all_db_tables_response
        all_tables_for_import = [table_result_ka_1_1, table_result_ka_1_2, table_result_ka_2_1, table_result_ka_2_2,
                                 table_result_kmb_1_1, table_result_kmb_1_2, table_result_kmb_2_1, table_result_kmb_2_2]

        full_tables = IngestibleDbTableListGenerator()._extract_full_db_tables(all_tables_for_import);
        set1 = set(
            [table_result_ka_2_1, table_result_ka_2_2, table_result_kmb_1_1, table_result_kmb_1_2, table_result_kmb_2_1,
             table_result_kmb_2_2])
        set2 = set(full_tables)
        self.assertEqual(5, len(set1.intersection(set2)))

    @patch('hadoopimport.ingestible_db_table_list_generator.IngestibleDbTableListGenerator.generate_customer_databases',
           return_value=generate_customer_databases_result)
    def test_get_customer_dbs(self, mock_generate_customer_databases):

        flat_db_list = IngestibleDbTableListGenerator().generate_customer_databases();
        set1 = [get_customer_dbs_result_1, get_customer_dbs_result_2, get_customer_dbs_result_3]
        intersection = set(flat_db_list).intersection(set1)

        self.assertEqual(3, len(intersection))

    def side_effect_get_children_db(self, param):

        if param == 11111:
            return [get_customer_dbs_result_3, get_customer_dbs_result_4]
        else:
            return []

    def test_post_process_customer_db(self):
        self.mock_customer_subscription_repo.get_subscription_children_dbs.side_effect=self.side_effect_get_children_db

        full_tables = IngestibleDbTableListGenerator().post_process_customer_db(table_result_ka_1_1)
        set1 = set(full_tables)
        set2 = set([table_result_ka_1_1, get_customer_dbs_result_3, get_customer_dbs_result_4])
        intersection = set1.intersection(set2)

        self.assertEqual(3, len(intersection))
