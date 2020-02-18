from db_manager import DbManager
from config import Config
from environment import Environment

class CustomerListGenerator:
    STAGED_DB = "STAGE_CUSTOMER"
    ARCHIVED_DB = "Archived"

    def __init__(self):
        self.db_manager = DbManager()
        self.config = Config()
        self.environment = self.config.get("GLOBAL", "environment")
        self.list_cache = None

        self.logger = self.config.get_logger(__package__)

    def get_customer_list(self):
        return self.generate_customer_list()

    def get_flat_customer_list(self):
        self.logger.info("Get flat customer list")
        customer_list = self.generate_customer_list()
        flat_customer_list = []

        for customer_id, customer_info in customer_list.items():
            flat_customer_list.extend(customer_info)

        self.logger.debug("Flat customer list: %s" % flat_customer_list)
        return flat_customer_list

    def generate_customer_list(self):
        self.logger.info("Generate customer list")
        if self.list_cache is not None:
            self.logger.debug("Cached customer list: %s" % self.list_cache)
            return self.list_cache
        else:
            self.list_cache = {}
            self.logger.debug(
                "Query customers: conn name: %s, customer query: %s" % (self.conn_name, self.customer_query))
            results = self.db_manager.execute_query_with_connection(self.conn_name, self.customer_query)

            for customer in results:
                self.logger.debug(
                    "Processing customer: %s on DB: %s" % (customer["customer_id"], customer["db_server"]))

                self.list_cache[customer["customer_id"]] = self.post_process_customer(customer)

            # For debug mode, filter to customer ids
            if self.config.is_debug_enabled():
                self.list_cache = self.filter_customers_for_debugging(self.list_cache)

            self.logger.debug("New cached customer list: %s" % self.list_cache)
            return self.list_cache

    def filter_customers_for_debugging(self, customer_dict):
        self.logger.info("Filter customers for debugging")
        customer_id_str = self.config.get_debug_configuration('customer_ids')
        self.logger.debug("Customer id list: %s" % customer_id_str)

        if customer_id_str is not None:
            customer_ids = customer_id_str.split(',')
            filter_dict = {}
            for id, customer in customer_dict.items():
                if str(id) in customer_ids:
                    filter_dict[id] = customer

            self.logger.debug("Filtered customers: %s" % filter_dict)
            return filter_dict
        else:
            return customer_dict

    def post_process_customer(self, customer):
        self.logger.debug("Post process Customer Id: %s" % customer["customer_id"])
        customer = self.add_db_port(customer)
        customer = self.normalize_db_server(customer)
        return [customer]

    def normalize_db_server(self, customer):
        self.logger.debug("Normalize DB Server for Customer %s" % customer)
        if not Environment.is_production_environment(self.environment):
            # For the lower tiers there should be a "customer" database instance
            customer_db_conf = self.db_manager.get_db_conn_properties("customer")
            customer["db_server"] = customer_db_conf["db_server"]
        else:
            self.add_db_server_domain(customer)

        self.logger.debug("Customer: %s" % customer)
        return customer

    def add_db_port(self, customer):
        self.logger.debug("Add Db Port for Customer: %s" % customer)
        if not Environment.is_production_environment(self.environment):
            # For the lower tiers there should be a "customer" database instance
            customer_db_conf = self.db_manager.get_db_conn_properties("customer")
            customer["db_port"] = customer_db_conf["db_port"]
        else:
            customer["db_port"] = 4700 + int(customer["db_server"][-2:])

        return customer

    @staticmethod
    def add_db_server_domain(customer):
        config = Config()
        logger = config.get_logger(__package__)
        logger.debug("Add DB server domain for Customer: %s" % customer)
        customer["db_server"] = customer["db_server"].lower() + "." + DbManager.get_mssql_db_server_domain()
        return customer


class KmbCustomerListGenerator(CustomerListGenerator):
    conn_name = "shared"

    customer_query = """
                SELECT DISTINCT
                  c.customerid as customer_id,
                  c.databaseservername as db_server,                    
                  c.databasename as db_name
                FROM 
                  superbill_shared.dbo.customer c
                  INNER JOIN superbill_shared.dbo.productdomain_productsubscription pdps ON c.customerid=pdps.customerid
                WHERE 
                  c.DBActive = 1 AND
                  productid=5
                  AND deactivationdate IS NULL
                  AND providerguid IS NULL 
                  AND c.CustomerType='N'
                ORDER BY databaseservername
    """


class KareoAnalyticsCustomerListGenerator(CustomerListGenerator):
    conn_name = "shared"

    customer_query = """
                    SELECT
                      c.CustomerId as customer_id,
                      c.DatabaseServerName as db_server,
                      c.DatabaseName as db_name
                    FROM
                      superbill_shared.dbo.ProductDomain_ProductSubscription ps
                      JOIN superbill_Shared.dbo.Customer c ON c.CustomerId = ps.CustomerId
                    WHERE
                        c.DBActive = 1 AND
                        ps.ProviderGuid IS NULL AND
                        ps.PracticeGuid IS NULL AND
                        ps.DeactivationDate IS NULL AND
                        ps.ProductId = 8;
    """

    children_customer_query = """
                SELECT
                  c.CustomerId as customer_id,
                  c.DatabaseServerName as db_server,
                  c.DatabaseName as db_name
                FROM 
                  Superbill_Shared.dbo.ManagedBillingCompany mbc
                  JOIN Superbill_Shared.dbo.Customer c ON c.CustomerID = mbc.ChildCustomerId
                WHERE
                  c.DBActive = 1 AND
                  mbc.ChildCustomerId != mbc.ParentCustomerId AND
                  mbc.ParentCustomerId = %s
    """

    def post_process_customer(self, customer):
        self.logger.info("Post process customer")
        self.logger.debug("Customer Id: %s" % customer["customer_id"])

        parent_customer_id = customer["customer_id"]

        children_query = self.children_customer_query % parent_customer_id
        children_customers = self.db_manager.execute_query_with_connection(self.conn_name, children_query)
        self.logger.debug("Children for customer %s: %s" % (parent_customer_id, children_customers))

        self.add_db_port(customer)
        self.add_db_server_domain(customer)

        children_list = []

        for child_customer in children_customers:
            self.add_db_port(child_customer)
            self.add_db_server_domain(child_customer)
            children_list.append(child_customer)

        children_list.append(customer)
        self.logger.debug("Children list after filtering importable databases: %s" % children_list)

        return children_list
