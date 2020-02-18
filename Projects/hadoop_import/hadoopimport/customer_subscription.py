class CustomerSubscription:
    """
    Object to store customer subscription
    """

    def __init__(self, customer_id, db_server, db_name):
        self.customer_id = customer_id
        self.db_server = db_server
        self.db_name = db_name

    def __str__(self):
        return str(self.__dict__)

    def __repr__(self):
        return self.__str__()
