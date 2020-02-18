#!/usr/bin/env python
import pymssql
import pandas as pd
import datetime as dt
from sqlalchemy import create_engine
from ConfigParser import ConfigParser
import sys
import argparse
import atexit

"""
This file is for inserting table and column data into the HDP import
tables.  The tables have already been created and did not contain any
data.

1) establish connection to CustomerModel (_cm) and Shared (_shr)
2) get list of all tables in CustomerModel database
3) get list of 
4) insert table information into pandas dataframe for its data
manipulation abilities and nice bulk insert to sql property
5) query our new table and get tableIDs
6) query customermodel and extract columns for every table
7) join columns, tablenames, and tableids
8) insert column data into sql server
"""


parser = argparse.ArgumentParser(description='Populates table and column information for tables to import.')
parser.add_argument('type' , nargs='+', help='type of data population, ex: customerdb|shareddb|salesforcedb')
args = parser.parse_args()
dpType = args.type[0]
print("Populating data population type %s" % dpType)


# Load configuration data from config.ini
cfg = ConfigParser()
try:
    cfg.read('config.ini')
   
    customermodel_server = cfg.get('shared_database', 'server')
    customermodel_port = cfg.get('shared_database', 'port')
    customermodel_db = cfg.get('shared_database', 'db')
    superbill_server = cfg.get('superbill_database', 'server')
    superbill_port = cfg.get('superbill_database', 'port')
    superbill_db = cfg.get('superbill_database', 'db')
    salesforce_server = cfg.get('salesforce_database', 'server')
    salesforce_port = cfg.get('salesforce_database', 'port')
    salesforce_db = cfg.get('salesforce_database', 'db')
    logging_server = cfg.get('logging_database', 'server')
    logging_port = cfg.get('logging_database', 'port')
    logging_db = cfg.get('logging_database', 'db')

    db_user = cfg.get('global', 'username')
    db_user_domain = cfg.get('global', 'domain')
    db_pass = cfg.get('global', 'password')
    tds_version = cfg.get('global', 'tds_version')

except Exception as err:
    print("Error while loading configuration file")
    print(err)
    sys.exit(1)

# connection properties for CustomerModel tables
db_conn_cm = pymssql.connect(customermodel_server + ':' + customermodel_port, db_user_domain + '\\' + db_user, db_pass, customermodel_db, tds_version=tds_version)
db_cursor_cm = db_conn_cm.cursor(as_dict=True)

# connection properties for SuperbillShared tables
db_conn_shr = pymssql.connect(superbill_server+ ':' + superbill_port, db_user_domain + '\\' + db_user, db_pass, superbill_db, tds_version=tds_version)
db_cursor_shr = db_conn_shr.cursor(as_dict=True)

# connection properties for Salesforce tables
db_conn_sales = pymssql.connect(salesforce_server+ ':' + salesforce_port, db_user_domain + '\\' + db_user, db_pass, salesforce_db, tds_version=tds_version)
db_cursor_sales = db_conn_sales.cursor(as_dict=True)

# connection properties to logging database
db_conn_logging = pymssql.connect(logging_server+ ':' + logging_port, db_user_domain + '\\' + db_user, db_pass, logging_db, tds_version=tds_version) 
db_cursor_logging = db_conn_logging.cursor(as_dict=True)

engine_cm = create_engine('mssql+pymssql://' + db_user_domain +  '\\' + db_user + ':' + db_pass + '@' + customermodel_server + ':' + customermodel_port + '/' + customermodel_db)
engine_sales = create_engine('mssql+pymssql://' + db_user_domain +  '\\' + db_user + ':' + db_pass + '@' + salesforce_server + ':' + salesforce_port + '/' + salesforce_db)
engine_logging = create_engine('mssql+pymssql://' + db_user_domain +  '\\' + db_user + ':' + db_pass + '@' + logging_server + ':' + logging_port + '/' + logging_db)


def exit_handler():
    print 'application is ending!'
    db_cursor_cm.close()
    db_conn_cm.close()
    db_cursor_shr.close()
    db_conn_shr.close()
    db_cursor_sales.close()
    db_conn_sales.close()
    db_cursor_logging.close()
    db_conn_logging.close()
			
atexit.register(exit_handler)

# get list of tables we currently import
# then read it into a list
tables_to_import = []

def populate_shareddb():
	# extract all tables from the shared db
	db_cursor_shr.execute('select * from information_schema.tables')
	tables = db_cursor_shr.fetchall()
	tables_list = []

	for table in tables:
		tables_list.append(table['TABLE_NAME'].strip())


	with open('shared_tables.txt') as f:
		for line in f:
			tables_to_import.append(line.rstrip())

	df_tables = insert_table_meta_data(tables_list, tables_to_import, 2)
	insert_column_meta_data(tables, df_tables, db_cursor_shr)

