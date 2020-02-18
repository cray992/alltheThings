--===========================================================================
-- MOD: CLAIM SCHEMA
--===========================================================================

--Copy Claims.
SELECT	*
INTO 	TEMP_Claim
FROM	Claim

--Copy Claim Transactions.
SELECT 	*
INTO	TEMP_ClaimTransaction
FROM	ClaimTransaction

--Copy BillClaims.
SELECT	*
INTO 	TEMP_BillClaim
FROM	BillClaim

--===========================================================================

DROP TABLE dbo.BillClaim

DROP TABLE dbo.ClaimTransaction

DROP TABLE dbo.Claim

--===========================================================================

CREATE TABLE dbo.Claim (
	ClaimID INT IDENTITY(1,1) NOT NULL,
	PracticeID INT NOT NULL,

	ClaimStatusCode CHAR(1) NOT NULL,
	AssignmentIndicator CHAR(1),

	PatientID INT,
	FacilityID INT,
	RenderingProviderID INT,
	ReferringProviderID INT,
	AuthorizationID INT,
	EncounterID INT,
	DiagnosisCode1 VARCHAR(30),
	DiagnosisCode2 VARCHAR(30),
	DiagnosisCode3 VARCHAR(30),
	DiagnosisCode4 VARCHAR(30),
	DiagnosisCode5 VARCHAR(30),
	DiagnosisCode6 VARCHAR(30),
	DiagnosisCode7 VARCHAR(30),
	DiagnosisCode8 VARCHAR(30),
	OrderDate DATETIME,
	InitialTreatmentDate DATETIME,
	ReferralDate DATETIME,
	LastSeenDate DATETIME,
	CurrentIllnessDate DATETIME,
	AcuteManifestationDate DATETIME,
	SimilarIllnessDate DATETIME,
	LastMenstrualDate DATETIME,
	LastXrayDate DATETIME,
	EstimatedBirthDate DATETIME,
	HearingVisionPrescriptionDate DATETIME,
	DisabilityBeginDate DATETIME,
	DisabilityEndDate DATETIME,
	LastWorkedDate DATETIME,
	ReturnToWorkDate DATETIME,
	HospitalizationBeginDate DATETIME,
	HospitalizationEndDate DATETIME,
	ProviderSignatureOnFileFlag BIT,
	MedicareAssignmentCode CHAR(1),
	AssignmentOfBenefitsFlag BIT,
	ReleaseOfInformationCode CHAR(1),
	ReleaseSignatureSourceCode CHAR(1),
	AutoAccidentRelatedFlag BIT,
	AutoAccidentRelatedState CHAR(2),
	AbuseRelatedFlag BIT,
	EmploymentRelatedFlag BIT,
	OtherAccidentRelatedFlag BIT,
	SpecialProgramCode VARCHAR(3),
	PropertyCasualtyClaimNumber VARCHAR(30),
	ServiceAuthorizationExceptionCode VARCHAR(30),
	MammographyCertificationNumber VARCHAR(30),
	CLIANumber VARCHAR(30),
	APGNumber VARCHAR(30),
	IDENumber VARCHAR(30),
	AmbulanceTransportFlag BIT NOT NULL,
	AmbulanceCode CHAR(1),
	AmbulanceReasonCode CHAR(1),
	AmbulanceDistance DECIMAL(10,4),
	AmbulanceCertificationCode1 CHAR(2),
	AmbulanceCertificationCode2 CHAR(2),
	AmbulanceCertificationCode3 CHAR(2),
	AmbulanceCertificationCode4 CHAR(2),
	AmbulanceCertificationCode5 CHAR(2),
	SpineTreatmentFlag BIT NOT NULL,
	SpineTreatmentNumber INT,
	SpineTreatmentCount INT,
	SpineSubluxationLevelCode VARCHAR(3),
	SpineSubluxationLevelEndCode VARCHAR(3),
	SpineTreatmentPeriodCount INT,
	SpineTreatmentMonthlyCount INT,
	SpinePatientConditionCode CHAR(1),
	SpineComplicationFlag BIT,
	SpineXrayAvailableFlag BIT,
	VisionReplacementFlag BIT NOT NULL,
	VisionReplacementTypeCode CHAR(2),
	VisionReplacementConditionCode CHAR(2),
	PatientPaidAmount MONEY,
	PlaceOfServiceCode CHAR(2),

	EncounterProcedureID INT,
	ProcedureCode VARCHAR(48),
	TypeOfServiceCode VARCHAR(2),
	ServiceBeginDate DATETIME,
	ServiceEndDate DATETIME,
	ServiceChargeAmount MONEY,
	ServiceUnitCount DECIMAL(6,4),
	ProcedureModifier1 CHAR(2),
	ProcedureModifier2 CHAR(2),
	ProcedureModifier3 CHAR(2),
	ProcedureModifier4 CHAR(2),
	DiagnosisPointer1 INT,
	DiagnosisPointer2 INT,
	DiagnosisPointer3 INT,
	DiagnosisPointer4 INT,

	CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()),

	TIMESTAMP
)

