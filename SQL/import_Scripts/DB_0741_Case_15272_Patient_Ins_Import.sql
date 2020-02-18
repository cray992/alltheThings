-- DB 0741
-- Practice : Full Solution Services
-- FogBugz Case ID : 15272

-- Tables inserted to:
-- Patient
-- PatientCase
-- InsuranceCompany
-- InsuranceCompanyPlan
-- InsurancePolicy

DECLARE @VendorImportID int
DECLARE @PracticeID int
DECLARE @Rows Int
DECLARE @Message Varchar(75)

INSERT INTO VendorImport (VendorName, VendorFormat, DateCreated, Notes)
VALUES ('Chuck Bagby', 'parsed', GETDATE(), 'None')

SET @VendorImportID = SCOPE_IDENTITY()

SELECT @PracticeID = PracticeID
FROM dbo.Practice
WHERE (Name = 'Test Flatirons2')


INSERT INTO Patient (
	PracticeID, 
	ReferringPhysicianID, 
	Prefix, 
	FirstName, 
	MiddleName, 
	LastName, 
	Suffix, 
	AddressLine1, 
	AddressLine2, 
	City, 
	State, 
	Country, 
	ZipCode,
	Gender, 
	MaritalStatus, 
	HomePhone,  
	HomePhoneExt, 
	WorkPhone,  
	WorkPhoneExt,
	DOB, 
	SSN, 
	ResponsibleDifferentThanPatient, 
	CreatedDate, 
	ModifiedDate,
	EmploymentStatus, 
	MedicalRecordNumber, 
	VendorID, 
	VendorImportID)

SELECT 
	@PracticeID as PracticeID,
	NULL, -- Ref Phys
	'', -- Prefix
	LTrim(RTrim(ISNULL(FirstName, ''))),
	'', --LTrim(RTrim(ISNULL(MI, ''))),
	LTrim(RTrim(ISNULL(LastName, ''))),
	'', -- Suffix
	LTrim(RTrim(AddressLine1)),
	LTrim(RTrim(AddressLine2)), -- Addr 2
	LTrim(RTrim(City)),
	LTrim(RTrim(State)),
	NULL, -- country
	Left(ZipCode, 5),	-- ZIP
	'U',  --LTrim(RTrim(ISNULL(Sex, ''))), --Gender
	'U',	-- marital status
	LEFT(REPLACE(REPLACE(REPLACE(Phone, '(', ''), ')', ''), '-', ''), 10),	--	Phone,
	NULL, -- home phone ext
	LEFT(REPLACE(REPLACE(REPLACE(Fax, '(', ''), ')', ''), '-', ''), 10),	--NULL, --WorkPhone,  
	NULL, --WorkPhoneExt,
	DOB,
	NULL, --Left(SSN, 9),
	0,    --ResponsibleDifferentThanPatient
	GetDate(),	-- created date
	GetDate(),	-- Modified date
	'U',		--EmploymentStatus
	NULL,  --AccountNo,	--MedicalRecordNumber
	NULL,  --[ID],		--VendorID
	@VendorImportID			--VendorImportID

FROM dbo.Imp_741_Patients_15272_2 
INNER JOIN (SELECT LastName AS LastName2, FirstName AS FirstName2, MIN(PatientID) AS PatientID
	FROM dbo.Imp_741_Patients_15272_2 AS Imp_741_Patients_15272_2_1
	GROUP BY LastName, FirstName) AS derivedtbl_1 
	ON dbo.Imp_741_Patients_15272_2.PatientID = derivedtbl_1.PatientID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in Patient Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [Imp_741_Patients_15272_2]
Select @Message = 'Rows in original Imp_741_Patients_15272_2 Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

-- for each patient create one default case
INSERT INTO PatientCase (
	PatientID, 
	[Name], 
	Active, 
	PayerScenarioID, 
	ReferringPhysicianID, 
	EmploymentRelatedFlag, 
	AutoAccidentRelatedFlag, 
	OtherAccidentRelatedFlag, 
	AbuseRelatedFlag, 
	AutoAccidentRelatedState, 
	Notes, 
	ShowExpiredInsurancePolicies, 
	CreatedDate, 
	ModifiedDate, 
	PracticeID, 
	CaseNumber, 
	WorkersCompContactInfoID, 
	VendorID, 
	VendorImportID, 
	PregnancyRelatedFlag, 
	StatementActive, 
	EPSDT, 
	FamilyPlanning
)

