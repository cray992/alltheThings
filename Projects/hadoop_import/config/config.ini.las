[GLOBAL]
environment=LAS
is_debug_enabled=false
failure_report_recipients = squaddata@kareo.com
report_failure_limit = 1000

[DEBUG]
; List of customer IDs to process in debug mode
customer_ids=

[SMTP]
smtp_server=las-smtp.kareoprod.ent

[ETL]
mapreduce_reducers=1
mapreduce_memory=4096
spark_executors=10
spark_executor_memory=20g
spark_driver_memory=10g

[INGESTION]
num_workers = 5
batch_size = 10
num_buckets = 20
max_retries = 4

[SPARK]
; deploy_mode: Sets Spark job deployment mode
; Options: client or cluster
; In cluster mode, the spark driver runs inside a container in the spark cluster
; In client mode, the spark driver runs in local process in the client machine.
; This is particularly useful in cases that the spark driver does not perform any processing such as computing totals
; from partial results computed by workers. For example ingestion jobs that only involve read/write operations.
deploy_mode = cluster

; spark_major_version: It switches Spark SDK (PySpark) version for any job that is sent to the Spark cluster
; Value options: 1 or 2
; Both version 1 and 2 are available in our HortonWorks Data Platform (HDP)
spark_major_version=2

[DB:MSSQL]
db_server=NOT_REQUIRED
db_port=NOT_REQUIRED
db_user = kareoprod\p-hadoop-user
db_password = dpJsTdj$ar1r
db_domain=kareoprod.ent
max_retries = 3

[DB:HIVE]
db_server = las-pdx-hmas-01.kareoprod.ent
db_metastore = las-pdx-hmas-02.kareoprod.ent
db_port   = 10500
db_user   = p-jams-svc
db_password =

[DB:HIVE:ETL]
; Settings for DB storing results of ETLs
db_name = etl

[DB:MSSQL:SUBSCRIPTIONS]
; Settings for DB containing customer and product subscription data
db_server = las-pdw-shr01.kareoprod.ent
db_port = 4801
db_name = superbill_shared

[DB:MSSQL:APPLICATION_METADATA]
; Settings for DB containing metadata and config for hadoop-import and qlik-import
db_server = las-pdw-com03.kareoprod.ent
db_port = 4903
db_name = ReportingLog

[DB:MSSQL:CHANGE_TRACKING]
; Settings for DB containing metadata and sproc for enabling Change Tracking
db_server = las-pdw-com03.kareoprod.ent
db_port = 4903
db_name = ReportingLog


; TODO: Remove these configs when deprecating the old DbManager
; All these configs are used by the old DbManager ot be deprecated

[HIVE]
hive_buckets = 20

[DB_COMMON]
mssql_user = kareoprod\p-hadoop-user
mssql_passwd = dpJsTdj$ar1r
mssql_db_server_domain=kareoprod.ent
hive_server = las-pdx-hmas-01.kareoprod.ent
hive_metastore = las-pdx-hmas-01.kareoprod.ent
hive_port   = 10000
hive_user   = p-jams-svc
hive_passwd =

[DBCONN:mssql:shared]
server = las-pdw-shr01.kareoprod.ent
port = 4801
db_name = superbill_shared

[DBCONN:mssql:enterprise_reports]
server = las-pdw-com03.kareoprod.ent
port = 4903
db_name = ReportingLog

[DBCONN:hive:hive_global]
db_name = customer

[DBCONN:hive:hive_etl]
db_name = etl

[DBCONN:hive:hive_shared]
db_name = shared

