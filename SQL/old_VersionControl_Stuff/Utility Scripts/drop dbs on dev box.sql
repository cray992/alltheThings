DECLARE @SQL VARCHAR(8000)
DECLARE @EXSQL VARCHAR(8000)
DECLARE @LOOP INT
DECLARE @COUNT INT
DECLARE @CurrentDB VARCHAR(50)

DECLARE @DBs TABLE(DBID INT IDENTITY(1,1), DatabaseName VARCHAR(50))
INSERT @DBs(DatabaseName)
SELECT name 
FROM sys.databases
WHERE name NOT IN ('CustomerModel','CustomerModelPrepopulated','master','tempdb','model','msdb','ReportServer','ReportServerTempDB','KareoBizclaims','MigrationX_Dev','superbill_shared','HL7','SQLdm','Trace')

DELETE DB
FROM @DBs DB INNER JOIN Superbill_Shared..Customer C
ON DB.DataBaseName=C.DatabaseName

DECLARE @DBsToDelete TABLE(DBID INT IDENTITY(1,1), DatabaseName VARCHAR(50))
INSERT @DBsToDelete(DatabaseName)
SELECT DatabaseName
FROM @DBs

SET @LOOP=@@ROWCOUNT
SET @COUNT=0
SET @CurrentDB=''

SET @SQL='DROP DATABASE {0}'

WHILE @COUNT<@LOOP
BEGIN
	SET @COUNT=@COUNT+1
	SELECT @CurrentDB=DatabaseName
	FROM @DBsToDelete
	WHERE DBID=@COUNT
	
	SET @EXSQL=REPLACE(@SQL,'{0}',@CurrentDB)

	EXEC(@EXSQL)
END