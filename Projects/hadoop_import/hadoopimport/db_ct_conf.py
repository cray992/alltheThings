class DbCTConf:
    def __init__(self, db_id, db_server, db_name, db_enabled, create_time, modified_time):
        """
        :type db_id: int
        :type db_server: str
        :type db_name: list
        :type db_enabled: bool
        :type create_time: datetime
        :type modified_time: datetime
        """

        self.db_id = db_id
        self.db_server = db_server
        self.db_name = db_name
        self.db_enabled = db_enabled
        self.create_time = create_time
        self.modified_time = modified_time

    def __str__(self):
        return str(self.__dict__)

    def __repr__(self):
        return self.__str__()

    def __hash__(self):
        sorted_dict = ', '.join("%s: %s" % item for item in sorted(self.__dict__.items(), key=lambda i: i[0]))
        return hash(sorted_dict)

    def __eq__(self, other):
        return self.__hash__() == other.__hash__()

    def __ne__(self, other):
        return not self.__eq__(other)