-- DB 0837
-- Practice : Full Solution Services
-- FogBugz Case ID : 14142


-- Tables Populated.
-- =================
-- 1. Doctor
-- 2. Patient
-- 3. PatientCase
-- 4. InsuranceCompany
-- 5. InsuranceCompanyPlan
-- 6. InsurancePolicy
-- 7. AppointmentReason
-- 8. Appointment
-- 9. AppointmentToAppointmentReason


DECLARE @VendorImportID int
DECLARE @PracticeID int
DECLARE @Rows Int
DECLARE @Message Varchar(75)

INSERT INTO VendorImport (VendorName, VendorFormat, DateCreated, Notes)
VALUES ('Chuck Bagby', 'csv', GETDATE(), 'None')

SET @VendorImportID = SCOPE_IDENTITY()

SET @PracticeID = 1
--FROM dbo.Practice
--WHERE (Name = 'Full Solution Services')


Begin Transaction
Begin

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
	INS_NAME,		--	InsuranceCompanyName, 
	NULL,			--	Notes, 
	INS_ADDRESS1,	--	AddressLine1, 
	INS_ADDRESS2,	--	AddressLine2, 
	INS_CITY,		--	City, 
	INS_STATE,		--  State,
	NULL,			--	Country, 
	LEFT(REPLACE(REPLACE(REPLACE(INS_ZIP, '(', ''), ')', ''), '-', ''), 9),	--ZipCode, 
	NULL,			--	ContactPrefix, 
	NULL,			--	ContactFirstName, 
	NULL,			--	ContactMiddleName, 
	NULL,			--	ContactLastName, 
	NULL,			--	ContactSuffix, 
	CASE WHEN CONVERT(BIGINT, LEFT(REPLACE(REPLACE(REPLACE(INS_PHONE, '(', ''), ')', ''), '-', ''), 10)) = 0 THEN NULL ELSE LEFT(REPLACE(REPLACE(REPLACE(INS_PHONE, '(', ''), ')', ''), '-', ''), 10) END,	--	Phone, 
	NULL,			--	PhoneExt, 
	CASE WHEN CONVERT(BIGINT, LEFT(REPLACE(REPLACE(REPLACE(INS_PHONE_2, '(', ''), ')', ''), '-', ''), 10)) = 0 THEN NULL ELSE LEFT(REPLACE(REPLACE(REPLACE(INS_PHONE_2, '(', ''), ')', ''), '-', ''), 10) END,	--	Fax, 
	NULL,			--	FaxExt, 
	0,				--	BillSecondaryInsurance, 
	0,				--	EClaimsAccepts, 
	1,				--	BillingFormID, 
	'CI',			--	InsuranceProgramCode, 
	'C',			--	HCFADiagnosisReferenceFormatCode, 
	'D',			--	HCFASameAsInsuredFormatCode, 
	NULL,			--	LocalUseFieldTypeCode, 
	'R',			--	ReviewCode, 
	NULL,			--	ProviderNumberTypeID, 
	NULL,			--	GroupNumberTypeID, 
	NULL,			--	LocalUseProviderNumberTypeID, 
	NULL,			--	CompanyTextID, 
	NULL,			--	ClearinghousePayerID, 
	NULL, --@PracticeID,	--	CreatedPracticeID, 
	GETDATE(),		--	CreatedDate, 
	0,				--	CreatedUserID, 
	GETDATE(),		--	ModifiedDate, 
	0,				--	ModifiedUserID, 
	NULL,			--	KareoInsuranceCompanyID, 
	NULL,			--	KareoLastModifiedDate, 
	NULL,			--	RecordTimeStamp, 
	1,				--	SecondaryPrecedenceBillingFormID, 
	INS_NUMBER,		--	VendorID, 
	@VendorImportID,--	VendorImportID, 
	NULL,			--	DefaultAdjustmentCode, 
	NULL,			--	ReferringProviderNumberTypeID, 
	1				--	NDCFormat
