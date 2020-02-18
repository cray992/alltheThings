-- 90 day ERA Report

--Run across all DBs
DECLARE @Sql VARCHAR(MAX)
SET @SQL='
CREATE TABLE #ERAs (ClearingHouseResponseID INT, PracticeID INT, PracticeName VARCHAR(100), [FileContents] Varchar(Max), OriginatingCompanySupplementalCode VARCHAR(50),
PayerName VARCHAR(100), PayerIdentifier VARCHAR(50), PayerAdditionalIdentifier VARCHAR(50), PayeeName VARCHAR(100),
PayeeIdentifier VARCHAR(50), PayeeAdditionalIdentifier VARCHAR(50), sourceaddress varchar(128))
INSERT INTO #ERAs (ClearinghouseResponseID, PracticeID, PracticeName, [FileContents], sourceaddress)
SELECT C.ClearinghouseResponseID, C.PracticeID, P.Name,
C.[FileContents] , sourceaddress
FROM dbo.ClearinghouseResponse C WITH (NOLOCK)
INNER JOIN dbo.Practice P WITH (NOLOCK) ON C.PracticeID = P.PracticeID
WHERE ClearinghouseResponseReportTypeID = 2
AND FileReceiveDate BETWEEN ''''5/1/2018'''' and ''''8/31/2018''''
AND C.PaymentID IS NULL
--AND C.SourceAddress LIKE ''''%proxymed%''''

INSERT INTO Sharedserver.DataCollection.dbo.ERA90Days2
SELECT dbo.fn_GetCustomerID(), PracticeID, PracticeName,FileContents, OriginatingCompanySupplementalCode,
PayerName, PayerIdentifier, PayerAdditionalIdentifier, PayeeName, PayeeIdentifier, PayeeAdditionalIdentifier, sourceaddress
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
INNER JOIN SHAREDSERVER.superbill_shared.dbo.ProductDomain_ProductSubscription pdps ON pdps.CustomerId = customer.CustomerID AND ProductId IN (5,6)
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
---Run for KMB Ò Updated all payerids
PRINT @CurrentDB
SET @SqlCommand='USE ['+@DBName+ ']; EXEC ('''+@sql+''');';
EXEC(@SqlCommand);
--SELECT @SqlCommand
--===== Get ready to read the next file row
SELECT @CurrentDB = @CurrentDB + 1
;
END
DROP TABLE #DBInfo

———————————————


--USE DataCollection
--GO


----Run on DataCollection DB:
--alter table dbo.era90days3 add FilecontentsXml xml
--UPDATE dbo.era90days3
--set filecontentsxml= Cast([filecontents] as xml)
--from dbo.era90days3
--UPDATE dbo.era90days3
--SET OriginatingCompanySupplementalCode = FilecontentsXml.value('(/loop[@name="ST"]/segment[@name="TRN"][@qual="1"]/TRN04/text())[1]', 'VARCHAR(50)'),
--PayerName = FilecontentsXml.value('(/loop[@name="ST"]/loop[@name="1000A"]/segment[@name="N1"][@qual="PR"]/N102/text())[1]', 'VARCHAR(50)'),
--PayerIdentifier = FilecontentsXml.value('(/loop[@name="ST"]/loop[@name="1000A"]/segment[@name="N1"][@qual="PR"]/N104/text())[1]', 'VARCHAR(50)'),
--PayerAdditionalIdentifier = FilecontentsXml.value('(/loop[@name="ST"]/loop[@name="1000A"]/segment[@name="REF"][@qual="2U"]/REF02/text())[1]', 'VARCHAR(50)'),
--PayeeName = FilecontentsXml.value('(/loop[@name="ST"]/loop[@name="1000B"]/segment[@name="N1"][@qual="PE"]/N102/text())[1]', 'VARCHAR(50)'),
--PayeeIdentifier = FilecontentsXml.value('(/loop[@name="ST"]/loop[@name="1000B"]/segment[@name="N1"][@qual="PE"]/N104/text())[1]', 'VARCHAR(50)'),
--PayeeAdditionalIdentifier = FilecontentsXml.value('(/loop[@name="ST"]/loop[@name="1000B"]/segment[@name="REF"]/REF01/text())[1]', 'VARCHAR(50)') + '/' +
--FilecontentsXml.value('(/loop[@name="ST"]/loop[@name="1000B"]/segment[@name="REF"]/REF02/text())[1]', 'VARCHAR(50)')
----


----SELECT DISTINCT ch.customerid,c.companyname,ch.OriginatingCompanySupplementalCode, PayerName, PayerIdentifier, PayerAdditionalIdentifier, PayeeName, PayeeIdentifier, PayeeAdditionalIdentifier
----,
----	CASE ch.sourceaddress
----		WHEN '204.138.99.118/remits' THEN 'Trizetto'
----		WHEN 'claimsftp.proxymed.com/reports/0073922N' THEN 'Change'
----		WHEN 'claimsftp.proxymed.com/reports/0073922U' THEN 'Change'
----		WHEN 'claimsftp.proxymed.com/reports/0073922X' THEN 'Change'
----		WHEN 'ftp.officeally.com/outbound' THEN 'OfficeAlly'
----		WHEN 'sftp.jopari.net//download' THEN 'Jopari'
----		WHEN 'sshftp.zirmed.com//Download' THEN 'Zirmed'
----		ELSE ''
----	END as 'ClearingHouse'

--FROM dbo.era90days2 ch
--Inner join superbill_shared.dbo.customer c on ch.customerid=c.customerid
--INNER JOIN [DataCollection].[dbo].['90DayERACustList_dag370'] b ON b.custid = ch.CustomerID
----INNER JOIN SHAREDSERVER.DataCollection.dbo.ERA90DAyCustomers dc ON c.CustomerID=dc.[cus] and dc.[practice id]=ch.practiceid
