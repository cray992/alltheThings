USE superbill_10846_dev
--USE superbill_10846_prod
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
SET @VendorName = 'LA Clin Soleil Urgent'
SET @ImportNote = 'Initial import for customer 10846'

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
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
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
SELECT 
	DISTINCT
	[INS_COMPANY_NAME]
	,[STREET1]
	,[STREET2]
	,[CITY]
	,LEFT([STATE], 2)
	,'USA'
	,LEFT(REPLACE([ZIP], '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([PHONE], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[INS_CODE]
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
FROM dbo.[_import_20120622_Insurance]

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
SELECT
	impIF.[INS_COMPANY_NAME]
	,impIF.[STREET1]
	,impIF.[STREET2]
	,impIF.[CITY]
	,LEFT(impIF.[STATE], 2)
	,'USA'
	,LEFT(REPLACE(impIF.[ZIP], '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIF.[PHONE], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[INS_CODE] -- Vendor provided insurance identifier, (not unique DOH!, but cases that are linked to patiens are unique)
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_import_20120622_Insurance] impIF
INNER JOIN dbo.InsuranceCompany ic ON impIF.[INS_CODE] = ic.VendorID
WHERE ic.VendorImportID = @VendorImportID
		
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
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
SELECT DISTINCT
	@PracticeID
	,''
	,impP.[FIRST_NAME]
	,impP.[MI]
	,impP.[LAST_NAME]
	,''
	,impP.[STREET1]
	,impP.[STREET2]
	,impP.[CITY]
	,LEFT(impP.[STATE], 2)
	,'USA'
	,LEFT(REPLACE(impP.[ZIP], '-', ''), 9)
	,impP.[SEX]
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[PHONE], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.[DOB]) WHEN 1 THEN impP.[DOB] ELSE NULL END 
	,LEFT(REPLACE(impP.[SS#], '-', ''), 9)
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'U'
	,impP.[CHART_#]
	,impP.ID
	,@VendorImportID
	,1
	,1
	,1
	,1
FROM dbo.[_import_20120622_Patient] impP

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- Patient Case (Depends on patient records already being imported, can only run after)
PRINT ''
PRINT 'Inserting records into PatientCase ...'
INSERT INTO dbo.PatientCase (
	PatientID,
	[Name],
	PayerScenarioID,
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
	,5 -- 'Commercial' (I was told this is a good default)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impP.ID
	,@VendorImportID
FROM 
	dbo.[_import_20120622_Patient] impP
INNER JOIN dbo.Patient realP ON 
	impP.ID = realP.VendorID AND 
	realP.VendorImportID = @VendorImportID
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
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,LEFT(impP.[POLICY1], 32)
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impP.ID
	,@VendorImportID
	,'Y'
FROM dbo.[_import_20120622_Patient] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.ID = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN 
(
	SELECT DISTINCT MAX(InsuranceCompanyPlanID) AS 'InsuranceCompanyPlanID', VendorID FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID GROUP BY VendorID
) icp ON impP.INS1_Code = icp.VendorID
WHERE NOT(impP.[POLICY1] IS NULL) AND impP.[POLICY1] <> ''
	
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
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,2
	,LEFT(impP.[POLICY2], 32)
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impP.ID
	,@VendorImportID
	,'Y'
FROM dbo.[_import_20120622_Patient] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.ID = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN 
(
	SELECT DISTINCT MAX(InsuranceCompanyPlanID) AS 'InsuranceCompanyPlanID', VendorID FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID GROUP BY VendorID
) icp ON impP.INS1_Code = icp.VendorID
WHERE NOT(impP.[POLICY2] IS NULL) AND RTRIM(LTRIM(impP.[POLICY2])) <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Set cases without policies to self-pay (11)
PRINT ''
PRINT 'Setting cases without policies to Self-Pay'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11 
WHERE 
	@VendorImportID = VendorImportID AND 
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy) AND
	PayerScenarioID <> 11
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records updated'


COMMIT TRAN