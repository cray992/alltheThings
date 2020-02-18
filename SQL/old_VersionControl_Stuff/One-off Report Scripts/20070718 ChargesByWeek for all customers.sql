



create TABLE #DB ( rowid int identity(1,1),  DatabaseServerName varchar(max), DatabaseName varchar(max) )

Insert INTO #DB(  DatabaseServerName, DatabaseName )
select DatabaseServerName, DatabaseName
from Customer
where DatabaseName IS NOT NULL
AND DBActive = 1
AND CustomerType = 'N'
order by DatabaseServerName, DatabaseName



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

create table #Temp ( rowID INT, PracticeID INT, PracticeName varchar(max), PracticeActive INT, PostingWeek INT, PostWeekDate datetime, Amount MONEY )
SET @sql_step01 = 
		'
		SET nocount ON

			INSERT INTO #Temp ( rowID, PracticeID, PracticeName, PracticeActive, PostingWeek, Amount  )

			select {3}, p.PracticeID, p.Name, p.Active, datepart(ww, postingDate), sum(Amount) Amount
			from [{1}].{2}.dbo.ClaimAccounting ca (nolock)
				INNER JOIN [{1}].{2}.dbo.Practice P (nolock) on p.PracticeID = ca.PracticeID
			where ClaimTransactionTypeCode = ''CST''
				AND PostingDate between ''1/1/2007'' AND ''6/16/07''
			GROUP BY p.PracticeID, p.Name, p.Active, datepart(ww, postingDate)
		'


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
				SET @sql_exec = replace(@sql_exec, '{3}', @rowid)

				print @sql_exec

								
				exec (@sql_exec)
			END

		

END


-- Figures out the date of the end of hte week


declare @Date datetime, @FirstDayOfYear datetime, @LastDayOfFirstWeekOfYear datetime
select @Date = '1/14/07', @FirstDayOfYear = '1/1/2007'
select @LastDayOfFirstWeekOfYear = dateadd( d,7- datepart(dw, @FirstDayOfYear), @FirstDayOfYear)

update #Temp
SET PostWeekDate = dateadd(ww, PostingWeek-1, @LastDayOfFirstWeekOfYear)  


--
--select DatabaseName, practiceName, sum(Amount) 
--from #DB d
--	INNER JOIN #Temp t on d.rowID = t.rowID
--where practiceActive = 1
--group by DatabaseName, practiceName
--order by DatabaseName, PracticeName
--
--
--select DatabaseName, sum(Amount) 
--from #DB d
--	INNER JOIN #Temp t on d.rowID = t.rowID
--where practiceActive = 1
--group by DatabaseName
--order by DatabaseName

select c.CustomerID, c.CompanyName, t.* from #DB d
	INNER JOIN #Temp t on d.rowID = t.rowID
	INNER JOIN Customer c On c.DatabaseName = d.DatabaseName

-- drop table #DB, #temp