FROM dbo.[x_INSURANCE(1)_csv]

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsuranceCompany Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [x_INSURANCE(1)_csv]
Select @Message = 'Rows in original x_INSURANCE(1)_csv Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

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
	dbo.[x_INS_PLANS(1)_csv].PLAN_NAME,				-- PlanName, 
	dbo.[x_INS_PLANS(1)_csv].PLAN_ADDRESS1,			-- AddressLine1, 
	dbo.[x_INS_PLANS(1)_csv].PLAN_ADDRESS2,			-- AddressLine2, 
	dbo.[x_INS_PLANS(1)_csv].PLAN_CITY,				-- City, 
	dbo.[x_INS_PLANS(1)_csv].PLAN_STATE,			-- State, 
	NULL,											-- Country, 
	dbo.[x_INS_PLANS(1)_csv].PLAN_ZIP,				-- ZipCode, 
	NULL,											-- ContactPrefix, 
	SUBSTRING(dbo.[x_INS_PLANS(1)_csv].PLAN_CONTACT, 0, CHARINDEX(' ', LTRIM(dbo.[x_INS_PLANS(1)_csv].PLAN_CONTACT))),	-- ContactFirstName, 
	NULL,											-- ContactMiddleName, 
	SUBSTRING(dbo.[x_INS_PLANS(1)_csv].PLAN_CONTACT, CHARINDEX(' ', dbo.[x_INS_PLANS(1)_csv].PLAN_CONTACT), LEN(dbo.[x_INS_PLANS(1)_csv].PLAN_CONTACT) - CHARINDEX(' ', dbo.[x_INS_PLANS(1)_csv].PLAN_CONTACT) + 1), -- ContactLastName, 
	NULL,											-- ContactSuffix, 
	CASE WHEN CONVERT(BIGINT, LEFT(REPLACE(REPLACE(REPLACE(dbo.[x_INS_PLANS(1)_csv].PLAN_PHONE1, '(', ''), ')', ''), '-', ''), 10)) = 0 THEN NULL ELSE LEFT(REPLACE(REPLACE(REPLACE(dbo.[x_INS_PLANS(1)_csv].PLAN_PHONE1, '(', ''), ')', ''), '-', ''), 10) END, -- Phone, 
	NULL,											-- PhoneExt, 
	NULL,											-- Notes, 
	NULL,											-- MM_CompanyID, 
	GETDATE(),										-- CreatedDate, 
	0,												-- CreatedUserID, 
	GETDATE(),										-- ModifiedDate, 
	0,												-- ModifiedUserID, 
									-- RecordTimeStamp, 
	'R',												-- ReviewCode, 
	NULL, --@PracticeID,									-- CreatedPracticeID, 
	CASE WHEN CONVERT(BIGINT, LEFT(REPLACE(REPLACE(REPLACE(dbo.[x_INS_PLANS(1)_csv].PLAN_FAX_NUMBER, '(', ''), ')', ''), '-', ''), 10)) = 0 THEN NULL ELSE LEFT(REPLACE(REPLACE(REPLACE(dbo.[x_INS_PLANS(1)_csv].PLAN_FAX_NUMBER, '(', ''), ')', ''), '-', ''), 10) END, -- Fax, 
	NULL,											-- FaxExt, 
	NULL,											-- KareoInsuranceCompanyPlanID, 
	NULL,											-- KareoLastModifiedDate, 
	dbo.InsuranceCompany.InsuranceCompanyID,		-- InsuranceCompanyID, 
	NULL,											-- ADS_CompanyID, 
	ISNULL(dbo.[x_INS_PLANS(1)_csv].PLAN_COPAY_AMT, 0),		-- Copay, 
	ISNULL(dbo.[x_INS_PLANS(1)_csv].PLAN_DEDUCTIBLE, 0),	-- Deductible, 
	dbo.[x_INS_PLANS(1)_csv].PLAN_NUMBER,			-- VendorID, 
	@VendorImportID									-- VendorImportID

FROM dbo.[x_INS_PLANS(1)_csv] 
LEFT OUTER JOIN  dbo.InsuranceCompany 
ON dbo.[x_INS_PLANS(1)_csv].PLAN_INS_NUM = dbo.InsuranceCompany.VendorID
WHERE dbo.[x_INS_PLANS(1)_csv].PLAN_NAME IS NOT NULL
AND dbo.InsuranceCompany.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsuranceCompanyPlan Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [x_INS_PLANS(1)_csv]
Select @Message = 'Rows in original x_INS_PLANS(1)_csv Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

