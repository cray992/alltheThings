set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



--===========================================================================
-- CREATE STATEMENT BATCH
--===========================================================================
ALTER PROCEDURE [dbo].[BillDataProvider_PopulatePatientClaimsForStatement]
	@practice_id INT,
	@days INT,
	@min_balance NUMERIC,
	@CountStatements INT=0
AS
BEGIN
	SET NOCOUNT ON 

	--Set Break Point Date
	DECLARE @EvalDate DATETIME
	SET @EvalDate=DATEADD(D, @days * -1, GETDATE())

	DECLARE @PatientStatementCount INT

	IF @CountStatements=1
	BEGIN
		--Try getting claims first, then items to remove due to 0 balance, then patients recently billed
		DECLARE @PatClaims TABLE(ClaimID INT, PatientID INT, ClaimBalance MONEY)
		INSERT @PatClaims(ClaimID, PatientID, ClaimBalance)
		SELECT CAA.ClaimID, CAA.PatientID, SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE -1*Amount END) ClaimBalance
		FROM ClaimAccounting_Assignments CAA 
		INNER JOIN ClaimAccounting CA
			ON CAA.PracticeID = CA.PracticeID
			AND CAA.ClaimID = CA.ClaimID AND CA.Status=0
		WHERE CAA.PracticeID=@practice_id AND CAA.Status=0 AND LastAssignment=1 AND InsurancePolicyID IS NULL
		GROUP BY CAA.ClaimID, CAA.PatientID
		HAVING  SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE -1*Amount END) <>0

		DECLARE @PatientsRecentlyBilled TABLE(PatientID INT)
		INSERT @PatientsRecentlyBilled(PatientID)
		SELECT DISTINCT PatientID
		FROM @PatClaims PC INNER JOIN ClaimAccounting_Billings CAB
		ON PC.ClaimID=CAB.ClaimID AND CAB.PracticeID=@practice_id AND Status=0 AND LastBilled=1 AND BatchType='S' AND PostingDate>=@EvalDate

		DECLARE @PatientList_ToSend TABLE(PatientID INT)
		INSERT @PatientList_ToSend(PatientID)
		SELECT PC.PatientID
		FROM @PatClaims PC LEFT JOIN @PatientsRecentlyBilled PRB
		ON PC.PatientID=PRB.PatientID
		WHERE PRB.PatientID IS NULL 
		GROUP BY PC.PatientID
		HAVING SUM(ClaimBalance)>@min_balance

		SET @PatientStatementCount=@@ROWCOUNT

		RETURN @PatientStatementCount	
	END
	
	--Get All Open Claims for Patients
	CREATE TABLE #OpenPatientClaims(PatientID INT, ClaimID INT, Type CHAR(1))
	INSERT INTO #OpenPatientClaims(PatientID, ClaimID, Type)
	SELECT PatientID, ClaimID, CASE WHEN InsurancePolicyID IS NULL THEN 'P' ELSE 'I' END Type
	FROM ClaimAccounting_Assignments 
	WHERE PracticeID=@practice_id AND Status=0 AND LastAssignment=1
	
	--Build Assignments Key
	CREATE TABLE #Assignments(TID INT IDENTITY(1,1), PatientID INT, ClaimID INT, StartID INT, EndID INT, Type CHAR(1))
	INSERT INTO #Assignments(PatientID, ClaimID, StartID, Type)
	SELECT CAA.PatientID, CAA.ClaimID, ClaimTransactionID, CASE WHEN InsurancePolicyID IS NULL THEN 'P' ELSE 'I' END Type
	FROM ClaimAccounting_Assignments CAA INNER JOIN #OpenPatientClaims OPC ON CAA.ClaimID=OPC.ClaimID AND OPC.Type='P'
	WHERE PracticeID=@practice_id AND Status=0
	ORDER BY CAA.PatientID, CAA.ClaimID, ClaimTransactionID
	
	UPDATE A SET EndID=A2.StartID
	FROM #Assignments A INNER JOIN #Assignments A2 ON A.ClaimID=A2.ClaimID AND A.TID+1=A2.TID
	
	--Determine assignments of bills for claims
	CREATE TABLE #LastBills(PatientID INT, ClaimID INT, PostingDate DATETIME, Type CHAR(1))
	INSERT INTO #LastBills(PatientID, ClaimID, PostingDate, Type)
	SELECT PatientID, CAB.ClaimID, PostingDate, Type
	FROM ClaimAccounting_Billings CAB INNER JOIN #Assignments A 
	ON CAB.ClaimID=A.ClaimID AND CAB.ClaimTransactionID>A.StartID AND CAB.ClaimTransactionID<A.EndID
	OR CAB.ClaimID=A.ClaimID AND CAB.ClaimTransactionID>A.StartID AND A.EndID IS NULL
	WHERE PracticeID=@practice_id AND Status=0
	
	--Get last patient billed date for claims
	CREATE TABLE #LastBilled(PatientID INT, ClaimID INT, LastBilled DATETIME)
	INSERT INTO #LastBilled(PatientID, ClaimID, LastBilled)
	SELECT PatientID, ClaimID, MAX(PostingDate) LastBilled
	FROM #LastBills
	WHERE Type='P'
	GROUP BY PatientID, ClaimID
	
	--Get Balances on Claims
	CREATE TABLE #ClaimBalances(PatientID INT, ClaimID INT, Balance MONEY)
	INSERT INTO #ClaimBalances(PatientID, ClaimID, Balance)
	SELECT CA.PatientID, CA.ClaimID, SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE -1*Amount END) Balance
	FROM ClaimAccounting CA INNER JOIN #OpenPatientClaims OPC ON CA.ClaimID=OPC.ClaimID AND OPC.Type='P'
	WHERE PracticeID=@practice_id AND Status=0
	GROUP BY CA.PatientID, CA.ClaimID
	
	--Populate Patients that meet criteria for Statement Generation
	CREATE TABLE #BillablePatients(PatientID INT, LastBilled DATETIME, Balances MONEY)
	INSERT INTO #BillablePatients(PatientID, LastBilled, Balances)
	SELECT OPC.PatientID, MAX(LastBilled) LastBilled, SUM(Balance) Balances
	FROM #OpenPatientClaims OPC INNER JOIN #ClaimBalances CB
	ON OPC.PatientID=CB.PatientID AND OPC.ClaimID=CB.ClaimID
	LEFT JOIN #LastBilled LB
	ON OPC.PatientID=LB.PatientID AND OPC.ClaimID=LB.ClaimID
	GROUP BY OPC.PatientID
	HAVING (MAX(LastBilled)<@EvalDate OR MAX(LastBilled) IS NULL) AND SUM(Balance)>@min_balance

	CREATE TABLE #ReturnResults(ClaimID INT, PatientID INT)
	INSERT INTO #ReturnResults(ClaimID, PatientID)
	SELECT ClaimID, OPC.PatientID
	FROM #OpenPatientClaims OPC INNER JOIN #BillablePatients BP 
	ON OPC.PatientID=BP.PatientID
	ORDER BY OPC.PatientID, ClaimID

	--Delete Patient Assigned Claims with 0 balance
	DELETE RR
	FROM #ReturnResults RR INNER JOIN #ClaimBalances CB ON RR.ClaimID=CB.ClaimID
	WHERE Balance = 0

	--Calculate Insurance Assigned Claims balances for claims in this batch
	DELETE #ClaimBalances

	INSERT INTO #ClaimBalances(PatientID, ClaimID, Balance)
	SELECT CA.PatientID, CA.ClaimID, SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE -1*Amount END) Balance
	FROM ClaimAccounting CA INNER JOIN #OpenPatientClaims OPC ON CA.ClaimID=OPC.ClaimID AND OPC.Type='I'
	INNER JOIN #BillablePatients BP ON OPC.PatientID=BP.PatientID	 
	WHERE PracticeID=@practice_id AND Status=0
	GROUP BY CA.PatientID, CA.ClaimID

	--Delete Insurance Assigned Claims with 0 balances
	DELETE RR
	FROM #ReturnResults RR INNER JOIN #ClaimBalances CB ON RR.ClaimID=CB.ClaimID
	WHERE Balance = 0

	INSERT #t_claims(ClaimID, PatientID)
	SELECT ClaimID, PatientID
	FROM #ReturnResults
	
	DROP TABLE #OpenPatientClaims
	DROP TABLE #Assignments
	DROP TABLE #LastBills
	DROP TABLE #LastBilled
	DROP TABLE #ClaimBalances
	DROP TABLE #BillablePatients
	DROP TABLE #ReturnResults

	RETURN
END


