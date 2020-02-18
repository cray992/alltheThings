-- update script for the practitioner

IF NOT EXISTS(
	SELECT * FROM sys.tables T 
		join sys.columns c on c.object_id=t.object_id and c.name='ServiceChargeAmount'
	WHERE t.name ='HandheldEncounterDetail')
BEGIN
	ALTER TABLE HandheldEncounterDetail ADD ServiceChargeAmount MONEY NOT NULL DEFAULT 0
END
GO



--===========================================================================
-- 
-- ENCOUNTER DATA PROVIDER
-- 	(HANDHELD EDITION)
--
--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'Handheld_EncounterDataProvider_CreateEncounterDetail'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.Handheld_EncounterDataProvider_CreateEncounterDetail
GO

--===========================================================================
-- CREATE ENCOUNTER
--===========================================================================
CREATE PROCEDURE dbo.Handheld_EncounterDataProvider_CreateEncounterDetail
	@handheldencounterID INT,
	@procedure_code INT,
	@Units DECIMAL(19,4),
	@ServiceChargeAmount money,
	@diagnosis_code_1 INT,
	@diagnosis_code_2 INT,
	@diagnosis_code_3 INT,
	@diagnosis_code_4 INT,
	@Modifier_1 varchar(16),
	@Modifier_2 varchar(16),
	@Modifier_3 varchar(16),
	@Modifier_4 varchar(16)

AS
BEGIN

	INSERT	HANDHELDENCOUNTERDETAIL (
		HandheldEncounterID,
		ProcedureCodeDictionaryID,
		Units,
		ServiceChargeAmount,
		DiagnosisCodeDictionaryID1,
		DiagnosisCodeDictionaryID2,
		DiagnosisCodeDictionaryID3,
		DiagnosisCodeDictionaryID4,
		Modifier1,
		Modifier2,
		Modifier3,
		Modifier4)
	VALUES	(
		@handheldencounterID,
		@procedure_code,
		@Units,
		@ServiceChargeAmount,
		@diagnosis_code_1,
		@diagnosis_code_2,
		@diagnosis_code_3,
		@diagnosis_code_4,
		@Modifier_1,
		@Modifier_2,
		@Modifier_3,
		@Modifier_4)

	RETURN @@identity
END
GO

--===========================================================================
--
-- MOBILE ENCOUNTER DATA PROVIDER
--
--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'EncounterDataProvider_ConvertMobileEncounter'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.EncounterDataProvider_ConvertMobileEncounter
GO

--===========================================================================
-- CONVERT MOBILE ENCOUNTER TO A REAL ONE
-- exec dbo.EncounterDataProvider_ConvertMobileEncounter 452
--===========================================================================
CREATE  PROCEDURE dbo.EncounterDataProvider_ConvertMobileEncounter
	@mobileEncounterId INT
AS
BEGIN

	DECLARE @newID INT

	DECLARE @practiceID INT
	DECLARE @caseID INT
	DECLARE @doctorID INT
	DECLARE @patientID INT
	DECLARE @locationID INT
	DECLARE @dateCreated DATETIME
	DECLARE @dateOfService DATETIME
	DECLARE @datePosted DATETIME

	DECLARE @authorizationID INT
	DECLARE @placeOfServiceCode CHAR(2)
	DECLARE @referringProviderID INT

	-- Get the necessary handheld encounter data
	SELECT 	@practiceID=ME.PracticeID,
		@doctorID = ME.DoctorID,
		@patientID = ME.PatientID,
		@locationID = ME.ServiceLocationID,
		@dateCreated = ME.DateCreated,
		@dateOfService = ME.DateOfService,
		@datePosted = IsNull(ME.DatePosted, ME.DateOfService)
	FROM	HandheldEncounter ME
	WHERE	ME.HandheldEncounterID = @mobileEncounterId

	-- Get the default case id if there is one
	SELECT	@caseID = PatientCaseID
	FROM	dbo.fn_PatientDataProvider_GetDefaultPatientCase(@patientID)

	-- Try to get Referring Provider from the patient case
--	SET @ReferringProviderID=NULL
--	SELECT @ReferringProviderID=ReferringPhysicianID FROM PatientCase WHERE PatientCaseID=@caseID
	-- in case there is no ReferringPhysicianID is on the case - try to get it from the Patient record