SELECT DISTINCT
PatientID, 
'Default Case', 
1, 
5, 
null,
0, 
0, 
0, 
0, 
null,
'Autocreated during data import', 
1, 
GetDate(), 
GetDate(), 
@PracticeID, 
null, 
null, 
null, 
@VendorImportID, 
0, 
1, 
0, 
0
FROM Patient 
WHERE Patient.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in PatientCase Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [Patient] WHERE Patient.VendorImportID = @VendorImportID
Select @Message = 'Rows in original Patient Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--************************************* InsuranceCompany

INSERT INTO InsuranceCompany 
(
	InsuranceCompanyName, 
	Notes, 
	AddressLine1, 
	AddressLine2, 
	City, State,
	Country, 
	ZipCode, 
	ContactPrefix, 
	ContactFirstName, 
	ContactMiddleName, 
	ContactLastName, 
	ContactSuffix, 
	Phone, 
	PhoneExt, 
	Fax, 
	FaxExt, 
	BillSecondaryInsurance, 
	EClaimsAccepts, 
	BillingFormID, 
	InsuranceProgramCode, 
	HCFADiagnosisReferenceFormatCode, 
	HCFASameAsInsuredFormatCode, 
	LocalUseFieldTypeCode, 
	ReviewCode, 
	ProviderNumberTypeID, 
	GroupNumberTypeID, 
	LocalUseProviderNumberTypeID, 
	CompanyTextID, 
	ClearinghousePayerID, 
	CreatedPracticeID, 
	CreatedDate, 
	CreatedUserID, 
	ModifiedDate, 
	ModifiedUserID, 
	KareoInsuranceCompanyID, 
	KareoLastModifiedDate, 
	RecordTimeStamp, 
	SecondaryPrecedenceBillingFormID, 
	VendorID, 
	VendorImportID, 
	DefaultAdjustmentCode, 
	ReferringProviderNumberTypeID, 
	NDCFormat
)

SELECT DISTINCT
	InsuranceComapnyName,	--	InsuranceCompanyName, 
	NULL,			--	Notes, 
	AddressLine1,	--	AddressLine1, 
	AddressLine2,	--	AddressLine2, 
	City,			--	City, 
	State,			--  State,
	NULL,			--	Country, 
	LEFT(REPLACE(REPLACE(REPLACE(ZipCode, '(', ''), ')', ''), '-', ''), 9),	--ZipCode, 
	NULL,			--	ContactPrefix, 
	NULL,			--	ContactFirstName, 
	NULL,			--	ContactMiddleName, 
	NULL,			--	ContactLastName, 
	NULL,			--	ContactSuffix, 
	LEFT(REPLACE(REPLACE(REPLACE(Phone, '(', ''), ')', ''), '-', ''), 10),	--	Phone, 
	NULL,			--	PhoneExt, 
	LEFT(REPLACE(REPLACE(REPLACE(Fax, '(', ''), ')', ''), '-', ''), 10),	--	Fax, 
	NULL,			--	FaxExt, 
	0,			--	BillSecondaryInsurance, 
	0,			--	EClaimsAccepts, 
	1,			--	BillingFormID, 
	'CI',			--	InsuranceProgramCode, 
	'C',			--	HCFADiagnosisReferenceFormatCode, 
	'D',			--	HCFASameAsInsuredFormatCode, 
	NULL,			--	LocalUseFieldTypeCode, 
	' ',			--	ReviewCode, 
	NULL,			--	ProviderNumberTypeID, 
	NULL,			--	GroupNumberTypeID, 
	NULL,			--	LocalUseProviderNumberTypeID, 
	NULL,			--	CompanyTextID, 
	NULL,			--	ClearinghousePayerID, 
	@PracticeID,			--	CreatedPracticeID, 
	GETDATE(),		--	CreatedDate, 
	0,				--	CreatedUserID, 
	GETDATE(),		--	ModifiedDate, 
	0,				--	ModifiedUserID, 
	NULL,			--	KareoInsuranceCompanyID, 
	NULL,			--	KareoLastModifiedDate, 
	NULL,			--	RecordTimeStamp, 
	1,			--	SecondaryPrecedenceBillingFormID, 
	1,			--	VendorID, 
	@VendorImportID,			--	VendorImportID, 
	NULL,			--	DefaultAdjustmentCode, 
	NULL,			--	ReferringProviderNumberTypeID, 
	1				--	NDCFormat
