IF EXISTS (
	select * from Information_SCHEMA.COLUMNS
	where Table_Schema = 'dbo'
	and Table_name='Partner' 
	and column_name='AllowEInvoice')
BEGIN
	ALTER TABLE dbo.Partner DROP CONSTRAINT [DF_Partner_AllowEInvoice]
		
	ALTER TABLE dbo.Partner
	DROP COLUMN AllowEInvoice
END

IF EXISTS (
	select * from Information_SCHEMA.COLUMNS
	where Table_Schema = 'dbo'
	and Table_name='Partner' 
	and column_name='QuickBooksIdentifier')
BEGIN
	ALTER TABLE dbo.Partner
	DROP COLUMN QuickBooksIdentifier
END