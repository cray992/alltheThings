DECLARE @Loop INT
DECLARE @Count INT

	CREATE TABLE #DBs(DBID INT IDENTITY(1,1), DatabaseServerName varchar(128), DatabaseName VARCHAR(128))
	INSERT INTO #DBs(DatabaseServerName, DatabaseName)
	SELECT DatabaseServerName, DatabaseName
	FROM Customer
	WHERE DBActive=1


SET @Loop=@@ROWCOUNT
SET @Count=0

DECLARE @DB VARCHAR(128)
DECLARE @DBServerName VARCHAR(500)
DECLARE @SQL VARCHAR(8000)
DECLARE @ESQL VARCHAR(8000)
DECLARE @ClaimPatientSwap Table( CustomerID varchar(100) , PracticeID INT, Name varchar(8000), ClaimStatusCode varchar(3), EncounterID INT, ClaimID INT)


SET @SQL='
select ''{1}'', p.PracticeID, p.Name, C.ClaimStatusCode,  e.EncounterID, c.ClaimID
from 
	[{0}].{1}.dbo.Practice P
	INNER JOIN [{0}].{1}.dbo.ClaimAccounting ca ON ca.PracticeID = p.PracticeID
	INNER JOIN [{0}].{1}.dbo.Claim c ON ca.PracticeID = c.PracticeID AND ca.ClaimID = c.CLaimID
	INNER JOIN [{0}].{1}.dbo.EncounterProcedure ep ON ep.PracticeID = c.PracticeID AND ep.EncounterProcedureID = c.EncounterProcedureID
	INNER JOIN [{0}].{1}.dbo.Encounter E on E.PracticeID = ep.PracticeID AND e.EncounterID = ep.EncounterID 
where ca.ClaimTransactionTypeCode = ''CST''
	AND ca.PatientID <> e.PatientID
	AND c.ClaimStatusCode <> ''C''
'

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1
	
	SELECT @DB=DatabaseName, @DBServerName = DatabaseServerName
	FROM #DBs
	WHERE DBID=@Count

	SET @ESQL=REPLACE(@SQL,'{0}',@DBServerName)
	SET @ESQL=REPLACE(@ESQL,'{1}',@DB)


	insert into @ClaimPatientSwap
	exec(@ESQL)
END

select * 
INTO #ClaimPatientSwap
from @ClaimPatientSwap

select * from #ClaimPatientSwap

select CustomerID, count(*)
FROM @ClaimPatientSwap
GROUP BY CUstomerID


DROP TABLE #DBs
-- drop table #ClaimPatientSwap