FROM dbo.Imp_741_Insurance_15272_2


Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsuranceCompany Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [Imp_741_Insurance_15272_2]
Select @Message = 'Rows in original Imp_741_Insurance_15272_2 Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


--************************** InsuranceCompanyPlan

INSERT INTO InsuranceCompanyPlan
(
	PlanName, 
	AddressLine1, 
	AddressLine2, 
	City, 
	State, 
	Country, 
	ZipCode, 
	ContactPrefix, 
	ContactFirstName, 
	ContactMiddleName, 
	ContactLastName, 
	ContactSuffix, 
	Phone, 
	PhoneExt, 
	Notes, 
	MM_CompanyID, 
	CreatedDate, 
	CreatedUserID, 
	ModifiedDate, 
	ModifiedUserID, 
--	RecordTimeStamp, 
	ReviewCode, 
	CreatedPracticeID, 
	Fax, 
	FaxExt, 
	KareoInsuranceCompanyPlanID, 
	KareoLastModifiedDate, 
	InsuranceCompanyID, 
	ADS_CompanyID, 
	Copay, 
	Deductible, 
	VendorID, 
	VendorImportID
)
SELECT DISTINCT
	InsuranceCompanyName,				-- PlanName, 
	AddressLine1,			-- AddressLine1, 
	AddressLine2,			-- AddressLine2, 
	City,				-- City, 
	State,			-- State, 
	NULL,											-- Country, 
	ZipCode,				-- ZipCode, 
	NULL,											-- ContactPrefix, 
	NULL,	-- ContactFirstName, 
	NULL,											-- ContactMiddleName, 
	NULL, -- ContactLastName, 
	NULL,											-- ContactSuffix, 
	NULL, -- Phone, 
	NULL,											-- PhoneExt, 
	NULL,											-- Notes, 
	NULL,											-- MM_CompanyID, 
	GETDATE(),										-- CreatedDate, 
	0,												-- CreatedUserID, 
	GETDATE(),										-- ModifiedDate, 
	0,												-- ModifiedUserID, 
-- RecordTimeStamp, 
	'',												-- ReviewCode, 
	@PracticeID,									-- CreatedPracticeID, 
	LEFT(REPLACE(REPLACE(REPLACE(Fax, '(', ''), ')', ''), '-', ''), 10), -- Fax, 
	NULL,											-- FaxExt, 
	NULL,											-- KareoInsuranceCompanyPlanID, 
	NULL,											-- KareoLastModifiedDate, 
	InsuranceCompanyID,		-- InsuranceCompanyID, 
	NULL,											-- ADS_CompanyID, 
	0,		-- Copay, 
	0,	-- Deductible, 
	0,			-- VendorID, 
	@VendorImportID									-- VendorImportID

FROM dbo.InsuranceCompany
WHERE dbo.InsuranceCompany.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsuranceCompanyPlan Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [InsuranceCompany] WHERE InsuranceCompany.VendorImportID = @VendorImportID
Select @Message = 'Rows in original InsuranceCompany '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


--**************** Create Dummy Insurance Company
DECLARE @DummyInsuranceCompanyID INT

