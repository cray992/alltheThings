
	select 
		rowID = identity(int, 1, 1),
		Name
	INTO #DBtoMove
	from sys.databases
	where Name NOT IN (
		'master', 
		'tempdb',
		'model',
		'msdb'
		)
	AND state_desc = 'ONLINE'



	declare @DatabaseServerName varchar(50)
	declare @DatabaseName varchar(128)
	declare @rowID INT
	DECLARE @SQL VARCHAR(8000)
	DECLARE @EXSQL VARCHAR(8000)
	SET @DatabaseServerName = ISNULL(@DatabaseServerName, '[kprod-db06]')



	CREATE TABLE #Files(DatabaseName varchar(128), Type CHAR(1), Name VARCHAR(128))


	select @rowID = 0

	WHILE 1=1
	BEGIN
		select @rowID = min( rowID ) 
		FROM #DBtoMove
		WHERE rowID > @rowID

		if @@rowcount = 0 OR @rowID IS NULL
			break
		
		select @DatabaseName = Name FROM #DBtoMove where rowID = @rowID

		SET @SQL='INSERT INTO #Files(DatabaseName, Type, Name) SELECT ''{0}'', CASE WHEN Type=0 THEN ''D'' ELSE ''L'' END Type, physical_name
				  FROM {0}.sys.database_files'

		SET @EXSQL=REPLACE(@SQL,'{0}',@DatabaseName)

		EXEC(@EXSQL)
	END

delete [kprod-db04].KareoMaintenance.dbo.DBToAttach

insert into [kprod-db04].KareoMaintenance.dbo.DBToAttach(  [DatabaseName], [Type], [Name] )
select [DatabaseName], [Type], [Name]
from #Files



drop table #DBtoMove, #Files