--	IF @ReferringProviderID is null
--		SELECT @ReferringProviderID=ReferringPhysicianID from Patient where PatientID=@patientID

	SELECT @ReferringProviderID=COALESCE(PC.ReferringPhysicianID, P.ReferringPhysicianID) from Patient P
		LEFT JOIN PatientCase PC on PC.PatientCaseID=@caseID


	-- Grab any data from the most recent encounter with this case (if case was found)
	IF	@caseID IS NOT NULL
	BEGIN
		SELECT	@authorizationID = E.InsurancePolicyAuthorizationID,
			@placeOfServiceCode = E.PlaceOfServiceCode
		FROM	PATIENT P
			LEFT OUTER JOIN ENCOUNTER E
			ON E.EncounterID = (
				SELECT	TOP 1 EE.EncounterID
				FROM	ENCOUNTER EE
				WHERE	EE.PatientID = P.PatientID
				AND	EE.PatientCaseID = @caseID
				ORDER BY CreatedDate DESC)
		WHERE	P.PatientID = @patientID
	END

	IF(@placeOfServiceCode IS NOT NULL)
	BEGIN

		-- Insert the encounter record
		INSERT	ENCOUNTER (
			PracticeID,
			PatientID,
			PatientCaseID, 
			DoctorID,
			LocationID,
			DateCreated,
			DateOfService,
			PostingDate,
			EncounterStatusID,
			Notes,
			ReleaseSignatureSourceCode, 
			AmountPaid,
			InsurancePolicyAuthorizationID,
			PlaceOfServiceCode,
			ReferringPhysicianID)
		VALUES	(
			@practiceID,		-- PracticeID
			@patientID,		-- PatientID
			@caseID, 		-- PatientCaseID
			@doctorID,		-- DoctorID
			@locationID,		-- LocationID
			@dateCreated,		-- DateCreated
			@dateOfService,		-- DateOfService
			@datePosted,		-- DatePosted
			CAST(1 AS INT),		-- EncounterStatusID
			'',			-- Notes
			CAST('B' as CHAR(1)), 	-- ReleaseSignatureSourceCode
			CAST(0 AS MONEY),	-- AmountPaid
			@authorizationID, 	-- InsurancePolicyAuthorizationID
			@placeOfServiceCode,	-- PlaceOfServiceCode
			@ReferringProviderID	-- ReferringPhysicianID
		)

	END
	ELSE
	BEGIN

		-- Insert the encounter record without the auth or place of service data
		INSERT	ENCOUNTER (
			PracticeID,
			PatientID,
			PatientCaseID, 
			DoctorID,
			LocationID,
			DateCreated,
			DateOfService,
			PostingDate,
			EncounterStatusID,
			Notes,
			ReleaseSignatureSourceCode, 
			AmountPaid,
			ReferringPhysicianID
			)
		VALUES	(
			@practiceID,		-- PracticeID
			@patientID,		-- PatientID
			@caseID, 		-- PatientCaseID
			@doctorID,		-- DoctorID
			@locationID,		-- LocationID
			@dateCreated,		-- DateCreated
			@dateOfService,		-- DateOfService
			@datePosted,		-- DatePosted
			CAST(1 AS INT),		-- EncounterStatusID
			'',			-- Notes
			CAST('B' as CHAR(1)), 	-- ReleaseSignatureSourceCode
			CAST(0 AS MONEY),	-- AmountPaid
			@ReferringProviderID
		)

	END

	SET @newID = SCOPE_IDENTITY()

  -- COPY THE Notes field -- START:

	-- the code below is doing basically the following:
	--	UPDATE	ENCOUNTER 
	--	SET Notes = (SELECT Notes FROM HandheldEncounter WHERE HandheldEncounterID = @mobileEncounterId)
	--	WHERE EncounterID = @newID

	DECLARE @src_textptr varbinary(16), @dest_textptr varbinary(16);

	SELECT @src_textptr = TEXTPTR( HandheldEncounter.Notes )
		FROM HandheldEncounter
		WHERE HandheldEncounterID = @mobileEncounterId
	
	-- (Ensure that the text pointer is initialized to '' in the destination table)

	SELECT @dest_textptr = TEXTPTR( Encounter.Notes )
	FROM Encounter
	WHERE EncounterID = @newID
	
	-- If the source & destination pointers are NOT NULL , do the copy
	IF COALESCE( @src_textptr , @dest_textptr ) IS NOT NULL
	        UPDATETEXT Encounter.Notes @dest_textptr NULL NULL HandheldEncounter.Notes @src_textptr

  -- COPY THE Notes field -- END

	DECLARE @id int

	-- we can use EncounterDataProvider_GetEncounterDiagnosesFromPatient @PatientID   here to get default diagnoses if we need to merge them in
 
  -- COPY THE Diagnoses -- START
