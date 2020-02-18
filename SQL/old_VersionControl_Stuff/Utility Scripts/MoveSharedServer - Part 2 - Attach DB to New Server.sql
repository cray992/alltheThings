declare @New_DatabaseServerName varchar(128)
Declare @Old_DatabaseServerName varchar(128)

SET @New_DatabaseServerName
SET @Old_DatabaseServerName



CREATE TABLE #Files(DatabaseName varchar(128), Type CHAR(1), Name VARCHAR(128))

insert into #Files( [DatabaseName], [Type], [Name] )
select [DatabaseName], [Type], [Name]
FROM [kprod-db04].KareoMaintenance.dbo.DBToAttach
WHERE [DatabaseName] NOT IN (select name from sys.databases )

DECLARE @Logical_Data VARCHAR(128)
DECLARE @Logical_Log VARCHAR(128)
declare @DatabaseName varchar(128)
DECLARE @SQL VARCHAR(8000)
DECLARE @EXSQL VARCHAR(8000)

SET @DatabaseName = ''
SET @SQL = 'CREATE DATABASE {2}
		ON (FILENAME = ''{0}''),
		(FILENAME = ''{1}'')
		FOR ATTACH'

WHILE 1=1
BEGIN
	
	SELECT @DatabaseName = min( DatabaseName )
	FROM #Files
	WHERE DatabaseName > @DatabaseName

	IF @@rowcount = 0 OR @DatabaseName IS NULL
		BREAK


	select @Logical_Data = Name
	from #Files
	where Type = 'D' AND DatabaseName = @DatabaseName


	select @Logical_Log = Name
	from #Files
	where Type = 'L' AND DatabaseName = @DatabaseName


	SET @EXSQL = @SQL
	
	SET @EXSQL=REPLACE(@EXSQL,'{2}',@DatabaseName)
	SET @EXSQL=REPLACE(@EXSQL,'{1}',@Logical_Log)
	SET @EXSQL=REPLACE(@EXSQL,'{0}',@Logical_Data)

	exec (@EXSQL)
	-- print @EXSQL

END


Update sharedserver.superbill_shared.dbo.Customer
SET DatabaseServerName = @New_DatabaseServerName
WHere DatabaseServerName = @Old_DatabaseServerName

Update sharedserver.superbill_shared.dbo.SharedSystemPropertiesAndValues
SET  [value] = @New_DatabaseServerName
where propertyName = 'DefaultNewCustomer_DBServerName'

drop table #Files