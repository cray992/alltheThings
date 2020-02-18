#!/usr/bin/env python
import traceback

from config import Config
from datetime import datetime

from database_type import DatabaseType
from ingestible_db_repository import IngestibleDbConfRepository
from hive_db_manager import HiveDbManager
from emailer import Emailer

# Constants
DEFAULT_EMAIL_SUBJECT = 'Data Ingestion Summary'

# Config Constants
GLOBAL_SECTION = 'GLOBAL'
ENVIRONMENT_CONFIG = "environment"
SMTP_SECTION = 'SMTP'
SMTP_SERVER_CONFIG='smtp_server'
REPORT_RECIPIENTS = 'report_recipients'
STAGE_SECTION_PREFIX = 'Stage'
DB_NAME = 'db_name'
DB_TYPE = 'db_type'
TABLES = 'tables'
REPORT_DISTINCT_CUSTOMERS = 'report_distinct_customers'
DISTINCT_CUSTOMERS_COLUMN = 'distinct_customers_column'
DISTINCT_CUSTOMERS_TABLE = 'distinct_customers_table'


class StageSummary(object):
    """
    Data object representing the results of a Data Ingestion stage

    """

    def __init__(self, stage, table_row_counts, ingested_customers=None):
        self.stage = stage
        self.ingested_customers = ingested_customers
        self.table_row_counts = table_row_counts

    def get_empty_tables(self):
        """
        Returns a list of empty tables given a map of table row counts

        :param table_row_counts: A dictionary mapping table name to row count
        :type table_row_counts: dict of str:int
        :return: A list of empty tables
        """
        empty_tables = []
        for table, row_count in self.table_row_counts.items():
            if row_count == 0:
                empty_tables.append(table)
        return empty_tables

    def __str__(self):
        """
        Formats a list of stage summary

        :return: The string representation of this summary report
        :rtype: str
        """
        report = ['=' * 80, 'Stage: %s' % self.stage]
        if self.ingested_customers:
            report.append('Number of ingested customers: %s' % len(self.ingested_customers))
        empty_tables = self.get_empty_tables()
        if empty_tables:
            report.append('Empty Tables: %s' % empty_tables)
        report.append('Table row counts: %s' % self.table_row_counts)
        return '\n'.join(report)


