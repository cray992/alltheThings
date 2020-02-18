from config import Config
from mssql_db_manager import MsSqlDbManager, MsSqlDbName


class DbCategory:
    def __init__(self, db_category_id, db_category_name, min_table_size_mb, max_table_size_mb, num_workers,
                 num_executors, executor_memory, executor_cores, driver_memory, driver_cores, create_time, update_time):
        """
        :type db_category_id: int
        :type db_category_name: str
        :type min_table_size_mb: int
        :type max_table_size_mb: int
        :type num_workers: int
        :type num_executors: int
        :type executors_memory: int
        :type executors_cores: int
        :type driver_memory: int
        :type driver_cores: int
        :type create_time: datetime.datetime
        :type update_time: datetime.datetime
        """
        self.db_category_id = db_category_id
        self.db_category_name = db_category_name
        self.min_table_size_mb = min_table_size_mb
        self.max_table_size_mb = max_table_size_mb
        self.num_workers = num_workers
        self.num_executors = num_executors
        self.executor_memory = executor_memory
        self.executor_cores = executor_cores
        self.driver_memory = driver_memory
        self.driver_cores = driver_cores
        self.create_time = create_time
        self.update_time = update_time

    def __str__(self):
        return '%s(%s)' % (type(self).__name__, ', '.join('%s=%s' % item for item in vars(self).items()))

    def __repr__(self):
        return self.__str__()

    def __eq__(self, other):
        if isinstance(other, self.__class__):
            return self.__dict__ == other.__dict__
        else:
            return False


class DbCategoryRepository:
    GET_ALL_DB_CATEGORIES_QUERY = """SELECT
                                        DbCategoryId,
                                        DbCategoryName,
                                        MinTableSizeMB,
                                        MaxTableSizeMB,
                                        NumWorkers,
                                        NumExecutors,
                                        ExecutorMemory,
                                        ExecutorCores,
                                        DriverMemory,
                                        DriverCores,
                                        CreateTime,
                                        UpdateTime                                     
                                    FROM
                                        HDP_DBCategory"""

    def __init__(self):
        self.mssql_db_mgr = MsSqlDbManager(db_name=MsSqlDbName.APPLICATION_METADATA)
        self.config = Config()
        self.logger = self.config.get_logger(__package__)

    @staticmethod
    def _parse_record(record):
        """
        :type record: dict
        :rtype: DbCategory
        """
        return DbCategory(record.get("DbCategoryId"),
                          record.get("DbCategoryName"),
                          record.get("MinTableSizeMB"),
                          record.get("MaxTableSizeMB"),
                          record.get("NumWorkers"),
                          record.get("NumExecutors"),
                          record.get("ExecutorMemory"),
                          record.get("ExecutorCores"),
                          record.get("DriverMemory"),
                          record.get("DriverCores"),
                          record.get("CreateTime"),
                          record.get("UpdateTime"))

    def get_all_db_categories(self):
        """
        Returns a dictionary of DB Category ID to DbCategory

        :rtype: dict of int:DbCategory
        """
        self.logger.debug("Get all DB categories")
        all_categories = {}
        result = self.mssql_db_mgr.execute_query(DbCategoryRepository.GET_ALL_DB_CATEGORIES_QUERY)
        self.logger.debug("Query result for All DB categories: %s" % result)
        for record in result:
            db_category = DbCategoryRepository._parse_record(record)
            all_categories[db_category.db_category_id] = db_category
        self.logger.debug("Got all DB Categories: %s" % all_categories)
        return all_categories
