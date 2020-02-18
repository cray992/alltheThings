----All DBs

--CREATE TABLE Datacollection.dbo.EnrollmentRequests(Customerid INT, PracticeID INT, RequestsCount Int)
--drop TABLE Datacollection.dbo.Surveys(Customerid Int, Year Int, SurveyType VARCHAR(64), SurveyCnt Int)
DECLARE @Sql VARCHAR(MAX)
SET @SQL='


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
INNER JOIN (SELECT customerid FROM SHAREDSERVER.superbill_shared.dbo.ProductDomain_ProductSubscription WITH (NOLOCK) WHERE ProductId=6 AND DeactivationDate IS NULL) bill ON customer.CustomerID=bill.customerid
WHERE CustomerType='N'
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




--USE DataCollection
--SELECT  CompanyName ,
--        CustomerID ,
--		PracticeId,
--		PracticeName,
--		PayerNumber,
--		ClearinghousePayerid,
--		PayerName,
--        Claims
--FROM (
--SELECT CompanyName,c.Customerid, cbf.PracticeId, cbf.PracticeName, cbf.PayerNumber, cbf.clearinghousepayerid, cbf.PayerName,
--SUM(cbf.claimcount)Claims
--FROM ClaimsThroughChangeBeforeFilter012018 CBF
--INNER JOIN superbill_shared.dbo.Customer c ON cbf.customerid=c.customerid
--LEFT JOIN (
--SELECT *
--FROM ClaimsThroughChangeBeforeFilter012018 cbf
--INNER JOIN superbill_shared.dbo.ClearinghousePayersList_ClaimRemapping crm ON cbf.clearinghousepayerid=crm.FromClearinghousePayerID AND CreatedBy<>'40936'
--AND cbf.customerid NOT IN (SELECT customerid FROM superbill_shared.dbo.ClearinghousePayersList_ClaimRemapping_CustomerExclusion ce )) exclude ON cbf.customerid=exclude.customerid AND cbf.practiceid=exclude.practiceid AND cbf.clearinghousepayerid=exclude.FromClearinghousePayerID
--WHERE exclude.FromClearinghousePayerID IS NULL
--GROUP BY  CompanyName,c.Customerid, cbf.PracticeId, cbf.PracticeName, cbf.PayerNumber, cbf.ClearinghousePayerID, cbf.PayerName)sub
--WHERE Claims IS NOT null
--ORDER BY CustomerID
