SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].PatientDataProvider_GetActivities_ChargeSummary') and OBJECTPROPERTY(id, N'IsProcedure') = 1) drop procedure [dbo].PatientDataProvider_GetActivities_ChargeSummary
GO
-- dbo.PatientDataProvider_GetActivities_ChargeSummary 65, 328334, @ReportType = NULL

CREATE PROCEDURE dbo.PatientDataProvider_GetActivities_ChargeSummary
	@PracticeID INT,
	@PatientID INT,
	@BeginDate Datetime = NULL,
	@EndDate DateTime = NULL,
	@PatientCaseID INT = NULL,
	@ProviderID INT = NULL,

	@ReportType CHAR(1) = 'A' --'O' Open service lines only (Default), 'A' All Service Lines, 'S' Settled Service Lines Only
AS
/*

DECLARE
	@PracticeID INT,
	@PatientID INT,
	@BeginDate Datetime,
	@EndDate DateTime,
	@PatientCaseID INT,
	@ProviderID INT,

	@ReportType CHAR(1) --'O' Open service lines only (Default), 'A' Al Service Lines

SELECT
	@PracticeID = 65,
	@PatientID = 304980,

	@BeginDate  = NULL,
	@EndDate  = NULL,
	@PatientCaseID  = NULL,
	@ProviderID  = NULL,

	@ReportType = 'A' --'O' Open service lines only (Default), 'A' Al Service Lines
*/


BEGIN
	SET NOCOUNT OFF
	
	CREATE TABLE #AR (ClaimID INT, Amount MONEY)

	IF @ReportType <> 'A' and @ReportType IS NOT NULL
	BEGIN
		INSERT INTO #AR(ClaimID, Amount)

		SELECT ClaimID, SUM(Amount)
		FROM (
			SELECT ClaimID, SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE Amount*-1 END) as Amount
			FROM ClaimAccounting
			WHERE PracticeID=@PracticeID AND PatientID=@PatientID
			GROUP BY ClaimID, Status
			HAVING ( @ReportType <> 'O' OR SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE -1*Amount END) <> 0)
						AND ( @ReportType <> 'S' OR Status = 1 OR SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE -1*Amount END) = 0 )
			) as v
		GROUP BY ClaimID
	END


	

	CREATE TABLE #ASN (ClaimID INT, PatientID INT, TypeGroup INT, InsuranceCompanyPlanID INT)
	INSERT INTO #ASN(ClaimID, PatientID, TypeGroup, InsuranceCompanyPlanID)
	SELECT CAA.ClaimID, CAA.PatientID,
		CASE WHEN ICP.InsuranceCompanyPlanID IS NULL THEN 2 ELSE 1 END TypeGroup,
		ICP.InsuranceCompanyPlanID
	FROM ClaimAccounting_Assignments CAA 
		LEFT JOIN #AR ar on caa.ClaimID = ar.ClaimID
		LEFT JOIN InsuranceCompanyPlan ICP ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
	WHERE CAA.PracticeID=@PracticeID AND CAA.PatientID=@PatientID
		AND ( ISNULL(@ReportType, 'A') = 'A' OR ar.ClaimID is not null )
		AND  LastAssignment = 1


	SELECT C.ClaimID, ProcedureDateOfService, ProcedureCode,  ISNULL( PCD.LocalName, PCD.OfficialName) ProcedureName, 
		SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END) Charges,
		SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN Amount*-1 ELSE 0 END) Adjustments,
		SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='I' THEN Amount*-1 ELSE 0 END) InsPay,
		SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P' THEN Amount*-1 ELSE 0 END) PatPay,
		SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE Amount*-1 END) TotalBalance,
		SUM(CASE WHEN TypeGroup=1 AND ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)+
		SUM(CASE WHEN TypeGroup=1 AND ClaimTransactionTypeCode<>'CST' THEN Amount*-1 ELSE 0 END) PendingIns,
		SUM(CASE WHEN TypeGroup=2 AND ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)+
		SUM(CASE WHEN TypeGroup=2 AND ClaimTransactionTypeCode<>'CST' THEN Amount*-1 ELSE 0 END) PendingPat,
		E.LocationID,
		InsuranceCompanyPlanID,
		Pat.Gender, 
		Cast( 0 AS MONEY) as ExpectedReimbursement,
		ProcedureModifier1,
		ep.ProcedureCodeDictionaryID,
		ISNULL(EP.ServiceUnitCount,0) ServiceUnitCount
	INTO #Procedure	
	FROM #ASN A 
		INNER JOIN ClaimAccounting CAA ON A.PatientID=CAA.PatientID AND A.ClaimID=CAA.ClaimID
		LEFT JOIN PaymentClaimTransaction PCT ON CAA.ClaimTransactionID=PCT.ClaimTransactionID
		LEFT JOIN Payment P ON PCT.PaymentID=P.PaymentID
		INNER JOIN Claim C ON A.ClaimID=C.ClaimID
		INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
		INNER JOIN ProcedureCodeDictionary PCD ON EP.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
		INNER JOIN Encounter e on e.PracticeID = ep.PracticeID AND ep.EncounterID = e.EncounterID
		INNER JOIN Patient pat on pat.PatientID = e.patientID 
	WHERE CAA.PracticeID=@PracticeID AND CAA.PatientID=@PatientID

		AND ( @BeginDate IS NULL OR ProcedureDateOfService >= @BeginDate ) AND (@EndDate IS NULL OR ProcedureDateOfService <= @EndDate )
		AND ( @ProviderID IS NULL OR @ProviderID = e.DoctorID )
		AND ( @PatientCaseID IS NULL OR @PatientCaseID = e.PatientCaseID )

	GROUP BY C.ClaimID, ProcedureDateOfService, ProcedureCode, 
		ISNULL( PCD.LocalName, PCD.OfficialName), E.LocationID, InsuranceCompanyPlanID, Pat.Gender, 
		ProcedureModifier1, ep.ProcedureCodeDictionaryID, ISNULL(EP.ServiceUnitCount,0)



