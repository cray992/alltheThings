-------Customers with claims and ERAs with Change Healthcare (Capario)

--USE [DataCollection]
--GO
--CREATE TABLE [dbo].[ClaimsThroughChangeBeforeFilter091818](
--	[CustomerID] [INT] NULL,
--	[PracticeID] [INT] NULL,
--	[PracticeName] [VARCHAR](256) NULL,
--	[PayerNumber] [VARCHAR](32) NULL,
--	[ClearinghousePayerID] [INT] NULL,
--	[PayerName] [VARCHAR](256) NULL,
--	[PostingDate] [DATE] NULL,
--	[claimcount] [INT] NULL
--) ON [PRIMARY]
--CREATE TABLE [dbo].[ERAChangeHealthcare091818](
--	[CustomerID] [INT] NULL,
--	[PracticeID] [INT] NULL,
--	[PracticeName] [VARCHAR](100) NULL,
--	[FileContents] [VARCHAR](MAX) NULL,
--	[OriginatingCompanySupplementalCode] [VARCHAR](50) NULL,
--	[PayerName] [VARCHAR](100) NULL,
--	[PayerIdentifier] [VARCHAR](50) NULL,
--	[PayerAdditionalIdentifier] [VARCHAR](50) NULL,
--	[PayeeName] [VARCHAR](100) NULL,
--	[PayeeIdentifier] [VARCHAR](50) NULL,
--	[PayeeAdditionalIdentifier] [VARCHAR](50) NULL,
--) 

----DROP TABLE [dbo].[ClaimsThroughChangeBeforeFilter091818]
----DROP TABLE [dbo].[ERAChangeHealthcare091818]

DECLARE @Sql VARCHAR(MAX)
SET @SQL='

INSERT INTO SHAREDSERVER.DataCollection.dbo.ClaimsThroughChangeBeforeFilter091818
SELECT dbo.fn_GetCustomerID() AS KareoID, p.Practiceid, P.Name, cpl.PayerNumber, ic.ClearinghousePayerID, cpl.Name PayerName, dbo.fn_DateOnly(PostingDate)PostingDate,
COUNT(DISTINCT ClaimID) AS ClaimCount
FROM dbo.ClaimAccounting_Assignments a WITH (NOLOCK) 
INNER JOIN dbo.InsuranceCompanyPlan ICP WITH (NOLOCK) ON ICP.InsuranceCompanyPlanID = a.InsuranceCompanyPlanID
INNER JOIN dbo.InsuranceCompany IC WITH (NOLOCK) ON IC.InsuranceCompanyID = ICP.InsuranceCompanyID
INNER JOIN dbo.Practice P WITH (NOLOCK) ON a.PracticeID=p.PracticeID
INNER JOIN SHAREDSERVER.superbill_shared.dbo.ClearinghousePayersList CPL WITH (NOLOCK) ON CPL.ClearinghousePayerID = IC.ClearinghousePayerID
WHERE a.PostingDate BETWEEN ''''8/1/2018'''' AND ''''8/31/2018'''' AND ClearinghouseID=1
GROUP BY p.Practiceid, P.Name, cpl.PayerNumber, ic.ClearinghousePayerID, cpl.Name,dbo.fn_DateOnly(PostingDate);

CREATE TABLE #ERAs (ClearingHouseResponseID INT, PracticeID INT, PracticeName VARCHAR(100), [FileContents] Varchar(Max), OriginatingCompanySupplementalCode VARCHAR(50),
PayerName VARCHAR(100), PayerIdentifier VARCHAR(50), PayerAdditionalIdentifier VARCHAR(50), PayeeName VARCHAR(100), 
PayeeIdentifier VARCHAR(50), PayeeAdditionalIdentifier VARCHAR(50))
INSERT INTO #ERAs (ClearinghouseResponseID, PracticeID, PracticeName, [FileContents])
SELECT C.ClearinghouseResponseID, C.PracticeID, P.Name,
C.[FileContents] 
FROM dbo.ClearinghouseResponse C WITH (NOLOCK)
INNER JOIN dbo.Practice P WITH (NOLOCK) ON C.PracticeID = P.PracticeID
WHERE ClearinghouseResponseReportTypeID = 2 
AND FileReceiveDate BETWEEN DATEADD(dd, -15, GETDATE()) AND GETDATE()
AND C.PaymentID IS NULL
AND C.SourceAddress LIKE ''''%proxymed%''''

INSERT INTO Sharedserver.DataCollection.dbo.ERAChangeHealthcare091818
SELECT dbo.fn_GetCustomerID(), PracticeID, PracticeName,FileContents, OriginatingCompanySupplementalCode, 
PayerName, PayerIdentifier, PayerAdditionalIdentifier, PayeeName, PayeeIdentifier, PayeeAdditionalIdentifier
FROM #ERAs
DROP TABLE #ERAs

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

SELECT * FROM [dbo].[ClaimsThroughChangeBeforeFilter091818]
SELECT * FROM [dbo].[ERAChangeHealthcare091818]