ALTER TABLE dbo.Claim
ADD CONSTRAINT PK_Claim
PRIMARY KEY (ClaimID)

ALTER TABLE dbo.Claim
ADD CONSTRAINT FK_Claim_ClaimStatus
FOREIGN KEY (ClaimStatusCode)
REFERENCES ClaimStatus(ClaimStatusCode)

ALTER TABLE dbo.Claim
ADD CONSTRAINT CK_Claim_AssignmentIndicator
CHECK (AssignmentIndicator IN ('P','1','2','3','4','5','6','7','8','9'))

ALTER TABLE dbo.Claim
ADD CONSTRAINT DF_Claim_AmbulanceTransportFlag
DEFAULT (0) FOR AmbulanceTransportFlag

ALTER TABLE dbo.Claim
ADD CONSTRAINT DF_Claim_SpineTreatmentFlag 
DEFAULT (0) FOR SpineTreatmentFlag

ALTER TABLE dbo.Claim
ADD CONSTRAINT DF_Claim_VisionReplacementFlag
DEFAULT (0) FOR VisionReplacementFlag

--===========================================================================

CREATE TABLE dbo.ClaimPayer (
	ClaimPayerID INT IDENTITY(1,1) NOT NULL,
	ClaimID INT NOT NULL,
	Precedence INT NOT NULL,

	PatientInsuranceID INT,

	CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()),

	TIMESTAMP
)

ALTER TABLE dbo.ClaimPayer
ADD CONSTRAINT PK_ClaimPayer
PRIMARY KEY (ClaimPayerID)

ALTER TABLE dbo.ClaimPayer
ADD CONSTRAINT FK_ClaimPayer_Claim
FOREIGN KEY (ClaimID)
REFERENCES Claim(ClaimID)

--===========================================================================

CREATE TABLE dbo.ClaimTransaction (
	ClaimTransactionID INT IDENTITY(1,1) NOT NULL,
	ClaimTransactionTypeCode CHAR(3) NOT NULL,
	ClaimID INT NOT NULL,
	TransactionDate DATETIME,
	ReferenceDate DATETIME,
	Amount MONEY,
	Quantity INT,
	Code VARCHAR(50),
	ReferenceID INT,
	ReferenceData VARCHAR(250),
	Notes TEXT,

	CreatedDate DATETIME NOT NULL DEFAULT (GETDATE()),
	ModifiedDate DATETIME NOT NULL DEFAULT (GETDATE()),

	TIMESTAMP
)

ALTER TABLE dbo.ClaimTransaction
ADD CONSTRAINT PK_ClaimTransaction
PRIMARY KEY (ClaimTransactionID)

ALTER TABLE dbo.ClaimTransaction
ADD CONSTRAINT FK_ClaimTransaction_ClaimTransactionType
FOREIGN KEY (ClaimTransactionTypeCode)
REFERENCES ClaimTransactionType(ClaimTransactionTypeCode)

ALTER TABLE dbo.ClaimTransaction
ADD CONSTRAINT FK_ClaimTransaction_Claim
FOREIGN KEY (ClaimID)
REFERENCES Claim(ClaimID)

--===========================================================================

CREATE TABLE dbo.BillClaim (
	BillID INT NOT NULL,
	ClaimID INT NOT NULL,

	TIMESTAMP
)

ALTER TABLE dbo.BillClaim
ADD CONSTRAINT PK_BillClaim
PRIMARY KEY (BillID, ClaimID)

ALTER TABLE dbo.BillClaim
ADD CONSTRAINT FK_BillClaim_Claim
FOREIGN KEY (ClaimID)
REFERENCES Claim(ClaimID)


