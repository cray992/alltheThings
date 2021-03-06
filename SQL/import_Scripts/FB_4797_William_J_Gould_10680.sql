USE superbill_10680_dev
--USE superbill_10680_prod
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
SET @VendorName = 'William J Gould DO PC'
SET @ImportNote = 'Initial import for customer 10860. FBID: 4797.'

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

DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientJournalNote records deleted'
DELETE FROM dbo.ServiceLocation WHERE PracticeID = @PRacticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ServiceLocation records deleted'
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


-- Service Locations
PRINT ''
PRINT 'Inserting records into ServiceLocation ...'
INSERT INTO dbo.ServiceLocation (
	PracticeID,
	Name,
	AddressLine1,
	AddressLine2,
	City,
	[State],
	Country,
	ZipCode,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Phone,
	VendorImportID,
	VendorID
)
SELECT DISTINCT
	@PracticeID
	,FacilityName
	,Address2 -- yeah these are in the wrong fields in the source data
	,Address1
	,City
	,State
	,'USA'
	,LEFT(REPLACE(ZipCode, '-',''), 9)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(OfficePhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@VendorImportID
	,Facility_UID
FROM dbo.[_importServiceLocation]


PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


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
	Fax,
	CompanyTextID,
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
	CarrierName
	,Address2 -- yeah these are in the wrong fields in the source data
	,Address1
	,City
	,State
	,'USA'
	,LEFT(REPLACE(ZipCode, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(EligibilityPhoneNumber, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(FaxNumber, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CarrierCode
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,Carrier_UID
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
	Fax,
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
	impIns.CarrierName
	,impIns.Address2
	,impIns.Address1
	,impIns.City
	,impIns.State
	,'USA'
	,LEFT(REPLACE(impIns.ZipCode, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.EligibilityPhoneNumber, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.FaxNumber, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,Carrier_UID
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_importInsurance] impIns
INNER JOIN dbo.InsuranceCompany ic ON 
	ic.VendorImportID = @VendorImportID AND
	impIns.Carrier_UID = ic.VendorID

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
	FaxNumber,
	ActiveDoctor,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Degree,
	VendorID,
	VendorImportID,
	[External],
	NPI,
	ProviderTypeID
)
SELECT
	@PracticeID
	,''
	,FirstName
	,''
	,LastName
	,''
	,Address2 -- yeah these are in the wrong fields in the source data
	,Address1
	,City
	,State
	,'USA'
	,LEFT(REPLACE(ZipCode, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(OfficePhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(Fax, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,Title
	,ReferringProvider_UID
	,@VendorImportID
	,1
	,NPINumber
	,1
FROM dbo.[_importReferringDoctor]


PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Doctor Referring
PRINT ''
PRINT 'Inserting records into Doctor ...'
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
	FaxNumber,
	ActiveDoctor,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Degree,
	TaxonomyCode,
	VendorID,
	VendorImportID,
	[External],
	NPI,
	ProviderTypeID
)
SELECT
	@PracticeID
	,''
	,FirstName
	,''
	,LastName
	,''
	,Address2
	,Address1
	,City
	,State
	,'USA'
	,LEFT(REPLACE(ZipCode, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(OfficePhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(Fax, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,Title
	,Taxonomy
	,PGProvider_UID
	,@VendorImportID
	,0
	,NPINumber
	,1
FROM dbo.[_importDoctor]


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
	HomePhone,
	WorkPhone,
	DOB,
	SSN,
	EmailAddress,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	MedicalRecordNumber,
	PrimaryCarePhysicianID,
	VendorID,
	VendorImportID,
	CollectionCategoryID,
	Active,
	SendEmailCorrespondence,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,''
	,impP.LastName
	,impP.FirstName
	,impP.MiddleName
	,''
	,impP.Address2
	,impP.Address1
	,impP.City
	,impP.[State]
	,'USA'
	,LEFT(REPLACE(impP.ZipCode, '-', ''), 9)
	,impP.Gender
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.HomePhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.OfficePhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.DOB) WHEN 1 THEN impP.DOB ELSE NULL END 
	,REPLACE(impP.SSN, '-', '')
	,Email
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impP.ChartNumber
	,provider.DoctorID
	,impP.Patient_UID -- I verified it's unique
	,@VendorImportID
	,1
	,1
	,1
	,1
FROM dbo.[_importPatient] impP
LEFT OUTER JOIN 
(
	SELECT DISTINCT DoctorID, FirstName, LastName, VendorID FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID AND [External] = 0
) provider ON 
	impP.ProviderFID = provider.VendorID
WHERE impP.FirstName <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Journal Note
PRINT ''
PRINT 'Inserting records into PatientJournalNote ...'
INSERT INTO dbo.PatientJournalNote (
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	PatientID,
	UserName,
	SoftwareApplicationID,
	NoteMessage
)
SELECT
	impJN.CreateDate
	,0
	,GETDATE()
	,0
	,realP.PatientID
	,impJN.CreateUser
	,'K'
	,impJN.Note
FROM 
	dbo.[_importJournalNote] impJN
INNER JOIN dbo.Patient realP ON 
	impJN.PatientFID = realP.VendorID
WHERE
	realP.PracticeID = @PracticeID AND
	realP.VendorImportID = @VendorImportID -- This is very important as previous vendor imports can potentially contain VendorIDs that collide with this import. 
	
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
	,impP.ChartNumber
	,impP.Patient_UID -- I verified it's unique
	,@VendorImportID
FROM 
	dbo.[_importPatient] impP
INNER JOIN dbo.Patient realP ON 
	impP.Patient_UID = realP.VendorID
WHERE
	impP.FirstName <> '' AND
	realP.PracticeID = @PracticeID AND
	realP.VendorImportID = @VendorImportID -- This is very important as previous vendor imports can potentially contain VendorIDs that collide with this import. 

	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Insurance Policy
PRINT ''
PRINT 'Inserting records into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	PolicyStartDate,
	PolicyEndDate,
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
	,CAST(SequenceNumber AS INT)+1
	,impP.SubscriberIDNumber
	,impP.GroupNumber
	,CASE ISDATE(impP.EffectiveStartDate) WHEN 1 THEN impP.EffectiveStartDate ELSE NULL END
	,CASE ISDATE(impP.EffectiveEndDate) WHEN 1 THEN impP.EffectiveEndDate ELSE NULL END
	,'O'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,CopayDollarAmount
	,@PracticeID
	,impP.PatientInsuranceCoverage_UID -- Tie to patient and patient case. I verified it's unique. 
	,@VendorImportID
	,'Y'
FROM dbo.[_importPolicies] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.PatientFID = pc.VendorID AND 
	@VendorImportID = pc.VendorImportID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	@VendorImportID = icp.VendorImportID AND
	impP.CarrierFID = icp.VendorID


PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




COMMIT TRAN