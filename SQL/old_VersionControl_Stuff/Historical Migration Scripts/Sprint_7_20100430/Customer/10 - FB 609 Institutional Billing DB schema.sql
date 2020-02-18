-- create new fields for institutional billing

-- **********************************************************************************************
-- Lookup Tables creation
-- **********************************************************************************************

-- **********************************************************************************************
-- Service Location
-- **********************************************************************************************
alter table ServiceLocation add
	PayToName varchar(25) null,
	PayToAddressLine1 varchar(256) null,
	PayToAddressLine2 varchar(256) null,
	PayToCity varchar(128) null,
	PayToState varchar(2) null,
	PayToCountry varchar(32) null,
	PayToZipCode varchar(9) null,
	PayToPhone varchar(10) null,
	PayToPhoneExt varchar(10) null,
	PayToFax varchar(10) null,
	PayToFaxExt varchar(10) null,
	EIN varchar(9) null,
	BillTypeID int null 
GO

-- set default BillTypeID
update ServiceLocation set BillTypeID=(select Min(BillTypeID) from BillType)	

alter table ServiceLocation WITH CHECK ADD CONSTRAINT FK_ServiceLocation_BillType FOREIGN KEY(BillTypeID)
	REFERENCES dbo.BillType (BillTypeID)
GO

-- **********************************************************************************************
-- Insurance Policy
-- **********************************************************************************************
alter table InsurancePolicy add
	GroupName varchar(14) null,
	ReleaseOfInformation varchar(1) null

GO
-- FB 821
update InsurancePolicy
set ReleaseOfInformation = 'Y'	

GO

-- **********************************************************************************************
-- Encounter
-- **********************************************************************************************
alter table dbo.Encounter add
	ClaimTypeID int not null default 0,

	OperatingProviderID int,
	OtherProviderID int,
	PrincipalDiagnosisCodeDictionaryID int,
	AdmittingDiagnosisCodeDictionaryID int,
	PrincipalProcedureCodeDictionaryID int,
	DRGCodeID int,
	ProcedureDate DateTime,
	AdmissionTypeID int,
	AdmissionDate DateTime,
	PointOfOriginCodeID int,
	AdmissionHour varchar(2),
	DischargeHour varchar(2),
	DischargeStatusCodeID int,
	Remarks varchar(255),
	SubmitReasonID int,
	DocumentControlNumber varchar(26)

GO	

ALTER TABLE dbo.Encounter WITH CHECK ADD CONSTRAINT FK_Encounter_OprtatingProvider FOREIGN KEY (OperatingProviderID)
	REFERENCES dbo.Doctor (DoctorID)
GO

ALTER TABLE dbo.Encounter WITH CHECK ADD CONSTRAINT FK_Encounter_OtherProvider FOREIGN KEY (OtherProviderID)
	REFERENCES dbo.Doctor (DoctorID)
GO

ALTER TABLE dbo.Encounter WITH CHECK ADD CONSTRAINT FK_Encounter_ClaimType FOREIGN KEY(ClaimTypeID)
	REFERENCES dbo.ClaimType (ClaimTypeID)
GO

ALTER TABLE dbo.Encounter WITH CHECK ADD CONSTRAINT FK_Encounter_PrincipalDiagnosisCodeDictionary FOREIGN KEY(PrincipalDiagnosisCodeDictionaryID)
	REFERENCES dbo.DiagnosisCodeDictionary (DiagnosisCodeDictionaryID)
GO

ALTER TABLE dbo.Encounter WITH CHECK ADD CONSTRAINT FK_Encounter_SubmitReason FOREIGN KEY(SubmitReasonID)
	REFERENCES dbo.SubmitReason (SubmitReasonID)
GO

ALTER TABLE dbo.Encounter WITH CHECK ADD CONSTRAINT FK_Encounter_AdmittingDiagnosisCodeDictionary FOREIGN KEY(AdmittingDiagnosisCodeDictionaryID)
	REFERENCES dbo.DiagnosisCodeDictionary (DiagnosisCodeDictionaryID)
GO

ALTER TABLE dbo.Encounter WITH CHECK ADD CONSTRAINT FK_Encounter_PrincipalProcedureCodeDictionary FOREIGN KEY(PrincipalProcedureCodeDictionaryID)
	REFERENCES dbo.ProcedureCodeDictionary (ProcedureCodeDictionaryID)
GO

ALTER TABLE dbo.Encounter WITH CHECK ADD CONSTRAINT FK_Encounter_DRGCode FOREIGN KEY(DRGCodeID)
	REFERENCES dbo.DRGCode (DRGCodeID)
GO

