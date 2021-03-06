DECLARE @DatabaseServerName varchar(128)
DECLARE @sql nvarchar(max)

IF OBJECT_ID('tempdb..#midx') IS NOT NULL DROP TABLE #midx

CREATE TABLE #midx (
	database_server VARCHAR(255),
	database_name VARCHAR(255),
	table_name VARCHAR(4000),
	improvement_measure DECIMAL(28,1),
	equality_columns NVARCHAR(4000),
	inequality_columns NVARCHAR(4000),
	included_columns NVARCHAR(4000),
	unique_compiles INT,
	user_seeks INT,
	user_scans INT,
	avg_total_user_cost FLOAT,
	avg_user_impact FLOAT
)
	
DECLARE db_server_cursor CURSOR
READ_ONLY
FOR 	SELECT DISTINCT '['+C.DatabaseServerName+']'
		FROM dbo.Customer C
		WHERE DBActive = 1
	
OPEN db_server_cursor
	
FETCH NEXT FROM db_server_cursor INTO @DatabaseServerName
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
	
		IF @DatabaseServerName LIKE '%' + @@servername + '%'
		BEGIN
			SET @DatabaseServerName = '[SharedServer]'
		END
		
		-- http://sqlserverpedia.com/blog/sql-server-bloggers/updated-missing-index-dmv-script/
		SET @sql = '
INSERT INTO #midx
SELECT * FROM OPENQUERY(' + @DatabaseServerName + ','' 
WITH misind (equality_columns, inequality_columns, included_columns, unique_compiles,
	user_seeks, user_scans, avg_total_user_cost, avg_user_impact, improvement_measure, 
	database_name, table_name)
AS
(
	SELECT --TOP 20 
		mid.equality_columns,
		mid.inequality_columns,
		mid.included_columns,
		migs.unique_compiles,
		migs.user_seeks,
		migs.user_scans,
		migs.avg_total_user_cost,
		migs.avg_user_impact,
		CONVERT (decimal (28,1), migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans)) AS improvement_measure,
		--mid.database_id,
		DB_NAME(mid.database_id) as [database_name],
		object_name(mid.object_id,mid.database_id) as [table_name]
					
	FROM sys.dm_db_missing_index_groups mig
		INNER JOIN sys.dm_db_missing_index_group_stats migs
			ON migs.group_handle = mig.index_group_handle
		INNER JOIN sys.dm_db_missing_index_details mid
			ON mig.index_handle = mid.index_handle
	WHERE CONVERT (decimal (28,1), migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans)) > 1000
		AND last_user_seek>DATEADD(wk,-1,GETDATE())
	--	ORDER BY migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) DESC
)
SELECT
	''''' + CASE WHEN @DatabaseServerName = '[SharedServer]' THEN '[' + LOWER(@@servername) + ']' ELSE @DatabaseServerName END + ''''',
	database_name,
	table_name,
	improvement_measure,
	equality_columns,
	inequality_columns,
	included_columns,
	unique_compiles,
	user_seeks,
	user_scans,
	avg_total_user_cost,
	avg_user_impact
FROM misind
ORDER BY table_name, equality_columns
'')'

		EXEC sp_executesql @sql


	END

	FETCH NEXT FROM db_server_cursor INTO @DatabaseServerName
END

CLOSE db_server_cursor
DEALLOCATE db_server_cursor

select * from #midx
--order by table_name, equality_columns
order by improvement_measure desc

--select * from #midx where database_name = 'msdb'