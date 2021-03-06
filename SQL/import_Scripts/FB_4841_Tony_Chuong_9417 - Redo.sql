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
	DefaultServiceLocationID,
	PrimaryCarePhysicianID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
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
	,impP.[address_1:]
	,impP.[address_2:]
	,impP.[city:]
	,impP.state
	,'USA'
	,LEFT(REPLACE(impP.zip_code, '-', ''), 9)
	,CASE impP.sex
		WHEN 'Male' THEN 'M'
		WHEN 'Female' THEN 'F'
		ELSE 'U'
	END
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.home, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.work, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.mobile, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
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
	,sl.ServiceLocationID
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impP.patient_id -- I verified it's unique
	,@VendorImportID
	,1
	,1
	,0
	,1
	,impP.[emergency_contact]
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[emergency_contact_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
FROM dbo.[_import_20120626_Patient_1] impP
LEFT OUTER JOIN dbo.ServiceLocation sl ON impP.facility = sl.Name
WHERE impP.last_name <> ''

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
	dbo.[_import_20120626_Patient_1] impP
INNER JOIN dbo.Patient realP ON 
	impP.patient_id = realP.VendorID AND
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
	,impP.[primary_id]
	,impP.[primary_group]
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
	,impP.patient_id -- Tie to patient and patient case. I verified it's unique. 
	,@VendorImportID
	,'Y'
FROM dbo.[_import_20120626_Patient_1] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.patient_id = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	impP.[pimary_insurance] = icp.PlanName AND
	icp.VendorImportID = @VendorImportID AND
	icp.CreatedPracticeID = @PracticeID
WHERE impP.[pimary_insurance] <> ''

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
	,impP.[secondary_id:]
	,impP.[secondary_group_number]
	,'O'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impP.patient_id -- Tie to patient and patient case. I verified it's unique. 
	,@VendorImportID
	,'Y'
FROM dbo.[_import_20120626_Patient_1] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.patient_id = pc.VendorID AND 
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