INSERT INTO DOCTOR 
(
	PracticeID, 
	Prefix, 
	FirstName, 
	MiddleName, 
	LastName, 
	Suffix, 
	SSN, 
	AddressLine1, 
	AddressLine2, 
	City, 
	State, 
	Country, 
	ZipCode, 
	HomePhone, 
	HomePhoneExt, 
	WorkPhone, 
	WorkPhoneExt, 
	PagerPhone, 
	PagerPhoneExt, 
	MobilePhone, 
	MobilePhoneExt, 
	DOB, 
	EmailAddress, 
	Notes, 
	ActiveDoctor, 
	CreatedDate, 
	CreatedUserID, 
	ModifiedDate, 
	ModifiedUserID, 
	RecordTimeStamp, 
	UserID, 
	Degree, 
	DefaultEncounterTemplateID, 
	TaxonomyCode, 
	DepartmentID, 
	VendorID, 
	VendorImportID, 
	FaxNumber, 
	FaxNumberExt, 
	OrigReferringPhysicianID, 
	[External]
)
SELECT DISTINCT
	@PracticeID,							--PracticeID, 
	'',										--Prefix, 
	LTRIM(RTRIM(ISNULL(RDR_F_NAME, ''))),	--FirstName, 
	'',										--MiddleName, 
	LTRIM(RTRIM(ISNULL(RDR_L_NAME, ''))),	--LastName, 
	'',										--Suffix, 
	NULL,									--SSN, 
	RDR_ADDRESS1,							--AddressLine1, 
	RDR_ADDRESS2,							--AddressLine2, 
	RDR_CITY,								--City, 
	RDR_STATE,								--State, 
	NULL,									--Country, 
	LEFT(REPLACE(REPLACE(REPLACE(RDR_ZIP, '(', ''), ')', ''), '-', ''), 9),		--ZipCode, 
	CASE WHEN CONVERT(BIGINT, LEFT(REPLACE(REPLACE(REPLACE(RDR_PHONE, '(', ''), ')', ''), '-', ''), 10)) = 0 THEN NULL ELSE LEFT(REPLACE(REPLACE(REPLACE(RDR_PHONE, '(', ''), ')', ''), '-', ''), 10) END AS HomePhone,	--HomePhone, 
	NULL,									--HomePhoneExt, 
	NULL,									--WorkPhone, 
	NULL,									--WorkPhoneExt, 
	NULL,									--PagerPhone, 
	NULL,									--PagerPhoneExt, 
	NULL,									--MobilePhone, 
	NULL,									--MobilePhoneExt, 
	NULL,									--DOB, 
	NULL,									--EmailAddress, 
	NULL,									--Notes, 
	1,										--ActiveDoctor, (Default -1)
	GETDATE(),								--CreatedDate,	(getdate())
	0,										--CreatedUserID,	(0)
	GETDATE(),								--ModifiedDate, 	(getdate())
	0,										--ModifiedUserID,	(0)
	NULL,									--RecordTimeStamp,	(Default)
	NULL,									--UserID, 
	NULL,									--Degree, 
	NULL,									--DefaultEncounterTemplateID, 
	NULL,									--TaxonomyCode, 
	NULL,									--DepartmentID, 
	RDR_NUMBER,								--VendorID, 
	@VendorImportID,						--VendorImportID, 
	CASE WHEN CONVERT(BIGINT, LEFT(REPLACE(REPLACE(REPLACE(RDR_FAX, '(', ''), ')', ''), '-', ''), 10)) = 0 THEN NULL ELSE LEFT(REPLACE(REPLACE(REPLACE(RDR_FAX, '(', ''), ')', ''), '-', ''), 10) END AS FaxNumber, --FaxNumber, 
	NULL,									--FaxNumberExt, 
	NULL,									--OrigReferringPhysicianID, 
	1										--[External]

FROM dbo.[x_REFERRING DR(1)_csv] 
WHERE (RDR_L_NAME IS NOT NULL OR RDR_F_NAME IS NOT NULL)

Select @Rows = @@RowCount
Select @Message = 'Rows Added in DOCTOR Table for Referring Doctors'
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [x_REFERRING DR(1)_csv]
Select @Message = 'Rows in original x_REFERRING DR(1)_csv Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

