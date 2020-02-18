IF EXISTS (
	SELECT	*
	FROM	sysobjects
	WHERE	Name = 'tr_IU_Encounter_ChangeTime'
	AND	type = 'TR'
)
	DROP TRIGGER dbo.tr_IU_Encounter_ChangeTime
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

	DECLARE @UPD_DateCreated INT
	DECLARE @UPD_DateOfService INT
	DECLARE @UPD_DateOfServiceTo INT
	DECLARE @UPD_PostingDate INT
	DECLARE @UPD_HospitalizationStartDT INT
	DECLARE @UPD_HospitalizationEndDT INT
	DECLARE @UPD_SubmittedDate INT

	SELECT @UPD_DateCreated=0,@UPD_DateOfService=0,@UPD_DateOfServiceTo=0,@UPD_PostingDate=0,
		   @UPD_HospitalizationStartDT=0,@UPD_HospitalizationEndDT=0,@UPD_SubmittedDate=0

	IF UPDATE(DateCreated)
		SET @UPD_DateCreated=1

	IF UPDATE(DateOfService)
		SET @UPD_DateOfService=1

	IF UPDATE(DateOfServiceTo)
		SET @UPD_DateOfServiceTo=1

	IF UPDATE(PostingDate)
		SET @UPD_PostingDate=1

	IF UPDATE(HospitalizationStartDT)
		SET @UPD_HospitalizationStartDT=1

	IF UPDATE(HospitalizationEndDT)
		SET @UPD_HospitalizationEndDT=1

	IF UPDATE(SubmittedDate)
		SET @UPD_SubmittedDate=1

	DECLARE @InsertedValues TABLE(EncounterID INT, DateCreated DATETIME, DateOfService DATETIME, DateOfServiceTo DATETIME,
							PostingDate DATETIME, HospitalizationStartDT DATETIME, HospitalizationEndDT DATETIME,
							SubmittedDate DATETIME)
	DECLARE @DeletedValues TABLE(EncounterID INT, DateCreated DATETIME, DateOfService DATETIME, DateOfServiceTo DATETIME,
							PostingDate DATETIME, HospitalizationStartDT DATETIME, HospitalizationEndDT DATETIME,
							SubmittedDate DATETIME)

	INSERT @InsertedValues
	SELECT EncounterID, DateCreated, DateOfService, DateOfServiceTo, PostingDate, HospitalizationStartDT,
	HospitalizationEndDT, SubmittedDate
	FROM INSERTED

	INSERT @DeletedValues
	SELECT EncounterID, DateCreated, DateOfService, DateOfServiceTo, PostingDate, HospitalizationStartDT,
	HospitalizationEndDT, SubmittedDate
	FROM DELETED

	--For purposes of comparison DATE 1-1-1800 is used to represent a NULL value
	IF(@UPD_DateCreated+@UPD_DateOfService+@UPD_DateOfServiceTo+@UPD_PostingDate+@UPD_HospitalizationStartDT+@UPD_HospitalizationEndDT+@UPD_SubmittedDate)>0
	AND (NOT EXISTS(SELECT * FROM @DeletedValues)
		 OR EXISTS(SELECT I.*
			       FROM @InsertedValues I INNER JOIN @DeletedValues D ON I.EncounterID=D.EncounterID
			       WHERE I.DateCreated<>D.DateCreated OR I.DateOfService<>D.DateOfService
			       OR ISNULL(I.DateOfServiceTo,'1-1-1800')<>ISNULL(D.DateOfServiceTo,'1-1-1800')
			       OR I.PostingDate<>D.PostingDate
			       OR ISNULL(I.HospitalizationStartDT,'1-1-1800')<>ISNULL(D.HospitalizationStartDT,'1-1-1800')
			       OR ISNULL(I.HospitalizationEndDT,'1-1-1800')<>ISNULL(D.HospitalizationEndDT,'1-1-1800')
			       OR ISNULL(I.SubmittedDate,'1-1-1800')<>ISNULL(D.SubmittedDate,'1-1-1800')))
	BEGIN

		UPDATE E SET DateCreated =  ISNULL(dbo.fn_ReplaceTimeInDate(i.DateCreated),E.DateCreated),
		DateOfService =  ISNULL(dbo.fn_ReplaceTimeInDate(i.DateOfService),E.DateOfService),
		DateOfServiceTo =  ISNULL(dbo.fn_ReplaceTimeInDate(i.DateOfServiceTo),E.DateOfServiceTo),
		PostingDate =  ISNULL(dbo.fn_ReplaceTimeInDate(i.PostingDate),E.PostingDate),
		HospitalizationStartDT =  ISNULL(dbo.fn_ReplaceTimeInDate(i.HospitalizationStartDT),E.HospitalizationStartDT),
		HospitalizationEndDT =  ISNULL(dbo.fn_ReplaceTimeInDate(i.HospitalizationEndDT),E.HospitalizationEndDT),
		SubmittedDate =  ISNULL(dbo.fn_ReplaceTimeInDate(i.SubmittedDate),E.SubmittedDate)
		FROM dbo.Encounter E INNER JOIN inserted i 
		ON E.EncounterID = i.EncounterID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran

		IF @UPD_PostingDate=1 AND 
		   (NOT EXISTS(SELECT * FROM @DeletedValues)
			OR EXISTS(SELECT I.*
			          FROM @InsertedValues I INNER JOIN @DeletedValues D ON I.EncounterID=D.EncounterID
			          WHERE I.PostingDate<>D.PostingDate))
		BEGIN
			UPDATE CT SET PostingDate=dbo.fn_ReplaceTimeInDate(I.PostingDate)
			FROM Inserted I INNER JOIN EncounterProcedure EP
			ON I.PracticeID=EP.PracticeID AND I.EncounterID=EP.EncounterID
			INNER JOIN Claim C
			ON EP.PracticeID=C.PracticeID AND EP.EncounterProcedureID=C.EncounterProcedureID
			INNER JOIN ClaimTransaction CT
			ON C.PracticeID=CT.PracticeID AND C.ClaimID=CT.ClaimID AND CT.ClaimTransactionTypeCode='CST'	

			SET @error_var = @@ERROR
			
			--Error checking
			IF @error_var > 0
				GOTO rollback_tran
		END
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