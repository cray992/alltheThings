USE superbill_9823_dev
--USE superbill_9823_prod
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
SET @PracticeID = 7
SET @VendorName = 'Practice Partners LLC'
SET @ImportNote = 'Initial import for customer 9823'

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
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'

-- Customer asked that we don't import insurance companies and plans but instead map incoming patient policies to existing insurance plans in DB.
-- In cases with no match we are to use the "Check/Change Insurance" co/plan (87)

-- Insurance Company Plan
IF NOT EXISTS (SELECT * FROM dbo.InsuranceCompanyPlan WHERE PlanName = 'Check/Change Insurance')
BEGIN
	PRINT ''
	PRINT 'Inserting default "Check/Change Insurance" plan record into InsuranceCompanyPlan ...'
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
		InsuranceCompanyName
		,AddressLine1
		,AddressLine2
		,City
		,State
		,Country
		,ZipCode
		,Phone
		,CreatedPracticeID
		,GETDATE()
		,0
		,GETDATE()
		,0
		,0
		,@VendorImportID
		,InsuranceCompanyID
	FROM dbo.InsuranceCompany
	WHERE InsuranceCompanyName = 'Check/Change Insurance'

	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'
END

-- Fetch the default ins plan ID
DECLARE @DefaultInsPlanID INT
SET @DefaultInsPlanID = (SELECT InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan WHERE PlanName = 'Check/Change Insurance')


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
	City ,
	[State] ,
	Country ,
	ZipCode ,
	Gender ,
	HomePhone ,
	WorkPhone ,
	DOB ,
	SSN ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	SendEmailCorrespondence ,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,''
	,impP.PFirstName
	,''
	,impP.PLastName
	,''
	,impP.[Demographics Address]
	,impP.[Demographics City]
	,LEFT(impP.[Demographics ST], 2)
	,'USA'
	,LEFT(REPLACE(impP.[Demographics Zip], '-', ''), 9)
	,impP.Sx
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.HPhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.WPhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.[DOB]) WHEN 1 THEN impP.[DOB] ELSE NULL END 
	,LEFT(REPLACE(impP.SSN, '-', ''), 9)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@VendorImportID
	,1
	,1
	,1
	,1
FROM dbo._importPatientPolicy1 impP

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
	,@VendorImportID
FROM 
	dbo.[_importPatientPolicy1] impP
INNER JOIN dbo.Patient realP ON 
	impP.PFirstName = realP.FirstName AND 
	impP.PLastName = realP.LastName AND 
	impP.[Demographics Address] = realP.AddressLine1 AND 
	LEFT(REPLACE(impP.SSN, '-', ''), 9) = realP.SSN
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
	VendorImportID,
	ReleaseOfInformation
)
SELECT DISTINCT
	pc.PatientCaseID
	,CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN @DefaultInsPlanID ELSE icp.InsuranceCompanyPlanID END
	,1
	,impP.PInsID
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,@VendorImportID
	,'Y'
FROM dbo.[_importPatientPolicy1] impP
INNER JOIN dbo.Patient realP ON 
	@VendorImportID = realP.VendorImportID AND
	impP.PFirstName = realP.FirstName AND 
	impP.PLastName = realP.LastName AND 
	impP.[Demographics Address] = realP.AddressLine1 AND 
	LEFT(REPLACE(impP.SSN, '-', ''), 9) = realP.SSN
INNER JOIN dbo.PatientCase pc ON 
	@VendorImportID = pc.VendorImportID AND
	realP.PatientID = pc.PatientID 
LEFT OUTER JOIN (
		SELECT MAX(InsuranceCompanyPlanID) AS InsuranceCompanyPlanID, PlanName FROM dbo.InsuranceCompanyPlan GROUP BY PlanName -- Had to do this because there are multiple plans with the same name
) icp ON impP.[Insurance Plan] = icp.PlanName


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
	VendorImportID,
	ReleaseOfInformation
)
SELECT DISTINCT
	pc.PatientCaseID
	,CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN @DefaultInsPlanID ELSE icp.InsuranceCompanyPlanID END
	,2
	,impP.SInsID
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,@VendorImportID
	,'Y'
FROM dbo.[_importPatientPolicy2] impP
INNER JOIN dbo.Patient realP ON 
	@VendorImportID = realP.VendorImportID AND
	impP.PFirstName = realP.FirstName AND 
	impP.PLastName = realP.LastName AND 
	impP.[Demographics Address] = realP.AddressLine1 AND 
	LEFT(REPLACE(impP.SSN, '-', ''), 9) = realP.SSN
INNER JOIN dbo.PatientCase pc ON 
	@VendorImportID = pc.VendorImportID AND
	realP.PatientID = pc.PatientID 
LEFT OUTER JOIN (
		SELECT MAX(InsuranceCompanyPlanID) AS InsuranceCompanyPlanID, PlanName FROM dbo.InsuranceCompanyPlan GROUP BY PlanName -- Had to do this because there are multiple plans with the same name
) icp ON impP.[Insurance Plan] = icp.PlanName


PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT TRAN