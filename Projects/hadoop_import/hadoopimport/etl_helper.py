from config import Config


class EtlHelper:
    def __init__(self):
        self.conf = Config()
        self.logger = self.conf.get_logger(__package__)

    def get_map_reduce_conf(self, etl_name):
        self.logger.info("Get map reduce conf")
        self.logger.debug("ETL name: %s" % etl_name)

        # At the moment these values are coming from the config file but we may want to consider
        # getting them from the database instead
        return {
            "memory": self.conf.get("ETL", "mapreduce_memory"),
            "reducers": self.conf.get("ETL", "mapreduce_reducers")
        }

    def get_spark_conf(self, etl_name):
        self.logger.info("Get Spark conf")
        self.logger.debug("ETL name: %s" % etl_name)

        # At the moment these values are coming from the config file but we may want to consider
        # getting them from the database instead
        return {
            "executors": self.conf.get("ETL", "spark_executors"),
            "driver_memory": self.conf.get("ETL", "spark_driver_memory"),
            "executor_memory": self.conf.get("ETL", "spark_executor_memory")
        }
