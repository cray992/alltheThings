# Hadoop Data Import (POC) #

## Debug ##
Use the customer_ids debug config for importing specific customers. The value is a comma sepparated list of ids.

## How To Run Hadoop Import ##
Step 1 : Copy config.ini into hadoopimport
Step 2 : Change Database names - hive_global, hive_etl, hive_shared, hive_salesforce
Step 3 : Copy Loggin Conf file (logging.conf.stg) into hadoopimport
Step 4 : Run work flow

## Work Flow ##

### Backup ###
bin/backup_hive_db.py all;

### Set Up Hive Tables ###
bin/setup_hive_db.py customer;
bin/setup_hive_db.py etl;
bin/setup_hive_db.py shared;

### Import Data ###
bin/import_db.py shared;
bin/import_db.py kareo_analytics;

### Run ETLS ###
bin/run_etl.py spark etl/hive/adjustments_etl.hive
bin/run_etl.py spark etl/hive/claimlifecycle_etl.hive;
bin/run_etl.py spark etl/hive/ar_etl.hive;
bin/run_etl.py pig etl/pig/payment_claim_eob_etl.pig;
bin/run_etl.py spark etl/hive/charges_etl.hive;

### Reload and Synch Customers in Qlik ###
source $HOME/miniconda/bin/activate qlik;
bin/sync_customer_apps.py "<<AppName>>";

source $HOME/miniconda/bin/activate qlik;
bin/reload_customer_apps.py "<<AppName>>";

### Run Ingestion Report ###
bin/run_ingestion_report.py;

## Move to Cluster for Testing ##

scp -r . <user.name>@sna-sgx-hdat-01.kareoprod.ent:/home/kareoprod.ent/<user.name>/hadoop-import

## Running in Cluster for Testing ##
Step 0.
a. ssh <user.name>@sna-sgx-hdat-01.kareoprod.ent
b. cd hadoop-import
c. PYTHONPATH=. bin/<command_file>.py


## Debugging Hive ##
In order to check if a query works without running it type into hive shell:
explain {HIVE STATEMENT}  


