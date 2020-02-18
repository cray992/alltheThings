#!/usr/bin/env python

from datetime import datetime
from hadoopimport.config import Config, ConfigNamespace
import hadoopimport.cli_utils as cli_utils
import requests
import argparse
import os.path
import pytz

######################## Initialization Block Begin #########################

config = Config()
logger = config.get_logger(__package__)


######################### Initialization Block End ##########################

def main(start_time, end_time, output_file_name, user, application_type, log_type, key_word, max_errors, time_zone,
         hadoop_rest_host_and_port):
    """
        Searches for errors on  Hadoop cluster log files

        :type start_time: str Date with this format YYYY/MM/DD hh:mm:ss
        :type end_time: str Date with this format YYYY/MM/DD hh:mm:ss
        :type output_file_name: str Output file name
        :type user: str Hadoop job User filter
        :type application_type: str Hadoop job application type filter
        :type log_type: str Hadoop job log type (stdout, stderr,...)
        :type key_word: str The word(s) to search for. To search for more than one word you can use grep style: (W1\|W2\|W3...)
        :type max_errors: int Once errors have been found in different files (max_errors times), the script stops
        :type time_zone: str Time zone used to convert to UTC time (server time is UTC)
        :type hadoop_rest_host_and_port: str Hadoop host: str port where the Cluster Application API is exposed

    """
    app_ids_str = get_app_ids(start_time, end_time, user, application_type, time_zone, hadoop_rest_host_and_port)

    if app_ids_str:
        search_apps(app_ids_str, output_file_name, log_type, key_word, max_errors)
    else:
        print "---------------------------------------------------------------------------- NO JOBS (APPLICATION IDS) FOUND, PLEASE TRY WITH DIFFERENT FILTERS ----------------------------------------------------------------------------"

    logger.info("Search Finished!")


def search_apps(app_ids_str, output_file_name, log_type, key_word, max_errors):
    """
        Executes a yarn command to get all log files (for all application ids in app_ids_str) and filters it
        using grep command

        :type app_ids_str: str Application Ids blank space separated
        :type output_file_name: str Output file name
        :type log_type: str Hadoop job log type (stdout, stderr,...)
        :type key_word: str The word to search for.
        :type max_errors: int Once errors have been found in different files (max_errors times), the script stops

    """
    default_output_file_name = "searchErrorsOut.txt"
    yarn_logs_template = """
                        msg_buff=""; \\
                        rm -f {0}; \\
                        error_count=0; \\
                        for appId in {1}; \\
                        do \\
                            if [[ $error_count -ge {4} ]]; then break; fi 
                            error_msg=$( yarn logs -applicationId $appId -log_files {2} | grep '{3}' );\\
                            if [ ! -z "$error_msg" ]; then \\
                                msg_buff=$msg_buff"\\n\\n******************* ERROR FOUND IN APP: $appId ******************* \\n EXECUTE THIS COMMAND TO DISPLAY THE LOG FILE: yarn logs -applicationId $appId -log_files stdout  \\n ERROR: "$error_msg; \\
                                error_count=$(($error_count+1));
                            fi
                        done; \\
                        if [ ! -z "$msg_buff" ]; then \\
                            printf "$msg_buff\\n" > {0}; \\
                        fi
                        """

    if not output_file_name:
        output_file_name = default_output_file_name

    yarn_logs_command = yarn_logs_template.format(output_file_name, app_ids_str, log_type, key_word, max_errors)
    cli_utils.execute_shell_command(yarn_logs_command)
    error_file_content = None
    if os.path.exists(output_file_name):
        with open(output_file_name, 'r') as output_file:
            error_file_content = output_file.read()

    if error_file_content:
        print "**************************************************************************** ERRORS FOUND ****************************************************************************"
        print error_file_content
        print "**************************************************************************** ERRORS FOUND (output file: {0})****************************************************************************".format(
            output_file_name)
    else:
        print "---------------------------------------------------------------------------- NO ERRORS FOUND ----------------------------------------------------------------------------"


def get_current_hostname():
    """
        Executes a hostname command to get the local hostname then replaces hdat with hmas
        because it assumes that's the way master nodes and deployment nodes are named.
        :return: master node hostname
        :rtype: str
    """
    return cli_utils.execute_shell_with_output("hostname")[0].replace("hdat", "hmas")


def get_cluster_apps_url_query(start_time, end_time, user, application_type, time_zone, hadoop_rest_host_port):
    """
        Formats the Hadoop Cluster REST API URL (used to get the application ids)

        :type start_time: str Datetime with this format YYYY/MM/DD hh:mm:ss
        :type end_time: str Datetime with this format YYYY/MM/DD hh:mm:ss
        :type user: str Hadoop job User filter
        :type application_type: str Hadoop job application type filter
        :type time_zone: str Time zone used to convert to UTC time (server time is UTC)
        :type hadoop_rest_host_port str Hadoop host: str port where the Cluster Application API is exposed
        :return: Query URL
        "rtype" str

    """

    start_time_ms = convert_to_utcepoch_time_milis(start_time, time_zone)

    if hadoop_rest_host_port:
        url = "http://{0}/ws/v1/cluster/apps?startedTimeBegin={1}".format(hadoop_rest_host_port, start_time_ms)
    else:
        hostname = get_current_hostname()
        url = "http://{0}:8088/ws/v1/cluster/apps?startedTimeBegin={1}".format(hostname, start_time_ms)

    if end_time:
        end_time_ms = convert_to_utcepoch_time_milis(end_time, time_zone)
        url = url + "&startedTimeEnd={0}".format(end_time_ms)
    if user:
        url = url + "&user={0}".format(user)
    if application_type:
        url = url + "&applicationTypes={0}".format(application_type)

    return url


