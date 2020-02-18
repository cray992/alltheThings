SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_PatientTransactionsDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_PatientTransactionsDetail]
GO


--===========================================================================
-- SRS Patient Referrals Detail
-- ReportDataProvider_PatientTransactionsDetail 37, 160373, '1/1/2000', '1/1/2006'
-- ReportDataProvider_PatientTransactionsDetail 19, 202222, '1/1/2000', '1/1/2006'
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_PatientTransactionsDetail
	@PracticeID int = NULL,
	@PatientID int = NULL, 
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	SET @BeginDate =  dbo.fn_DateOnly(@BeginDate)
	SET @EndDate=DATEADD(S,-1,DATEADD(D,1,@EndDate))
	
	CREATE TABLE #ClaimAmounts(PatientID INT, ClaimID INT, PostingDate DATETIME, PaymentID INT, PayerTypeCode CHAR(1), ClaimTransactionID INT, ClaimTransactionTypeCode CHAR(3), Amount MONEY)
	INSERT INTO #ClaimAmounts(PatientID, ClaimID, PostingDate, ClaimTransactionID, ClaimTransactionTypeCode, Amount)
	SELECT PatientID, ClaimID, PostingDate, ClaimTransactionID, ClaimTransactionTypeCode, Amount
	FROM ClaimAccounting
	WHERE PracticeID=@PracticeID AND PostingDate <= @EndDate AND ClaimTransactionTypeCode NOT IN ('BLL','PAY')
	AND ((PatientID=@PatientID) OR (@PatientID=0))

	INSERT INTO #ClaimAmounts(PatientID, ClaimID, PostingDate, PaymentID, PayerTypeCode, ClaimTransactionID, ClaimTransactionTypeCode, Amount)
	SELECT CA.PatientID, CA.ClaimID, P.PostingDate, P.PaymentID, P.PayerTypeCode, CA.ClaimTransactionID, CA.ClaimTransactionTypeCode, CA.Amount
	FROM Payment P INNER JOIN PaymentClaimTransaction PCT
	ON P.PracticeID=PCT.PracticeID AND P.PaymentID=PCT.PaymentID
	INNER JOIN ClaimAccounting CA
	ON PCT.PracticeID=CA.PracticeID AND PCT.ClaimID=CA.ClaimID AND PCT.ClaimTransactionID=CA.ClaimTransactionID
	WHERE P.PracticeID=@PracticeID 
	AND ca.PostingDate <= @EndDate --AND P.PostingDate<=@EndDate 
	AND CA.ClaimTransactionTypeCode='PAY'
	AND ((CA.PatientID=@PatientID) OR (@PatientID=0))
	
	CREATE TABLE #PastAppliedPayments(PatientID INT, PaymentID INT, AppliedPayments MONEY)
	INSERT INTO #PastAppliedPayments(PatientID, PaymentID, AppliedPayments)
	SELECT PatientID, PaymentID, SUM(Amount) AppliedPayments
	FROM #ClaimAmounts 
	WHERE ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P' AND PostingDate<@BeginDate
	GROUP BY PatientID, PaymentID
	
	CREATE TABLE #PastRefundsToPayments(PatientID INT, PaymentID INT, RefundAmount MONEY)
	INSERT INTO #PastRefundsToPayments(PatientID, PaymentID, RefundAmount)
	SELECT PatientID, PAP.PaymentID, SUM(RTP.Amount) RefundAmount
	FROM RefundToPayments RTP INNER JOIN #PastAppliedPayments PAP ON RTP.PaymentID=PAP.PaymentID
	WHERE PostingDate<@BeginDate
	GROUP BY PatientID, PAP.PaymentID
	
	CREATE TABLE #Unapplied(PatientID INT, PaymentID INT, UnappliedAmount MONEY)
	INSERT INTO #Unapplied(PatientID, PaymentID, UnappliedAmount)
	SELECT PayerID PatientID, P.PaymentID, PaymentAmount UnappliedAmount
	FROM Payment P INNER JOIN (SELECT DISTINCT PatientID FROM #ClaimAmounts) AnalysisPatients ON P.PayerID=AnalysisPatients.PatientID
	WHERE PracticeID=@PracticeID AND PayerTypeCode='P' AND PostingDate<@BeginDate
	
	CREATE TABLE #InitialUnapplied(PatientID INT, InitialUnappliedAmount MONEY)
	INSERT INTO #InitialUnapplied(PatientID, InitialUnappliedAmount)
	SELECT UA.PatientID, SUM(UnappliedAmount)-SUM(RefundAmount)-SUM(AppliedPayments) InitialUnappliedAmount
	FROM #Unapplied UA LEFT JOIN #PastRefundsToPayments PR ON UA.PatientID=PR.PatientID AND UA.PaymentID=PR.PaymentID
	LEFT JOIN #PastAppliedPayments PAP ON UA.PatientID=PAP.PatientID AND UA.PaymentID=PAP.PaymentID
	GROUP BY UA.PatientID
	
	CREATE TABLE #ClaimAssignments(TID INT IDENTITY(1,1), PatientID INT, ClaimID INT, PostingDate DATETIME, Type CHAR(1), ClaimTransactionID INT, InsuranceCompanyPlanID INT)
	INSERT INTO #ClaimAssignments(PatientID, ClaimID, PostingDate, Type, ClaimTransactionID, InsuranceCompanyPlanID)
	SELECT CAA.PatientID, CAA.ClaimID, CAA.PostingDate, CASE WHEN CAA.InsurancePolicyID IS NULL THEN 'P' ELSE 'I' END Type, ClaimTransactionID, InsuranceCompanyPlanID
	FROM ClaimAccounting_Assignments CAA INNER JOIN 
	(SELECT DISTINCT ClaimID FROM #ClaimAmounts) Claims ON CAA.ClaimID=Claims.ClaimID
	WHERE CAA.PracticeID=@PracticeID AND PostingDate <=@EndDate
	ORDER BY CAA.PatientID, CAA.ClaimID, CAA.PostingDate, ClaimTransactionID
	
	CREATE TABLE #Assignments(TID INT IDENTITY(1,1), PatientID INT, ClaimID INT, PostingDate DATETIME, CurType CHAR(1), PrevType CHAR(1), StartID INT, EndID INT, Balance MONEY, InsuranceCompanyPlanID INT)
	INSERT INTO #Assignments(PatientID, ClaimID, CA1.PostingDate, CurType, StartID, EndID, InsuranceCompanyPlanID)
	SELECT CA1.PatientID, CA1.ClaimID, CA1.PostingDate, CA1.Type, CA1.ClaimTransactionID, CA2.ClaimTransactionID, CA1.InsuranceCompanyPlanID
	FROM #ClaimAssignments CA1 LEFT JOIN #ClaimAssignments CA2
	ON CA1.ClaimID=CA2.ClaimID AND CA1.TID+1=CA2.TID
	
	UPDATE A SET PrevType=ISNULL(A2.CurType,'P')
	FROM #Assignments A LEFT JOIN #Assignments A2 ON A.ClaimID=A2.ClaimID AND A.TID-1=A2.TID
	
	DECLARE @RowsToUpdate INT
	
	CREATE TABLE #UpdateBal(ClaimID INT, TID INT, ClaimTransactionID INT)
	INSERT INTO #UpdateBal(ClaimID, TID)
	SELECT ClaimID, MIN(TID) TID
	FROM #Assignments
	WHERE Balance IS NULL
	GROUP BY ClaimID
	
	SET @RowsToUpdate=@@ROWCOUNT
	
	UPDATE UB SET ClaimTransactionID=StartID
	FROM #UpdateBal UB INNER JOIN #Assignments A ON UB.TID=A.TID
	
	WHILE @RowsToUpdate>0
	BEGIN
		UPDATE A SET Balance=Summary.Balance
		FROM #Assignments A INNER JOIN (
		SELECT TID, SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE -1*Amount END) Balance
		FROM #UpdateBal UB INNER JOIN #ClaimAmounts CA ON UB.ClaimID=CA.ClaimID AND CA.ClaimTransactionID<UB.ClaimTransactionID
		GROUP BY TID) Summary ON A.TID=Summary.TID
	
		DELETE #updateBal
	
		INSERT INTO #UpdateBal(ClaimID, TID)
		SELECT ClaimID, MIN(TID) TID
		FROM #Assignments
		WHERE Balance IS NULL
		GROUP BY ClaimID
		
		SET @RowsToUpdate=@@ROWCOUNT
		
		UPDATE UB SET ClaimTransactionID=StartID
		FROM #UpdateBal UB INNER JOIN #Assignments A ON UB.TID=A.TID
		
	END
	
	CREATE TABLE #BeginingClaimBalances(PatientID INT, ClaimID INT, Balance MONEY)
	INSERT INTO #BeginingClaimBalances(PatientID, ClaimID, Balance)
	SELECT PatientID, ClaimID, SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE -1*Amount END) Balance
	FROM #ClaimAmounts 
	WHERE PostingDate<@BeginDate
	GROUP BY PatientID, ClaimID
	HAVING SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE -1*Amount END)<>0
	
	CREATE TABLE #LastAssigned(ClaimID INT, LastID INT, PayerType CHAR(1))
	INSERT INTO #LastAssigned(ClaimID, LastID)
	SELECT ClaimID, MAX(TID) LastID
	FROM #Assignments
	WHERE PostingDate<@BeginDate
	GROUP BY ClaimID
	
	UPDATE LA SET PayerType=CurType
	FROM #LastAssigned LA INNER JOIN #Assignments A ON LA.ClaimID=A.ClaimID AND LA.LastID=A.TID
	
	CREATE TABLE #BeginingBalances(PatientID INT, InitialInsuranceBalance MONEY, InitialPatientBalance MONEY)
	INSERT INTO #BeginingBalances(PatientID, InitialInsuranceBalance, InitialPatientBalance)
	SELECT PatientID, SUM(CASE WHEN PayerType='I' THEN BCB.Balance ELSE 0 END) InitialInsuranceBalance, 
	SUM(CASE WHEN PayerType='P' THEN BCB.Balance ELSE 0 END) InitialPatientBalance
	FROM #BeginingClaimBalances BCB INNER JOIN #LastAssigned LA ON BCB.ClaimID=LA.ClaimID
	GROUP BY PatientID
	
	CREATE TABLE #CurrentTrans(PatientID INT, ClaimID INT, DoctorID INT, LocationID INT, DateOfService DATETIME, ProcedureCode VARCHAR(16), PostingDate DATETIME, RefundID INT, RefundDate DATETIME, PaymentID INT, InsuranceCompanyPlanID INT, ClaimTransactionID INT, 
				   ClaimTransactionTypeCode CHAR(3), Amount MONEY, Type CHAR(1), PayerType CHAR(1), Unapplied MONEY, InsuranceBalance MONEY, PatientBalance MONEY, Notes VARCHAR(500))
	INSERT INTO #CurrentTrans(PatientID, ClaimID, PostingDate, PaymentID, InsuranceCompanyPlanID, ClaimTransactionID, ClaimTransactionTypeCode, Amount, Type, PayerType,
				  Unapplied, InsuranceBalance, PatientBalance)
	SELECT CA.PatientID, CA.ClaimID, CA.PostingDate, PaymentID, A.InsuranceCompanyPlanID, CA.ClaimTransactionID, ClaimTransactionTypeCode, Amount, ISNULL(CurType,'P') Type, PayerTypeCode PayerType, 
	CASE WHEN PayerTypeCode='P' AND ClaimTransactionTypeCode='PAY' THEN -1.00*CA.Amount Else 0 END Unapplied,
	CASE WHEN CurType='I' AND ClaimTransactionTypeCode<>'CST' THEN -1.00*CA.Amount ELSE 0 END InsuranceBalance,
	CASE WHEN ClaimTransactionTypeCode='CST' THEN CA.Amount
	     WHEN CurType='P' AND ClaimTransactionTypeCode<>'CST' THEN -1.00*CA.Amount ELSE 0 END PatientBalance
	FROM #ClaimAmounts CA LEFT JOIN #Assignments A ON CA.ClaimID=A.ClaimID AND CA.ClaimTransactionID>A.StartID AND CA.ClaimTransactionID<A.EndID
	OR CA.ClaimID=A.ClaimID AND CA.ClaimTransactionID>A.StartID AND A.EndID IS NULL
	WHERE CA.PostingDate BETWEEN @BeginDate AND @EndDate
	ORDER BY CA.PatientID, CA.ClaimTransactionID
	
	--Insert Assignment Transactions
	INSERT INTO #CurrentTrans(PatientID, ClaimID, PostingDate, InsuranceCompanyPlanID, ClaimTransactionID, ClaimTransactionTypeCode, Amount, Type, Unapplied, InsuranceBalance, PatientBalance)
	SELECT PatientID, ClaimID, PostingDate, InsuranceCompanyPlanID, StartID ClaimTransactionID, 'ASN', Balance Amount, CurType, 0 Unapplied,
	CASE WHEN PrevType='P' AND CurType='I' THEN Balance 
	     WHEN PrevType='I' AND CurType='P' THEN -1.00*Balance ELSE 0 END InsuranceBalance,
	CASE WHEN PrevType='I' AND CurType='P' THEN Balance 
	     WHEN PrevType='P' AND CurType='I' THEN -1.00*Balance ELSE 0 END PatientBalance
	FROM #Assignments
	WHERE PostingDate BETWEEN @BeginDate AND @EndDate
	
	--Insert Posted Payments Transactions
	INSERT INTO #CurrentTrans(PatientID, PaymentID, PostingDate, ClaimTransactionTypeCode, Amount, Unapplied, InsuranceBalance, PatientBalance)
	SELECT PayerID PatientID, PaymentID, CAST(CONVERT(CHAR(10),PostingDate,110) AS DATETIME), 'PMT', PaymentAmount, PaymentAmount, 0, 0
	FROM Payment P INNER JOIN (SELECT DISTINCT PatientID FROM #ClaimAmounts) AnalysisPatients ON P.PayerID=AnalysisPatients.PatientID
	WHERE PracticeID=@PracticeID AND PostingDate BETWEEN @BeginDate AND @EndDate AND PayerTypeCode='P'
	
	--Insert Refunds Transactions
	INSERT INTO #CurrentTrans(PatientID, RefundID, RefundDate, ClaimTransactionTypeCode, Amount, Unapplied, InsuranceBalance, PatientBalance)
	SELECT PayerID PatientID, RefundID, CAST(CONVERT(CHAR(10),RTP.PostingDate,110) AS DATETIME) RefundDate, 'RFD', Amount, -1.00*Amount, 0, 0
	FROM RefundToPayments RTP INNER JOIN Payment P ON RTP.PaymentID=P.PaymentID
	INNER JOIN (SELECT DISTINCT PatientID FROM #ClaimAmounts) AnalysisPatients ON P.PayerID=AnalysisPatients.PatientID
	WHERE P.PayerTypeCode='P' AND RTP.CreatedDate BETWEEN @BeginDate AND @EndDate
	
	--Insert Void Transactions
	INSERT INTO #CurrentTrans(PatientID, ClaimID, PostingDate, ClaimTransactionID, ClaimTransactionTypeCode, Amount, Unapplied, InsuranceBalance, PatientBalance)
	SELECT CT.PatientID, CT.ClaimID, CAST(CONVERT(CHAR(10),CT.PostingDate,110) AS DATETIME), CT.ClaimTransactionID, 'XXX', -1.00*Amount, 0 Unapplied, 
	CASE WHEN CurType='I' THEN Amount ELSE 0 END InsuranceBalance,
	CASE WHEN CurType='P' THEN Amount ELSE 0 END PatientBalance
	FROM ClaimTransaction CT INNER JOIN (SELECT DISTINCT PatientID, ClaimID FROM #ClaimAmounts) AnalysisClaims ON CT.PatientID=AnalysisClaims.PatientID AND CT.ClaimID=AnalysisClaims.ClaimID
	LEFT JOIN #Assignments A ON CT.ClaimID=A.ClaimID AND CT.ClaimTransactionID>A.StartID AND CT.ClaimTransactionID<A.EndID
	OR CT.ClaimID=A.ClaimID AND CT.ClaimTransactionID>A.StartID AND A.EndID IS NULL
	WHERE CT.PracticeID=@PracticeID AND CT.PostingDate BETWEEN @BeginDate AND @EndDate AND ClaimTransactionTypeCode='XXX'
	
	UPDATE CT SET DoctorID=E.DoctorID, LocationID=E.LocationID, DateOfService=EP.ProcedureDateOfService, ProcedureCode=PCD.ProcedureCode
	FROM #CurrentTrans CT 
	INNER JOIN Claim C 
		ON CT.ClaimID = C.ClaimID
	INNER JOIN EncounterProcedure EP 
		ON C.PracticeID = EP.PracticeID
		AND C.EncounterProcedureID = EP.EncounterProcedureID
	INNER JOIN Encounter E 
		ON EP.PracticeID = E.PracticeID
		AND EP.EncounterID = E.EncounterID
	INNER JOIN ProcedureCodeDictionary PCD 
		ON EP.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
	
	UPDATE CTs SET Notes=CAST(CT.Notes AS VARCHAR(500))
	FROM ClaimTransaction CT INNER JOIN #CurrentTrans CTs ON CT.ClaimTransactionID=CTs.ClaimTransactionID
	WHERE CTs.ClaimTransactionTypeCode='END'
	
	CREATE TABLE #SortedTrans(TID INT IDENTITY(1,1), PatientID INT, ClaimID INT, DoctorID INT, LocationID INT, DateOfService DATETIME, ProcedureCode VARCHAR(16), PostingDate DATETIME, PaymentID INT, RefundID INT, RefundDate DATETIME, InsuranceCompanyPlanID INT, ClaimTransactionID INT, 
				   ClaimTransactionTypeCode CHAR(3), Amount MONEY, Type CHAR(1), PayerType CHAR(1), Unapplied MONEY, InsuranceBalance MONEY, PatientBalance MONEY, Notes VARCHAR(500))
	INSERT INTO #SortedTrans(PatientID, ClaimID, DoctorID, LocationID, DateOfService, ProcedureCode, PostingDate, PaymentID, InsuranceCompanyPlanID, ClaimTransactionID, ClaimTransactionTypeCode, Amount, Type,
				 Unapplied, InsuranceBalance, PatientBalance, Notes)
	SELECT PatientID, ClaimID, DoctorID, LocationID, DateOfService, ProcedureCode, PostingDate, PaymentID, InsuranceCompanyPlanID, ClaimTransactionID, ClaimTransactionTypeCode, Amount, Type,
	Unapplied, InsuranceBalance, PatientBalance, Notes
	FROM #CurrentTrans
	ORDER BY PatientID, ISNULL(PostingDate,RefundDate), ClaimID, 
	CASE ClaimTransactionTypeCode WHEN 'CST' THEN 1
				      WHEN 'ASN' THEN 2
				      WHEN 'PMT' THEN 3
				      WHEN 'PAY' THEN 4
				      WHEN 'ADJ' THEN 5
				      WHEN 'END' THEN 6
				      WHEN 'RFD' THEN 7
				      WHEN 'XXX' THEN 8 END
							
	
	UPDATE ST SET Unapplied=Unapplied+ISNULL(InitialUnappliedAmount,0), InsuranceBalance=InsuranceBalance+ISNULL(InitialInsuranceBalance,0), PatientBalance=PatientBalance+ISNULL(InitialPatientBalance,0)
	FROM #SortedTrans ST INNER JOIN 
	(SELECT PatientID, MIN(TID) TID
	 FROM #SortedTrans
	 GROUP BY PatientID) STMin ON ST.PatientID=STMin.PatientID AND ST.TID=STMin.TID
	LEFT JOIN #BeginingBalances BB ON STMin.PatientID=BB.PatientID
	LEFT JOIN #InitialUnapplied IU ON STMin.PatientID=IU.PatientID
	
	CREATE TABLE #Balances(PatientID INT, TID INT, Unapplied MONEY, InsuranceBalance MONEY, PatientBalance MONEY)
	INSERT INTO #Balances(PatientID, TID, Unapplied, InsuranceBalance, PatientBalance)
	SELECT CT1.PatientID, CT1.TID, SUM(CT2.Unapplied), SUM(CT2.InsuranceBalance), SUM(CT2.PatientBalance)
	FROM #SortedTrans CT1 INNER JOIN #SortedTrans CT2 ON CT1.PatientID=CT2.PatientID AND CT1.TID>=CT2.TID
	GROUP BY CT1.PatientID, CT1.TID
	ORDER BY CT1.PatientID, CT1.TID
	
	SELECT ST.PatientID, 
	RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), '') ProviderFullname,
	RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) PatientFullname, DateOfService, 
	SL.Name LocationName, 
	CASE 	WHEN ClaimTransactionTypeCode='XXX' THEN '*** Void ***'
		WHEN ClaimTransactionTypeCode='PMT' THEN 'Received from patient'
		WHEN ClaimTransactionTypeCode='RFD' THEN 'Refund issued to patient'
		WHEN ClaimTransactionTypeCode='CST' THEN 'Charge created from encounter'
		WHEN ClaimTransactionTypeCode='PAY' AND PayerType='I' THEN 'Payment posted to claim from '+ICP.PlanName
		WHEN ClaimTransactionTypeCode='PAY' AND PayerType='P' THEN 'Payment posted to claim from patient'
		WHEN ClaimTransactionTypeCode='PAY' AND PayerType='O' THEN 'Payment posted to claim from other'
		WHEN ClaimTransactionTypeCode='ASN' AND Type='I' THEN 'Transfer to '+ICP.PlanName
		WHEN ClaimTransactionTypeCode='ASN' AND Type='P' THEN 'Transfer to patient'
		WHEN ClaimTransactionTypeCode='ADJ' AND Type='I' THEN ICP.PlanName+' Adjustment'
		WHEN ClaimTransactionTypeCode='ADJ' AND Type='P' THEN 'Patient Adjustment' 
		ELSE ST.Notes END Notes, PostingDate TransactionDate, 
	CASE ClaimTransactionTypeCode
		WHEN 'CST' THEN ClaimID
		WHEN 'PMT' THEN PaymentID
		WHEN 'RFD' THEN RefundID
	ELSE ClaimTransactionID END TransactionNumber, ProcedureCode, ClaimTransactionTypeCode,
	CASE ClaimTransactionTypeCode
		WHEN 'ADJ' THEN 'Adjustment'
		WHEN 'CST' THEN 'Charge'
		WHEN 'PMT' THEN 'Payment Received'
		WHEN 'PAY' THEN 'Payment Posted'
		WHEN 'ASN' THEN 'Transfer'
		WHEN 'RFD' THEN 'Refund'
		WHEN 'END' THEN 'Settled'
		WHEN 'XXX' THEN 'Void' END Type, Amount, B.Unapplied, B.InsuranceBalance, B.PatientBalance
	FROM #SortedTrans ST INNER JOIN #Balances B ON ST.TID=B.TID
	INNER JOIN Patient P ON ST.PatientID=P.PatientID
	LEFT JOIN InsuranceCompanyPlan ICP ON ST.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
	LEFT JOIN ServiceLocation SL ON SL.ServiceLocationID=ST.LocationID
	LEFT JOIN Doctor D ON ST.DoctorID=D.DoctorID
	ORDER BY P.PatientID, ISNULL(PostingDate,RefundDate), ClaimID, 
	CASE ClaimTransactionTypeCode WHEN 'CST' THEN 1
				      WHEN 'ASN' THEN 2
				      WHEN 'PMT' THEN 3
				      WHEN 'PAY' THEN 4
				      WHEN 'ADJ' THEN 5
				      WHEN 'END' THEN 6
				      WHEN 'RFD' THEN 7
				      WHEN 'XXX' THEN 8 END
	
	DROP TABLE #ClaimAmounts
	DROP TABLE #PastAppliedPayments
	DROP TABLE #PastRefundsToPayments
	DROP TABLE #Unapplied
	DROP TABLE #InitialUnapplied
	DROP TABLE #ClaimAssignments
	DROP TABLE #Assignments
	DROP TABLE #UpdateBal
	DROP TABLE #BeginingClaimBalances
	DROP TABLE #LastAssigned
	DROP TABLE #BeginingBalances
	DROP TABLE #CurrentTrans
	DROP TABLE #SortedTrans
	DROP TABLE #Balances
END


GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

