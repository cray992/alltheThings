USE superbill_9380_dev
--USE superbill_9380_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @VendorName VARCHAR(100)
DECLARE @ImportNote VARCHAR(100)

-- This script ASSUMES that someone has created the first practice record.
SET @PracticeID = 1
SET @VendorName = 'Life Line Medical Supply Co.'
SET @ImportNote = 'Initial import for customer 9380'

-- If the VendorImport record doesn't exist create it
IF NOT EXISTS (SELECT * FROM dbo.VendorImport WHERE VendorName = @VendorName AND Notes = @ImportNote)
BEGIN
	INSERT INTO dbo.VendorImport (VendorName, VendorFormat, DateCreated, Notes) 
	VALUES (@VendorName, 'CSV', GETDATE(), @ImportNote)
END

SET @VendorImportID = (SELECT VendorImportID FROM dbo.VendorImport WHERE VendorName = @VendorName AND Notes = @ImportNote)

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID

-- FIX bad insurance company data in import tables
UPDATE dbo._importInsuranceInfo
SET
	[INS CODE] = 'TX-Mcaid'
WHERE
	[INS CODE] = 'TX-Mdcaid'

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
	Phone,
	CompanyTextID,
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
SELECT 
	DISTINCT([INS COMPANY NAME])
	,[STREET1]
	,[CITY]
	,[STATE]
	,'USA'
	,REPLACE([ZIP], '-','')
	,REPLACE(REPLACE(REPLACE(REPLACE([PHONE], '-', ''), '(', ''), ')', ''), ' ', '')
	,[INS CODE]
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[ID]
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
FROM dbo._importInsuranceInfo

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
SELECT
	impIF.[INS PLAN NAME]
	,impIF.[STREET1]
	,impIF.[CITY]
	,impIF.[STATE]
	,'USA'
	,REPLACE(impIF.[ZIP], '-','')
	,REPLACE(REPLACE(REPLACE(REPLACE(impIF.[PHONE], '-', ''), '(', ''), ')', ''), ' ', '')
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[ID]
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo._importInsuranceInfo impIF
INNER JOIN dbo.InsuranceCompany ic ON impIF.[INS CODE] = ic.CompanyTextID
WHERE ic.VendorImportID = @VendorImportID
		
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Doctor
PRINT ''
PRINT 'Inserting records into Doctor ...'
INSERT INTO dbo.Doctor (
	PracticeID,
	Prefix,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	ActiveDoctor,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	[External],
	NPI,
	ProviderTypeID
)
SELECT
	@PracticeID
	,''
	,[REF PROVIDER FIRST NAME]
	,''
	,[REF PROVIDER LAST NAME]
	,''
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[ID]
	,@VendorImportID
	,1
	,[REF PROVIDER NPI]
	,1
FROM dbo._importReferringProviderInfo

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	ReferringPhysicianID,
	Prefix ,
	FirstName ,
	MiddleName ,
	LastName ,
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
	DOB ,
	SSN ,
	ResponsibleRelationshipToPatient,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	EmploymentStatus ,
	MedicalRecordNumber ,
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	SendEmailCorrespondence ,
	PhonecallRemindersEnabled
	)
SELECT 
	@PracticeID
	,rp.DoctorID
	,''
	,[pi].[FIRST NAME]
	,[pi].[MI]
	,[pi].[LAST NAME]
	,''
	,[pi].[STREET1]
	,[pi].[STREET2]
	,[pi].[CITY]
	,[pi].[STATE]
	,'USA'
	,LEFT(REPLACE([pi].[ZIP], '-', ''), 9)
	,[pi].[SEX]
	,'U'
	,REPLACE(REPLACE(REPLACE(REPLACE([pi].[PHONE], '-', ''), '(', ''), ')', ''), ' ', '')
	,CASE ISDATE([pi].[DOB]) WHEN 1 THEN [pi].[DOB] ELSE NULL END 
	,REPLACE([pi].[SS#], '-', '')
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'U'
	,[pi].[CHART #]
	,[ID] -- auto ID we added to temp table
	,@VendorImportID
	,1
	,1
	,1
	,1
FROM dbo._importPatientInfo [pi]
INNER JOIN dbo.Doctor rp ON [pi].[REFPRONPI] = rp.NPI

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- Patient Case (Depends on patient records already being imported, can only run after)
PRINT ''
PRINT 'Inserting records into PatientCase ...'
INSERT INTO dbo.PatientCase (
	PatientID,
	[Name],
	PayerScenarioID,
	ReferringPhysicianID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	PracticeID,
	VendorID,
	VendorImportID
)
SELECT
	realP.PatientID
	,'Default Case'
	,5 -- 'Commercial' (I was told this is a good default)
	,rp.DoctorID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,[pi].[ID]
	,@VendorImportID
FROM 
	dbo._importPatientInfo [pi]
INNER JOIN dbo.Patient realP ON [pi].ID = realP.VendorID AND realP.VendorImportID = @VendorImportID
INNER JOIN dbo.Doctor rp ON realP.ReferringPhysicianID = rp.DoctorID
WHERE
	realP.PracticeID = @PracticeID AND
	realP.VendorImportID = @VendorImportID -- This is very important as previous vendor imports can potentially contain VendorIDs that collide with this import. 
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Insurance Policy 1
PRINT ''
PRINT 'Inserting records into InsurancePolicy for primary insurance ...'
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
SELECT 
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,[pi].[POLICY1]
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,[pi].[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
FROM dbo._importPatientInfo [pi]
INNER JOIN dbo.PatientCase pc ON [pi].ID = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompany ic ON [pi].[INS1 CODE] = ic.CompanyTextID AND ic.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON ic.InsuranceCompanyID = icp.InsuranceCompanyID
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- Insurance Policy 2
PRINT ''
PRINT 'Inserting records into InsurancePolicy for secondary insurance ...'
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
SELECT 
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,2
	,[pi].[POLICY2]
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,[pi].[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
FROM dbo._importPatientInfo [pi]
INNER JOIN dbo.PatientCase pc ON [pi].ID = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompany ic ON [pi].[INS2 CODE] = ic.CompanyTextID AND ic.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON ic.InsuranceCompanyID = icp.InsuranceCompanyID
WHERE NOT([pi].[POLICY2] IS NULL) AND RTRIM(LTRIM([pi].[POLICY2])) <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT TRAN