INSERT INTO Patient 
(
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
	EmailAddress, 
	ResponsibleDifferentThanPatient, 
	ResponsiblePrefix, 
	ResponsibleFirstName, 
	ResponsibleMiddleName, 
	ResponsibleLastName, 
	ResponsibleSuffix, 
	ResponsibleRelationshipToPatient, 
	ResponsibleAddressLine1, 
	ResponsibleAddressLine2, 
	ResponsibleCity, 
	ResponsibleState, 
	ResponsibleCountry, 
	ResponsibleZipCode, 
	CreatedDate, 
	CreatedUserID, 
	ModifiedDate, 
	ModifiedUserID, 
	RecordTimeStamp, 
	EmploymentStatus, 
	InsuranceProgramCode, 
	PatientReferralSourceID, 
	PrimaryProviderID, 
	DefaultServiceLocationID, 
	EmployerID, 
	MedicalRecordNumber, 
	MobilePhone, 
	MobilePhoneExt, 
	PrimaryCarePhysicianID, 
	VendorID, 
	VendorImportID
)
SELECT DISTINCT
	@PracticeID,									-- PracticeID,
	dbo.Doctor.DoctorID,						-- ReferringPhysicianID
	'', 										-- Prefix
	LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].PAT_F_NAME, ''))),		-- FirstName '' for default
	LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].PAT_M_NAME, ''))),		-- MiddleName '' for default
	LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].PAT_L_NAME, ''))),		-- LastName '' for default
	'', 																-- Suffix
	LTrim(RTrim(dbo.[x_PATIENT(1)_csv].PAT_ADDRESS1)),					-- AddressLine1	
	LTrim(RTrim(dbo.[x_PATIENT(1)_csv].PAT_ADDRESS2)), 					-- AddressLine2
	LTrim(RTrim(dbo.[x_PATIENT(1)_csv].PAT_CITY)),						-- City
	LTrim(RTrim(dbo.[x_PATIENT(1)_csv].PAT_STATE)),						-- State
	NULL, 																-- Country
	Left(dbo.[x_PATIENT(1)_csv].PAT_ZIP_CODE, 5),						-- ZipCode
	LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].PAT_SEX, 'U'))), 			-- Gender 'U' for default
	LEFT (ISNULL(dbo.[x_MARTIAL_STATUS(1)_csv].MS_NAME, 'U'), 1),		-- MaritalStatus 'U' for default
	CASE WHEN CONVERT(BIGINT, LEFT(REPLACE(REPLACE(REPLACE(dbo.[x_PATIENT(1)_csv].PAT_PHONE_HM, '(', ''), ')', ''), '-', ''), 10)) = 0 THEN NULL ELSE LEFT(REPLACE(REPLACE(REPLACE(dbo.[x_PATIENT(1)_csv].PAT_PHONE_HM, '(', ''), ')', ''), '-', ''), 10) END AS HomePhone,	-- HomePhone default Null
	NULL,																-- HomePhoneExt
	CASE WHEN CONVERT(BIGINT, LEFT(REPLACE(REPLACE(REPLACE(dbo.[x_PATIENT(1)_csv].PAT_PHONE_WRK, '(', ''), ')', ''), '-', ''), 10)) = 0 THEN NULL ELSE LEFT(REPLACE(REPLACE(REPLACE(dbo.[x_PATIENT(1)_csv].PAT_PHONE_WRK, '(', ''), ')', ''), '-', ''), 10) END AS WorkPhone,	-- WorkPhone, default null
	NULL, 										-- WorkPhoneExt,
	dbo.[x_PATIENT(1)_csv].PAT_BIRTHDATE,		-- DOB
	CASE WHEN LEFT(REPLACE(REPLACE(REPLACE(dbo.[x_PATIENT(1)_csv].PAT_SSN, '(', ''), ')', ''), '-', ''), 9) = 0 THEN NULL ELSE LEFT(REPLACE(REPLACE(REPLACE(dbo.[x_PATIENT(1)_csv].PAT_SSN, '(', ''), ')', ''), '-', ''), 9) END AS SSN,	-- SSN
	NULL,										-- EmailAddress
	CASE WHEN LEN(LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].GUAR_L_NAME, '')))) = 0 THEN 0 ELSE 1 END AS ResponsibleDifferentThanPatient,    -- ResponsibleDifferentThanPatient default 0
	NULL,										-- ResponsiblePrefix, 
	CASE WHEN LEN(LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].GUAR_L_NAME, '')))) = 0 THEN '' ELSE LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].GUAR_F_NAME, ''))) END,		-- ResponsibleFirstName, 
	CASE WHEN LEN(LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].GUAR_L_NAME, '')))) = 0 THEN '' ELSE LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].GUAR_M_NAME, ''))) END,		-- ResponsibleMiddleName, 
	CASE WHEN LEN(LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].GUAR_L_NAME, '')))) = 0 THEN '' ELSE LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].GUAR_L_NAME, ''))) END,		-- ResponsibleLastName, 
	NULL,										-- ResponsibleSuffix, 
	NULL,										-- vResponsibleRelationshipToPatient, 
	CASE WHEN LEN(LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].GUAR_L_NAME, '')))) = 0 THEN '' ELSE dbo.[x_PATIENT(1)_csv].GUAR_ADDRESS1 END,		-- ResponsibleAddressLine1, 
	CASE WHEN LEN(LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].GUAR_L_NAME, '')))) = 0 THEN '' ELSE dbo.[x_PATIENT(1)_csv].GUAR_ADDRESS2 END,		-- ResponsibleAddressLine2, 
	CASE WHEN LEN(LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].GUAR_L_NAME, '')))) = 0 THEN '' ELSE dbo.[x_PATIENT(1)_csv].GUAR_CITY END,			-- ResponsibleCity, 
	CASE WHEN LEN(LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].GUAR_L_NAME, '')))) = 0 THEN '' ELSE dbo.[x_PATIENT(1)_csv].GUAR_STATE END,			-- ResponsibleState, 
	NULL,										-- ResponsibleCountry, 
	CASE WHEN LEN(LTrim(RTrim(ISNULL(dbo.[x_PATIENT(1)_csv].GUAR_L_NAME, '')))) = 0 THEN '' ELSE LEFT(REPLACE(REPLACE(REPLACE(dbo.[x_PATIENT(1)_csv].GUAR_ZIP_CODE, '(', ''), ')', ''), '-', ''), 9) END,	-- ResponsibleZipCode,
	GetDate(),									-- CreatedDate
	0,											-- CreatedUserID
	GetDate(),									-- ModifiedDate
	0,											-- ModifiedUserID
	NULL,										-- RecordTimeStamp
	CASE dbo.[x_PAT_EMP_STATUS(1)_csv].[NAME]
				WHEN 'Employed Full-Time'
					THEN 'E'
				WHEN 'Self-Employed'
					THEN 'E'
				WHEN 'Employed Part-Time'
					THEN 'E'
				WHEN 'On Active Military Duty'
					THEN 'E'
				WHEN 'Retired'
					THEN 'R'
				WHEN NULL
					THEN 'U'
				WHEN 'Unknown'
					THEN 'U'
				WHEN 'Not Employed'
					THEN 'U'
				WHEN 'Not Employed'
					THEN 'U' 
				ELSE 'U'
			END AS EmploymentStatus,			-- EmploymentStatus
	NULL,										-- InsuranceProgramCode, 
	NULL,										-- PatientReferralSourceID, 
	NULL,										-- PrimaryProviderID, 
	NULL,										-- DefaultServiceLocationID, 
	NULL,										-- EmployerID, 
	dbo.[x_PATIENT(1)_csv].PAT_NUMBER,			-- MedicalRecordNumber
	NULL,										-- MobilePhone, 
	NULL,										-- MobilePhoneExt, 
	NULL,										-- PrimaryCarePhysicianID,
	dbo.[x_PATIENT(1)_csv].PAT_NO,				-- VendorID
	@VendorImportID								-- VendorImportID

