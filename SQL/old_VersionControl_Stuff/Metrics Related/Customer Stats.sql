DECLARE @Loop INT
DECLARE @Count INT
DECLARE @CustomerID INT
DECLARE @DatabaseName VARCHAR(50)
DECLARE @DatabaseServerName VARCHAR(50)

DECLARE @SQL VARCHAR(MAX)
DECLARE @ExecSQL VARCHAR(MAX)

CREATE TABLE #CustomerRpt(CustomerID INT, FirstPractice DATETIME, FirstProvider DATETIME, ActivePractices INT, InActivePractices INT,
						  ActiveProviders INT, InActiveProviders INT, LastEncounter DATETIME)

SET @SQL='
CREATE TABLE #Encounter(CustomerID INT, LastEncounter DATETIME)
INSERT INTO #Encounter(CustomerID, LastEncounter)
SELECT {1} CustomerID, MAX(E.CreatedDate) LastEncounter
FROM {0}Encounter E INNER JOIN {0}Practice P
ON E.PracticeID=P.PracticeID
WHERE P.Metrics=1

CREATE TABLE #Doctor(CustomerID INT, FirstProvider DATETIME, ActiveProviders INT, InActiveProviders INT)
INSERT INTO #Doctor(CustomerID, FirstProvider, ActiveProviders, InActiveProviders)
SELECT {1} CustomerID, MIN(D.CreatedDate) FirstProvider, 
COUNT(CASE WHEN ActiveDoctor=1 THEN 1 ELSE NULL END) ActiveProviders,
COUNT(CASE WHEN ActiveDoctor=0 THEN 1 ELSE NULL END) InActiveProviders
FROM {0}Doctor D INNER JOIN {0}Practice P
ON D.PracticeID=P.PracticeID
WHERE P.Metrics=1 AND D.[External]=0

CREATE TABLE #Practice(CustomerID INT, FirstPractice DATETIME, ActivePractices INT, InActivePractices INT)
INSERT INTO #Practice(CustomerID, FirstPractice, ActivePractices, InActivePractices)
SELECT {1} CustomerID, MIN(CreatedDate) FirstPractice, 
COUNT(CASE WHEN Active=1 THEN 1 ELSE NULL END) ActivePractices,
COUNT(CASE WHEN Active=0 THEN 1 ELSE NULL END) InActivePractices
FROM {0}Practice

INSERT INTO #CustomerRpt(CustomerID, FirstPractice, FirstProvider, ActivePractices, InActivePractices, ActiveProviders, InActiveProviders,
						 LastEncounter)
SELECT {1} CustomerID, FirstPractice, FirstProvider, ActivePractices, InActivePractices, ActiveProviders, 
InActiveProviders, LastEncounter
FROM #Practice P LEFT JOIN #Doctor D
ON P.CustomerID=D.CustomerID
LEFT JOIN #Encounter E
ON P.CustomerID=E.CustomerID

DROP TABLE #Encounter
DROP TABLE #Doctor
DROP TABLE #Practice
'

CREATE TABLE #DBs(RID INT IDENTITY(1,1), DatabaseServerName VARCHAR(50), DatabaseName VARCHAR(50), CustomerID INT, CompanyName VARCHAR(128),
				  AccountCreated DATETIME, Locked BIT, Metrics BIT, Active BIT)
INSERT INTO #DBs(DatabaseServerName, DatabaseName, CustomerID, CompanyName, AccountCreated, Locked, Metrics, Active)
SELECT DatabaseServerName, DatabaseName, CustomerID, CompanyName, CreatedDate, AccountLocked, Metrics, DBActive
FROM Customer
WHERE CustomerType='N' AND DatabaseServerName IS NOT NULL AND DatabaseName IS NOT NULL

SET @Loop=@@ROWCOUNT
SET @Count=0

DECLARE @InnerLoop INT
DECLARE @InnerCount INT

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1

	SELECT @CustomerID=CustomerID, 
	@DatabaseName=DatabaseName, @DatabaseServerName=DatabaseServerName
	FROM #DBs
	WHERE RID=@Count

	SET @ExecSQL=REPLACE(@SQL,'{0}','['+@DatabaseServerName+'].'+@DatabaseName+'.dbo.')
	SET @ExecSQL=REPLACE(@ExecSQL,'{1}',CAST(@CustomerID AS VARCHAR))

	EXEC(@ExecSQL)
END

SELECT CR.CustomerID, CompanyName CustomerName, AccountCreated, Locked, Metrics, DB.Active AccountActive,
FirstPractice, FirstProvider, ActivePractices, InActivePractices, ActiveProviders, InActiveProviders,
LastEncounter
FROM #CustomerRpt CR INNER JOIN #DBs DB
ON CR.CustomerID=DB.CustomerID

DROP TABLE #DBs
DROP TABLE #CustomerRpt