def get_app_ids(start_time, end_time, user, application_type, time_zone, hadoop_rest_host_port):
    """
        Gets the application id (job ids) list

        :type start_time: str Datetime with this format YYYY/MM/DD hh:mm:ss
        :type end_time: str Datetime with this format YYYY/MM/DD hh:mm:ss
        :type user: str Hadoop job User filter
        :type application_type: str Hadoop job application type filter
        :type time_zone: str Time zone used to convert to UTC time (server time is UTC)
        :type hadoop_rest_host_port str Hadoop host: str port where the Cluster Application API is exposed

    """

    apps_json = requests.get(get_cluster_apps_url_query(start_time, end_time, user, application_type, time_zone,
                                                        hadoop_rest_host_port)).json()

    if not apps_json["apps"]:
        return []

    return ' '.join([app["id"] for app in apps_json["apps"]["app"]])


def convert_to_utcepoch_time_milis(datetime_param, time_zone):
    """
    Converts a datetime to UTC epoch time milliseconds
    :param datetime_param: datetime Datetime to convert
    :param time_zone: str Time zone used to convert from (to UTC).
    :return: milliseconds
    :rtype: int
    """
    local = pytz.timezone(time_zone)
    return int(total_seconds(
        local.localize(datetime_param, is_dst=True) - pytz.utc.localize(datetime.utcfromtimestamp(0))) * 1000)


def total_seconds(timedelta):  # TODO: Get rid of this method as soon as we move to python 2.7
    """
    Converts the timedelta object to seconds
    :param timedelta: timedelta
    :return: seconds
    :rtype: int
    """
    return (timedelta.microseconds + 0.0 +
            (timedelta.seconds + timedelta.days * 24 * 3600) * 10 ** 6) / 10 ** 6


def valid_datetime(str):
    """
    Converts an string into a datetime.
    :param str: Datetime with this format YYYY/MM/DD hh:mm:ss
    :return: Converted datetime
    :rtype: datetime
    :raises: argparse.ArgumentTypeError if the parameter does not have the expected format (YYYY/MM/DD hh:mm:ss)
    """
    try:
        return datetime.strptime(str, "%Y/%m/%d %H:%M:%S")
    except ValueError:
        msg = "Not a valid date: '{0}', format expected: YYYY/MM/DD hh:mm:ss".format(str)
        raise argparse.ArgumentTypeError(msg)


def parse_command_line_arguments():
    """
    Parses the command line args
    :return: Arguments dictionary
    :rtype: dict
    """
    default_output_file = "searchErrorsOut.txt"

    parser = argparse.ArgumentParser(description="Searches for errors in hadoop log files")
    parser.add_argument("-s", "--start_time", help="Range Start Time, Format: YYYY/MM/DD hh:mm:ss", type=valid_datetime)
    parser.add_argument("-e", "--end_time", help="Range End Time, Format: YYYY/MM/DD hh:mm:ss", type=valid_datetime)
    parser.add_argument("-f", "--output_file_name",
                        help="File where the errors will be written to. No file will be created if there isn't errors. The file will be removed if it exists. Default file: {0}".format(default_output_file),
                        default=default_output_file,
                        required=False)
    parser.add_argument("-u", "--user", help="Job User (Ex: s-jamsstg-svc, hive, etc)", required=False)
    parser.add_argument("-t", "--application_type", help="Job Application Type (Ex: SPARK, MAPREDUCE, TEZ, ...)",
                        required=False)
    parser.add_argument("-l", "--log_type", help="Log type, default is stdout, could be also stderr", required=False,
                        default="stdout")
    parser.add_argument("-k", "--key_word",
                        help="Searches for this keyword in the log files. Default value is ERROR. More than one key word could be used Ex: ERROR\|Exception",
                        required=False, default="ERROR")
    parser.add_argument("-m", "--max_errors",
                        help="Once errors have been found in different files (max_errors times), the script stops. Default value is 10",
                        required=False, default=10)
    parser.add_argument("-tz", "--time_zone",
                        help="Local time zone used to convert to UTC. Default value is America/Los_Angeles",
                        required=False, default="America/Los_Angeles")
    parser.add_argument("-hp", "--hadoop_rest_host_and_port",
                        help="Hadoop host:port where the Cluster Application REST API is exposed. Ex: sna-sgx-hmas-01.kareoprod.ent:8088. If no parameter is provided, the value the currrent hostname() is used replacing 'hdat' with 'hmas'.",
                        required=False)

    return vars(parser.parse_args())


if __name__ == "__main__":
    main(**parse_command_line_arguments())
