USE superbill_shared

DECLARE @DatabaseServerName varchar(128)
DECLARE @DatabaseName VARCHAR(50)
DECLARE @sql nvarchar(max)

IF OBJECT_ID('tempdb..#uidx') IS NOT NULL DROP TABLE #uidx

CREATE TABLE #uidx (
	database_name VARCHAR(255),
	table_name VARCHAR(4000),
	index_name VARCHAR(4000),
	index_id INT,
	total_writes INT,
	total_reads INT,
	user_seeks INT,
    user_scans INT,
    user_lookups INT,
	difference INT,
	space_used_kb INT
)
	
DECLARE db_server_cursor CURSOR
READ_ONLY
FOR			SELECT DISTINCT '['+C.DatabaseServerName+']', C.DatabaseName
			FROM dbo.Customer C
			WHERE DBActive = 1
	
OPEN db_server_cursor
	
FETCH NEXT FROM db_server_cursor INTO @DatabaseServerName, @DatabaseName
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
	
		IF @DatabaseServerName LIKE '%' + @@servername + '%'
		BEGIN
			SET @DatabaseServerName = '[SharedServer]'
		END
		
		print @DatabaseServerName + ', ' + @DatabaseName
		
		--http://sql.richarddouglas.co.uk/archive/2010/09/t-sql-tuesday-10-unused-indexes-indices.html
		SET @SQL = '
INSERT INTO #uidx
SELECT * FROM OPENQUERY(' + @DatabaseServerName + ','' 
SELECT
	''''' + @DatabaseName + ''''' database_name,
	OBJECT_NAME(s.[object_id], DB_ID(''''' + @DatabaseName + ''''')) AS table_name,
	i.name AS index_name,
	i.index_id,
    user_updates AS total_writes,
    user_seeks + user_scans + user_lookups AS total_reads,
    user_seeks,
    user_scans,
    user_lookups,
    user_updates - (user_seeks + user_scans + user_lookups) AS [difference],
	ISNULL((select 8192 * SUM(a.used_pages - CASE WHEN a.type <> 1 THEN a.used_pages WHEN p.index_id < 2 THEN a.data_pages ELSE 0 END)
		FROM ' + @DatabaseName + '.sys.partitions as p
		JOIN ' + @DatabaseName + '.sys.allocation_units as a ON a.container_id = p.partition_id
		WHERE p.object_id = i.object_id
		AND p.index_id = i.index_id)/1024
	,0.0) AS space_used_kb
FROM sys.dm_db_index_usage_stats AS s WITH (NOLOCK)
INNER JOIN ' + @DatabaseName + '.sys.indexes AS i WITH (NOLOCK)
	ON s.[object_id] = i.[object_id] AND i.index_id = s.index_id
INNER JOIN ' + @DatabaseName + '.sys.objects AS o WITH (NOLOCK)
	ON s.[object_id] = o.[object_id]
WHERE o.type = ''''U'''' --OBJECTPROPERTY(s.[object_id],''''IsUserTable'''') = 1
	AND s.database_id = DB_ID(''''' + @DatabaseName + ''''')
	--AND user_updates > (user_seeks + user_scans + user_lookups)
	AND i.index_id > 1
	--AND user_seeks + user_scans + user_lookups < 100
	--AND Last_User_Update BETWEEN @LastWeek AND @Today
	AND Is_Primary_Key = 0
	AND IS_Unique = 0
ORDER BY [difference] DESC, total_reads ASC, total_writes DESC;'')'
		

		EXEC sp_executesql @sql

	END

	FETCH NEXT FROM db_server_cursor INTO @DatabaseServerName, @DatabaseName
END

CLOSE db_server_cursor
DEALLOCATE db_server_cursor

/*
select database_name, sum(space_used_kb) from #uidx
group by database_name
order by sum(space_used_kb) 
*/

/*
select * from #uidx
where database_name in ('superbill_1266_prod',
	'superbill_2379_prod',
	'superbill_1575_prod',
	'superbill_0122_prod',
	'superbill_0644_prod',
	'superbill_0801_prod',
	'superbill_1012_prod')
	
order by index_name 

*/

SELECT index_name, SUM(total_writes) AS writes, SUM(total_reads) AS reads 
FROM #uidx
GROUP BY index_name
ORDER BY index_name

/*
Find all indexes with less than @reads
_limit aggregate reads

DECLARE @reads_limit INT
SET @reads_limit = 30000

SELECT index_name, SUM(space_used_kb)/1024 AS MB, SUM(total_writes) AS Writes, SUM(total_reads) AS Reads
FROM #uidx
GROUP BY index_name
HAVING SUM(total_reads) < @reads_limit
ORDER BY writes desc
*/

/*
Group by name, order by : (total # with zero reads / total #)

SELECT index_name, (SUM(CASE WHEN total_reads = 0 THEN 0 ELSE 1 END) / CONVERT(FLOAT, COUNT(1))) * 100 AS HasReadPct
FROM #uidx
GROUP BY index_name
ORDER BY (SUM(CASE WHEN total_reads = 0 THEN 0 ELSE 1 END) / CONVERT(FLOAT, COUNT(1)))
--ORDER BY index_name


*/

/*
SELECT * FROM #uidx
WHERE index_name = 'IX_ClaimAccounting_EncounterProcedureID'
ORDER BY user_scans desc
*/
