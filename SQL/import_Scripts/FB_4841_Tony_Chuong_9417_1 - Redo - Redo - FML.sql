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
SET @VendorImportID = 1 -- Since this is a redo of an existing import, re-using that same ID

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'


-- Employer
PRINT ''
PRINT 'Inserting records into Employers ...'
INSERT INTO dbo.Employers ( 
	EmployerName ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID
)
SELECT DISTINCT
	employer, -- EmployerName - varchar(128)
	GETDATE(), -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE(), -- ModifiedDate - datetime
	0 -- ModifiedUserID - int
FROM dbo.[_import_2_1_patientstatistics4]
WHERE employer NOT IN (SELECT EmployerName FROM dbo.Employers)

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
	PrimaryCarePhysicianID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	EmploymentStatus,
	PrimaryProviderID,
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
	,impP.middle
	,''
	,impP.address
	,impP.city
	,impP.state
	,'USA'
	,LEFT(REPLACE(impP.zip, '-', ''), 9)
	,CASE impP.sex
		WHEN 'Male' THEN 'M'
		WHEN 'Female' THEN 'F'
		ELSE 'U'
	END
	,CASE impP.[status]
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
	,CASE impP.guarantor
		WHEN 'Self' THEN 0
		ELSE 1
	END
	,CASE impP.guarantor
		WHEN 'Self' THEN 'S'
		ELSE 'O'
	END
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,CASE WHEN employer <> '' THEN 'E' ELSE 'U' END
	,1
	,e.EmployerID
	,impP.pid -- I verified it's unique
	,@VendorImportID
	,1
	,1
	,0
	,1
	,impP.[emergency_contact]
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[emergency_contact_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
FROM dbo.[_import_2_1_patientstatistics4] impP
LEFT OUTER JOIN dbo.Employers e ON impP.employer = e.EmployerName
WHERE 
	impP.last_name <> ''

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
	,impP.pid -- I verified it's unique
	,@VendorImportID
FROM 
	dbo.[_import_2_1_patientstatistics4] impP
INNER JOIN dbo.Patient realP ON 
	impP.pid = realP.VendorID AND
	realP.VendorImportID = @VendorImportID AND
	realP.PracticeID = @PracticeID
WHERE
	impP.last_name <> '' 

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
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,impP.[primary_id_#]
	,impP.[primary_group_#]
	,CASE impP.[primary_insured_relation]
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
	,impP.pid -- Tie to patient and patient case. I verified it's unique. 
	,@VendorImportID
	,'Y'
FROM dbo.[_import_2_1_patientstatistics4] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.pid = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	impP.[primary_ins] = icp.PlanName AND
	icp.VendorImportID = @VendorImportID AND
	icp.CreatedPracticeID = @PracticeID
WHERE impP.[primary_ins] <> ''

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
	,impP.[secondary_id#]
	,impP.[secondary_group#]
	,'O'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impP.pid -- Tie to patient and patient case. I verified it's unique. 
	,@VendorImportID
	,'Y'
FROM dbo.[_import_2_1_patientstatistics4] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.pid = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	impP.[secondary_insurance] = icp.PlanName AND
	icp.VendorImportID = @VendorImportID AND
	icp.CreatedPracticeID = @PracticeID
WHERE impP.[secondary_insurance] <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Set cases without policies to self-pay (11)
PRINT ''
PRINT 'Setting cases without policies to Self-Pay'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11 
WHERE 
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy) AND
	VendorImportID = @VendorImportID AND 
	PayerScenarioID <> 11 AND
	PracticeID = @PracticeID
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records updated'


COMMIT TRAN