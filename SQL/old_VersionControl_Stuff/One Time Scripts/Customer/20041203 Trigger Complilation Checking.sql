if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_IU_Payment_ChangeTime]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tr_IU_Payment_ChangeTime]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_IU_PatientInsurance_ChangeTime]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tr_IU_PatientInsurance_ChangeTime]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_IU_PatientAuthorization_ChangeTime]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tr_IU_PatientAuthorization_ChangeTime]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_IU_Patient_ChangeTime]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tr_IU_Patient_ChangeTime]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_IU_HandheldEncounter_ChangeTime]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tr_IU_HandheldEncounter_ChangeTime]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_IU_EncounterProcedure_ChangeTime]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tr_IU_EncounterProcedure_ChangeTime]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_IU_Encounter_ChangeTime]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tr_IU_Encounter_ChangeTime]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_IU_ClaimTransaction_ChangeTime]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tr_IU_ClaimTransaction_ChangeTime]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_IU_Claim_ChangeTime]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tr_IU_Claim_ChangeTime]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_ClaimTransaction_MaintainClaimBalances]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tr_ClaimTransaction_MaintainClaimBalances]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_Claim_MaintainClaimAmountInClaimTransaction]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[tr_Claim_MaintainClaimAmountInClaimTransaction]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[MaintainPaymentsOnEncounterApproved]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
drop trigger [dbo].[MaintainPaymentsOnEncounterApproved]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- MAINTAIN PAYMENTS ON ENCOUNTER APPROVED
--===========================================================================
CREATE TRIGGER dbo.MaintainPaymentsOnEncounterApproved
ON	dbo.Encounter
FOR	INSERT, UPDATE
AS
BEGIN
	DECLARE @patient_id INT
	DECLARE @practice_id INT
	DECLARE @encounter_date DATETIME
	DECLARE @paid_amount MONEY
	DECLARE @encounter_status INT
	DECLARE @encounter_id INT
	DECLARE @payment_id INT

	--Retrieve information about the encounter affected.
	SELECT	@patient_id = PatientID,
		@encounter_id = EncounterID,
		@practice_id = PracticeID,
		@encounter_date = DateOfService,
		@paid_amount = AmountPaid,
		@encounter_status = EncounterStatusID
	FROM	INSERTED

	--check for payment for this encounter
	SET @payment_id = (SELECT PaymentID FROM Payment WHERE SourceEncounterID = @encounter_id)

	--encounter is not approved so delete any potentially listed payments
	IF (@encounter_status <> 3)
	BEGIN
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
			PaymentDate,
			PaymentAmount,
			PaymentMethodCode,
			PayerTypeCode,
			PayerID,
			PaymentNumber,
			Description)
		VALUES	(
			@practice_id,
			@encounter_id,
			@encounter_date,
			@paid_amount,
			'U',
			'P',
			@patient_id,
			NULL,
			'PATIENT PAYMENT MADE AT TIME OF ENCOUNTER')
			
		SET @payment_id = SCOPE_IDENTITY()

		--associate with patient			
		EXEC dbo.PaymentDataProvider_AddPatientForPayment @payment_id, @patient_id
		
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
			PaymentDate = @encounter_date,
			PaymentAmount = @paid_amount,
			PayerID = @patient_id
		WHERE
			PaymentID = @payment_id
		
		IF (@old_patient_id IS NOT NULL)
			EXEC dbo.PaymentDataProvider_RemovePatientFromPayment @payment_id, @old_patient_id
		
		EXEC dbo.PaymentDataProvider_AddPatientForPayment @payment_id, @patient_id
	END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- Maintain Claim amount info in the ClaimTransaction table