INSERT INTO InsuranceCompany 
(
	InsuranceCompanyName, 
--	Notes, 
--	AddressLine1, 
--	AddressLine2, 
--	City, State,
--	Country, 
--	ZipCode, 
--	ContactPrefix, 
--	ContactFirstName, 
--	ContactMiddleName, 
--	ContactLastName, 
--	ContactSuffix, 
--	Phone, 
--	PhoneExt, 
--	Fax, 
--	FaxExt, 
	BillSecondaryInsurance, 
	EClaimsAccepts, 
	BillingFormID, 
	InsuranceProgramCode, 
	HCFADiagnosisReferenceFormatCode, 
	HCFASameAsInsuredFormatCode, 
	LocalUseFieldTypeCode, 
	ReviewCode, 
	ProviderNumberTypeID, 
	GroupNumberTypeID, 
	LocalUseProviderNumberTypeID, 
	CompanyTextID, 
	ClearinghousePayerID, 
	CreatedPracticeID, 
	CreatedDate, 
	CreatedUserID, 
	ModifiedDate, 
	ModifiedUserID, 
	KareoInsuranceCompanyID, 
	KareoLastModifiedDate, 
	RecordTimeStamp, 
	SecondaryPrecedenceBillingFormID, 
	VendorID, 
	VendorImportID, 
	DefaultAdjustmentCode, 
	ReferringProviderNumberTypeID, 
	NDCFormat
)
VALUES
(
	'InsuranceComapanyName',	--	InsuranceCompanyName, 
--	NULL,			--	Notes, 
--	NULL, --AddressLine1,	--	AddressLine1, 
--	NULL, --AddressLine2,	--	AddressLine2, 
--	NULL, --City,			--	City, 
--	NULL, --State,			--  State,
--	NULL,			--	Country, 
--	NULL, --LEFT(REPLACE(REPLACE(REPLACE(ZipCode, '(', ''), ')', ''), '-', ''), 9),	--ZipCode, 
--	NULL,			--	ContactPrefix, 
--	NULL,			--	ContactFirstName, 
--	NULL,			--	ContactMiddleName, 
--	NULL,			--	ContactLastName, 
--	NULL,			--	ContactSuffix, 
--	NULL, --LEFT(REPLACE(REPLACE(REPLACE(Phone, '(', ''), ')', ''), '-', ''), 10),	--	Phone, 
--	NULL,			--	PhoneExt, 
--	NULL, --LEFT(REPLACE(REPLACE(REPLACE(Fax, '(', ''), ')', ''), '-', ''), 10),	--	Fax, 
--	NULL,			--	FaxExt, 
	0,			--	BillSecondaryInsurance, 
	0,			--	EClaimsAccepts, 
	1,			--	BillingFormID, 
	'CI',			--	InsuranceProgramCode, 
	'C',			--	HCFADiagnosisReferenceFormatCode, 
	'D',			--	HCFASameAsInsuredFormatCode, 
	NULL,			--	LocalUseFieldTypeCode, 
	' ',			--	ReviewCode, 
	NULL,			--	ProviderNumberTypeID, 
	NULL,			--	GroupNumberTypeID, 
	NULL,			--	LocalUseProviderNumberTypeID, 
	NULL,			--	CompanyTextID, 
	NULL,			--	ClearinghousePayerID, 
	@PracticeID,			--	CreatedPracticeID, 
	GETDATE(),		--	CreatedDate, 
	0,				--	CreatedUserID, 
	GETDATE(),		--	ModifiedDate, 
	0,				--	ModifiedUserID, 
	NULL,			--	KareoInsuranceCompanyID, 
	NULL,			--	KareoLastModifiedDate, 
	NULL,			--	RecordTimeStamp, 
	1,			--	SecondaryPrecedenceBillingFormID, 
	1,			--	VendorID, 
	@VendorImportID,			--	VendorImportID, 
	NULL,			--	DefaultAdjustmentCode, 
	NULL,			--	ReferringProviderNumberTypeID, 
	1				--	NDCFormat
)

SET @DummyInsuranceCompanyID = SCOPE_IDENTITY()


--**************** Create Dummy InsuranceCompanyPlan
DECLARE @DummyInsuranceCompanyPlanID INT