FROM dbo.[x_PATIENT(1)_csv] 
LEFT OUTER JOIN dbo.Doctor 
ON dbo.[x_PATIENT(1)_csv].PAT_RDR_NUMBER = dbo.Doctor.VendorID 
AND dbo.Doctor.VendorImportID = @VendorImportID
LEFT OUTER JOIN dbo.[x_PAT_EMP_STATUS(1)_csv] 
ON dbo.[x_PATIENT(1)_csv].PAT_EMP_STAT = dbo.[x_PAT_EMP_STATUS(1)_csv].CODE 
LEFT OUTER JOIN dbo.[x_MARTIAL_STATUS(1)_csv] 
ON dbo.[x_PATIENT(1)_csv].PAT_MS_NUMBER = dbo.[x_MARTIAL_STATUS(1)_csv].MS_NUMBER
WHERE (dbo.[x_PATIENT(1)_csv].PAT_L_NAME IS NOT NULL) OR (dbo.[x_PATIENT(1)_csv].PAT_F_NAME IS NOT NULL)

Select @Rows = @@RowCount
Select @Message = 'Rows Added in Patient Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [x_PATIENT(1)_csv]
Select @Message = 'Rows in original x_PATIENT(1)_csv Table '
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
ReferringPhysicianID, --null,
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
@VendorImportID, --1, 
0, 
1, 
0, 
0
FROM Patient 
WHERE @VendorImportID = VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in PatientCase Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [Patient] WHERE [Patient].VendorImportID = @VendorImportID
Select @Message = 'Rows in original Patient Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--InsurancePolicy 1.
Insert Into InsurancePolicy
( PatientCaseID
  , PracticeID
  , InsuranceCompanyPlanID
  , PolicyNumber
  , GroupNumber
  , Precedence
  , PolicyStartDate
  , PolicyEndDate
  , PatientRelationshipToInsured
  , HolderLastName
  , HolderFirstName
  , HolderMiddleName
  , HolderAddressLine1
  , HolderAddressLine2
  , HolderCity
  , HolderState
  , HolderZipCode
  , HolderGEnder
  , HolderPhone
  , HolderDOB
  , HolderSSN
  , VendorID
  , VendorImportID
)
SELECT DISTINCT
dbo.PatientCase.PatientCaseID, 
dbo.Patient.PracticeID, 
derivedtbl_1.InsuranceCompanyPlanID AS InsuranceCompanyPlanID, 
CASE WHEN LEN([x_PATIC(1)_csv].COV_ID11_CONTRACT) = 0 THEN 'UNKNOWN' ELSE [x_PATIC(1)_csv].COV_ID11_CONTRACT END AS PolicyNumber, 
CASE WHEN LEN([x_PATIC(1)_csv].COV_ID11_GROUP) = 0 THEN NULL ELSE [x_PATIC(1)_csv].COV_ID11_GROUP END AS GroupNumber, 
1 AS Precedence, 
CASE WHEN LEN([x_PATIC(1)_csv].COV_EFF_FROM_DATE) < 1 THEN NULL ELSE [x_PATIC(1)_csv].COV_EFF_FROM_DATE END AS PolicyStartDate, 
CASE WHEN LEN([x_PATIC(1)_csv].COV_EFF_TO_DATE) < 1 THEN NULL ELSE [x_PATIC(1)_csv].COV_EFF_FROM_DATE END AS PolicyEndDate, 
CASE
	When [x_PATIC(1)_csv].COV_COV_REL BETWEEN 1 AND 2 Then 'S'	-- Self
	When [x_PATIC(1)_csv].COV_COV_REL BETWEEN 3 AND 4 Then 'U'	-- Spouse
	When [x_PATIC(1)_csv].COV_COV_REL BETWEEN 5 AND 6 Then 'C'	-- Child
	Else 'O'														-- Other
