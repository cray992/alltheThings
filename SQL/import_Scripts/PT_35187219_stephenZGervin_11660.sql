USE superbill_11660_dev
--USE superbill_11660_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT


SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'


-- Insurance Company
PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany (
	InsuranceCompanyName,
	AddressLine1,
	AddressLine2,
	City,
	[State],
	Country,
	ZipCode,
	Phone,
	CreatedPracticeID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	BillSecondaryInsurance ,
	EClaimsAccepts ,
	BillingFormID ,
	InsuranceProgramCode ,
	HCFADiagnosisReferenceFormatCode ,
	HCFASameAsInsuredFormatCode ,
	DefaultAdjustmentCode ,
	ReferringProviderNumberTypeID ,
	NDCFormat ,
	UseFacilityID ,
	AnesthesiaType ,
	InstitutionalBillingFormID,
	SecondaryPrecedenceBillingFormID 
)
SELECT DISTINCT
	[INS_COMPANY_NAME]
	,STREET1
	,STREET2
	,CITY
	,[STATE]
	,''
	,LEFT(REPLACE(ZIP, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(PHONE, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[ID]    --Kareo generated id since customer didn't provide unique id
	,@VendorImportID,
	0 , -- BillSecondaryInsurance - bit
	0, -- EClaimsAccepts - bit
	13 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	NULL , -- DefaultAdjustmentCode - varchar(10)
	NULL , -- ReferringProviderNumberTypeID - int
	1 , -- NDCFormat - int
	1, -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 , -- InstitutionalBillingFormID - int,
	13
FROM dbo.[_import_1_1_InsuranceCompanies]

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Insurance Company Plan
PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan (
	PlanName,
	AddressLine1,
	AddressLine2,
	City,
	[State],
	Country,
	ZipCode,
	Phone,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	CreatedPracticeID,
	VendorID,
	VendorImportID,
	InsuranceCompanyID
)
SELECT DISTINCT
	impIns.[INS_COMPANY_NAME]
	,impIns.STREET1
	,impIns.STREET2
	,impIns.CITY
	,impIns.[STATE]
	,''
	,LEFT(REPLACE(impIns.ZIP, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.PHONE, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,[ID] --Kareo generated
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_import_1_1_InsuranceCompanies] impIns
INNER JOIN dbo.InsuranceCompany ic ON 
	ic.VendorImportID = @VendorImportID AND
	impIns.[ID] = ic.VendorID

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Doctor Referring
PRINT ''
PRINT 'Inserting records into Doctor (Referring) ...'
INSERT INTO dbo.Doctor (
	PracticeID,
	Prefix,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	AddressLine1,
	AddressLine2,
	City,
	STATE,
	Country,
	ZipCode,
	WorkPhone,
	FaxNumber,
	Notes, 
	ActiveDoctor,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Degree,
	VendorID,
	VendorImportID,
	[External],
	NPI,
	ProviderTypeID
)
SELECT
	@PracticeID
	,''
	,[REF_PROVIDER_FIRST_NAME]
	,[REF_PROVIDER_MI]
	,[REF_PROVIDER_LAST_NAME]
	,''
	,[STREET1]
	,[STREET2]
	,[CITY]
	,[STATE]
	,''
	,LEFT(REPLACE([ZIP], '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([PHONE1], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([FAX], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,'License #:  ' + [REF_PROVIDER_LICENSE#] + '  EIN:  ' + [REF_PROVIDER_EIN]   
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[REF_PROVIDER_CREDENTIAL]
	,[ID]
	,@VendorImportID
	,1
	,LEFT([REF_PROVIDER_NPI], 10)
	,1
FROM dbo.[_import_1_1_ReferringProviders]


PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	Prefix ,
	LastName ,
	FirstName ,
	MiddleName ,
	Suffix ,
	AddressLine1 ,
	AddressLine2 ,
	City ,
	[State] ,
	Country ,
	ZipCode,
	Gender,
	HomePhone,
	WorkPhone,
	SSN,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	CollectionCategoryID,
	Active,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,''
	,[LASTNAME]
	,[FIRSTNAME]
	,[MI]
	,''
	,[STREET1]
	,[STREET2]
	,[CITY]
	,LEFT([STATE], 2)
	,''
	,LEFT(REPLACE([ZIP], '-', ''), 9)
	,[SEX] 	
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([PHONE], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([WORK_PHONE], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE([SSN], '-', ''), 9)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,0 
	,@VendorImportID
	,1
	,1
	,1
FROM dbo.[_import_1_1_Patients] 
GROUP BY firstname, lastname, mi, street1, street2, city, state, zip, sex, phone, work_phone, ssn

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



COMMIT TRAN


