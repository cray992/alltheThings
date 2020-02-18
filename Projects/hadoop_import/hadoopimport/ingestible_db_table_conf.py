from ingestible_db_conf import IngestibleDbConf

class IngestibleDbTableConf(IngestibleDbConf):
    """
    Object to store table and db level info.
    """

    def __init__(self, db_name, db_server, target_db_name, db_type, table_name="", db_conf_id="", db_port="",
                 customer_id="", db_domain=None, db_user=None, db_password=None):
        IngestibleDbConf.__init__(self, db_name=db_name,
                                  db_server=db_server,
                                  db_type=db_type,
                                  db_conf_id=db_conf_id,
                                  customer_id=customer_id,
                                  target_db_name=target_db_name,
                                  db_domain=db_domain,
                                  db_port=db_port,
                                  db_user=db_user,
                                  db_password=db_password)
        self.table_name = table_name

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

    def serialize(self):
        """
        :rtype: str
        """
        return "|".join(
            [str(self.db_conf_id), self.db_name, self.db_server, self.target_db_name, str(self.db_type),
             self.table_name,
             str(self.db_port), str(self.customer_id)])

    @staticmethod
    def deserialize(string_rep):
        """
        :param string_rep: str
        :return: IngestibleDbTableConf
        """
        (db_conf_id, db_name, db_server, target_db_name, db_type, table_name, db_port,
         customer_id) = string_rep.strip().split('|')
        return IngestibleDbTableConf(db_name, db_server, target_db_name, int(db_type), table_name=table_name,
                                     db_conf_id=db_conf_id, db_port=db_port, customer_id=customer_id)
