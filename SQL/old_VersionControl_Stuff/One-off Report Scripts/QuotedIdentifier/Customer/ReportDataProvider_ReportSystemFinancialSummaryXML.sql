SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_ReportSystemFinancialSummaryXML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_ReportSystemFinancialSummaryXML]
GO

/*
--===========================================================================
-- REPORT SYSTEM FINANCIAL SUMMARY XML
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_ReportSystemFinancialSummaryXML
	@practice_id INT,
	@ref_date DATETIME
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--Pre-process parameters.
	DECLARE @day_start_date DATETIME
	DECLARE @period_start_date DATETIME
	DECLARE @year_start_date DATETIME
	
	SET @period_start_date = CAST(CAST(YEAR(@ref_date) AS VARCHAR) + '-' +	CAST(MONTH(@ref_date) AS VARCHAR) + '-01' AS DATETIME)

	SET @year_start_date = CAST(CAST(YEAR(@ref_date) AS VARCHAR) + '-01-01' AS DATETIME)

	SET @ref_date = CAST(CAST(YEAR(@ref_date) AS VARCHAR) + '-' + CAST(MONTH(@ref_date) AS VARCHAR) + '-' + CAST(DAY(@ref_date) AS VARCHAR) + ' 23:59:59.999' AS DATETIME)
	SET @day_start_date = DATEADD(day, -1, @ref_date)

	
	--Create a temp table of transactions.
	SELECT	C.PracticeID,
		C.RenderingProviderID AS DoctorID,
		C.ClaimID,
		'NEW' AS TypeCode,
		C.CreatedDate AS TransactionDate,
		COALESCE(ServiceChargeAmount,0) * COALESCE(ServiceUnitCount,1) AS Amount,
		COALESCE(ServiceUnitCount,1) AS ServiceUnitCount,
		NULL AS PayerTypeCode,
		NULL AS AdjustmentCode,
		NULL AS AdjustmentDescription
	INTO	#ReportTransactions
	FROM	Claim C
	WHERE	C.PracticeID = @practice_id
	AND	C.CreatedDate BETWEEN @year_start_date AND @ref_date
	UNION ALL 
	SELECT	C.PracticeID,
		C.RenderingProviderID AS DoctorID,
		CT.ClaimID,
		'PAY' AS TypeCode,
		CT.ReferenceDate AS TransactionDate,
		COALESCE(CT.Amount,0) AS Amount,
		NULL AS ServiceUnitCount,
		(
			CASE 
			WHEN PMT.PayerTypeCode = 'P' THEN 'P'
			WHEN ICP.InsuranceProgramCode IN ('MB') THEN 'M'
			ELSE 'I'
			END
			) AS PayerTypeCode,
		NULL AS AdjustmentCode,
		NULL AS AdjustmentDescription
	FROM	Claim C
		INNER JOIN ClaimTransaction CT
		ON	CT.ClaimID = C.ClaimID
		AND	CT.ClaimTransactionTypeCode = 'PAY'
		LEFT OUTER JOIN Payment PMT
		ON	PMT.PaymentID = CT.ReferenceID
		LEFT OUTER JOIN InsuranceCompanyPlan ICP
		ON	PMT.PayerTypeCode = 'I'
		AND	ICP.InsuranceCompanyPlanID = PMT.PayerID
	WHERE	C.PracticeID = @practice_id
	AND	CT.TransactionDate BETWEEN @year_start_date AND @ref_date
	UNION ALL
	SELECT	C.PracticeID,
		C.RenderingProviderID AS DoctorID,
		CT.ClaimID,
		'ADJ' AS TypeCode,
		CT.ReferenceDate AS TransactionDate,
		COALESCE(CT.Amount,0) AS Amount,
		NULL AS ServiceUnitCount,
		NULL AS PayerTypeCode,
		ADJ.AdjustmentCode,
		ADJ.Description AS AdjustmentDescription
	FROM	Claim C
		INNER JOIN ClaimTransaction CT
		ON	CT.ClaimID = C.ClaimID
		AND	CT.ClaimTransactionTypeCode IN ('ADJ','END')
		LEFT OUTER JOIN Adjustment ADJ
		ON	ADJ.AdjustmentCode = CT.Code
	WHERE	C.PracticeID = @practice_id
	AND	CT.TransactionDate BETWEEN @year_start_date AND @ref_date


	--Create a temp table of doctor totals.
	SELECT	RT.DoctorID,
		SUM(
			CASE
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.ServiceUnitCount
				ELSE 0
			END
		) AS PeriodProcedureCount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.ServiceUnitCount
				ELSE 0
			END
		) AS YearProcedureCount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS PeriodChargeAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS YearChargeAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'PAY' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS PeriodReceiptAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'PAY' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS YearReceiptAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'PAY' AND RT.PayerTypeCode = 'P' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS PeriodPatientReceiptAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'PAY' AND RT.PayerTypeCode = 'P' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS YearPatientReceiptAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'PAY' AND RT.PayerTypeCode = 'I' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS PeriodInsuranceReceiptAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'PAY' AND RT.PayerTypeCode = 'I' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS YearInsuranceReceiptAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'PAY' AND RT.PayerTypeCode = 'M' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS PeriodMedicareReceiptAmount,
		SUM(
			CASE	
				WHEN RT.TypeCode = 'PAY' AND RT.PayerTypeCode = 'M' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS YearMedicareReceiptAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'ADJ' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS PeriodAdjustmentAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'ADJ' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS YearAdjustmentAmount
	INTO	#DoctorTotals
	FROM	#ReportTransactions RT
	WHERE	RT.PracticeID = @practice_id
	GROUP BY RT.DoctorID

	--Create a temp table of practice totals.
	SELECT	RT.PracticeID,
		SUM(
			CASE
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.ServiceUnitCount
				ELSE 0
			END
		) AS PeriodProcedureCount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.ServiceUnitCount
				ELSE 0
			END
		) AS YearProcedureCount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS PeriodChargeAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS YearChargeAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'PAY' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS PeriodReceiptAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'PAY' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS YearReceiptAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'PAY' AND RT.PayerTypeCode = 'P' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS PeriodPatientReceiptAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'PAY' AND RT.PayerTypeCode = 'P' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS YearPatientReceiptAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'PAY' AND RT.PayerTypeCode = 'I' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS PeriodInsuranceReceiptAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'PAY' AND RT.PayerTypeCode = 'I' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS YearInsuranceReceiptAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'PAY' AND RT.PayerTypeCode = 'M' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS PeriodMedicareReceiptAmount,
		SUM(
			CASE	
				WHEN RT.TypeCode = 'PAY' AND RT.PayerTypeCode = 'M' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS YearMedicareReceiptAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'ADJ' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS PeriodAdjustmentAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'ADJ' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS YearAdjustmentAmount
	INTO	#PracticeTotals
	FROM 	#ReportTransactions RT
	WHERE	RT.PracticeID = @practice_id
	GROUP BY RT.PracticeID


	--Retrieve the results.
	SELECT	1 AS Tag, NULL AS Parent,
		1 AS [report!1!report-ind],
		GETDATE() AS [report!1!report-date],
		@day_start_date AS [report!1!to-date],
		@period_start_date AS [report!1!period-start-date],
		@year_start_date AS [report!1!year-start-date],
		COALESCE(PT.PeriodChargeAmount,0)
			AS [report!1!practice-ptd-charge-amount],
		COALESCE(PT.PeriodReceiptAmount,0)
			AS [report!1!practice-ptd-receipt-amount],
		COALESCE(PT.PeriodAdjustmentAmount,0)
			AS [report!1!practice-ptd-adjustment-amount],
		COALESCE(PT.PeriodChargeAmount,0) - COALESCE(PT.PeriodReceiptAmount,0) - COALESCE(PT.PeriodAdjustmentAmount,0)
			AS [report!1!practice-ptd-net-ar-amount],
		0 AS [report!1!practice-ptd-total-ar-amount],
		COALESCE(PT.PeriodProcedureCount,0)
			AS [report!1!practice-ptd-procedure-count],
		COALESCE(
			CASE
			WHEN PT.PeriodChargeAmount = 0 THEN 0
			ELSE PT.PeriodReceiptAmount / PT.PeriodChargeAmount
			END,
			0
		) AS [report!1!practice-ptd-collection-rate],
		COALESCE(PT.PeriodMedicareReceiptAmount,0)
			AS [report!1!practice-ptd-medicare-receipt-amount],
		COALESCE(PT.PeriodInsuranceReceiptAmount,0)
			AS [report!1!practice-ptd-insurance-receipt-amount],
		COALESCE(PT.PeriodPatientReceiptAmount,0)
			AS [report!1!practice-ptd-patient-receipt-amount],
		COALESCE(PT.YearChargeAmount,0)
			AS [report!1!practice-ytd-charge-amount],
		COALESCE(PT.YearReceiptAmount,0)
			AS [report!1!practice-ytd-receipt-amount],
		COALESCE(PT.YearAdjustmentAmount,0)
			AS [report!1!practice-ytd-adjustment-amount],
		COALESCE(PT.YearChargeAmount,0) - COALESCE(PT.YearReceiptAmount,0) - COALESCE(PT.YearAdjustmentAmount,0)
			AS [report!1!practice-ytd-net-ar-amount],
		0 AS [report!1!practice-ytd-total-ar-amount],
		COALESCE(PT.YearProcedureCount,0)
			AS [report!1!practice-ytd-procedure-count],
		COALESCE(
			CASE
			WHEN PT.YearChargeAmount = 0 THEN 0
			ELSE PT.YearReceiptAmount / PT.YearChargeAmount
			END,
			0
		) AS [report!1!practice-ytd-collection-rate],
		COALESCE(PT.YearMedicareReceiptAmount,0)
			AS [report!1!practice-ytd-medicare-receipt-amount],
		COALESCE(PT.YearInsuranceReceiptAmount,0)
			AS [report!1!practice-ytd-insurance-receipt-amount],
		COALESCE(PT.YearPatientReceiptAmount,0)
			AS [report!1!practice-ytd-patient-receipt-amount],
		NULL AS [practice-adjustment-detail!3!adjustment-ind],
		NULL AS [practice-adjustment-detail!3!adjustment-code],
		NULL AS [practice-adjustment-detail!3!description],
		NULL AS [practice-adjustment-detail!3!ptd-amount],
		NULL AS [practice-adjustment-detail!3!ytd-amount],
		NULL AS [doctor!2!doctor-id],
		NULL AS [doctor!2!first-name],
		NULL AS [doctor!2!middle-name],
		NULL AS [doctor!2!last-name],
		NULL AS [doctor!2!suffix],
		NULL AS [doctor!2!degree],
		NULL AS [doctor!2!ptd-charge-amount],
		NULL AS [doctor!2!ptd-receipt-amount],
		NULL AS [doctor!2!ptd-adjustment-amount],
		NULL AS [doctor!2!ptd-net-ar-amount],
		NULL AS [doctor!2!ptd-total-ar-amount],
		NULL AS [doctor!2!ptd-procedure-count],
		NULL AS [doctor!2!ptd-collection-rate],
		NULL AS [doctor!2!ptd-medicare-receipt-amount],
		NULL AS [doctor!2!ptd-insurance-receipt-amount],
		NULL AS [doctor!2!ptd-patient-receipt-amount],
		NULL AS [doctor!2!ytd-charge-amount],
		NULL AS [doctor!2!ytd-receipt-amount],
		NULL AS [doctor!2!ytd-adjustment-amount],
		NULL AS [doctor!2!ytd-net-ar-amount],
		NULL AS [doctor!2!ytd-total-ar-amount],
		NULL AS [doctor!2!ytd-procedure-count],
		NULL AS [doctor!2!ytd-collection-rate],
		NULL AS [doctor!2!ytd-medicare-receipt-amount],
		NULL AS [doctor!2!ytd-insurance-receipt-amount],
		NULL AS [doctor!2!ytd-patient-receipt-amount],
		NULL AS [doctor-adjustment-detail!4!adjustment-ind],
		NULL AS [doctor-adjustment-detail!4!adjustment-code],
		NULL AS [doctor-adjustment-detail!4!description],
		NULL AS [doctor-adjustment-detail!4!ptd-amount],
		NULL AS [doctor-adjustment-detail!4!ytd-amount]
	FROM	Practice PR
		LEFT OUTER JOIN #PracticeTotals PT
		ON	PT.PracticeID = PR.PracticeID
	WHERE	PR.PracticeID = @practice_id
	UNION ALL
	SELECT	2 AS Tag, 1 AS Parent,
		1 AS [report!1!report-ind],
		NULL AS [report!1!report-date],
		NULL AS [report!1!to-date],
		NULL AS [report!1!period-start-date],
		NULL AS [report!1!year-start-date],
		NULL AS [report!1!practice-ptd-charge-amount],
		NULL AS [report!1!practice-ptd-receipt-amount],
		NULL AS [report!1!practice-ptd-adjustment-amount],
		NULL AS [report!1!practice-ptd-net-ar-amount],
		NULL AS [report!1!practice-ptd-total-ar-amount],
		NULL AS [report!1!practice-ptd-procedure-count],
		NULL AS [report!1!practice-ptd-collection-rate],
		NULL AS [report!1!practice-ptd-medicare-receipt-amount],
		NULL AS [report!1!practice-ptd-insurance-receipt-amount],
		NULL AS [report!1!practice-ptd-patient-receipt-amount],
		NULL AS [report!1!practice-ytd-charge-amount],
		NULL AS [report!1!practice-ytd-receipt-amount],
		NULL AS [report!1!practice-ytd-adjustment-amount],
		NULL AS [report!1!practice-ytd-net-ar-amount],
		NULL AS [report!1!practice-ytd-total-ar-amount],
		NULL AS [report!1!practice-ytd-procedure-count],
		NULL AS [report!1!practice-ytd-collection-rate],
		NULL AS [report!1!practice-ytd-medicare-receipt-amount],
		NULL AS [report!1!practice-ytd-insurance-receipt-amount],
		NULL AS [report!1!practice-ytd-patient-receipt-amount],
		NULL AS [practice-adjustment-detail!3!adjustment-ind],
		NULL AS [practice-adjustment-detail!3!adjustment-code],
		NULL AS [practice-adjustment-detail!3!description],
		NULL AS [practice-adjustment-detail!3!ptd-amount],
		NULL AS [practice-adjustment-detail!3!ytd-amount],
		D.DoctorID AS [doctor!2!doctor-id],
		UPPER(D.FirstName) AS [doctor!2!first-name],
		UPPER(D.MiddleName) AS [doctor!2!middle-name],
		UPPER(D.LastName) AS [doctor!2!last-name],
		UPPER(D.Suffix) AS [doctor!2!suffix],
		UPPER(D.Degree) AS [doctor!2!degree],
		COALESCE(DT.PeriodChargeAmount,0)
			AS [doctor!2!ptd-charge-amount],
		COALESCE(DT.PeriodReceiptAmount,0)
			AS [doctor!2!ptd-receipt-amount],
		COALESCE(DT.PeriodAdjustmentAmount,0)
			AS [doctor!2!ptd-adjustment-amount],
		COALESCE(DT.PeriodChargeAmount,0) - COALESCE(DT.PeriodReceiptAmount,0) - COALESCE(DT.PeriodAdjustmentAmount,0)
			AS [doctor!2!ptd-net-ar-amount],
		0 AS [doctor!2!ptd-total-ar-amount],
		COALESCE(DT.PeriodProcedureCount,0)
			AS [doctor!2!ptd-procedure-count],
		COALESCE(
			CASE
			WHEN DT.PeriodChargeAmount = 0 THEN 0
			ELSE DT.PeriodReceiptAmount / DT.PeriodChargeAmount
			END, 
			0) 
			AS [doctor!2!ptd-collection-rate],
		COALESCE(DT.PeriodMedicareReceiptAmount,0)
			AS [doctor!2!ptd-medicare-receipt-amount],
		COALESCE(DT.PeriodInsuranceReceiptAmount,0)
			AS [doctor!2!ptd-insurance-receipt-amount],
		COALESCE(DT.PeriodPatientReceiptAmount,0)
			AS [doctor!2!ptd-patient-receipt-amount],
		COALESCE(DT.YearChargeAmount,0)
			AS [doctor!2!ytd-charge-amount],
		COALESCE(DT.YearReceiptAmount,0)
			AS [doctor!2!ytd-receipt-amount],
		COALESCE(DT.YearAdjustmentAmount,0)
			AS [doctor!2!ytd-adjustment-amount],
		COALESCE(DT.YearChargeAmount,0) - COALESCE(DT.YearReceiptAmount,0) - COALESCE(DT.YearAdjustmentAmount,0)
			AS [doctor!2!ytd-net-ar-amount],
		0 AS [doctor!2!ytd-total-ar-amount],
		COALESCE(DT.YearProcedureCount,0)
			AS [doctor!2!ytd-procedure-count],
		COALESCE(
			CASE
			WHEN DT.YearChargeAmount = 0 THEN 0
			ELSE DT.YearReceiptAmount / DT.YearChargeAmount
			END,
			0)
			AS [doctor!2!ytd-collection-rate],
		COALESCE(DT.YearMedicareReceiptAmount,0)
			AS [doctor!2!ytd-medicare-receipt-amount],
		COALESCE(DT.YearInsuranceReceiptAmount,0)
			AS [doctor!2!ytd-insurance-receipt-amount],
		COALESCE(DT.YearPatientReceiptAmount,0)
			AS [doctor!2!ytd-patient-receipt-amount],
		NULL AS [doctor-adjustment-detail!4!adjustment-ind],
		NULL AS [doctor-adjustment-detail!4!adjustment-code],
		NULL AS [doctor-adjustment-detail!4!description],
		NULL AS [doctor-adjustment-detail!4!ptd-amount],
		NULL AS [doctor-adjustment-detail!4!ytd-amount]
	FROM	Doctor D
		LEFT OUTER JOIN #DoctorTotals DT
		ON	DT.DoctorID = D.DoctorID
	WHERE	D.PracticeID = @practice_id
	UNION ALL
	SELECT	3 AS Tag, 1 AS Parent,
		1 AS [report!1!report-ind],
		NULL AS [report!1!report-date],
		NULL AS [report!1!to-date],
		NULL AS [report!1!period-start-date],
		NULL AS [report!1!year-start-date],
		NULL AS [report!1!practice-ptd-charge-amount],
		NULL AS [report!1!practice-ptd-receipt-amount],
		NULL AS [report!1!practice-ptd-adjustment-amount],
		NULL AS [report!1!practice-ptd-net-ar-amount],
		NULL AS [report!1!practice-ptd-total-ar-amount],
		NULL AS [report!1!practice-ptd-procedure-count],
		NULL AS [report!1!practice-ptd-collection-rate],
		NULL AS [report!1!practice-ptd-medicare-receipt-amount],
		NULL AS [report!1!practice-ptd-insurance-receipt-amount],
		NULL AS [report!1!practice-ptd-patient-receipt-amount],
		NULL AS [report!1!practice-ytd-charge-amount],
		NULL AS [report!1!practice-ytd-receipt-amount],
		NULL AS [report!1!practice-ytd-adjustment-amount],
		NULL AS [report!1!practice-ytd-net-ar-amount],
		NULL AS [report!1!practice-ytd-total-ar-amount],
		NULL AS [report!1!practice-ytd-procedure-count],
		NULL AS [report!1!practice-ytd-collection-rate],
		NULL AS [report!1!practice-ytd-medicare-receipt-amount],
		NULL AS [report!1!practice-ytd-insurance-receipt-amount],
		NULL AS [report!1!practice-ytd-patient-receipt-amount],
		1 AS [practice-adjustment-detail!3!adjustment-ind],
		RT.AdjustmentCode
			AS [practice-adjustment-detail!3!adjustment-code],
		RT.AdjustmentDescription
			AS [practice-adjustment-detail!3!description],
		COALESCE(
			SUM(
				CASE
				WHEN RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.Amount
				ELSE 0
				END),
			0)
			AS [practice-adjustment-detail!3!ptd-amount],
		COALESCE(
			SUM(
				CASE
				WHEN RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.Amount
				ELSE 0
				END),
			0)
			AS [practice-adjustment-detail!3!ytd-amount],
		NULL AS [doctor!2!doctor-id],
		NULL AS [doctor!2!first-name],
		NULL AS [doctor!2!middle-name],
		NULL AS [doctor!2!last-name],
		NULL AS [doctor!2!suffix],
		NULL AS [doctor!2!degree],
		NULL AS [doctor!2!ptd-charge-amount],
		NULL AS [doctor!2!ptd-receipt-amount],
		NULL AS [doctor!2!ptd-adjustment-amount],
		NULL AS [doctor!2!ptd-net-ar-amount],
		NULL AS [doctor!2!ptd-total-ar-amount],
		NULL AS [doctor!2!ptd-procedure-count],
		NULL AS [doctor!2!ptd-collection-rate],
		NULL AS [doctor!2!ptd-medicare-receipt-amount],
		NULL AS [doctor!2!ptd-insurance-receipt-amount],
		NULL AS [doctor!2!ptd-patient-receipt-amount],
		NULL AS [doctor!2!ytd-charge-amount],
		NULL AS [doctor!2!ytd-receipt-amount],
		NULL AS [doctor!2!ytd-adjustment-amount],
		NULL AS [doctor!2!ytd-net-ar-amount],
		NULL AS [doctor!2!ytd-total-ar-amount],
		NULL AS [doctor!2!ytd-procedure-count],
		NULL AS [doctor!2!ytd-collection-rate],
		NULL AS [doctor!2!ytd-medicare-receipt-amount],
		NULL AS [doctor!2!ytd-insurance-receipt-amount],
		NULL AS [doctor!2!ytd-patient-receipt-amount],
		NULL AS [doctor-adjustment-detail!4!adjustment-ind],
		NULL AS [doctor-adjustment-detail!4!adjustment-code],
		NULL AS [doctor-adjustment-detail!4!description],
		NULL AS [doctor-adjustment-detail!4!ptd-amount],
		NULL AS [doctor-adjustment-detail!4!ytd-amount]
	FROM	#ReportTransactions RT
	WHERE	RT.PracticeID = @practice_id
	AND	RT.TypeCode = 'ADJ'
	GROUP BY RT.AdjustmentCode, RT.AdjustmentDescription
	UNION ALL
	SELECT	4 AS Tag, 2 AS Parent,
		1 AS [report!1!report-ind],
		NULL AS [report!1!report-date],
		NULL AS [report!1!to-date],
		NULL AS [report!1!period-start-date],
		NULL AS [report!1!year-start-date],
		NULL AS [report!1!practice-ptd-charge-amount],
		NULL AS [report!1!practice-ptd-receipt-amount],
		NULL AS [report!1!practice-ptd-adjustment-amount],
		NULL AS [report!1!practice-ptd-net-ar-amount],
		NULL AS [report!1!practice-ptd-total-ar-amount],
		NULL AS [report!1!practice-ptd-procedure-count],
		NULL AS [report!1!practice-ptd-collection-rate],
		NULL AS [report!1!practice-ptd-medicare-receipt-amount],
		NULL AS [report!1!practice-ptd-insurance-receipt-amount],
		NULL AS [report!1!practice-ptd-patient-receipt-amount],
		NULL AS [report!1!practice-ytd-charge-amount],
		NULL AS [report!1!practice-ytd-receipt-amount],
		NULL AS [report!1!practice-ytd-adjustment-amount],
		NULL AS [report!1!practice-ytd-net-ar-amount],
		NULL AS [report!1!practice-ytd-total-ar-amount],
		NULL AS [report!1!practice-ytd-procedure-count],
		NULL AS [report!1!practice-ytd-collection-rate],
		NULL AS [report!1!practice-ytd-medicare-receipt-amount],
		NULL AS [report!1!practice-ytd-insurance-receipt-amount],
		NULL AS [report!1!practice-ytd-patient-receipt-amount],
		NULL AS [practice-adjustment-detail!3!adjustment-ind],
		NULL AS [practice-adjustment-detail!3!adjustment-code],
		NULL AS [practice-adjustment-detail!3!description],
		NULL AS [practice-adjustment-detail!3!ptd-amount],
		NULL AS [practice-adjustment-detail!3!ytd-amount],
		RT.DoctorID AS [doctor!2!doctor-id],
		NULL AS [doctor!2!first-name],
		NULL AS [doctor!2!middle-name],
		NULL AS [doctor!2!last-name],
		NULL AS [doctor!2!suffix],
		NULL AS [doctor!2!degree],
		NULL AS [doctor!2!ptd-charge-amount],
		NULL AS [doctor!2!ptd-receipt-amount],
		NULL AS [doctor!2!ptd-adjustment-amount],
		NULL AS [doctor!2!ptd-net-ar-amount],
		NULL AS [doctor!2!ptd-total-ar-amount],
		NULL AS [doctor!2!ptd-procedure-count],
		NULL AS [doctor!2!ptd-collection-rate],
		NULL AS [doctor!2!ptd-medicare-receipt-amount],
		NULL AS [doctor!2!ptd-insurance-receipt-amount],
		NULL AS [doctor!2!ptd-patient-receipt-amount],
		NULL AS [doctor!2!ytd-charge-amount],
		NULL AS [doctor!2!ytd-receipt-amount],
		NULL AS [doctor!2!ytd-adjustment-amount],
		NULL AS [doctor!2!ytd-net-ar-amount],
		NULL AS [doctor!2!ytd-total-ar-amount],
		NULL AS [doctor!2!ytd-procedure-count],
		NULL AS [doctor!2!ytd-collection-rate],
		NULL AS [doctor!2!ytd-medicare-receipt-amount],
		NULL AS [doctor!2!ytd-insurance-receipt-amount],
		NULL AS [doctor!2!ytd-patient-receipt-amount],
		1 AS [doctor-adjustment-detail!4!adjustment-ind],
		RT.AdjustmentCode 
			AS [doctor-adjustment-detail!4!adjustment-code],
		RT.AdjustmentDescription
			AS [doctor-adjustment-detail!4!description],
		COALESCE(
			SUM(
				CASE
				WHEN RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.Amount
				ELSE 0
				END),
			0)
			AS [doctor-adjustment-detail!4!ptd-amount],
		COALESCE(
			SUM(
				CASE
				WHEN RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.Amount
				ELSE 0
				END),
			0)
			AS [doctor-adjustment-detail!4!ytd-amount]
	FROM	#ReportTransactions RT
	WHERE	RT.TypeCode = 'ADJ'
	GROUP BY RT.DoctorID, RT.AdjustmentCode, RT.AdjustmentDescription
	ORDER BY [report!1!report-ind],
		[practice-adjustment-detail!3!adjustment-ind],
		[doctor!2!doctor-id],
		[doctor-adjustment-detail!4!adjustment-ind],
		[doctor-adjustment-detail!4!adjustment-code]
	FOR XML EXPLICIT

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END
*/

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

