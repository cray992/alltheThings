if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[fn_ReportDataProvider_GetPatientActivities]') and xtype in (N'FN', N'IF', N'TF'))
drop function [dbo].[fn_ReportDataProvider_GetPatientActivities]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS OFF 
GO


/*
--===========================================================================
-- GET PATIENT ACTIVITIES
--===========================================================================
CREATE FUNCTION dbo.fn_ReportDataProvider_GetPatientActivities 
	(@patient_id int)
RETURNS @OrderedDetail TABLE (
		id int identity(1,1) PRIMARY KEY, 
		CreatedDate datetime,
		ClaimTransactionID int, 
		ClaimID int,
		PaymentID int,
		RefundID int, 
		ClaimTransactionTypeCode char(4),
		Amount money, 
		PatientBalance money, 
		InsuranceBalance money, 
		Unapplied money,
		IsVoidedClaim bit default(0), 
		IsPatientTransfer bit default(0),
		PaymentPayerTypeCode char(1)
	)
AS
BEGIN

	--The voided claims need to be surpressed FROM the balance calculations
	DECLARE @VoidedClaims TABLE (ClaimID int PRIMARY KEY)

	--Insert all of the different types we want to use in this report
	INSERT @OrderedDetail (CreatedDate, ClaimTransactionID, ClaimID, PaymentID, RefundID, 
		ClaimTransactionTypeCode, Amount)
	SELECT T.*
	FROM
	(SELECT CT.CreatedDate, CT.ClaimTransactionID as ID, CT.ClaimID, NULL as PaymentID, NULL as RefundID, 
		CT.ClaimTransactionTypeCode, CT.Amount
	FROM dbo.ClaimTransaction CT INNER JOIN
		dbo.Claim C ON
			CT.ClaimID = C.ClaimID 
	WHERE C.PatientID = @patient_id
		AND CT.ClaimTransactionTypeCode IN ('ASN', 'ADJ', 'END')
	UNION ALL
	SELECT CT.CreatedDate, CT.ClaimTransactionID as ID, CT.ClaimID, PCT.PaymentID as PaymentID, NULL as RefundID, 
		CT.ClaimTransactionTypeCode, CT.Amount
	FROM dbo.ClaimTransaction CT INNER JOIN
		dbo.Claim C ON
			CT.ClaimID = C.ClaimID 
		INNER JOIN dbo.PaymentClaimTransaction PCT
		ON CT.ClaimTransactionID = PCT.ClaimTransactionID
	WHERE C.PatientID = @patient_id
		AND CT.ClaimTransactionTypeCode IN ('PAY')
	UNION ALL
	SELECT CT.CreatedDate, CT.ClaimTransactionID as ID, CT.ClaimID, NULL as PaymentID, NULL as RefundID, 
		CT.ClaimTransactionTypeCode, -1 * C.ServiceChargeAmount * C.ServiceUnitCount AS Amount 
	FROM dbo.ClaimTransaction CT INNER JOIN
		dbo.Claim C ON
			CT.ClaimID = C.ClaimID 
	WHERE C.PatientID = @patient_id
		AND CT.ClaimTransactionTypeCode IN ('XXX')
	UNION ALL
	SELECT C.CreatedDate, 0, C.ClaimID, NULL, NULL as RefundID, 
		'CLM', C.ServiceChargeAmount * C.ServiceUnitCount
	FROM dbo.Claim C 
	WHERE C.PatientID = @patient_id
	UNION ALL
	SELECT P.CreatedDate, -1, NULL, P.PaymentID, NULL as RefundID, 
		'PMT', P.PaymentAmount 
	FROM dbo.Payment P 
	WHERE P.PayerID = @patient_id
		AND P.PayerTypeCode = 'P'
	UNION ALL
	SELECT R.RefundDate, -1, NULL, RTP.PaymentID, R.RefundID, 
		'RFD', RTP.Amount
	FROM dbo.Refund R
	INNER JOIN dbo.RefundToPayments RTP
	ON RTP.RefundID = R.RefundID
	WHERE R.RecipientTypeCode = 'P'
	AND R.RecipientID = @patient_id) as T
	ORDER BY CreatedDate, ID	

	--Update list of voided claims
	INSERT INTO @VoidedClaims
	SELECT	distinct ClaimID
	FROM	@OrderedDetail
	WHERE	ClaimTransactionTypeCode = 'XXX'

	--Update voided claims flag
	UPDATE OD
		SET IsVoidedClaim = 1
	FROM @OrderedDetail OD INNER JOIN
		@VoidedClaims VC ON
			OD.ClaimID = VC.ClaimID

	--Update the patient transfer flag
	UPDATE 		OD
	SET 		IsPatientTransfer = 1
	FROM 		@OrderedDetail OD
	INNER JOIN	dbo.ClaimTransaction CT
	ON		   CT.ClaimTransactionID = OD.ClaimTransactionID
	AND		   CT.AssignedToType = 'P'
	WHERE		OD.ClaimTransactionTypeCode in('ASN', 'ADJ', 'PAY')

	--Update the payment payer type code
	UPDATE		OD
	SET		PaymentPayerTypeCode = P.PayerTypeCode
	FROM		@OrderedDetail OD
	INNER JOIN	dbo.ClaimTransaction CT
	ON		   CT.ClaimTransactionID = OD.ClaimTransactionID
	INNER JOIN	dbo.Payment P
	ON		   P.PaymentID = CT.ReferenceID
	WHERE		OD.ClaimTransactionTypeCode = 'PAY'

	--Create claim balance table to hold the current balances of each claim
	DECLARE @ClaimBalance TABLE (
		ClaimID int,
		PreviousTransferToPatient bit, 
		Balance money)

	INSERT		@ClaimBalance
	SELECT		distinct ClaimID, 1, 0
	FROM		@OrderedDetail
	WHERE		not ClaimID is null

	--Create variables to be used
	DECLARE @PrevPatientBalance money, 
		@PrevInsuranceBalance money, 
		@PrevUnapplied money, 
		@PreviousTransferToPatient bit, 
		@CurrId int, 
		@CurrClaimTransactionTypeCode char(4), 
		@CurrAmount money, 
		@CurrPatientBalance money, 
		@CurrInsuranceBalance money, 
		@CurrUnapplied money, 
		@CurrIsPatientTransfer bit, 
		@CurrPaymentPayerTypeCode char(1), 
		@CurrClaimId int

	--Open cursor to handle calculations on balances, etc.
	DECLARE activity_cursor CURSOR
	READ_ONLY
	FOR 	SELECT 	Id, 
			ClaimTransactionTypeCode, 
			Amount, 
			IsPatientTransfer, 
			PaymentPayerTypeCode,
			ClaimId
		FROM 	@OrderedDetail
--		WHERE	IsVoidedClaim = 0
	
	OPEN activity_cursor

	FETCH NEXT FROM activity_cursor
	INTO 	@CurrId, 
		@CurrClaimTransactionTypeCode, 
		@CurrAmount, 
		@CurrIsPatientTransfer, 
		@CurrPaymentPayerTypeCode, 
		@CurrClaimId

	set	@PrevPatientBalance = 0
	set	@PrevInsuranceBalance = 0
	set	@PrevUnapplied = 0

	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
	WHILE @@FETCH_STATUS = 0
	BEGIN

		-- If transaction is a claim then add the amount to the patient balance
		if @CurrClaimTransactionTypeCode = 'CLM'
		begin
			set @CurrPatientBalance = @PrevPatientBalance + @CurrAmount
			set @CurrInsuranceBalance = @PrevInsuranceBalance		-- unchanged
			set @CurrUnapplied = @PrevUnapplied				-- unchanged

			-- Update the claim balance
			update 	@ClaimBalance
			set	Balance = Balance + @CurrAmount
			where	ClaimId = @CurrClaimId
		end
		-- If transaction is a transfer then add the remaining claim amount to the patient or insurance balance (based on flag)
		else if @CurrClaimTransactionTypeCode = 'ASN'
		begin
			-- Get the current claim balance
			select	@CurrAmount = Balance, 
				@PreviousTransferToPatient = isnull(PreviousTransferToPatient, 1)
			from	@ClaimBalance
			where	ClaimID = @CurrClaimID

			set @CurrUnapplied = @PrevUnapplied				-- unchanged

			-- Check to see if this is a transfer to a patient
			if @CurrIsPatientTransfer = 1
			begin
				if @PreviousTransferToPatient = 1
				begin
					-- The previous was transferred to patient so don't do anything
					set @CurrPatientBalance = @PrevPatientBalance		-- unchanged
					set @CurrInsuranceBalance = @PrevInsuranceBalance	-- unchanged
				end
				else
				begin
					-- Transfer to Patient, increase patient balance, decrease insurance balance
					set @CurrPatientBalance = @PrevPatientBalance + @CurrAmount
					set @CurrInsuranceBalance = @PrevInsuranceBalance - @CurrAmount
				end
			end
			else
			begin
				-- If the previous transfer was to an insurance don't change anything
				if @PreviousTransferToPatient = 0
				begin
					set @CurrPatientBalance = @PrevPatientBalance	-- unchanged
					set @CurrInsuranceBalance = @PrevInsuranceBalance -- unchanged
				end
				else
				begin
					-- Transfer to Insurance, increase insurance balance, decrease patient balance
					set @CurrPatientBalance = @PrevPatientBalance - @CurrAmount
					set @CurrInsuranceBalance = @PrevInsuranceBalance + @CurrAmount
				end
			end

			-- Update the previous transfer type
			update	@ClaimBalance
			set	PreviousTransferToPatient = @CurrIsPatientTransfer
			where	ClaimID = @CurrClaimID
		end
		-- If the transaction is an adjustment then add the amount to the patient or insurance balance (based on flag)
		else if @CurrClaimTransactionTypeCode = 'ADJ'
		begin
			-- Decrease the current claim balance
			update	@ClaimBalance
			set	Balance = Balance - @CurrAmount
			where	ClaimID = @CurrClaimID

			set @CurrUnapplied = @PrevUnapplied				-- unchanged
			
			-- Check to see if this is an adjustment to a patient
			if @CurrIsPatientTransfer = 1
			begin
				-- Adjustment to a patient, decrease patient
				set @CurrPatientBalance = @PrevPatientBalance - @CurrAmount
				set @CurrInsuranceBalance = @PrevInsuranceBalance	-- unchanged
			end
			else
			begin
				-- Adjustment to an insurance, decrease insurance
				set @CurrPatientBalance = @PrevPatientBalance		-- unchanged
				set @CurrInsuranceBalance = @PrevInsuranceBalance - @CurrAmount
			end
		end
		-- If the transaction is a payment received adjust the unapplied amount
		else if @CurrClaimTransactionTypeCode = 'PMT'
		begin
			set @CurrUnapplied = @PrevUnapplied + @CurrAmount
			set @CurrPatientBalance = @PrevPatientBalance			-- unchanged
			set @CurrInsuranceBalance = @PrevInsuranceBalance		-- unchanged
		end
		-- If the transaction is a payment posted adjust the unapplied amount (if from patient) as well as patient balance or insurance balance (based on flag)
		else if @CurrClaimTransactionTypeCode = 'PAY'
		begin
			-- Decrease the current claim balance
			update	@ClaimBalance
			set	Balance = Balance - @CurrAmount
			where	ClaimID = @CurrClaimID

			-- Check to see if this is a payment posted to a patient
			if @CurrPaymentPayerTypeCode = 'P'
				-- Decrease the unapplied
				set @CurrUnapplied = @PrevUnapplied - @CurrAmount
			else
				set @CurrUnapplied = @PrevUnapplied			-- unchanged
		
		
			-- Check to see if this is a payment posted to a patient
			if @CurrIsPatientTransfer = 1
			begin
				-- Decrease patient balance
				set @CurrPatientBalance = @PrevPatientBalance - @CurrAmount
				set @CurrInsuranceBalance = @PrevInsuranceBalance	-- unchanged
			end
			else
			begin
				-- Decrease the insurance balance
				set @CurrPatientBalance = @PrevPatientBalance		-- unchanged
				set @CurrInsuranceBalance = @PrevInsuranceBalance - @CurrAmount
			end
		end
		-- If the transaction is a refund then adjust the applied amount
		else if @CurrClaimTransactionTypeCode = 'RFD'
		begin
			set @CurrUnapplied = @PrevUnapplied - @CurrAmount
			set @CurrPatientBalance = @PrevPatientBalance			-- unchanged
			set @CurrInsuranceBalance = @PrevInsuranceBalance		-- unchanged
		end			
		-- If transaction is a void then add the remaining claim amount to the patient or insurance balance (based on flag)
		else if @CurrClaimTransactionTypeCode = 'XXX'
		begin
			-- Get the current claim balance
			select	@CurrAmount = Balance, 
				@PreviousTransferToPatient = isnull(PreviousTransferToPatient, 1)
			from	@ClaimBalance
			where	ClaimID = @CurrClaimID

			set @CurrUnapplied = @PrevUnapplied				-- unchanged

			if @PreviousTransferToPatient = 1
			begin
				-- The previous was transferred to patient so subtract from the patient balance
				set @CurrPatientBalance = @PrevPatientBalance - @CurrAmount
				set @CurrInsuranceBalance = @PrevInsuranceBalance	-- unchanged
			end
			else
			begin
				-- The previous was transferred to insurance so subtract from the insurance balance
				set @CurrPatientBalance = @PrevPatientBalance		-- unchanged
				set @CurrInsuranceBalance = @PrevInsuranceBalance - @CurrAmount
			end
		end

		-- Update this line with the calculated values
		update 	@OrderedDetail
		set	Amount = @CurrAmount, 
			PatientBalance = @CurrPatientBalance, 
			InsuranceBalance = @CurrInsuranceBalance, 
			Unapplied = @CurrUnapplied
		where	Id = @CurrId


		-- Set the previous values
		set	@PrevPatientBalance = @CurrPatientBalance
		set	@PrevInsuranceBalance = @CurrInsuranceBalance
		set	@PrevUnapplied = @CurrUnapplied

		-- Get the next set of values
		FETCH NEXT FROM activity_cursor
		INTO 	@CurrId, 
			@CurrClaimTransactionTypeCode, 
			@CurrAmount, 
			@CurrIsPatientTransfer, 
			@CurrPaymentPayerTypeCode, 
			@CurrClaimId
	END

	CLOSE activity_cursor
	DEALLOCATE activity_cursor

	--Update the TotalBalance, PatientBalance, and Unapplied amounts for the voided claims with the record right above it	
	DECLARE @CurrentID int
	SELECT 	@CurrentID = min(ID)
	FROM	@OrderedDetail
	WHERE	IsVoidedClaim = 1

	WHILE NOT @CurrentID is null
	BEGIN
		--Get the previous record and set the balances using it
		UPDATE 	OD
		SET 	--InsuranceBalance = OD2.InsuranceBalance,
			--PatientBalance = OD2.PatientBalance,
			Unapplied = OD2.Unapplied
		FROM	@OrderedDetail OD
		LEFT JOIN
			@OrderedDetail OD2
		ON	   OD2.ID = @CurrentID - 1
		WHERE	OD.ID = @CurrentID

		--Get the next ID to process if any
		SELECT 	@CurrentID = min(ID)
		FROM	@OrderedDetail
		WHERE	IsVoidedClaim = 1
		AND	ID > @CurrentID
	END

	--Update the voided amounts to a negative value
	UPDATE	@OrderedDetail
	SET	Amount = -1 * Amount
	WHERE	ClaimTransactionTypeCode = 'XXX'	

	RETURN 

END
*/

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

