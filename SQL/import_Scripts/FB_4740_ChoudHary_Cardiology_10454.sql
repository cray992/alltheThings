USE superbill_10454_dev
--USE superbill_10454_prod
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
SET @VendorName = 'Choudhary Cardiology'
SET @ImportNote = 'Initial import for customer 10454. FBID: 4740.'

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
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'


-- Insurance Company
PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany (
	InsuranceCompanyName,
	Notes,
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
	[INS COMPANY NAME]
	,NOTES
	,STREET1
	,STREET2
	,CITY
	,STATE
	,'USA'
	,LEFT(REPLACE(ZIP, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(PHONE, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[INS CODE] -- use their id as the vendorid, (I checked and it is unique)
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
FROM dbo.[_importInsurance]

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
	Notes,
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
	impIns.[INS PLAN NAME]
	,impIns.STREET1
	,impIns.STREET2
	,impIns.CITY
	,impIns.STATE
	,'USA'
	,LEFT(REPLACE(impIns.ZIP, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.PHONE, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,impIns.NOTES
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impIns.[INS CODE]
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_importInsurance] impIns
INNER JOIN dbo.InsuranceCompany ic ON 
	@VendorImportID  = ic.VendorImportID AND
	impIns.[INS CODE] = ic.VendorID
		
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Doctor Referring
PRINT ''
PRINT 'Inserting records into Doctor (Referring) ...'
INSERT INTO dbo.Doctor (
	PracticeID,
	Prefix,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	AddressLine1,
	AddressLine2,
	City,
	STATE,
	Country,
	ZipCode,
	WorkPhone,
	ActiveDoctor,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Degree,
	VendorID,
	VendorImportID,
	FaxNumber,
	[External],
	NPI,
	ProviderTypeID
)
SELECT
	@PracticeID
	,''
	,[FirstName]
	,MiddleInitial
	,[LastName]
	,''
	,[Address1]
	,[Address2]
	,City
	,State
	,'USA'
	,LEFT(REPLACE(ZipCode, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(Phone1, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[Credentials]
	,[ID]
	,@VendorImportID
	,CASE Phone2Type
		WHEN 'Fax' THEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(Phone2, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		ELSE NULL
	END
	,1
	,LEFT(NPI, 10)
	,1
FROM dbo.[_importReferringDoctor]

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	ReferringPhysicianID,
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
	MaritalStatus ,
	HomePhone ,
	WorkPhone,
	DOB ,
	SSN ,
	ResponsibleRelationshipToPatient,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	EmploymentStatus ,
	PrimaryCarePhysicianID,
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	SendEmailCorrespondence ,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,DoctorPri.DoctorID
	,''
	,impP.[LAST NAME]
	,impP.[FIRST NAME]
	,impP.MI
	,''
	,impP.STREET1
	,impP.STREET2
	,impP.CITY
	,impP.STATE
	,'USA'
	,LEFT(REPLACE(ZIP, '-', ''), 9)
	,impP.SEX 
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.PHONE1, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.PHONE2, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.DOB) WHEN 1 THEN impP.DOB ELSE NULL END 
	,REPLACE(impP.SS#, '-', '')
	,'O'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'U'
	,DoctorRef.DoctorID
	,0 -- Just puttin in 0 because their source data doesn't have a unique identifier per "Patient". Chart # I found out is acceidentally reused across multiple patients, and [ID], is unique per row, but each patient has multiple rows.
	,@VendorImportID
	,1
	,1
	,1
	,1
FROM dbo.[_importPatient] impP
LEFT OUTER JOIN dbo.Doctor DoctorRef ON impP.REFPRONPI = DoctorRef.NPI AND DoctorRef.[External] = 1
LEFT OUTER JOIN dbo.Doctor DoctorPri ON impP.REFPRONPI = DoctorPri.NPI AND DoctorPri.[External] = 0

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
	,impP.[ID]
	,@VendorImportID
FROM 
	dbo.[_importPatient] impP
INNER JOIN dbo.Patient realP ON
	@VendorImportID = realP.VendorImportID AND
	@PracticeID = realP.PracticeID AND
	impP.[FIRST NAME] = realP.FirstName AND
	impP.[LAST NAME] = realP.LastName AND
	impP.MI = realP.MiddleName AND
	impP.STREET1 = realP.AddressLine1 AND
	impP.STREET2 = realP.AddressLine2 AND
	impP.CITY = realP.City AND
	impP.STATE = realP.State AND
	LEFT(REPLACE(impP.ZIP, '-', ''), 9) = realP.ZipCode AND
	impP.SS# = realP.SSN AND
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.PHONE1, '-', ''), '(', ''), ')', ''), ' ', ''), 10) = realP.HomePhone AND
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.PHONE2, '-', ''), '(', ''), ')', ''), ' ', ''), 10) = realP.WorkPhone AND
	impP.SEX = realP.Gender
	

	
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
	ReleaseOfInformation,
	HolderPrefix,
	HolderSuffix,
	HolderFirstName,
	HolderMiddleName,
	HolderLastName,
	HolderDOB,
	HolderGender,
	HolderAddressLine1,
	HolderAddressLine2,
	HolderCity,
	HolderState,
	HolderCountry,
	HolderZipCode,
	HolderPhone
)
SELECT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,LEFT(impP.POLICY1, 32)
	,LEFT(impP.GROUP1, 32)
	,CASE impP.INSUREDSAMEASPATIENT
		WHEN '1' THEN 'S' 
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impP.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,LEFT(impP.INSUREDFIRST, 64)
	,LEFT(impP.INSUREDMI, 64)
	,LEFT(impP.INSUREDLAST, 64)
	,CASE ISDATE(impP.INSUREDDOB) WHEN 1 THEN impP.INSUREDDOB ELSE NULL END 
	,LEFT(impP.INSUREDSEX, 1)
	,LEFT(impP.[INSUREDADDRESS!], 256)
	,LEFT(impP.INSUREDADDRESS2, 256)
	,LEFT(impP.INSUREDCITY, 64)
	,LEFT(impP.INSUREDSTATE, 2)
	,'USA'
	,LEFT(REPLACE(impP.INSUREDZIP, '-', ''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.INSUREDPHONE, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
FROM dbo.[_importPatient] impP
INNER JOIN dbo.PatientCase pc ON impP.[ID] = pc.VendorID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON impP.[INS1 CODE] = icp.VendorID
WHERE
	pc.VendorImportID = @VendorImportID AND
	icp.VendorImportID = @VendorImportID

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT TRAN