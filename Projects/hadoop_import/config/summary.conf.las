[GLOBAL]
report_recipients = squaddata@kareo.com, Sam.Santella@kareo.com, James.Buac@kareo.com

[Stage:Import Customer DB]
report_distinct_customers = true
distinct_customers_column = partitioncustomerid
distinct_customers_table = doctor_staging
db_name = global
tables =
    doctor_staging
    claimtransaction_staging
    paymentclaim_staging
# TODO: incremental ingestion cleanup
; Backwards compatibility for old flow
db_conn_name = hive_global

[Stage:Import Specified Customer DB]
report_distinct_customers = true
distinct_customers_column = partitioncustomerid
distinct_customers_table = doctor_staging
db_name = customer_kmb
tables =
    doctor_staging
    claimtransaction_staging
    paymentclaim_staging
db_conn_name = hive_global

[Stage:Import Shared DB]
report_distinct_customers = false
db_name = shared
tables =
    customer_staging
    clearinghousepayerslist_staging
    clearinghouse_staging
# TODO: incremental ingestion cleanup
; Backwards compatibility for old flow
db_conn_name = hive_shared

[Stage:ETL Adjustments]
report_distinct_customers = true
distinct_customers_column = partitioncustomerid
distinct_customers_table = adjustments_all
db_name = etl
tables =
    adjustments_all
# TODO: incremental ingestion cleanup
; Backwards compatibility for old flow
db_conn_name = hive_etl

[Stage:ETL AR]
report_distinct_customers = true
distinct_customers_column = partitioncustomerid
distinct_customers_table = arsummary_all
db_name = etl
tables =
    arsummary_all
# TODO: incremental ingestion cleanup
; Backwards compatibility for old flow
db_conn_name = hive_etl

[Stage:ETL Payment Claim EOB]
report_distinct_customers = true
distinct_customers_column = partitioncustomerid
distinct_customers_table = paymentclaimeob_all
db_name = etl
tables =
    paymentclaimeob_all
# TODO: incremental ingestion cleanup
; Backwards compatibility for old flow
db_conn_name = hive_etl

[Stage:ETL Charges]
report_distinct_customers = true
distinct_customers_column = partitioncustomerid
distinct_customers_table = chargesdetail_all
db_name = etl
tables =
    chargesdetail_all
# TODO: incremental ingestion cleanup
; Backwards compatibility for old flow
db_conn_name = hive_etl
