/*
Script created by SQL Compare from Red Gate Software Ltd at 10/11/2004 22:24:40
Run this script on kdb01.kareoprod.ent.superbill_prod to make it the same as k0.kareo.ent.superbill_merge
Please back up your database before running this script
*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
PRINT N'Creating [dbo].[DashboardReceiptsDisplay]'
GO
CREATE TABLE [dbo].[DashboardReceiptsDisplay]
(
[PracticeID] [int] NOT NULL,
[ID] [int] NOT NULL,
[Amount] [int] NULL,
[Period] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL
)

GO
PRINT N'Creating [dbo].[DashboardDataProvider_GetGraphDataForMedicalOffice]'
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.DashboardDataProvider_GetGraphDataForMedicalOffice
	@PracticeID int = 34
AS
BEGIN
	SELECT  
		Amount, 
		Period,
		ID
	FROM dbo.DashboardReceiptsDisplay
	WHERE PracticeID = @PracticeID
	ORDER BY ID
	
	RETURN
END

GO
PRINT N'Creating [dbo].[DashboardReceiptsVolatile]'
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DashboardReceiptsVolatile]
(
[PracticeID] [int] NOT NULL,
[ID] [int] NOT NULL,
[Amount] [int] NULL,
[Period] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL
)

GO
PRINT N'Creating [dbo].[DashboardDataProvider_GetARAging]'
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE dbo.DashboardDataProvider_GetARAging
	@PracticeID int = NULL
AS
BEGIN
	SET NOCOUNT ON
	--Select the type of payer for each section of the report
	DECLARE @EndDate datetime
	SET @EndDate = GETDATE()
	
	DECLARE @PayerTypeText varchar(128)
	
	CREATE TABLE #ARAgingSummary (
		TypeGroup varchar(128),	
		TypeSort int, 
		Num int,
		Type varchar(128),	
		Name varchar(256),
		Phone varchar(10),
		LastBilled datetime,
		LastPaid datetime,
		Unapplied money default(0),
		CurrentBalance money default(0),
		Age31_60 money default(0),
		Age61_90 money default(0),
		Age91_120 money default(0),
		AgeOver120 money default(0),
		TotalBalance money default(0)
		)
	
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))
	
	--================================================================================ 
	--Let's get the Insurance assigned information
	--================================================================================ 
	SET @PayerTypeText = 'Insurance'
	
	SELECT TClaimsWithARBalance.AssignedToID, 
		COUNT(TFB.ClaimID) ClaimCount, 
		AVG(DATEDIFF(d, TFB.FirstBilled, @EndDate)) AS ARAge, 
		SUM(TClaimsWithARBalance.Claim_ARBalance) AS ARBal,
		CASE 
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 0 and 30 THEN 1
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 31 and 60 THEN 2
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 61 and 90 THEN 3
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 91 and 120 THEN 4
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) >= 121  THEN 5
		END AS AgeGroup,
		MAX(TInsuranceLastBilled.LastBilled) AS LastBilled,
		MAX(TInsuranceLastPaid.LastPaid) AS LastPaid
	INTO #TInsuranceBalances
	FROM
		(
			SELECT CT.ClaimID, MIN(CT.CreatedDate) AS FirstBilled
			FROM dbo.ClaimTransaction CT
			WHERE CT.PracticeID = @PracticeID
				AND CT.CreatedDate <= @EndDate
				AND CT.ClaimTransactionTypeCode = 'BLL'
			GROUP BY CT.ClaimID
		) TFB 
		INNER JOIN
		(
			--We only want the claims whose most recent assignment was to insurance
			SELECT CT.AssignedToID, CT.ClaimID, CT.ClaimTransactionID, CT.Claim_ARBalance
			FROM dbo.ClaimTransaction CT
				INNER JOIN 
				(
					SELECT CT.ClaimID, MAX(CT.ClaimTransactionID) AS MaxTransID
					FROM dbo.ClaimTransaction CT
					WHERE CT.CreatedDate <= @EndDate
						AND CT.PracticeID = @PracticeID
					GROUP BY CT.ClaimID
				) AS T		
				ON CT.ClaimTransactionID = T.MaxTransID
			WHERE CT.CreatedDate <= @EndDate
				AND CT.PracticeID = @PracticeID
				AND CT.Claim_ARBalance > 0
				AND CT.AssignedToType = 'I'
		) TClaimsWithARBalance
		ON TFB.ClaimID = TClaimsWithARBalance.ClaimID
		--Get the last billed and last paid dates
		LEFT OUTER JOIN
		(
			SELECT CT.AssignedToID, MAX(CT.CreatedDate) AS LastBilled
			FROM dbo.ClaimTransaction CT
			WHERE CT.PracticeID = @PracticeID
				AND CT.CreatedDate <= @EndDate
				AND CT.ClaimTransactionTypeCode = 'BLL'
				AND CT.AssignedToType = 'I'
			GROUP BY CT.AssignedToID
		) TInsuranceLastBilled
		ON TClaimsWithARBalance.AssignedToID = TInsuranceLastBilled.AssignedToID
		LEFT OUTER JOIN
		(
			SELECT CT.AssignedToID, MAX(CT.CreatedDate) AS LastPaid
			FROM dbo.ClaimTransaction CT
			WHERE CT.PracticeID = @PracticeID
				AND CT.CreatedDate <= @EndDate
				AND CT.ClaimTransactionTypeCode = 'PAY'
				AND CT.AssignedToType = 'I'
			GROUP BY CT.AssignedToID
		) TInsuranceLastPaid
		ON TClaimsWithARBalance.AssignedToID = TInsuranceLastPaid.AssignedToID
	--WHERE C.PracticeID = @PracticeID
	GROUP BY TClaimsWithARBalance.AssignedToID,
		CASE 
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 0 and 30 THEN 1
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 31 and 60 THEN 2
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 61 and 90 THEN 3
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 91 and 120 THEN 4
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) >= 121  THEN 5
		END


	INSERT #ARAgingSummary(
		TypeGroup,	
		TypeSort, 
		Num,
		Type,	
		Name,
		Phone,
		LastBilled,
		LastPaid
	)
	SELECT distinct @PayerTypeText,
		1,
		TIB.AssignedToID,
		@PayerTypeText,
		ICP.PlanName AS Name,	
		ICP.Phone AS Phone,	
		LastBilled,
		LastPaid
	FROM #TInsuranceBalances TIB
		INNER JOIN dbo.InsuranceCompanyPlan ICP
		ON TIB.AssignedToID = ICP.InsuranceCompanyPlanID


	--Update the balances
	UPDATE ARAS
		SET CurrentBalance = TIB.ARBal
	FROM #ARAgingSummary ARAS
		INNER JOIN #TInsuranceBalances TIB
		ON ARAS.Num = TIB.AssignedToID
	WHERE AgeGroup = 1
		AND ARAS.Type = @PayerTypeText
		
	UPDATE ARAS
		SET Age31_60 = TIB.ARBal
	FROM #ARAgingSummary ARAS
		INNER JOIN #TInsuranceBalances TIB
		ON ARAS.Num = TIB.AssignedToID
	WHERE AgeGroup = 2
		AND ARAS.Type = @PayerTypeText
		
	UPDATE ARAS
		SET Age61_90 = TIB.ARBal
	FROM #ARAgingSummary ARAS
		INNER JOIN #TInsuranceBalances TIB
		ON ARAS.Num = TIB.AssignedToID
	WHERE AgeGroup = 3
		AND ARAS.Type = @PayerTypeText
		
	UPDATE ARAS
		SET Age91_120 = TIB.ARBal
	FROM #ARAgingSummary ARAS
		INNER JOIN #TInsuranceBalances TIB
		ON ARAS.Num = TIB.AssignedToID
	WHERE AgeGroup = 4
		AND ARAS.Type = @PayerTypeText

	UPDATE ARAS
		SET AgeOver120 = TIB.ARBal
	FROM #ARAgingSummary ARAS
		INNER JOIN #TInsuranceBalances TIB
		ON ARAS.Num = TIB.AssignedToID
	WHERE AgeGroup = 5
		AND ARAS.Type = @PayerTypeText
		
		
	--Unapplied Amount
	UPDATE ARAS
		SET Unapplied = TPMT.PaymentAmount
	FROM #ARAgingSummary ARAS
		INNER JOIN 
		(SELECT PMT.PayerID, SUM(PMT.PaymentAmount) AS PaymentAmount
		FROM [dbo].[Payment] PMT
		WHERE PMT.PaymentDate <= @EndDate
			AND PMT.PracticeID = @PracticeID
			AND PMT.PayerTypeCode = 'I'
		GROUP BY PMT.PayerID) AS TPMT
		ON ARAS.Num = TPMT.PayerID
	WHERE ARAS.Type = @PayerTypeText
		
	UPDATE ARAS
		SET Unapplied = ISNULL(Unapplied,0) - ISNULL(TAPP.AppliedAmount,0)
	FROM #ARAgingSummary ARAS
		INNER JOIN 
		(	SELECT PMT.PayerID, SUM(CT.Amount) AS AppliedAmount
			FROM [dbo].[Payment] PMT
				INNER JOIN [dbo].[PaymentClaimTransaction] PCT
				ON PMT.PaymentID = PCT.PaymentID
				INNER JOIN dbo.ClaimTransaction CT
				ON PCT.ClaimTransactionID = CT.ClaimTransactionID
			WHERE PMT.PaymentDate <= @EndDate
				AND PMT.PracticeID = @PracticeID
				AND PMT.PayerTypeCode = 'I'
				AND CT.PracticeID = @PracticeID
				AND CT.ClaimTransactionTypeCode = 'PAY'
				AND CT.CreatedDate <= @EndDate
			GROUP BY PMT.PayerID) AS TAPP
		ON ARAS.Num = TAPP.PayerID
	WHERE ARAS.Type = @PayerTypeText
			
	UPDATE ARAS
		SET Unapplied = ISNULL(Unapplied,0) - ISNULL(TRFD.RefundAmount,0)
	FROM #ARAgingSummary ARAS
		INNER JOIN 
		(	SELECT RecipientID, SUM(RefundAmount) AS RefundAmount
			FROM [dbo].[Refund]	RFD
			WHERE RFD.RecipientTypeCode = 'I'
				AND RFD.RefundDate <= @EndDate
				AND RFD.PracticeID = @PracticeID
			GROUP BY RecipientID) AS TRFD
		ON ARAS.Num = TRFD.RecipientID
	WHERE ARAS.Type = @PayerTypeText
			

	--================================================================================ 
	--Let's get the patient assigned information
	--================================================================================ 
	SET @PayerTypeText = 'Patient'
	
	SELECT C.PatientID, 
		COUNT(TFB.ClaimID) ClaimCount, 
		AVG(DATEDIFF(d, TFB.FirstBilled, @EndDate)) AS ARAge, 
		SUM(TClaimsWithARBalance.Claim_ARBalance) AS ARBal,
		CASE 
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 0 and 30 THEN 1
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 31 and 60 THEN 2
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 61 and 90 THEN 3
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 91 and 120 THEN 4
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) >= 121  THEN 5
		END AS AgeGroup,
		MAX(TPatientLastBilled.LastBilled) AS LastBilled,
		MAX(TPatientLastPaid.LastPaid) AS LastPaid
	INTO #TPatientBalances
	FROM
		(
			SELECT CT.ClaimID, MIN(CT.CreatedDate) AS FirstBilled
			FROM dbo.ClaimTransaction CT
			WHERE CT.PracticeID = @PracticeID
				AND CT.CreatedDate <= @EndDate
				AND CT.ClaimTransactionTypeCode = 'BLL'
			GROUP BY CT.ClaimID
		) TFB 
		INNER JOIN
		(
			SELECT CT.ClaimID, CT.ClaimTransactionID, CT.Claim_ARBalance
			FROM dbo.ClaimTransaction CT
				INNER JOIN 
				(
					SELECT CT.ClaimID, MAX(CT.ClaimTransactionID) AS MaxTransID
					FROM dbo.ClaimTransaction CT
					WHERE CT.CreatedDate <= @EndDate
						AND CT.PracticeID = @PracticeID
					GROUP BY CT.ClaimID
				) AS T		
				ON CT.ClaimTransactionID = T.MaxTransID
			WHERE CT.CreatedDate <= @EndDate
				AND CT.PracticeID = @PracticeID
				AND CT.Claim_ARBalance > 0
		) TClaimsWithARBalance
		ON TFB.ClaimID = TClaimsWithARBalance.ClaimID
		INNER JOIN dbo.Claim C
		ON TFB.ClaimID = C.ClaimID
		--Get the last billed and last paid amounts
		LEFT OUTER JOIN
		(
			SELECT CT.PatientID, MAX(CT.CreatedDate) AS LastBilled
			FROM dbo.ClaimTransaction CT
			WHERE CT.PracticeID = @PracticeID
				AND CT.CreatedDate <= @EndDate
				AND CT.ClaimTransactionTypeCode = 'BLL'
			GROUP BY CT.PatientID
		) TPatientLastBilled
		ON C.PatientID = TPatientLastBilled.PatientID
		LEFT OUTER JOIN
		(
			SELECT CT.PatientID, MAX(CT.CreatedDate) AS LastPaid
			FROM dbo.ClaimTransaction CT
			WHERE CT.PracticeID = @PracticeID
				AND CT.CreatedDate <= @EndDate
				AND CT.ClaimTransactionTypeCode = 'PAY'
			GROUP BY CT.PatientID
		) TPatientLastPaid
		ON C.PatientID = TPatientLastPaid.PatientID

	WHERE C.PracticeID = @PracticeID
		AND C.AssignmentIndicator = 'P'
	GROUP BY C.PatientID,
		CASE 
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 0 and 30 THEN 1
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 31 and 60 THEN 2
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 61 and 90 THEN 3
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 91 and 120 THEN 4
			WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) >= 121  THEN 5
		END


	INSERT #ARAgingSummary(
		TypeGroup,	
		TypeSort, 
		Num,
		Type,	
		Name,
		Phone,
		LastBilled,
		LastPaid
	)
	SELECT distinct @PayerTypeText,
		2,
		TPB.PatientID,
		@PayerTypeText,
		RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) AS Name,	
		P.HomePhone AS Phone,	
		LastBilled,
		LastPaid
	FROM #TPatientBalances TPB
		INNER JOIN dbo.Patient P
		ON TPB.PatientID = P.PatientID


	--Update the balances
	UPDATE ARAS
		SET CurrentBalance = TPB.ARBal
	FROM #ARAgingSummary ARAS
		INNER JOIN #TPatientBalances TPB
		ON ARAS.Num = TPB.PatientID
	WHERE AgeGroup = 1
		AND ARAS.Type = @PayerTypeText
		
	UPDATE ARAS
		SET Age31_60 = TPB.ARBal
	FROM #ARAgingSummary ARAS
		INNER JOIN #TPatientBalances TPB
		ON ARAS.Num = TPB.PatientID
	WHERE AgeGroup = 2
		AND ARAS.Type = @PayerTypeText
		
	UPDATE ARAS
		SET Age61_90 = TPB.ARBal
	FROM #ARAgingSummary ARAS
		INNER JOIN #TPatientBalances TPB
		ON ARAS.Num = TPB.PatientID
	WHERE AgeGroup = 3
		AND ARAS.Type = @PayerTypeText
		
	UPDATE ARAS
		SET Age91_120 = TPB.ARBal
	FROM #ARAgingSummary ARAS
		INNER JOIN #TPatientBalances TPB
		ON ARAS.Num = TPB.PatientID
	WHERE AgeGroup = 4
		AND ARAS.Type = @PayerTypeText

	UPDATE ARAS
		SET AgeOver120 = TPB.ARBal
	FROM #ARAgingSummary ARAS
		INNER JOIN #TPatientBalances TPB
		ON ARAS.Num = TPB.PatientID
	WHERE AgeGroup = 5
		AND ARAS.Type = @PayerTypeText
		
		
	--Unapplied Amount
	UPDATE ARAS
		SET Unapplied = TPMT.PaymentAmount
	FROM #ARAgingSummary ARAS
		INNER JOIN 
		(SELECT PMT.PayerID, SUM(PMT.PaymentAmount) AS PaymentAmount
		FROM [dbo].[Payment] PMT
		WHERE PMT.PaymentDate <= @EndDate
			AND PMT.PracticeID = @PracticeID
			AND PMT.PayerTypeCode = 'P'
		GROUP BY PMT.PayerID) AS TPMT
		ON ARAS.Num = TPMT.PayerID
	WHERE ARAS.Type = @PayerTypeText
		
	UPDATE ARAS
		SET Unapplied = ISNULL(Unapplied,0) - ISNULL(TAPP.AppliedAmount,0)
	FROM #ARAgingSummary ARAS
		INNER JOIN 
		(	SELECT PMT.PayerID, SUM(CT.Amount) AS AppliedAmount
			FROM [dbo].[Payment] PMT
				INNER JOIN [dbo].[PaymentClaimTransaction] PCT
				ON PMT.PaymentID = PCT.PaymentID
				INNER JOIN dbo.ClaimTransaction CT
				ON PCT.ClaimTransactionID = CT.ClaimTransactionID
			WHERE PMT.PaymentDate <= @EndDate
				AND PMT.PracticeID = @PracticeID
				AND PMT.PayerTypeCode = 'P'
				AND CT.PracticeID = @PracticeID
				AND CT.CreatedDate <= @EndDate
				AND CT.ClaimTransactionTypeCode = 'PAY'
			GROUP BY PMT.PayerID) AS TAPP
		ON ARAS.Num = TAPP.PayerID
	WHERE ARAS.Type = @PayerTypeText
				
	UPDATE ARAS
		SET Unapplied = ISNULL(Unapplied,0) - ISNULL(TRFD.RefundAmount,0)
	FROM #ARAgingSummary ARAS
		INNER JOIN 
		(	SELECT RecipientID, SUM(RefundAmount) AS RefundAmount
			FROM [dbo].[Refund]	RFD
			WHERE RFD.RecipientTypeCode = 'P'
				AND RFD.RefundDate <= @EndDate
				AND RFD.PracticeID = @PracticeID
			GROUP BY RecipientID) AS TRFD
		ON ARAS.Num = TRFD.RecipientID
	WHERE ARAS.Type = @PayerTypeText

	--================================================================================ 
	--Let's get the Other payer information
	--================================================================================ 
	SET @PayerTypeText = 'Other'
			
	INSERT #ARAgingSummary(
		TypeGroup,	
		TypeSort, 
		Num,
		Type,	
		Name,
		Unapplied
	)
	SELECT distinct @PayerTypeText,
		3,
		PMT.PayerID,
		@PayerTypeText,
		O.OtherName AS Name,	
		SUM(PMT.PaymentAmount)
	FROM dbo.Payment PMT 
		INNER JOIN dbo.Other O
		ON PMT.PayerID = O.OtherID
			AND PMT.PayerTypeCode = 'O'
	WHERE PMT.PracticeID = @PracticeID
		AND PMT.PaymentDate <= @EndDate
	GROUP BY PMT.PayerID, O.OtherName
		
	--Unapplied Amount
	UPDATE ARAS
		SET Unapplied = ISNULL(Unapplied,0) - ISNULL(TAPP.AppliedAmount,0),
			LastPaid = TAPP.LastPaid
	FROM #ARAgingSummary ARAS
		INNER JOIN 
		(	SELECT PMT.PayerID, SUM(CT.Amount) AS AppliedAmount, MAX(CT.CreatedDate) AS LastPaid
			FROM [dbo].[Payment] PMT
				INNER JOIN [dbo].[PaymentClaimTransaction] PCT
				ON PMT.PaymentID = PCT.PaymentID
				INNER JOIN dbo.ClaimTransaction CT
				ON PCT.ClaimTransactionID = CT.ClaimTransactionID
			WHERE PMT.PaymentDate <= @EndDate
				AND PMT.PracticeID = @PracticeID
				AND PMT.PayerTypeCode = 'O'
				AND CT.PracticeID = @PracticeID
				AND CT.CreatedDate <= @EndDate
				AND CT.ClaimTransactionTypeCode = 'PAY'
			GROUP BY PMT.PayerID) AS TAPP
		ON ARAS.Num = TAPP.PayerID
	WHERE ARAS.Type = @PayerTypeText
				
	UPDATE ARAS
		SET Unapplied = ISNULL(Unapplied,0) - ISNULL(TRFD.RefundAmount,0)
	FROM #ARAgingSummary ARAS
		INNER JOIN 
		(	SELECT RecipientID, SUM(RefundAmount) AS RefundAmount
			FROM [dbo].[Refund]	RFD
			WHERE RFD.RecipientTypeCode = 'O'
				AND RFD.RefundDate <= @EndDate
				AND RFD.PracticeID = @PracticeID
			GROUP BY RecipientID) AS TRFD
		ON ARAS.Num = TRFD.RecipientID
	WHERE ARAS.Type = @PayerTypeText
	
	UPDATE #ARAgingSummary
		SET TotalBalance = CurrentBalance + Age31_60 + Age61_90 + Age91_120 + AgeOver120

	--SELECT 	* FROM #ARAgingSummary
	/*
	WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 0 and 30 THEN 1
	WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 31 and 60 THEN 2
	WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 61 and 90 THEN 3
	WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) between 91 and 120 THEN 4
	WHEN (DATEDIFF(d, TFB.FirstBilled, @EndDate)) >= 121  THEN 5
	*/
	
	CREATE TABLE #AgeGroup
	(
		ID int identity(1,1),
		Amount money,
		DaysInARText varchar(10)
	)
	
	INSERT #AgeGroup(DaysInARText)
	VALUES ('<30')

	INSERT #AgeGroup(DaysInARText)
	VALUES ('30-60')
	
	INSERT #AgeGroup(DaysInARText)
	VALUES ('61-90')
	
	INSERT #AgeGroup(DaysInARText)
	VALUES ('91-120')

	INSERT #AgeGroup(DaysInARText)
	VALUES ('120+')

	UPDATE AG
		SET Amount = 	ISNULL((SELECT SUM(CurrentBalance)
						FROM #ARAgingSummary AAS), 0)
	FROM #AgeGroup AG
	WHERE AG.ID = 1

	UPDATE AG
		SET Amount = 	ISNULL((SELECT SUM(Age31_60)
						FROM #ARAgingSummary AAS), 0)
	FROM #AgeGroup AG
	WHERE AG.ID = 2

	UPDATE AG
		SET Amount = 	ISNULL((SELECT SUM(Age61_90)
						FROM #ARAgingSummary AAS), 0)
	FROM #AgeGroup AG
	WHERE AG.ID = 3

	UPDATE AG
		SET Amount = 	ISNULL((SELECT SUM(Age91_120)
						FROM #ARAgingSummary AAS), 0)
	FROM #AgeGroup AG
	WHERE AG.ID = 4

	UPDATE AG
		SET Amount = 	ISNULL((SELECT SUM(AgeOver120)
						FROM #ARAgingSummary AAS), 0)
	FROM #AgeGroup AG
	WHERE AG.ID = 5

	SELECT *
	FROM #AgeGroup
	ORDER BY ID

	DROP TABLE #AgeGroup
	DROP TABLE #ARAgingSummary
		
	RETURN
	
END



GO
PRINT N'Creating [dbo].[DashboardARAgingDisplay]'
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DashboardARAgingDisplay]
(
[PracticeID] [int] NOT NULL,
[ID] [int] NOT NULL,
[Amount] [int] NULL,
[DaysInARText] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF_DashboardARAgingDisplay_CreatedDate] DEFAULT (getdate())
)

GO
PRINT N'Creating primary key [PK_DashboardARAgingDisplay] on [dbo].[DashboardARAgingDisplay]'
GO
ALTER TABLE [dbo].[DashboardARAgingDisplay] ADD CONSTRAINT [PK_DashboardARAgingDisplay] PRIMARY KEY CLUSTERED  ([PracticeID], [ID])
GO
PRINT N'Creating [dbo].[DashboardDataProvider_GetGraphDataForBusinessManager]'
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.DashboardDataProvider_GetGraphDataForBusinessManager
	@PracticeID int = 40
AS
BEGIN
	SELECT * 
	FROM dbo.DashboardARAgingDisplay D
	WHERE D.PracticeID = @PracticeID
	
	RETURN
END

GO
PRINT N'Creating [dbo].[DashboardDataProvider_GetKeyIndicators]'
GO


CREATE PROCEDURE dbo.DashboardDataProvider_GetKeyIndicators
	@PracticeID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))
	
	SELECT CAST(0 AS int) AS ProviderID,	
		CAST(0 AS money) AS Charges,
		CAST(0 AS money) AS Adjustments,
		CAST(0 AS money) AS Receipts,
		CAST(0 AS money) AS Refunds,
		CAST(0 AS money) AS ARBalance,
		CAST(0 AS decimal(10,2)) AS DaysInAR,
		CAST(0 AS decimal(10,2)) AS DaysRevenueOutstanding,
		CAST(0 AS decimal(10,2)) AS DaysToSubmission,
		CAST(0 AS decimal(10,2)) AS DaysToBill
	INTO #key_indicator_summary

	UPDATE KIS
		SET Charges = UPD.ChargeTotal
	FROM
		#key_indicator_summary KIS 
		CROSS JOIN 
			(
				SELECT SUM(ISNULL(C.ServiceUnitCount,0) * ISNULL(C.ServiceChargeAmount,0)) AS ChargeTotal
				FROM dbo.Claim C
					INNER JOIN dbo.Encounter E
					ON C.EncounterID = E.EncounterID
				WHERE E.PracticeID = @PracticeID
					AND C.CreatedDate BETWEEN @BeginDate AND @EndDate
					AND C.ClaimID NOT IN
							(	SELECT CT.ClaimID
								FROM dbo.ClaimTransaction CT
								WHERE CT.ClaimTransactionTypeCode = 'XXX'
							)
			) AS UPD

	UPDATE KIS
		SET Adjustments = UPD.AdjustmentTotal
	FROM
		#key_indicator_summary KIS 
		CROSS JOIN 
			(
				SELECT SUM(ISNULL(CT.Amount,0)) AS AdjustmentTotal
				FROM dbo.Claim C
					INNER JOIN dbo.Encounter E
					ON C.EncounterID = E.EncounterID
					INNER JOIN dbo.ClaimTransaction CT
					ON C.ClaimID = CT.ClaimID
						AND 'ADJ' = CT.ClaimTransactionTypeCode
				WHERE E.PracticeID = @PracticeID
					AND CT.CreatedDate BETWEEN @BeginDate AND @EndDate
					AND C.ClaimID NOT IN
							(	SELECT CT.ClaimID
								FROM dbo.ClaimTransaction CT
								WHERE CT.ClaimTransactionTypeCode = 'XXX'
							)
			) AS UPD

	UPDATE KIS
		SET Receipts = UPD.ReceiptTotal
	FROM
		#key_indicator_summary KIS 
		CROSS JOIN 
			(
				SELECT SUM(ISNULL(CT.Amount,0)) AS ReceiptTotal
				FROM dbo.Claim C
					INNER JOIN dbo.Encounter E
					ON C.EncounterID = E.EncounterID
					INNER JOIN dbo.ClaimTransaction CT
					ON C.ClaimID = CT.ClaimID
						AND 'PAY' = CT.ClaimTransactionTypeCode
				WHERE E.PracticeID = @PracticeID
					AND CT.CreatedDate BETWEEN @BeginDate AND @EndDate
					AND C.ClaimID NOT IN
							(	SELECT CT.ClaimID
								FROM dbo.ClaimTransaction CT
								WHERE CT.ClaimTransactionTypeCode = 'XXX'
							)
			) UPD
			

	--ARBalance
	--AR Beginning Balance
	SELECT ClaimID, MAX(CT.ClaimTransactionID) AS ClaimTransactionID
	INTO #CT1
	FROM dbo.ClaimTransaction CT
	WHERE CT.CreatedDate < @EndDate
		and CT.PracticeID = @PracticeID
	GROUP BY ClaimID

	CREATE UNIQUE CLUSTERED INDEX #UX_CT1_ClaimTransactionID
		ON #CT1(ClaimTransactionID)
		
	--CREATE UNIQUE INDEX #UX_CT_ClaimID
	--	ON #CT(ClaimID)
	UPDATE KIS
		SET ARBalance = UPD.ARBalance
	FROM
		#key_indicator_summary KIS 
		CROSS JOIN 
			(
				SELECT SUM(ISNULL(CT.Claim_ARBalance,0)) AS ARBalance
				FROM dbo.Claim C
					INNER JOIN dbo.Encounter E
					ON C.EncounterID = E.EncounterID
					INNER JOIN dbo.ClaimTransaction CT
					ON C.ClaimID = CT.ClaimID
					INNER JOIN #CT1 TCT
					ON CT.ClaimTransactionID = TCT.ClaimTransactionID
				WHERE E.PracticeID = @PracticeID
			) UPD
			
			
	DROP TABLE #CT1

	SELECT E.DoctorID, 
		TFB.ClaimID, 
		TFB.FirstBilled,
		TFirstPay.FirstPayDate,
		E.DateOfService
	INTO #TDaysInAR
	FROM
		(
			SELECT CT.ClaimID, MIN(CT.CreatedDate) AS FirstBilled
			FROM dbo.ClaimTransaction CT
			WHERE CT.PracticeID = @PracticeID
				AND CT.CreatedDate <= @EndDate
				AND CT.ClaimTransactionTypeCode = 'BLL'
			GROUP BY CT.ClaimID
		) TFB 
		INNER JOIN
		(
			--This selects the first payment made BY an insurance company for those claims that have insurance
			SELECT T.ClaimID, MIN(T.FirstPayDate) AS FirstPayDate
			FROM 
			(
				SELECT CT.ClaimID, MIN(CT.CreatedDate) AS FirstPayDate
				FROM dbo.ClaimTransaction CT
					INNER JOIN dbo.PaymentClaimTransaction PCT
					ON CT.ClaimTransactionID = PCT.ClaimTransactionID
					INNER JOIN dbo.Payment PMT 
					ON PCT.PaymentID = PMT.PaymentID
						AND PMT.PayerTypeCode = 'I'
						AND PMT.PracticeID = @PracticeID
				WHERE CT.PracticeID = @PracticeID
					AND CT.CreatedDate <= @EndDate
					AND CT.ClaimTransactionTypeCode = 'PAY'
					AND PMT.PaymentDate <= @EndDate
				GROUP BY CT.ClaimID
				HAVING MIN(CT.CreatedDate) >= @BeginDate
				UNION ALL
				--This SELECT the first payment made BY a patient when the claim has no insurance payers
				SELECT CT.ClaimID, MIN(CT.CreatedDate) AS FirstPayDate
				FROM dbo.ClaimTransaction CT
				WHERE CT.PracticeID = @PracticeID
					AND CT.CreatedDate <= @EndDate
					AND CT.ClaimTransactionTypeCode = 'PAY'
					AND NOT EXISTS (SELECT * FROM dbo.ClaimPayer CP WHERE CP.ClaimID = CT.ClaimID)
				GROUP BY CT.ClaimID
				HAVING MIN(CT.CreatedDate) >= @BeginDate
			) AS T
			GROUP BY T.ClaimID
		) TFirstPay
		ON TFB.ClaimID = TFirstPay.ClaimID
		INNER JOIN dbo.Claim C
		ON TFB.ClaimID = C.ClaimID
		INNER JOIN dbo.Encounter E
		ON C.EncounterID = E.EncounterID
	WHERE E.PracticeID = @PracticeID
		AND C.PracticeID = @PracticeID

	CREATE UNIQUE INDEX #UX_TDaysInAR
	ON #TDaysInAR (ClaimID)
	
	CREATE CLUSTERED INDEX #IX_TDaysInAR
	ON #TDaysInAR (DoctorID)
	
	SELECT 0 AS ID,
		ISNULL((
			SELECT COUNT(*)
			FROM dbo.Encounter E
				INNER JOIN dbo.EncounterProcedure EP
				ON E.EncounterID = EP.EncounterID
			WHERE E.DateOfService BETWEEN @BeginDate AND @EndDate
				AND E.PracticeID = @PracticeID
				AND E.EncounterStatusID IN (3,5,6)
		),0) AS Procedures,
		ISNULL(Charges, 0) AS Charges,
		ISNULL(Adjustments, 0) AS Adjustments,
		ISNULL(Receipts, 0) AS Receipts,
		ISNULL((
			SELECT SUM(R.RefundAmount)
			FROM [dbo].[Refund] R
			WHERE R.RefundDate BETWEEN @BeginDate AND @EndDate
				AND R.PracticeID = @PracticeID
		),0) AS Refunds,
		ISNULL(ARBalance, 0) AS ARBalance,
		(
			SELECT 
				AVG(DATEDIFF(hh, dbo.fn_DateOnly(TDAR.FirstBilled), dbo.fn_DateOnly(TDAR.FirstPayDate)) / 24.0) AS DaysInAR
			FROM #TDaysInAR TDAR
		) DaysInAR,
		(
			SELECT 
				AVG(DATEDIFF(hh, dbo.fn_DateOnly(TDAR.DateOfService), dbo.fn_DateOnly(TDAR.FirstPayDate)) / 24.0) AS DaysRevenueOutstanding
			FROM #TDaysInAR TDAR
		) AS DaysRevenueOutstanding,
		(
			SELECT AVG(DATEDIFF(hh, dbo.fn_DateOnly(E.DateOfService), dbo.fn_DateOnly(E.DatePosted)) / 24.0) AS DaysToSubmission
			FROM dbo.Encounter E
			WHERE E.DateOfService <= @EndDate
				AND E.DatePosted BETWEEN @BeginDate AND @EndDate
				AND E.PracticeID = @PracticeID
		) AS DaysToSubmission,
		(
			SELECT AVG(DATEDIFF(hh, dbo.fn_DateOnly(TDTB.EnteredDate), dbo.fn_DateOnly(TDTB.FirstBilled)) / 24.0) AS DaysToBill
			FROM
				(
					SELECT CT.ClaimID, E.DatePosted AS EnteredDate ,MIN(CT.CreatedDate) AS FirstBilled
					FROM dbo.ClaimTransaction CT
						INNER JOIN dbo.Claim C
						ON CT.ClaimID = C.ClaimID
						INNER JOIN dbo.Encounter E
						ON C.EncounterID = E.EncounterID
					WHERE CT.PracticeID = @PracticeID
						AND CT.CreatedDate <= @EndDate
						AND E.DatePosted <= @EndDate									
						AND CT.ClaimTransactionTypeCode = 'BLL'
						AND E.PracticeID = @PracticeID
						AND C.PracticeID = @PracticeID
					GROUP BY CT.ClaimID, E.DatePosted
					HAVING MIN(CT.CreatedDate) >= @BeginDate
				) TDTB
		) AS DaysToBill
	FROM #key_indicator_summary
	
	DROP TABLE #key_indicator_summary
	DROP TABLE #TDaysInAR
		
	RETURN
	
END	



GO
PRINT N'Creating [dbo].[DashboardDataProvider_GetToDoDataForProvidersWithoutNumber]'
GO
CREATE PROCEDURE dbo.DashboardDataProvider_GetToDoDataForProvidersWithoutNumber
	@PracticeID int = 34
AS
BEGIN
	
	SELECT D.DoctorID AS ProviderID,
		RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), '') AS ProviderFullname
	FROM dbo.Doctor D
	WHERE D.PracticeID = @PracticeID
		AND NOT EXISTS (SELECT *
						FROM dbo.ProviderNumber PN
						WHERE PN.DoctorID = D.DoctorID)


END

GO
PRINT N'Creating [dbo].[DashboardKeyIndicatorDisplay]'
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DashboardKeyIndicatorDisplay]
(
[PracticeID] [int] NOT NULL,
[ComparePeriodType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Procedures] [int] NULL,
[PercentOfProcedures] [decimal] (10, 6) NULL,
[Charges] [money] NULL,
[PercentOfCharges] [decimal] (10, 6) NULL,
[Adjustments] [money] NULL,
[PercentOfAdjustments] [decimal] (10, 6) NULL,
[Receipts] [money] NULL,
[PercentOfReceipts] [decimal] (10, 6) NULL,
[Refunds] [money] NULL,
[PercentOfRefunds] [decimal] (10, 6) NULL,
[ARBalance] [money] NULL,
[PercentOfARBalance] [decimal] (10, 6) NULL,
[DaysInAR] [decimal] (10, 6) NULL,
[PercentOfDaysInAR] [decimal] (10, 6) NULL,
[DaysRevenueOutstanding] [decimal] (10, 6) NULL,
[PercentOfDaysRevenueOutstanding] [decimal] (10, 6) NULL,
[DaysToSubmission] [decimal] (10, 6) NULL,
[PercentOfDaysToSubmission] [decimal] (10, 6) NULL,
[DaysToBill] [decimal] (10, 6) NULL,
[PercentOfDaysToBill] [decimal] (10, 6) NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF_DashboardKeyIndicatorDisplay_CreatedDate] DEFAULT (getdate())
)

GO
PRINT N'Creating primary key [PK_DashboardKeyIndicatorDisplay] on [dbo].[DashboardKeyIndicatorDisplay]'
GO
ALTER TABLE [dbo].[DashboardKeyIndicatorDisplay] ADD CONSTRAINT [PK_DashboardKeyIndicatorDisplay] PRIMARY KEY CLUSTERED  ([PracticeID], [ComparePeriodType])
GO
PRINT N'Creating [dbo].[DashboardARAgingVolatile]'
GO
CREATE TABLE [dbo].[DashboardARAgingVolatile]
(
[PracticeID] [int] NOT NULL,
[ID] [int] NOT NULL,
[Amount] [int] NULL,
[DaysInARText] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF_DashboardARAgingVolatile_CreatedDate] DEFAULT (getdate())
)

GO
PRINT N'Creating primary key [PK_DashboardARAgingVolatile] on [dbo].[DashboardARAgingVolatile]'
GO
ALTER TABLE [dbo].[DashboardARAgingVolatile] ADD CONSTRAINT [PK_DashboardARAgingVolatile] PRIMARY KEY CLUSTERED  ([PracticeID], [ID])
GO
PRINT N'Creating [dbo].[DashboardDataProvider_GetToDoDataForMedicalOfficeDisplay]'
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.DashboardDataProvider_GetToDoDataForMedicalOfficeDisplay
	@PracticeID int = 34
AS
BEGIN
	DECLARE @flat TABLE (
		[PracticeID] [int] NULL ,
		NeedContactInfo bit default(0),
		NeedProviders bit default(0),
		NeedProviderNumbers bit default(0),
		NeedGroupNumber bit default(0),
		CountPatientScheduledForAppointments int default(0),
		CountDraftEncounters int default(0),
		CountRejectedEncounters int default(0),
		CountMobileEncounters int default(0),
		NeedReviewReports bit default(1)
	)
	
	--
	INSERT @flat (PracticeID)
	VALUES(@PracticeID)

	--Contact Info
	IF EXISTS(
				SELECT *
				FROM dbo.Practice P
				WHERE P.PracticeID = @PracticeID
					AND (
						LEN(P.AddressLine1) = 0
						OR LEN(P.City) = 0
						OR LEN(P.State) = 0
						OR LEN(P.ZipCode) = 0
						OR LEN(P.Phone) < 10
						OR LEN(P.Fax) < 10
						OR LEN(P.EIN) < 9
					)
				)
	BEGIN
		UPDATE @flat
			SET NeedContactInfo = 1
	END
	
	--Providers
	IF NOT EXISTS(
				SELECT *
				FROM dbo.Doctor D
				WHERE D.PracticeID = @PracticeID
				)
	BEGIN
		UPDATE @flat
			SET NeedProviders = 1
	END	
	
	--NeedProviderNumbers
	IF EXISTS(
				SELECT *
				FROM dbo.Doctor D
				WHERE D.PracticeID = @PracticeID
					AND NOT EXISTS (SELECT *
									FROM dbo.ProviderNumber PN
									WHERE PN.DoctorID = D.DoctorID)
				)
	BEGIN
		UPDATE @flat
			SET NeedProviderNumbers = 1
	END	

	--NeedGroupNumber
	IF NOT EXISTS(
				SELECT *
				FROM dbo.PracticeInsuranceGroupNumber PIGN
				WHERE PIGN.PracticeID = @PracticeID
				)
	BEGIN
		UPDATE @flat
			SET NeedGroupNumber = 1
	END	

	UPDATE @flat
		SET CountPatientScheduledForAppointments = (SELECT COUNT(*)
													FROM dbo.Appointment A
													WHERE A.PracticeID = @PracticeID
														AND A.AppointmentType = 'P'
														AND A.StartDate BETWEEN dbo.fn_DateOnly(GETDATE()) AND DATEADD(ms,-10,dbo.fn_DateOnly(GETDATE()) + 1)
													)
									
	UPDATE @flat
		SET CountDraftEncounters = (SELECT COUNT(*)
									FROM dbo.Encounter E
									WHERE E.PracticeID = @PracticeID
										AND E.EncounterStatusID = 1
									)

	UPDATE @flat
		SET CountRejectedEncounters = (SELECT COUNT(*)
										FROM dbo.Encounter E
										WHERE E.PracticeID = @PracticeID
											AND E.EncounterStatusID = 4
									   )

	UPDATE @flat
		SET CountMobileEncounters = (SELECT COUNT(*)
									FROM dbo.HandheldEncounter HE
									WHERE HE.PracticeID = @PracticeID
										AND HE.ReviewStatus = 'N'
									)

	--Get the data			
	SELECT *
	FROM @flat
	
	RETURN
END

GO
PRINT N'Creating [dbo].[DashboardKeyIndicatorVolatile]'
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DashboardKeyIndicatorVolatile]
(
[PracticeID] [int] NOT NULL,
[ComparePeriodType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Procedures] [int] NULL,
[PercentOfProcedures] [decimal] (10, 6) NULL,
[Charges] [money] NULL,
[PercentOfCharges] [decimal] (10, 6) NULL,
[Adjustments] [money] NULL,
[PercentOfAdjustments] [decimal] (10, 6) NULL,
[Receipts] [money] NULL,
[PercentOfReceipts] [decimal] (10, 6) NULL,
[Refunds] [money] NULL,
[PercentOfRefunds] [decimal] (10, 6) NULL,
[ARBalance] [money] NULL,
[PercentOfARBalance] [decimal] (10, 6) NULL,
[DaysInAR] [decimal] (10, 6) NULL,
[PercentOfDaysInAR] [decimal] (10, 6) NULL,
[DaysRevenueOutstanding] [decimal] (10, 6) NULL,
[PercentOfDaysRevenueOutstanding] [decimal] (10, 6) NULL,
[DaysToSubmission] [decimal] (10, 6) NULL,
[PercentOfDaysToSubmission] [decimal] (10, 6) NULL,
[DaysToBill] [decimal] (10, 6) NULL,
[PercentOfDaysToBill] [decimal] (10, 6) NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF_DashboardKeyIndicatorVolatile_CreatedDate] DEFAULT (getdate())
)

