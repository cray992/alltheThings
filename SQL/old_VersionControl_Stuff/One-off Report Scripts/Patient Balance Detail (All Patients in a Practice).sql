	DECLARE @PracticeID INT ,
	@EndDate datetime ,
	@ReportType CHAR(1)

	SET @PracticeID=1
	SET @EndDate='4-6-06'
	SET @ReportType='O'

	CREATE TABLE #AR (ClaimID INT, Amount MONEY)
	INSERT INTO #AR(ClaimID, Amount)
	SELECT ClaimID, SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)+
	SUM(CASE WHEN ClaimTransactionTypeCode<>'CST' THEN Amount*-1 ELSE 0 END)
	FROM ClaimAccounting
	WHERE PracticeID=@PracticeID AND PostingDate<=@EndDate
	GROUP BY ClaimID
	HAVING ((@ReportType='O' AND (SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)+
	SUM(CASE WHEN ClaimTransactionTypeCode<>'CST' THEN Amount*-1 ELSE 0 END))>0) OR (@ReportType='A'))
	
	--Get Last Assignments
	CREATE TABLE #ASNMax (ClaimID INT, ClaimTransactionID INT)
	INSERT INTO #ASNMax(ClaimID, ClaimTransactionID)
	SELECT CAA.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM ClaimAccounting_Assignments CAA INNER JOIN #AR AR ON CAA.ClaimID=AR.ClaimID
	WHERE PracticeID=@PracticeID AND PostingDate<=@EndDate
	GROUP BY CAA.ClaimID
	
	CREATE TABLE #ASN (ClaimID INT, PatientID INT, TypeGroup INT)
	INSERT INTO #ASN(ClaimID, PatientID, TypeGroup)
	SELECT CAA.ClaimID, CAA.PatientID,
	CASE WHEN ICP.InsuranceCompanyPlanID IS NULL THEN 2 ELSE 1 END TypeGroup
	FROM ClaimAccounting_Assignments CAA INNER JOIN #ASNMax AM ON CAA.ClaimID=AM.ClaimID AND CAA.ClaimTransactionID=AM.ClaimTransactionID
	LEFT JOIN InsuranceCompanyPlan ICP ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
	WHERE CAA.PracticeID=@PracticeID AND CAA.PostingDate<=@EndDate

	CREATE TABLE #Rpt(PatientID INT, ClaimID INT, ProcedureDateOfService DATETIME, ProcedureCode VARCHAR(16), ProcedureName VARCHAR(512),
	Charges MONEY, Adjustments MONEY, InsPay MONEY, PatPay MONEY, TotalBalance MONEY, PendingIns MONEY, PendingPat MONEY)
	INSERT INTO #Rpt
	SELECT A.PatientID, C.ClaimID, ProcedureDateOfService, ProcedureCode, PCD.OfficialName ProcedureName, 
	SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END) Charges,
	SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN Amount*-1 ELSE 0 END) Adjustments,
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='I' THEN Amount*-1 ELSE 0 END) InsPay,
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P' THEN Amount*-1 ELSE 0 END) PatPay,
	SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)+
	SUM(CASE WHEN ClaimTransactionTypeCode<>'CST' THEN Amount*-1 ELSE 0 END) TotalBalance,
	SUM(CASE WHEN TypeGroup=1 AND ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)+
	SUM(CASE WHEN TypeGroup=1 AND ClaimTransactionTypeCode<>'CST' THEN Amount*-1 ELSE 0 END) PendingIns,
	SUM(CASE WHEN TypeGroup=2 AND ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)+
	SUM(CASE WHEN TypeGroup=2 AND ClaimTransactionTypeCode<>'CST' THEN Amount*-1 ELSE 0 END) PendingPat
	FROM #ASN A INNER JOIN ClaimAccounting CAA
	ON A.PatientID=CAA.PatientID AND A.ClaimID=CAA.ClaimID
	LEFT JOIN PaymentClaimTransaction PCT
	ON CAA.ClaimTransactionID=PCT.ClaimTransactionID
	LEFT JOIN Payment P
	ON PCT.PaymentID=P.PaymentID
	INNER JOIN Claim C
	ON A.ClaimID=C.ClaimID
	INNER JOIN EncounterProcedure EP
	ON C.EncounterProcedureID=EP.EncounterProcedureID
	INNER JOIN ProcedureCodeDictionary PCD
	ON EP.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
	WHERE CAA.PracticeID=@PracticeID AND CAA.PostingDate<=@EndDate
	GROUP BY A.PatientID, C.ClaimID, ProcedureDateOfService, ProcedureCode, PCD.OfficialName
	ORDER BY ProcedureDateOfService, ProcedureCode, PCD.OfficialName

	SELECT 	RTRIM(ISNULL(LastName + ', ', '') + ISNULL(FirstName,'') + ISNULL(' ' + MiddleName, '')) + ' - ID#: '+CAST(P.PatientID AS VARCHAR(10))+CHAR(13)+ CHAR(10)+
	ISNULL(AddressLine1+', ','')+ISNULL(City+', ','')+ISNULL(State+' ','')+dbo.fn_FormatZipCode(ZipCode) + CHAR(13) + CHAR(10)+
	ISNULL('Phone: '+dbo.fn_FormatPhone(HomePhone),'') PatientInfo, R.*
	FROM #Rpt R INNER JOIN Patient P
	ON R.PatientID=P.PatientID
	WHERE PracticeID=@PracticeID

	DROP TABLE #AR
	DROP TABLE #ASN
	DROP TABLE #ASNMax
	DROP TABLE #Rpt