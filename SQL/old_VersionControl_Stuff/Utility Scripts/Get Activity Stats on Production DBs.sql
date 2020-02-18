DECLARE @Loop INT, @Count INT

CREATE TABLE #DBs(DBID INT IDENTITY(1,1), CompanyName VARCHAR(128), ContactFirstName VARCHAR(64), ContactLastName VARCHAR(64), DatabaseName VARCHAR(128), CreatedDate DATETIME)
INSERT INTO #DBs(CompanyName, ContactFirstName, ContactLastName, DatabaseName, CreatedDate)
SELECT CompanyName, ContactFirstName, ContactLastName, DatabaseName, CreatedDate
FROM Customer
WHERE DBActive=1 AND CustomerType <> 'N'

SET @Loop=@@ROWCOUNT
SET @Count=0

DECLARE @DB VARCHAR(128)
DECLARE @DBCreated DATETIME

CREATE TABLE #DCDBs(DatabaseName VARCHAR(128), LPR DATETIME, LER DATETIME, LAR DATETIME)

DECLARE @SQL VARCHAR(8000)
DECLARE @ESQL VARCHAR(8000)

SET @SQL='
DECLARE @LastPatientRecord DATETIME
DECLARE @LastEncounterRecord DATETIME
DECLARE @LastAppointmentRecord DATETIME

SELECT @LastPatientRecord=MAX(CreatedDate)
FROM {0}..Patient

SELECT @LastEncounterRecord=MAX(CreatedDate)
FROM {0}..Encounter

SELECT @LastAppointmentRecord=MAX(CreatedDate)
FROM {0}..Appointment

INSERT INTO #DCDBs(DatabaseName, LPR, LER, LAR)
VALUES(''{0}'', @LastPatientRecord, @LastEncounterRecord, @LastAppointmentRecord)
'

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1
	
	SELECT @DB=DatabaseName
	FROM #DBs
	WHERE DBID=@Count

	SET @ESQL=REPLACE(@SQL,'{0}',@DB)

	EXEC(@ESQL)
END

SELECT CompanyName, ContactFirstName, ContactLastName, II.DatabaseName, DATEDIFF(D,II.CreatedDate,GETDATE()) DFC, DATEDIFF(D,LPR,GETDATE()) LPR, DATEDIFF(D,LER,GETDATE()) LER, DATEDIFF(D,LAR,GETDATE()) LAR
FROM #DCDBs I INNER JOIN #DBs II
ON I.DatabaseName=II.DatabaseName
WHERE (LPR IS NULL OR DATEDIFF(D,LPR,GETDATE())>0) AND (LER IS NULL OR DATEDIFF(D,LER,GETDATE())>0) AND (LAR IS NULL OR DATEDIFF(D,LAR,GETDATE())>0)

DROP TABLE #DBs
DROP TABLE #DCDBs