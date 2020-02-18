CREATE TABLE #TableData(Name VARCHAR(128), Rows INT, Reserved VARCHAR(128), Data VARCHAR(128), Index_Size VARCHAR(128), Unused VARCHAR(128))

DECLARE @SQL VARCHAR(4000)
DECLARE @EXSQL VARCHAR(4000)
SET @SQL='
INSERT INTO #TableData(Name, Rows, Reserved, Data, Index_Size, Unused)
exec sp_spaceused [{0}]'

DECLARE @COUNT INT
DECLARE @LOOP INT

DECLARE @Tables TABLE(TID INT IDENTITY(1,1), Name VARCHAR(128))
INSERT @Tables(Name)
SELECT Name
FROM sys.objects
WHERE type='U'

SET @LOOP=@@ROWCOUNT
SET @COUNT=0

DECLARE @TableName VARCHAR(128)

WHILE @COUNT<@LOOP
BEGIN
	SET @COUNT=@COUNT+1

	SELECT @TableName=Name
	FROM @Tables
	WHERE TID=@COUNT

	SET @EXSQL=REPLACE(@SQL,'{0}',@TableName)
	EXEC(@EXSQL)
END

SELECT Name, Rows, CAST(REPLACE(Reserved,' KB','') AS REAL)/1024.00 Reserved,
CAST(REPLACE(Data,' KB','') AS REAL)/1024.00 Data, CAST(REPLACE(Index_Size,' KB','') AS REAL)/1024.00 Index_Size
FROM #TableData
ORDER BY Name

DROP TABLE #TableData