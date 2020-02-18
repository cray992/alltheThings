USE superbill_10799_dev
--USE superbill_10799_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 6 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))


DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM DBO.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST (@@ROWCOUNT AS VARCHAR(10)) + ' Doctors records deleted'



-- Insurance Company
PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany (
	InsuranceCompanyName,
	CreatedPracticeID,
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
	VendorID,
	VendorImportID,
	BillSecondaryInsurance ,
	EClaimsAccepts ,
	BillingFormID ,
	ReviewCode,
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
	[draftrevisedcombinedreferenceinsurance]
	,@PracticeID
	,[insstreet1]
	,[insstreet2]
	,[inscity]
	,LEFT([insstate], 2)
	,''
	,LEFT(REPLACE([inszip], '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([insphone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[combins]
	,@VendorImportID
	,0  -- BillSecondaryInsurance - bit
	,0 -- EClaimsAccepts - bit
	,13  -- BillingFormID - int
	,'R' -- ReviewCode
	,'CI' -- InsuranceProgramCode - char(2)
	,'C'  -- HCFADiagnosisReferenceFormatCode - char(1)
	,'D'  -- HCFASameAsInsuredFormatCode - char(1)
	,NULL  -- DefaultAdjustmentCode - varchar(10)
	,NULL  -- ReferringProviderNumberTypeID - int
	,1  -- NDCFormat - int
	,1 -- UseFacilityID - bit
	,'U'  -- AnesthesiaType - varchar(1)
	,18  -- InstitutionalBillingFormID - int,
	,13
FROM dbo._import_6_1_PatientDemos
WHERE combins
	NOT IN (SELECT VendorID FROM dbo.InsuranceCompany)
	AND [draftrevisedcombinedreferenceinsurance]  <> '0' AND
	[draftrevisedcombinedreferenceinsurance] IS NOT NULL
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'
/*
-- Insurance Company
PRINT ''
PRINT 'Inserting random into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany (
	InsuranceCompanyName,
	CreatedPracticeID,
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
	VendorID,
	VendorImportID,
	BillSecondaryInsurance ,
	EClaimsAccepts ,
	BillingFormID ,
	ReviewCode,
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
	[draftrevisedcombinedreferenceinsurance]
	,@PracticeID
	,[insstreet1]
	,[insstreet2]
	,[inscity]
	,LEFT([insstate], 2)
	,''
	,LEFT(REPLACE([inszip], '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([insphone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[combins]
	,@VendorImportID
	,0  -- BillSecondaryInsurance - bit
	,0 -- EClaimsAccepts - bit
	,13  -- BillingFormID - int
	,'R' -- ReviewCode
	,'CI' -- InsuranceProgramCode - char(2)
	,'C'  -- HCFADiagnosisReferenceFormatCode - char(1)
	,'D'  -- HCFASameAsInsuredFormatCode - char(1)
	,NULL  -- DefaultAdjustmentCode - varchar(10)
	,NULL  -- ReferringProviderNumberTypeID - int
	,1  -- NDCFormat - int
	,1 -- UseFacilityID - bit
	,'U'  -- AnesthesiaType - varchar(1)
	,18  -- InstitutionalBillingFormID - int,
	,13
FROM dbo._import_6_1_PatientDemos
WHERE combins = '379.16'
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

*/
-- Insurance Company Plan
PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan (
	PlanName,
	CreatedPracticeID,
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
	VendorID,
	VendorImportID,
	InsuranceCompanyID
)
SELECT DISTINCT 
	impIns.[inscodeplanname]
	,@PracticeID
	,[insstreet1]
	,[insstreet2]
	,[inscity]
	,LEFT([insstate], 2)
	,''
	,LEFT(REPLACE([inszip], '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([insphone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[CombIns]
	,@VendorImportID
	,ic.ICID
FROM dbo._import_6_1_PatientDemos impIns
Left JOIN 
	(
		SELECT MAX(InsuranceCompanyID) AS ICID, InsuranceCompanyName, VendorID
		FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID GROUP BY InsuranceCompanyName, VendorID
	) ic ON
	impIns.[draftrevisedcombinedreferenceinsurance] = ic.InsuranceCompanyName AND
	impIns.combins = ic.VendorID
WHERE
	impIns.[inscodeplanname] <> '' AND
	impIns.[inscodeplanname] IS NOT NULL 
	AND impIns.[combins] NOT IN (SELECT
		ISNULL(VendorID, '') FROM InsuranceCompanyPlan)
		
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	ReferringPhysicianID ,
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
	DOB ,
	MaritalStatus ,
	HomePhone ,
	SSN ,
	MedicalRecordNumber ,
	ResponsibleRelationshipToPatient,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	SendEmailCorrespondence ,
	PhonecallRemindersEnabled ,
	PrimaryCarePhysicianID  
	)
SELECT DISTINCT 
	@PracticeID
	,refP.DoctorID
	,''
	,impP.[lastname]
	,impP.[firstname]
	,impP.[mi]
	,''
	,impP.[street1]
	,impP.[street2]
	,impP.[city]
	,LEFT(impP.[state], 2)
	,''
	,LEFT(REPLACE(impP.[zip], '-', ''), 9)
	,CASE impP.[sex] WHEN 'F' THEN 'F' WHEN 'M' THEN 'M' ELSE 'U' END
	,impP.[dob]
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(impP.[ss], '-', ''), 9)
	,impP.[chart]
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impP.[chart] -- It's unique, we verified it, h00ray!!!!
	,@VendorImportID
	,1
	,1
	,0
	,1
	,pcp.DoctorID
FROM dbo._import_6_1_PatientDemos impP
LEFT JOIN dbo.Doctor refP ON
	impP.refprovidercode = refP.vendorID AND 
	refP.[external] = 1
LEFT JOIN dbo.Doctor pcp ON
	impP.providercode = pcp.VendorID	
WHERE 
	impP.coveragelev = 1 AND 
	impP.firstname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Case (Depends on patient records already being imported, can only run after)
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
SELECT 
	realP.PatientID
	,'Default Case'
	,5 -- 'Commercial' (I was told this is a good default)
	,'Created via data import'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impCase.[chart]
	,@VendorImportID
FROM 
	dbo.[_import_6_1_PatientDemos] impCase
LEFT JOIN dbo.Patient realP ON impCase.[chart] = realP.VendorID
WHERE
	realP.PracticeID = @PracticeID
	AND impCase.[draftrevisedcombinedreferenceinsurance] <> '0'
	AND impCase.coveragelev = 1
	AND impCase.draftrevisedcombinedreferenceinsurance <> 'NaN'
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy #1
PRINT ''
PRINT 'Inserting records into InsurancePolicy  1...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	PracticeID,
	VendorImportID,
	VendorID,
	ReleaseOfInformation	
)
SELECT 
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,impPI.[coveragelev]
	,impPI.[policyid]
	,impPI.[groupid]
	,CASE WHEN (impPI.firstname = impPI.[subfirstn] 
		AND impPI.lastname = impPI.[sublastn])
		THEN 'S'
		ELSE 'O'
	END	
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,@VendorImportID
	,impPI.[chart] + '_' + impPI.[coveragelev]
	,'Y'
FROM dbo.[_import_6_1_PatientDemos] impPI
LEFT JOIN dbo.PatientCase pc ON impPI.[chart] = PC.VendorID
	AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	(icp.VendorImportID = @VendorImportID AND impPI.combins = icp.VendorID) OR
	(icp.VendorImportID = (@VendorImportID - 1) AND impPI.combins = icp.VendorID)
WHERE 
	impPI.coveragelev = 1 AND
	impPI.[INSCODEPLANNAME] <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy #2
PRINT ''
PRINT 'Inserting records into InsurancePolicy  2...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	PracticeID,
	VendorImportID,
	VendorID,
	ReleaseOfInformation	
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,impPI.[coveragelev]
	,impPI.[policyid]
	,impPI.[groupid]
	,CASE WHEN (impPI.firstname = impPI.[subfirstn] 
		AND impPI.lastname = impPI.[sublastn])
		THEN 'S'
		ELSE 'O'
	END	
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,@VendorImportID
	,impPI.[chart] + '_' + impPI.[coveragelev]
	,'Y'
FROM dbo.[_import_6_1_PatientDemos] impPI
INNER JOIN dbo.PatientCase pc ON impPI.[chart] = PC.VendorID
	AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	(icp.VendorImportID = @VendorImportID AND impPI.combins = icp.VendorID) OR
	(icp.VendorImportID = (@VendorImportID-1) AND impPI.combins = icp.VendorID)
WHERE 
	impPI.coveragelev = 2 AND
	impPI.[INSCODEPLANNAME] <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



COMMIT 