--CREATE TABLE sharedserver.DataCollection.dbo.background_printers


DECLARE @Sql VARCHAR(MAX)
SET @SQL='
insert into sharedserver.DataCollection.dbo.background_printers
SELECT dbo.fn_getcustomerid() as CustomerID, MAX(Br.BusinessRuleID) AS ID, BR.PracticeID, BR.Name
FROM dbo.BusinessRule BR
INNER JOIN dbo.Practice P ON P.PracticeID = BR.PracticeID 
WHERE BR.BusinessRuleProcessingTypeID = 1

GROUP BY BR.PracticeID, BR.Name
'
DECLARE @CurrentDB INT, --Current RowNum we're working on in the #DBInfo table
@DBCount INT, --Total count of rows in the #DBInfo table
@DBName	VARCHAR(50)
CREATE TABLE #DBInfo
(
RowNum INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
[DatabaseID] INT NOT NULL,
DBName VARCHAR(128) NOT NULL,
)
;
INSERT INTO #DBInfo
SELECT
distinct	
d.Database_ID,
--DatabaseServerName ,
customer.DatabaseName
FROM SHAREDSERVER.superbill_shared.dbo.customer AS customer WITH(NOLOCK) 
INNER JOIN sys.databases d ON customer.DatabaseName=d.name
WHERE customer.CustomerType ='N'
ORDER BY customer.DatabaseName
;
--===== Preset the variables
SELECT @DBCount = MAX(RowNum),
@CurrentDB = 1
FROM #DBInfo
;
DECLARE @SqlCommand VARCHAR(MAX)
WHILE @CurrentDB <= @DBCount
BEGIN
SELECT @DBName=(SELECT #DBInfo.DBName FROM #DBInfo WHERE #DBInfo.RowNum=@CurrentDB); 
PRINT @DBName
PRINT @CurrentDB
SET @SqlCommand='USE ['+@DBName+ ']; EXEC  ('''+@SQL+''');'
EXEC(@SQLCommand);

--SELECT @SqlCommand
--===== Get ready to read the next file row
SELECT @CurrentDB = @CurrentDB + 1
;
END
DROP TABLE #DBInfo

--SELECT DISTINCT * FROM dbo.background_printers WHERE name LIKE '%background printing%'