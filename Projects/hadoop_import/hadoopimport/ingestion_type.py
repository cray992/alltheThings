class IngestionType:
    NONE = 0
    INCREMENTAL = 1
    FULL = 2

    def __init__(self):
        pass

    @staticmethod
    def get_ingestion_type(ingestion_type_name):
        return {
            "none": IngestionType.NONE,
            "incremental": IngestionType.INCREMENTAL,
            "full": IngestionType.FULL
        }[ingestion_type_name]

    @staticmethod
    def get_ingestion_type_name(ingestion_type):
        return {
            IngestionType.NONE: "none",
            IngestionType.INCREMENTAL: "incremental",
            IngestionType.FULL: "full"
        }[ingestion_type]