ALTER TABLE dbo.Encounter WITH CHECK ADD CONSTRAINT FK_Encounter_AdmissionTypeCode FOREIGN KEY(AdmissionTypeID)
	REFERENCES dbo.AdmissionTypeCode (AdmissionTypeCodeID)
GO

ALTER TABLE dbo.Encounter WITH CHECK ADD CONSTRAINT FK_Encounter_PointOfOrigin FOREIGN KEY(PointOfOriginCodeID)
	REFERENCES dbo.PointOfOriginCode (PointOfOriginCodeID)
GO

ALTER TABLE dbo.Encounter WITH CHECK ADD CONSTRAINT FK_Encounter_DischargeStatus FOREIGN KEY(DischargeStatusCodeID)
	REFERENCES dbo.DischargeStatusCode (DischargeStatusCodeID)
GO

if exists (select * from sys.tables where name='EncounterHealthCode')
	drop table EncounterHealthCode
GO

create table dbo.EncounterHealthCode (
	EncounterHealthCodeID int not null identity(1, 1),
	EncounterID int not null,
	HealthCodeID int null,
	DateFrom DateTime null,
	DateTo DateTime null,
	Amount money null default 0,
	DiagnosisCodeDictionaryID int null,
	
	CreatedUserID int null,
	UpdatedUserID int null
	
	CONSTRAINT PK_EncounterHealthCode PRIMARY KEY CLUSTERED 
	(
		EncounterHealthCodeID ASC
	)
)

alter table dbo.EncounterHealthCode WITH CHECK ADD CONSTRAINT FK_EncounterHealthCode_HealthCode FOREIGN KEY(HealthCodeID)
	REFERENCES dbo.HealthCode (HealthCodeID)

alter table dbo.EncounterHealthCode WITH CHECK ADD CONSTRAINT FK_EncounterHealthCode_Encounter FOREIGN KEY(EncounterID)
	REFERENCES dbo.Encounter (EncounterID)

alter table dbo.EncounterHealthCode WITH CHECK ADD CONSTRAINT FK_EncounterHealthCode_DiagnosisCodeDictionary FOREIGN KEY(DiagnosisCodeDictionaryID)
	REFERENCES dbo.DiagnosisCodeDictionary (DiagnosisCodeDictionaryID)

alter table dbo.EncounterProcedure add 
	AssessmentDate DateTime null,
	RevenueCodeID int null,
	NonCoveredCharges money
GO

ALTER TABLE dbo.EncounterProcedure WITH CHECK ADD CONSTRAINT FK_EncounterProcedure_RevenueCode FOREIGN KEY(RevenueCodeID)
	REFERENCES dbo.RevenueCode (RevenueCodeID)
GO

ALTER TABLE dbo.InsuranceCompany ADD InstitutionalBillingFormID int
GO

ALTER TABLE dbo.EncounterProcedure add
	DoctorID int null,
	StartTime datetime null,
	EndTime datetime null,
	ConcurrentProcedures int null
	
