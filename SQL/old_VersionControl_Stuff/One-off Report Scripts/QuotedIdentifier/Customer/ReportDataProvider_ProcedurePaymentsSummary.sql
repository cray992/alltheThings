SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_ProcedurePaymentsSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_ProcedurePaymentsSummary]
GO

--===========================================================================
-- SRS Procedure Payments Summary
-- dbo.ReportDataProvider_ProcedurePaymentsSummary @practiceid=10, @begindate='1/1/2006', @enddate='3/22/2006'
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_ProcedurePaymentsSummary
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@ProcedureCode int = 0,
	@GroupByProvider bit = 1,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))

	DECLARE @ProcedureCodeText varchar(48)

	IF @ProcedureCode <> 0
		SELECT	@ProcedureCodeText = ProcedureCode
		FROM	ProcedureCodeDictionary
		WHERE	ProcedureCodeDictionaryID = @ProcedureCode
					
	CREATE TABLE #Charges(DoctorID INT, ProcedureCodeDictionaryID INT, Units INT, Charges MONEY)
	INSERT INTO #Charges(DoctorID, ProcedureCodeDictionaryID, Units, Charges)
	SELECT E.DoctorID, ProcedureCodeDictionaryID, ISNULL(ServiceUnitCount,1) Units, ISNULL(ServiceChargeAmount,0)*ISNULL(ServiceUnitCount,1) Charges
	FROM Claim C 
	INNER JOIN EncounterProcedure EP 
		ON EP.PracticeID = C.PracticeID
		AND C.EncounterProcedureID = EP.EncounterProcedureID
	INNER JOIN Encounter E 
		ON E.PracticeID = EP.PracticeID
		AND EP.EncounterID = E.EncounterID
	LEFT JOIN VoidedClaims VC 
		ON C.ClaimID=VC.ClaimID
	WHERE C.PracticeID = @PracticeID 
		AND ProcedureDateOfService BETWEEN @BeginDate AND @EndDate 
		AND VC.ClaimID IS NULL

	CREATE TABLE #Payments(ClaimID INT, PayerTypeCode CHAR(1), PayAmount MONEY)
	INSERT INTO #Payments(ClaimID, PayerTypeCode, PayAmount)
	SELECT CA.ClaimID, PayerTypeCode, SUM(CA.Amount) PayAmount
	FROM ClaimAccounting CA 
	INNER JOIN PaymentClaimTransaction PCT 
		ON PCT.PracticeID = CA.PracticeID
		AND CA.ClaimTransactionID = PCT.ClaimTransactionID
	INNER JOIN Payment P 
		ON P.PracticeID = PCT.PracticeID
		AND PCT.PaymentID = P.PaymentID
	WHERE CA.PracticeID = @PracticeID 
		AND CA.PostingDate BETWEEN @BeginDate AND @EndDate
		AND ClaimTransactionTypeCode='PAY' 
		AND PayerTypeCode IN ('I','P')
	GROUP BY CA.ClaimID, PayerTypeCode

	CREATE TABLE #Adjustments(ClaimID INT, ClaimTransactionID INT, Type CHAR(1), Amount MONEY)
	INSERT INTO #Adjustments(ClaimID, ClaimTransactionID, Amount)
	SELECT ClaimID, ClaimTransactionID, Amount
	FROM ClaimAccounting
	WHERE PracticeID=@PracticeID AND PostingDate BETWEEN @BeginDate AND @EndDate 
	AND ClaimTransactionTypeCode='ADJ' AND Amount<>0

	--Create the tables used to get the assignment type per transaction
	CREATE TABLE #Assignments(TID INT IDENTITY(1,1), ClaimID INT, Type CHAR(1), ClaimTransactionID INT)
	INSERT INTO #Assignments(ClaimID, Type, ClaimTransactionID)
	SELECT CAA.ClaimID, CASE WHEN InsurancePolicyID IS NULL THEN 'P' ELSE 'I' END Type, CAA.ClaimTransactionID
	FROM ClaimAccounting_Assignments CAA INNER JOIN (SELECT DISTINCT CLAIMID FROM #Adjustments) A
	ON CAA.ClaimID=A.ClaimID
	WHERE PracticeID=@PracticeID
	ORDER BY CAA.ClaimID, CAA.ClaimTransactionID
	
	CREATE TABLE #AssignmentsRange(ClaimID INT, Type CHAR(1), StartID INT, EndID INT)
	INSERT INTO #AssignmentsRange(ClaimID, Type, StartID, EndID)
	SELECT A.ClaimID, A.Type, A.ClaimTransactionID StartID, A2.ClaimTransactionID
	FROM #Assignments A LEFT JOIN #Assignments A2 ON A.ClaimID=A2.ClaimID
	AND A.TID+1=A2.TID

	UPDATE Adj SET Type=AR.Type
	FROM #Adjustments Adj INNER JOIN #AssignmentsRange AR 
	ON Adj.ClaimID=AR.ClaimID AND Adj.ClaimTransactionID>AR.StartID AND Adj.ClaimTransactionID<AR.EndID
	OR Adj.ClaimID=AR.ClaimID AND Adj.ClaimTransactionID>AR.StartID AND AR.EndID IS NULL
	
	CREATE TABLE #AdjustmentsSummary(ClaimID INT, Type CHAR(1), AdjAmount MONEY)
	INSERT INTO #AdjustmentsSummary(ClaimID, Type, AdjAmount)
	SELECT ClaimID, Type, SUM(Amount) AdjAmount
	FROM #Adjustments
	GROUP BY ClaimID, Type

	CREATE TABLE #ProcswTrans(DoctorID INT, ProcedureCodeDictionaryID INT, ClaimID INT, TransUnits INT)
	INSERT INTO #ProcswTrans(DoctorID, ProcedureCodeDictionaryID, ClaimID, TransUnits)
	SELECT E.DoctorID, ProcedureCodeDictionaryID, C.ClaimID, ISNULL(ServiceUnitCount,1) TransUnits
	FROM Claim C INNER JOIN (
	SELECT DISTINCT ClaimID
	FROM #Payments
	UNION
	SELECT DISTINCT ClaimID
	FROM #AdjustmentsSummary) CTrans 
		ON C.ClaimID=CTrans.ClaimID
	INNER JOIN EncounterProcedure EP 
		ON C.PracticeID = EP.PracticeID
		AND C.EncounterProcedureID=EP.EncounterProcedureID
	INNER JOIN Encounter E 
		ON EP.PracticeID = E.PracticeID
		AND EP.EncounterID = E.EncounterID


	CREATE TABLE #ReportResults(ProviderFullName VARCHAR(256), DoctorID INT, ProcedureCode VARCHAR(16),
				    ProcedureName VARCHAR(300), UnitCount INT, AvgCharges MONEY, TotalCharges MONEY,
				    AvgPaymentInsurance MONEY, AvgAdjustmentInsurance MONEY, AvgPaymentPatient MONEY,
				    AvgAdjustmentPatient MONEY, AvgPaymentTotal MONEY, AvgAdjustmentTotal MONEY)

	CREATE TABLE #ChargesSummary(DoctorID INT, ProcedureCode VARCHAR(16), ProcedureName VARCHAR(300), Units INT, Charges MONEY)

	IF @GroupByProvider = 1
	BEGIN

		INSERT INTO #ChargesSummary(DoctorID, ProcedureCode, ProcedureName, Units, Charges)
		SELECT C.DoctorID, ProcedureCode, PCD.OfficialName ProcedureName, SUM(Units) Units, SUM(Charges) Charges
		FROM #Charges C INNER JOIN ProcedureCodeDictionary PCD ON C.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
		GROUP BY C.DoctorID, ProcedureCode, PCD.OfficialName
	
		INSERT INTO #ReportResults(DoctorID, ProcedureCode, ProcedureName, AvgPaymentInsurance, AvgAdjustmentInsurance, AvgPaymentPatient,
					   AvgAdjustmentPatient, AvgPaymentTotal, AvgAdjustmentTotal)
		SELECT DoctorID, ProcedureCode, PCD.OfficialName ProcedureName, 
		--SUM(CASE WHEN PayerTypeCode='I' THEN PayAmount ELSE 0 END)/SUM(TransUnits) AvgPaymentInsurance,
		AVG(CASE WHEN PayerTypeCode='I' THEN PayAmount ELSE NULL END) AvgPaymentInsurance,
		--SUM(CASE WHEN Type='I' THEN AdjAmount ELSE 0 END)/SUM(TransUnits) AvgAdjustmentInsurance,
		AVG(CASE WHEN Type='I' THEN AdjAmount ELSE NULL END) AvgAdjustmentInsurance,
		--SUM(CASE WHEN PayerTypeCode='P' THEN PayAmount ELSE 0 END)/SUM(TransUnits) AvgPaymentPatient,
		AVG(CASE WHEN PayerTypeCode='P' THEN PayAmount ELSE NULL END) AvgPaymentPatient,
		--SUM(CASE WHEN Type='P' THEN AdjAmount ELSE 0 END)/SUM(TransUnits) AvgAdjustmentPatient,
		AVG(CASE WHEN Type='P' THEN AdjAmount ELSE NULL END) AvgAdjustmentPatient,
		--SUM(PayAmount)/SUM(TransUnits) AvgPaymentTotal,
		AVG(PayAmount) AvgPaymentTotal,
		--SUM(AdjAmount)/SUM(TransUnits) AvgAdjustmentTotal
		AVG(AdjAmount) AvgAdjustmentTotal
		FROM #ProcswTrans PT INNER JOIN ProcedureCodeDictionary PCD ON PT.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
		LEFT JOIN #Payments P ON PT.ClaimID=P.ClaimID
		LEFT JOIN #AdjustmentsSummary Adj ON PT.ClaimID=Adj.ClaimID
		GROUP BY DoctorID, ProcedureCode, PCD.OfficialName

		UPDATE RR SET UnitCount=Units, AvgCharges= case when units = 0 then 0 else Charges/Units end, TotalCharges=Charges
		FROM #ReportResults RR INNER JOIN #ChargesSummary CS ON RR.DoctorID=CS.DoctorID AND RR.ProcedureCode=CS.ProcedureCode
	
		INSERT INTO #ReportResults(DoctorID, ProcedureCode, ProcedureName, UnitCount, AvgCharges, TotalCharges)
		SELECT CS.DoctorID, CS.ProcedureCode, CS.ProcedureName, Units UnitCount, case when units = 0 then 0 else Charges/Units end AvgCharges, Charges TotalCharges
		FROM #ChargesSummary CS LEFT JOIN #ReportResults RR ON CS.DoctorID=RR.DoctorID AND CS.ProcedureCode=RR.ProcedureCode
		WHERE RR.ProcedureCode IS NULL	
		
		SELECT RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), '') AS ProviderFullname,
		D.DoctorID, ProcedureCode, ProcedureName, ISNULL(UnitCount,0) UnitCount, ISNULL(AvgCharges,0) AvgCharges, ISNULL(TotalCharges,0) TotalCharges, ISNULL(AvgPaymentInsurance,0) AvgPaymentInsurance,
		ISNULL(AvgAdjustmentInsurance,0) AvgAdjustmentInsurance, ISNULL(AvgPaymentPatient,0) AvgPaymentPatient, ISNULL(AvgAdjustmentPatient,0) AvgAdjustmentPatient, ISNULL(AvgPaymentTotal,0) AvgPaymentTotal,
		ISNULL(AvgAdjustmentTotal,0) AvgAdjustmentTotal
		FROM #ReportResults RR INNER JOIN Doctor D ON RR.DoctorID=D.DoctorID
		WHERE ((RR.DoctorID = @ProviderID) OR (ISNULL(@ProviderID,0) = 0)) AND
		(RR.ProcedureCode = @ProcedureCodeText or @ProcedureCodeText is null)
		
	END 
	ELSE
	BEGIN
		INSERT INTO #ChargesSummary(ProcedureCode, ProcedureName, Units, Charges)
		SELECT ProcedureCode, PCD.OfficialName ProcedureName, SUM(Units) Units, SUM(Charges) Charges
		FROM #Charges C INNER JOIN ProcedureCodeDictionary PCD ON C.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
		GROUP BY ProcedureCode, PCD.OfficialName
	
		INSERT INTO #ReportResults(ProcedureCode, ProcedureName, AvgPaymentInsurance, AvgAdjustmentInsurance, AvgPaymentPatient,
					   AvgAdjustmentPatient, AvgPaymentTotal, AvgAdjustmentTotal)
		SELECT ProcedureCode, PCD.OfficialName ProcedureName, 
		--SUM(CASE WHEN PayerTypeCode='I' THEN PayAmount ELSE 0 END)/SUM(TransUnits) AvgPaymentInsurance,
		AVG(CASE WHEN PayerTypeCode='I' THEN PayAmount ELSE NULL END) AvgPaymentInsurance,
		--SUM(CASE WHEN Type='I' THEN AdjAmount ELSE 0 END)/SUM(TransUnits) AvgAdjustmentInsurance,
		AVG(CASE WHEN Type='I' THEN AdjAmount ELSE NULL END) AvgAdjustmentInsurance,
		--SUM(CASE WHEN PayerTypeCode='P' THEN PayAmount ELSE 0 END)/SUM(TransUnits) AvgPaymentPatient,
		AVG(CASE WHEN PayerTypeCode='P' THEN PayAmount ELSE NULL END) AvgPaymentPatient,
		--SUM(CASE WHEN Type='P' THEN AdjAmount ELSE 0 END)/SUM(TransUnits) AvgAdjustmentPatient,
		AVG(CASE WHEN Type='P' THEN AdjAmount ELSE NULL END) AvgAdjustmentPatient,
		--SUM(PayAmount)/SUM(TransUnits) AvgPaymentTotal,
		AVG(PayAmount) AvgPaymentTotal,
		--SUM(AdjAmount)/SUM(TransUnits) AvgAdjustmentTotal
		AVG(AdjAmount) AvgAdjustmentTotal
		FROM #ProcswTrans PT INNER JOIN ProcedureCodeDictionary PCD ON PT.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
		LEFT JOIN #Payments P ON PT.ClaimID=P.ClaimID
		LEFT JOIN #AdjustmentsSummary Adj ON PT.ClaimID=Adj.ClaimID
		GROUP BY ProcedureCode, PCD.OfficialName
	
		UPDATE RR SET UnitCount=Units, AvgCharges= case when units = 0 then 0 else Charges/Units end, TotalCharges=Charges
		FROM #ReportResults RR INNER JOIN #ChargesSummary CS ON RR.ProcedureCode=CS.ProcedureCode
	
		INSERT INTO #ReportResults(ProcedureCode, ProcedureName, UnitCount, AvgCharges, TotalCharges)
		SELECT CS.ProcedureCode, CS.ProcedureName, Units UnitCount, case when units = 0 then 0 else Charges/Units end AvgCharges, Charges TotalCharges
		FROM #ChargesSummary CS LEFT JOIN #ReportResults RR ON CS.ProcedureCode=RR.ProcedureCode
		WHERE RR.ProcedureCode IS NULL	
		
		SELECT ProcedureCode, ProcedureName, ISNULL(UnitCount,0) UnitCount, ISNULL(AvgCharges,0) AvgCharges, ISNULL(TotalCharges,0) TotalCharges, ISNULL(AvgPaymentInsurance,0) AvgPaymentInsurance,
		ISNULL(AvgAdjustmentInsurance,0) AvgAdjustmentInsurance, ISNULL(AvgPaymentPatient,0) AvgPaymentPatient, ISNULL(AvgAdjustmentPatient,0) AvgAdjustmentPatient, ISNULL(AvgPaymentTotal,0) AvgPaymentTotal,
		ISNULL(AvgAdjustmentTotal,0) AvgAdjustmentTotal
		FROM #ReportResults RR
		WHERE (RR.ProcedureCode = @ProcedureCodeText or @ProcedureCodeText is null)
	END
		
	DROP TABLE #Charges
	DROP TABLE #Payments
	DROP TABLE #Assignments
	DROP TABLE #AssignmentsRange
	DROP TABLE #Adjustments
	DROP TABLE #AdjustmentsSummary
	DROP TABLE #ProcswTrans
	DROP TABLE #ChargesSummary
	DROP TABLE #ReportResults
			
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

