SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_ReportPatientFinancialHistoryXML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_ReportPatientFinancialHistoryXML]
GO


--===========================================================================
-- REPORT PATIENT FINANCIAL HISTORY XML
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_ReportPatientFinancialHistoryXML 
	@patient_id INT, 
	@start_date DATETIME = NULL, 
	@end_date DATETIME = NULL
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--Pre-process parameters.
	SET @start_date = COALESCE(@start_date, CAST(0 AS DATETIME))
	SET @end_date = COALESCE(@end_date, GETDATE())
	
	--Create a temp table of allowable claims
	DECLARE @patient_claims TABLE (ClaimID INT, ClaimStatusCode CHAR(1), LastTransaction CHAR(3))

	INSERT INTO @patient_claims
	SELECT
		C.ClaimID, 
		C.ClaimStatusCode, 
		NULL
	FROM
		Claim C
	WHERE
		C.PatientID = @patient_id
		
	UPDATE
		@patient_claims
	SET
		LastTransaction = 
			(
				SELECT
					TOP 1 ClaimTransactionTypeCode 
				FROM
					ClaimTransaction 
				WHERE
					ClaimID=F.ClaimID
				ORDER BY
					PostingDate DESC
			)
	FROM
		@patient_claims f

	DELETE FROM 
		@patient_claims
	WHERE
		ClaimStatusCode = 'C' 
		AND LastTransaction = 'XXX'
		
	

	--Create a temp table of transactions.
	SELECT	C.PatientID,
		NULL AS DoctorID,
		C.ClaimID,
		'NEW' AS TypeCode,
		C.CreatedDate AS TransactionDate,
		'9-15-05' AS DateOfService,
		0 Amount,
		0 ServiceUnitCount,
		NULL ProcedureCode,
		NULL DiagnosisCode,
		'DESC' Description,
		NULL AS PaymentNumber
	INTO	#ReportTransactions
	FROM	Claim C
		INNER JOIN @patient_claims PC ON PC.ClaimID = C.ClaimID
	WHERE	C.PatientID = @patient_id
	AND	C.CreatedDate BETWEEN @start_date AND @end_date
	UNION ALL 
	SELECT	C.PatientID,
		NULL DoctorID,
		CT.ClaimID,
		'PAY' AS TypeCode,
		'9-15-05' TransactionDate,
		NULL AS DateOfService,
		COALESCE(CT.Amount,0) AS Amount,
		NULL AS ServiceUnitCount,
		NULL AS ProcedureCode,
		NULL AS DiagnosisCode,
		(
			CASE (PMT.PayerTypeCode)
			WHEN 'I' THEN 'Check Payment Ins #' + CAST(PMT.PayerID AS VARCHAR)
			WHEN 'P' THEN 'Check Payment Patient'
			ELSE 'Check Payment Other'
			END
		) AS Description,
		PMT.PaymentNumber
	FROM	Claim C
		INNER JOIN @patient_claims PC ON PC.ClaimID = C.ClaimID
		INNER JOIN ClaimTransaction CT
		ON	CT.ClaimID = C.ClaimID
		AND	CT.ClaimTransactionTypeCode = 'PAY'
		LEFT OUTER JOIN Payment PMT
		ON	PMT.PaymentID = CT.ReferenceID
	WHERE	C.PatientID = @patient_id
	AND	CT.PostingDate BETWEEN @start_date AND @end_date
	UNION ALL
	SELECT	C.PatientID,
		NULL DoctorID,
		CT.ClaimID,
		'ADJ' AS TypeCode,
		'9-15-05' TransactionDate,
		NULL AS DateOfService,
		COALESCE(CT.Amount,0) AS Amount,
		NULL AS ServiceUnitCount,
		NULL AS ProcedureCode,
		NULL AS DiagnosisCode,
		ADJ.Description,
		NULL AS PaymentNumber
	FROM	Claim C
		INNER JOIN @patient_claims PC ON PC.ClaimID = C.ClaimID
		INNER JOIN ClaimTransaction CT
		ON	CT.ClaimID = C.ClaimID
		AND	CT.ClaimTransactionTypeCode IN ('ADJ','END')
		LEFT OUTER JOIN Adjustment ADJ
		ON	ADJ.AdjustmentCode = CT.Code
	WHERE	C.PatientID = @patient_id
	AND	CT.PostingDate BETWEEN @start_date AND @end_date

	--Create a temp table of patient totals.
	SELECT	RT.PatientID,
		SUM(
			CASE
			WHEN RT.TypeCode = 'NEW' THEN RT.Amount
			ELSE 0
			END) 
			AS PeriodChargeAmount,
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


	--Retrieve the results.
	SELECT	1 AS Tag, NULL AS Parent,
		1 AS [report!1!report-ind],
		GETDATE() AS [report!1!report-date],
		@start_date AS [report!1!period-start-date],
		@end_date AS [report!1!period-end-date],
		P.PatientID AS [report!1!patient-id],
		P.FirstName AS [report!1!patient-first-name],
		P.MiddleName AS [report!1!patient-middle-name],
		P.LastName AS [report!1!patient-last-name],
		COALESCE(PT.PeriodChargeAmount,0)
			AS [report!1!total-charge-amount],
		COALESCE(PT.PeriodReceiptAmount,0)
			AS [report!1!total-receipt-amount],
		COALESCE(PT.PeriodAdjustmentAmount,0)
			AS [report!1!total-adjustment-amount],
		COALESCE(PT.PeriodChargeAmount,0) - COALESCE(PT.PeriodReceiptAmount,0) - COALESCE(PT.PeriodAdjustmentAmount,0)
			AS [report!1!total-balance-amount],
		NULL AS [transaction!2!transaction-ind],
		NULL AS [transaction!2!transaction-type-code],
		NULL AS [transaction!2!transaction-date],
		NULL AS [transaction!2!date-of-service],
		NULL AS [transaction!2!transaction-amount],
		NULL AS [transaction!2!doctor-id],
		NULL AS [transaction!2!description],
		NULL AS [transaction!2!procedure-code],
		NULL AS [transaction!2!diagnosis-code],
		NULL AS [transaction!2!service-unit-count],
		NULL AS [transaction!2!check-number]
	FROM	Patient P
		LEFT OUTER JOIN #PatientTotals PT
		ON	PT.PatientID = P.PatientID
	WHERE	P.PatientID = @patient_id
	UNION ALL
	SELECT	2 AS Tag, 1 AS Parent,
		1 AS [report!1!report-ind],
		NULL AS [report!1!report-date],
		NULL AS [report!1!period-start-date],
		NULL AS [report!1!period-end-date],
		NULL AS [report!1!patient-id],
		NULL AS [report!1!patient-first-name],
		NULL AS [report!1!patient-middle-name],
		NULL AS [report!1!patient-last-name],
		NULL AS [report!1!total-charge-amount],
		NULL AS [report!1!total-receipt-amount],
		NULL AS [report!1!total-adjustment-amount],
		NULL AS [report!1!total-balance-amount],
		1 AS [transaction!2!transaction-ind],
		RT.TypeCode
			AS [transaction!2!transaction-type-code],
		DATEADD(hour,5,RT.TransactionDate)
			AS [transaction!2!transaction-date],
		DATEADD(hour,5,RT.DateOfService)
			AS [transaction!2!date-of-service],
		RT.Amount
			AS [transaction!2!transaction-amount],
		RT.DoctorID 
			AS [transaction!2!doctor-id],
		RT.Description
			AS [transaction!2!description],
		RT.ProcedureCode
			AS [transaction!2!procedure-code],
		RT.DiagnosisCode
			AS [transaction!2!diagnosis-code],
		RT.ServiceUnitCount
			AS [transaction!2!service-unit-count],
		RT.PaymentNumber 
			AS [transaction!2!check-number]
	FROM	#ReportTransactions RT
	ORDER BY [report!1!report-ind],
		[transaction!2!transaction-ind],
		[transaction!2!transaction-date]
	FOR XML EXPLICIT

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END


GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