END AS PatientRelationshipToInsured,						
CASE WHEN [x_PATIC(1)_csv].COV_COV_REL BETWEEN 1 AND 2 THEN NULL ELSE [x_PATIC(1)_csv].COV_SUB_L_NAME END AS HolderLastName, 
CASE WHEN [x_PATIC(1)_csv].COV_COV_REL BETWEEN 1 AND 2 THEN NULL ELSE [x_PATIC(1)_csv].COV_SUB_F_NAME END AS HolderFirstName, 
CASE WHEN [x_PATIC(1)_csv].COV_COV_REL BETWEEN 1 AND 2 THEN NULL ELSE [x_PATIC(1)_csv].COV_SUB_M_NAME END AS HolderMiddleName, 
NULL,														--HolderAddressLine1
NULL,														--HolderAddressLine2
NULL,														--HolderCity
NULL,														--HolderState
NULL,														--HolderZipCode
CASE WHEN [x_PATIC(1)_csv].COV_COV_REL BETWEEN 1 AND 2 THEN NULL ELSE [x_PATIC(1)_csv].COV_SUB_SEX END AS HolderGender, 
NULL,														-- HolderPhone
[x_PATIC(1)_csv].COV_SUB_DOB AS HolderDOB, 
CASE WHEN [x_PATIC(1)_csv].COV_SUB_SSN = 0 THEN NULL ELSE [x_PATIC(1)_csv].COV_SUB_SSN END AS HolderSSN, 
[x_PATIC(1)_csv].COV_NUMBER AS VendorID,
@VendorImportID AS VendorImportID
FROM dbo.InsuranceCompany 
INNER JOIN dbo.PatientCase 
INNER JOIN dbo.Patient 
ON dbo.PatientCase.PatientID = dbo.Patient.PatientID 
AND dbo.PatientCase.VendorImportID = @VendorImportID
AND dbo.Patient.VendorImportID = @VendorImportID
INNER JOIN 
(
SELECT DISTINCT 
COV_ID11_CONTRACT, COV_ID11_GROUP, COV_EFF_FROM_DATE, COV_EFF_TO_DATE, 
COV_COV_REL, COV_SUB_L_NAME, COV_SUB_F_NAME, 
COV_SUB_M_NAME, COV_SUB_SEX, COV_SUB_DOB, COV_SUB_SSN, COV_NUMBER, COV_PAT_NO, COV_INS_NUMBER
FROM dbo.[x_PATIC(1)_csv]
) AS [x_PATIC(1)_csv] 
ON dbo.Patient.VendorID = [x_PATIC(1)_csv].COV_PAT_NO 
ON dbo.InsuranceCompany.VendorID = [x_PATIC(1)_csv].COV_INS_NUMBER
AND dbo.InsuranceCompany.VendorImportID = @VendorImportID
INNER JOIN
(SELECT InsuranceCompanyID, MIN(InsuranceCompanyPlanID) AS InsuranceCompanyPlanID
FROM dbo.InsuranceCompanyPlan
GROUP BY InsuranceCompanyID) AS derivedtbl_1 
ON dbo.InsuranceCompany.InsuranceCompanyID = derivedtbl_1.InsuranceCompanyID


