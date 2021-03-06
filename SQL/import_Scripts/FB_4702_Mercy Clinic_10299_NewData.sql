USE superbill_10299_dev 
--USE superbill_10299_prod
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
SET @VendorName = 'Mercy Clinic'
SET @ImportNote = 'Initial import for customer 10299. FBID: 4702'

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
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
	
-- Table var for insurance info
DECLARE @Insurance TABLE (
	InsName VARCHAR(100),
	InsAddr1 VARCHAR(100),
	InsAddr2 VARCHAR(100),
	InsCity VARCHAR(100),
	InsState VARCHAR(100),
	InsZip VARCHAR(100)
)

INSERT INTO @Insurance
        ( InsName ,
          InsAddr1 ,
          InsAddr2 ,
          InsCity ,
          InsState ,
          InsZip
        )
SELECT DISTINCT [_primary_name], [primary_address], [primary_address_2], [primary_city], [primary_state], [primary_zip] FROM dbo.[_import_20120620_sheet1] WHERE [_primary_name] <> ''
UNION All
SELECT DISTINCT [_secondary_name], [secondary_address], [secondary_address_2], [secondary_city], [secondary_state], [secondary_zip] FROM dbo.[_import_20120620_sheet1] WHERE [_secondary_name] <> ''


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
	InsName
	,InsAddr1
	,InsAddr2
	,InsCity
	,LEFT(InsState, 2)
	,'USA'
	,LEFT(REPLACE(InsZip, '-',''), 9)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,0 -- Don't have a unique insurance code that is tied to patient, will have to join on name and address info
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
FROM @Insurance


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
	impIns.InsName
	,impIns.InsAddr1
	,impIns.InsAddr2
	,impIns.InsCity
	,LEFT(impIns.InsState, 2)
	,'USA'
	,LEFT(REPLACE(impIns.InsZip, '-',''), 9)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,0 -- we have nothing
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM @Insurance impIns
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorImportID = @VendorImportID AND
	impIns.InsName = ic.InsuranceCompanyName AND
	impIns.InsAddr1 = ic.AddressLine1 AND
	impIns.InsAddr2 = ic.AddressLine2 AND
	impIns.InsCity = ic.City AND
	LEFT(impIns.InsState, 2) = ic.State AND
	LEFT(REPLACE(impIns.InsZip, '-',''), 9) = ic.ZipCode

		
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
	Gender ,
	HomePhone ,
	DOB ,
	SSN ,
	ResponsibleDifferentThanPatient,
	ResponsibleRelationshipToPatient,
	ResponsibleFirstName,
	ResponsibleLastName,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	MedicalRecordNumber,
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
	,[last]
	,[_first_]
	,[_middle]
	,''
	,[_address1]
	,[_address2]
	,[_city]
	,LEFT([_state], 2)
	,'USA'
	,LEFT(REPLACE([_zip], '-', ''), 9)
	,CASE [_gender] WHEN 'M' THEN 'M' WHEN 'F' THEN 'F' ELSE 'U' END
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE([_dob]) WHEN 1 THEN [_dob] ELSE NULL END 
	,LEFT(REPLACE([_ssn], '-', ''), 9)
	,CASE
		WHEN [_guarantor_last] = '' THEN 0
		ELSE 1
	END
	,CASE
		WHEN [_guarantor_last] = '' THEN 'S'
		ELSE 'O'
	END
	,[_guarantor_first]
	,[_guarantor_last]
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[_patient_id]
	,[ID]
	,@VendorImportID
	,1
	,1
	,0
	,1
FROM dbo.[_import_20120620_sheet1]
WHERE [last] <> ''

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
	CaseNumber,
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
	,[_patient_id]
	,impCase.[ID] -- Verified unique
	,@VendorImportID
FROM 
	dbo.[_import_20120620_sheet1] impCase
INNER JOIN dbo.Patient realP ON impCase.ID = realP.VendorID AND realP.VendorImportID = @VendorImportID
WHERE
	impCase.[last] <> '' AND
	realP.VendorImportID = @VendorImportID -- This is very important as previous vendor imports can potentially contain VendorIDs that collide with this import. 
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Insurance Policy #1
PRINT ''
PRINT 'Inserting records into InsurancePolicy #1...'
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
	,impPC.[primary_policy]
	,impPC.[primary_group]
	,CASE
		WHEN impPC.[_guarantor_last] = '' THEN 'S'
		ELSE 'O'
	END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impPC.[ID] -- unique id provided by customer
	,@VendorImportID
	,'Y'
FROM dbo.[_import_20120620_sheet1] impPC
INNER JOIN dbo.PatientCase pc ON impPC.[ID] = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.[_primary_name] = icp.PlanName AND
	impPC.[primary_address] = icp.AddressLine1 AND
	impPC.[primary_address_2] = icp.AddressLine2 AND
	impPC.[primary_city] = icp.City AND
	LEFT(impPC.[primary_state], 2) = icp.State AND
	LEFT(REPLACE(impPC.[primary_zip], '-',''), 9) = icp.ZipCode
WHERE
	pc.VendorImportID = @VendorImportID AND
	impPC.[_primary_name] <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy #2
PRINT ''
PRINT 'Inserting records into InsurancePolicy #2...'
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
	,impPC.[secondary_policy]
	,impPC.[secondary_group]
	,CASE
		WHEN impPC.[_guarantor_last] = '' THEN 'S'
		ELSE 'O'
	END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impPC.[ID] -- unique id provided by customer
	,@VendorImportID
	,'Y'
FROM dbo.[_import_20120620_sheet1] impPC
INNER JOIN dbo.PatientCase pc ON impPC.[ID] = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.[_secondary_name] = icp.PlanName AND
	impPC.[secondary_address] = icp.AddressLine1 AND
	impPC.[secondary_address_2] = icp.AddressLine2 AND
	impPC.[secondary_city] = icp.City AND
	LEFT(impPC.[secondary_state], 2) = icp.State AND
	LEFT(REPLACE(impPC.[secondary_zip], '-',''), 9) = icp.ZipCode
WHERE
	pc.VendorImportID = @VendorImportID AND
	impPC.[_secondary_name] <> ''

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