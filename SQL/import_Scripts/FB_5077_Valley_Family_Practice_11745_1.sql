USE superbill_11745_dev 
--USE superbill_11745_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT


SET @PracticeID = 1
SET @VendorImportID = 1 -- Uploaded through import tool

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
	policy_group_name
	,address_1
	,address_2
	,city
	,[State]
	,'USA'
	,zip_code + zip4
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,plan_id -- Verified to be unique, (yay!)
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
FROM dbo.[_import_1_1_VFPIns]
WHERE
	RTRIM(LTRIM(policy_group_name)) <> ''

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
	CreatedPracticeID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	InsuranceCompanyID
)
SELECT DISTINCT 
	impIns.policy_group_name
	,impIns.address_1
	,impIns.address_2
	,impIns.city
	,impIns.[state]
	,'USA'
	,impIns.zip_code + impIns.zip4
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impIns.plan_id
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_import_1_1_VFPIns] impIns
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorImportID = @VendorImportID AND
	ic.CreatedPracticeID = @PracticeID AND
	impIns.plan_id = ic.VendorID
WHERE
	RTRIM(LTRIM(policy_group_name)) <> ''
		
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Doctor Referring
PRINT ''
PRINT 'Inserting records into Doctor Referring ...'
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
	[State],
	ZipCode,
	Country,
	WorkPhone,
	FaxNumber,
	MobilePhone,
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
SELECT DISTINCT
	@PracticeID
	,''
	,first_name
	,middle_initial
	,last_name
	,''
	,address1
	,address2
	,city
	,state
	,referring_doctor_zip_code
	,'USA'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(fax, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(alternate_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,LEFT(degree_desc, 8)
	,referring_id -- Unique, I verified
	,@VendorImportID
	,1
	,LEFT(npi, 10)
	,1
FROM dbo.[_import_1_1_VFPRefdocs]
WHERE 
	first_name <> ''

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
	ZipCode ,
	Gender ,
	MaritalStatus ,
	HomePhone ,
	EmailAddress,
	DOB ,
	SSN ,
	ResponsibleRelationshipToPatient,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	MedicalRecordNumber,
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	SendEmailCorrespondence ,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,''
	,impP.last_name
	,impP.first_name
	,impP.middle_initial
	,''
	,impP.address1
	,impP.address2
	,impP.city
	,impP.[state]
	,'USA'
	,impP.patient_zip + impP.zip4
	,'U'
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,e_mail_address
	,CASE ISDATE(impP.dob) WHEN 1 THEN impP.dob ELSE NULL END 
	,LEFT(REPLACE(impP.ss_no, '-', ''), 9)
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impP.chart_no
	,impP.ID -- Unique key we add during upload
	,@VendorImportID
	,1
	,1
	,CASE WHEN impP.e_mail_address <> '' THEN 1 ELSE 0 END
	,1
FROM dbo.[_import_1_1_VFPPatients] impP
WHERE first_name <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



COMMIT TRAN