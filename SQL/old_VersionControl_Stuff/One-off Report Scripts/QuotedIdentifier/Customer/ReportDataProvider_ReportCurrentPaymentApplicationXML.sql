SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_ReportCurrentPaymentApplicationXML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_ReportCurrentPaymentApplicationXML]
GO

/*
--===========================================================================
-- REPORT CURRENT PAYMENT APPLICATION XML
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_ReportCurrentPaymentApplicationXML 
	@practice_id INT,
	@start_date DATETIME,
	@end_date DATETIME
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--Create a temp table of transactions.
	SELECT	C.PracticeID,
		C.PatientID,
		C.ClaimID,
		'PAY' AS TypeCode,
		CT.ClaimTransactionID,
		CT.TransactionDate,
		COALESCE(CT.Amount,0) AS Amount,
		CT.ReferenceDate,
		CT.ReferenceID AS PaymentID,
		NULL AS AdjustmentCode
	INTO	#ReportTransactions
	FROM	Claim C
		INNER JOIN ClaimTransaction CT
		ON	CT.ClaimID = C.ClaimID
		AND	CT.ClaimTransactionTypeCode = 'PAY'
	WHERE	C.PracticeID = @practice_id
	AND	CT.TransactionDate BETWEEN @start_date AND @end_date
	UNION ALL
	SELECT	C.PracticeID,
		C.PatientID,
		C.ClaimID,
		'ADJ' AS TypeCode,
		CT.ClaimTransactionID,
		CT.TransactionDate,
		COALESCE(CT.Amount,0) AS Amount,
		CT.ReferenceDate,
		NULL AS PaymentID,
		CT.Code AS AdjustmentCode
	FROM	Claim C
		INNER JOIN ClaimTransaction CT
		ON	CT.ClaimID = C.ClaimID
		AND	CT.ClaimTransactionTypeCode IN ('ADJ','END')
	WHERE	C.PracticeID = @practice_id
	AND	CT.TransactionDate BETWEEN @start_date AND @end_date

	--Create a temp table of patient-applied payments.
	SELECT	RT.PatientID,
		RT.PaymentID,
		SUM(RT.Amount) AS PatientAppliedAmount
	INTO	#ReportPayments
	FROM	#ReportTransactions RT
	WHERE	RT.TypeCode = 'PAY'
	GROUP BY RT.PatientID, RT.PaymentID

	--Create a temp table of patient totals.
	SELECT	RT.PatientID,
		SUM(
			CASE
			WHEN RT.TypeCode = 'ADJ' THEN RT.Amount
			ELSE 0
			END)
			AS PeriodAdjustmentAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'PAY' THEN RT.Amount
			ELSE 0
			END)
			AS PeriodReceiptAmount
	INTO	#PatientTotals
	FROM	#ReportTransactions RT
	GROUP BY RT.PatientID

	--Create a temp table of practice totals.
	SELECT	RT.PracticeID,
		SUM(
			CASE
			WHEN RT.TypeCode = 'ADJ' THEN RT.Amount
			ELSE 0
			END)
			AS PeriodAdjustmentAmount,
		SUM(
			CASE
			WHEN RT.TypeCode = 'PAY' THEN RT.Amount
			ELSE 0
			END)
			AS PeriodReceiptAmount
	INTO 	#PracticeTotals
	FROM	#ReportTransactions RT
	GROUP BY RT.PracticeID

	
	--Retrieve the results.
	SELECT	1 AS Tag, NULL AS Parent,
		1 AS [report!1!report-ind],
		GETDATE() AS [report!1!report-date],
		@start_date AS [report!1!period-start-date],
		@end_date AS [report!1!period-end-date],
		COALESCE(PT.PeriodReceiptAmount,0)
			AS [report!1!total-receipt-amount],
		COALESCE(PT.PeriodAdjustmentAmount,0)
			AS [report!1!total-adjustment-amount],
		COALESCE(PT.PeriodReceiptAmount,0) + COALESCE(PT.PeriodAdjustmentAmount,0)
			AS [report!1!total-applied-amount],
		NULL AS [account!2!patient-id],
		NULL AS [account!2!first-name],
		NULL AS [account!2!middle-name],
		NULL AS [account!2!last-name],
		NULL AS [account!2!total-receipt-amount],
		NULL AS [account!2!total-adjustment-amount],
		NULL AS [account!2!total-applied-amount],
		NULL AS [transaction!3!transaction-id],
		NULL AS [transaction!3!transaction-date],
		NULL AS [transaction!3!transaction-amount],
		NULL AS [transaction!3!description],
		NULL AS [transaction!3!reference-date],
		NULL AS [transaction!3!check-number],
		NULL AS [transaction-detail!4!detail-ind],
		NULL AS [transaction-detail!4!detail-amount],
		NULL AS [transaction-detail!4!posted-date],
		NULL AS [transaction-detail!4!service-date],
		NULL AS [transaction-detail!4!procedure-code],
		NULL AS [transaction-detail!4!doctor-id]
	FROM	Practice PR
		LEFT OUTER JOIN #PracticeTotals PT
		ON	PT.PracticeID = PR.PracticeID
	WHERE	PR.PracticeID = @practice_id
	UNION ALL
	SELECT	2 AS Tag, 1 AS Parent,
		1 AS [report!1!report-ind],
		NULL AS [report!1!report-date],
		NULL AS [report!1!period-start-date],

		NULL AS [report!1!period-end-date],
		NULL AS [report!1!total-receipt-amount],
		NULL AS [report!1!total-adjustment-amount],
		NULL AS [report!1!total-applied-amount],
		P.PatientID AS [account!2!patient-id],
		UPPER(P.FirstName) AS [account!2!first-name],
		UPPER(P.MiddleName) AS [account!2!middle-name],
		UPPER(P.LastName) AS [account!2!last-name],
		COALESCE(PT.PeriodReceiptAmount,0)
			AS [account!2!total-receipt-amount],
		COALESCE(PT.PeriodAdjustmentAmount,0)
			AS [account!2!total-adjustment-amount],
		COALESCE(PT.PeriodReceiptAmount,0) + COALESCE(PT.PeriodAdjustmentAmount,0)
			AS [account!2!total-applied-amount],
		NULL AS [transaction!3!transaction-ind],
		NULL AS [transaction!3!transaction-date],
		NULL AS [transaction!3!transaction-amount],
		NULL AS [transaction!3!description],
		NULL AS [transaction!3!reference-date],
		NULL AS [transaction!3!check-number],
		NULL AS [transaction-detail!4!detail-ind],
		NULL AS [transaction-detail!4!detail-amount],
		NULL AS [transaction-detail!4!posted-date],
		NULL AS [transaction-detail!4!service-date],
		NULL AS [transaction-detail!4!procedure-code],
		NULL AS [transaction-detail!4!doctor-id]
	FROM	Patient P
		INNER JOIN #PatientTotals PT
		ON	PT.PatientID = P.PatientID
	WHERE	P.PracticeID = @practice_id
	UNION ALL 
	SELECT	3 AS Tag, 2 AS Parent,
		1 AS [report!1!report-ind],
		NULL AS [report!1!report-date],
		NULL AS [report!1!period-start-date],
		NULL AS [report!1!period-end-date],
		NULL AS [report!1!total-receipt-amount],
		NULL AS [report!1!total-adjustment-amount],
		NULL AS [report!1!total-applied-amount],
		RP.PatientID AS [account!2!patient-id],
		NULL AS [account!2!first-name],
		NULL AS [account!2!middle-name],
		NULL AS [account!2!last-name],
		NULL AS [account!2!total-receipt-amount],
		NULL AS [account!2!total-adjustment-amount],
		NULL AS [account!2!total-applied-amount],
		'PAY' + CAST(RP.PaymentID AS VARCHAR) 
			AS [transaction!3!transaction-id],
		PMT.CreatedDate 
			AS [transaction!3!transaction-date],
		RP.PatientAppliedAmount
			AS [transaction!3!transaction-amount],
		(
			CASE (PMT.PayerTypeCode)
			WHEN 'I' THEN 'Check Payment From ' + CAST(PMT.PayerID AS VARCHAR)
			WHEN 'P' THEN 'Check Payment From Patient'
			ELSE 'Check Payment From Other'
			END
			) AS [transaction!3!description],
		PMT.PostingDate
			AS [transaction!3!reference-date],
		PMT.PaymentNumber
			AS [transaction!3!check-number],
		NULL AS [transaction-detail!4!detail-ind],
		NULL AS [transaction-detail!4!detail-amount],
		NULL AS [transaction-detail!4!posted-date],
		NULL AS [transaction-detail!4!service-date],
		NULL AS [transaction-detail!4!procedure-code],
		NULL AS [transaction-detail!4!doctor-id]
	FROM	#ReportPayments RP
		INNER JOIN Payment PMT
		ON	PMT.PaymentID = RP.PaymentID
	UNION ALL
	SELECT	3 AS Tag, 2 AS Parent,
		1 AS [report!1!report-ind],
		NULL AS [report!1!report-date],
		NULL AS [report!1!period-start-date],
		NULL AS [report!1!period-end-date],
		NULL AS [report!1!total-receipt-amount],
		NULL AS [report!1!total-adjustment-amount],
		NULL AS [report!1!total-applied-amount],
		RT.PatientID AS [account!2!patient-id],
		NULL AS [account!2!first-name],
		NULL AS [account!2!middle-name],
		NULL AS [account!2!last-name],
		NULL AS [account!2!total-receipt-amount],
		NULL AS [account!2!total-adjustment-amount],
		NULL AS [account!2!total-applied-amount],
		'ADJ' + CAST(RT.ClaimTransactionID AS VARCHAR)
			AS [transaction!3!transaction-id],
		RT.TransactionDate 
			AS [transaction!3!transaction-date],
		RT.Amount 
			AS [transaction!3!transaction-amount],
		ADJ.Description 
			AS [transaction!3!description],
		RT.ReferenceDate 
			AS [transaction!3!reference-date],
		NULL AS [transaction!3!check-number],
		NULL AS [transaction-detail!4!detail-ind],
		NULL AS [transaction-detail!4!detail-amount],
		NULL AS [transaction-detail!4!posted-date],
		NULL AS [transaction-detail!4!service-date],
		NULL AS [transaction-detail!4!procedure-code],
		NULL AS [transaction-detail!4!doctor-id]
	FROM	#ReportTransactions RT
		LEFT OUTER JOIN Adjustment ADJ
		ON ADJ.AdjustmentCode = RT.AdjustmentCode
	WHERE	RT.TypeCode = 'ADJ'
	UNION ALL
	SELECT	4 AS Tag, 3 AS Parent,
		1 AS [report!1!report-ind],
		NULL AS [report!1!report-date],
		NULL AS [report!1!period-start-date],
		NULL AS [report!1!period-end-date],
		NULL AS [report!1!total-receipt-amount],
		NULL AS [report!1!total-adjustment-amount],
		NULL AS [report!1!total-applied-amount],
		RT.PatientID AS [account!2!patient-id],
		NULL AS [account!2!first-name],
		NULL AS [account!2!middle-name],
		NULL AS [account!2!last-name],
		NULL AS [account!2!total-receipt-amount],
		NULL AS [account!2!total-adjustment-amount],
		NULL AS [account!2!total-applied-amount],
		(
			CASE
			WHEN RT.TypeCode = 'ADJ' THEN 'ADJ' + CAST(RT.ClaimTransactionID AS VARCHAR)
			WHEN RT.TypeCode = 'PAY' THEN 'PAY' + CAST(RT.PaymentID AS VARCHAR)
			END
			) AS [transaction!3!transaction-id],
		NULL AS [transaction!3!transaction-date],
		NULL AS [transaction!3!transaction-amount],
		NULL AS [transaction!3!description],
		NULL AS [transaction!3!reference-date],
		NULL AS [transaction!3!check-number],
		1 AS [transaction-detail!4!detail-ind],
		RT.Amount 
			AS [transaction-detail!4!detail-amount],
		RT.TransactionDate
			AS [transaction-detail!4!posted-date],
		DATEADD(hour,5,C.ServiceBeginDate) 
			AS [transaction-detail!4!service-date],
		C.ProcedureCode 
			AS [transaction-detail!4!procedure-code],
		C.RenderingProviderID
			AS [transaction-detail!4!doctor-id]
	FROM	#ReportTransactions RT
		INNER JOIN Claim C
		ON	C.ClaimID = RT.ClaimID
	ORDER BY [report!1!report-ind],
		[account!2!patient-id],
		[transaction!3!transaction-id],
		[transaction-detail!4!detail-ind]
	FOR XML EXPLICIT

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
*/

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

