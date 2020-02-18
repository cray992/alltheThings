class DbConnConf:
    """
    Object to store database connection info.
    """

    def __init__(self, db_name, db_server, db_port=None, db_user=None, db_password=None):
        """

        :type db_name: str
        :type db_server: str
        :type db_port: str
        :type db_user: str
        :type db_password: str
        """
        self.db_name = db_name
        self.db_server = db_server
        self.db_port = db_port
        self.db_user = db_user
        self.db_password = db_password

    def __str__(self):
        return str(self.__dict__)

    def __repr__(self):
        return self.__str__()