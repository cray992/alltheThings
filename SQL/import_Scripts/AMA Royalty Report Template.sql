------------------------------------------------------------Create Table in DataCollection-----------------------------------------------------------------------------------------------------------
--DROP table AmAEncountersQ22018

USE DataCollection
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AmAEncountersQ32018](
	[Customerid] [INT] NULL,
	[DoctorGuid] [VARCHAR](64) NULL,
	[ProviderCreateDate] [DATETIME] NULL,
	[EmailAddress] [VARCHAR](256) NULL,
	[Firstname] [VARCHAR](128) NULL,
	[LastName] [VARCHAR](128) NULL,
	[EncounterCnt] [INT] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


------------------------------------------------------------Run Against all DBs--------------------------------------------------------------------------------------------------------------------

DECLARE @Sql VARCHAR(MAX)
SET @SQL='

DECLARE @startDate DATETIME=''''04/1/2018''''
DECLARE @enddate DATETIME=''''06/30/2018''''

Insert into sharedserver.datacollection.dbo.AmAEncountersQ22018
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


-------------------------------------------GET LOGIN DATA - Run from DataCollection--------------------------------------------------------------------------------------------------------------------

SELECT amae.Customerid, REPLACE(amae.DoctorGuid,'-','')AS doctorguid, amae.EmailAddress, amae.Firstname, amae.LastName, CAST(amae.ProviderCreateDate AS date)AS ProviderCreateDate, amae.EncounterCnt, COUNT(lh.LoginHistoryID)Logins
FROM AmAEncountersQ32018 amae
LEFT JOIN superbill_shared.dbo.LoginHistory lh ON amae.emailaddress=lh.UserEmailAddress AND amae.customerid=lh.CustomerID
GROUP BY amae.Customerid, amae.DoctorGuid, amae.EmailAddress, amae.Firstname, amae.LastName, amae.ProviderCreateDate, amae.EncounterCnt



-------------------------------------------Run in Oracle----------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE ehrdba.AMANotecount;
DROP TABLE ehrdba.AMAUsageQ32018;

CREATE TABLE ehrdba.AMANotecount(Customerid INT, Userid int,  ProviderGuid Varchar2(64), Firstname VARCHAR2(64), LastName varchar2(64), username varchar2(100), createdate date, NoteCnt Int, LogInCount INT);

CREATE TABLE ehrdba.AMAUsageQ32018(Customerid INT, Userid int,  ProviderGuid Varchar(64), Firstname VARCHAR(64), LastName varchar(64), username varchar(100), createdate date, NoteCnt Int, LogInCount INT);

INSERT INTO ehrdba.AMANotecount(Customerid, Userid, ProviderGuid, FirstName, LastName, username, createdate, NoteCnt)
SELECT ee.customer_id, u.userid, p.Guid as ProviderGuid, u.fname as FirstName, u.lname as LastName, u.username, u.create_dt, count(distinct n.ID)NoteCount
FROM healthcare.notes n
Inner join ecomment.enterprise_site_user esu on n.signer_id=esu.enterprise_site_user_id
Inner join reg.users u on esu.userid=u.userid
Inner join ecomment.enterprise_site es on esu.enterprise_site_id=es.enterprise_site_id
Inner join ecomment.enterprise ee on es.enterprise_id=ee.enterprise_id
inner join ecomment.customer c on ee.customer_id=c.customer_id
Inner join ecomment.provider p on u.userid=p.userid 
WHERE status='complete' and signed_at >= to_date('07/01/18', 'mm/dd/yy') and signed_at <= to_date('09/30/18', 'mm/dd/yy') and n.is_deleted=0
GROUP BY ee.customer_id,ee.enterprise_id, ee.name, c.name,u.userid, p.guid, u.fname, u.lname, u.username, u.create_dt
;

Insert into  ehrdba.AMAUsageQ32018      
Select ana.Customerid, ana.userid, Ana.ProviderGuid, ana.firstname, ana.lastname, ana.username, ana.CREATEDATE, ana.NoteCnt,count(login_id) as LoginCnt
from ehrdba.amanotecount ana
Inner join reg.users u on ana.userid=u.userid
Inner join healthaudit.login_event le on u.guid=le.user_guid and le.customer_id=ana.customerid
where  login_time  >= to_date('07/01/18', 'mm/dd/yy') and login_time <= to_date('09/30/18', 'mm/dd/yy') 
group by ana.Customerid, ana.userid, Ana.ProviderGuid, ana.firstname, ana.lastname, ana.username, ana.createdate, ana.NoteCnt;


select a.customerid,userid,providerguid,a.firstname,a.lastname,a.username,to_char(a.createdate,'YYYY-MM-DD'),a.notecnt,a.logincount FROM ehrdba.AMAUsageQ32018 a;






-------------------------------------------Combine PM and EHR data in Workbook and Import into a dev Account-----------------------------------------------------------------------------------------

USE superbill_24553_dev
GO 
SELECT COALESCE(a.customerid, b.customerid)AS customerid, COALESCE(a.doctorguid, b.providerguid)AS providerguid,  
COALESCE(a.lastname, b.lastname)AS lastname, COALESCE(a.firstname, b.firstname)AS firstname, COALESCE(a.emailaddress, b.username)AS email,
COALESCE(a.providercreatedate, b.createdate)AS createdate, a.encountercnt, a.logins AS pmlogincnt, b.notecnt, b.logincount AS ehrlogincnt
FROM dbo._import_1_1_amaQ3pm a 
 FULL JOIN dbo._import_1_1_amaQ3ehr b ON 
	b.providerguid = a.doctorguid

	SELECT * FROM dbo._import_1_1_amaQ3ehr a 