--===========================================================================
CREATE TRIGGER dbo.tr_Claim_MaintainClaimAmountInClaimTransaction
ON	dbo.Claim
FOR	INSERT, UPDATE
AS
BEGIN
	IF UPDATE(ServiceChargeAmount) OR UPDATE(ServiceUnitCount)
	BEGIN 

		-- =============================================
		-- Declare and using a READ_ONLY cursor
		-- =============================================
		DECLARE claim_cursor CURSOR
		READ_ONLY
		FOR 
			SELECT I.ClaimID, 
				ISNULL(I.ServiceChargeAmount,0) * ISNULL(I.ServiceUnitCount,0) AS Amount,
				I.PatientID,
				I.PracticeID,
				I.CreatedDate
			FROM inserted I
		
		DECLARE @ClaimID int
		DECLARE @Amount money
		DECLARE @PatientID int
		DECLARE @PracticeID int
		DECLARE @ClaimCreatedDate datetime	
		
		OPEN claim_cursor
		
		FETCH NEXT FROM claim_cursor INTO @ClaimID, @Amount, @PatientID, @PracticeID, @ClaimCreatedDate
		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN
	
				IF NOT EXISTS(	SELECT *
							FROM dbo.ClaimTransaction CT
							WHERE CT.ClaimID = @ClaimID
								AND CT.ClaimTransactionTypeCode = 'CST'
							)
				BEGIN
					INSERT INTO [dbo].[ClaimTransaction] (
						[Amount],
						[ClaimID],
						[ClaimTransactionTypeCode],
						[Notes],
						[PatientID],
						[PracticeID],
						[TransactionDate],
						CreatedDate)
					VALUES (
						@Amount,
						@ClaimID,
						'CST',
						'Claim created for ' + STR(@Amount,15,2) + '  ',
						@PatientID,
						@PracticeID,
						GETDATE(),
						@ClaimCreatedDate)
				END
				ELSE
				BEGIN 
					--Update the claim start transaction amount
					UPDATE	[dbo].[ClaimTransaction]
						SET	[Amount] = @Amount,
							[ModifiedDate] = GETDATE(),
							[Notes] = CAST(Notes AS varchar(8000)) + 'Claim updated for ' + STR(@Amount,15,2) + '  '
						WHERE ClaimID = @ClaimID
							AND ClaimTransactionTypeCode = 'CST'
				END 
			END
			FETCH NEXT FROM claim_cursor INTO @ClaimID, @Amount, @PatientID, @PracticeID, @ClaimCreatedDate
		END
		
		CLOSE claim_cursor
		DEALLOCATE claim_cursor
	
	END