--===========================================================================
-- ADD: NEW BUSINESS RULE FUNCTIONS
--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_EncounterDiagnosisCode'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_EncounterDiagnosisCode
GO

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

--===========================================================================

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'BusinessRule_EncounterDiagnosisIndex'
	AND	TYPE = 'FN'
)
	DROP FUNCTION dbo.BusinessRule_EncounterDiagnosisIndex
GO

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

--===========================================================================
-- POP: NEW CLAIM SCHEMA
--===========================================================================

DECLARE @claim_id INT
DECLARE claim_cursor CURSOR READ_ONLY
FOR 	
	SELECT	ClaimID
	FROM	TEMP_Claim

OPEN claim_cursor

FETCH NEXT FROM claim_cursor
INTO	@claim_id
WHILE (@@FETCH_STATUS <> -1)
BEGIN
	IF (@@FETCH_STATUS <> -2)
	BEGIN
		--Create new version of the claim.
		DECLARE @new_claim_id INT

		INSERT	Claim (
			PracticeID,
			ClaimStatusCode,
			AssignmentIndicator,
			PatientID,
			FacilityID,
			RenderingProviderID,
			ReferringProviderID,
			AuthorizationID,
			EncounterID,
			DiagnosisCode1,
			DiagnosisCode2,
			DiagnosisCode3,
			DiagnosisCode4,
			DiagnosisCode5,
			DiagnosisCode6,
			DiagnosisCode7,
			DiagnosisCode8,
			CurrentIllnessDate,
			SimilarIllnessDate,
			InitialTreatmentDate,
			LastWorkedDate,
			ReturnToWorkDate,
			DisabilityBeginDate,
			DisabilityEndDate,
			HospitalizationBeginDate,
			HospitalizationEndDate,
			ReferralDate,
			LastSeenDate,
			LastXrayDate,
			AcuteManifestationDate,
			ProviderSignatureOnFileFlag,
			MedicareAssignmentCode,
			AssignmentOfBenefitsFlag,
			ReleaseOfInformationCode,
			ReleaseSignatureSourceCode,
			AutoAccidentRelatedFlag,
			AutoAccidentRelatedState,
			AbuseRelatedFlag,
			EmploymentRelatedFlag,
			OtherAccidentRelatedFlag,
			SpecialProgramCode,
			PropertyCasualtyClaimNumber,
			PatientPaidAmount,
			PlaceOfServiceCode,
			EncounterProcedureID,
			ProcedureCode,
			TypeOfServiceCode,
			ServiceBeginDate,
			ServiceEndDate,
			ServiceChargeAmount,
			ServiceUnitCount,
			ProcedureModifier1,
			ProcedureModifier2,
			ProcedureModifier3,
			ProcedureModifier4,
			DiagnosisPointer1,
			DiagnosisPointer2,
			DiagnosisPointer3,
			DiagnosisPointer4,
			CreatedDate,
			ModifiedDate)
		SELECT 	E.PracticeID,
			C.ClaimStatusCode,
			C.AssignmentIndicator,
			E.PatientID,
			E.LocationID,
			E.DoctorID,
			(CASE WHEN E.ReferringPhysicianID > 0 
				THEN E.ReferringPhysicianID
				ELSE NULL
				END),
			(CASE WHEN E.PatientAuthorizationID > 0
				THEN E.PatientAuthorizationID
				ELSE NULL
				END),
			E.EncounterID,
			dbo.BusinessRule_EncounterDiagnosisCode(E.EncounterID, 1),
			dbo.BusinessRule_EncounterDiagnosisCode(E.EncounterID, 2),
			dbo.BusinessRule_EncounterDiagnosisCode(E.EncounterID, 3),
			dbo.BusinessRule_EncounterDiagnosisCode(E.EncounterID, 4),
			dbo.BusinessRule_EncounterDiagnosisCode(E.EncounterID, 5),
			dbo.BusinessRule_EncounterDiagnosisCode(E.EncounterID, 6),
			dbo.BusinessRule_EncounterDiagnosisCode(E.EncounterID, 7),
			dbo.BusinessRule_EncounterDiagnosisCode(E.EncounterID, 8),
			E.DateOfInjury,
			E.SimilarIllnessDate,
			E.InitialTreatmentDate,
			E.LastWorkedDate,
			E.ReturnToWorkDate,
			E.DisabilityBeginDate,
			E.DisabilityEndDate,
			E.HospitalizationBeginDate,
			E.HospitalizationEndDate,
			NULL,
			NULL,
			NULL,
			NULL,
			CAST(DoctorSignature AS BIT),
			E.MedicareAssignmentCode,
			E.AssignmentOfBenefitsFlag,
			E.ReleaseOfInformationCode,
			E.ReleaseSignatureSourceCode,
			E.AutoAccidentRelatedFlag,
			E.AutoAccidentRelatedState,
			E.AbuseRelatedFlag,
			E.EmploymentRelatedFlag,
			E.OtherAccidentRelatedFlag,
			NULL,
			NULL,
			E.AmountPaid,
			E.PlaceOfServiceCode,
			EP.EncounterProcedureID,
			PCD.ProcedureCode,
			PCD.TypeOfServiceCode,
			E.DateOfService,
			NULL,
			EP.ServiceChargeAmount,
			EP.ServiceUnitCount,
			EP.ProcedureModifier1,
			EP.ProcedureModifier2,
			EP.ProcedureModifier3,
			EP.ProcedureModifier4,
			dbo.BusinessRule_EncounterDiagnosisIndex(
				E.EncounterID, EP.DiagnosisID1),
			dbo.BusinessRule_EncounterDiagnosisIndex(
				E.EncounterID, EP.DiagnosisID2),
			dbo.BusinessRule_EncounterDiagnosisIndex(
				E.EncounterID, EP.DiagnosisID3),
			dbo.BusinessRule_EncounterDiagnosisIndex(
				E.EncounterID, EP.DiagnosisID4),
			C.CreatedDate,
			C.ModifiedDate
		FROM	TEMP_Claim C
			INNER JOIN EncounterProcedure EP
			ON EP.EncounterProcedureID = C.EncounterProcedureID
			INNER JOIN Encounter E
			ON E.EncounterID = EP.EncounterID
			INNER JOIN ProcedureCodeDictionary PCD
			ON PCD.ProcedureCodeDictionaryID = EP.ProcedureCodeDictionaryID
		WHERE	C.ClaimID = @claim_id

		SET @new_claim_id = SCOPE_IDENTITY()

		--Create the payer records.
		INSERT	ClaimPayer (
			ClaimID,
			Precedence,
			PatientInsuranceID)
		SELECT	@new_claim_id,
			EPI.Precedence,
			EPI.PatientInsuranceID
		FROM	EncounterToPatientInsurance EPI
		WHERE	EPI.EncounterID = (
			SELECT	C.EncounterID
			FROM	Claim C
			WHERE	C.ClaimID = @new_claim_id)

		--Create redirected transactions.
		INSERT	ClaimTransaction (
			ClaimTransactionTypeCode,
			ClaimID,
			TransactionDate,
			ReferenceDate,
			Amount,
			Quantity,
			Code,
			ReferenceID,
			ReferenceData,
			Notes,
			CreatedDate,
			ModifiedDate)
		SELECT	ClaimTransactionTypeCode,
			@new_claim_id,
			TransactionDate,
			ReferenceDate,
			Amount,
			Quantity,
			Code,
			ReferenceID,
			NULL,
			Notes,
			CreatedDate,
			ModifiedDate
		FROM	TEMP_ClaimTransaction
		WHERE	ClaimID = @claim_id
		AND	ClaimTransactionTypeCode NOT IN ('ADJ', 'END')
		UNION ALL
		SELECT	ClaimTransactionTypeCode,
			@new_claim_id,
			TransactionDate,
			ReferenceDate,
			Amount,
			Quantity,
			'01',
			ReferenceID,
			Code,
			Notes,
			CreatedDate,
			ModifiedDate
		FROM	TEMP_ClaimTransaction
		WHERE	ClaimID = @claim_id
		AND	ClaimTransactionTypeCode IN ('ADJ','END')

		--Create redirected bills.
		INSERT	BillClaim (
			BillID,
			ClaimID)
		SELECT	BillID,
			@new_claim_id
		FROM	TEMP_BillClaim
		WHERE	ClaimID = @claim_id
	END

	FETCH NEXT FROM claim_cursor
	INTO	@claim_id
END

CLOSE claim_cursor
DEALLOCATE claim_cursor

