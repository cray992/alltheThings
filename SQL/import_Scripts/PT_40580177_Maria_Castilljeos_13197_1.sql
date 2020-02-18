--USE superbill_13197_dev
USE superbill_13197_prod
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
	City,
	[State],
	Country,
	ZipCode,
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
	ic.[insurancecompanyname]--, ic.[insuranceplanname])
	,ic.[line1]
	,ic.[city]
	,LEFT(ic.[state], 2)
	,''
	,LEFT(REPLACE(ic.[zipcode], '-',''), 9)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,LEFT(ic.[insurancecompanyname], 25) + LEFT(ic.insuranceplanname, 25) -- 
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
FROM dbo.[_import_1_1_Policies2] ic
WHERE ic.insurancecompanyname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Company Plan
PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan (
	PlanName,
	AddressLine1,
	City,
	[State],
	Country,
	ZipCode,
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
	icp.[insuranceplanname]
	,icp.[line1]
	,icp.[city]
	,LEFT(icp.[state], 2)
	,''
	,LEFT(REPLACE(icp.zipcode, '-',''), 9)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,LEFT(icp.insuranceplanname, 25)+LEFT(icp.[insurancecompanyname], 25) -- Hope it's unique!
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_import_1_1_Policies2] icp
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorImportID = @VendorImportID AND
	ic.InsuranceCompanyName =icp.insurancecompanyname AND
	ic.AddressLine1 = icp.line1 AND
	ic.city = icp.city AND 
	ic.STATE = icp.state AND
	ic.ZipCode = icp.zipcode AND 
	ic.VendorID = LEFT(icp.insurancecompanyname, 50)
WHERE icp.insuranceplanname <> ''
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
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,''
	,pat.[lastname]
	,pat.[firstname]
	,''
	,''
	,pat.[line1]
	,''
	,pat.[city]
	,LEFT(pat.[state], 2)
	,''
	,LEFT(REPLACE(pat.[zipcode], '-', ''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pat.[homephone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(pat.[dateofbirth]) WHEN 1 THEN pat.[dateofbirth] ELSE NULL END 
	,LEFT(REPLACE(pat.[ssn], '-', ''), 9)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,pat.[uniquepatientid] -- VendorID unique hooray!
	,@VendorImportID
	,1
	,1
	,1
FROM dbo.[_import_1_1_PatientDemos] pat
WHERE pat.firstname <> '' OR (pat.firstname <> '' AND pat.lastname <> '')
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
	,'Default Case'
	, 5   -- Commercial 
	,'Record created via data import, please review.'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,realP.VendorID
	,@VendorImportID
FROM dbo.Patient realP
WHERE realP.VendorImportID = @VendorImportID
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
	,ip.precedence
	,''
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,CAST(ip.uniquepatientid AS VARCHAR)
	,@VendorImportID
	,'Y'
FROM dbo.[_import_1_1_Policies2] ip
INNER JOIN dbo.PatientCase pc ON 
	ip.uniquepatientid = pc.VendorID  AND
	pc.VendorImportID = @VendorImportId
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.InsuranceCompanyPlanID = 
	( SELECT TOP 1 InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan 
		WHERE VendorID = LEFT(ip.insuranceplanname, 25) + LEFT(ip.insurancecompanyname,25))
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




COMMIT TRAN