GO
PRINT N'Creating primary key [PK_DashboardKeyIndicatorVolatile] on [dbo].[DashboardKeyIndicatorVolatile]'
GO
ALTER TABLE [dbo].[DashboardKeyIndicatorVolatile] ADD CONSTRAINT [PK_DashboardKeyIndicatorVolatile] PRIMARY KEY CLUSTERED  ([PracticeID], [ComparePeriodType])
GO
PRINT N'Creating [dbo].[DashboardDataProvider_UpdateKeyIndicatorsForVolatile]'
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.DashboardDataProvider_UpdateKeyIndicatorsForVolatile
	@PracticeID int = NULL,
	@ComparePeriodType char(1) = 'M'
AS
BEGIN
	--M=Month, Q=Quarter, Y=Year
	DECLARE @Current_BeginDate datetime 
	DECLARE @Current_EndDate datetime
	DECLARE @Prior_BeginDate datetime
	DECLARE @Prior_EndDate datetime
	DECLARE @CurrentMonth int
	DECLARE @QuarterBeginMonth int
	
	SET @Current_EndDate = GETDATE()
	
	IF @ComparePeriodType = 'M'
	BEGIN
		SET @Current_BeginDate = CAST(MONTH(@Current_EndDate) AS varchar(2)) + '/1/' + CAST(YEAR(@Current_EndDate) AS varchar(4))
		SET @Prior_BeginDate = DATEADD(m,-1,@Current_BeginDate)
		SET @Prior_EndDate = DATEADD(ms,-10,DATEADD(m,1,@Prior_BeginDate))
	END
	ELSE IF @ComparePeriodType = 'Q'
	BEGIN
		SET @CurrentMonth = MONTH(@Current_EndDate)
		IF @CurrentMonth IN (1,2,3)
			SET @QuarterBeginMonth = 1
		ELSE IF @CurrentMonth IN (4,5,6)
			SET @QuarterBeginMonth = 4
		ELSE IF @CurrentMonth IN (7,8,9)
			SET @QuarterBeginMonth = 7
		ELSE
			SET @QuarterBeginMonth = 10	
	
		SET @Current_BeginDate = CAST(@QuarterBeginMonth AS varchar(2)) + '/1/' + CAST(YEAR(@Current_EndDate) AS varchar(4))
		SET @Prior_BeginDate = DATEADD(q,-1,@Current_BeginDate)
		SET @Prior_EndDate = DATEADD(ms,-10,DATEADD(q,1,@Prior_BeginDate))			
	END
	ELSE
	BEGIN
		SET @Current_BeginDate = '1/1/' + CAST(YEAR(@Current_EndDate) AS varchar(4))
		SET @Prior_BeginDate = DATEADD(yyyy,-1,@Current_BeginDate)
		SET @Prior_EndDate = DATEADD(ms,-10,DATEADD(yyyy,1,@Prior_BeginDate))		
	END
	
	--Remove the existing record, may or may NOT exist
	DELETE dbo.DashboardKeyIndicatorVolatile
	WHERE PracticeID = @PracticeID
		AND ComparePeriodType = @ComparePeriodType
	
	CREATE TABLE #ki_table(
		ID int PRIMARY KEY,
		Procedures int,
		Charges money,
		Adjustments money,
		Receipts money,
		Refunds money,
		ARBalance money,
		DaysInAR decimal(10,2),
		DaysRevenueOutstanding decimal(10,2),
		DaysToSubmission decimal(10,2),
		DaysToBill decimal(10,2)
	)

	INSERT #ki_table (
		ID,
		Procedures,
		Charges,
		Adjustments,
		Receipts,
		Refunds,
		ARBalance,
		DaysInAR,
		DaysRevenueOutstanding,
		DaysToSubmission,
		DaysToBill
	)
	EXECUTE dbo.DashboardDataProvider_GetKeyIndicators @PracticeID, @Current_BeginDate, @Current_EndDate


	INSERT dbo.DashboardKeyIndicatorVolatile(
		PracticeID, 
		ComparePeriodType
	)
	VALUES(
		@PracticeID, 
		@ComparePeriodType
	)

	UPDATE V
		SET Procedures = U.Procedures,
			Charges = U.Charges,
			Adjustments = U.Adjustments,
			Receipts = U.Receipts,
			Refunds = U.Refunds,
			ARBalance = U.ARBalance,
			DaysInAR = U.DaysInAR,
			DaysRevenueOutstanding = U.DaysRevenueOutstanding,
			DaysToSubmission = U.DaysToSubmission,
			DaysToBill = U.DaysToBill
		FROM #ki_table U
			CROSS JOIN dbo.DashboardKeyIndicatorVolatile V
		WHERE V.PracticeID = @PracticeID
			AND V.ComparePeriodType = @ComparePeriodType

	--Clear the TABLE and then get the prior values
	DELETE #ki_table

	INSERT #ki_table (
		ID,
		Procedures,
		Charges,
		Adjustments,
		Receipts,
		Refunds,
		ARBalance,
		DaysInAR,
		DaysRevenueOutstanding,
		DaysToSubmission,
		DaysToBill
	)
	EXECUTE dbo.DashboardDataProvider_GetKeyIndicators @PracticeID, @Prior_BeginDate, @Prior_EndDate


	UPDATE V
		SET PercentOfProcedures = 	CASE WHEN U.Procedures > 0 THEN
										(V.Procedures / U.Procedures)
									ELSE
										0
									END,
			PercentOfCharges = 		CASE WHEN U.Charges > 0 THEN
										V.Charges / U.Charges
									ELSE
										0
									END,
			PercentOfAdjustments = CASE WHEN U.Adjustments > 0 THEN
										V.Adjustments / U.Adjustments
									ELSE
										0
									END,
			PercentOfReceipts = 	CASE WHEN U.Receipts > 0 THEN
										V.Receipts / U.Receipts
									ELSE
										0
									END,
			PercentOfRefunds = 		CASE WHEN U.Refunds > 0 THEN
										V.Refunds / U.Refunds
									ELSE
										0
									END,
			PercentOfARBalance = 	CASE WHEN U.ARBalance > 0 THEN
										V.ARBalance / U.ARBalance
									ELSE
										0
									END,
			PercentOfDaysInAR = 	CASE WHEN U.DaysInAR > 0 THEN
										V.DaysInAR / U.DaysInAR
									ELSE
										0
									END,
			PercentOfDaysRevenueOutstanding = CASE WHEN U.DaysRevenueOutstanding > 0 THEN
										V.DaysRevenueOutstanding / U.DaysRevenueOutstanding
									ELSE
										0
									END,
			PercentOfDaysToSubmission = CASE WHEN U.DaysToSubmission > 0 THEN
										V.DaysToSubmission / U.DaysToSubmission
									ELSE
										0
									END,
			PercentOfDaysToBill = 	CASE WHEN U.DaysToBill > 0 THEN
										V.DaysToBill / U.DaysToBill
									ELSE
										0
									END
		FROM #ki_table U
			CROSS JOIN dbo.DashboardKeyIndicatorVolatile V
		WHERE V.PracticeID = @PracticeID
			AND V.ComparePeriodType = @ComparePeriodType

	
	DROP TABLE #ki_table
	
	RETURN
