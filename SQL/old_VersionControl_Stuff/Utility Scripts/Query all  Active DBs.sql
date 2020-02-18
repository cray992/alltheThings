DECLARE @Loop INT
DECLARE @Count INT

CREATE TABLE #DBS(DBID INT IDENTITY(1,1), DatabaseName VARCHAR(50), Exsts BIT)
INSERT INTO #DBS(DatabaseName, Exsts)
SELECT DatabaseName, 0
FROM Customer
WHERE DBActive=1

SET @Loop=@@ROWCOUNT
SET @Count=0

DECLARE @SQL VARCHAR(8000)
DECLARE @ESQL VARCHAR(8000)
SET @SQL='IF EXISTS(SELECT * FROM {0}..sysobjects WHERE xtype=''TR'' AND name=''tr_IU_Patient_ChangeTime'')
BEGIN
	UPDATE #DBS SET Exsts=1
	WHERE DatabaseName=''{0}''
END
'

DECLARE @DB VARCHAR(50)
SET @DB=''

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1

	SELECT @DB=DatabaseName
	FROM #DBS
	WHERE DBID=@Count

	SET @ESQL=REPLACE(@SQL,'{0}',@DB)

	EXEC(@ESQL)
END

SELECT DatabaseName
FROM #DBS
WHERE Exsts=0

DROP TABLE #DBS