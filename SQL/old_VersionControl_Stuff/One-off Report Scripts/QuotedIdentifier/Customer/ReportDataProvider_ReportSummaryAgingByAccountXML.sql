SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_ReportSummaryAgingByAccountXML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_ReportSummaryAgingByAccountXML]
GO

/*
--===========================================================================
-- REPORT SUMMARY AGING BY ACCOUNT XML
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_ReportSummaryAgingByAccountXML
	@practice_id INT
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @ref_date DATETIME
	SET @ref_date = GETDATE()

	--Create a temp table of transactions.
	SELECT	C.PatientID,
		C.ClaimID,
		C.CreatedDate AS ClaimDate,
		'NEW' AS TypeCode,
		C.CreatedDate AS TransactionDate,
		COALESCE(ServiceChargeAmount,0) * COALESCE(ServiceUnitCount,1) AS Amount
	INTO	#ReportTransactions
	FROM	Claim C
	WHERE	C.PracticeID = @practice_id
		AND C.ClaimStatusCode <> 'C'
	UNION ALL 
	SELECT	C.PatientID,
		C.ClaimID,
		C.CreatedDate AS ClaimDate,
		'PAY' AS TypeCode,
		CT.TransactionDate,
		COALESCE(CT.Amount,0) AS Amount
	FROM	Claim C
		INNER JOIN ClaimTransaction CT
		ON	CT.ClaimID = C.ClaimID
		AND	CT.ClaimTransactionTypeCode = 'PAY'
	WHERE	C.PracticeID = @practice_id
		AND C.ClaimStatusCode <> 'C'
	UNION ALL
	SELECT	C.PatientID,
		C.ClaimID,
		C.CreatedDate AS ClaimDate,
		'ADJ' AS TypeCode,
		CT.TransactionDate,
		COALESCE(CT.Amount,0) AS Amount
	FROM	Claim C
		INNER JOIN ClaimTransaction CT
		ON	CT.ClaimID = C.ClaimID
		AND	CT.ClaimTransactionTypeCode IN ('ADJ','END')
	WHERE	C.PracticeID = @practice_id
		AND C.ClaimStatusCode <> 'C'

	--Create a temp table of Patient totals.
	SELECT	RT.PatientID,
		SUM(
			CASE
			WHEN RT.TypeCode = 'NEW' AND DATEDIFF(day,RT.ClaimDate,@ref_date) <= 30 THEN RT.Amount
			ELSE 0
			END) 
			AS CurrentChargeAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'NEW' AND DATEDIFF(day,RT.ClaimDate,@ref_date) BETWEEN 31 AND 60 THEN RT.Amount
			ELSE 0
			END)
			AS ThirtyDayChargeAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'NEW' AND DATEDIFF(day,RT.ClaimDate,@ref_date) BETWEEN 61 AND 90 THEN RT.Amount
			ELSE 0
			END)
			AS SixtyDayChargeAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'NEW' AND DATEDIFF(day,RT.ClaimDate,@ref_date) BETWEEN 91 AND 120 THEN RT.Amount
			ELSE 0
			END)
			AS NinetyDayChargeAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'NEW' AND DATEDIFF(day,RT.ClaimDate,@ref_date) > 120 THEN RT.Amount
			ELSE 0
			END)
			AS OneTwentyDayChargeAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'NEW' THEN RT.Amount
			ELSE 0
			END)
			AS TotalChargeAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'ADJ' AND DATEDIFF(day,RT.ClaimDate,@ref_date) <= 30 THEN RT.Amount
			ELSE 0
			END)
			AS CurrentAdjustmentAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'ADJ' AND DATEDIFF(day,RT.ClaimDate,@ref_date) BETWEEN 31 AND 60 THEN RT.Amount
			ELSE 0
			END)
			AS ThirtyDayAdjustmentAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'ADJ' AND DATEDIFF(day,RT.ClaimDate,@ref_date) BETWEEN 61 AND 90 THEN RT.Amount
			ELSE 0
			END)
			AS SixtyDayAdjustmentAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'ADJ' AND DATEDIFF(day,RT.ClaimDate,@ref_date) BETWEEN 91 AND 120 THEN RT.Amount
			ELSE 0
			END)
			AS NinetyDayAdjustmentAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'ADJ' AND DATEDIFF(day,RT.ClaimDate,@ref_date) > 120 THEN RT.Amount
			ELSE 0
			END)
			AS OneTwentyDayAdjustmentAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'ADJ' THEN RT.Amount
			ELSE 0
			END)
			AS TotalAdjustmentAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'PAY' AND DATEDIFF(day,RT.ClaimDate,@ref_date) <= 30 THEN RT.Amount
			ELSE 0
			END)
			AS CurrentReceiptAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'PAY' AND DATEDIFF(day,RT.ClaimDate,@ref_date) BETWEEN 31 AND 60 THEN RT.Amount
			ELSE 0
			END)
			AS ThirtyDayReceiptAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'PAY' AND DATEDIFF(day,RT.ClaimDate,@ref_date) BETWEEN 61 AND 90 THEN RT.Amount
			ELSE 0
			END)
			AS SixtyDayReceiptAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'PAY' AND DATEDIFF(day,RT.ClaimDate,@ref_date) BETWEEN 91 AND 120 THEN RT.Amount
			ELSE 0
			END)
			AS NinetyDayReceiptAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'PAY' AND DATEDIFF(day,RT.ClaimDate,@ref_date) > 120 THEN RT.Amount
			ELSE 0
			END)
			AS OneTwentyDayReceiptAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'PAY' THEN RT.Amount
			ELSE 0
			END)
			AS TotalReceiptAmount
	INTO	#PatientTotals
	FROM	#ReportTransactions RT
	GROUP BY RT.PatientID


	--Retrieve the results.
	SELECT	1 AS Tag, NULL AS Parent,
		1 AS [report!1!report-id],
		GETDATE() AS [report!1!report-date],
		NULL AS [account!2!patient-id],
		NULL AS [account!2!first-name],
		NULL AS [account!2!middle-name],
		NULL AS [account!2!last-name],
		NULL AS [account!2!phone],
		NULL AS [account!2!last-payment-date],
		NULL AS [account!2!unapplied-amount],
		NULL AS [account!2!current-amount],
		NULL AS [account!2!thirty-day-amount],
		NULL AS [account!2!sixty-day-amount],
		NULL AS [account!2!ninety-day-amount],
		NULL AS [account!2!one-hundred-twenty-day-amount],
		NULL AS [account!2!total-balance-amount]
	UNION ALL
	SELECT	2 AS Tag, 1 AS Parent,
		NULL AS [report!1!report-id],
		NULL AS [report!1!report-date],
		P.PatientID AS [account!2!patient-id],
		P.FirstName AS [account!2!first-name],
		P.MiddleName AS [account!2!middle-name],
		P.LastName AS [account!2!last-name],
		P.HomePhone AS [account!2!phone],
		(
			SELECT	MAX(PostingDate)
			FROM	Payment PMT
			WHERE	PMT.PayerTypeCode = 'P'
			AND	PMT.PayerID = P.PatientID)
			AS [account!2!last-payment-date],
		0 AS [account!2!unapplied-amount],
		COALESCE(PT.CurrentChargeAmount,0) - COALESCE(PT.CurrentAdjustmentAmount,0) - COALESCE(PT.CurrentReceiptAmount,0)
			AS [account!2!current-amount],
		COALESCE(PT.ThirtyDayChargeAmount,0) - COALESCE(PT.ThirtyDayAdjustmentAmount,0) - COALESCE(PT.ThirtyDayReceiptAmount,0)
			AS [account!2!thirty-day-amount],
		COALESCE(PT.SixtyDayChargeAmount,0) - COALESCE(PT.SixtyDayAdjustmentAmount,0) - COALESCE(PT.SixtyDayReceiptAmount,0)
			AS [account!2!sixty-day-amount],
		COALESCE(PT.NinetyDayChargeAmount,0) - COALESCE(PT.NinetyDayAdjustmentAmount,0) - COALESCE(PT.NinetyDayReceiptAmount,0)
			AS [account!2!ninety-day-amount],
		COALESCE(PT.OneTwentyDayChargeAmount,0) - COALESCE(PT.OneTwentyDayAdjustmentAmount,0) - COALESCE(PT.OneTwentyDayReceiptAmount,0)
			AS [account!2!one-hundred-twenty-day-amount],
		COALESCE(PT.TotalChargeAmount,0) - COALESCE(PT.TotalAdjustmentAmount,0) - COALESCE(PT.TotalReceiptAmount,0)
			AS [account!2!total-balance-amount]
	FROM	Patient P
		LEFT OUTER JOIN #PatientTotals PT
		ON	PT.PatientID = P.PatientID
	WHERE	P.PracticeID = @practice_id
	AND	0 <> COALESCE(PT.TotalChargeAmount,0) - COALESCE(PT.TotalAdjustmentAmount,0) - COALESCE(PT.TotalReceiptAmount,0)
	ORDER BY [account!2!patient-id]
	FOR XML EXPLICIT

	--DEBUG
	--select sum(		COALESCE(PT.TotalChargeAmount,0) - COALESCE(PT.TotalAdjustmentAmount,0) - COALESCE(PT.TotalReceiptAmount,0) )
	--	from #PatientTotals PT

	DROP TABLE #ReportTransactions
	DROP TABLE #PatientTotals

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
*/

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

