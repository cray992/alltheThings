#!/usr/bin/env python
from datetime import datetime

import itertools

from config import Config, MissingConfigException
from hadoopimport.ingestion_job_repository import IngestionJobRepository
from hadoopimport.ingestion_job_status import IngestionJobStatus
from emailer import Emailer

# Constants
FAILURE_EMAIL_SUBJECT = 'Data Ingestion Failure Summary'
DEFAULT_REPORT_FAILURE_LIMIT = 1000

# Config Constants
GLOBAL_SECTION = 'GLOBAL'
ENVIRONMENT_CONFIG = "environment"
SMTP_SECTION = 'SMTP'
SMTP_SERVER_CONFIG='smtp_server'
FAILURE_REPORT_RECIPIENTS = 'failure_report_recipients'
REPORT_FAILURE_LIMIT = 'report_failure_limit'
INGESTION_JOB_TABLE = 'HDP_IngestionJob'


class FailureSummary(object):
    """
    Data object representing the results of a Data Ingestion failure

    """

    def __init__(self, failure_tables):
        self.failure_tables = failure_tables  # a tuple contains table name, ingestion type and update time

    def __str__(self):
        """
        Formats a list of failure ingestion summary

        :return: The string representation of this failure summary report
        :rtype: str
        """

        group_failure_tables = []
        for key, group in itertools.groupby(self.failure_tables, lambda group_item: group_item['DbName']):
            key_group = {key: list(group)}
            group_failure_tables.append(key_group)

        report = ['=' * 80]
        for failure_table in group_failure_tables:
            for key in failure_table:
                report.append('=== DATABASE: ' + str(key) + " ===")
                customer_failure_tables = failure_table[key]
                for customer_failure_table in customer_failure_tables:
                    item = 'TableName: ' + customer_failure_table.get('TableName') + ', IngestionJobType: ' + str(
                        customer_failure_table.get('IngestionJobType'))
                    report.append(item)
                report.append('   ')

        return '\n'.join(report)


class IngestionFailureReporter(object):
    """
    Class in charge of reporting the data ingestion failure

    """

    def __init__(self):
        self.ingestion_job_repo = IngestionJobRepository()
        self.config = Config()
        self.logger = self.config.get_logger(__package__)
        self.report_failure_limit = DEFAULT_REPORT_FAILURE_LIMIT
        try:
            report_failure_limit_str = self.config.get(GLOBAL_SECTION, REPORT_FAILURE_LIMIT)
            if report_failure_limit_str.strip():
                self.report_failure_limit = int(report_failure_limit_str.strip())
        except MissingConfigException:
            self.report_failure_limit = DEFAULT_REPORT_FAILURE_LIMIT

    def send_failure_job_summary(self, ingestion_group):
        """
        Sends a summary of failure ingestion jobs

        :type ingestion_group: IngestionGroup
        :rtype:

        """
        self.logger.info('Generating failure ingestion summary')

        failure_job_tables = self.ingestion_job_repo.get_last_ingestion_jobs_by_status(IngestionJobStatus.FAIL)
        if failure_job_tables:
            limit_failure_job_tables = failure_job_tables
            if len(failure_job_tables) > self.report_failure_limit:
                limit_failure_job_tables = failure_job_tables[0: self.report_failure_limit]

            failure_summary = FailureSummary(limit_failure_job_tables)
            failure_report = failure_summary.__str__()
            self.email_failure_summary_report(failure_report)

    def email_failure_summary_report(self, body, subject=FAILURE_EMAIL_SUBJECT):
        """
        Sends a failure summary report email with the given body to the configured list of recipients.

        :param body: The report body
        :type: str
        :param subject: An email subject
        :type subject: str
        :return: None
        """

        recipients = self.config.get(GLOBAL_SECTION, FAILURE_REPORT_RECIPIENTS)
        environment = self.config.get(GLOBAL_SECTION, ENVIRONMENT_CONFIG)
        subject_env = "%s - %s" % (environment, subject)
        smtp_server = self.config.get(SMTP_SECTION, SMTP_SERVER_CONFIG)
        emailer = Emailer(smtp_server)
        emailer.send_email(recipients, body, '%s %s' % (subject_env, datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")))