class IngestionReporter(object):
    """
    Class in charge of summarizing and reporting the results of data ingestion pipeline

    """

    def __init__(self):
        self.hive_db_mgr = HiveDbManager()
        self.config = Config()
        self.logger = self.config.get_logger(__package__)
        self.report_config = Config.get_summary_config_parser()

    def get_config_option(self, section, option, mandatory=True):
        """
        Returns a config option value.

        :param section: The section name
        :type section: str
        :param option: The config option
        :type option: str
        :param mandatory: Whether this option is mandatory or not
        :type mandatory: bool
        :return: The config value
        :rtype: str
        :raises Exception: If the option is missing and it is mandatory.
        """
        if self.report_config.has_option(section, option):
            return self.report_config.get(section, option)
        else:
            if mandatory:
                raise Exception('Missing config option %s of section %s' % (option, section))
            else:
                return None

    @staticmethod
    def get_stage_section_name(stage):
        """
        Returns the stage config section name

        :param stage: The stage name
        :type stage: str
        :return: The config section name
        :rtype: str
        """
        return '%s:%s' % (STAGE_SECTION_PREFIX, stage)

    def get_tables_to_validate(self, stage):
        """
        Returns the list of tables to validate

        :return: List of table names
        :rtype: list of str
        """
        tables = []
        table_option_str = self.get_config_option(IngestionReporter.get_stage_section_name(stage), TABLES)
        for table in table_option_str.split('\n'):
            if len(table) > 0:
                tables.append(table)
        return tables

    def get_stages(self):
        """
        Returns a list of stages from the summary config

        :return: List of stages
        :rtype: list of str
        """
        stages = []
        for section in self.report_config.sections():
            if section.startswith(STAGE_SECTION_PREFIX):
                stage = section.split(':')[1]
                # We only load in the configuration for the new pipeline
                if stage != 'Import Customer DB':
                    stages.append(stage)
        return stages

    def run_sql(self, db_name, query):
        """
        Executes a Hive sql statement using the given DB name

        :param db_name: A DB name
        :type db_name: str
        :param query: A single sql query without semicolon
        :type query: str
        :return: The resulting list of tuples
        :rtype: list of dict
        """
        self.logger.debug('Now running SQL %s' % query)
        result = self.hive_db_mgr.execute_query(query.strip(), db_name=db_name)
        self.logger.debug('Query executed successfully')
        return result

    def get_distinct_values(self, db_name, table, column):
        """
        Returns the list of distinct values from the given column and table

        :param db_name: A connection name defined in config
        :type db_name: str
        :param table: A table name
        :type table: str
        :param column: A column name
        :type column: str
        :return: The list of disctinct values
        :rtype: list of str
        """
        values = []
        results = self.run_sql(db_name, 'select distinct %s from %s order by %s' % (column, table, column))
        for row in results:
            values.append(row[0])
        return values

    def get_table_row_count(self, db_name, table):
        """
        Returns the number of rows in a table

        :param db_name: A connection name defined in config
        :type db_name: str
        :param table: A table name
        :type table: str
        :return: The number of rows in the table
        :rtype: int
        """
        results = self.run_sql(db_name, 'select count(*) as num_rows from %s' % table)
        return results[0][0]

    def get_tables_row_counts(self, db_name, tables):
        """
        Returns a map of table to row count for a list of tables using the given DB connection

        :param db_name: A connection name defined in config
        :type db_name: str
        :param tables: A list of table names
        :type tables: list of str
        :return: A dictionary mapping table name to row count
        :rtype: dict of str:int
        """
        table_to_row_counts = {}
        for table in tables:
            table_to_row_counts[table] = self.get_table_row_count(db_name, table)
        return table_to_row_counts

    def get_ingested_customers(self, db_name, stage):
        """
        Return number of customers ingested for the given stage

        :param db_name: A connection name defined in config
        :type db_name: str
        :param stage: A stage name
        :type stage: str
        :return: List of ingested customer IDs
        :rtype: list of int
        """
        self.logger.info('Obtaining list of customers ingested for stage %s' % stage)
        stage_section_name = self.get_stage_section_name(stage)
        distinct_customers_table = self.get_config_option(stage_section_name, DISTINCT_CUSTOMERS_TABLE)
        distinct_customers_column = self.get_config_option(stage_section_name, DISTINCT_CUSTOMERS_COLUMN)
        customer_ids = self.get_distinct_values(db_name, distinct_customers_table, distinct_customers_column)
        self.logger.info('Done obtaining list of customers ingested for stage %s' % stage)
        return customer_ids

    def get_summary(self, stage, target_db_names):
        """
        Returns a summary of stage

        :param stage: A stage name as defined in the summary config file
        :type stage: str
        :param target_db_names: a list of target db name(hive)
        :type target_db_names: list of str
        :return: The summary for the given stage
        :rtype: StageSummary
        """
        self.logger.info('Generating summary for stage %s' % stage)
        stage_section_name = self.get_stage_section_name(stage)

        db_type = self.get_config_option(stage_section_name, DB_TYPE, False)
        if db_type is not None:
            db_name = target_db_names[getattr(DatabaseType, db_type)]
        else:
            db_name = self.get_config_option(stage_section_name, DB_NAME, False)

        if db_name is None:
            raise Exception("No target database found.")

        tables = self.get_tables_to_validate(stage)
        table_row_counts = self.get_tables_row_counts(db_name, tables)

        report_distinct_customers = self.get_config_option(stage_section_name, REPORT_DISTINCT_CUSTOMERS,
                                                           mandatory=False)
        if report_distinct_customers and report_distinct_customers.lower() == 'true':
            ingested_customers = self.get_ingested_customers(db_name, stage)
            return StageSummary(stage, table_row_counts, ingested_customers)
        else:
            return StageSummary(stage, table_row_counts)

    def email_summary_report(self, body, subject=DEFAULT_EMAIL_SUBJECT):
        """
        Sends an summary report email with the given body to the configured list of recipients.

        :param body: The report body
        :type: str
        :param subject: An email subject
        :type subject: str
        :return: None
        """

        recipients = self.get_config_option(GLOBAL_SECTION, REPORT_RECIPIENTS)
        environment = self.config.get(GLOBAL_SECTION, ENVIRONMENT_CONFIG)
        subject_env = "%s - %s" % (environment, subject)
        smtp_server = self.config.get(SMTP_SECTION, SMTP_SERVER_CONFIG)
        emailer = Emailer(smtp_server)
        emailer.send_email(recipients, body, '%s %s' % (subject_env, datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")))

    def execute(self, ingestion_group):
        """
        :type ingestion_group: IngestionGroup
        :rtype:
        """
        self.logger.info('Preparing Kareo Analytics Data Ingestion Summary')

        ingestible_db_repo = IngestibleDbConfRepository(ingestion_group)
        target_db_names = ingestible_db_repo.get_target_db_names()

        stage_summaries = []
        for stage in self.get_stages():
            try:
                stage_summary = self.get_summary(stage, target_db_names)
                self.logger.info(stage_summary)
                stage_summaries.append('%s\n' % stage_summary)
            except Exception as ex:
                error_msg = 'Failed to obtain summary for stage: %s' % stage
                self.logger.error(error_msg)
                self.logger.exception(ex)
                stage_summaries.append(error_msg)
                stage_summaries.append(traceback.format_exc())

        summary_report = '\n'.join(stage_summaries)
        self.email_summary_report(summary_report)

        self.logger.info('Done Preparing Kareo Analytics Data Ingestion Summary')
