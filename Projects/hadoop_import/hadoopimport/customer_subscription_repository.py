from config import Config
from customer_subscription import CustomerSubscription
from ingestion_group import IngestionGroup
from mssql_db_manager import MsSqlDbManager, MsSqlDbName


class CustomerSubscriptionRepository:
    CUSTOMER_SUBSCRIPTION_QUERY = """
                        SELECT DISTINCT
                          c.customerid as customer_id,
                          c.databaseservername as db_server,                    
                          c.databasename as db_name
                        FROM 
                          superbill_shared.dbo.customer c
                          INNER JOIN superbill_shared.dbo.productdomain_productsubscription pdps
                          ON c.customerid=pdps.customerid
                        WHERE 
                          c.DBActive = 1
                          AND deactivationdate IS NULL 
                          AND providerguid IS NULL {0}
            """

    CHILDREN_SUBSCRIPTION_QUERY = """
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
                              mbc.ParentCustomerId = {0}
                """

    KA_CUSTOMER_FILTER = "AND pdps.productid = 8 AND c.CustomerType='N'"
    KMB_CUSTOMER_FILDER = "AND pdps.productid = 5 AND pdps.ProviderGuid IS NULL"

    def __init__(self, ingestion_group):
        self.ingestion_group = ingestion_group
        self.config = Config()
        self.logger = self.config.get_logger(__package__)
        self.mssql_db_mgr = MsSqlDbManager(db_name=MsSqlDbName.SUBSCRIPTIONS)
        self.additional_customer_filder = {
            IngestionGroup.KA: CustomerSubscriptionRepository.KA_CUSTOMER_FILTER,
            IngestionGroup.KMB: CustomerSubscriptionRepository.KMB_CUSTOMER_FILDER
        }

    def get_customer_subscriptions(self, include_children=False):
        """
        Return set of active customer ids
        :type include_children: bool
        :rtype: list of CustomerSubscription
        """
        self.logger.info("Get Customer subscriptions")
        subscriptions = self._get_parent_customer_subscriptions()
        if include_children:
            all_subscriptions = []
            for subscription in subscriptions:
                all_subscriptions.append(subscription)
                all_subscriptions.extend(self._get_children_customer_subscriptions(subscription.customer_id))
            return all_subscriptions
        else:
            return subscriptions

    def _get_parent_customer_subscriptions(self):
        """

        :rtype: list of CustomerSubscription
        """
        self.logger.debug("Get parent customer subscriptions, Ingestion Group: %s" % self.ingestion_group)
        query = self.CUSTOMER_SUBSCRIPTION_QUERY.format(self.additional_customer_filder[self.ingestion_group])
        self.logger.debug("Get parent customer subscriptions, Query: %s" % query)
        customer_subscription_dbs = self.mssql_db_mgr.execute_query(query)
        customer_subscriptions = map(self._customer_subscription_row_mapper, customer_subscription_dbs)
        if self.config.is_debug_enabled():
            debugging_custmer_ids = self.config.get_debug_customer_ids()
            return filter(lambda subscription: subscription.customer_id in debugging_custmer_ids, customer_subscriptions)
        else:
            return customer_subscriptions



    def _get_children_customer_subscriptions(self, parent_customer_id):
        """

        :type parent_customer_id: int
        :rtype: list of CustomerSubscription
        """
        self.logger.debug("Ger children subscriptions for parent customer ID: %s" % parent_customer_id)
        query = self.CHILDREN_SUBSCRIPTION_QUERY.format(parent_customer_id)
        children_subscription_dbs = self.mssql_db_mgr.execute_query(query)
        return map(self._customer_subscription_row_mapper, children_subscription_dbs)

    def _customer_subscription_row_mapper(self, customer_subscription_row):
        """
        :type customer_subscription_row: dict
        :rtype: CustomerSubscription
        """
        self.logger.debug("Map customer subscription row: %s" % customer_subscription_row)
        return CustomerSubscription(customer_id=customer_subscription_row["customer_id"],
                                    db_name=customer_subscription_row["db_name"],
                                    db_server=customer_subscription_row["db_server"])