END

GO
PRINT N'Creating [dbo].[DashboardDataProvider_UpdateARAgingForVolatile]'
GO
CREATE PROCEDURE dbo.DashboardDataProvider_UpdateARAgingForVolatile
	@PracticeID int = NULL
AS
BEGIN
	
	--Remove the existing record, may or may NOT exist
	DELETE dbo.DashboardARAgingVolatile
	WHERE PracticeID = @PracticeID
	
	CREATE TABLE #ar_table(
		ID int PRIMARY KEY,
		Amount money,
		DaysInARText varchar(10)
	)

	INSERT #ar_table (
		ID,
		Amount,
		DaysInARText
	)
	EXECUTE dbo.DashboardDataProvider_GetARAging @PracticeID


	INSERT dbo.DashboardARAgingVolatile(
		PracticeID, 
		ID, 
		Amount, 
		DaysInARText
	)
	SELECT
		@PracticeID, 
		ID,
		CAST((ROUND(Amount, -3)/1000.0) AS int),
		DaysInARText
	FROM #ar_table
	ORDER BY ID
	
	RETURN
END

GO
PRINT N'Creating [dbo].[DashboardDataProvider_GetKeyIndicatorsForDisplay]'
GO


CREATE PROCEDURE dbo.DashboardDataProvider_GetKeyIndicatorsForDisplay
	@PracticeID int = NULL,
	@ComparePeriodType char(1) = 'M'
