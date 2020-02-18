class IngestionJobStatus:
    CREATED = 1
    STARTED = 2
    FAIL = 3
    SUCCESS = 4
    STALE = 5
    NO_CHANGE = 6

    def __init__(self):
        pass
