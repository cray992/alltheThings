class IngestionGroup:
    KA = 1
    KMB = 2

    def __init__(self):
        pass

    @staticmethod
    def get_ingestion_group(ingestion_group_name):
        return {
            "kareo_analytics": IngestionGroup.KA,
            "kmb": IngestionGroup.KMB
        }[ingestion_group_name]

    @staticmethod
    def get_ingestion_group_name(ingestion_group):
        return {
            IngestionGroup.KA: "kareo_analytics",
            IngestionGroup.KMB: "kmb"
        }[ingestion_group]