/*
	CREATE TABLE #t_EncounterDiagnosis (
		EncounterDiagnosisID int, 
		DiagnosisCodeDictionaryID int,
		DiagnosisCode varchar (16),
		DiagnosisName varchar (300),
		ListSequence int
	)

	INSERT INTO #t_EncounterDiagnosis
	EXECUTE EncounterDataProvider_GetMobileEncounterDiagnoses @mobileEncounterId

	DECLARE enc_cursor CURSOR READ_ONLY
	FOR 	SELECT DiagnosisCodeDictionaryID FROM #t_EncounterDiagnosis

	DECLARE @Diagnosis1 INT
	DECLARE @Diagnosis2 INT
	DECLARE @Diagnosis3 INT
	DECLARE @Diagnosis4 INT

	OPEN enc_cursor
	
	FETCH NEXT FROM enc_cursor INTO @id
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			EXEC EncounterDataProvider_CreateEncounterDiagnosis @newID, @id, 1

			-- Update the encounter diagnosis id link with the newly created id
			IF @Diagnosis1 IS NULL
				SET @Diagnosis1 = @id
			ELSE IF @Diagnosis2 IS NULL
				SET @Diagnosis2 = @id
			ELSE IF @Diagnosis3 IS NULL
				SET @Diagnosis3 = @id
			ELSE IF @Diagnosis4 IS NULL
				SET @Diagnosis4 = @id
		END
		FETCH NEXT FROM enc_cursor INTO @id
	END
	
	CLOSE enc_cursor
	DEALLOCATE enc_cursor

  -- COPY THE Diagnoses -- END
*/

  -- COPY THE Procedures -- START

	CREATE TABLE #t_EncounterProcedure (
		EncounterProcedureID int,
		ProcedureCodeDictionaryID int,
		ProcedureCode varchar (16),
		ProcedureName varchar (300),
		
		ServiceUnitCount Decimal(19,4) default 1,
		ServiceChargeAmount money default 0,

		DiagnosisCodeDictionaryID1 int null,
		DiagnosisCodeDictionaryID2 int null,
		DiagnosisCodeDictionaryID3 int null,
		DiagnosisCodeDictionaryID4 int null,
		DiagnosisCode1 varchar(32), DiagnosisDescription1 varchar(128),
		DiagnosisCode2 varchar(32), DiagnosisDescription2 varchar(128),
		DiagnosisCode3 varchar(32), DiagnosisDescription3 varchar(128),
		DiagnosisCode4 varchar(32), DiagnosisDescription4 varchar(128),

		ModifierCode1 varchar(16), ModifierDescription1 varchar(250),
		ModifierCode2 varchar(16), ModifierDescription2 varchar(250),
		ModifierCode3 varchar(16), ModifierDescription3 varchar(250),
		ModifierCode4 varchar(16), ModifierDescription4 varchar(250),

		ListSequence int
	)

	CREATE TABLE #FeeInfo (
		ContractFeeScheduleID int, 
		CreatedDate DateTime,
		CreatedUserID int,
		ModifiedDate DateTime,
		ModifiedUserID int,
		ContractID int,
		Modifier varchar(16),
		Gender char(1),
		StandardFee money,
		Allowable money,
		ExpectedReimbursement money,
		RVU decimal(18,0),
		ProcedureCodeDictionary int,
		DiagnosisCodeDictionary int,
		AnesthesiaTimeIncrement int) 

	DECLARE 
		@DiagnosisCodeDictionaryID1 int,
		@DiagnosisCodeDictionaryID2 int,
		@DiagnosisCodeDictionaryID3 int,
		@DiagnosisCodeDictionaryID4 int,
		@Modifier_1 varchar(16),
		@Modifier_2 varchar(16),
		@Modifier_3 varchar(16),
		@Modifier_4 varchar(16),

		@ProcedureFeeAmt money,
		@Units decimal(19, 4)
		

	INSERT INTO #t_EncounterProcedure
	EXECUTE EncounterDataProvider_GetMobileEncounterProcedures @mobileEncounterId

	DECLARE prc_cursor CURSOR READ_ONLY
	FOR SELECT ProcedureCodeDictionaryID, 
		DiagnosisCodeDictionaryID1, DiagnosisCodeDictionaryID2, 
		DiagnosisCodeDictionaryID3, DiagnosisCodeDictionaryID4,
		ModifierCode1, ModifierCode2, ModifierCode3, ModifierCode4,
		ServiceUnitCount, ServiceChargeAmount
	FROM #t_EncounterProcedure

	OPEN prc_cursor
	
	FETCH NEXT FROM prc_cursor INTO @id, 
		@DiagnosisCodeDictionaryID1, @DiagnosisCodeDictionaryID2,
		@DiagnosisCodeDictionaryID3, @DiagnosisCodeDictionaryID4,
		@Modifier_1, @Modifier_2, @Modifier_3, @Modifier_4, 
		@Units, @ProcedureFeeAmt

	WHILE @@fetch_status = 0
	BEGIN
		-- calculate procedure fee
		--SET @ProcedureFeeAmt=0
		DELETE #FeeInfo
		INSERT INTO #FeeInfo
			EXECUTE PracticeDataProvider_GetContractFeesInfoForCase @caseID, @dateOfService, @locationID, @id, @Modifier_1, @DiagnosisCodeDictionaryID1, @doctorID
		
		-- if mobile encounter didn't contain Fee amount - let's try to get it from the fee schedule
		if @ProcedureFeeAmt=0
			SELECT @ProcedureFeeAmt=StandardFee from #FeeInfo

		EXEC EncounterDataProvider_CreateEncounterProcedure @encounter_id = @newID, @procedure_dictionary_id = @id, 
				@location_id = @locationID, @procedure_service_date = @dateOfService, 
				@diagnosis_id_1=@DiagnosisCodeDictionaryID1, @diagnosis_id_2=@DiagnosisCodeDictionaryID2, 
				@diagnosis_id_3=@DiagnosisCodeDictionaryID3, @diagnosis_id_4=@DiagnosisCodeDictionaryID4,
				@Modifier_1=@Modifier_1, @Modifier_2=@Modifier_2,
				@Modifier_3=@Modifier_3, @Modifier_4=@Modifier_4,
				@service_charge_amount=@ProcedureFeeAmt, @unit_count=@Units

		FETCH NEXT FROM prc_cursor INTO @id, 
			@DiagnosisCodeDictionaryID1, @DiagnosisCodeDictionaryID2,
			@DiagnosisCodeDictionaryID3, @DiagnosisCodeDictionaryID4,
			@Modifier_1, @Modifier_2, @Modifier_3, @Modifier_4,
			@Units, @ProcedureFeeAmt

	END
	
	CLOSE prc_cursor
	DEALLOCATE prc_cursor

  -- COPY THE Procedures -- END


	RETURN @newID
