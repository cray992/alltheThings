SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_ProcedureAnalysisSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_ProcedureAnalysisSummary]
GO


--===========================================================================
-- SRS Procedure Analysis Detail
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_ProcedureAnalysisSummary
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@InsuranceCompanyPlanID int = 0,
	@GroupByProvider bit = 1,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))
	
	CREATE TABLE #EncounterClaims(PatientCaseID INT, DoctorID INT, PatientID INT, LocationID INT, DateOfService DATETIME, Precedence INT, ClaimID INT, ProcedureCodeDictionaryID INT, TotalCharges MONEY)
	INSERT INTO #EncounterClaims(PatientCaseID, DoctorID, PatientID, LocationID, DateOfService, Precedence, ClaimID, ProcedureCodeDictionaryID, TotalCharges)
	SELECT E.PatientCaseID, E.DoctorID, E.PatientID, E.LocationID, E.DateOfService, dbo.fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence(E.PatientCaseID,EP.ProcedureDateOfService,0) Precendence, 
	C.ClaimID, ProcedureCodeDictionaryID, ISNULL(EP.ServiceUnitCount,0) * ISNULL(EP.ServiceChargeAmount,0) TotalCharges
	FROM Encounter E 
	INNER JOIN EncounterProcedure EP 
		ON EP.PracticeID = E.PracticeID
		AND E.EncounterID = EP.EncounterID
	LEFT JOIN Claim C 
		ON C.PracticeID = EP.PracticeID
		AND EP.EncounterProcedureID = C.EncounterProcedureID
	LEFT JOIN VoidedClaims VC ON C.ClaimID=VC.ClaimID
	WHERE E.PracticeID=@PracticeID AND E.DateOfService BETWEEN @BeginDate AND @EndDate
	AND ((E.DoctorID = @ProviderID) OR (ISNULL(@ProviderID,0) = 0))
	AND VC.ClaimID IS NULL
	
	CREATE TABLE #ClaimAmounts(ClaimID INT, Adjustments MONEY, Payments MONEY)
	INSERT INTO #ClaimAmounts(ClaimID, Adjustments, Payments)
	SELECT CA.ClaimID, SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN Amount ELSE NULL END) Adjustments,
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' THEN Amount ELSE NULL END) Payments
	FROM ClaimAccounting CA INNER JOIN #EncounterClaims EC ON CA.ClaimID=EC.ClaimID
	WHERE CA.PracticeID=@PracticeID AND ClaimTransactionTypeCode IN ('PAY','ADJ')
	GROUP BY CA.ClaimID
	
	IF @GroupByProvider = 1
	BEGIN

		SELECT EC.DoctorID, RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), '') AS ProviderFullname,
		ICP.PlanName, PCD.ProcedureCode, PCD.OfficialName ProcedureName, COUNT(EC.ClaimID) Qty,
		SUM(EC.TotalCharges) TotalCharges, AVG(EC.TotalCharges) AvgCharges, AVG(CA.Adjustments) AvgAdjustment, AVG(CA.Payments) AvgPayment
		FROM #EncounterClaims EC LEFT JOIN #ClaimAmounts CA ON EC.ClaimID=CA.ClaimID
		INNER JOIN Doctor D 
			ON D.PracticeID = @PracticeID
			AND EC.DoctorID = D.DoctorID
		INNER JOIN ProcedureCodeDictionary PCD ON EC.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
		LEFT JOIN InsurancePolicy IP ON EC.PatientCaseID=IP.PatientCaseID AND EC.Precedence=IP.Precedence
		LEFT JOIN InsuranceCompanyPlan ICP ON IP.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
		WHERE ((ICP.InsuranceCompanyPlanID = @InsuranceCompanyPlanID) OR ISNULL(@InsuranceCompanyPlanID,0)=0)
		GROUP BY EC.DoctorID, RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), ''),
		ICP.PlanName, PCD.ProcedureCode, PCD.OfficialName

	END
	ELSE
	BEGIN
		SELECT ICP.PlanName, PCD.ProcedureCode, PCD.OfficialName ProcedureName, COUNT(EC.ClaimID) Qty,
		SUM(EC.TotalCharges) TotalCharges, AVG(EC.TotalCharges) AvgCharges, AVG(CA.Adjustments) AvgAdjustment, AVG(CA.Payments) AvgPayment
		FROM #EncounterClaims EC LEFT JOIN #ClaimAmounts CA ON EC.ClaimID=CA.ClaimID
		INNER JOIN ProcedureCodeDictionary PCD ON EC.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
		LEFT JOIN InsurancePolicy IP ON EC.PatientCaseID=IP.PatientCaseID AND EC.Precedence=IP.Precedence
		LEFT JOIN InsuranceCompanyPlan ICP ON IP.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
		WHERE ((ICP.InsuranceCompanyPlanID = @InsuranceCompanyPlanID) OR ISNULL(@InsuranceCompanyPlanID,0)=0)
		GROUP BY ICP.PlanName, PCD.ProcedureCode, PCD.OfficialName
	END
	
	DROP TABLE #EncounterClaims
	DROP TABLE #ClaimAmounts
	
	RETURN

END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