AS
BEGIN

	DECLARE @flat TABLE (
		[PracticeID] [int] NULL ,
		[ComparePeriodType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[Procedures] [varchar](100) NULL ,
		[PercentOfProcedures] [varchar](100) NULL ,
		[Charges] [varchar](100) NULL ,
		[PercentOfCharges] [varchar](100) NULL ,
		[Adjustments] [varchar](100) NULL ,
		[PercentOfAdjustments] [varchar](100) NULL ,
		[Receipts] [varchar](100) NULL ,
		[PercentOfReceipts] [varchar](100) NULL ,
		[Refunds] [varchar](100) NULL ,
		[PercentOfRefunds] [varchar](100) NULL ,
		[ARBalance] [varchar](100) NULL ,
		[PercentOfARBalance] [varchar](100) NULL ,
		[DaysInAR] [varchar](100) NULL ,
		[PercentOfDaysInAR] [varchar](100) NULL ,
		[DaysRevenueOutstanding] [varchar](100) NULL ,
		[PercentOfDaysRevenueOutstanding] [varchar](100) NULL ,
		[DaysToSubmission] [varchar](100) NULL ,
		[PercentOfDaysToSubmission] [varchar](100) NULL ,
		[DaysToBill] [varchar](100) NULL ,
		[PercentOfDaysToBill] [varchar](100) NULL ,
		[CreatedDate] [datetime] NULL
	)
	
	INSERT @flat(	
		PracticeID, 
		ComparePeriodType, 
		Procedures, 
		PercentOfProcedures, 
		Charges, 
		PercentOfCharges, 
		Adjustments, 
		PercentOfAdjustments, 
		Receipts, 
		PercentOfReceipts, 
		Refunds, 
		PercentOfRefunds, 
		ARBalance, 
		PercentOfARBalance, 
		DaysInAR, 
		PercentOfDaysInAR, 
		DaysRevenueOutstanding, 
		PercentOfDaysRevenueOutstanding, 
		DaysToSubmission, 
		PercentOfDaysToSubmission, 
		DaysToBill, 
		PercentOfDaysToBill, 
		CreatedDate
	)
	SELECT PracticeID, 
		ComparePeriodType, 
		CONVERT(varchar, CONVERT(int, Procedures)), 
		CONVERT(varchar, CONVERT(int, PercentOfProcedures)), 
		'$' + CONVERT(varchar, CONVERT(int, Charges)), 
		CONVERT(varchar, CONVERT(int, PercentOfCharges)), 
		'$' + CONVERT(varchar, CONVERT(int, Adjustments)), 
		CONVERT(varchar, CONVERT(int, PercentOfAdjustments)), 
		'$' + CONVERT(varchar, CONVERT(int, Receipts)), 
		CONVERT(varchar, CONVERT(int, PercentOfReceipts)), 
		'$' + CONVERT(varchar, CONVERT(int, Refunds)), 
		CONVERT(varchar, CONVERT(int, PercentOfRefunds)), 
		'$' + CONVERT(varchar, CONVERT(int, ARBalance)), 
		CONVERT(varchar, CONVERT(int, PercentOfARBalance)), 
		CONVERT(varchar, CONVERT(int, DaysInAR)), 
		CONVERT(varchar, CONVERT(int, PercentOfDaysInAR)), 
		CONVERT(varchar, CONVERT(int, DaysRevenueOutstanding)), 
		CONVERT(varchar, CONVERT(int, PercentOfDaysRevenueOutstanding)), 
		CONVERT(varchar, CONVERT(int, DaysToSubmission)), 
		CONVERT(varchar, CONVERT(int, PercentOfDaysToSubmission)), 
		CONVERT(varchar, CONVERT(int, DaysToBill)), 
		CONVERT(varchar, CONVERT(int, PercentOfDaysToBill)), 
		CreatedDate
	FROM dbo.DashboardKeyIndicatorDisplay
	WHERE PracticeID = @PracticeID
		AND ComparePeriodType = @ComparePeriodType

	DECLARE @list TABLE(
		ID int identity(1,1),
		Indicator varchar(100),
		Amount varchar(100),
		PercentOfChange varchar(100)
	)
	
	--1. Procedures
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Procedures', Procedures, PercentOfProcedures
	FROM @flat
	--2. Charges
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Charges', Charges, PercentOfCharges FROM @flat
	--3. Adjustments
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Adjustments', Adjustments, PercentOfAdjustments
	FROM @flat
	--4. Receipts
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Receipts', Receipts, PercentOfReceipts
	FROM @flat
	--5. Refunds
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Refunds', Refunds, PercentOfRefunds
	FROM @flat
	--6. A/R Balance
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'A/R Balance', ARBalance, PercentOfARBalance
	FROM @flat
	--7. Days in A/R
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Days in A/R', DaysInAR, PercentOfDaysInAR
	FROM @flat
	--8. Days Revenue Outstanding
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Days Revenue Outstanding', DaysRevenueOutstanding, PercentOfDaysRevenueOutstanding
	FROM @flat	
	--9. Days to Submission
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Days To Submission', DaysToSubmission, PercentOfDaysToSubmission
	FROM @flat	
	--8. Days to Bill
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Days to Bill', DaysToBill, PercentOfDaysToBill
	FROM @flat		
		
	SELECT *
	FROM @list 
	ORDER BY ID ASC
	RETURN
END


GO
PRINT N'Creating [dbo].[DashboardDataProvider_GetReceipts]'
GO


CREATE PROCEDURE dbo.DashboardDataProvider_GetReceipts
	@PracticeID int = NULL
AS
BEGIN
	SET NOCOUNT ON
	--Select the type of payer for each section of the report
	DECLARE @EndDate datetime
	SET @EndDate = GETDATE()
	
	
	DECLARE @Current_BeginDate datetime 
	DECLARE @Current_EndDate datetime
	DECLARE @Prior_BeginDate datetime
	DECLARE @Prior_EndDate datetime
	DECLARE @CurrentMonth int
	DECLARE @QuarterBeginMonth int
	


	DECLARE @receipts TABLE 
	(
		ID int PRIMARY KEY,
		Amount int default (0),
		Period varchar(20)
	)

	INSERT @receipts(ID, Period)
	VALUES(1, 'month to date')
	
	INSERT @receipts(ID, Period)
	VALUES(2, 'last month')
	
	INSERT @receipts(ID, Period)
	VALUES(3, 'quarter to date')
	
	INSERT @receipts(ID, Period)
	VALUES(4, 'year to date')
	
	SET @Current_EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))
	SET @Current_BeginDate = CAST(MONTH(@Current_EndDate) AS varchar(2)) + '/1/' + CAST(YEAR(@Current_EndDate) AS varchar(4))

	--Month to date	
	UPDATE @receipts 
		SET Amount = 	ISNULL((SELECT SUM(CT.Amount) / 1000.0
						FROM dbo.ClaimTransaction CT
						WHERE CT.PracticeID = @PracticeID
							AND CT.ClaimTransactionTypeCode = 'PAY'
							AND CT.TransactionDate BETWEEN @Current_BeginDate AND @Current_EndDate
							AND CT.ClaimID NOT IN (SELECT CT1.ClaimID FROM dbo.ClaimTransaction CT1 WHERE CT1.ClaimTransactionTypeCode = 'XXX')
						),0)
	WHERE ID = 1
	

	--Last month
	SET @Prior_BeginDate = DATEADD(m,-1,@Current_BeginDate)
	SET @Prior_EndDate = DATEADD(ms,-10,DATEADD(m,1,@Prior_BeginDate))

	UPDATE @receipts 
		SET Amount = 	ISNULL((SELECT SUM(CT.Amount) / 1000.0
						FROM dbo.ClaimTransaction CT
						WHERE CT.PracticeID = @PracticeID
							AND CT.ClaimTransactionTypeCode = 'PAY'
							AND CT.TransactionDate BETWEEN @Prior_BeginDate AND @Prior_EndDate
							AND CT.ClaimID NOT IN (SELECT CT1.ClaimID FROM dbo.ClaimTransaction CT1 WHERE CT1.ClaimTransactionTypeCode = 'XXX')
						),0)
	WHERE ID = 2
	
	

	--Quarter to date		
	SET @CurrentMonth = MONTH(@Current_EndDate)
	IF @CurrentMonth IN (1,2,3)
		SET @QuarterBeginMonth = 1
	ELSE IF @CurrentMonth IN (4,5,6)
		SET @QuarterBeginMonth = 4
	ELSE IF @CurrentMonth IN (7,8,9)
		SET @QuarterBeginMonth = 7
	ELSE
		SET @QuarterBeginMonth = 10	
	
	SET @Current_BeginDate = CAST(@QuarterBeginMonth AS varchar(2)) + '/1/' + CAST(YEAR(@Current_EndDate) AS varchar(4))

	UPDATE @receipts 
		SET Amount = 	ISNULL((SELECT SUM(CT.Amount) / 1000.0
						FROM dbo.ClaimTransaction CT
						WHERE CT.PracticeID = @PracticeID
							AND CT.ClaimTransactionTypeCode = 'PAY'
							AND CT.TransactionDate BETWEEN @Current_BeginDate AND @Current_EndDate
							AND CT.ClaimID NOT IN (SELECT CT1.ClaimID FROM dbo.ClaimTransaction CT1 WHERE CT1.ClaimTransactionTypeCode = 'XXX')
						), 0)
	WHERE ID = 3
		
	--Year to date		
	SET @Current_BeginDate = '1/1/' + CAST(YEAR(@Current_EndDate) AS varchar(4))
	
	UPDATE @receipts 
		SET Amount = 	ISNULL((SELECT SUM(CT.Amount) / 1000.0
						FROM dbo.ClaimTransaction CT
						WHERE CT.PracticeID = @PracticeID
							AND CT.ClaimTransactionTypeCode = 'PAY'
							AND CT.TransactionDate BETWEEN @Current_BeginDate AND @Current_EndDate
							AND CT.ClaimID NOT IN (SELECT CT1.ClaimID FROM dbo.ClaimTransaction CT1 WHERE CT1.ClaimTransactionTypeCode = 'XXX')
						),0)
	WHERE ID = 4

	SELECT *
	FROM @receipts
	ORDER BY ID
	
	RETURN
	
