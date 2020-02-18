class IngestionJobType:
    INCREMENTAL = 1
    FULL = 2
    MERGE = 3
    CLEANUP = 4
    PERSIST = 5

    def __init__(self):
        pass

    @staticmethod
    def get_ingestion_job_type(ingestion_job_type_name):
        return {
            "incremental": IngestionJobType.INCREMENTAL,
            "full": IngestionJobType.FULL,
            "merge": IngestionJobType.MERGE,
            "cleanup": IngestionJobType.CLEANUP,
            "persist": IngestionJobType.PERSIST
        }[ingestion_job_type_name]

    @staticmethod
    def get_ingestion_job_type_name(ingestion_job_type):
        return {
            IngestionJobType.INCREMENTAL: "incremental",
            IngestionJobType.FULL: "full",
            IngestionJobType.MERGE: "merge",
            IngestionJobType.CLEANUP: "cleanup",
            IngestionJobType.PERSIST: "persist"
        }[ingestion_job_type]
