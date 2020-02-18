----Claims and ERA Monthly Report

--USE DataCollection
--GO
--CREATE TABLE datacollection.dbo.EnrollmentERASJun2018(Customerid INT, CompanyName Varchar(256), CompanyType varchar(64), PracticeID Int, PracticeName varchar(256), PracticeCreated datetime, PracticeAge Int, MonthPosted Int, TotalInsurancePayments Int, ERA Int)
--CREATE TABLE datacollection.dbo.TotalClaimsJun2018(Customerid INT, CompanyName Varchar(256), CompanyType varchar(64), PracticeID Int, PracticeName varchar(256), PracticeCreated datetime, PracticeAge Int, MonthPosted Int, ElectronicClaims Int, PrintedClaims Int, TotalClaims INT)

DECLARE @Sql VARCHAR(MAX)
SET @SQL='


INSERT INTO SHAREDSERVER.DataCollection.DBO.[EnrollmentERASMAY2018]
SELECT dbo.fn_GetCustomerID() AS Customerid ,
CompanyName ,
ct.CompanyTypeCaption AS CompanyType ,
pr.PracticeID ,
pr.name AS Practice ,
pr.CreatedDate PracticeCreated ,
DATEDIFF(dd,pr.createddate,GETDATE())PracticeAge,
MONTH(PostingDate) AS MonthPosted,
COUNT(DISTINCT p.paymentid) AS TotalInsurancePayments ,
Sum(CASE WHEN p.ClearinghouseResponseID IS NOT NULL THEN 1 ELSE 0 END) AS ERA
FROM Payment P
INNER JOIN dbo.Practice pr ON pr.PracticeID = P.PracticeID
INNER JOIN SHAREDSERVER.superbill_shared.dbo.Customer c WITH ( NOLOCK ) ON dbo.fn_GetCustomerID() = c.CustomerID
INNER JOIN SHAREDSERVER.superbill_shared.dbo.CompanyType ct WITH ( NOLOCK ) ON ct.CompanyTypeID = c.CompanyTypeID
LEFT JOIN dbo.ClearinghouseResponse cr ON cr.PaymentID = p.paymentid AND
ResponseType IN ( 31, 33 )
WHERE p.PayerTypeCode = ''''I''''
AND PostingDate BETWEEN ''''6/1/2018'''' and ''''6/30/2018''''
--AND pr.CreatedDate > DATEADD(dd, -120,GETDATE())
GROUP BY CompanyName ,
ct.CompanyTypeCaption ,
pr.PracticeID ,
pr.name ,
pr.CreatedDate,
MONTH(PostingDate);

Insert into sharedserver.datacollection.dbo.[TotalClaimsMAY2018]
SELECT
dbo.fn_GetCustomerID() AS Customerid ,
CompanyName ,
ct.CompanyTypeCaption AS CompanyType ,
pr.PracticeID ,
pr.name AS Practice ,
pr.CreatedDate PracticeCreated ,
DATEDIFF(dd,pr.createddate,GETDATE())PracticeAge,
MONTH(PostingDate) AS MonthPosted ,
SUM(CASE WHEN BatchType=''''E'''' THEN 1 END) AS ElectronicClaims,
SUM(CASE WHEN BatchType=''''P'''' THEN 1 END) PrintedClaims,
COUNT(DISTINCT ClaimTransactionID)AS TotalClaims
FROM dbo.ClaimAccounting_Billings b with (nolock)
INNER JOIN dbo.Practice pr ON pr.PracticeID = b.PracticeID
INNER JOIN SHAREDSERVER.superbill_shared.dbo.Customer c WITH ( NOLOCK ) ON dbo.fn_GetCustomerID() = c.CustomerID
INNER JOIN SHAREDSERVER.superbill_shared.dbo.CompanyType ct WITH ( NOLOCK ) ON ct.CompanyTypeID = c.CompanyTypeID
WHERE b.PostingDate BETWEEN ''''6/1/2018'''' and ''''6/30/2018''''
Group By CompanyName ,
ct.CompanyTypeCaption ,
pr.PracticeID ,
pr.name ,
pr.CreatedDate,
MONTH(PostingDate);


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



--USE DataCollection
--GO
--DECLARE @startdate DATETIME
--DECLARE @enddate DATETIME

--SET @startdate = '2017-08-01 00:00:00.810'
--SET @enddate = '2017-08-31 23:23:59.810'

--SELECT *, CONCAT(ROUND(electronicclaims * 100 / totalclaims, 1),'%') AS 'Electronic%'
--FROM dbo.TotalClaimsJan2018
--WHERE practicecreated BETWEEN @startdate AND @enddate
--ORDER BY practicecreated DESC

--SELECT *, CONCAT(ROUND(ERA * 100 / TotalInsurancePayments, 1),'%') AS 'Electronic%'
--FROM dbo.EnrollmentERASJan2018
--WHERE practicecreated BETWEEN @startdate AND @enddate
--ORDER BY practicecreated DE
