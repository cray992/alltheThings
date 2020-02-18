SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_ReportDailyReportXML]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_ReportDailyReportXML]
GO


--===========================================================================
-- REPORT DAILY REPORT
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_ReportDailyReportXML
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
		NULL DoctorID,
		C.ClaimID,
		'NEW' AS TypeCode,
		C.CreatedDate AS TransactionDate,
		0 Amount,
		C.PatientID,
		'9-15-05' AS ServiceDate,
		NULL ProcedureCode,
		0 AS ServiceChargeAmount,
		0 AS ServiceUnitCount,
-- 		PI1.InsuranceCompanyPlanID AS PrimaryInsuranceID,
-- 		PI2.InsuranceCompanyPlanID AS SecondaryInsuranceID,
		NULL PrimaryInsuranceID,
		NULL SecondaryInsuranceID,
		NULL AS LocationID,
		NULL AS CheckNumber,
		NULL AS Description,
		NULL AS PaymentAmount,
		NULL AS ReferenceDate
	INTO	#ReportTransactions
	FROM	Claim C
-- 		LEFT OUTER JOIN ClaimPayer CP1
-- 			INNER JOIN InsurancePolicy PI1
-- 			ON	PI1.InsurancePolicyID = CP1.InsurancePolicyID
-- 		ON	CP1.ClaimID = C.ClaimID
-- 		AND	CP1.Precedence = 1
-- 		LEFT OUTER JOIN ClaimPayer CP2
-- 			INNER JOIN InsurancePolicy PI2
-- 			ON	PI2.InsurancePolicyID = CP2.InsurancePolicyID
-- 		ON	CP2.ClaimID = C.ClaimID
-- 		AND	CP2.Precedence = 2
	WHERE	C.PracticeID = @practice_id
	AND	C.CreatedDate BETWEEN @year_start_date AND @ref_date
	UNION ALL 
	SELECT	C.PracticeID,
		NULL AS DoctorID,
		CT.ClaimID,
		'PAY' AS TypeCode,
		'9-15-05' TransactionDate,
		COALESCE(CT.Amount,0) AS Amount,
		C.PatientID,
		NULL AS ServiceDate,
		NULL AS ProcedureCode,
		NULL AS ServiceChargeAmount,
		NULL AS ServiceUnitCount,
		NULL AS PrimaryInsuranceID,
		NULL AS SecondaryInsuranceID,
		NULL AS LocationID,
		PMT.PaymentNumber AS CheckNumber,
		(
			CASE (PMT.PayerTypeCode)
			WHEN 'I' THEN 'Check Ins #' + CAST(PMT.PayerID AS VARCHAR)
			WHEN 'P' THEN 'Check Patient'
			ELSE 'Check Other'
			END 
		) AS Description,
		PMT.PaymentAmount AS PaymentAmount,
		PMT.PostingDate AS ReferenceDate
	FROM	Claim C
		INNER JOIN ClaimTransaction CT
		ON	CT.ClaimID = C.ClaimID
		AND	CT.ClaimTransactionTypeCode = 'PAY'
		LEFT OUTER JOIN Payment PMT
		ON	PMT.PaymentID = CT.ReferenceID
	WHERE	C.PracticeID = @practice_id
	AND	CT.PostingDate BETWEEN @year_start_date AND @ref_date
	UNION ALL
	SELECT	C.PracticeID,
		NULL AS DoctorID,
		CT.ClaimID,
		'ADJ' AS TypeCode,
		'9-15-05' TransactionDate,
		COALESCE(CT.Amount,0) AS Amount,
		C.PatientID,
		NULL AS ServiceDate,
		NULL AS ProcedureCode,
		NULL AS ServiceChargeAmount,
		NULL AS ServiceUnitCount,
		NULL AS PrimaryInsuranceID,
		NULL AS SecondaryInsuranceID,
		NULL AS LocationID,
		NULL AS CheckNumber,
		ADJ.Description AS Description,
		COALESCE(CT.Amount,0) AS PaymentAmount,
		'9-15-05' AS ReferenceDate
	FROM	Claim C
		INNER JOIN ClaimTransaction CT
		ON	CT.ClaimID = C.ClaimID
		AND	CT.ClaimTransactionTypeCode IN ('ADJ','END')
		LEFT OUTER JOIN Adjustment ADJ
		ON	ADJ.AdjustmentCode = CT.Code
	WHERE	C.PracticeID = @practice_id
	AND	CT.PostingDate BETWEEN @year_start_date AND @ref_date

	
	--Create a temp table of payments.
	SELECT	PMT.PracticeID,	
		PMT.PaymentID,
		PMT.PostingDate,
		COALESCE(PMT.PaymentAmount,0) AS PaymentAmount,
		PMT.PaymentNumber,
		COALESCE(ICP.PlanName, P.LastName + ', ' + P.FirstName, O.OtherName) AS Description,
		PMT.PayerID,
		PMT.PaymentMethodCode
	INTO	#ReportPayments
	FROM	Payment PMT
		LEFT OUTER JOIN InsuranceCompanyPlan ICP
		ON 	PMT.PayerTypeCode = 'I'
		AND 	ICP.InsuranceCompanyPlanID = PMT.PayerID
		LEFT OUTER JOIN Patient P
		ON 	PMT.PayerTypeCode = 'P'
		AND 	P.PatientID = PMT.PayerID
		LEFT OUTER JOIN Other O
		ON 	PMT.PayerTypeCode = 'O'
		AND 	O.OtherID = PMT.PayerID
	WHERE	PMT.PracticeID = @practice_id
	AND 	PMT.CreatedDate BETWEEN @day_start_date AND @ref_date


	--Create a temp table of doctor totals.
	SELECT	RT.DoctorID,
		SUM(
			CASE
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @day_start_date AND @ref_date THEN RT.ServiceUnitCount
				ELSE 0
			END
		) AS DailyProcedureCount,
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
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @day_start_date AND @ref_date THEN RT.ServiceChargeAmount * RT.ServiceUnitCount
				ELSE 0
			END
		) AS DailyChargeAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.ServiceChargeAmount * RT.ServiceUnitCount
				ELSE 0
			END
		) AS PeriodChargeAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.ServiceChargeAmount * RT.ServiceUnitCount
				ELSE 0
			END
		) AS YearChargeAmount,
		SUM(
			CASE	
				WHEN RT.TypeCode = 'PAY' AND RT.TransactionDate BETWEEN @day_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS DailyReceiptAmount,
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
				WHEN RT.TypeCode = 'ADJ' AND RT.TransactionDate BETWEEN @day_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS DailyAdjustmentAmount,
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
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @day_start_date AND @ref_date THEN RT.ServiceUnitCount
				ELSE 0
			END
		) AS DailyProcedureCount,
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
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @day_start_date AND @ref_date THEN RT.ServiceChargeAmount * RT.ServiceUnitCount
				ELSE 0
			END
		) AS DailyChargeAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @period_start_date AND @ref_date THEN RT.ServiceChargeAmount * RT.ServiceUnitCount
				ELSE 0
			END
		) AS PeriodChargeAmount,
		SUM(
			CASE
				WHEN RT.TypeCode = 'NEW' AND RT.TransactionDate BETWEEN @year_start_date AND @ref_date THEN RT.ServiceChargeAmount * RT.ServiceUnitCount
				ELSE 0
			END
		) AS YearChargeAmount,
		SUM(
			CASE	
				WHEN RT.TypeCode = 'PAY' AND RT.TransactionDate BETWEEN @day_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS DailyReceiptAmount,
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
				WHEN RT.TypeCode = 'ADJ' AND RT.TransactionDate BETWEEN @day_start_date AND @ref_date THEN RT.Amount
				ELSE 0
			END
		) AS DailyAdjustmentAmount,
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
		COALESCE(PT.DailyChargeAmount,0)
			AS [report!1!practice-daily-charge-amount],
		COALESCE(PT.DailyReceiptAmount,0)
			AS [report!1!practice-daily-receipt-amount],
		COALESCE(PT.DailyAdjustmentAmount,0)
			AS [report!1!practice-daily-adjustment-amount],
		COALESCE(PT.DailyChargeAmount,0) - COALESCE(PT.DailyReceiptAmount,0) - COALESCE(PT.DailyAdjustmentAmount,0)
			AS [report!1!practice-daily-net-ar-amount],
		0 AS [report!1!practice-daily-total-ar-amount],
		COALESCE(PT.DailyProcedureCount,0)
			AS [report!1!practice-daily-procedure-count],
		COALESCE(
			CASE 
			WHEN PT.DailyChargeAmount = 0 THEN 0
			ELSE PT.DailyReceiptAmount / PT.DailyChargeAmount
			END,
			0)
			AS [report!1!practice-daily-collection-rate],
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
			0)
			AS [report!1!practice-ptd-collection-rate],
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
			0)
			AS [report!1!practice-ytd-collection-rate],
		NULL AS [doctor!2!doctor-id],
		NULL AS [doctor!2!first-name],
		NULL AS [doctor!2!middle-name],
		NULL AS [doctor!2!last-name],
		NULL AS [doctor!2!suffix],
		NULL AS [doctor!2!degree],
		NULL AS [doctor!2!daily-charge-amount],
		NULL AS [doctor!2!daily-receipt-amount],
		NULL AS [doctor!2!daily-adjustment-amount],
		NULL AS [doctor!2!daily-net-ar-amount],
		NULL AS [doctor!2!daily-total-ar-amount],
		NULL AS [doctor!2!daily-procedure-count],
		NULL AS [doctor!2!daily-collection-rate],
		NULL AS [doctor!2!ptd-charge-amount],
		NULL AS [doctor!2!ptd-receipt-amount],
		NULL AS [doctor!2!ptd-adjustment-amount],
		NULL AS [doctor!2!ptd-net-ar-amount],
		NULL AS [doctor!2!ptd-total-ar-amount],
		NULL AS [doctor!2!ptd-procedure-count],
		NULL AS [doctor!2!ptd-collection-rate],
		NULL AS [doctor!2!ytd-charge-amount],
		NULL AS [doctor!2!ytd-receipt-amount],
		NULL AS [doctor!2!ytd-adjustment-amount],
		NULL AS [doctor!2!ytd-net-ar-amount],
		NULL AS [doctor!2!ytd-total-ar-amount],
		NULL AS [doctor!2!ytd-procedure-count],
		NULL AS [doctor!2!ytd-collection-rate],
		NULL AS [transaction!4!transaction-ind],
		NULL AS [transaction!4!transaction-date],
		NULL AS [transaction!4!transaction-type-code],
		NULL AS [transaction!4!transaction-amount],
		NULL AS [transaction!4!patient-id],
		NULL AS [transaction!4!patient-first-name],
		NULL AS [transaction!4!patient-middle-name],
		NULL AS [transaction!4!patient-last-name],
		NULL AS [transaction!4!service-date],
		NULL AS [transaction!4!procedure-code],
		NULL AS [transaction!4!service-unit-count],
		NULL AS [transaction!4!primary-insurance-id],
		NULL AS [transaction!4!secondary-insurance-id],
		NULL AS [transaction!4!location-id],
		NULL AS [transaction!4!check-number],
		NULL AS [transaction!4!description],
		NULL AS [transaction!4!payment-amount],
		NULL AS [transaction!4!reference-date],
		NULL AS [cash!3!cash-ind],
		NULL AS [cash!3!total-payment-amount],
		NULL AS [check!5!payment-id],
		NULL AS [check!5!payment-date],
		NULL AS [check!5!payment-amount],
		NULL AS [check!5!check-number],
		NULL AS [check!5!description],
		NULL AS [check!5!payer-id],
		NULL AS [cash-detail!6!cash-detail-ind],
		NULL AS [cash-detail!6!payment-method],
		NULL AS [cash-detail!6!payment-amount]
	FROM	Practice P
		LEFT OUTER JOIN #PracticeTotals PT
		ON	PT.PracticeID = P.PracticeID
	WHERE	P.PracticeID = @practice_id
	UNION ALL
	SELECT	2 AS Tag, 1 AS Parent,
		1 AS [report!1!report-ind],
		NULL AS [report!1!report-date],
		NULL AS [report!1!to-date],
		NULL AS [report!1!period-start-date],
		NULL AS [report!1!year-start-date],
		NULL AS [report!1!practice-daily-charge-amount],
		NULL AS [report!1!practice-daily-receipt-amount],
		NULL AS [report!1!practice-daily-adjustment-amount],
		NULL AS [report!1!practice-daily-net-ar-amount],
		NULL AS [report!1!practice-daily-total-ar-amount],
		NULL AS [report!1!practice-daily-procedure-count],
		NULL AS [report!11practice-daily-collection-rate],
		NULL AS [report!1!practice-ptd-charge-amount],
		NULL AS [report!1!practice-ptd-receipt-amount],
		NULL AS [report!1!practice-ptd-adjustment-amount],
		NULL AS [report!1!practice-ptd-net-ar-amount],
		NULL AS [report!1!practice-ptd-total-ar-amount],
		NULL AS [report!1!practice-ptd-procedure-count],
		NULL AS [report!1!practice-ptd-collection-rate],
		NULL AS [report!1!practice-ytd-charge-amount],
		NULL AS [report!1!practice-ytd-receipt-amount],
		NULL AS [report!1!practice-ytd-adjustment-amount],
		NULL AS [report!1!practice-ytd-net-ar-amount],
		NULL AS [report!1!practice-ytd-total-ar-amount],
		NULL AS [report!1!practice-ytd-procedure-count],
		NULL AS [report!1!practice-ytd-collection-rate],
		D.DoctorID AS [doctor!2!doctor-id],
		UPPER(D.FirstName) AS [doctor!2!first-name],
		UPPER(D.MiddleName) AS [doctor!2!middle-name],
		UPPER(D.LastName) AS [doctor!2!last-name],
		UPPER(D.Suffix) AS [doctor!2!suffix],
		UPPER(D.Degree) AS [doctor!2!degree],
		COALESCE(DT.DailyChargeAmount,0)

			AS [doctor!2!daily-charge-amount],
		COALESCE(DT.DailyReceiptAmount,0)
			AS [doctor!2!daily-receipt-amount],
		COALESCE(DT.DailyAdjustmentAmount,0)
			AS [doctor!2!daily-adjustment-amount],
		COALESCE(DT.DailyChargeAmount,0) - COALESCE(DT.DailyReceiptAmount,0) - COALESCE(DT.DailyAdjustmentAmount,0)
			AS [doctor!2!daily-net-ar-amount],
		0 AS [doctor!2!daily-total-ar-amount],
		COALESCE(DT.DailyProcedureCount,0)
			AS [doctor!2!daily-procedure-count],
		COALESCE(
			CASE
			WHEN DT.DailyChargeAmount = 0 THEN 0
			ELSE DT.DailyReceiptAmount / DT.DailyChargeAmount
			END,
			0)
			AS [doctor!2!daily-collection-rate],
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
		NULL AS [transaction!4!transaction-ind],
		NULL AS [transaction!4!transaction-date],
		NULL AS [transaction!4!transaction-type-code],
		NULL AS [transaction!4!transaction-amount],
		NULL AS [transaction!4!patient-id],
		NULL AS [transaction!4!patient-first-name],
		NULL AS [transaction!4!patient-middle-name],
		NULL AS [transaction!4!patient-last-name],
		NULL AS [transaction!4!service-date],
		NULL AS [transaction!4!procedure-code],
		NULL AS [transaction!4!service-unit-count],
		NULL AS [transaction!4!primary-insurance-id],
		NULL AS [transaction!4!secondary-insurance-id],
		NULL AS [transaction!4!location-id],
		NULL AS [transaction!4!check-number],
		NULL AS [transaction!4!description],
		NULL AS [transaction!4!payment-amount],
		NULL AS [transaction!4!reference-date],
		NULL AS [cash!3!cash-ind],
		NULL AS [cash!3!total-payment-amount],
		NULL AS [check!5!payment-id],
		NULL AS [check!5!payment-date],
		NULL AS [check!5!payment-amount],
		NULL AS [check!5!check-number],
		NULL AS [check!5!description],
		NULL AS [check!5!payer-id],
		NULL AS [cash-detail!6!cash-detail-ind],
		NULL AS [cash-detail!6!payment-method],
		NULL AS [cash-detail!6!payment-amount]
	FROM	Doctor D
		LEFT OUTER JOIN #DoctorTotals DT
		ON	DT.DoctorID = D.DoctorID
	WHERE	D.PracticeID = @practice_id
	UNION ALL
	SELECT	3 AS Tag, 1 AS Parent,
		1 AS [report!1!report-id],
		NULL AS [report!1!report-date],
		NULL AS [report!1!to-date],
		NULL AS [report!1!period-start-date],
		NULL AS [report!1!year-start-date],
		NULL AS [report!1!practice-daily-charge-amount],
		NULL AS [report!1!practice-daily-receipt-amount],
		NULL AS [report!1!practice-daily-adjustment-amount],
		NULL AS [report!1!practice-daily-net-ar-amount],
		NULL AS [report!1!practice-daily-total-ar-amount],
		NULL AS [report!1!practice-daily-procedure-count],
		NULL AS [report!11practice-daily-collection-rate],
		NULL AS [report!1!practice-ptd-charge-amount],
		NULL AS [report!1!practice-ptd-receipt-amount],
		NULL AS [report!1!practice-ptd-adjustment-amount],
		NULL AS [report!1!practice-ptd-net-ar-amount],
		NULL AS [report!1!practice-ptd-total-ar-amount],
		NULL AS [report!1!practice-ptd-procedure-count],
		NULL AS [report!1!practice-ptd-collection-rate],
		NULL AS [report!1!practice-ytd-charge-amount],
		NULL AS [report!1!practice-ytd-receipt-amount],
		NULL AS [report!1!practice-ytd-adjustment-amount],
		NULL AS [report!1!practice-ytd-net-ar-amount],
		NULL AS [report!1!practice-ytd-total-ar-amount],
		NULL AS [report!1!practice-ytd-procedure-count],
		NULL AS [report!1!practice-ytd-collection-rate],
		NULL AS [doctor!2!doctor-id],
		NULL AS [doctor!2!first-name],
		NULL AS [doctor!2!middle-name],
		NULL AS [doctor!2!last-name],
		NULL AS [doctor!2!suffix],
		NULL AS [doctor!2!degree],
		NULL AS [doctor!2!daily-charge-amount],
		NULL AS [doctor!2!daily-receipt-amount],
		NULL AS [doctor!2!daily-adjustment-amount],
		NULL AS [doctor!2!daily-net-ar-amount],
		NULL AS [doctor!2!daily-total-ar-amount],
		NULL AS [doctor!2!daily-procedure-count],
		NULL AS [doctor!2!daily-collection-rate],
		NULL AS [doctor!2!ptd-charge-amount],
		NULL AS [doctor!2!ptd-receipt-amount],
		NULL AS [doctor!2!ptd-adjustment-amount],
		NULL AS [doctor!2!ptd-net-ar-amount],
		NULL AS [doctor!2!ptd-total-ar-amount],
		NULL AS [doctor!2!ptd-procedure-count],
		NULL AS [doctor!2!ptd-collection-rate],
		NULL AS [doctor!2!ytd-charge-amount],
		NULL AS [doctor!2!ytd-receipt-amount],
		NULL AS [doctor!2!ytd-adjustment-amount],
		NULL AS [doctor!2!ytd-net-ar-amount],
		NULL AS [doctor!2!ytd-total-ar-amount],
		NULL AS [doctor!2!ytd-procedure-count],
		NULL AS [doctor!2!ytd-collection-rate],
		NULL AS [transaction!4!transaction-id],
		NULL AS [transaction!4!transaction-date],
		NULL AS [transaction!4!transaction-type-code],
		NULL AS [transaction!4!transaction-amount],
		NULL AS [transaction!4!patient-id],
		NULL AS [transaction!4!patient-first-name],
		NULL AS [transaction!4!patient-middle-name],
		NULL AS [transaction!4!patient-last-name],
		NULL AS [transaction!4!service-date],
		NULL AS [transaction!4!procedure-code],
		NULL AS [transaction!4!service-unit-count],
		NULL AS [transaction!4!primary-insurance-id],
		NULL AS [transaction!4!secondary-insurance-id],
		NULL AS [transaction!4!location-id],
		NULL AS [transaction!4!check-number],
		NULL AS [transaction!4!description],
		NULL AS [transaction!4!payment-amount],
		NULL AS [transaction!4!reference-date],
		1 AS [cash!3!cash-id],
		COALESCE(SUM(RP.PaymentAmount),0)
			AS [cash!3!total-payment-amount],
		NULL AS [check!5!payment-id],
		NULL AS [check!5!payment-date],
		NULL AS [check!5!payment-amount],
		NULL AS [check!5!check-number],
		NULL AS [check!5!description],
		NULL AS [check!5!payer-id],
		NULL AS [cash-detail!6!cash-detail-ind],
		NULL AS [cash-detail!6!payment-method],
		NULL AS [cash-detail!6!payment-amount]
	FROM	Practice PR
		LEFT OUTER JOIN #ReportPayments RP
		ON	RP.PracticeID = PR.PracticeID
	WHERE	PR.PracticeID = @practice_id
	UNION ALL
	SELECT	4 AS Tag, 2 AS Parent,
		1 AS [report!1!report-id],
		NULL AS [report!1!report-date],
		NULL AS [report!1!to-date],
		NULL AS [report!1!period-start-date],
		NULL AS [report!1!year-start-date],
		NULL AS [report!1!practice-daily-charge-amount],
		NULL AS [report!1!practice-daily-receipt-amount],
		NULL AS [report!1!practice-daily-adjustment-amount],
		NULL AS [report!1!practice-daily-net-ar-amount],
		NULL AS [report!1!practice-daily-total-ar-amount],
		NULL AS [report!1!practice-daily-procedure-count],
		NULL AS [report!11practice-daily-collection-rate],
		NULL AS [report!1!practice-ptd-charge-amount],
		NULL AS [report!1!practice-ptd-receipt-amount],
		NULL AS [report!1!practice-ptd-adjustment-amount],
		NULL AS [report!1!practice-ptd-net-ar-amount],
		NULL AS [report!1!practice-ptd-total-ar-amount],
		NULL AS [report!1!practice-ptd-procedure-count],
		NULL AS [report!1!practice-ptd-collection-rate],
		NULL AS [report!1!practice-ytd-charge-amount],
		NULL AS [report!1!practice-ytd-receipt-amount],
		NULL AS [report!1!practice-ytd-adjustment-amount],
		NULL AS [report!1!practice-ytd-net-ar-amount],
		NULL AS [report!1!practice-ytd-total-ar-amount],
		NULL AS [report!1!practice-ytd-procedure-count],
		NULL AS [report!1!practice-ytd-collection-rate],
		RT.DoctorID AS [doctor!2!doctor-id],
		NULL AS [doctor!2!first-name],
		NULL AS [doctor!2!middle-name],
		NULL AS [doctor!2!last-name],
		NULL AS [doctor!2!suffix],
		NULL AS [doctor!2!degree],
		NULL AS [doctor!2!daily-charge-amount],
		NULL AS [doctor!2!daily-receipt-amount],
		NULL AS [doctor!2!daily-adjustment-amount],
		NULL AS [doctor!2!daily-net-ar-amount],
		NULL AS [doctor!2!daily-total-ar-amount],
		NULL AS [doctor!2!daily-procedure-count],
		NULL AS [doctor!2!daily-collection-rate],
		NULL AS [doctor!2!ptd-charge-amount],
		NULL AS [doctor!2!ptd-receipt-amount],
		NULL AS [doctor!2!ptd-adjustment-amount],
		NULL AS [doctor!2!ptd-net-ar-amount],
		NULL AS [doctor!2!ptd-total-ar-amount],
		NULL AS [doctor!2!ptd-procedure-count],
		NULL AS [doctor!2!ptd-collection-rate],
		NULL AS [doctor!2!ytd-charge-amount],
		NULL AS [doctor!2!ytd-receipt-amount],
		NULL AS [doctor!2!ytd-adjustment-amount],
		NULL AS [doctor!2!ytd-net-ar-amount],
		NULL AS [doctor!2!ytd-total-ar-amount],
		NULL AS [doctor!2!ytd-procedure-count],
		NULL AS [doctor!2!ytd-collection-rate],
		1 AS [transaction!4!transaction-ind],
		DATEADD(hour,5,RT.TransactionDate)
			AS [transaction!4!transaction-date],
		RT.TypeCode 
			AS [transaction!4!transaction-type-code],
		RT.Amount
			AS [transaction!4!transaction-amount],
		RT.PatientID
			AS [transaction!4!patient-id],
		UPPER(P.FirstName) 
			AS [transaction!4!patient-first-name],
		UPPER(P.MiddleName) 
			AS [transaction!4!patient-middle-name],
		UPPER(P.LastName) 
			AS [transaction!4!patient-last-name],
		DATEADD(hour,5,RT.ServiceDate)
			AS [transaction!4!service-date],
		RT.ProcedureCode
			AS [transaction!4!procedure-code],
		RT.ServiceUnitCount
			AS [transaction!4!service-unit-count],
		RT.PrimaryInsuranceID
			AS [transaction!4!primary-insurance-id],
		RT.SecondaryInsuranceID
			AS [transaction!4!secondary-insurance-id],
		RT.LocationID AS [transaction!4!location-id],
		RT.CheckNumber 
			AS [transaction!4!check-number],
		RT.Description
			AS [transaction!4!description],
		RT.PaymentAmount
			AS [transaction!4!payment-amount],
		RT.ReferenceDate 
			AS [transaction!4!reference-date],
		NULL AS [cash!3!cash-ind],
		NULL AS [cash!3!total-payment-amount],
		NULL AS [check!5!payment-id],
		NULL AS [check!5!payment-date],
		NULL AS [check!5!payment-amount],
		NULL AS [check!5!check-number],
		NULL AS [check!5!description],
		NULL AS [check!5!payer-id],
		NULL AS [cash-detail!6!cash-detail-ind],
		NULL AS [cash-detail!6!payment-method],
		NULL AS [cash-detail!6!payment-amount]
	FROM 	#ReportTransactions RT
		LEFT OUTER JOIN Patient P
		ON 	P.PatientID = RT.PatientID
	WHERE	RT.TransactionDate BETWEEN @day_start_date AND @ref_date
	UNION ALL
	SELECT	5 AS Tag, 3 AS Parent,
		1 AS [report!1!report-ind],
		NULL AS [report!1!report-date],
		NULL AS [report!1!to-date],
		NULL AS [report!1!period-start-date],
		NULL AS [report!1!year-start-date],
		NULL AS [report!1!practice-daily-charge-amount],
		NULL AS [report!1!practice-daily-receipt-amount],
		NULL AS [report!1!practice-daily-adjustment-amount],
		NULL AS [report!1!practice-daily-net-ar-amount],
		NULL AS [report!1!practice-daily-total-ar-amount],
		NULL AS [report!1!practice-daily-procedure-count],
		NULL AS [report!11practice-daily-collection-rate],
		NULL AS [report!1!practice-ptd-charge-amount],
		NULL AS [report!1!practice-ptd-receipt-amount],
		NULL AS [report!1!practice-ptd-adjustment-amount],
		NULL AS [report!1!practice-ptd-net-ar-amount],
		NULL AS [report!1!practice-ptd-total-ar-amount],
		NULL AS [report!1!practice-ptd-procedure-count],
		NULL AS [report!1!practice-ptd-collection-rate],
		NULL AS [report!1!practice-ytd-charge-amount],
		NULL AS [report!1!practice-ytd-receipt-amount],
		NULL AS [report!1!practice-ytd-adjustment-amount],
		NULL AS [report!1!practice-ytd-net-ar-amount],
		NULL AS [report!1!practice-ytd-total-ar-amount],
		NULL AS [report!1!practice-ytd-procedure-count],
		NULL AS [report!1!practice-ytd-collection-rate],
		NULL AS [doctor!2!doctor-id],
		NULL AS [doctor!2!first-name],
		NULL AS [doctor!2!middle-name],
		NULL AS [doctor!2!last-name],
		NULL AS [doctor!2!suffix],
		NULL AS [doctor!2!degree],
		NULL AS [doctor!2!daily-charge-amount],
		NULL AS [doctor!2!daily-receipt-amount],
		NULL AS [doctor!2!daily-adjustment-amount],
		NULL AS [doctor!2!daily-net-ar-amount],
		NULL AS [doctor!2!daily-total-ar-amount],
		NULL AS [doctor!2!daily-procedure-count],
		NULL AS [doctor!2!daily-collection-rate],
		NULL AS [doctor!2!ptd-charge-amount],
		NULL AS [doctor!2!ptd-receipt-amount],
		NULL AS [doctor!2!ptd-adjustment-amount],
		NULL AS [doctor!2!ptd-net-ar-amount],
		NULL AS [doctor!2!ptd-total-ar-amount],
		NULL AS [doctor!2!ptd-procedure-count],
		NULL AS [doctor!2!ptd-collection-rate],
		NULL AS [doctor!2!ytd-charge-amount],
		NULL AS [doctor!2!ytd-receipt-amount],
		NULL AS [doctor!2!ytd-adjustment-amount],
		NULL AS [doctor!2!ytd-net-ar-amount],
		NULL AS [doctor!2!ytd-total-ar-amount],
		NULL AS [doctor!2!ytd-procedure-count],
		NULL AS [doctor!2!ytd-collection-rate],
		NULL AS [transaction!4!transaction-ind],
		NULL AS [transaction!4!transaction-date],
		NULL AS [transaction!4!transaction-type-code],
		NULL AS [transaction!4!transaction-amount],
		NULL AS [transaction!4!patient-id],
		NULL AS [transaction!4!patient-first-name],
		NULL AS [transaction!4!patient-middle-name],
		NULL AS [transaction!4!patient-last-name],
		NULL AS [transaction!4!service-date],
		NULL AS [transaction!4!procedure-code],
		NULL AS [transaction!4!service-unit-count],
		NULL AS [transaction!4!primary-insurance-id],
		NULL AS [transaction!4!secondary-insurance-id],
		NULL AS [transaction!4!location-id],
		NULL AS [transaction!4!check-number],
		NULL AS [transaction!4!description],
		NULL AS [transaction!4!payment-amount],
		NULL AS [transaction!4!reference-date],
		1 AS [cash!3!cash-ind],
		NULL AS [cash!3!total-payment-amount],
		RP.PaymentID 
			AS [check!5!payment-id],
		DATEADD(hour,5,RP.PostingDate)
			AS [check!5!payment-date],
		RP.PaymentAmount 
			AS [check!5!payment-amount],
		RP.PaymentNumber 
			AS [check!5!check-number],
		RP.Description
			AS [check!5!description],
		RP.PayerID
			AS [check!5!payer-id],
		NULL AS [cash-detail!6!cash-detail-ind],
		NULL AS [cash-detail!6!payment-method],
		NULL AS [cash-detail!6!payment-amount]
	FROM	#ReportPayments RP
	UNION ALL
	SELECT	6 AS Tag, 3 AS Parent,
		1 AS [report!1!report-ind],
		NULL AS [report!1!report-date],
		NULL AS [report!1!to-date],
		NULL AS [report!1!period-start-date],
		NULL AS [report!1!year-start-date],
		NULL AS [report!1!practice-daily-charge-amount],
		NULL AS [report!1!practice-daily-receipt-amount],
		NULL AS [report!1!practice-daily-adjustment-amount],
		NULL AS [report!1!practice-daily-net-ar-amount],
		NULL AS [report!1!practice-daily-total-ar-amount],
		NULL AS [report!1!practice-daily-procedure-count],
		NULL AS [report!11practice-daily-collection-rate],
		NULL AS [report!1!practice-ptd-charge-amount],
		NULL AS [report!1!practice-ptd-receipt-amount],
		NULL AS [report!1!practice-ptd-adjustment-amount],
		NULL AS [report!1!practice-ptd-net-ar-amount],
		NULL AS [report!1!practice-ptd-total-ar-amount],
		NULL AS [report!1!practice-ptd-procedure-count],
		NULL AS [report!1!practice-ptd-collection-rate],
		NULL AS [report!1!practice-ytd-charge-amount],
		NULL AS [report!1!practice-ytd-receipt-amount],
		NULL AS [report!1!practice-ytd-adjustment-amount],
		NULL AS [report!1!practice-ytd-net-ar-amount],
		NULL AS [report!1!practice-ytd-total-ar-amount],
		NULL AS [report!1!practice-ytd-procedure-count],
		NULL AS [report!1!practice-ytd-collection-rate],
		NULL AS [doctor!2!doctor-id],
		NULL AS [doctor!2!first-name],
		NULL AS [doctor!2!middle-name],
		NULL AS [doctor!2!last-name],
		NULL AS [doctor!2!suffix],
		NULL AS [doctor!2!degree],
		NULL AS [doctor!2!daily-charge-amount],
		NULL AS [doctor!2!daily-receipt-amount],
		NULL AS [doctor!2!daily-adjustment-amount],
		NULL AS [doctor!2!daily-net-ar-amount],
		NULL AS [doctor!2!daily-total-ar-amount],
		NULL AS [doctor!2!daily-procedure-count],
		NULL AS [doctor!2!daily-collection-rate],
		NULL AS [doctor!2!ptd-charge-amount],
		NULL AS [doctor!2!ptd-receipt-amount],
		NULL AS [doctor!2!ptd-adjustment-amount],
		NULL AS [doctor!2!ptd-net-ar-amount],
		NULL AS [doctor!2!ptd-total-ar-amount],
		NULL AS [doctor!2!ptd-procedure-count],
		NULL AS [doctor!2!ptd-collection-rate],
		NULL AS [doctor!2!ytd-charge-amount],
		NULL AS [doctor!2!ytd-receipt-amount],
		NULL AS [doctor!2!ytd-adjustment-amount],
		NULL AS [doctor!2!ytd-net-ar-amount],
		NULL AS [doctor!2!ytd-total-ar-amount],
		NULL AS [doctor!2!ytd-procedure-count],
		NULL AS [doctor!2!ytd-collection-rate],
		NULL AS [transaction!4!transaction-ind],
		NULL AS [transaction!4!transaction-date],
		NULL AS [transaction!4!transaction-type-code],
		NULL AS [transaction!4!transaction-amount],
		NULL AS [transaction!4!patient-id],
		NULL AS [transaction!4!patient-first-name],
		NULL AS [transaction!4!patient-middle-name],
		NULL AS [transaction!4!patient-last-name],
		NULL AS [transaction!4!service-date],
		NULL AS [transaction!4!procedure-code],
		NULL AS [transaction!4!service-unit-count],
		NULL AS [transaction!4!primary-insurance-id],
		NULL AS [transaction!4!secondary-insurance-id],
		NULL AS [transaction!4!location-id],
		NULL AS [transaction!4!check-number],
		NULL AS [transaction!4!description],
		NULL AS [transaction!4!payment-amount],
		NULL AS [transaction!4!reference-date],
		1 AS [cash!3!cash-ind],
		NULL AS [cash!3!total-payment-amount],
		NULL AS [check!5!payment-id],
		NULL AS [check!5!payment-date],
		NULL AS [check!5!payment-amount],
		NULL AS [check!5!check-number],
		NULL AS [check!5!description],
		NULL AS [check!5!payer-id],
		1 AS [cash-detail!6!cash-detail-ind],
		PMC.Description 
			AS [cash-detail!6!payment-method],
		COALESCE(SUM(RP.PaymentAmount),0)
			AS [cash-detail!6!payment-amount]
	FROM	PaymentMethodCode PMC
		LEFT OUTER JOIN #ReportPayments RP
		ON	RP.PaymentMethodCode = PMC.PaymentMethodCode
	GROUP BY PMC.Description

	ORDER BY [report!1!report-ind],
		[doctor!2!doctor-id],
		[cash!3!cash-ind],
		[transaction!4!transaction-ind],
		[transaction!4!patient-last-name],
		[check!5!payment-id],
		[cash-detail!6!cash-detail-ind]
	FOR XML EXPLICIT

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

