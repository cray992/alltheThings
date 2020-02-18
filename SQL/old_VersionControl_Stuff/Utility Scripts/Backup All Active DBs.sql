DECLARE @Loop INT
DECLARE @Count INT

CREATE TABLE #DBs(DBID INT IDENTITY(1,1), DatabaseName VARCHAR(128))
INSERT INTO #DBs(DatabaseName)
SELECT DatabaseName
FROM Customer
WHERE DBActive=1
UNION
SELECT 'CustomerModel'
UNION
SELECT 'CustomerModelPrepopulated'
UNION
SELECT 'superbill_shared'

SET @Loop=@@ROWCOUNT
SET @Count=0

DECLARE @DB VARCHAR(128)
DECLARE @BackupPath VARCHAR(500)
DECLARE @SQL VARCHAR(8000)
DECLARE @ESQL VARCHAR(8000)

SET @BackupPath='D:\migration_backups'

SET @SQL='
BACKUP DATABASE {1}
TO DISK=N''{0}\{1}.bak''
WITH INIT,  NAME=N''{1} backup'',
SKIP, STATS=10, NOFORMAT, copy_only'

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1
	
	SELECT @DB=DatabaseName
	FROM #DBs
	WHERE DBID=@Count

	SET @ESQL=REPLACE(@SQL,'{0}',@BackupPath)
	SET @ESQL=REPLACE(@ESQL,'{1}',@DB)

	EXEC(@ESQL)
END

DROP TABLE #DBs