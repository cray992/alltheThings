USE superbill_9698_dev 
--USE superbill_9698_prod
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
SET @VendorName = 'Mahesh Patel MD PA'
SET @ImportNote = 'Initial import for customer 9698. FBID: 4891'

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
	InsZip VARCHAR(100),
	InsPhone VARCHAR(100)
)

INSERT INTO @Insurance
        ( InsName ,
          InsAddr1 ,
          InsAddr2 ,
          InsCity ,
          InsState ,
          InsZip ,
          InsPhone
        )
SELECT DISTINCT primary_insurance, insurance_address_1, insurance_address_2, primary_insurance_city, primary_insurance_state, [primary_ins._zip], [ins._phone] FROM dbo.[_import_20120618_maheshpatel] WHERE primary_insurance <> ''
UNION All
SELECT DISTINCT secondary_insurance, [2nd_insurance_address_1], [2nd_insurance_address_2], [2nd_ins._city], [2nd_ins._state], [2nd_ins._zip], [2nd_ins_phone] FROM dbo.[_import_20120618_maheshpatel] WHERE secondary_insurance <> ''


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
SELECT DISTINCT
	InsName
	,InsAddr1
	,InsAddr2
	,InsCity
	,LEFT(InsState, 2)
	,'USA'
	,LEFT(REPLACE(InsZip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(InsPhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,0 -- Don't have a uniquen insurance code that is tied to patient, will have to join on name and address info
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
SELECT DISTINCT 
	impIns.InsName
	,impIns.InsAddr1
	,impIns.InsAddr2
	,impIns.InsCity
	,LEFT(impIns.InsState, 2)
	,'USA'
	,LEFT(REPLACE(impIns.InsZip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.InsPhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,0 -- we got nothing
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
	LEFT(REPLACE(impIns.InsZip, '-',''), 9) = ic.ZipCode AND
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.InsPhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10) = ic.Phone

		
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
	,last_name
	,first_name
	,middle_initial
	,''
	,patient_address_1
	,patient_address_2
	,patient_city
	,LEFT(patient_state, 2)
	,'USA'
	,LEFT(REPLACE(patient_zip_code, '-', ''), 9)
	,gender
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(patient_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(date_of_birth) WHEN 1 THEN date_of_birth ELSE NULL END 
	,LEFT(REPLACE(ssn, '-', ''), 9)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,medical_record_number
	,medical_record_number -- It's unique I verified
	,@VendorImportID
	,1
	,1
	,0
	,1
FROM dbo.[_import_20120618_maheshpatel]
WHERE first_name <> ''

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
	,medical_record_number
	,medical_record_number -- Verified unique
	,@VendorImportID
FROM 
	dbo.[_import_20120618_maheshpatel] impCase
INNER JOIN dbo.Patient realP ON impCase.medical_record_number = realP.VendorID AND realP.VendorImportID = @VendorImportID
WHERE
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
	,impPC.primary_policy
	,impPC.primary_group
	,'O'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impPC.medical_record_number -- unique id provided by customer
	,@VendorImportID
	,'Y'
FROM dbo.[_import_20120618_maheshpatel] impPC
INNER JOIN dbo.PatientCase pc ON impPC.medical_record_number = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.primary_insurance = icp.PlanName AND
	impPC.insurance_address_1 = icp.AddressLine1 AND
	impPC.insurance_address_2 = icp.AddressLine2 AND
	impPC.primary_insurance_city = icp.City AND
	LEFT(impPC.primary_insurance_state, 2) = icp.State AND
	LEFT(REPLACE(impPC.[primary_ins._zip], '-',''), 9) = icp.ZipCode AND
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impPC.[ins._phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10) = icp.Phone
WHERE
	pc.VendorImportID = @VendorImportID AND
	impPC.primary_insurance <> ''

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
	,impPC.[2nd_ins_policy]
	,impPC.[2nd_ins_group]
	,'O'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impPC.medical_record_number -- unique id provided by customer
	,@VendorImportID
	,'Y'
FROM dbo.[_import_20120618_maheshpatel] impPC
INNER JOIN dbo.PatientCase pc ON impPC.medical_record_number = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.secondary_insurance = icp.PlanName AND
	impPC.[2nd_insurance_address_1] = icp.AddressLine1 AND
	impPC.[2nd_insurance_address_2] = icp.AddressLine2 AND
	impPC.[2nd_ins._city] = icp.City AND
	LEFT(impPC.[2nd_ins._state], 2) = icp.State AND
	LEFT(REPLACE(impPC.[2nd_ins._zip], '-',''), 9) = icp.ZipCode AND
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impPC.[2nd_ins_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10) = icp.Phone
WHERE
	pc.VendorImportID = @VendorImportID AND
	impPC.secondary_insurance <> ''

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