Select @Rows = @@RowCount
Select @Message = 'Rows Added in InsurancePolicy Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [x_PATIC(1)_csv]
Select @Message = 'Rows in original x_PATIC(1)_csv Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

----************************* Appointment Reason table
-- Import into AppointmentReason
INSERT INTO AppointmentReason 
(
	PracticeID,					-- Not Null
	[Name],						-- Not Null
	DefaultDurationMinutes, 
--	DefaultColorCode,			-- Leave Null
--	Description, 
--	ModifiedDate,				-- Not Null, Use Default
--	[TIMESTAMP],				-- Leave Null
	VendorID, 
	VendorImportID
)
SELECT 
	@PracticeID,
	CONVERT(VARCHAR(128), Reason),
	30,
	ApptID,
	@VendorImportID
	FROM
	(SELECT     T_TICKET_NUMBER AS ApptID, T_REASON1 AS Reason
	FROM         dbo.[x_TAPPT(1)_csv]
	WHERE     (T_REASON1 IS NOT NULL) AND (T_REASON1 <> '')
	UNION
	SELECT     T_TICKET_NUMBER AS ApptID, T_REASON2 AS Reason
	FROM         dbo.[x_TAPPT(1)_csv] AS [x_TAPPT(1)_csv_3]
	WHERE     (T_REASON2 IS NOT NULL) AND (T_REASON2 <> '')
	UNION
	SELECT     T_TICKET_NUMBER AS ApptID, T_REASON3 AS Reason
	FROM         dbo.[x_TAPPT(1)_csv] AS [x_TAPPT(1)_csv_2]
	WHERE     (T_REASON3 IS NOT NULL) AND (T_REASON3 <> '')
	UNION
	SELECT     T_TICKET_NUMBER AS ApptID, T_REASON4 AS Reason
	FROM         dbo.[x_TAPPT(1)_csv] AS [x_TAPPT(1)_csv_1]
	WHERE     (T_REASON4 IS NOT NULL) AND (T_REASON4 <> '')
	) AS ReasonTbl

Select @Rows = @@RowCount
Select @Message = 'Rows Added in AppointmentReason Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


INSERT INTO Appointment
(
	PatientID, 
	PracticeID, 
	ServiceLocationID, 
	StartDate, 
	EndDate, 
	AppointmentType, 
	Subject, 
	Notes, 
	CreatedDate, 
	CreatedUserID, 
	ModifiedDate, 
	ModifiedUserID, 
--	RecordTimeStamp, 
	AppointmentResourceTypeID, 
	AppointmentConfirmationStatusCode, 
	AllDay, 
	InsurancePolicyAuthorizationID, 
	PatientCaseID, 
	Recurrence, 
	RecurrenceStartDate, 
	RangeEndDate, 
	RangeType, 
	StartDKPracticeID, 
	EndDKPracticeID, 
	StartTm, 
	EndTm,
	VendorID,
	VendorImportID
)
SELECT
dbo.Patient.PatientID,		--PatientID, 
@PracticeID,		--PracticeID, 
NULL,		--ServiceLocationID, 

CONVERT(datetime,
RIGHT (dbo.[x_TAPPT(1)_csv].T_DATE, 4) 
+ '-' + 
LEFT (dbo.[x_TAPPT(1)_csv].T_DATE, CHARINDEX('/', dbo.[x_TAPPT(1)_csv].T_DATE) - 1)
+ '-' + 
SUBSTRING(dbo.[x_TAPPT(1)_csv].T_DATE, CHARINDEX('/', dbo.[x_TAPPT(1)_csv].T_DATE)+1, 
CHARINDEX('/', dbo.[x_TAPPT(1)_csv].T_DATE, CHARINDEX('/', dbo.[x_TAPPT(1)_csv].T_DATE)+1) - CHARINDEX('/', dbo.[x_TAPPT(1)_csv].T_DATE)-1) 
 + ' ' 
+ LEFT (REPLICATE('0', 4 - LEN(dbo.[x_TAPPT(1)_csv].T_TIME)) 
+ dbo.[x_TAPPT(1)_csv].T_TIME, 2) + ':' + RIGHT (REPLICATE('0', 4 - LEN(dbo.[x_TAPPT(1)_csv].T_TIME)) + dbo.[x_TAPPT(1)_csv].T_TIME, 2) + ':00'
, 121) AS StartDate,
			--StartDate, 
