--USE DataCollection 
--GO 
--CREATE TABLE DataCollection.dbo.dmsupload(customerid INT, createddate DATETIME, count INT)
--CREATE TABLE DataCollection.dbo.dmssize(customerid INT, dmsdocumentid int, sizeinbytes INT) 

DECLARE @Sql VARCHAR(MAX)
SET @SQL='
insert into sharedserver.DataCollection.dbo.dmsupload
SELECT dbo.fn_GetCustomerID(),dbo.fn_DateOnly(d.CreatedDate), COUNT(*)
FROM dbo.DMSDocument d with (nolock)
WHERE d.CreatedDate>GETDATE()-90
GROUP BY dbo.fn_DateOnly(d.CreatedDate)

insert into sharedserver.DataCollection.dbo.dmssize
SELECT dbo.fn_GetCustomerID(),f.dmsdocumentid, sum(f.sizeinbytes)
FROM dbo.DMSFileInfo f with (nolock)
WHERE d.CreatedDate>GETDATE()-90
group by f.dmsdocumentid

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
--CREATE TABLE PatientPayments112014(CustomerID INT, Month VARCHAR(32), YEAR INT, PAYMENTAMOUNT MONEY)


--max, min, avg, document count
USE DataCollection
GO 
SELECT MAX(count) AS Highest,MIN(count) AS Lowest,AVG(count) AS Average
	FROM (
		SELECT CAST (d.CreatedDate AS date)AS date, COUNT(*)AS count 
		FROM dbo.dmsupload d 
	GROUP BY CAST(d.createddate AS DATE)
	)AS s


--max, min, avg, size uploaded files 
ALTER TABLE dbo.dmssize ADD datamb BIGINT
UPDATE a SET 
datamb = a.sizeinbytes/1000000
FROM dmssize a 

SELECT SUM(f.datamb),MAX(f.datamb) AS Highest,MIN(f.datamb) AS Lowest, CAST(SUM(f.datamb)AS DECIMAL(9,2))/CAST(3901711 AS DECIMAL(9,2))
FROM dbo.dmssize f
WHERE f.sizeinbytes <>0


USE DataCollection
go
SELECT * FROM dbo.dmsupload --ORDER BY sizeinbytes desc