END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- Maintain Claim amount info in the ClaimTransaction table
--===========================================================================
CREATE TRIGGER dbo.tr_ClaimTransaction_MaintainClaimBalances
ON	dbo.ClaimTransaction
FOR	INSERT, UPDATE
AS
BEGIN
	--IF UPDATE(ServiceChargeAmount) OR UPDATE(ServiceUnitCount)
	BEGIN 
		CREATE TABLE #ClaimTransList(ClaimTransactionID int PRIMARY KEY)
		
		-- =============================================
		-- Declare and using a READ_ONLY cursor
		-- =============================================
		DECLARE claimtrans_cursor CURSOR
		READ_ONLY
		FOR 
			SELECT I.ClaimTransactionID,
				I.ClaimID
			FROM inserted I
		
		DECLARE @ClaimTransactionID int
		DECLARE @InsideClaimTransactionID int
		DECLARE @ClaimID int
		DECLARE @BatchKey uniqueidentifier
		SET @BatchKey = NEWID()
		
		OPEN claimtrans_cursor
		
		FETCH NEXT FROM claimtrans_cursor INTO @ClaimTransactionID, @ClaimID
		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN
				--Do NOT reprocess claimtransactionid's already processed in this group
				IF NOT EXISTS(SELECT * FROM #ClaimTransList WHERE ClaimTransactionID = @ClaimTransactionID)
				BEGIN
					--Update the currently affected transaction
					EXEC dbo.ClaimDataProvider_UpdateClaimTransactionBalances @ClaimTransactionID, @BatchKey
					
					-- =============================================
					-- Declare and using a READ_ONLY cursor
					-- =============================================
					
					--Any future transactions for this claim and UPDATE them AS well
					DECLARE inside_cursor CURSOR
					READ_ONLY
					FOR 
						SELECT ClaimTransactionID
						FROM dbo.ClaimTransaction CT
						WHERE CT.ClaimID = @ClaimID
							AND CT.ClaimTransactionID > @ClaimTransactionID	
					
					OPEN inside_cursor
					
					FETCH NEXT FROM inside_cursor INTO @InsideClaimTransactionID
					WHILE (@@fetch_status <> -1)
					BEGIN
						IF (@@fetch_status <> -2)
						BEGIN
							INSERT #ClaimTransList(ClaimTransactionID)
							VALUES(@InsideClaimTransactionID)
							
							EXEC dbo.ClaimDataProvider_UpdateClaimTransactionBalances @InsideClaimTransactionID, @BatchKey
						END
						FETCH NEXT FROM inside_cursor INTO @InsideClaimTransactionID
					END
					
					CLOSE inside_cursor
					DEALLOCATE inside_cursor
				END
			END
			FETCH NEXT FROM claimtrans_cursor INTO @ClaimTransactionID, @ClaimID
		END
		
		CLOSE claimtrans_cursor
		DEALLOCATE claimtrans_cursor
		
		DROP TABLE #ClaimTransList	
	END
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- TR -- IU -- CLAIM -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_Claim_ChangeTime ON dbo.Claim
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	
	IF UPDATE(InitialTreatmentDate)
	BEGIN
		UPDATE C
			SET InitialTreatmentDate =  dbo.fn_ReplaceTimeInDate(i.InitialTreatmentDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(SimilarIllnessDate)
	BEGIN
		UPDATE C
			SET SimilarIllnessDate =  dbo.fn_ReplaceTimeInDate(i.SimilarIllnessDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(LastWorkedDate)
	BEGIN
		UPDATE C
			SET LastWorkedDate =  dbo.fn_ReplaceTimeInDate(i.LastWorkedDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(ReturnToWorkDate)
	BEGIN
		UPDATE C
			SET ReturnToWorkDate =  dbo.fn_ReplaceTimeInDate(i.ReturnToWorkDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(DisabilityBeginDate)
	BEGIN
		UPDATE C
			SET DisabilityBeginDate =  dbo.fn_ReplaceTimeInDate(i.DisabilityBeginDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(DisabilityEndDate)
	BEGIN
		UPDATE C
			SET DisabilityEndDate =  dbo.fn_ReplaceTimeInDate(i.DisabilityEndDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(HospitalizationBeginDate)
	BEGIN
		UPDATE C
			SET HospitalizationBeginDate =  dbo.fn_ReplaceTimeInDate(i.HospitalizationBeginDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(HospitalizationEndDate)
	BEGIN
		UPDATE C
			SET HospitalizationEndDate =  dbo.fn_ReplaceTimeInDate(i.HospitalizationEndDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	
	IF UPDATE(ReferralDate)
	BEGIN
		UPDATE C
			SET ReferralDate = dbo.fn_ReplaceTimeInDate(i.ReferralDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(LastSeenDate)
	BEGIN
		UPDATE C
			SET LastSeenDate = dbo.fn_ReplaceTimeInDate(i.LastSeenDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(CurrentIllnessDate)
	BEGIN
		UPDATE C
			SET CurrentIllnessDate = dbo.fn_ReplaceTimeInDate(i.CurrentIllnessDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(AcuteManifestationDate)
	BEGIN
		UPDATE C
			SET AcuteManifestationDate = dbo.fn_ReplaceTimeInDate(i.AcuteManifestationDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(LastMenstrualDate)
	BEGIN
		UPDATE C
			SET LastMenstrualDate = dbo.fn_ReplaceTimeInDate(i.LastMenstrualDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(LastXrayDate)
	BEGIN
		UPDATE C
			SET LastXrayDate = dbo.fn_ReplaceTimeInDate(i.LastXrayDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(EstimatedBirthDate)
	BEGIN
		UPDATE C
			SET EstimatedBirthDate = dbo.fn_ReplaceTimeInDate(i.EstimatedBirthDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(HearingVisionPrescriptionDate)
	BEGIN
		UPDATE C
			SET HearingVisionPrescriptionDate = dbo.fn_ReplaceTimeInDate(i.HearingVisionPrescriptionDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(ServiceBeginDate)
	BEGIN
		UPDATE C
			SET ServiceBeginDate = dbo.fn_ReplaceTimeInDate(i.ServiceBeginDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(ServiceEndDate)
	BEGIN
		UPDATE C
			SET ServiceEndDate = dbo.fn_ReplaceTimeInDate(i.ServiceEndDate)
		FROM dbo.Claim C INNER JOIN
			inserted i ON
				C.ClaimID = i.ClaimID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END



	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- TR -- IU -- CLAIM TRANSACTION -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_ClaimTransaction_ChangeTime ON dbo.ClaimTransaction
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(ReferenceDate)
	BEGIN
		UPDATE CT
			SET ReferenceDate =  dbo.fn_ReplaceTimeInDate(i.ReferenceDate)
		FROM dbo.ClaimTransaction CT INNER JOIN
			inserted i ON
				CT.ClaimTransactionID = i.ClaimTransactionID

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END


	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- TR -- IU -- ENCOUNTER -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_Encounter_ChangeTime ON dbo.Encounter
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(DateCreated)
	BEGIN
		UPDATE E
			SET DateCreated =  dbo.fn_ReplaceTimeInDate(i.DateCreated)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	IF UPDATE(DatePosted)
	BEGIN
		UPDATE E
			SET DatePosted =  dbo.fn_ReplaceTimeInDate(i.DatePosted)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	IF UPDATE(DateOfService)
	BEGIN
		UPDATE E
			SET DateOfService =  dbo.fn_ReplaceTimeInDate(i.DateOfService)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	IF UPDATE(DateOfInjury)
	BEGIN
		UPDATE E
			SET DateOfInjury =  dbo.fn_ReplaceTimeInDate(i.DateOfInjury)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	
	IF UPDATE(InitialTreatmentDate)
	BEGIN
		UPDATE E
			SET InitialTreatmentDate =  dbo.fn_ReplaceTimeInDate(i.InitialTreatmentDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(SimilarIllnessDate)
	BEGIN
		UPDATE E
			SET SimilarIllnessDate =  dbo.fn_ReplaceTimeInDate(i.SimilarIllnessDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(LastWorkedDate)
	BEGIN
		UPDATE E
			SET LastWorkedDate =  dbo.fn_ReplaceTimeInDate(i.LastWorkedDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(ReturnToWorkDate)
	BEGIN
		UPDATE E
			SET ReturnToWorkDate =  dbo.fn_ReplaceTimeInDate(i.ReturnToWorkDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(DisabilityBeginDate)
	BEGIN
		UPDATE E
			SET DisabilityBeginDate =  dbo.fn_ReplaceTimeInDate(i.DisabilityBeginDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(DisabilityEndDate)
	BEGIN
		UPDATE E
			SET DisabilityEndDate =  dbo.fn_ReplaceTimeInDate(i.DisabilityEndDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(HospitalizationBeginDate)
	BEGIN
		UPDATE E
			SET HospitalizationBeginDate =  dbo.fn_ReplaceTimeInDate(i.HospitalizationBeginDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	IF UPDATE(HospitalizationEndDate)
	BEGIN
		UPDATE E
			SET HospitalizationEndDate =  dbo.fn_ReplaceTimeInDate(i.HospitalizationEndDate)
		FROM dbo.Encounter E INNER JOIN
			inserted i ON
				E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	



	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- TR -- IU -- ENCOUNTER PROCEDURE -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_EncounterProcedure_ChangeTime ON dbo.EncounterProcedure
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(ProcedureDateOfService)
	BEGIN
		UPDATE EP
			SET ProcedureDateOfService =  dbo.fn_ReplaceTimeInDate(i.ProcedureDateOfService)
		FROM dbo.EncounterProcedure EP INNER JOIN
			inserted i ON
				EP.EncounterProcedureID = i.EncounterProcedureID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END


	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- TR -- IU -- HANDHELD ENCOUNTER -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_HandheldEncounter_ChangeTime ON dbo.HandheldEncounter
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(DateCreated)
	BEGIN
		UPDATE HE
			SET DateCreated =  dbo.fn_ReplaceTimeInDate(i.DateCreated)
		FROM dbo.HandheldEncounter HE INNER JOIN
			inserted i ON
				HE.HandheldEncounterID = i.HandheldEncounterID

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	IF UPDATE(DateOfService)
	BEGIN
		UPDATE HE
			SET DateOfService =  dbo.fn_ReplaceTimeInDate(i.DateOfService)
		FROM dbo.HandheldEncounter HE INNER JOIN
			inserted i ON
				HE.HandheldEncounterID = i.HandheldEncounterID

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- TR -- IU -- PATIENT -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_Patient_ChangeTime ON dbo.Patient
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(DOB)
	BEGIN
		UPDATE P
			SET DOB =  dbo.fn_ReplaceTimeInDate(i.DOB)
		FROM dbo.Patient P INNER JOIN
			inserted i ON
				P.PatientID = i.PatientID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- TR -- IU -- PATIENT AUTHORIZATION -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_PatientAuthorization_ChangeTime ON dbo.PatientAuthorization
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(StartDate)
	BEGIN
		UPDATE PA
			SET StartDate =  dbo.fn_ReplaceTimeInDate(i.StartDate)
		FROM dbo.PatientAuthorization PA INNER JOIN
			inserted i ON
				PA.PatientAuthorizationID = i.PatientAuthorizationID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	IF UPDATE(EndDate)
	BEGIN
		UPDATE PA
			SET EndDate =  dbo.fn_ReplaceTimeInDate(i.EndDate)
		FROM dbo.PatientAuthorization PA INNER JOIN
			inserted i ON
				PA.PatientAuthorizationID = i.PatientAuthorizationID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- TR -- IU -- PATIENT INSURANCE -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_PatientInsurance_ChangeTime ON dbo.PatientInsurance
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(PolicyStartDate)
	BEGIN
		UPDATE PI
			SET PolicyStartDate =  dbo.fn_ReplaceTimeInDate(i.PolicyStartDate)
		FROM dbo.PatientInsurance PI INNER JOIN
			inserted i ON
				PI.PatientInsuranceID = i.PatientInsuranceID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	IF UPDATE(PolicyEndDate)
	BEGIN
		UPDATE PI
			SET PolicyEndDate =  dbo.fn_ReplaceTimeInDate(i.PolicyEndDate)
		FROM dbo.PatientInsurance PI INNER JOIN
			inserted i ON
				PI.PatientInsuranceID = i.PatientInsuranceID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- TR -- IU -- PAYMENT -- CHANGE TIME
--===========================================================================
CREATE TRIGGER tr_IU_Payment_ChangeTime ON dbo.Payment
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @error_var int
	SET @error_var = 0
	DECLARE @proc_name sysname
    	SET @proc_name = (SELECT name FROM sysobjects WHERE id = @@PROCID)
	DECLARE @CRLF char(2)
    	SET @CRLF = CHAR(13) + CHAR(10)
    
	DECLARE @err_message nvarchar(255)

	IF UPDATE(PaymentDate)
	BEGIN
		UPDATE P
			SET PaymentDate =  dbo.fn_ReplaceTimeInDate(i.PaymentDate)
		FROM dbo.Payment P INNER JOIN
			inserted i ON
				P.PaymentID = i.PaymentID

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END


	RETURN
	
rollback_tran:
	IF @err_message IS NULL
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)
	ELSE
		SET @err_message = 'Rolling back transaction - ' + @proc_name + ' - ' + CONVERT(varchar(30), GETDATE(), 121)  + @CRLF + @CRLF + @err_message

	IF @@TRANCOUNT > 0
    		ROLLBACK TRANSACTION

	RAISERROR(@err_message, 16,1)

	RETURN
END

GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON 
GO