DATEADD(mi, 30,
CONVERT(datetime,
RIGHT (dbo.[x_TAPPT(1)_csv].T_DATE, 4) 
+ '-' + 
LEFT (dbo.[x_TAPPT(1)_csv].T_DATE, CHARINDEX('/', dbo.[x_TAPPT(1)_csv].T_DATE) - 1)
+ '-' + 
SUBSTRING(dbo.[x_TAPPT(1)_csv].T_DATE, CHARINDEX('/', dbo.[x_TAPPT(1)_csv].T_DATE)+1, 
CHARINDEX('/', dbo.[x_TAPPT(1)_csv].T_DATE, CHARINDEX('/', dbo.[x_TAPPT(1)_csv].T_DATE)+1) - CHARINDEX('/', dbo.[x_TAPPT(1)_csv].T_DATE)-1) 
 + ' ' 
+ LEFT (REPLICATE('0', 4 - LEN(dbo.[x_TAPPT(1)_csv].T_TIME)) + dbo.[x_TAPPT(1)_csv].T_TIME, 2) + ':' + RIGHT (REPLICATE('0', 4 - LEN(dbo.[x_TAPPT(1)_csv].T_TIME)) + dbo.[x_TAPPT(1)_csv].T_TIME, 2) + ':00'
, 121)) AS EndDate,
				--EndDate, 
'P',			--AppointmentType, 
NULL,		--Subject, 
NULL,		--Notes, 
GetDate(),		--CreatedDate, 
0,				--CreatedUserID, 
GetDate(),		--ModifiedDate, 
0,				--ModifiedUserID, 
--RecordTimeStamp, Allow default
1,			--AppointmentResourceTypeID, 
'C',		--AppointmentConfirmationStatusCode, 
0,			--AllDay, 
NULL,		--InsurancePolicyAuthorizationID, 
NULL,		--PatientCaseID, 
NULL,		--Recurrence, 
NULL,		--RecurrenceStartDate, 
NULL,		--RangeEndDate, 
NULL,		--RangeType, 
NULL,		--StartDKPracticeID, 
NULL,		--EndDKPracticeID, 
NULL,		--StartTm, 
NULL,		--EndTm
T_TICKET_NUMBER,	--VendorID,
@VendorImportID		--VendorImportID
FROM dbo.[x_TAPPT(1)_csv] 
LEFT OUTER JOIN dbo.[x_LOCATION(1)_csv] 
ON dbo.[x_TAPPT(1)_csv].T_LOC_NUMBER = dbo.[x_LOCATION(1)_csv].LOC_NUMBER 
LEFT OUTER JOIN dbo.Doctor AS Doctor_1 
ON dbo.[x_TAPPT(1)_csv].T_RDR_NUMBER = Doctor_1.OrigReferringPhysicianID 
AND Doctor_1.VendorImportID = @VendorImportID
LEFT OUTER JOIN dbo.Doctor 
ON dbo.[x_TAPPT(1)_csv].T_DR_NUMBER = dbo.Doctor.VendorID 
AND dbo.Doctor.VendorImportID = @VendorImportID
LEFT OUTER JOIN dbo.Patient 
ON dbo.[x_TAPPT(1)_csv].T_PAT_NUMBER = dbo.Patient.VendorID
AND dbo.Patient.VendorImportID = @VendorImportID
WHERE dbo.[x_TAPPT(1)_csv].T_DATE IS NOT NULL

Select @Rows = @@RowCount
Select @Message = 'Rows Added in Appointment Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

SELECT @Rows = COUNT(*) FROM [x_TAPPT(1)_csv]
Select @Message = 'Rows in original x_TAPPT(1)_csv Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


--*************************** AppointmentToAppointmentReason
INSERT INTO dbo.AppointmentToAppointmentReason
(
	AppointmentID, 
	AppointmentReasonID, 
	--PrimaryAppointment, 
	--ModifiedDate, 
	--[TIMESTAMP], 
	PracticeID
)
SELECT     
	dbo.Appointment.AppointmentID, 
	dbo.AppointmentReason.AppointmentReasonID,
	@PracticeID
FROM dbo.Appointment 
INNER JOIN dbo.AppointmentReason 
ON dbo.Appointment.VendorImportID = dbo.AppointmentReason.VendorImportID 
AND dbo.Appointment.VendorID = dbo.AppointmentReason.VendorID
AND dbo.AppointmentReason.PracticeID = dbo.Appointment.PracticeID
WHERE dbo.AppointmentReason.VendorImportID = @VendorImportID

Select @Rows = @@RowCount
Select @Message = 'Rows Added in AppointmentToAppointmentReason Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

End
-- ROLLBACK
-- Commit Transaction