END

GO


--===========================================================================
--
-- MOBILE ENCOUNTER DATA PROVIDER
--
--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'EncounterDataProvider_GetMobileEncounterProcedures'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.EncounterDataProvider_GetMobileEncounterProcedures
GO

--===========================================================================
-- GET MOBILE ENCOUNTER PROCEDURES
--===========================================================================
CREATE PROCEDURE dbo.EncounterDataProvider_GetMobileEncounterProcedures
	@encounter_id INT
AS
BEGIN
	CREATE TABLE #t_EncounterProcedure (
		EncounterProcedureID int IDENTITY (1, 1) NOT NULL,
		ProcedureCodeDictionaryID int NOT NULL,
		ProcedureCode varchar (16),
		ProcedureName varchar (300),

		ServiceUnitCount DECIMAL(19,4) default 1,
		ServiceChargeAmount money default 0,

		DiagnosisCodeDictionaryID1 int null,
		DiagnosisCodeDictionaryID2 int null,
		DiagnosisCodeDictionaryID3 int null,
		DiagnosisCodeDictionaryID4 int null,
		
		DiagnosisCode1 varchar(32), DiagnosisDescription1 varchar(128),
		DiagnosisCode2 varchar(32), DiagnosisDescription2 varchar(128),
		DiagnosisCode3 varchar(32), DiagnosisDescription3 varchar(128),
		DiagnosisCode4 varchar(32), DiagnosisDescription4 varchar(128),

		ModifierCode1 varchar(16), ModifierDescription1 varchar (250),
		ModifierCode2 varchar(16), ModifierDescription2 varchar (250),
		ModifierCode3 varchar(16), ModifierDescription3 varchar (250),
		ModifierCode4 varchar(16), ModifierDescription4 varchar (250),

		ListSequence int NOT NULL DEFAULT (1)
	)

	insert into #t_EncounterProcedure(ProcedureCodeDictionaryID, ProcedureCode, ProcedureName, 
		DiagnosisCodeDictionaryID1, DiagnosisCodeDictionaryID2, 
		DiagnosisCodeDictionaryID3, DiagnosisCodeDictionaryID4,
		DiagnosisCode1, DiagnosisDescription1,
		DiagnosisCode2, DiagnosisDescription2,
		DiagnosisCode3, DiagnosisDescription3,
		DiagnosisCode4, DiagnosisDescription4,
		ModifierCode1, ModifierDescription1,
		ModifierCode2, ModifierDescription2,
		ModifierCode3, ModifierDescription3,
		ModifierCode4, ModifierDescription4,
		ServiceUnitCount, ServiceChargeAmount
)
	select CD.ProcedureCodeDictionaryID, CD.ProcedureCode, IsNull(CD.LocalName, CD.OfficialName), 
		HED.DiagnosisCodeDictionaryID1, HED.DiagnosisCodeDictionaryID2,
		HED.DiagnosisCodeDictionaryID3, HED.DiagnosisCodeDictionaryID4,
		DD1.DiagnosisCode, IsNull(DD1.LocalName, DD1.OfficialName),
		DD2.DiagnosisCode, IsNull(DD2.LocalName, DD2.OfficialName),
		DD3.DiagnosisCode, IsNull(DD3.LocalName, DD3.OfficialName),
		DD4.DiagnosisCode, IsNull(DD4.LocalName, DD4.OfficialName),

		PM1.ProcedureModifierCode, PM1.ModifierName,
		PM2.ProcedureModifierCode, PM2.ModifierName,
		PM3.ProcedureModifierCode, PM3.ModifierName,
		PM4.ProcedureModifierCode, PM4.ModifierName,

		Units, ServiceChargeAmount
		
		from HandheldEncounterDetail HED
	left join ProcedureCodeDictionary CD on HED.ProcedureCodeDictionaryID=CD.ProcedureCodeDictionaryID
	left join DiagnosisCodeDictionary DD1 on HED.DiagnosisCodeDictionaryID1=DD1.DiagnosisCodeDictionaryID
	left join DiagnosisCodeDictionary DD2 on HED.DiagnosisCodeDictionaryID2=DD2.DiagnosisCodeDictionaryID
	left join DiagnosisCodeDictionary DD3 on HED.DiagnosisCodeDictionaryID3=DD3.DiagnosisCodeDictionaryID
	left join DiagnosisCodeDictionary DD4 on HED.DiagnosisCodeDictionaryID4=DD4.DiagnosisCodeDictionaryID

	left join ProcedureModifier PM1 on HED.Modifier1=PM1.ProcedureModifierCode
	left join ProcedureModifier PM2 on HED.Modifier2=PM2.ProcedureModifierCode
	left join ProcedureModifier PM3 on HED.Modifier3=PM3.ProcedureModifierCode
	left join ProcedureModifier PM4 on HED.Modifier4=PM4.ProcedureModifierCode

	where HandheldEncounterID=@encounter_id

select * from #t_EncounterProcedure

END
 
GO