END



GO
PRINT N'Creating [dbo].[DashboardDataProvider_UpdateReceiptsForVolatile]'
GO
CREATE PROCEDURE dbo.DashboardDataProvider_UpdateReceiptsForVolatile
	@PracticeID int = NULL
AS
BEGIN
	
	--Remove the existing record, may or may NOT exist
	DELETE dbo.DashboardReceiptsVolatile
	WHERE PracticeID = @PracticeID
	
	CREATE TABLE #receipt_table(
		ID int PRIMARY KEY,
		Amount money,
		Period varchar(20)
	)

	INSERT #receipt_table (
		ID,
		Amount,
		Period
	)
	EXECUTE dbo.DashboardDataProvider_GetReceipts @PracticeID


	INSERT dbo.DashboardReceiptsVolatile(
		PracticeID, 
		ID, 
		Amount, 
		Period
	)
	SELECT
		@PracticeID, 
		ID,
		Amount,
		Period
	FROM #receipt_table
	ORDER BY ID
	
	RETURN
END

GO
PRINT N'Creating [dbo].[DashboardDataProvider_GetToDoDataForBusinessManagerDisplay]'
GO
CREATE PROCEDURE dbo.DashboardDataProvider_GetToDoDataForBusinessManagerDisplay
	@PracticeID int = 34
