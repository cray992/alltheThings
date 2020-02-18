USE ReportingLog

UPDATE HDP_IngestibleDb SET TargetDbName='customer_kareo_analytics' WHERE TargetDbName='customer_ka'

UPDATE HDP_IngestibleDb SET TargetDbName='shared_kareo_analytics' WHERE TargetDbName='shared_ka'
