IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_ClaimInsuranceReceiptAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_ClaimInsuranceReceiptAmount
GO

--===========================================================================
-- CLAIM INSURANCE RECEIPT Amount
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_ClaimInsuranceReceiptAmount (@claim_id INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @receipt_amount MONEY
	SET @receipt_amount = (
		SELECT	SUM(COALESCE(CT.Amount,0))
		FROM	CLAIM C
			INNER JOIN CLAIMTRANSACTION CT
			ON CT.ClaimID = C.ClaimID
			AND CT.ClaimTransactionTypeCode = 'PAY'
			INNER JOIN PAYMENT P
			ON P.PaymentID = CT.ReferenceID
			AND P.PayerTypeCode = 'I'
			INNER JOIN INSURANCECOMPANYPLAN ICP
			ON ICP.InsuranceCompanyPlanID = P.PayerID
		WHERE	C.ClaimID = @claim_id
		AND	ICP.InsuranceProgramCode <> 'M')
	
	RETURN COALESCE(@receipt_amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_ClaimMedicareReceiptAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_ClaimMedicareReceiptAmount
GO

--===========================================================================
-- CLAIM MEDICARE RECEIPT Amount
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_ClaimMedicareReceiptAmount (@claim_id INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @receipt_amount MONEY
	SET @receipt_amount = (
		SELECT	SUM(COALESCE(CT.Amount,0))
		FROM	CLAIM C
			INNER JOIN CLAIMTRANSACTION CT
			ON CT.ClaimID = C.ClaimID
			AND CT.ClaimTransactionTypeCode = 'PAY'
			INNER JOIN PAYMENT P
			ON P.PaymentID = CT.ReferenceID
			AND P.PayerTypeCode = 'I'
			INNER JOIN INSURANCECOMPANYPLAN ICP
			ON ICP.InsuranceCompanyPlanID = P.PayerID
		WHERE	C.ClaimID = @claim_id
		AND	ICP.InsuranceProgramCode = 'M')
	
	RETURN COALESCE(@receipt_amount, 0)
END
GO
	
IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_ClaimPatientReceiptAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_ClaimPatientReceiptAmount
GO

--===========================================================================
-- CLAIM PATIENT RECEIPT Amount
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_ClaimPatientReceiptAmount (@claim_id INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @receipt_amount MONEY
	SET @receipt_amount = (
		SELECT	SUM(COALESCE(CT.Amount,0))
		FROM	CLAIM C
			INNER JOIN CLAIMTRANSACTION CT
			ON CT.ClaimID = C.ClaimID
			AND CT.ClaimTransactionTypeCode = 'PAY'
			INNER JOIN PAYMENT P
			ON P.PaymentID = CT.ReferenceID
			AND P.PayerTypeCode = 'P'
		WHERE	C.ClaimID = @claim_id)

	RETURN COALESCE(@receipt_amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorCollectionRateForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorCollectionRateForPeriod
GO

--===========================================================================
-- DOCTOR COLLECTION RATE FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_DoctorCollectionRateForPeriod (@doctor_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS FLOAT
AS
BEGIN
	DECLARE @rate FLOAT
	DECLARE @charges MONEY
	DECLARE @receipts MONEY
	SET @charges = dbo.BusinessRule_DoctorChargesForPeriod(@doctor_id, @start_date, @end_date)
	SET @receipts = dbo.BusinessRule_DoctorReceiptsForPeriod(@doctor_id, @start_date, @end_date)

	IF (@charges = 0)
		RETURN 0.0

	SET @rate = @receipts / @charges

	RETURN COALESCE(@rate, 0.0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorProcedureChargeAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorProcedureChargeAmountForPeriod
GO

--===========================================================================
-- DOCTOR PROCEDURE CHARGE Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_DoctorProcedureChargeAmountForPeriod (
	@doctor_id INT, 
	@procedure_id INT,
	@start_date DATETIME,
	@end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimOriginalChargeAmount(C.ClaimID))
		FROM	EncounterProcedure EP
			INNER JOIN Claim C
			ON C.EncounterProcedureID = EP.EncounterProcedureID
			AND C.CreatedDate BETWEEN @start_date AND @end_date
		WHERE	C.RenderingProviderID = @doctor_id
		AND	EP.ProcedureCodeDictionaryID = @procedure_id)

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorProcedureUnitCountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorProcedureUnitCountForPeriod
GO

--===========================================================================
-- DOCTOR PROCEDURE UNIT COUNT FOR PERIOD
--===========================================================================
-- Total units for the doctor for the given procedure for the given period.
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_DoctorProcedureUnitCountForPeriod (
	@doctor_id INT, 
	@procedure_id INT, 
	@start_date DATETIME, 
	@end_date DATETIME)
RETURNS FLOAT
AS
BEGIN
	DECLARE @units FLOAT
	SET @units = (
		SELECT	SUM(COALESCE(C.ServiceUnitCount, 1))
		FROM	EncounterProcedure EP
			INNER JOIN Claim C
			ON C.EncounterProcedureID = EP.EncounterProcedureID
			AND C.CreatedDate BETWEEN @start_date AND @end_date
		WHERE	C.RenderingProviderID = @doctor_id
		AND	EP.ProcedureCodeDictionaryID = @procedure_id)
	
	RETURN COALESCE(@units, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorRefundsForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorRefundsForPeriod
GO

--===========================================================================
-- DOCTOR REFUNDS FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_DoctorRefundsForPeriod (@doctor_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY

	RETURN COALESCE(@amount, 0)
END
GO


IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_EDIBillTotalBalanceAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_EDIBillTotalBalanceAmount
GO

--===========================================================================
-- EDI BILL TOTAL BALANCE Amount
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_EDIBillTotalBalanceAmount (@bill_id INT)
RETURNS MONEY
AS
BEGIN
	RETURN	dbo.BusinessRule_EDIBillTotalAdjustedChargeAmount(@bill_id) - dbo.BusinessRule_EDIBillTotalPaidAmount(@bill_id)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_EncounterDiagnosisCode'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_EncounterDiagnosisCode
GO

--===========================================================================
-- ENCOUNTER DIAGNOSIS Code
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_EncounterDiagnosisCode (@encounter_id INT, @index INT)
RETURNS VARCHAR(16)
AS
BEGIN
	DECLARE @retval VARCHAR(16)
	SET @retval = NULL

	DECLARE @diagnosis_code VARCHAR(16)
	DECLARE @diagnosis_index INT
	DECLARE diagnosis_cursor CURSOR READ_ONLY
	FOR	
		SELECT	DCD.DiagnosisCode
		FROM	EncounterDiagnosis ED
			INNER JOIN DiagnosisCodeDictionary DCD
			ON DCD.DiagnosisCodeDictionaryID = ED.DiagnosisCodeDictionaryID
		WHERE	ED.EncounterID = @encounter_id
		ORDER BY ED.EncounterDiagnosisID
	
	OPEN diagnosis_cursor

	SET @diagnosis_index = 1
	FETCH NEXT FROM diagnosis_cursor
	INTO	@diagnosis_code

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		IF (@diagnosis_index = @index)
			SET @retval = @diagnosis_code

		SET @diagnosis_index = @diagnosis_index + 1
		FETCH NEXT FROM diagnosis_cursor
		INTO	@diagnosis_code
	END

	CLOSE diagnosis_cursor
	DEALLOCATE diagnosis_cursor

	RETURN @retval
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_EncounterDiagnosisIndex'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_EncounterDiagnosisIndex
GO

--===========================================================================
-- ENCOUNTER DIAGNOSIS INDEX
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_EncounterDiagnosisIndex (@encounter_id INT, @encounter_diagnosis_id INT)
RETURNS INT
AS
BEGIN
	DECLARE @retval INT
	SET @retval = NULL

	DECLARE @diagnosis_id INT
	DECLARE @diagnosis_index INT
	DECLARE diagnosis_cursor CURSOR READ_ONLY
	FOR
		SELECT	EncounterDiagnosisID
		FROM	EncounterDiagnosis
		WHERE	EncounterID = @encounter_id
		ORDER BY EncounterDiagnosisID

	OPEN diagnosis_cursor

	SET @diagnosis_index = 1
	FETCH NEXT FROM diagnosis_cursor
	INTO	@diagnosis_id

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		IF (@diagnosis_id = @encounter_diagnosis_id)
			SET @retval = @diagnosis_index

		SET @diagnosis_index = @diagnosis_index + 1
		FETCH NEXT FROM diagnosis_cursor
		INTO	@diagnosis_id
	END

	CLOSE diagnosis_cursor
	DEALLOCATE diagnosis_cursor

	RETURN @retval
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_InsurancePlanCurrentBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_InsurancePlanCurrentBalance
GO

--===========================================================================
-- INSURANCE PLAN CURRENT BALANCE
--===========================================================================
-- Total balance for all claims billed within the last 30 days.
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_InsurancePlanCurrentBalance (@plan_id INT, @practice_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimPayerBalanceAmount(BC.ClaimID, @plan_id))
		FROM	BillClaim BC
		WHERE EXISTS (
			SELECT	PI.PatientInsuranceID
			FROM	BillBatch BB
				INNER JOIN Bill_HCFA B
				ON B.BillBatchID = BB.BillBatchID
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID =
					B.PayerPatientInsuranceID
			WHERE 	BB.PracticeID = @practice_id
			AND BB.ConfirmedDate IS NOT NULL
			AND	B.BillID = BC.BillID
			AND	BC.BillBatchTypeCode = 'P'
			AND	PI.InsuranceCompanyPlanID = @plan_id
			UNION ALL
			SELECT	PI.PatientInsuranceID
			FROM	BillBatch BB
				INNER JOIN Bill_EDI B
				ON B.BillBatchID = BB.BillBatchID
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID =
					B.PayerPatientInsuranceID
			WHERE 	BB.PracticeID = @practice_id
			AND BB.ConfirmedDate IS NOT NULL
			AND	B.BillID = BC.BillID
			AND	BC.BillBatchTypeCode = 'P'
			AND	PI.InsuranceCompanyPlanID = @plan_id)
		AND	DATEDIFF(day, dbo.BusinessRule_ClaimPayerOriginalBillDate(BC.ClaimID, @plan_id), @ref_date) <= 30)

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_InsurancePlanNinetyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_InsurancePlanNinetyDayBalance
GO

--===========================================================================
-- INSURANCE PLAN NINETY DAY BALANCE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_InsurancePlanNinetyDayBalance (@plan_id INT, @practice_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimPayerBalanceAmount(BC.ClaimID, @plan_id))
		FROM	BillClaim BC
		WHERE EXISTS (
			SELECT	PI.PatientInsuranceID
			FROM	BillBatch BB
				INNER JOIN Bill_HCFA B
				ON B.BillBatchID = BB.BillBatchID
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID =
					B.PayerPatientInsuranceID
			WHERE 	BB.PracticeID = @practice_id
			AND BB.ConfirmedDate IS NOT NULL
			AND	B.BillID = BC.BillID
			AND	BC.BillBatchTypeCode = 'P'
			AND	PI.InsuranceCompanyPlanID = @plan_id
			UNION ALL
			SELECT	PI.PatientInsuranceID
			FROM	BillBatch BB
				INNER JOIN Bill_EDI B
				ON B.BillBatchID = BB.BillBatchID
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID =
					B.PayerPatientInsuranceID
			WHERE 	BB.PracticeID = @practice_id
			AND BB.ConfirmedDate IS NOT NULL
			AND	B.BillID = BC.BillID
			AND	BC.BillBatchTypeCode = 'P'
			AND	PI.InsuranceCompanyPlanID = @plan_id)
		AND	DATEDIFF(day, dbo.BusinessRule_ClaimPayerOriginalBillDate(BC.ClaimID, @plan_id), @ref_date) <= 120
		AND	DATEDIFF(day, dbo.BusinessRule_ClaimPayerOriginalBillDate(BC.ClaimID, @plan_id), @ref_date) > 90)

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_InsurancePlanOneHundredTwentyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_InsurancePlanOneHundredTwentyDayBalance
GO

--===========================================================================
-- INSURANCE PLAN ONE HUNDRED TWENTY DAY BALANCE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_InsurancePlanOneHundredTwentyDayBalance (@plan_id INT, @practice_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimPayerBalanceAmount(BC.ClaimID, @plan_id))
		FROM	BillClaim BC
		WHERE EXISTS (
			SELECT	PI.PatientInsuranceID
			FROM	BillBatch BB
				INNER JOIN Bill_HCFA B
				ON B.BillBatchID = BB.BillBatchID
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID =
					B.PayerPatientInsuranceID
			WHERE 	BB.PracticeID = @practice_id
			AND BB.ConfirmedDate IS NOT NULL
			AND	B.BillID = BC.BillID
			AND	BC.BillBatchTypeCode = 'P'
			AND	PI.InsuranceCompanyPlanID = @plan_id
			UNION ALL
			SELECT	PI.PatientInsuranceID
			FROM	BillBatch BB
				INNER JOIN Bill_EDI B
				ON B.BillBatchID = BB.BillBatchID
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID =
					B.PayerPatientInsuranceID
			WHERE 	BB.PracticeID = @practice_id
			AND BB.ConfirmedDate IS NOT NULL
			AND	B.BillID = BC.BillID
			AND	BC.BillBatchTypeCode = 'P'
			AND	PI.InsuranceCompanyPlanID = @plan_id)
		AND	DATEDIFF(day, dbo.BusinessRule_ClaimPayerOriginalBillDate(BC.ClaimID, @plan_id), @ref_date) > 120)

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_InsurancePlanOverpaidAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_InsurancePlanOverpaidAmount
GO

--===========================================================================
-- INSURANCE PLAN OVERPAID Amount
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_InsurancePlanOverpaidAmount (@plan_id INT, @practice_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_InsurancePlanSixtyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_InsurancePlanSixtyDayBalance
GO

--===========================================================================
-- INSURANCE PLAN SIXTY DAY BALANCE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_InsurancePlanSixtyDayBalance (@plan_id INT, @practice_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimPayerBalanceAmount(BC.ClaimID, @plan_id))
		FROM	BillClaim BC
		WHERE EXISTS (
			SELECT	PI.PatientInsuranceID
			FROM	BillBatch BB
				INNER JOIN Bill_HCFA B
				ON B.BillBatchID = BB.BillBatchID
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID =
					B.PayerPatientInsuranceID
			WHERE 	BB.PracticeID = @practice_id
			AND BB.ConfirmedDate IS NOT NULL
			AND	B.BillID = BC.BillID
			AND	BC.BillBatchTypeCode = 'P'
			AND	PI.InsuranceCompanyPlanID = @plan_id
			UNION ALL
			SELECT	PI.PatientInsuranceID
			FROM	BillBatch BB
				INNER JOIN Bill_EDI B
				ON B.BillBatchID = BB.BillBatchID
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID =
					B.PayerPatientInsuranceID
			WHERE 	BB.PracticeID = @practice_id
			AND BB.ConfirmedDate IS NOT NULL
			AND	B.BillID = BC.BillID
			AND	BC.BillBatchTypeCode = 'P'
			AND	PI.InsuranceCompanyPlanID = @plan_id)
		AND	DATEDIFF(day, dbo.BusinessRule_ClaimPayerOriginalBillDate(BC.ClaimID, @plan_id), @ref_date) <= 90
		AND	DATEDIFF(day, dbo.BusinessRule_ClaimPayerOriginalBillDate(BC.ClaimID, @plan_id), @ref_date) > 60)

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_InsurancePlanThirtyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_InsurancePlanThirtyDayBalance
GO

--===========================================================================
-- INSURANCE PLAN THIRTY DAY BALANCE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_InsurancePlanThirtyDayBalance (@plan_id INT, @practice_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimPayerBalanceAmount(BC.ClaimID, @plan_id))
		FROM	BillClaim BC
		WHERE EXISTS (
			SELECT	PI.PatientInsuranceID
			FROM	BillBatch BB
				INNER JOIN Bill_HCFA B
				ON B.BillBatchID = BB.BillBatchID
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID =
					B.PayerPatientInsuranceID
			WHERE 	BB.PracticeID = @practice_id
			AND BB.ConfirmedDate IS NOT NULL
			AND	B.BillID = BC.BillID
			AND	BC.BillBatchTypeCode = 'P'
			AND	PI.InsuranceCompanyPlanID = @plan_id
			UNION ALL
			SELECT	PI.PatientInsuranceID
			FROM	BillBatch BB
				INNER JOIN Bill_EDI B
				ON B.BillBatchID = BB.BillBatchID
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID =
					B.PayerPatientInsuranceID
			WHERE 	BB.PracticeID = @practice_id
			AND BB.ConfirmedDate IS NOT NULL
			AND	B.BillID = BC.BillID
			AND	BC.BillBatchTypeCode = 'P'
			AND	PI.InsuranceCompanyPlanID = @plan_id)
		AND	DATEDIFF(day, dbo.BusinessRule_ClaimPayerOriginalBillDate(BC.ClaimID, @plan_id), @ref_date) <= 60
		AND	DATEDIFF(day, dbo.BusinessRule_ClaimPayerOriginalBillDate(BC.ClaimID, @plan_id), @ref_date) > 30)

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_InsurancePlanTotalBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_InsurancePlanTotalBalance
GO

--===========================================================================
-- INSURANCE PLAN TOTAL BALANCE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_InsurancePlanTotalBalance (@plan_id INT, @practice_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimPayerBalanceAmount(BC.ClaimID, @plan_id))
		FROM	BillClaim BC
		WHERE EXISTS (
			SELECT	PI.PatientInsuranceID
			FROM	BillBatch BB
				INNER JOIN Bill_HCFA B
				ON B.BillBatchID = BB.BillBatchID
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID =
					B.PayerPatientInsuranceID
			WHERE 	BB.PracticeID = @practice_id
			AND BB.ConfirmedDate IS NOT NULL
			AND	B.BillID = BC.BillID
			AND	BC.BillBatchTypeCode = 'P'
			AND	PI.InsuranceCompanyPlanID = @plan_id
			UNION ALL
			SELECT	PI.PatientInsuranceID
			FROM	BillBatch BB
				INNER JOIN Bill_EDI B
				ON B.BillBatchID = BB.BillBatchID
				INNER JOIN PatientInsurance PI
				ON PI.PatientInsuranceID =
					B.PayerPatientInsuranceID
			WHERE 	BB.PracticeID = @practice_id
			AND BB.ConfirmedDate IS NOT NULL
			AND	B.BillID = BC.BillID
			AND	BC.BillBatchTypeCode = 'P'
			AND	PI.InsuranceCompanyPlanID = @plan_id))

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientAssignedBalanceToDateHistorical'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientAssignedBalanceToDateHistorical
GO

--===========================================================================
-- PATIENT ASSIGNED BALANCE TO DATE HISTORICAL
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PatientAssignedBalanceToDateHistorical (@patient_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN


	DECLARE @tmpTab TABLE (value MONEY)

	INSERT INTO @tmpTab (value)
	SELECT
		ISNULL(
			C.ServiceChargeAmount -
			ISNULL((SELECT SUM(CT.Amount) FROM ClaimTransaction CT WHERE CT.ClaimID = C.ClaimID AND CT.ClaimTransactionTypeCode='PAY' AND CT.CreatedDate <= @ref_date),0) -
			ISNULL((SELECT SUM(CT.Amount) FROM ClaimTransaction CT WHERE CT.ClaimID = C.ClaimID AND CT.ClaimTransactionTypeCode IN ('ADJ','END') AND CT.CreatedDate <= @ref_date),0)
		,0
		)
	FROM
		Claim C
		INNER JOIN (
			SELECT	
				S_C.ClaimID,
				(
					SELECT TOP 1 
						Code 
					FROM 
						ClaimTransaction CT2 
					WHERE 
						CT2.ClaimID = S_C.ClaimID
						AND CT2.CreatedDate <= @ref_date
						AND CT2.ClaimTransactionTypeCode = 'ASN'
						AND CT2.Code IS NOT NULL
					ORDER BY 
						CT2.CreatedDate DESC
				) AS Code
			FROM
				Claim S_C
			WHERE
				S_C.CreatedDate <= @ref_date
				AND S_C.PatientID = @patient_id
		) AS JT ON JT.ClaimID = C.ClaimID
	WHERE
		C.PatientID = @patient_id
		AND C.CreatedDate <= @ref_date
		AND JT.Code = 'P'
		AND NOT EXISTS
			(
				--Surpress the voided claims
				SELECT *
				FROM dbo.ClaimTransaction CT2 
				WHERE CT2.ClaimID = C.ClaimID  
					AND CT2.ClaimTransactionTypeCode = 'XXX'
			)

	DECLARE @balance MONEY
	SELECT  @balance = ISNULL(SUM(Value),0) FROM @tmpTab

	RETURN  @balance

END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientBalanceToDate'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientBalanceToDate
GO

--===========================================================================
-- PATIENT BALANCE TO DATE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PatientBalanceToDate (@patient_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @balance_amount MONEY
	SET @balance_amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimBalanceToDate(C.ClaimID, @ref_date))
		FROM	Claim C
		WHERE	C.PatientID = @patient_id)

	RETURN COALESCE(@balance_amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientBalanceToDateHistorical'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientBalanceToDateHistorical
GO

--===========================================================================
-- PATIENT BALANCE TO DATE HISTORICAL
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PatientBalanceToDateHistorical (@patient_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN

	DECLARE @tmpTab TABLE (value MONEY)

	INSERT INTO @tmpTab (value)
	SELECT 
		ISNULL(
			C.ServiceChargeAmount -
			ISNULL((SELECT SUM(CT.Amount) FROM ClaimTransaction CT WHERE CT.ClaimID = C.ClaimID AND CT.ClaimTransactionTypeCode='PAY' AND CT.CreatedDate <= @ref_date),0) -
			ISNULL((SELECT SUM(CT.Amount) FROM ClaimTransaction CT WHERE CT.ClaimID = C.ClaimID AND CT.ClaimTransactionTypeCode IN ('ADJ','END') AND CT.CreatedDate <= @ref_date),0)
		,0
		)
	FROM
		Claim C
	WHERE
		C.PatientID = @patient_id
		AND C.CreatedDate <= @ref_date
		AND NOT EXISTS
			(
				--Surpress the voided claims
				SELECT *
				FROM dbo.ClaimTransaction CT2 
				WHERE CT2.ClaimID = C.ClaimID  
					AND CT2.ClaimTransactionTypeCode = 'XXX'
			)

	DECLARE @balance MONEY
	SELECT  @balance = ISNULL(SUM(Value),0) FROM @tmpTab

	RETURN  @balance

END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientCurrentBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientCurrentBalance
GO

--===========================================================================
-- PATIENT CURRENT BALANCE
--===========================================================================
-- Total balance for all claims within the last 30 days.
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PatientCurrentBalance (@patient_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @balance_amount MONEY
	SET @balance_amount = (
		SELECT 	SUM(dbo.BusinessRule_ClaimBalanceAmount(C.ClaimID))
		FROM	Claim C
		WHERE	C.PatientID = @patient_id
		AND	DATEDIFF(day, C.ServiceBeginDate, @ref_date) <= 30)

	RETURN COALESCE(@balance_amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientLastPaymentAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientLastPaymentAmount
GO

--===========================================================================
-- PATIENT LAST PAYMENT Amount
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PatientLastPaymentAmount (@patient_id INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @last_payment_date DATETIME
	SET @last_payment_date = 
		dbo.BusinessRule_PatientLastPaymentDate(@patient_id)
	IF (@last_payment_date IS NULL)
		RETURN 0

	DECLARE @last_payment_amount MONEY
	SET @last_payment_amount = (
		SELECT	TOP 1 PaymentAmount
		FROM	PAYMENT
		WHERE	PayerTypeCode = 'P'
		AND	PayerID = @patient_id
		AND	PaymentDate = @last_payment_date
		ORDER BY CreatedDate DESC)
	
	RETURN COALESCE(@last_payment_amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientNinetyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientNinetyDayBalance
GO

--===========================================================================
-- PATIENT NINETY DAY BALANCE
--===========================================================================
-- Total balance for all claims between 90 and 120 days old.
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PatientNinetyDayBalance (@patient_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @balance_amount MONEY
	SET @balance_amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimBalanceAmount(C.ClaimID))
		FROM	Claim C
		WHERE	C.PatientID = @patient_id
		AND	DATEDIFF(day, C.ServiceBeginDate, @ref_date) <= 120
		AND	DATEDIFF(day, C.ServiceBeginDate, @ref_date) > 90)
	
	RETURN COALESCE(@balance_amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientOneHundredTwentyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientOneHundredTwentyDayBalance
GO

--===========================================================================
-- PATIENT ONE HUNDRED TWENTY DAY BALANCE
--===========================================================================
-- Total balance for all claims 120 days old or older.
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PatientOneHundredTwentyDayBalance (@patient_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @balance_amount MONEY
	SET @balance_amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimBalanceAmount(C.ClaimID))
		FROM	Claim C
		WHERE	C.PatientID = @patient_id
		AND	DATEDIFF(day, C.ServiceBeginDate, @ref_date) > 120)
	
	RETURN COALESCE(@balance_amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientSixtyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientSixtyDayBalance
GO

--===========================================================================
-- PATIENT SIXTY DAY BALANCE
--===========================================================================
-- Total balance for all claims between 60 and 90 days old.
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PatientSixtyDayBalance (@patient_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @balance_amount MONEY
	SET @balance_amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimBalanceAmount(C.ClaimID))
		FROM	Claim C
		WHERE	C.PatientID = @patient_id
		AND	DATEDIFF(day, C.ServiceBeginDate, @ref_date) <= 90
		AND	DATEDIFF(day, C.ServiceBeginDate, @ref_date) > 60)

	RETURN COALESCE(@balance_amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientThirtyDayBalance'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientThirtyDayBalance
GO

--===========================================================================
-- PATIENT THIRTY DAY BALANCE
--===========================================================================
-- Total balance for all claims between 30 and 60 days old.
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PatientThirtyDayBalance (@patient_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @balance_amount MONEY
	SET @balance_amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimBalanceAmount(C.ClaimID))
		FROM	Claim C
		WHERE	C.PatientID = @patient_id
		AND	DATEDIFF(day, C.ServiceBeginDate, @ref_date) <= 60
		AND	DATEDIFF(day, C.ServiceBeginDate, @ref_date) > 30)

	RETURN COALESCE(@balance_amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientTotalBalanceForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientTotalBalanceForPeriod
GO

--===========================================================================
-- PATIENT TOTAL BALANCE FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PatientTotalBalanceForPeriod (@patient_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = dbo.BusinessRule_PatientChargesForPeriod(@patient_id, @start_date, @end_date) - dbo.BusinessRule_PatientReceiptsForPeriod(@patient_id, @start_date, @end_date) - dbo.BusinessRule_PatientAdjustmentsForPeriod(@patient_id, @start_date, @end_date)

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PaymentPatientAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PaymentPatientAmountForPeriod
GO

--===========================================================================
-- PAYMENT PATIENT Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PaymentPatientAmountForPeriod (@payment_id INT, @patient_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_PaymentClaimAmountForPeriod (@payment_id, C.ClaimID, @start_date, @end_date))
		FROM	Claim C
		WHERE	C.PatientID = @patient_id)

	RETURN COALESCE(@amount, 0)
END
GO


IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PaymentUnappliedAmountToDate'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PaymentUnappliedAmountToDate
GO

--===========================================================================
-- PAYMENT UNAPPLIED Amount TO DATE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PaymentUnappliedAmountToDate (@payment_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @payment_amount MONEY
	SET @payment_amount = (
		SELECT	PaymentAmount
		FROM	PAYMENT
		WHERE	PaymentID = @payment_id)

	RETURN @payment_amount - dbo.BusinessRule_PaymentAppliedAmountToDate(@payment_id, @ref_date)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeAdjustmentAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeAdjustmentAmountForPeriod
GO

--===========================================================================
-- PRACTICE ADJUSTMENT Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PracticeAdjustmentAmountForPeriod (@practice_id INT, @adjustment_code VARCHAR(5), @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_DoctorAdjustmentAmountForPeriod(D.DoctorID, @adjustment_code, @start_date, @end_date))
		FROM	Doctor D
		WHERE	D.PracticeID = @practice_id)
	
	RETURN COALESCE(@amount, 0)
END
GO


IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeCollectionRateForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeCollectionRateForPeriod
GO

--===========================================================================
-- PRACTICE COLLECTION RATE FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PracticeCollectionRateForPeriod (@practice_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS FLOAT
AS
BEGIN
	DECLARE @rate FLOAT
	DECLARE @charges MONEY
	DECLARE @receipts MONEY
	SET @charges = dbo.BusinessRule_PracticeTotalChargeAmountForPeriod(@practice_id, @start_date, @end_date)
	SET @receipts = dbo.BusinessRule_PracticeTotalReceiptAmountForPeriod(@practice_id, @start_date, @end_date)

	IF (@charges = 0) RETURN 0.0

	SET @rate = @receipts / @charges

	RETURN COALESCE(@rate, 0.0)
END
GO


IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeInsuranceReceiptAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeInsuranceReceiptAmountForPeriod
GO

--===========================================================================
-- PRACTICE INSURANCE RECEIPT Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PracticeInsuranceReceiptAmountForPeriod (@practice_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_DoctorInsuranceReceiptAmountForPeriod(D.DoctorID, @start_date, @end_date))
		FROM	Doctor D
		WHERE	D.PracticeID = @practice_id)
	
	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeMedicareReceiptAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeMedicareReceiptAmountForPeriod
GO

--===========================================================================
-- PRACTICE MEDICARE RECEIPT Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PracticeMedicareReceiptAmountForPeriod (@practice_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_DoctorMedicareReceiptAmountForPeriod(D.DoctorID, @start_date, @end_date))
		FROM	Doctor D
		WHERE	D.PracticeID = @practice_id)
	
	RETURN COALESCE(@amount, 0)
END
GO


IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeNetAccountsReceivableAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeNetAccountsReceivableAmountForPeriod
GO

--===========================================================================
-- PRACTICE NET ACCOUNTS RECEIVABLE Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PracticeNetAccountsReceivableAmountForPeriod (@practice_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_DoctorNetAccountsReceivableForPeriod(D.DoctorID, @start_date, @end_date))
		FROM	Doctor D
		WHERE	D.PracticeID = @practice_id)
	
	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticePatientReceiptAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticePatientReceiptAmountForPeriod
GO

--===========================================================================
-- PRACTICE PATIENT RECEIPT Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PracticePatientReceiptAmountForPeriod (@practice_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_DoctorPatientReceiptAmountForPeriod(D.DoctorID, @start_date, @end_date))
		FROM	Doctor D
		WHERE	D.PracticeID = @practice_id)
	
	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticePaymentMethodAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticePaymentMethodAmountForPeriod
GO

--===========================================================================
-- PRACTICE PAYMENT METHOD Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PracticePaymentMethodAmountForPeriod (@practice_id INT, @payment_method_code CHAR(1), @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(COALESCE(PMT.PaymentAmount, 0))
		FROM	Payment PMT
		WHERE	PMT.PracticeID = @practice_id
		AND	PMT.PaymentDate BETWEEN @start_date AND @end_date
		AND	PMT.PaymentMethodCode = @payment_method_code)
	
	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticePaymentsForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticePaymentsForPeriod
GO

--===========================================================================
-- PRACTICE PAYMENTS FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PracticePaymentsForPeriod (@practice_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(COALESCE(PMT.PaymentAmount,0))
		FROM	Payment PMT
		WHERE	PMT.PracticeID = @practice_id
		AND	PMT.PaymentDate BETWEEN @start_date AND @end_date)

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeProcedureCountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeProcedureCountForPeriod
GO

--===========================================================================
-- PRACTICE PROCEDURE COUNT FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PracticeProcedureCountForPeriod (@practice_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS INT
AS
BEGIN
	DECLARE @count INT
	SET @count = (
		SELECT	SUM(dbo.BusinessRule_DoctorTotalUnitsForPeriod(D.DoctorID, @start_date, @end_date))
		FROM	Doctor D
		WHERE	D.PracticeID = @practice_id)

	RETURN COALESCE(@count, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeTotalAdjustmentAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeTotalAdjustmentAmountForPeriod
GO

--===========================================================================
-- PRACTICE TOTAL ADJUSTMENT Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PracticeTotalAdjustmentAmountForPeriod (@practice_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_DoctorAdjustmentsForPeriod(D.DoctorID, @start_date, @end_date))
		FROM	Doctor D
		WHERE	D.PracticeID = @practice_id)
	
	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'GeneralDataProvider_GetRelatedCausesCodes'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.GeneralDataProvider_GetRelatedCausesCodes
GO

--===========================================================================
-- GET RELATED CAUSES CodeS
--===========================================================================
CREATE PROCEDURE dbo.GeneralDataProvider_GetRelatedCausesCodes
AS
BEGIN
	SELECT	RELATEDCAUSESCode AS Code,
		Description AS Description
	FROM	RELATEDCAUSESCode
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'GeneralDataProvider_GetReleaseOfInformationCodes'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.GeneralDataProvider_GetReleaseOfInformationCodes
GO

--===========================================================================
-- GET RELEASE OF INFORMATION CodeS
--===========================================================================
CREATE PROCEDURE dbo.GeneralDataProvider_GetReleaseOfInformationCodes
AS
BEGIN
	SELECT	ReleaseOfInformationCode AS Code,
		Description AS Description
	FROM	ReleaseOfInformationCode
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_ClaimPayerBalanceAmount'
	AND 	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_ClaimPayerBalanceAmount
GO

--===========================================================================
-- CLAIM PAYER BALANCE Amount
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_ClaimPayerBalanceAmount(@claim_id INT, @plan_id INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = dbo.BusinessRule_ClaimPayerOriginalBillAmount(@claim_id, @plan_id) - dbo.BusinessRule_ClaimPayerAdjustmentAmount(@claim_id, @plan_id) - dbo.BusinessRule_ClaimPayerReceiptAmount(@claim_id, @plan_id)
	
	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorAdjustmentAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorAdjustmentAmountForPeriod
GO

--===========================================================================
-- DOCTOR ADJUSTMENT Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_DoctorAdjustmentAmountForPeriod (@doctor_id INT, @adjustment_code VARCHAR(5), @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS 
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(COALESCE(CT.Amount, 0))
		FROM	Claim C
			INNER JOIN ClaimTransaction CT
			ON CT.ClaimID = C.ClaimID
			AND CT.ClaimTransactionTypeCode IN ('ADJ', 'END')
			AND CT.TransactionDate BETWEEN @start_date AND @end_date
			AND CT.Code = @adjustment_code
		WHERE	C.RenderingProviderID = @doctor_id)

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorInsuranceReceiptAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorInsuranceReceiptAmountForPeriod
GO

--===========================================================================
-- DOCTOR INSURANCE RECEIPT Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_DoctorInsuranceReceiptAmountForPeriod (@doctor_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimInsuranceReceiptAmountForPeriod(C.ClaimID, @start_date, @end_date))
		FROM	Claim C
		WHERE	C.RenderingProviderID = @doctor_id)

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorMedicareReceiptAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorMedicareReceiptAmountForPeriod
GO

--===========================================================================
-- DOCTOR MEDICARE RECEIPT Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_DoctorMedicareReceiptAmountForPeriod (@doctor_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimMedicareReceiptAmountForPeriod(C.ClaimID, @start_date, @end_date))
		FROM	CLAIM C
		WHERE	C.RenderingProviderID = @doctor_id)

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorNetAccountsReceivableForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorNetAccountsReceivableForPeriod
GO

--===========================================================================
-- DOCTOR NET ACCOUNTS RECEIVABLE FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_DoctorNetAccountsReceivableForPeriod (@doctor_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = dbo.BusinessRule_DoctorChargesForPeriod(@doctor_id, @start_date, @end_date) - dbo.BusinessRule_DoctorReceiptsForPeriod(@doctor_id, @start_date, @end_date) - dbo.BusinessRule_DoctorAdjustmentsForPeriod(@doctor_id, @start_date, @end_date)

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorPatientReceiptAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorPatientReceiptAmountForPeriod
GO

--===========================================================================
-- DOCTOR PATIENT RECEIPT Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_DoctorPatientReceiptAmountForPeriod (@doctor_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimPatientReceiptAmountForPeriod(C.ClaimID, @start_date, @end_date))
		FROM	Claim C
		WHERE	C.RenderingProviderID = @doctor_id)

	RETURN COALESCE(@amount, 0)
END
GO


IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_DoctorTotalUnitsForPeriod'
	AND 	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_DoctorTotalUnitsForPeriod
GO

--===========================================================================
-- DOCTOR TOTAL UNITS FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_DoctorTotalUnitsForPeriod (@doctor_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS INT
AS
BEGIN
	DECLARE @count INT
	SET @count = (
		SELECT	SUM(COALESCE(C.ServiceUnitCount, 1))
		FROM	Claim C
		WHERE	C.RenderingProviderID = @doctor_id
		AND 	C.CreatedDate BETWEEN @start_date AND @end_date)

	RETURN COALESCE(@count, 0)
END
GO


IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_EDIBillTotalPaidAmount'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_EDIBillTotalPaidAmount
GO

--===========================================================================
-- EDI BILL TOTAL PAID Amount
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_EDIBillTotalPaidAmount (@bill_id INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @paid_amount MONEY
	SET @paid_amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimReceiptAmount(ClaimID))
		FROM	BILLCLAIM
		WHERE	BillID = @bill_id
		AND	BillBatchTypeCode = 'E')

	RETURN COALESCE(@paid_amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientAdjustmentsForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientAdjustmentsForPeriod
GO

--===========================================================================
-- PATIENT ADJUSTMENTS FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PatientAdjustmentsForPeriod (@patient_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @adjustment_amount MONEY
	SET @adjustment_amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimAdjustmentsForPeriod(C.ClaimID, @start_date, @end_date))
		FROM	Claim C
		WHERE	C.PatientID = @patient_id)
	
	RETURN COALESCE(@adjustment_amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientChargesForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientChargesForPeriod
GO

--===========================================================================
-- PATIENT CHARGES FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PatientChargesForPeriod (@patient_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @charge_amount MONEY
	SET @charge_amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimOriginalChargeAmount(C.ClaimID))
		FROM	Claim C
		WHERE	C.PatientID = @patient_id
		AND 	C.CreatedDate BETWEEN @start_date AND @end_date)

	RETURN COALESCE(@charge_amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientLastPaymentDate'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientLastPaymentDate
GO

--===========================================================================
-- PATIENT LAST PAYMENT DATE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PatientLastPaymentDate (@patient_id INT)
RETURNS DATETIME
AS
BEGIN
	DECLARE @last_payment_date DATETIME
	SET @last_payment_date = (
		SELECT	MAX(PaymentDate)
		FROM	PAYMENT
		WHERE	PayerTypeCode = 'P'
		AND	PayerID = @patient_id)

	RETURN @last_payment_date
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PatientReceiptsForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PatientReceiptsForPeriod
GO

--===========================================================================
-- PATIENT RECEIPTS FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PatientReceiptsForPeriod (@patient_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @receipt_amount MONEY
	SET @receipt_amount = (
		SELECT	SUM(dbo.BusinessRule_ClaimReceiptsForPeriod(C.ClaimID, @start_date, @end_date))
		FROM	Claim C
		WHERE	C.PatientID = @patient_id)
	
	RETURN COALESCE(@receipt_amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PaymentAppliedAmountToDate'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PaymentAppliedAmountToDate
GO

--===========================================================================
-- PAYMENT APPLIED Amount TO DATE
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PaymentAppliedAmountToDate (@payment_id INT, @ref_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @applied_amount MONEY
	SET @applied_amount = (
		SELECT	COALESCE(SUM(CT.Amount),0)
		FROM	CLAIMTRANSACTION CT
		WHERE	CT.ClaimTransactionTypeCode = 'PAY'
		AND	CT.ReferenceID = @payment_id
		AND	CT.CreatedDate <= @ref_date)

	RETURN @applied_amount
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PaymentClaimAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PaymentClaimAmountForPeriod
GO

--===========================================================================
-- PAYMENT CLAIM Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PaymentClaimAmountForPeriod (@payment_id INT, @claim_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(COALESCE(CT.Amount,0))
		FROM	ClaimTransaction CT
		WHERE	CT.ClaimID = @claim_id
		AND	CT.ClaimTransactionTypeCode = 'PAY'
		AND	CT.ReferenceID = @payment_id
		AND	CT.TransactionDate BETWEEN @start_date AND @end_date)
	
	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeTotalChargeAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeTotalChargeAmountForPeriod
GO

--===========================================================================
-- PRACTICE TOTAL CHARGE Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PracticeTotalChargeAmountForPeriod (@practice_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_DoctorChargesForPeriod(D.DoctorID, @start_date, @end_date))
		FROM	Doctor D
		WHERE	D.PracticeID = @practice_id)

	RETURN COALESCE(@amount, 0)
END
GO

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_PracticeTotalReceiptAmountForPeriod'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_PracticeTotalReceiptAmountForPeriod
GO

--===========================================================================
-- PRACTICE TOTAL RECEIPT Amount FOR PERIOD
--===========================================================================
CREATE FUNCTION dbo.BusinessRule_PracticeTotalReceiptAmountForPeriod (@practice_id INT, @start_date DATETIME, @end_date DATETIME)
RETURNS MONEY
AS
BEGIN
	DECLARE @amount MONEY
	SET @amount = (
		SELECT	SUM(dbo.BusinessRule_DoctorReceiptsForPeriod(D.DoctorID, @start_date, @end_date))
		FROM	Doctor D
		WHERE	D.PracticeID = @practice_id)

	RETURN COALESCE(@amount, 0)
END
GO