AS
BEGIN
	DECLARE @flat TABLE (
		[PracticeID] [int] NULL ,
		NeedContactInfo bit default(0),
		NeedProviders bit default(0),
		NeedServiceLocations bit default(0),
		NeedProviderNumbers bit default(0),
		NeedGroupNumber bit default(0),
		NeedCodingForm bit default(0),
		NeedElectronicClaimConfigure bit default(0),
		NeedPatientStatmentConfigure bit default(0),
		CountReviewEncounters int default(0),
		CountClaimsToSend int default(0),
		CountClearingHouseReportsToReview int default(0),
		CountPaymentsToApply int default(0),
		CountPatientStatementsToSend int default(0),
		NeedReviewReports bit default(1)
	)
	
	INSERT @flat (PracticeID)
	VALUES(@PracticeID)

	--Contact Info
	IF EXISTS(
				SELECT *
				FROM dbo.Practice P
				WHERE P.PracticeID = @PracticeID
					AND (
						LEN(P.AddressLine1) = 0
						OR LEN(P.City) = 0
						OR LEN(P.State) = 0
						OR LEN(P.ZipCode) = 0
						OR LEN(P.Phone) < 10
						OR LEN(P.Fax) < 10
						OR LEN(P.EIN) < 9
					)
				)
	BEGIN
		UPDATE @flat
			SET NeedContactInfo = 1
	END
	
	--Providers
	IF NOT EXISTS(
				SELECT *
				FROM dbo.Doctor D
				WHERE D.PracticeID = @PracticeID
				)
	BEGIN
		UPDATE @flat
			SET NeedProviders = 1
	END	
	
	--NeedServiceLocations
	IF NOT EXISTS(
				SELECT *
				FROM dbo.ServiceLocation SL
				WHERE SL.PracticeID = @PracticeID
				)
	BEGIN
		UPDATE @flat
			SET NeedServiceLocations = 1
	END	

	--NeedProviderNumbers
	IF EXISTS(
				SELECT *
				FROM dbo.Doctor D
				WHERE D.PracticeID = @PracticeID
					AND NOT EXISTS (SELECT *
									FROM dbo.ProviderNumber PN
									WHERE PN.DoctorID = D.DoctorID)
				)
	BEGIN
		UPDATE @flat
			SET NeedProviderNumbers = 1
	END	

	--NeedGroupNumber
	IF NOT EXISTS(
				SELECT *
				FROM dbo.PracticeInsuranceGroupNumber PIGN
				WHERE PIGN.PracticeID = @PracticeID
				)
	BEGIN
		UPDATE @flat
			SET NeedGroupNumber = 1
	END	

	--NeedCodingForm 
	IF NOT EXISTS(
				SELECT *
				FROM dbo.CodingTemplate CTMP
				WHERE CTMP.PracticeID = @PracticeID
				)
	BEGIN
		UPDATE @flat
			SET NeedCodingForm = 1
	END

	--NeedElectronicClaimConfigure 
	IF EXISTS(
				SELECT *
				FROM dbo.Practice P
				WHERE P.PracticeID = @PracticeID
					AND ISNULL(P.EClaimsEnrollmentStatusID,0) =0
				)
	BEGIN
		UPDATE @flat
			SET NeedElectronicClaimConfigure = 1
	END

	--NeedPatientStatmentConfigure 
	IF EXISTS(
				SELECT *
				FROM dbo.Practice P
				WHERE P.PracticeID = @PracticeID
					AND ISNULL(P.EnrolledForEStatements,0) =0
				)
	BEGIN
		UPDATE @flat
			SET NeedPatientStatmentConfigure = 1
	END

	UPDATE @flat
		SET CountReviewEncounters = (SELECT COUNT(*)
									FROM dbo.Encounter E
									WHERE E.PracticeID = @PracticeID
										AND E.EncounterStatusID = 2
									)
									
	UPDATE @flat
		SET CountClaimsToSend = (SELECT COUNT(*)
									FROM dbo.Claim C
									WHERE C.PracticeID = @PracticeID
										AND C.ClaimStatusCode = 'R'
										AND C.AssignmentIndicator IN ('1','2','3')
									)

	UPDATE @flat
		SET CountClearingHouseReportsToReview = (SELECT COUNT(*)
									FROM dbo.ClearinghouseResponse CR
									WHERE CR.PracticeID = @PracticeID
										AND CR.ReviewedFlag = 0
									)

	UPDATE @flat
		SET CountPaymentsToApply = 		(SELECT COUNT(T.PaymentID) AS UnappliedPaymentCount
										FROM
											(
											SELECT PMT.PracticeID
												, PMT.PaymentID
											FROM [dbo].[Payment] PMT
												LEFT OUTER JOIN dbo.PaymentClaimTransaction PCT
												ON PMT.PaymentID = PCT.PaymentID
												LEFT OUTER JOIN dbo.ClaimTransaction CT
												ON PCT.ClaimTransactionID = CT.ClaimTransactionID
											WHERE PMT.PracticeID = @PracticeID
											GROUP BY PMT.PracticeID, PMT.PaymentID
											HAVING  MAX(ISNULL(PMT.PaymentAmount,0)) - SUM(ISNULL(CT.Amount,0)) > 0
											) T
										)
										

	UPDATE @flat
		SET CountPatientStatementsToSend = 	(SELECT COUNT(DISTINCT C.PatientID) 
											FROM dbo.Claim C
											WHERE C.PracticeID = @PracticeID
												AND C.ClaimStatusCode IN ('P', 'R')
												AND C.ClaimID NOT IN (	SELECT ClaimID 
																		FROM dbo.ClaimTransaction CT 
																		WHERE CT.ClaimTransactionTypeCode = 'XXX' 
																			AND CT.PracticeID = @PracticeID
																	)
												AND C.PatientID NOT IN (		
																		SELECT BS.PatientID 
																		FROM dbo.Bill_Statement BS
																			INNER JOIN dbo.BillBatch BB
																			ON BS.BillBatchID = BB.BillBatchID
																		WHERE BB.ConfirmedDate BETWEEN DATEADD(d,-45,GETDATE()) AND GETDATE()
																			AND BB.PracticeID = @PracticeID
																			AND BB.BillBatchTypeCode = 'S' 
																	)
												)
		
	--Get the data		
	SELECT *
	FROM @flat
	
	RETURN
