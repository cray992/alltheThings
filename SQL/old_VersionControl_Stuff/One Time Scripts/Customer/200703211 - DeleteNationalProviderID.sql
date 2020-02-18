


create TABLE #DB ( rowid int identity(1,1),  DatabaseServerName varchar(max), DatabaseName varchar(max) )

Insert INTO #DB(  DatabaseServerName, DatabaseName )
select DatabaseServerName, DatabaseName
from Customer
where DatabaseName IS NOT NULL
order by DatabaseServerName, DatabaseName

--insert into #DB( DatabaseServerName, DatabaseName )
--select 'kprod-db06', 'CustomerModel'
--union all
--select 'kprod-db06', 'CustomerModelPrepopulated'


Declare @sql_step01 varchar(max),
	@sql_DatabaseName varchar(max),
	@sql_DatabaseServerName varchar(max),
	@sql_Deleted varchar(max),
	@sql_exec varchar(max),
	@rowid INT,
	@return INT


SET @sql_DatabaseName = ''
SET @sql_DatabaseServerName = ''
SET @rowID = 0
SET @sql_step01 = 
		'
		SET nocount ON
		if exists( select * from [{1}].Master.sys.databases where name = ''{2}'' AND state_desc = ''ONLINE'')
		BEGIN
		
			begin try
				delete [{1}].{2}.dbo.ProviderNumberType
				where ProviderNumberTypeID =  8

				print ''deleted from {1}, {2}''
			end try
			begin catch
				Update [{1}].{2}.dbo.ProviderNumberType
				SET TypeName = ''Legacy number for printing''
				WHERE ProviderNumberTypeID = 8
				
				print ''updated {1}, {2}''
			end catch
		END'


-- Removes offline or missing DBs
WHILE 1=1
BEGIN

	SELECT @sql_DatabaseServerName = min(DatabaseServerName)
	FROM #DB
	WHERE DatabaseServerName > @sql_DatabaseServerName


	if @sql_DatabaseServerName IS NULL or @@rowcount = 0
		break

	SET @sql_exec = 'DELETE #DB
					WHERE DatabaseName NOT IN (select Name from [' + @sql_DatabaseServerName + '].master.sys.databases WHERE state_desc = ''ONLINE'')
						AND DatabaseServerName = ''' + @sql_DatabaseServerName + ''''

	exec( @sql_exec )

END


while 1=1
BEGIN

print @rowid

		select	@rowid = min(rowid)
		FROM #DB
		WHERE rowid > @rowid 

		if @rowid IS NULL or @@rowcount = 0
			break

		select	@sql_DatabaseServerName = DatabaseServerName,
				@sql_DatabaseName = DatabaseName
		FROM #DB
		WHERE @rowid = rowid
		
		IF @sql_Deleted IS NULL
			BEGIN
				SET @sql_exec = @sql_step01
				SET @sql_exec = replace(@sql_exec, '{1}', @sql_DatabaseServerName)
				SET @sql_exec = replace(@sql_exec, '{2}', @sql_DatabaseName)

				-- print @sql_exec
				exec (@sql_exec)
			END

		

END

-- select * from #DB
drop table #DB