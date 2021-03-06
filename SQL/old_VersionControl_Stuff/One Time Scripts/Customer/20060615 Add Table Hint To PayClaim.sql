set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


--===========================================================================
-- PAY CLAIM
--===========================================================================
ALTER         PROCEDURE [dbo].[ClaimDataProvider_PayClaim]
	@claim_id INT,
	@posting_date DATETIME,
	@payment_amount MONEY,
	@paid_units INT,
	@payment_reference_id INT,
	@notes TEXT
AS
BEGIN

	DECLARE @practice_id int,
		@patient_id int,
		@provider_id int

	SELECT @practice_id=C.PracticeID, @patient_id=C.PatientID, @provider_id=E.DoctorID
	FROM CLAIM C
	JOIN EncounterProcedure EP ON EP.EncounterProcedureID = C.EncounterProcedureID
	JOIN Encounter E ON E.EncounterID = EP.EncounterID
	WHERE ClaimID=@claim_id

	INSERT	CLAIMTRANSACTION (
		ClaimTransactionTypeCode,
		ClaimID,
		PostingDate,
		Amount,
		Quantity,
		Code,
		ReferenceID,
		ReferenceData,
		Notes,
		PracticeID,
		PatientID,
		Claim_ProviderID)
	VALUES	(
		'PAY',
		@claim_id,
		CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(@posting_date) AS DATETIME),110) AS DATETIME),
		@payment_amount,
		@paid_units,
		NULL,
		@payment_reference_id,
		NULL,
		@notes,
		@practice_id,
		@patient_id,
		@provider_id)
		
	DECLARE @transaction_id INT
	SET @transaction_id = SCOPE_IDENTITY()
	
	INSERT INTO
		PaymentClaimTransaction
		(PaymentID, ClaimID, ClaimTransactionID, PracticeID)
	VALUES
		(@payment_reference_id, @claim_id, @transaction_id, @practice_id);

	IF dbo.BusinessRule_PaymentUnappliedAmount(@Payment_reference_id)<=0
		--Remove from UnappliedPayments if Payment becomes fully applied
		DELETE UnappliedPayments
		WHERE PracticeID=@practice_id AND PaymentID=@Payment_reference_id 
	ELSE
		IF NOT EXISTS(SELECT * FROM UnappliedPayments WHERE PracticeID=@practice_id AND PaymentID=@Payment_reference_id)
			INSERT INTO UnappliedPayments
			VALUES(@practice_id, @Payment_reference_id)

	-- Associate the payment with the patient if not already done
	IF NOT EXISTS(SELECT * 
		      FROM PaymentPatient WITH(UPDLOCK)
		      WHERE PaymentID = @payment_reference_id 
		      AND PatientID = @patient_id)
	BEGIN
		EXEC dbo.PaymentDataProvider_AddPatientForPayment @payment_reference_id, @patient_id
	END

	RETURN @transaction_id
END