END

GO
PRINT N'Creating [dbo].[DashboardDataProvider_UpdateKeyIndicatorsVolatileJob]'
GO
CREATE PROCEDURE dbo.DashboardDataProvider_UpdateKeyIndicatorsVolatileJob
AS
BEGIN
	SET NOCOUNT ON
	DECLARE pki_cursor CURSOR
	READ_ONLY
	FOR SELECT P.PracticeID,
			P.Name
		FROM dbo.Practice P
		ORDER BY P.Name
	
	DECLARE @PracticeIDForCursor int
	DECLARE @PracticeName varchar(128)
	
	OPEN pki_cursor
	
	FETCH NEXT FROM pki_cursor INTO @PracticeIDForCursor, @PracticeName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			--Create the volatile records for each practice for each period
			PRINT '==================================================================================='
			PRINT 'Creating Dashboard data for ' + @PracticeName
			PRINT '==================================================================================='
			EXECUTE dbo.DashboardDataProvider_UpdateKeyIndicatorsForVolatile @PracticeIDForCursor, 'M'
			EXECUTE dbo.DashboardDataProvider_UpdateKeyIndicatorsForVolatile @PracticeIDForCursor, 'Q'
			EXECUTE dbo.DashboardDataProvider_UpdateKeyIndicatorsForVolatile @PracticeIDForCursor, 'Y'
			--PRINT '==================================================================================='
		END
		FETCH NEXT FROM pki_cursor INTO @PracticeIDForCursor, @PracticeName
	END
	
	CLOSE pki_cursor
	DEALLOCATE pki_cursor
	
	--Now replace the data in one operation
	BEGIN TRAN 
		DELETE dbo.DashboardKeyIndicatorDisplay
	
		INSERT dbo.DashboardKeyIndicatorDisplay WITH (TABLOCK)
			(PracticeID, 
			ComparePeriodType, 
			Procedures, 
			PercentOfProcedures, 
			Charges, 
			PercentOfCharges, 
			Adjustments, 
			PercentOfAdjustments, 
			Receipts, 
			PercentOfReceipts, 
			Refunds, 
			PercentOfRefunds, 
			ARBalance, 
			PercentOfARBalance, 
			DaysInAR, 
			PercentOfDaysInAR, 
			DaysRevenueOutstanding, 
			PercentOfDaysRevenueOutstanding, 
			DaysToSubmission, 
			PercentOfDaysToSubmission, 
			DaysToBill, 
			PercentOfDaysToBill
		)
		SELECT PracticeID, 
			ComparePeriodType, 
			Procedures, 
			PercentOfProcedures, 
			Charges, 
			PercentOfCharges, 
			Adjustments, 
			PercentOfAdjustments, 
			Receipts, 
			PercentOfReceipts, 
			Refunds, 
			PercentOfRefunds, 
			ARBalance, 
			PercentOfARBalance, 
			DaysInAR, 
			PercentOfDaysInAR, 
			DaysRevenueOutstanding, 
			PercentOfDaysRevenueOutstanding, 
			DaysToSubmission, 
			PercentOfDaysToSubmission, 
			DaysToBill, 
			PercentOfDaysToBill
		FROM dbo.DashboardKeyIndicatorVolatile
	COMMIT
	
	RETURN
