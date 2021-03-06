USE superbill_9417_dev
--USE superbill_9417_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @VendorName VARCHAR(100)
DECLARE @ImportNote VARCHAR(100)

SET @PracticeID = 1
SET @VendorName = '	Tony Chuong MD'
SET @ImportNote = 'Initial import for customer 9417. FBID: 4841.'

-- If the VendorImport record doesn't exist create it
IF NOT EXISTS (SELECT * FROM dbo.VendorImport WHERE VendorName = @VendorName AND Notes = @ImportNote)
BEGIN
	INSERT INTO dbo.VendorImport (VendorName, VendorFormat, DateCreated, Notes) 
	VALUES (@VendorName, 'XLSX', GETDATE(), @ImportNote)
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


-- Employer
PRINT ''
PRINT 'Inserting records into Employer ...'
INSERT INTO dbo.Employers ( 
	EmployerName ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID
)
SELECT DISTINCT
	employer
	,GETDATE()
	,0
	,GETDATE()
	,0
FROM dbo.[_import_20120614_Patient]
WHERE 
	employer <> '' AND
	employer NOT IN (SELECT EmployerName FROM dbo.Employers)
	

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- Insurance Company
PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany (
	InsuranceCompanyName,
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
	primary_insurance
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,0
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
FROM dbo.[_import_20120614_Patient]
WHERE primary_insurance <> ''


PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Company Plan
PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan (
	PlanName,
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
	impIns.primary_insurance
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,0
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_import_20120614_Patient] impIns
INNER JOIN dbo.InsuranceCompany ic ON @VendorImportID = ic.VendorImportID AND impIns.primary_insurance = ic.InsuranceCompanyName
WHERE impIns.primary_insurance <> ''

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
	MaritalStatus,
	HomePhone,
	WorkPhone,
	MobilePhone,
	DOB,
	SSN,
	ResponsibleDifferentThanPatient,
	ResponsibleRelationshipToPatient,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	EmployerID,
	VendorID,
	VendorImportID,
	CollectionCategoryID,
	Active,
	SendEmailCorrespondence,
	PhonecallRemindersEnabled,
	EmergencyName,
	EmergencyPhone
	)
SELECT DISTINCT
	@PracticeID
	,''
	,impP.last_name
	,impP.first_name
	,impP.middle_name
	,''
	,impP.address_1
	,impP.address_2
	,impP.city
	,impP.state
	,'USA'
	,LEFT(REPLACE(impP.zip_code, '-', ''), 9)
	,CASE impP.sex
		WHEN 'Male' THEN 'M'
		WHEN 'Female' THEN 'F'
		ELSE 'U'
	END
	,CASE impP.marital_status
		WHEN 'Married' THEN 'M'
		WHEN 'Divorced' THEN 'D'
		WHEN 'Widowed' THEN 'W'
		WHEN 'Single' THEN 'S'
		ELSE 'U'
	END
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.home_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.work_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.mobile_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.DOB) WHEN 1 THEN impP.DOB ELSE NULL END 
	,REPLACE(impP.ss, '-', '')
	,CASE impP.guarantor_relation
		WHEN 'Self' THEN 0
		ELSE 1
	END
	,CASE impP.guarantor_relation
		WHEN 'Self' THEN 'S'
		WHEN 'Spouse' THEN 'U'
		WHEN 'Child' THEN 'C'
		ELSE 'O'
	END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,e.EmployerID
	,impP.patient_id -- I verified it's unique
	,@VendorImportID
	,1
	,1
	,0
	,1
	,impP.emergency_contact_name
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.emergency_contact_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
FROM dbo.[_import_20120614_Patient] impP
LEFT OUTER JOIN dbo.Employers e ON impP.employer = e.EmployerName
WHERE impP.first_name <> ''

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
	,impP.patient_id -- I verified it's unique
	,@VendorImportID
FROM 
	dbo.[_import_20120614_Patient] impP
INNER JOIN dbo.Patient realP ON 
	impP.patient_id = realP.VendorID
WHERE
	impP.first_name <> '' AND
	realP.PracticeID = @PracticeID AND
	realP.VendorImportID = @VendorImportID -- This is very important as previous vendor imports can potentially contain VendorIDs that collide with this import. 

	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Insurance Policy #1
PRINT ''
PRINT 'Inserting records into InsurancePolicy #1 ...'
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
	Copay,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,impP.primary_id#
	,impP.primary_group_#
	,CASE impP.guarantor_relation
		WHEN 'Self' THEN 'S'
		WHEN 'Child' THEN 'C'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O'
	END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impP.[co-pay]
	,@PracticeID
	,impP.patient_id -- Tie to patient and patient case. I verified it's unique. 
	,@VendorImportID
	,'Y'
FROM dbo.[_import_20120614_Patient] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.patient_id = pc.VendorID AND 
	@VendorImportID = pc.VendorImportID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	@VendorImportID = icp.VendorImportID AND
	impP.primary_insurance = icp.PlanName
WHERE impP.primary_insurance <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy #2
PRINT ''
PRINT 'Inserting records into InsurancePolicy #2 ...'
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
	VendorID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,2
	,impP.secondary_id_#
	,impP.secondary_group_number
	,CASE impP.guarantor_secondary_insured_relation
		WHEN 'Self' THEN 'S'
		WHEN 'Child' THEN 'C'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O'
	END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impP.patient_id -- Tie to patient and patient case. I verified it's unique. 
	,@VendorImportID
	,'Y'
FROM dbo.[_import_20120614_Patient] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.patient_id = pc.VendorID AND 
	@VendorImportID = pc.VendorImportID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	@VendorImportID = icp.VendorImportID AND
	impP.scondary_insurance = icp.PlanName
WHERE impP.scondary_insurance <> ''

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


-- Set Patient (DefaultServiceLocationID)
PRINT ''
PRINT 'Setting default service location for patients'
UPDATE dbo.Patient 
SET 
	DefaultServiceLocationID = (SELECT TOP 1 ServicelocationID FROM ServiceLocation) 
WHERE 
	@VendorImportID = VendorImportID AND 
	DefaultServiceLocationID IS NULL

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records updated'


-- Set Patient (PrimaryProviderID)
PRINT ''
PRINT 'Setting default primary care doctor for patients'
UPDATE dbo.Patient 
SET 
	PrimaryProviderID = (SELECT TOP 1 DoctorID FROM Doctor WHERE PracticeID = @PracticeID AND [External] = 0) 
WHERE 
	@VendorImportID = VendorImportID AND 
	PrimaryProviderID IS NULL

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records updated'



COMMIT TRAN