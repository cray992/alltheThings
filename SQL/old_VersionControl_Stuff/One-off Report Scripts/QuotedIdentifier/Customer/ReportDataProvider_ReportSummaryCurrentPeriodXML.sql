SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_ReportSummaryCurrentPeriodXML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_ReportSummaryCurrentPeriodXML]
GO

/*
--===========================================================================
-- REPORT SUMMARY CURRENT PERIOD
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_ReportSummaryCurrentPeriodXML
	@practice_id INT,
	@start_date DATETIME,
	@end_date DATETIME
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--Create a temp table of transactions.
	SELECT	C.PatientID,
		C.ClaimID,
		'NEW' AS TypeCode,
		C.CreatedDate AS TransactionDate,
		COALESCE(ServiceChargeAmount,0) * COALESCE(ServiceUnitCount,1) AS Amount
	INTO	#ReportTransactions
	FROM	Claim C
	WHERE	C.PracticeID = @practice_id
	AND	C.CreatedDate <= @end_date
	UNION ALL 
	SELECT	C.PatientID,
		CT.ClaimID,
		'PAY' AS TypeCode,
		CT.TransactionDate,
		COALESCE(CT.Amount,0) AS Amount
	FROM	Claim C
		INNER JOIN ClaimTransaction CT
		ON	CT.ClaimID = C.ClaimID
		AND	CT.ClaimTransactionTypeCode = 'PAY'
	WHERE	C.PracticeID = @practice_id
	AND	CT.TransactionDate <= @end_date
	UNION ALL
	SELECT	C.PatientID,
		CT.ClaimID,
		'ADJ' AS TypeCode,
		CT.TransactionDate,
		COALESCE(CT.Amount,0) AS Amount
	FROM	Claim C
		INNER JOIN ClaimTransaction CT
		ON	CT.ClaimID = C.ClaimID
		AND	CT.ClaimTransactionTypeCode IN ('ADJ','END')
	WHERE	C.PracticeID = @practice_id
	AND	CT.TransactionDate <= @end_date

	--Create a temp table of patient totals.
	SELECT	RT.PatientID,
		SUM(
			CASE
			WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate <= @start_date THEN RT.Amount
			ELSE 0
			END
		) AS ForwardChargeAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'ADJ' AND RT.TransactionDate <= @start_date THEN RT.Amount
			ELSE 0
			END
		) AS ForwardAdjustmentAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'PAY' AND RT.TransactionDate <= @start_date THEN RT.Amount
			ELSE 0
			END
		) AS ForwardReceiptAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @start_date AND @end_date THEN RT.Amount
			ELSE 0
			END
		) AS CurrentChargeAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'ADJ' AND RT.TransactionDate BETWEEN @start_date AND @end_date THEN RT.Amount
			ELSE 0
			END
		) AS CurrentAdjustmentAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'PAY' AND RT.TransactionDate BETWEEN @start_date AND @end_date THEN RT.Amount
			ELSE 0
			END
		) AS CurrentReceiptAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate <= @end_date THEN RT.Amount
			ELSE 0
			END
		) AS TotalChargeAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'ADJ' AND RT.TransactionDate <= @end_date THEN RT.Amount
			ELSE 0
			END
		) AS TotalAdjustmentAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'PAY' AND RT.TransactionDate <= @end_date THEN RT.Amount
			ELSE 0
			END
		) AS TotalReceiptAmount
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
		NULL AS [account!2!balance-forward-amount],
		NULL AS [account!2!charge-amount],
		NULL AS [account!2!receipt-amount],
		NULL AS [account!2!adjustment-amount],
		NULL AS [account!2!balance-amount]
	UNION ALL
	SELECT	2 AS Tag, 1 AS Parent,
		NULL AS [report!1!report-id],
		NULL AS [report!1!report-date],
		P.PatientID AS [account!2!patient-id],
		UPPER(P.FirstName) AS [account!2!first-name],
		UPPER(P.MiddleName) AS [account!2!middle-name],
		UPPER(P.LastName) AS [account!2!last-name],
		P.HomePhone AS [account!2!phone],
		COALESCE(PT.ForwardChargeAmount,0) - COALESCE(PT.ForwardAdjustmentAmount,0) - COALESCE(PT.ForwardReceiptAmount,0)
			AS [account!2!balance-forward-amount],
		COALESCE(PT.CurrentChargeAmount,0)
			AS [account!2!charge-amount],
		COALESCE(PT.CurrentReceiptAmount,0)
			AS [account!2!receipt-amount],
		COALESCE(PT.CurrentAdjustmentAmount,0)
			AS [account!2!adjustment-amount],
		COALESCE(PT.TotalChargeAmount,0) - COALESCE(PT.TotalReceiptAmount,0) - COALESCE(PT.TotalAdjustmentAmount,0)
			AS [account!2!balance-amount]
	FROM	Patient P
		LEFT OUTER JOIN #PatientTotals PT
		ON	PT.PatientID = P.PatientID
	WHERE	P.PracticeID = @practice_id
	ORDER BY [account!2!patient-id]
	FOR XML EXPLICIT

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
*/
GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

