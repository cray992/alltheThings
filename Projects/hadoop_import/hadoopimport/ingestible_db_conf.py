from mssql_db_manager import MsSqlDbConnConf


class IngestibleDbConf(MsSqlDbConnConf):
    """
    Object to store database info.
    """

    def __init__(self, db_name, db_server, target_db_name, db_type, db_conf_id="",
                 db_port="", customer_id="", db_domain=None, db_user=None, db_password=None):
        MsSqlDbConnConf.__init__(self, db_name=db_name,
                                 db_server=db_server,
                                 db_domain=db_domain,
                                 db_port=db_port,
                                 db_user=db_user,
                                 db_password=db_password)
        self.target_db_name = target_db_name
        self.db_type = db_type
        self.db_conf_id = db_conf_id
        self.customer_id = customer_id

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