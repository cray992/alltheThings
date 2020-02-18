SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_PatientStatement]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_PatientStatement]
GO



create PROCEDURE [dbo].[ReportDataProvider_PatientStatement]
	@PracticeID INT = NULL,
	@PatientID INT,
	@EndDate datetime = NULL,
	@ReportType CHAR(1) = 'O', --'O' Open service lines only (Default), 'A' Al Service Lines
	@IncludeUnappliedPayments BIT
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
	SUM(CASE WHEN ClaimTransactionTypeCode<>'CST' THEN Amount*-1 ELSE 0 END))>0) OR (@ReportType='A'))
	
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

	CREATE TABLE #FinalResults (ClaimID INT, ProcedureDateOfService DATETIME, PostingDate DATETIME, ProcedureCode VARCHAR(16),
								ProcedureName VARCHAR(300), Charges MONEY, Adjustments MONEY, InsPay MONEY, PatPay MONEY,
								OtherPay MONEY, TotalBalance MONEY, PendingIns MONEY, PendingPat MONEY)

	INSERT INTO #FinalResults(ClaimID, ProcedureDateOfService, PostingDate, ProcedureCode, ProcedureName, Charges, Adjustments, InsPay,
							  PatPay, OtherPay, TotalBalance, PendingIns, PendingPat)
	SELECT C.ClaimID, ProcedureDateOfService, 
	min( case when caa.Status=0 AND caa.ClaimTransactionTypeCode='BLL' then caa.PostingDate else null end) as PostingDate, 
	ProcedureCode, lower(PCD.OfficialName) ProcedureName, 
	SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END) Charges,
	SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN Amount*-1 ELSE 0 END) Adjustments,
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='I' THEN Amount*-1 ELSE 0 END) InsPay,
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='P' THEN Amount*-1 ELSE 0 END) PatPay,
	SUM(CASE WHEN ClaimTransactionTypeCode='PAY' AND PayerTypeCode='O' THEN Amount*-1 ELSE 0 END) OtherPay,
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
		ON PCT.PracticeID = @PracticeID
		AND CAA.ClaimTransactionID=PCT.ClaimTransactionID
	LEFT JOIN Payment P
		ON P.PracticeID = @PracticeID
		AND PCT.PaymentID = P.PaymentID
	INNER JOIN Claim C
		ON C.PracticeID = @PracticeID
		AND A.ClaimID=C.ClaimID
	INNER JOIN EncounterProcedure EP
		ON EP.PracticeID = @PracticeID
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

	IF @IncludeUnappliedPayments = 1
	BEGIN
		DECLARE @TotalPayments MONEY

		SELECT @TotalPayments = SUM(PaymentAmount * -1)
		FROM Payment
		WHERE PracticeID = @PracticeID AND PayerID = @PatientID AND PayerTypeCode = 'P'

		DECLARE @AppliedPayments MONEY

		SELECT @AppliedPayments = SUM(PatPay)
		FROM #FinalResults

		INSERT INTO #FinalResults(ProcedureCode, ProcedureName, PatPay, PendingPat)
		VALUES('Other', 'Unapplied payments on account', @TotalPayments - @AppliedPayments, @TotalPayments - @AppliedPayments)
	END

	CREATE TABLE #FirstOtherPayments (ClaimID INT, PaymentID INT)

	-- Stores the info for the first other payment for each claim of a patient.
	INSERT INTO #FirstOtherPayments(ClaimID, PaymentID)
	SELECT FR.ClaimID, MIN(P.PaymentID)
	FROM #FinalResults FR
	LEFT JOIN PaymentClaimTransaction PCT ON FR.ClaimID = PCT.ClaimID
	LEFT JOIN Payment P ON PCT.PaymentID = P.PaymentID
	WHERE P.PayerTypeCode = 'O' OR P.PaymentTypeID = 4
	GROUP BY FR.ClaimID

	SELECT FR.ClaimID, ProcedureDateOfService, FR.PostingDate, ProcedureCode, ProcedureName, Charges, Adjustments, InsPay,
		   PatPay, OtherPay, TotalBalance, PendingIns, PendingPat, LOWER(ISNULL(O.OtherName, '')) AS FirstOtherPayNote
	FROM #FinalResults FR
	LEFT JOIN #FirstOtherPayments FOP ON FR.ClaimID = FOP.ClaimID
	LEFT JOIN Payment P ON FOP.PaymentID = P.PaymentID
	LEFT JOIN Other O ON P.PayerID = O.OtherID

	DROP TABLE #FirstOtherPayments
	DROP TABLE #FinalResults

	RETURN
END


GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

