--USE superbill_10799_dev
USE superbill_10799_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 5 -- Vendor import record created through import tool

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
	[draft-revised_combined_reference_insurance]
	,@PracticeID
	,[ins_street1]
	,[ins_street2]
	,[ins_city]
	,LEFT([ins_state], 2)
	,''
	,LEFT(REPLACE([ins_zip], '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([ins_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
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
FROM dbo._import_5_1_PatientDemos
WHERE [draft-revised_combined_reference_insurance] 
	NOT IN (SELECT InsuranceCompanyName FROM dbo.InsuranceCompany)
	AND [draft-revised_combined_reference_insurance]  <> '0' AND
	[draft-revised_combined_reference_insurance] IS NOT NULL
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


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
	impIns.[ins_code-plan_name]
	,@PracticeID
	,[ins_street1]
	,[ins_street2]
	,[ins_city]
	,LEFT([ins_state], 2)
	,''
	,LEFT(REPLACE([ins_zip], '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([ins_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[CombIns]
	,@VendorImportID
	,ic.ICID
FROM dbo._import_5_1_PatientDemos impIns
Left JOIN 
	(
		SELECT MAX(InsuranceCompanyID) AS ICID, InsuranceCompanyName FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID GROUP BY InsuranceCompanyName
	) ic ON
	impIns.[draft-revised_combined_reference_insurance] = ic.InsuranceCompanyName
WHERE
	impIns.[ins_code-plan_name] <> '' AND
	impIns.[ins_code-plan_name] IS NOT NULL AND
	impIns.[ins_code-plan_name] NOT IN (SELECT
		ISNULL(PlanName, '') FROM InsuranceCompanyPlan)
		
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

IF NOT EXISTS(SELECT 1 FROM dbo.Doctor WHERE FirstName = 'Donald' AND LastName = 'Cady')
begin
INSERT INTO dbo.Doctor 
    (
    PracticeID,
	Prefix,
	LastName,
	FirstName,
	MiddleName,
	Suffix,
	ActiveDoctor,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	[External],
	Degree,
	VendorID,
	VendorImportID,
	ProviderTypeID
        )
VALUES  ( 1
	,''
	,'Cady'
    ,'Donald'
    ,''
	,''
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,0
	,'MD'
	,1204
	,@VendorImportID
	,1
        ) 
  end


-- Doctor Referring
PRINT ''
PRINT 'Inserting records into Doctor (Referring) ...'
INSERT INTO dbo.Doctor ( 
	PracticeID,
	Prefix,
	LastName,
	FirstName,
	MiddleName,
	Suffix,
	AddressLine1,
	AddressLine2,
	City,
	[STATE],
	Country,
	ZipCode,
	WorkPhone,
	FaxNumber,
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
	,ref_Doctor_Lname
    ,ref_Doctor_Fname
    ,ref_Doctor_Mi
	,''
	,[ref_provider_addr1]
	,[ref_provider_addr2]
	,[ref_provider_city]
	,LEFT(ref_provider_state, 2)
	,''
	,LEFT(REPLACE(ref_provider_zip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([ref_provider_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([ref_provider_fax], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,ref_provider_code
	,@VendorImportID
	,1
	,[ref_provider_-_npi]
	,1
FROM dbo.[_import_4_1_ReferringProviders]

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
	,impP.[last_name]
	,impP.[first_name]
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
	,LEFT(REPLACE(impP.[ss#], '-', ''), 9)
	,impP.[chart_#]
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impP.[chart_#] -- It's unique, we verified it, h00ray!!!!
	,@VendorImportID
	,1
	,1
	,0
	,1
	,pcp.DoctorID
FROM dbo._import_5_1_PatientDemos impP
LEFT JOIN dbo.Doctor refP ON
	impP.ref_provider_code = refP.vendorID AND 
	refP.[external] = 1
LEFT JOIN dbo.Doctor pcp ON
	impP.provider_code = pcp.VendorID	
WHERE 
	impP.coverage_lev = 1	



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
SELECT DISTINCT
	realP.PatientID
	,'Default Case'
	,5 -- 'Commercial' (I was told this is a good default)
	,'Created via data import'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impCase.[chart_#]
	,@VendorImportID
FROM 
	dbo.[_import_5_1_PatientDemos] impCase
LEFT JOIN dbo.Patient realP ON impCase.[chart_#] = realP.VendorID
WHERE
	realP.PracticeID = @PracticeID
	AND impCase.[draft-revised_combined_reference_insurance] <> '0'
	AND impCase.coverage_lev = 1
	
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
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,impPI.[coverage_lev]
	,impPI.[policy_id]
	,impPI.[group_id]
	,CASE WHEN (impPI.first_name = impPI.[sub_firstn] 
		AND impPI.last_name = impPI.[sub_lastn])
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
	,impPI.[chart_#] + '_' + impPI.[coverage_lev]
	,'Y'
FROM dbo.[_import_5_1_PatientDemos] impPI
INNER JOIN dbo.PatientCase pc ON impPI.[chart_#] = PC.VendorID
	AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND impPI.combins = icp.VendorID
WHERE 
	impPI.coverage_lev = 1 AND
	impPI.[INS_CODE-PLAN_NAME] <> ''

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
	,impPI.[coverage_lev]
	,impPI.[policy_id]
	,impPI.[group_id]
	,CASE WHEN (impPI.first_name = impPI.[sub_firstn] 
		AND impPI.last_name = impPI.[sub_lastn])
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
	,impPI.[chart_#] + '_' + impPI.[coverage_lev]
	,'Y'
FROM dbo.[_import_5_1_PatientDemos] impPI
INNER JOIN dbo.PatientCase pc ON impPI.[chart_#] = PC.VendorID
	AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND impPI.combins = icp.VendorID
WHERE 
	impPI.coverage_lev = 2 AND
	impPI.[INS_CODE-PLAN_NAME] <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Insurance Policy #3
PRINT ''
PRINT 'Inserting records into InsurancePolicy  3...'
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
	,impPI.[coverage_lev]
	,impPI.[policy_id]
	,impPI.[group_id]
	,CASE WHEN (impPI.first_name = impPI.[sub_firstn] 
		AND impPI.last_name = impPI.[sub_lastn])
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
	,impPI.[chart_#] + '_' + impPI.[coverage_lev]
	,'Y'
FROM dbo.[_import_5_1_PatientDemos] impPI
INNER JOIN dbo.PatientCase pc ON impPI.[chart_#] = PC.VendorID
	AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND impPI.combins = icp.VendorID
WHERE 
	impPI.coverage_lev = 3 AND
	impPI.[INS_CODE-PLAN_NAME] <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT TRAN