ALTER TABLE dbo.EncounterProcedure WITH CHECK ADD CONSTRAINT [FK_EncounterProcedure_Doctor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([DoctorID])

GO

ALTER TABLE dbo.ContractFeeSchedule add
	BaseUnits int not null default 0
GO

--*********************************************************************************************************************
-- TIME SHIFTING TRIGGERS for encounter and encounter procedure
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
	DECLARE @UPD_AdmissionDate INT
	DECLARE @UPD_ProcedureDate INT


	SELECT @UPD_DateCreated=0,@UPD_DateOfService=0,@UPD_DateOfServiceTo=0,@UPD_PostingDate=0,
		   @UPD_HospitalizationStartDT=0,@UPD_HospitalizationEndDT=0,@UPD_SubmittedDate=0,@UPD_AdmissionDate=0,@UPD_ProcedureDate=0

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

	IF UPDATE(AdmissionDate)
		SET @UPD_AdmissionDate=1

	IF UPDATE(ProcedureDate)
		SET @UPD_ProcedureDate=1

	DECLARE @InsertedValues TABLE(EncounterID INT, DateCreated DATETIME, DateOfService DATETIME, DateOfServiceTo DATETIME,
							PostingDate DATETIME, HospitalizationStartDT DATETIME, HospitalizationEndDT DATETIME,
							SubmittedDate DATETIME, AdmissionDate DATETIME, ProcedureDate DATETIME)
	DECLARE @DeletedValues TABLE(EncounterID INT, DateCreated DATETIME, DateOfService DATETIME, DateOfServiceTo DATETIME,
							PostingDate DATETIME, HospitalizationStartDT DATETIME, HospitalizationEndDT DATETIME,
							SubmittedDate DATETIME, AdmissionDate DATETIME, ProcedureDate DATETIME)

	INSERT @InsertedValues
	SELECT EncounterID, DateCreated, DateOfService, DateOfServiceTo, PostingDate, HospitalizationStartDT,
	HospitalizationEndDT, SubmittedDate, AdmissionDate, ProcedureDate
	FROM INSERTED

	INSERT @DeletedValues
	SELECT EncounterID, DateCreated, DateOfService, DateOfServiceTo, PostingDate, HospitalizationStartDT,
	HospitalizationEndDT, SubmittedDate, AdmissionDate, ProcedureDate
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
			       OR ISNULL(I.SubmittedDate,'1-1-1800')<>ISNULL(D.SubmittedDate,'1-1-1800')
			       OR ISNULL(I.AdmissionDate,'1-1-1800')<>ISNULL(D.AdmissionDate,'1-1-1800')
			       OR ISNULL(I.ProcedureDate,'1-1-1800')<>ISNULL(D.ProcedureDate,'1-1-1800')
			       ))
	BEGIN

		UPDATE E SET DateCreated =  ISNULL(dbo.fn_ReplaceTimeInDate(i.DateCreated),E.DateCreated),
		DateOfService =  ISNULL(dbo.fn_ReplaceTimeInDate(i.DateOfService),E.DateOfService),
		DateOfServiceTo =  ISNULL(dbo.fn_ReplaceTimeInDate(i.DateOfServiceTo),E.DateOfServiceTo),
		PostingDate =  ISNULL(dbo.fn_ReplaceTimeInDate(i.PostingDate),E.PostingDate),
		HospitalizationStartDT =  ISNULL(dbo.fn_ReplaceTimeInDate(i.HospitalizationStartDT),E.HospitalizationStartDT),
		HospitalizationEndDT =  ISNULL(dbo.fn_ReplaceTimeInDate(i.HospitalizationEndDT),E.HospitalizationEndDT),
		SubmittedDate =  ISNULL(dbo.fn_ReplaceTimeInDate(i.SubmittedDate),E.SubmittedDate),
		AdmissionDate =  ISNULL(dbo.fn_ReplaceTimeInDate(i.AdmissionDate),E.AdmissionDate),
		ProcedureDate =  ISNULL(dbo.fn_ReplaceTimeInDate(i.ProcedureDate),E.ProcedureDate)
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

--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	sysobjects
	WHERE	Name = 'tr_IU_EncounterProcedure_ChangeTime'
	AND	type = 'TR'
)
	DROP TRIGGER dbo.tr_IU_EncounterProcedure_ChangeTime
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
		DECLARE @InsertedProcedureDateOfService DATETIME
		DECLARE @DeletedProcedureDateOfService DATETIME
		DECLARE @EncounterProcedureID INT
		DECLARE @PracticeID INT

		SELECT @InsertedProcedureDateOfService=ProcedureDateOfService,
		@EncounterProcedureID=EncounterProcedureID,
		@PracticeID=PracticeID
		FROM Inserted

		SELECT @DeletedProcedureDateOfService=ProcedureDateOfService
		FROM Deleted
		
		IF @DeletedProcedureDateOfService IS NULL 
		OR @InsertedProcedureDateOfService<>@DeletedProcedureDateOfService
		BEGIN
			UPDATE EP
			SET ProcedureDateOfService =  dbo.fn_ReplaceTimeInDate(@InsertedProcedureDateOfService)
			FROM dbo.EncounterProcedure EP
			WHERE EP.EncounterProcedureID = @EncounterProcedureID	
		END

		IF @DeletedProcedureDateOfService IS NOT NULL 
		AND @InsertedProcedureDateOfService<>@DeletedProcedureDateOfService
		BEGIN
			UPDATE Claim SET DKProcedureDateOfServiceID=dbo.fn_GetDateKeySelectivityID(@PracticeID,dbo.fn_ReplaceTimeInDate(@InsertedProcedureDateOfService),0,0)
			WHERE EncounterProcedureID=@EncounterProcedureID
		END

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END
	
	IF UPDATE(ServiceEndDate)
	BEGIN
		UPDATE EP
			SET ServiceEndDate =  dbo.fn_ReplaceTimeInDate(i.ServiceEndDate)
		FROM dbo.EncounterProcedure EP INNER JOIN
			inserted i ON
				EP.EncounterProcedureID = i.EncounterProcedureID	

		SET @error_var = @@ERROR
		
		--Error checking
		IF @error_var > 0
			GOTO rollback_tran
	END

	IF UPDATE(AssessmentDate)
	BEGIN
		UPDATE EP
			SET AssessmentDate =  dbo.fn_ReplaceTimeInDate(i.AssessmentDate)
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
