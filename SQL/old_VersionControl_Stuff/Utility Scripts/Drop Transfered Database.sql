

select identity(int, 1, 1) as rowID,
	'[' + d.Name + ']'  as DatabaseName
INTO #DropDB
FROM sys.databases d
	INNER JOIN migrationx.dbo.TransferDatabase t ON t.DatabaseName = d.Name
	INNER JOIN [kprod-db04].master.sys.databases k4 ON k4.name = d.Name
where d.state_desc = 'offline'



declare @i INT,
	@sql varchar(500),
	@DBName varchar(500)


SET @i = 0
SET @sql = 'DROP DATABASE '


while 1=1
BEGIN
	SELECT @i = min(rowID)
	FROM #DropDB
	WHERE rowID >@i

	IF @@rowcount = 0 OR @i IS NULL
		break

	SELECT @DBName = DatabaseName
	FROM #DropDB Where rowID = @i

	-- print @sql + @DBName
	exec (@sql + @DBName)

END