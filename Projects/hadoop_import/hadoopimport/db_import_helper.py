from db_manager import DbManager
from config import Config


class DbImportHelper:
    GET_IMPORT_GROUP_HDP_CONF_QUERY = """ 
                                    SELECT 
                                      MemoryAmount, Reducers 
                                    FROM 
                                      HDP_CustomerMappingType 
                                    WHERE 
                                      CustomerMappingTypeName = '%s'"""

    def __init__(self):
        self.db_manager = DbManager()

        self.config = Config()
        self.logger = self.config.get_logger(__package__)

    def get_import_group_conf(self, import_group):
        self.logger.info("Get import group conf")
        self.logger.debug("Import group: %s" % import_group)

        results = self.db_manager.execute_query_with_connection("enterprise_reports",
                                                                self.GET_IMPORT_GROUP_HDP_CONF_QUERY % import_group)

        if len(results) != 1:
            return None
        else:
            group_conf = {
                "memory": results[0]["MemoryAmount"],
                "reducers": results[0]["Reducers"]
            }
            self.logger.debug("Group conf: %s" % group_conf)
            return group_conf
