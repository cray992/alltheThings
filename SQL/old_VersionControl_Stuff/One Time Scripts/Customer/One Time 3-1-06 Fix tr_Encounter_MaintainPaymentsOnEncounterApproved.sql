set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


--===========================================================================
-- MAINTAIN PAYMENTS ON ENCOUNTER APPROVED
--===========================================================================
ALTER TRIGGER [tr_Encounter_MaintainPaymentsOnEncounterApproved]
ON	[dbo].[Encounter]
FOR	INSERT, UPDATE
AS
BEGIN
	DECLARE @patient_id INT
	DECLARE @practice_id INT
	DECLARE @paid_amount MONEY
	DECLARE @encounter_status INT
	DECLARE @encounter_id INT
	DECLARE @payment_id INT
	DECLARE @DateOfService DATETIME
	DECLARE @PaymentReference varchar(40)
	DECLARE @PaymentMethod char(1)

	DECLARE @PostingDate DATETIME

	PRINT 'Entered tr_Encounter_MaintainPaymentsOnEncounterApproved'
	
	--Retrieve information about the encounter affected.
	SELECT	@patient_id = PatientID,
		@encounter_id = EncounterID,
		@practice_id = PracticeID,
		@paid_amount = AmountPaid,
		@encounter_status = EncounterStatusID,
		@DateOfService = DateOfService,
		@PaymentReference = Reference,
		@PaymentMethod = PaymentMethod,
		@PostingDate = PostingDate
	FROM	INSERTED

	--check for payment for this encounter
	SET @payment_id = (SELECT PaymentID FROM Payment WHERE SourceEncounterID = @encounter_id)

	--encounter is not approved so delete any potentially listed payments
	IF (@encounter_status <> 3)
	BEGIN
		PRINT '@encounter_status <> 3'
		IF ISNULL(@payment_id,0) <> 0
			EXEC dbo.PaymentDataProvider_DeletePayment @payment_id
		
		RETURN
	END
	
	--delete any existing payment if the amount changes to nothing
	--this is only to ensure consistency if the encounter gets updated while approved
	--normally this won't happen without resubmission (which would cause a deletion)
	IF (@paid_amount IS NULL OR @paid_amount <= 0)
	BEGIN
		IF ISNULL(@payment_id,0) <> 0
			EXEC dbo.PaymentDataProvider_DeletePayment @payment_id
		
		RETURN
	END
	
	IF (@payment_id IS NULL)
	BEGIN


		--Create a patient payment.
		INSERT	PAYMENT (
			PracticeID,
			SourceEncounterID,
			PostingDate, 
			PaymentAmount,
			PaymentMethodCode,
			PayerTypeCode,
			PayerID,
			PaymentNumber,
			Description)
		VALUES(
			@practice_id,
			@encounter_id,
			CAST(CONVERT(CHAR(10),@PostingDate,110) AS DATETIME),
			@paid_amount,
			COALESCE(@PaymentMethod,'U'),
			'P',
			@patient_id,
			CAST(@PaymentReference as varchar(30)),
			'Patient Payment made on ' + CONVERT(char(10), @DateOfService, 101) + ' with Encounter ' + CONVERT(varchar(12), @encounter_id))
			
		SET @payment_id = SCOPE_IDENTITY()

		INSERT INTO UnappliedPayments
		Values(@practice_id, @payment_id)

		--associate with patient			
		PRINT 'EXEC dbo.PaymentDataProvider_AddPatientForPayment'
		EXEC dbo.PaymentDataProvider_AddPatientForPayment @payment_id, @patient_id
		
		DECLARE @firstClaimID int
		SET @firstClaimID = (SELECT TOP 1 ClaimID FROM Claim C INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID = EP.EncounterProcedureID WHERE EP.EncounterID = @encounter_id ORDER BY C.ClaimID)
		
		IF @firstClaimID IS NOT NULL
		BEGIN
			DECLARE @paymentAmount money
			DECLARE @claimOutstandingAmount money
			DECLARE @amountToPay money
			
			SET @paymentAmount = dbo.BusinessRule_PaymentUnappliedAmount(@payment_id)
			SET @claimOutstandingAmount = dbo.BusinessRule_ClaimAdjustedChargeAmount(@firstClaimID)
			
			IF (@paymentAmount > @claimOutstandingAmount) 
			BEGIN
				SET @amountToPay = @claimOutstandingAmount
			END
			ELSE
			BEGIN
				SET @amountToPay = @paymentAmount
			END

			DECLARE @convertedPostingDate datetime
			SET @convertedPostingDate = CAST(CONVERT(CHAR(10),@PostingDate,110) AS DATETIME)
			
			DECLARE @NotesToAdd VARCHAR(150)
			SET @NotesToAdd='Payment made with encounter '+CAST(@payment_id AS VARCHAR) 

			EXEC dbo.ClaimDataProvider_PayClaim 
				@claim_id = @firstClaimID, 	
				@posting_date = @convertedPostingDate,
				@payment_amount = @amountToPay,
				@paid_units = 1,
				@payment_reference_id = @payment_id,
				@notes = @NotesToAdd

			--Check if PAY transaction settles Claim
			IF (SELECT SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)
				-SUM(CASE WHEN ClaimTransactionTypeCode IN ('PAY','ADJ') THEN Amount ELSE 0 END)
				FROM ClaimAccounting
				WHERE ClaimID=@firstClaimID)=0
			BEGIN
				EXEC ClaimDataProvider_SettleClaim
				@claim_id = @firstClaimID,
				@posting_date = @convertedPostingDate,
				@notes = @NotesToAdd
			END
		END

	
	END
	ELSE
	BEGIN
	
		--this section is to ensure consistency in case the encounter changes while approved; 
		--normally the payment would have gotten deleted already when the encounter was resubmitted
	
		--get old patient ID involved in transaction	
		DECLARE @old_patient_id INT
		SET @old_patient_id = (SELECT PayerID FROM Payment WHERE PaymentID = @payment_id AND PayerTypeCode = 'P')
			
		UPDATE
			Payment
		SET
			PostingDate = CAST(CONVERT(CHAR(10),@PostingDate,110) AS DATETIME),
			PaymentAmount = @paid_amount,
			PaymentNumber = CAST(@PaymentReference as varchar(30)),
			PaymentMethodCode = COALESCE(@PaymentMethod,'U'),
			PayerID = @patient_id
		WHERE
			PaymentID = @payment_id

		IF dbo.BusinessRule_PaymentUnappliedAmount(@payment_id)<=0
			--Remove from UnappliedPayments if Payment becomes fully applied
			DELETE UnappliedPayments
			WHERE PracticeID=@practice_id AND PaymentID=@payment_id
		ELSE
			IF NOT EXISTS(SELECT * FROM UnappliedPayments WHERE PracticeID=@practice_id AND PaymentID=@payment_id)
				INSERT INTO UnappliedPayments
				VALUES(@practice_id,@payment_id)
		
		IF (@old_patient_id IS NOT NULL)
		BEGIN
			PRINT 'EXEC dbo.PaymentDataProvider_RemovePatientFromPayment'
			EXEC dbo.PaymentDataProvider_RemovePatientFromPayment @payment_id, @old_patient_id
		END
		
		PRINT 'Exec PaymentDataProvider_AddPatientForPayment'
		EXEC dbo.PaymentDataProvider_AddPatientForPayment @payment_id, @patient_id
	END
END

