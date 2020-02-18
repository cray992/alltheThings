SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_PatientHistory]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_PatientHistory]
GO


CREATE PROCEDURE dbo.ReportDataProvider_PatientHistory
	@PracticeID int = NULL,
	@PatientID int = 0,
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
	WHERE PracticeID=@PracticeID AND PostingDate <= @EndDate AND ClaimTransactionTypeCode NOT IN ('BLL')
	AND ((PatientID=@PatientID) OR (@PatientID=0))
	
	UPDATE CA SET PaymentID=P.PaymentID, PayerTypeCode=P.PayerTypeCode
	FROM #ClaimAmounts CA INNER JOIN PaymentClaimTransaction PCT ON CA.ClaimTransactionID=PCT.ClaimTransactionID
	INNER JOIN Payment P ON PCT.PaymentID=P.PaymentID
	WHERE ClaimTransactionTypeCode='PAY'
	
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
	SELECT PayerID PatientID, RefundID, CAST(CONVERT(CHAR(10),RTP.PostingDate,110) AS DATETIME), 'RFD', Amount, -1.00*Amount, 0, 0
	FROM RefundToPayments RTP INNER JOIN Payment P ON RTP.PaymentID=P.PaymentID
	INNER JOIN (SELECT DISTINCT PatientID FROM #ClaimAmounts) AnalysisPatients ON P.PayerID=AnalysisPatients.PatientID
	WHERE P.PayerTypeCode='P' AND RTP.PostingDate BETWEEN @BeginDate AND @EndDate
	
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
		ON C.PracticeID = @PracticeID
		AND CT.ClaimID=C.ClaimID
	INNER JOIN EncounterProcedure EP 
		ON EP.PracticeID = @PracticeID
		AND C.EncounterProcedureID = EP.EncounterProcedureID
	INNER JOIN ProcedureCodeDictionary PCD ON EP.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
	INNER JOIN Encounter E 
		ON E.PracticeID = @PracticeID
		AND EP.EncounterID=E.EncounterID
	
	UPDATE CTs SET Notes=CAST(CT.Notes AS VARCHAR(500))
	FROM ClaimTransaction CT INNER JOIN #CurrentTrans CTs ON CT.ClaimTransactionID=CTs.ClaimTransactionID
	WHERE CTs.ClaimTransactionTypeCode='END'
	
	CREATE TABLE #SortedTrans(TID INT IDENTITY(1,1), Sort INT, PatientID INT, ClaimID INT, DoctorID INT, LocationID INT, DateOfService DATETIME, ProcedureCode VARCHAR(16), PostingDate DATETIME, PaymentID INT, RefundID INT, RefundDate DATETIME, InsuranceCompanyPlanID INT, ClaimTransactionID INT, 
				   ClaimTransactionTypeCode CHAR(3), Amount MONEY, Type CHAR(1), PayerType CHAR(1), Unapplied MONEY, InsuranceBalance MONEY, PatientBalance MONEY, Notes VARCHAR(500))
	INSERT INTO #SortedTrans(Sort, PatientID, ClaimID, DoctorID, LocationID, DateOfService, ProcedureCode, PostingDate, PaymentID, InsuranceCompanyPlanID, ClaimTransactionID, ClaimTransactionTypeCode, Amount, Type,
				 Unapplied, InsuranceBalance, PatientBalance, Notes)
	SELECT CASE ClaimTransactionTypeCode WHEN 'CST' THEN 1
				      WHEN 'ASN' THEN 2
				      WHEN 'PMT' THEN 3
				      WHEN 'PAY' THEN 4
				      WHEN 'ADJ' THEN 5
				      WHEN 'END' THEN 6
				      WHEN 'RFD' THEN 7
				      WHEN 'XXX' THEN 8 END Sort, PatientID, ClaimID, DoctorID, LocationID, DateOfService, ProcedureCode, PostingDate, PaymentID, InsuranceCompanyPlanID, ClaimTransactionID, ClaimTransactionTypeCode, Amount, Type,
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
	
	CREATE TABLE #ReportResults(TID INT, Sort INT, PatientID INT, ProviderFullName VARCHAR(256), PatientFullName VARCHAR(256), DateOfService DATETIME, 
				    LocationName VARCHAR(128), Notes VARCHAR(500), TransactionDate DATETIME, TransactionNumber INT, ProcedureCode VARCHAR(16), ClaimTransactionTypeCode CHAR(3),
				    Type VARCHAR(50), Amount MONEY, Unapplied MONEY, InsuranceBalance MONEY, PatientBalance MONEY)
	INSERT INTO #ReportResults(TID, Sort, PatientID, ProviderFullName, PatientFullName, DateOfService, LocationName, Notes, TransactionDate, TransactionNumber, ProcedureCode, ClaimTransactionTypeCode,
				  Type, Amount, Unapplied, InsuranceBalance, PatientBalance)
	SELECT ST.TID, Sort, ST.PatientID, 
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
		ELSE ST.Notes END Notes, PostingDate, 
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
	INNER JOIN Patient P 
		ON P.PracticeID = @PracticeID
		AND ST.PatientID=P.PatientID
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

	--Insert Patient Creation Info
	INSERT INTO #ReportResults(Sort, PatientID, PatientFullName, TransactionDate, Notes, TransactionNumber, ProcedureCode, Type)
	SELECT -4, P.PatientID, RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) PatientFullname, 
	CAST(CONVERT(CHAR(10),P.CreatedDate,110) AS DATETIME) TransactionDate, 'Patient entered into system' Notes, P.PatientID TransactionNumber, 'n/a' ProcedureCode, 'Created' Type
	FROM Patient P INNER JOIN (SELECT DISTINCT PatientID FROM #ReportResults) RR ON P.PatientID=RR.PatientID
	WHERE PracticeID=@PracticeID AND P.CreatedDate BETWEEN @BeginDate AND @EndDate

	--Insert Appointment Info
	CREATE TABLE #Appointments(Sort INT, PatientID INT, PatientFullName VARCHAR(256), TransactionDate DATETIME, Notes VARCHAR(500), TransactionNumber INT, ProcedureCode VARCHAR(16),
				   DateOfService DATETIME, ProviderFullName VARCHAR(256), LocationName VARCHAR(100), Type VARCHAR(50))
	INSERT INTO #Appointments(Sort, PatientID, PatientFullName, TransactionDate, Notes, TransactionNumber, ProcedureCode, DateOfService, ProviderFullName, LocationName, Type)
	SELECT -3, A.PatientID, RR.PatientFullName, A.CreatedDate TransactionDate, 'Patient Appointment' Notes, AppointmentID TransactionNumber, 'n/a' ProcedureCode, StartDate DateOfService,
	NULL, ISNULL(SL.Name,'n/a') LocationName, 'Appointment' Type
	FROM Appointment A INNER JOIN (SELECT DISTINCT PatientID, PatientFullName FROM #ReportResults WHERE PatientFullName IS NOT NULL) RR
	ON A.PracticeID=@PracticeID AND A.PatientID=RR.PatientID
	INNER JOIN ServiceLocation SL ON A.ServiceLocationID=SL.ServiceLocationID
	WHERE A.CreatedDate BETWEEN @BeginDate AND @EndDate
	 
	UPDATE A SET ProviderFullName=ISNULL(RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), ''),'n/a')
	FROM AppointmentToResource ATR INNER JOIN 
	(SELECT TransactionNumber AppointmentID, MIN(AppointmentToResourceID) MIN_ID 
	 FROM AppointmentToResource ATR INNER JOIN #Appointments A ON ATR.AppointmentResourceTypeID=1 AND ATR.AppointmentID=A.TransactionNumber
	 GROUP BY TransactionNumber) MIN_ATR ON ATR.AppointmentToResourceID=MIN_ATR.MIN_ID
	INNER JOIN Doctor D ON ATR.ResourceID=D.DoctorID
	INNER JOIN #Appointments A ON ATR.AppointmentID=A.TransactionNumber

	INSERT INTO #ReportResults(Sort, PatientID, PatientFullName, TransactionDate, Notes, TransactionNumber, ProcedureCode, DateOfService, ProviderFullName, LocationName, Type)	
	SELECT Sort, PatientID, PatientFullName, CAST(CONVERT(CHAR(10),TransactionDate,110) AS DATETIME), Notes, TransactionNumber, ProcedureCode, DateOfService, ProviderFullName, LocationName, Type
	FROM #Appointments

	--Insert Encounters
	INSERT INTO #ReportResults(Sort, PatientID, PatientFullName, TransactionDate, Notes, TransactionNumber, ProcedureCode, DateOfService, ProviderFullName, LocationName, Type)		
	SELECT -2, E.PatientID, RR.PatientFullName, CAST(CONVERT(CHAR(10),E.CreatedDate,110) AS DATETIME) TransactionDate, 'Encounter entered' Notes, E.EncounterID TransactionNumber, 'n/a' ProcedureCode, CAST(CONVERT(CHAR(10),E.DateOfService,110) AS DATETIME),
	RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), '') ProviderFullname,
	ISNULL(SL.Name, 'n/a') LocationName, 'Encounter' Type
	FROM Encounter E INNER JOIN (SELECT DISTINCT PatientID, PatientFullName FROM #ReportResults WHERE PatientFullName IS NOT NULL) RR
	ON E.PracticeID=@PracticeID AND E.PatientID=RR.PatientID
	INNER JOIN Doctor D ON E.DoctorID=D.DoctorID
	INNER JOIN ServiceLocation SL ON E.LocationID=SL.ServiceLocationID
	WHERE E.CreatedDate BETWEEN @BeginDate AND @EndDate

	--Insert EDI Bill Transactions
	INSERT INTO #ReportResults(Sort, PatientID, PatientFullName, TransactionDate, Notes, TransactionNumber, ProcedureCode, Type)		
	SELECT -1, RR.PatientID, RR.PatientFullName, CAST(CONVERT(CHAR(10),BB.CreatedDate,110) AS DATETIME) TransactionDate, 'EDI bill to ' + COALESCE(ICP.PlanName,'Insurance') Notes, 
	BE.BillID TransactionNumber, 'n/a' ProcedureCode, 'Insurance Billed' Type
	FROM BillBatch BB INNER JOIN Bill_EDI BE ON BB.PracticeID=@PracticeID AND BB.BillBatchID=BE.BillBatchID AND BB.BillBatchTypeCode='E'
	INNER JOIN InsurancePolicy IP ON BE.PayerInsurancePolicyID=IP.InsurancePolicyID
	INNER JOIN PatientCase PC ON PC.PracticeID=@PracticeID AND IP.PatientCaseID=PC.PatientCaseID
	INNER JOIN (SELECT DISTINCT PatientID, PatientFullName FROM #ReportResults WHERE PatientFullName IS NOT NULL) RR
	ON PC.PatientID=RR.PatientID
	INNER JOIN InsuranceCompanyPlan ICP ON IP.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
	WHERE BB.CreatedDate BETWEEN @BeginDate AND @EndDate AND BB.ConfirmedDate IS NOT NULL

	--HCFA Bill Transactions
	INSERT INTO #ReportResults(Sort, PatientID, PatientFullName, TransactionDate, Notes, TransactionNumber, ProcedureCode, Type)			
	SELECT 0, RR.PatientID, RR.PatientFullName, CAST(CONVERT(CHAR(10),DB.CreatedDate,110) AS DATETIME) TransactionDate, 'Paper bill to ' + COALESCE(ICP.PlanName,'Insurance') Notes,
	DH.Document_HCFAID TransactionNumber, 'n/a' ProcedureCode, 'Insurance Billed' Type
	FROM DocumentBatch DB INNER JOIN Document D ON DB.PracticeID=D.PracticeID AND DB.DocumentBatchID=D.DocumentBatchID
	INNER JOIN Document_HCFA DH ON D.PracticeID=DH.PracticeID AND D.DocumentID=DH.DocumentID
	INNER JOIN InsurancePolicy IP ON DH.PayerInsurancePolicyID=IP.InsurancePolicyID
	INNER JOIN PatientCase PC ON PC.PracticeID=@PracticeID AND IP.PatientCaseID=PC.PatientCaseID
	INNER JOIN (SELECT DISTINCT PatientID, PatientFullName FROM #ReportResults WHERE PatientFullName IS NOT NULL) RR
	ON PC.PatientID=RR.PatientID
	INNER JOIN InsuranceCompanyPlan ICP ON IP.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
	WHERE DB.CreatedDate BETWEEN @BeginDate AND @EndDate AND DB.ConfirmedDate IS NOT NULL

	SELECT PatientID, PatientFullName, TransactionDate CreatedDate, TransactionNumber Num, ProcedureCode ProcCode,
	DateOfService ServiceDate, ProviderFullName, LocationName, Type, Notes Description, Amount, Unapplied, InsuranceBalance, PatientBalance
	FROM #ReportResults
	ORDER BY PatientID, ISNULL(TransactionDate,DateOfService), TID, Sort

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
	DROP TABLE #ReportResults
	DROP TABLE #Appointments

	RETURN
	
END	


GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