def populate_salesforcedb():
	# extract all tables from the shared db
	db_cursor_sales.execute('select * from information_schema.tables')
	tables = db_cursor_sales.fetchall()
	tables_list = []

	for table in tables:
		tables_list.append(table['TABLE_NAME'].strip())


	with open('salesforce_tables.txt') as f:
		for line in f:
			tables_to_import.append(line.rstrip())

	df_tables = insert_table_meta_data(tables_list, tables_to_import, 3)
	insert_column_meta_data(tables, df_tables, db_cursor_sales)




def populate_customerdb():

	# extract all tables from the CustomerModel
	db_cursor_cm.execute('select * from information_schema.tables')
	tables = db_cursor_cm.fetchall()
	tables_list = []

	for table in tables:
		tables_list.append(table['TABLE_NAME'].strip())


	with open('tables.txt') as f:
		for line in f:
			tables_to_import.append(line.rstrip().lower())

	df_tables = insert_table_meta_data(tables_list, tables_to_import, 1)
	insert_column_meta_data(tables, df_tables, db_cursor_cm)

def insert_table_meta_data(tables_list, tables_to_import, sourceId):

	print("all tables %s " % tables_list)
	print("tables flag for importing %s " % tables_to_import)

	df_tables = pd.DataFrame(tables_list)

	df_tables.columns = ['TableName']
	df_tables['SourceID'] = sourceId

	# if the table name is in the tables_to_import list, then 1 else 0
	df_tables['ImportTypeID'] = df_tables.TableName.apply(lambda x: 1 if x.lower() in tables_to_import else 0)
	df_tables['Deleted'] = 0

	# create datetimes for our date columns
	cur_time = dt.datetime.today()
	df_tables['CreatedDate'] = cur_time
	df_tables['ModifiedDate'] = cur_time

	# inserting data to sql server via pandas and sqlalchemy
	df_tables.to_sql('HDP_TablesToImport', engine_logging, if_exists='append', index=False)

	# query the table we just inserted into so we can get their tableIDs
	query_tables_to_import = ("select TableID, TableName from HDP_TablesToImport where sourceID = %s" % sourceId)
	df_tables = pd.read_sql(query_tables_to_import, engine_logging)
	
	print("Done populating all tables metadata")
	return df_tables

# header row for the file
columns_for_df = [['TableName', 'ColumnName', 'ColumnType', 'ColumnLength'
        ,'ColumnPrecision', 'ColumnScale']]

data = []

def insert_column_meta_data(tables, df_tables, db_cursor):

	# iterate through tables and print out columns
	for num, table in enumerate(tables):
		print("Populating column metadata for table: %s" % table)
		query = """SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='%s'""" % (table['TABLE_NAME'].strip())
		db_cursor.execute(query)
		columns = db_cursor.fetchall()
		for col in columns:
			table_name = col['TABLE_NAME'].strip()
			column_name = col['COLUMN_NAME'].strip()
			column_type = col['DATA_TYPE']
			column_length = col['CHARACTER_MAXIMUM_LENGTH']
			precision = col['NUMERIC_PRECISION']
			scale = col['NUMERIC_SCALE']

			row = [table_name, column_name, column_type, column_length
			       ,precision, scale]

			data.append(row)

	df_columns = pd.DataFrame(data)
	df_columns.columns = columns_for_df
	df_columnsv2 = pd.merge(df_columns, df_tables, on='TableName', how='left')

	# create datetimes for our date columns
	cur_time = dt.datetime.today()
	df_columnsv2['CreatedDate'] = cur_time
	df_columnsv2['ModifiedDate'] = cur_time
	order_of_cols = ['ColumnName', 'TableID', 'ColumnType', 'ColumnLength'\
	,'ColumnPrecision', 'ColumnScale', 'CreatedDate', 'ModifiedDate']

	# df_columnsv2[order_of_cols].head()
	# inserting data to sql server via pandas and sqlalchemy
	df_columnsv2[order_of_cols].to_sql('HDP_ColumnsToImport', engine_logging\
		,if_exists='append', index=False)

if(dpType == 'customerdb'):
	populate_customerdb()	
elif (dpType == 'shareddb'):
	populate_shareddb()
elif (dpType == 'salesforcedb'):
	populate_salesforcedb()
else:
	print("Unsupported data population type %s " % dpType)
	sys.exit(1)



