from abc import ABCMeta


class LoggingUtils:
    """
        Helper class for preparing query column lists
        """

    __metaclass__ = ABCMeta

    @staticmethod
    def elapsed_time(start, end):
        """
        :type start:
        :type end:
        :rtype:
        """
        hours, rem = divmod(end - start, 3600)
        minutes, seconds = divmod(rem, 60)
        if hours > 0:
            return "%2dhrs %2dmin %2dsec" % (hours, minutes, seconds)
        elif minutes > 0:
            return "%2dmin %2dsec" % (minutes, seconds)
        else:
            return "%2dsec" % seconds
