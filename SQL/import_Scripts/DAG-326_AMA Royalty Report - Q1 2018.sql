
--CREATE TABLE Datacollection.dbo.AmAEncountersAll2017(Customerid Int, DoctorGuid Varchar(64), EmailAddress varchar(256), Firstname Varchar(128), LastName varchar(128) )

DECLARE @Sql VARCHAR(MAX)
SET @SQL='


DECLARE @startDate DATETIME=''''10/1/2017''''
DECLARE @enddate DATETIME=''''12/31/2017''''



Insert into sharedserver.datacollection.dbo.AmAEncountersQ42017_2
SELECT dbo.fn_getcustomerid() AS customerid,d.DoctorGuid, d.createddate, COALESCE(d.EmailAddress,u.EmailAddress) EmailAddress, D.FirstName, d.LastName, COUNT(DISTINCT encounterid) EncounterCnt
FROM Doctor D WITH (NOLOCK)
LEFT JOIN  SHAREDSERVER.superbill_shared.dbo.users u WITH (NOLOCK) ON d.userid=u.userid 
INNER JOIN Encounter E WITH (NOLOCK) ON d.doctorid=e.doctorid
WHERE encounterstatusid=3  AND e.postingdate BETWEEN @startdate AND @enddate
GROUP BY d.doctorguid, d.createddate, COALESCE(d.EmailAddress,u.EmailAddress), D.FirstName, d.LastName

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
WHERE CustomerType='N' AND PartnerID<>'2'
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




--------------------------GET LOGIN DATA
--SELECT amae.Customerid, amae.DoctorGuid, amae.EmailAddress, amae.Firstname, amae.LastName,amae.EncounterCnt, COUNT(lh.LoginHistoryID)Logins
----INTO #AMAData
--FROM AmAEncountersq12018 amae
--LEFT JOIN superbill_shared.dbo.LoginHistory lh ON amae.emailaddress=lh.UserEmailAddress AND amae.customerid=lh.CustomerID
--GROUP BY amae.Customerid, amae.DoctorGuid, amae.EmailAddress, amae.Firstname, amae.LastName,amae.EncounterCnt
