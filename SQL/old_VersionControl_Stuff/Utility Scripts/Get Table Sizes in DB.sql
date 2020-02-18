
CREATE TABLE #Results(name varchar(256), rows int, reserved varchar(100), data varchar(100), index_size varchar(100), unused varchar(100), MBSize INT, GBSize INT)

DECLARE @Loop INT
DECLARE @Count INT

DECLARE @Objs TABLE(OID INT IDENTITY(1,1), name sysname)
INSERT @Objs(name)
SELECT name
FROM sysobjects
WHERE xtype='U'

SET @Loop=@@ROWCOUNT
SET @Count=0

DECLARE @SQL VARCHAR(8000)
DECLARE @ESQL VARCHAR(8000)
DECLARE @CurrentObj VARCHAR(256)

SET @SQL='
INSERT INTO #Results(name, rows, reserved, data, index_size, unused)
exec sp_spaceused {0}'

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1

	SELECT @CurrentObj=name
	FROM @Objs
	WHERE OID=@Count

	SET @ESQL=REPLACE(@SQL,'{0}',@CurrentObj)

	EXEC(@ESQL)
END

UPDATE #Results SET MBSize=CAST(LEFT(data,CHARINDEX(' ',data)-1) AS INT)/1024
UPDATE #Results SET GBSize=CAST(LEFT(data,CHARINDEX(' ',data)-1) AS INT)/1024/1024

SELECT * FROM #Results
ORDER BY MBSize DESC

SELECT SUM(CAST(LEFT(data,CHARINDEX(' ',data)-1) AS INT)/1024/1024) AS TotalSize
FROM #Results

DROP TABLE #Results