-- Calculate Expected Reimbursement

	CREATE TABLE #StandardContract(ClaimID INT, ContractID INT)
	INSERT INTO #StandardContract(ClaimID, ContractID)
	SELECT ClaimID, C.ContractID
	FROM #Procedure P 
		INNER JOIN Contract C ON C.PracticeID = @PracticeID AND C.ContractType='S'
		INNER JOIN ContractToServiceLocation CTSL ON C.ContractID=CTSL.ContractID AND P.LocationID=ServiceLocationID 
					AND ((P.ProcedureDateOfService BETWEEN C.EffectiveStartDate AND C.EffectiveEndDate) OR (C.EffectiveStartDate IS NULL))
	WHERE C.PracticeID = @PracticeID AND C.ContractType='S'


	CREATE TABLE #PayerContract(ClaimID INT, ContractID INT)
	INSERT INTO #PayerContract(ClaimID, ContractID)
	SELECT P.ClaimID, C.ContractID
	FROM #Procedure P 
		INNER JOIN Contract C ON C.ContractType='P'
		INNER JOIN ContractToServiceLocation CTSL ON C.ContractID=CTSL.ContractID AND P.LocationID=ServiceLocationID 
					AND ((P.ProcedureDateOfService BETWEEN C.EffectiveStartDate AND C.EffectiveEndDate) OR (C.EffectiveStartDate IS NULL))
		INNER JOIN ContractToInsurancePlan CTIP ON C.ContractID=CTIP.ContractID AND p.InsuranceCompanyPlanID=CTIP.PlanID
	WHERE C.PracticeID = @PracticeID


	UPDATE P SET ExpectedReimbursement=CFS.ExpectedReimbursement* ServiceUnitCount
	FROM #Procedure P INNER JOIN #StandardContract SC
	ON P.ClaimID =SC.ClaimID
	INNER JOIN ContractFeeSchedule CFS ON SC.ContractID=CFS.ContractID 
		AND P.ProcedureCodeDictionaryID=CFS.ProcedureCodeDictionaryID
		AND ((P.Gender=CFS.Gender) OR CFS.Gender='B')
		AND ((ISNULL(P.ProcedureModifier1,'')=ISNULL(CFS.Modifier,'')) OR CFS.Modifier IS NULL)

	UPDATE P SET ExpectedReimbursement=CFS.ExpectedReimbursement*ServiceUnitCount
	FROM #Procedure P INNER JOIN #PayerContract PC
	ON P.ClaimID=PC.ClaimID
	INNER JOIN ContractFeeSchedule CFS
	ON PC.ContractID=CFS.ContractID AND P.ProcedureCodeDictionaryID=CFS.ProcedureCodeDictionaryID
	AND ((P.Gender=CFS.Gender) OR CFS.Gender='B')
	AND ((ISNULL(P.ProcedureModifier1,'')=ISNULL(CFS.Modifier,'')) OR CFS.Modifier IS NULL)



	select convert(varchar, ProcedureDateOfService, 101) as ProcedureDateOfService, ProcedureCode + ' - ' + ProcedureName as Description, 
			ExpectedReimbursement, Charges, Adjustments, InsPay + PatPay AS Receipts, PendingPat, PendingIns, Totalbalance,
			ClaimID AS RefID, 10 HyperLinkID
	from #Procedure
	ORDER BY ProcedureDateOfService, Description

	DROP TABLE #AR
	DROP TABLE #ASN, #Procedure, #StandardContract, #PayerContract

	RETURN
END


GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

