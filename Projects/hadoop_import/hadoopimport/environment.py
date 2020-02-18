class Environment:
    DR = "DR"
    PRODUCTION = "LAS"
    STAGE = "STG"
    DEVELOPMENT = "DEV"

    def __init__(self):
        pass

    @staticmethod
    def is_production_environment(environment):
        """

        :param environment: Environment string (short) value
        :type environment: str
        :rtype: bool
        """
        return environment not in [Environment.DEVELOPMENT, Environment.STAGE]