END

GO
PRINT N'Creating [dbo].[DashboardDataProvider_UpdateARAgingVolatileJob]'
GO
CREATE PROCEDURE dbo.DashboardDataProvider_UpdateARAgingVolatileJob
AS
BEGIN
	SET NOCOUNT ON
	DECLARE pki_cursor CURSOR
	READ_ONLY
	FOR SELECT P.PracticeID,
			P.Name
		FROM dbo.Practice P
		ORDER BY P.Name
	
	DECLARE @PracticeIDForCursor int
	DECLARE @PracticeName varchar(128)
	
	OPEN pki_cursor
	
	FETCH NEXT FROM pki_cursor INTO @PracticeIDForCursor, @PracticeName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			--Create the volatile records for each practice for each period
			PRINT '==================================================================================='
			PRINT 'Creating Dashboard Graph data for ' + @PracticeName
			PRINT '==================================================================================='
			EXECUTE dbo.DashboardDataProvider_UpdateARAgingForVolatile @PracticeIDForCursor
			--PRINT '==================================================================================='
		END
		FETCH NEXT FROM pki_cursor INTO @PracticeIDForCursor, @PracticeName
	END
	
	CLOSE pki_cursor
	DEALLOCATE pki_cursor
	
	--Now replace the data in one operation
	BEGIN TRAN 
		DELETE dbo.DashboardARAgingDisplay
	
		INSERT dbo.DashboardARAgingDisplay WITH (TABLOCK)
			(PracticeID, 
			ID, 
			Amount, 
			DaysInARText
		)
		SELECT
			PracticeID, 
			ID,
			Amount,
			DaysInARText
		FROM dbo.DashboardARAgingVolatile
	COMMIT
	
	RETURN
END

GO
PRINT N'Creating [dbo].[DashboardDataProvider_UpdateReceiptsVolatileJob]'
GO
CREATE PROCEDURE dbo.DashboardDataProvider_UpdateReceiptsVolatileJob
AS
BEGIN
	SET NOCOUNT ON
	DECLARE pki_cursor CURSOR
	READ_ONLY
	FOR SELECT P.PracticeID,
			P.Name
		FROM dbo.Practice P
		ORDER BY P.Name
	
	DECLARE @PracticeIDForCursor int
	DECLARE @PracticeName varchar(128)
	
	OPEN pki_cursor
	
	FETCH NEXT FROM pki_cursor INTO @PracticeIDForCursor, @PracticeName
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			--Create the volatile records for each practice for each period
			PRINT '==================================================================================='
			PRINT 'Creating Dashboard Graph data for ' + @PracticeName
			PRINT '==================================================================================='
			EXECUTE dbo.DashboardDataProvider_UpdateReceiptsForVolatile @PracticeIDForCursor
			--PRINT '==================================================================================='
		END
		FETCH NEXT FROM pki_cursor INTO @PracticeIDForCursor, @PracticeName
	END
	
	CLOSE pki_cursor
	DEALLOCATE pki_cursor
	
	--Now replace the data in one operation
	BEGIN TRAN 
		DELETE dbo.DashboardReceiptsDisplay WITH (TABLOCK)
	
		INSERT dbo.DashboardReceiptsDisplay WITH (TABLOCK)
			(PracticeID, 
			ID, 
			Amount, 
			Period
		)
		SELECT
			PracticeID, 
			ID,
			Amount,
			Period
		FROM dbo.DashboardReceiptsVolatile
	COMMIT
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON
GO

--================================================================================
--Job Scheduling
--================================================================================
BEGIN TRANSACTION
	DECLARE @JobID BINARY(16)
	DECLARE @ReturnCode INT
	SELECT @ReturnCode = 0

	EXECUTE @ReturnCode = msdb.dbo.sp_add_job @job_name = N'Run DashboardDataProvider_UpdateKeyIndicatorsVolatileJob', @enabled = 1, @description = N'No description available.', @category_name = N'[Uncategorized (Local)]', @owner_login_name = N'sa', @notify_level_eventlog = 2, @notify_level_email = 0, @notify_level_netsend = 0, @notify_level_page = 0, @delete_level = 0, @job_id = @JobID OUTPUT
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

	EXECUTE @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'DashboardDataProvider_UpdateKeyIndicatorsVolatileJob', @subsystem = N'TSQL', @command = N'exec DashboardDataProvider_UpdateKeyIndicatorsVolatileJob ', @cmdexec_success_code = 0, @on_success_action = 1, @on_success_step_id = 0, @on_fail_action = 2, @on_fail_step_id = 0, @server = N'', @database_name = N'superbill_merge', @database_user_name = N'', @retry_attempts = 0, @retry_interval = 0, @output_file_name = N'', @flags = 2
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

	EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

	EXECUTE @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'Every Hour', @enabled = 1, @freq_type = 4, @freq_interval = 1, @freq_subday_type = 1, @freq_subday_interval = 1, @freq_relative_interval = 1, @freq_recurrence_factor = 0, @active_start_date = 20041011, @active_start_time = 1500, @active_end_date = 99991231, @active_end_time = 235959
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

	EXECUTE @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'K0', @automatic_post = 0
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

COMMIT TRANSACTION
GOTO   EndSave
QuitWithRollback:
	IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

--================================================================================
BEGIN TRANSACTION
	DECLARE @JobID BINARY(16)
	DECLARE @ReturnCode INT
	SELECT @ReturnCode = 0

	EXECUTE @ReturnCode = msdb.dbo.sp_add_job @job_name = N'Run DashboardDataProvider_UpdateARAgingVolatileJob', @enabled = 1, @description = N'No description available.', @category_name = N'[Uncategorized (Local)]', @owner_login_name = N'sa', @notify_level_eventlog = 2, @notify_level_email = 0, @notify_level_netsend = 0, @notify_level_page = 0, @delete_level = 0, @job_id = @JobID OUTPUT
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

	EXECUTE @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'DashboardDataProvider_UpdateARAgingVolatileJob', @subsystem = N'TSQL', @command = N'exec DashboardDataProvider_UpdateARAgingVolatileJob ', @cmdexec_success_code = 0, @on_success_action = 1, @on_success_step_id = 0, @on_fail_action = 2, @on_fail_step_id = 0, @server = N'', @database_name = N'superbill_merge', @database_user_name = N'', @retry_attempts = 0, @retry_interval = 0, @output_file_name = N'', @flags = 2
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

	EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

	EXECUTE @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'Every Hour', @enabled = 1, @freq_type = 4, @freq_interval = 1, @freq_subday_type = 1, @freq_subday_interval = 1, @freq_relative_interval = 1, @freq_recurrence_factor = 0, @active_start_date = 20041011, @active_start_time = 1500, @active_end_date = 99991231, @active_end_time = 235959
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

	EXECUTE @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'K0', @automatic_post = 0
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

COMMIT TRANSACTION
GOTO   EndSave
QuitWithRollback:
	IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

--================================================================================
BEGIN TRANSACTION
	DECLARE @JobID BINARY(16)
	DECLARE @ReturnCode INT
	SELECT @ReturnCode = 0

	EXECUTE @ReturnCode = msdb.dbo.sp_add_job @job_name = N'Run DashboardDataProvider_UpdateReceiptsVolatileJob', @enabled = 1, @description = N'No description available.', @category_name = N'[Uncategorized (Local)]', @owner_login_name = N'sa', @notify_level_eventlog = 2, @notify_level_email = 0, @notify_level_netsend = 0, @notify_level_page = 0, @delete_level = 0, @job_id = @JobID OUTPUT
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

	EXECUTE @ReturnCode = msdb.dbo.sp_add_jobstep @job_id = @JobID, @step_id = 1, @step_name = N'DashboardDataProvider_UpdateReceiptsVolatileJob', @subsystem = N'TSQL', @command = N'exec DashboardDataProvider_UpdateReceiptsVolatileJob ', @cmdexec_success_code = 0, @on_success_action = 1, @on_success_step_id = 0, @on_fail_action = 2, @on_fail_step_id = 0, @server = N'', @database_name = N'superbill_merge', @database_user_name = N'', @retry_attempts = 0, @retry_interval = 0, @output_file_name = N'', @flags = 2
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

	EXECUTE @ReturnCode = msdb.dbo.sp_update_job @job_id = @JobID, @start_step_id = 1
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

	EXECUTE @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id = @JobID, @name = N'Every Hour', @enabled = 1, @freq_type = 4, @freq_interval = 1, @freq_subday_type = 1, @freq_subday_interval = 1, @freq_relative_interval = 1, @freq_recurrence_factor = 0, @active_start_date = 20041011, @active_start_time = 1500, @active_end_date = 99991231, @active_end_time = 235959
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

	EXECUTE @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @JobID, @server_name = N'K0', @automatic_post = 0
	IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

COMMIT TRANSACTION
GOTO   EndSave
QuitWithRollback:
	IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO
