CREATE TABLE #ConditionsType(CTID INT IDENTITY(1,1), Parameter VARCHAR(50), Transform BIT)

--1
INSERT INTO #ConditionsType(Parameter, Transform)
VALUES('ProcedureCode',1)

--2
INSERT INTO #ConditionsType(Parameter, Transform)
VALUES('ReferringProvider',1)

--3
INSERT INTO #ConditionsType(Parameter, Transform)
VALUES('State',0)

CREATE TABLE #Rule(RID INT IDENTITY(1,1), RuleName VARCHAR(50))

--1
INSERT INTO #Rule(RuleName)
VALUES('Rule 1')

--2
INSERT INTO #Rule(RuleName)
VALUES('Rule 2')

--3
INSERT INTO #Rule(RuleName)
VALUES('Rule 3')

--4
INSERT INTO #Rule(RuleName)
VALUES('Rule 4')

--5
INSERT INTO #Rule(RuleName)
VALUES('Rule 5')

--6
INSERT INTO #Rule(RuleName)
VALUES('Rule 6')

CREATE TABLE #RuleConditions(RCID INT IDENTITY(1,1), RID INT, CTID INT, CompareType BIT, Value VARCHAR(100))

INSERT INTO #RuleConditions(RID, CTID, CompareType, Value)
VALUES(1,1,1,'6*')
INSERT INTO #RuleConditions(RID, CTID, CompareType, Value)
VALUES(1,2,1,'BERNANKE,A. DAVID')
INSERT INTO #RuleConditions(RID, CTID, CompareType, Value)
VALUES(2,1,1,'95*')
INSERT INTO #RuleConditions(RID, CTID, CompareType, Value)
VALUES(2,3,0,'MD')
INSERT INTO #RuleConditions(RID, CTID, CompareType, Value)
VALUES(3,1,1,'99213')

INSERT INTO #RuleConditions(RID, CTID, CompareType, Value)
VALUES(4,1,1,'205*')
INSERT INTO #RuleConditions(RID, CTID, CompareType, Value)
VALUES(4,2,1,'FRIEDLIS,MAYO')
INSERT INTO #RuleConditions(RID, CTID, CompareType, Value)
VALUES(5,1,1,'NS*')
INSERT INTO #RuleConditions(RID, CTID, CompareType, Value)
VALUES(5,2,1,'CHERRICK,ABRAHAM')
INSERT INTO #RuleConditions(RID, CTID, CompareType, Value)
VALUES(5,3,1,'VA')
INSERT INTO #RuleConditions(RID, CTID, CompareType, Value)
VALUES(6,1,1,'CTC*')
INSERT INTO #RuleConditions(RID, CTID, CompareType, Value)
VALUES(6,2,1,'CINTRON,RUBEN')

DECLARE @PracticeID INT
SET @PracticeID=65

CREATE TABLE #CompareInfo(ClaimID INT, ProcedureCode VARCHAR(16), ReferringProvider VARCHAR(129), State VARCHAR(2))
INSERT INTO #CompareInfo(ClaimID, ProcedureCode, ReferringProvider, State)
SELECT C.ClaimID, ProcedureCode, RP.LastName+','+RP.FirstName ReferringProvider, P.State
FROM Claim C INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
INNER JOIN ProcedureCodeDictionary PCD ON EP.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
INNER JOIN Encounter E ON EP.EncounterID=E.EncounterID
INNER JOIN PatientCase PC ON E.PatientCaseID=PC.PatientCaseID
LEFT JOIN ReferringPhysician RP ON PC.ReferringPhysicianID=RP.ReferringPhysicianID
INNER JOIN Patient P ON PC.PatientID=P.PatientID
WHERE C.ClaimStatusCode='R' AND C.PracticeID=@PracticeID

CREATE TABLE #UniqueCodes(ProcedureCode VARCHAR(16))
INSERT INTO #UniqueCodes(ProcedureCode)
SELECT DISTINCT ProcedureCode
FROM #CompareInfo

CREATE TABLE #Comparator(RID INT, JoinType INT, ProcedureCode VARCHAR(16), ProcedureCodeCompareType BIT,
			 ReferringProvider VARCHAR(129), ReferringProviderCompareType BIT,
		   	 State VARCHAR(2), StateCompareType BIT)

DECLARE @ExpLoop INT
DECLARE @ExpCount INT
DECLARE @ExpRID INT
DECLARE @ExpValue VARCHAR(16)
DECLARE @ExpCompareType BIT

--Insert Rule conditions with single ProcedureCode comparison 
INSERT INTO #Comparator(RID, ProcedureCode, ProcedureCodeCompareType)
SELECT RID, Value, CompareType
FROM #RuleConditions RC INNER JOIN #ConditionsType CT
ON RC.CTID=CT.CTID
WHERE CT.Parameter='ProcedureCode' AND CHARINDEX('*',Value)=0

CREATE TABLE #CodesToExplode(TID INT IDENTITY(1,1), RID INT, Value VARCHAR(16), CompareType BIT)
INSERT INTO #CodesToExplode(RID, Value, CompareType)
SELECT RID, REPLACE(Value,'*','%') Value, CompareType
FROM #RuleConditions RC INNER JOIN #ConditionsType CT
ON RC.CTID=CT.CTID
WHERE CT.Parameter='ProcedureCode' AND CHARINDEX('*',Value)<>0

SET @ExpLoop=@@ROWCOUNT
SET @ExpCount=0
SET @ExpRID=0
SET @ExpValue=''

WHILE @ExpCount<@ExpLoop
BEGIN
	SET @ExpCount=@ExpCount+1
	SELECT @ExpRID=RID, @ExpValue=Value,
	@ExpCompareType=CompareType
	FROM #CodesToExplode
	WHERE TID=@ExpCount	

	INSERT INTO #Comparator(RID, ProcedureCode, ProcedureCodeCompareType)
	SELECT @ExpRID, ProcedureCode, @ExpCompareType
	FROM #UniqueCodes
	WHERE ProcedureCode LIKE @ExpValue
END

--Update Rule conditions with ReferringProvider
UPDATE C SET ReferringProvider=Value, ReferringProviderCompareType=CompareType
FROM #Comparator C INNER JOIN #RuleConditions RC 
ON C.RID=RC.RID
INNER JOIN #ConditionsType CT
ON RC.CTID=CT.CTID
WHERE CT.Parameter='ReferringProvider'

--Insert Rule conditions with ReferringProvider comparison not entered in previous step
INSERT INTO #Comparator(RID, ReferringProvider, ReferringProviderCompareType)
SELECT RC.RID, Value, CompareType
FROM #RuleConditions RC INNER JOIN #ConditionsType CT
ON RC.CTID=CT.CTID LEFT JOIN #Comparator C ON RC.RID=C.RID
WHERE CT.Parameter='ReferringProvider' AND C.RID IS NULL

--Update Rule conditions with State
UPDATE C SET State=Value, StateCompareType=CompareType
FROM #Comparator C INNER JOIN #RuleConditions RC 
ON C.RID=RC.RID
INNER JOIN #ConditionsType CT
ON RC.CTID=CT.CTID
WHERE CT.Parameter='State'

--Insert Rule conditions with State comparison not entered in previous step
INSERT INTO #Comparator(RID, State, StateCompareType)
SELECT RC.RID, Value, CompareType
FROM #RuleConditions RC INNER JOIN #ConditionsType CT
ON RC.CTID=CT.CTID LEFT JOIN #Comparator C ON RC.RID=C.RID
WHERE CT.Parameter='State' AND C.RID IS NULL

CREATE TABLE #Joins(JID INT IDENTITY(1,1), J1 BIT, J2 BIT, J3 BIT)
INSERT INTO #Joins(J1,J2,J3)
SELECT DISTINCT ISNULL(ProcedureCodeCompareType,1) J1, ISNULL(ReferringProviderCompareType, 1) J2, 
ISNULL(StateCompareType,1) J3
FROM #Comparator

UPDATE C SET JoinType=JID
FROM #Comparator C INNER JOIN #Joins J
ON ISNULL(C.ProcedureCodeCompareType,1)=J.J1 AND ISNULL(C.ReferringProviderCompareType,1)=J.J2
AND ISNULL(C.StateCompareType,1)=J.J3

DECLARE @J1 VARCHAR(20)
DECLARE @J2 VARCHAR(20)
DECLARE @J3 VARCHAR(20)
DECLARE @JoinType INT
DECLARE @DynamicSQL VARCHAR(8000)
DECLARE @ExecuteSQL VARCHAR(8000)

DECLARE @DynamicSQLoop INT
DECLARE @DynamicSQLCount INT

SELECT @DynamicSQLoop=COUNT(JID) FROM #Joins
SET @DynamicSQLCount=0
SET @J1=''
SET @J2=''
SET @J3=''
SET @ExecuteSQL=''

CREATE TABLE #ClaimRules(ClaimID INT, RuleID INT)

SET @DynamicSQL='INSERT INTO #ClaimRules(ClaimID, RuleID)
		 SELECT ClaimID, RID RuleID
		 FROM #CompareInfo CI INNER JOIN #Comparator C
		 ON ISNULL(CI.ProcedureCode,''''){0}ISNULL(C.ProcedureCode,'''')
		 AND ISNULL(CI.ReferringProvider,''''){1}ISNULL(C.ReferringProvider,'''')
		 AND ISNULL(CI.State,''''){2}ISNULL(C.State,'''')
		 WHERE C.JoinType={3}'

WHILE @DynamicSQLCount<@DynamicSQLoop
BEGIN
	SET @DynamicSQLCount=@DynamicSQLCount+1

	SELECT @J1=CASE WHEN J1=1 THEN '=' ELSE '<>' END,
	@J2=CASE WHEN J2=1 THEN '=' ELSE '<>' END,
	@J3=CASE WHEN J3=1 THEN '=' ELSE '<>' END
	FROM #Joins
	WHERE JID=@DynamicSQLCount

	SET @ExecuteSQL=REPLACE(@DynamicSQL,'{0}',@J1)
	SET @ExecuteSQL=REPLACE(@ExecuteSQL,'{1}',@J2)
	SET @ExecuteSQL=REPLACE(@ExecuteSQL,'{2}',@J3)
	SET @ExecuteSQL=REPLACE(@ExecuteSQL,'{3}',@DynamicSQLCount)

	EXEC(@ExecuteSQL)
END

SELECT * FROM #ClaimRules

DROP TABLE #CompareInfo
DROP TABLE #UniqueCodes
DROP TABLE #ConditionsType
DROP TABLE #Rule
DROP TABLE #RuleConditions
DROP TABLE #Comparator
DROP TABLE #CodesToExplode
DROP TABLE #Joins
DROP TABLE #ClaimRules