INSERT INTO InsuranceCompanyPlan
(
	PlanName, 
--	AddressLine1, 
--	AddressLine2, 
--	City, 
--	State, 
--	Country, 
--	ZipCode, 
--	ContactPrefix, 
--	ContactFirstName, 
--	ContactMiddleName, 
--	ContactLastName, 
--	ContactSuffix, 
--	Phone, 
--	PhoneExt, 
--	Notes, 
--	MM_CompanyID, 
	CreatedDate, 
	CreatedUserID, 
	ModifiedDate, 
	ModifiedUserID, 
--	RecordTimeStamp, 
	ReviewCode, 
	CreatedPracticeID, 
	Fax, 
	FaxExt, 
	KareoInsuranceCompanyPlanID, 
	KareoLastModifiedDate, 
	InsuranceCompanyID, 
	ADS_CompanyID, 
	Copay, 
	Deductible, 
	VendorID, 
	VendorImportID
)
VALUES
(
	'PlanName',				-- PlanName, 
--	NULL,	--AddressLine1,			-- AddressLine1, 
--	NULL,	--AddressLine2,			-- AddressLine2, 
--	NULL,	--City,				-- City, 
--	NULL,	--State,			-- State, 
--	NULL,											-- Country, 
--	NULL,	--ZipCode,				-- ZipCode, 
--	NULL,											-- ContactPrefix, 
--	NULL,	-- ContactFirstName, 
--	NULL,											-- ContactMiddleName, 
--	NULL, -- ContactLastName, 
--	NULL,											-- ContactSuffix, 
--	NULL, -- Phone, 
--	NULL,											-- PhoneExt, 
--	NULL,											-- Notes, 
--	NULL,											-- MM_CompanyID, 
	GETDATE(),										-- CreatedDate, 
	0,												-- CreatedUserID, 
	GETDATE(),										-- ModifiedDate, 
	0,												-- ModifiedUserID, 
-- RecordTimeStamp, 
	'',												-- ReviewCode, 
	@PracticeID,									-- CreatedPracticeID, 
	NULL,	--LEFT(REPLACE(REPLACE(REPLACE(Fax, '(', ''), ')', ''), '-', ''), 10), -- Fax, 
	NULL,											-- FaxExt, 
	NULL,											-- KareoInsuranceCompanyPlanID, 
	NULL,											-- KareoLastModifiedDate, 
	@DummyInsuranceCompanyID,								-- InsuranceCompanyID, 
	NULL,											-- ADS_CompanyID, 
	0,		-- Copay, 
	0,		-- Deductible, 
	0,			-- VendorID, 
	@VendorImportID	
)

SET @DummyInsuranceCompanyPlanID = SCOPE_IDENTITY()

--**************** Insurance Policy 1

Insert Into InsurancePolicy
( PatientCaseID
  , PracticeID
  , InsuranceCompanyPlanID
  , PolicyNumber
  , GroupNumber
  , Precedence
--  , PolicyStartDate
--  , PolicyEndDate
	, PatientRelationshipToInsured
--  , HolderLastName
--  , HolderFirstName
--  , HolderMiddleName
--  , HolderAddressLine1
--  , HolderAddressLine2
--  , HolderCity
--  , HolderState
--  , HolderZipCode
--  , HolderGEnder
--  , HolderPhone
--  , HolderDOB
--  , HolderSSN
--  , VendorID
  , VendorImportID
)
SELECT DISTINCT
	dbo.PatientCase.PatientCaseID, 
	@PracticeID, 
	@DummyInsuranceCompanyPlanID, 
	'UNKNOWN' AS PolicyNumber, 
	'UNKNOWN' AS GroupNumber, 
	1 AS Precedence, 
	-- AS PolicyStartDate, 
	-- AS PolicyEndDate, 
	'U' AS PatientRelationshipToInsured,						
	-- AS HolderLastName, 
	-- AS HolderFirstName, 
	-- AS HolderMiddleName, 
	--NULL,														--HolderAddressLine1
	--NULL,														--HolderAddressLine2
	--NULL,														--HolderCity
	--NULL,														--HolderState
	--NULL,														--HolderZipCode
	-- AS HolderGender, 
	--NULL,														-- HolderPhone
	-- AS HolderDOB, 
	-- AS HolderSSN, 
	-- AS VendorID,
	@VendorImportID AS VendorImportID
FROM dbo.PatientCase 
WHERE dbo.PatientCase.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsurancePolicy Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM dbo.[PatientCase] WHERE dbo.PatientCase.VendorImportID = @VendorImportID
Select @Message = 'Rows in original PatientCase Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )