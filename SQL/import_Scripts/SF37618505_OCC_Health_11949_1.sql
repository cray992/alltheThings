USE superbill_11949_dev 
--USE superbill_11949_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'

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
	ic.name
	,ic.street1
	,ic.street2
	,ic.city
	,ic.[state]
	,''
	,LEFT(REPLACE(ic.zipcode, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ic.phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,ic.code -- Hope it's unique!
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
FROM dbo.[_import_1_1_InsuranceCompanies] ic

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
	icp.name
	,icp.street1
	,icp.street2
	,icp.city
	,icp.[state]
	,''
	,LEFT(REPLACE(icp.zipcode, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(icp.phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,icp.code -- Hope it's unique!
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_import_1_1_InsuranceCompanies] icp
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorImportID = @VendorImportID AND
	icp.code = ic.VendorID
		
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
	HomePhone ,
	DOB ,
	SSN ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	MedicalRecordNumber,
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,''
	,pat.lastname
	,pat.firstname
	,pat.middleinitial
	,''
	,pat.street1
	,''
	,pat.city
	,LEFT(pat.[state], 2)
	,''
	,LEFT(REPLACE(pat.zipcode, '-', ''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.phone1, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(pat.dateofbirth) WHEN 1 THEN pat.dateofbirth ELSE NULL END 
	,LEFT(REPLACE(pat.socsecnum, '-', ''), 9)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,pat.chartnumber -- MedicalRecordNumber
	,pat.chartnumber -- VendorID unique hooray!
	,@VendorImportID
	,1
	,1
	,1
FROM dbo.[_import_1_1_PatientDemos] pat

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Case - All records
PRINT ''
PRINT 'Inserting records into PatientCase ...'
INSERT INTO dbo.PatientCase (
	PatientID,
	[Name],
	PayerScenarioID,
	Notes,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	PracticeID,
	VendorID,
	VendorImportID
)
SELECT DISTINCT
	realP.PatientID
	,CASE WHEN impIns.NAME IS NULL THEN 'Default Case'
		  WHEN impCase.insur1id <> '' THEN 'Case ' + impCase.insur1
		  ELSE 'Default Case'  END
	,CASE WHEN impIns.NAME IS NULL THEN 11
		  WHEN impCase.insur1id <> '' THEN 5
		  ELSE 11  END -- 5 'Commercial'    11 Self Pay
	,'Record created via data import, please review.'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impCase.chartnumber + impCase.insur1id
	,@VendorImportID
FROM dbo.Patient realP
LEFT JOIN dbo.[_import_1_1_InsurancePolicyinfo] impCase ON 
	impCase.chartnumber = realP.VendorID
LEFT JOIN dbo.[_import_1_1_InsuranceCompanies] impIns ON
	impCase.insur1 = impIns.name
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'





-- Insurance Policy #1
PRINT ''
PRINT 'Inserting records into InsurancePolicy #1...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation
	
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,impPC.insur1id
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impPC.chartnumber + '1' 
	,@VendorImportID
	,'Y'
FROM dbo.[_import_1_1_InsurancePolicyinfo] impPC
JOIN dbo.PatientCase pc ON 
	pc.VendorImportID = @VendorImportID AND 
	impPC.chartnumber + impPC.insur1id = pc.VendorID  AND
	pc.Name = 'Case ' + impPC.insur1
INNER JOIN dbo.InsuranceCompany ic ON
	impPC.insur1 = ic.InsuranceCompanyName
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	icp.InsuranceCompanyID = ic.InsuranceCompanyID

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy #2
PRINT ''
PRINT 'Inserting records into InsurancePolicy #2...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation
	
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,2
	,impPC.insur2id
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impPC.chartnumber + '2' 
	,@VendorImportID
	,'Y'
FROM dbo.[_import_1_1_InsurancePolicyinfo] impPC
JOIN dbo.PatientCase pc ON 
	pc.VendorImportID = @VendorImportID AND 
	impPC.chartnumber + impPC.insur1id = pc.VendorID  AND
	pc.Name = 'Case ' + impPC.insur1
INNER JOIN dbo.InsuranceCompany ic ON
	impPC.insur1 = ic.InsuranceCompanyName
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	icp.InsuranceCompanyID = ic.InsuranceCompanyID
WHERE 
	impPC.insur2 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT TRAN