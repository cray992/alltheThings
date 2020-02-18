SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_PatientBalanceDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_PatientBalanceDetail]
GO


CREATE PROCEDURE dbo.ReportDataProvider_PatientBalanceDetail
	@PracticeID INT = NULL,
	@PatientID INT,
	@EndDate datetime = NULL,
	@ReportType CHAR(1) = 'O' --'O' Open service lines only (Default), 'A' Al Service Lines
AS
BEGIN
	SET NOCOUNT ON
	
	CREATE TABLE #AR (ClaimID INT, Amount MONEY)
	INSERT INTO #AR(ClaimID, Amount)
	SELECT ClaimID, SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)+
	SUM(CASE WHEN ClaimTransactionTypeCode<>'CST' THEN Amount*-1 ELSE 0 END)
	FROM ClaimAccounting
	WHERE PracticeID=@PracticeID AND PatientID=@PatientID AND PostingDate<=@EndDate
	GROUP BY ClaimID
	HAVING ((@ReportType='O' AND (SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)+
	SUM(CASE WHEN ClaimTransactionTypeCode<>'CST' THEN Amount*-1 ELSE 0 END)) <> 0) OR (@ReportType='A'))
	
	--Get Last Assignments
	CREATE TABLE #ASNMax (ClaimID INT, ClaimTransactionID INT)
	INSERT INTO #ASNMax(ClaimID, ClaimTransactionID)
	SELECT CAA.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM ClaimAccounting_Assignments CAA INNER JOIN #AR AR ON CAA.ClaimID=AR.ClaimID
	WHERE PracticeID=@PracticeID AND CAA.PatientID=@PatientID AND PostingDate<=@EndDate
	GROUP BY CAA.ClaimID
	
	CREATE TABLE #ASN (ClaimID INT, PatientID INT, TypeGroup INT)
	INSERT INTO #ASN(ClaimID, PatientID, TypeGroup)
	SELECT CAA.ClaimID, CAA.PatientID,
	CASE WHEN ICP.InsuranceCompanyPlanID IS NULL THEN 2 ELSE 1 END TypeGroup
	FROM ClaimAccounting_Assignments CAA INNER JOIN #ASNMax AM ON CAA.ClaimID=AM.ClaimID AND CAA.ClaimTransactionID=AM.ClaimTransactionID
	LEFT JOIN InsuranceCompanyPlan ICP ON CAA.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
	WHERE CAA.PracticeID=@PracticeID AND CAA.PatientID=@PatientID AND CAA.PostingDate<=@EndDate

	SELECT C.ClaimID, ProcedureDateOfService, ProcedureCode, PCD.OfficialName ProcedureName, 
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
	FROM #ASN A 
	INNER JOIN ClaimAccounting CAA
		ON A.PatientID = CAA.PatientID 
		AND A.ClaimID = CAA.ClaimID
	LEFT JOIN PaymentClaimTransaction PCT
		ON CAA.PracticeID = PCT.PracticeID
		AND CAA.ClaimTransactionID=PCT.ClaimTransactionID
	LEFT JOIN Payment P
		ON P.PracticeID = PCT.PracticeID
		AND PCT.PaymentID=P.PaymentID
	INNER JOIN Claim C
		ON C.PracticeID = CAA.PracticeID
		AND A.ClaimID = C.ClaimID
	INNER JOIN EncounterProcedure EP
		ON EP.PracticeID = C.PracticeID
		AND C.EncounterProcedureID = EP.EncounterProcedureID
	INNER JOIN ProcedureCodeDictionary PCD
		ON EP.ProcedureCodeDictionaryID = PCD.ProcedureCodeDictionaryID
	WHERE CAA.PracticeID = @PracticeID 
		AND CAA.PatientID = @PatientID 
		AND CAA.PostingDate <= @EndDate
	GROUP BY C.ClaimID, ProcedureDateOfService, ProcedureCode, PCD.OfficialName
	ORDER BY ProcedureDateOfService, ProcedureCode, PCD.OfficialName

	DROP TABLE #AR
	DROP TABLE #ASN
	DROP TABLE #ASNMax
	-- DROP TABLE #PatientsInReport

	RETURN
END


GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

