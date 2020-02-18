declare @dataFile varchar(max),
	@eSQL varchar(max)

SET @eSQL = 'backup log {dbName} with truncate_only'
SET @eSQL= replace( @eSQL, '{dbName}', db_Name())

exec( @eSQL )


select @dataFile = Name from sys.database_files where type_desc = 'LOG'
DBCC SHRINKFILE ( @dataFile )





