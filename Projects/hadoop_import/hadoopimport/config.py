import logging.config
import os
import re
import sys

from ConfigParser import ConfigParser

"""
    This module wraps config reader so that other modules don't have to worry about where the config is located. 
    This is also be a good place to add any helper methods to read from the config, for example a method that reads
    all database configuration sections. 
"""


class MissingConfigFileException(Exception):
    pass


class MissingConfigException(Exception):
    pass


class ConfigNamespace:
    GLOBAL = 'GLOBAL'
    DEBUG = 'DEBUG'
    INGESTION = "INGESTION"

    def __init__(self):
        pass

class GlobalProperty:
    ENVIRONMENT = 'environment'
    IS_DEBUG_ENABLED = 'is_debug_enabled'

    def __init__(self):
        pass


class DebugProperty:
    CUSTOMER_IDS = 'customer_ids'

    def __init__(self):
        pass

class Config(object):
    CONFIG_FILE_NAME = "config.ini"
    CONFIG_DIR_NAME = "configs"
    LOGGING_CONF_NAME = "logging.conf"
    SUMMARY_CONF_NAME = "summary.conf"
    SECTION_PATTERN = re.compile("(\w+):(\w+):(\w+)")

    # TODO: Legacy constants used by old DB Manager remove when migrating to new db manager
    # Start of legacy constants
    DB_CONF_SECTION = re.compile("DBCONN:(\w+):(\w+)")
    DB_COMMON_SECTION = "DB_COMMON"
    DEBUG_SECTION = "DEBUG"
    # End of legacy constants

    config = None

    def has_section(self, section_name):
        return self.config.has_section(section_name)

    def get(self, section_name, option):
        section_name = str(section_name)
        option = str(option)
        section_config = self.get_section_with_common(section_name)
        if option in section_config:
            return section_config[option]
        else:
            raise MissingConfigException("Could not find a config option %s", option)

    def get_section(self, section_name):
        """
        Returns the config dictionary for a section name

        :type section_name: str
        :rtype: dict
        """
        if self.has_section(section_name):
            return dict(self.config.items(section_name))
        else:
            raise MissingConfigException("Could not find a config section %s", section_name)

    # TODO: Remove these legacy methods when migrating to new DbManager
    # Start of legacy methods
    def get_all_db_configurations(self):
        db_configurations = []

        for section in self.config.sections():
            match = self.DB_CONF_SECTION.match(section)

            if match is not None:
                section_name = match.group(2)
                db_type = match.group(1)

                db_conf = self.massage_db_configuration(dict(self.config.items(section)), section_name, db_type)

                db_configurations.append(db_conf)

        return db_configurations

    def massage_db_configuration(self, db_conf, section_name, db_type):
        common_db_conf = dict(self.get_section(self.DB_COMMON_SECTION))

        db_conf["conn_name"] = section_name
        db_conf["db_type"] = db_type

        if "user" not in db_conf or not db_conf["user"]:
            db_conf["user"] = common_db_conf[db_type + "_user"]

        if "passwd" not in db_conf or not db_conf["passwd"]:
            db_conf["passwd"] = common_db_conf[db_type + "_passwd"]

        if "server" not in db_conf or not db_conf["server"]:
            db_conf["server"] = common_db_conf[db_type + "_server"]

        if "port" not in db_conf or not db_conf["port"]:
            db_conf["port"] = common_db_conf[db_type + "_port"]

        return db_conf

    def get_hive_conf(self):

        return {
            "num_buckets": self.config.get("HIVE", "hive_buckets"),
        }

    def get_debug_configuration(self, key):
        if self.is_debug_enabled():
            return self.config.get(self.DEBUG_SECTION, key)
        else:
            return None

    # END of legacy methods

    def is_debug_enabled(self):
        """
        Returns True if debug is enabled

        :rtype: bool
        """
        return self.get(ConfigNamespace.GLOBAL, GlobalProperty.IS_DEBUG_ENABLED) == 'true'

    def get_debug_customer_ids(self):
        """
        Returns a list of customer IDs for debugging defined in config debug section

        :rtype: list of int
        """
        customers_str = self.get(ConfigNamespace.DEBUG, DebugProperty.CUSTOMER_IDS)
        customer_ids = []
        for customer_id_str in customers_str.split(','):
            customer_ids.append(int(customer_id_str))
        return customer_ids

    def get_global_environment(self):
        """
        Returns the global environment set in config

        :rtype: str
        """
        return self.get(ConfigNamespace.GLOBAL, GlobalProperty.ENVIRONMENT)

    @staticmethod
    def get_section_name(namespace, group=None, option=None):
        """
        Returns a section name from the given namespace, group and option

        :type namespace: str
        :type group: str
        :type option: str
        :rtype: str
        """
        if option is None:
            if group is None:
                return '%s' % namespace
            else:
                return '%s:%s' % (namespace, group)
        else:
            return '%s:%s:%s' % (namespace, group, option)

    def get_section_with_common(self, section_name):
        """
        Returns a section configs with name pattern [namespace:section_type:section_name],
        enriched with common configs for the namespace and type.

        :param section_name: The section name
        :type section_name: str
        :return: The section configs
        :rtype: dict
        """
        match = self.SECTION_PATTERN.match(section_name)
        if match is not None:
            if self.has_section(section_name):
                section = self.get_section(section_name)
            else:
                section = {}
            common_section_name = '%s:%s' % (match.group(1), match.group(2))
            if self.has_section(common_section_name):
                common_section = self.get_section(common_section_name)
            else:
                common_section = {}
            return dict(common_section, **section)
        else:
            return self.get_section(section_name)

    @staticmethod
    def _get_config_file(file_name):
        file_in_current_dir = os.path.join(os.path.abspath(os.path.dirname(__file__)), file_name)
        file_in_configs_dir = os.path.join(Config.CONFIG_DIR_NAME, file_name)
        # First check if the file exist in the current package
        if os.path.isfile(file_in_current_dir):
            return file_in_current_dir
        # Next, check if there' a configuration file in the current working directory
        elif os.path.isfile(file_name):
            return file_name
        # Next, check if there is a configs directory containing the config file
        elif os.path.isfile(file_in_configs_dir):
            return file_in_configs_dir
        else:
            raise MissingConfigFileException("Could not find a valid configuration file")

    @staticmethod
    def get_config_file():
        return Config._get_config_file(Config.CONFIG_FILE_NAME)

    @staticmethod
    def get_logging_file():
        return Config._get_config_file(Config.LOGGING_CONF_NAME)

    @staticmethod
    def get_logger(handler=None):
        logging.config.fileConfig(Config.get_logging_file())
        return logging.getLogger(handler)

    @staticmethod
    def get_summary_config_file():
        return Config._get_config_file(Config.SUMMARY_CONF_NAME)

    @staticmethod
    def get_summary_config_parser():
        """
        Returns a config parser for the summary config file

        :rtype: ConfigParser
        """
        summary_config = ConfigParser()
        summary_config.read(Config.get_summary_config_file())
        return summary_config

    def __init__(self):

        if self.config is None:
            logger = Config.get_logger(__package__)
            try:
                # Set the class variable config using the class reference so that it is shared,
                # read it using the instance reference
                Config.config = ConfigParser()
                self.config.read(Config.get_config_file())
            except Exception as ex:
                logger.error("Error reading config file: %s" % ex)
                logger.exception(ex)
                sys.exit(1)
