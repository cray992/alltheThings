USE superbill_11418_dev 
--USE superbill_11418_prod
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
SET @VendorName = 'Andrew K Roorda M.D.'
SET @ImportNote = 'Initial import for customer 11418. FBID: 4894'

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


DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCaseDate records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient journal notes records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM dbo.ServiceLocation WHERE  PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ServiceLocation records deleted'

-- Service Locations
PRINT ''
PRINT 'Inserting records into ServiceLocation ...'
INSERT INTO dbo.ServiceLocation (
	PracticeID ,
	Name ,
	AddressLine1 ,
	AddressLine2 ,
	City ,
	State ,
	Country ,
	ZipCode ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	BillingName ,
	Phone ,
	PhoneExt ,
	FaxPhone ,
	FaxPhoneExt ,
	VendorImportID ,
	VendorID
)
SELECT DISTINCT
	@PracticeID
	,defaultservicelocationname
	,defaultservicelocationnameaddressline1
	,defaultservicelocationnameaddressline2
	,defaultservicelocationnamecity
	,defaultservicelocationnamestate
	,defaultservicelocationnamecountry
	,defaultservicelocationnamezipcode
	,GETDATE()
	,0
	,GETDATE()
	,0
	,defaultservicelocationbillingname
	,defaultservicelocationphone
	,defaultservicelocationphoneext
	,defaultservicelocationfaxphone
	,defaultservicelocationfaxphoneext
	,@VendorImportID
	,defaultservicelocationid
FROM dbo.[_import_20120621_Patient]
WHERE
	defaultservicelocationid <> ''
	
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
	[primaryinsurancepolicycompanyname]
	,[primaryinsurancepolicyplanaddressline1]
	,[primaryinsurancepolicyplanaddressline2]
	,[primaryinsurancepolicyplancity]
	,[primaryinsurancepolicyplanstate]
	,[primaryinsurancepolicyplancountry]
	,[primaryinsurancepolicyplanzipcode]
	,[primaryinsurancepolicyplanphonenumber]
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[primaryinsurancepolicycompanyid] -- unique
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
FROM dbo.[_import_20120621_Patient]
WHERE
	[primaryinsurancepolicycompanyname] <> ''

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
	VendorID,
	VendorImportID,
	[External],
	NPI,
	ProviderTypeID
)
SELECT DISTINCT
	@PracticeID
	,''
	,firstname
	,middlename
	,lastname
	,''
	,addressline1
	,addressline2
	,city
	,state
	,'USA'
	,zipcode
	,workphone
	,faxnumber
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,degree
	,doctorid -- Appears to be unique in source data
	,@VendorImportID
	,1
	,npi
	,1
FROM dbo._import_20120621_ReferringDoctor

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	ReferringPhysicianID,
	DefaultServiceLocationID,
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
	HomePhoneExt,
	WorkPhone,
	WorkPhoneExt,
	MobilePhone,
	MobilePhoneExt,
	EmailAddress,
	DOB ,
	SSN ,
	ResponsibleDifferentThanPatient,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	EmploymentStatus ,
	MedicalRecordNumber,
	VendorID ,
	VendorImportID ,
	PatientReferralSourceID,
	CollectionCategoryID ,
	Active ,
	SendEmailCorrespondence ,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,refDoc.DoctorID
	,sl.ServiceLocationID
	,impP.prefix
	,impP.ptlastname
	,impP.ptfirstname
	,impP.ptmiddle
	,impP.suffix
	,impP.ptaddress1
	,impP.ptaddress2
	,impP.ptcity
	,impP.ptstate
	,impP.ptcountry
	,impP.ptzip
	,impP.gender
	,impP.maritalstatus
	,impP.homephone
	,impP.homephoneext
	,impP.ptworkph
	,impP.workphoneext
	,impP.mobilephone
	,impP.mobilephoneext
	,impP.emailaddress
	,impP.dob
	,impP.ptssn
	,impP.guarantordifferentthanpatient
	,GETDATE()
	,0
	,GETDATE()
	,0
	,CASE impP.employmentstatus WHEN 'Employed' THEN 'E' ELSE 'U' END
	,impP.medicalrecordnumber
	,impP.ptid 
	,@VendorImportID
	,PRS.PatientReferralSourceID
	,1
	,1
	,0
	,1
FROM dbo.[_import_20120621_Patient] impP
LEFT OUTER JOIN dbo.ServiceLocation sl ON @VendorImportID = sl.VendorImportID AND impP.defaultservicelocationid = sl.VendorID 
LEFT OUTER JOIN dbo.Doctor refDoc ON @VendorImportID = refDoc.VendorImportID AND impP.referringproviderid = refDoc.VendorID AND refDoc.[External] = 1
LEFT OUTER JOIN dbo.PatientReferralSource PRS ON PRS.PatientReferralSourceCaption = impP.referralsource
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient Journal Notes
PRINT ''
PRINT 'Inserting records into PatientJournalNote 1'
INSERT INTO dbo.PatientJournalNote (
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	PatientID ,
	UserName ,
	NoteMessage,
	SoftwareApplicationID
	)
SELECT DISTINCT
	mostrecentnote1date
	,0
	,GETDATE()
	,0
	,realP.PatientID
	,mostrecentnote1user
	,mostrecentnote1message
	,'K'
FROM dbo.[_import_20120621_Patient] impP
INNER JOIN dbo.Patient realP ON impP.ptid = realP.VendorID AND realP.VendorImportID = @VendorImportID
WHERE mostrecentnote1message <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

PRINT ''
PRINT 'Inserting records into PatientJournalNote 2'
INSERT INTO dbo.PatientJournalNote (
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	PatientID ,
	UserName ,
	NoteMessage
	)
SELECT DISTINCT
	mostrecentnote2date
	,0
	,GETDATE()
	,0
	,realP.PatientID
	,mostrecentnote2user
	,mostrecentnote2message
FROM dbo.[_import_20120621_Patient] impP
INNER JOIN dbo.Patient realP ON impP.ptid = realP.VendorID AND realP.VendorImportID = @VendorImportID
WHERE mostrecentnote2message <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

PRINT ''
PRINT 'Inserting records into PatientJournalNote 3'
INSERT INTO dbo.PatientJournalNote (
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	PatientID ,
	UserName ,
	NoteMessage
	)
SELECT DISTINCT
	mostrecentnote3date
	,0
	,GETDATE()
	,0
	,realP.PatientID
	,mostrecentnote3user
	,mostrecentnote3message
FROM dbo.[_import_20120621_Patient] impP
INNER JOIN dbo.Patient realP ON impP.ptid = realP.VendorID AND realP.VendorImportID = @VendorImportID
WHERE mostrecentnote3message <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

PRINT ''
PRINT 'Inserting records into PatientJournalNote 4'
INSERT INTO dbo.PatientJournalNote (
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	PatientID ,
	UserName ,
	NoteMessage
	)
SELECT DISTINCT
	mostrecentnote4date
	,0
	,GETDATE()
	,0
	,realP.PatientID
	,mostrecentnote4user
	,mostrecentnote4message
FROM dbo.[_import_20120621_Patient] impP
INNER JOIN dbo.Patient realP ON impP.ptid = realP.VendorID AND realP.VendorImportID = @VendorImportID
WHERE mostrecentnote4message <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient Case (Depends on patient records already being imported, can only run after)
PRINT ''
PRINT 'Inserting records into PatientCase ...'
INSERT INTO dbo.PatientCase (
	PatientID,
	[Name],
	PayerScenarioID,
	ReferringPhysicianID,
	Notes,
	StatementActive,
	EmergencyRelated,
	FamilyPlanning,
	EPSDT,
	PregnancyRelatedFlag,
	AbuseRelatedFlag,
	EmploymentRelatedFlag,
	AutoAccidentRelatedFlag,
	AutoAccidentRelatedState,
	OtherAccidentRelatedFlag,
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
	,impCase.defaultcasename
	,CASE 
		WHEN ps.PayerScenarioID IS NULL THEN 
			CASE impCase.defaultcasepayerscenario 
				WHEN '' THEN 11 
				ELSE 5 
			END
		WHEN NOT (ps.PayerScenarioID IS NULL) THEN ps.PayerScenarioID
	END 
	,refDoc.DoctorID
	,'Created via data import'
	,impCase.defaultcasesendpatientstatements
	,impCase.defaultcaseconditionrelatedtoemergency
	,impCase.defaultcaseconditionrelatedtofamilyplanning
	,impCase.defaultcaseconditionrelatedtoepsdt
	,impCase.defaultcaseconditionrelatedtopregnancy
	,impCase.defaultcaseconditionrelatedtoabuse
	,impCase.defaultcaseconditionrelatedtoemployment
	,impCase.defaultcaseconditionrelatedtoautoaccident
	,impCase.defaultcaseconditionrelatedtoautoaccidentstate
	,impCase.defaultcaseconditionrelatedtoother
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impCase.ptid
	,@VendorImportID
FROM 
	dbo.[_import_20120621_Patient] impCase
INNER JOIN dbo.Patient realP ON impCase.ptid = realP.VendorID AND realP.VendorImportID = @VendorImportID
LEFT OUTER JOIN dbo.Doctor refDoc ON @VendorImportID = refDoc.VendorImportID AND impCase.referringproviderid = refDoc.VendorID AND refDoc.[External] = 1
LEFT OUTER JOIN dbo.PayerScenario ps ON impCase.defaultcasepayerscenario = ps.Name
WHERE
	realP.VendorImportID = @VendorImportID -- This is very important as previous vendor imports can potentially contain VendorIDs that collide with this import. 
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


/*
Patient Case Date Types

1	Initial Treatment Date
2	Date of Injury
3	Date of Same or Similar Illness
4	Unable to Work in Current Occupation
5	Disability Related to Condition
6	Hospitalization Related to Condition
7	Last Menstrual Period
8	Date Last Seen
9	Referal Date
10	Acute Manifestation Date
11	Last X-ray Date
12	Accident Date
*/

-- Patient Case Dates
PRINT ''
PRINT 'Inserting records into PatientCaseDate ...'
INSERT INTO dbo.PatientCaseDate (
	PracticeID ,	PatientCaseID ,	PatientCaseDateTypeID ,	StartDate ,	EndDate ,	CreatedDate ,	CreatedUserID ,	ModifiedDate ,	ModifiedUserID
)
SELECT DISTINCT 
	@PracticeID
	,realPC.PatientCaseID
	,2
	,defaultcasedatesinjurystartdate
	,defaultcasedatesinjuryenddate 
	,GETDATE()	,0	,GETDATE()	,0
FROM dbo.[_import_20120621_Patient] impCase
INNER JOIN dbo.PatientCase realPC ON impCase.ptid = realPC.VendorID AND realPC.VendorImportID = @VendorImportID
WHERE defaultcasedatesinjurystartdate <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient Case Dates
PRINT ''
PRINT 'Inserting records into PatientCaseDate ...'
INSERT INTO dbo.PatientCaseDate (
	PracticeID ,	PatientCaseID ,	PatientCaseDateTypeID ,	StartDate ,	EndDate ,	CreatedDate ,	CreatedUserID ,	ModifiedDate ,	ModifiedUserID
)
SELECT DISTINCT 
	@PracticeID
	,realPC.PatientCaseID
	,3
	,defaultcasedatessameorsimilarillnessstartdate
	,defaultcasedatessameorsimilarillnessenddate 
	,GETDATE()	,0	,GETDATE()	,0
FROM dbo.[_import_20120621_Patient] impCase
INNER JOIN dbo.PatientCase realPC ON impCase.ptid = realPC.VendorID AND realPC.VendorImportID = @VendorImportID
WHERE defaultcasedatessameorsimilarillnessstartdate <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Case Dates
PRINT ''
PRINT 'Inserting records into PatientCaseDate ...'
INSERT INTO dbo.PatientCaseDate (
	PracticeID ,	PatientCaseID ,	PatientCaseDateTypeID ,	StartDate ,	EndDate ,	CreatedDate ,	CreatedUserID ,	ModifiedDate ,	ModifiedUserID
)
SELECT DISTINCT 
	@PracticeID
	,realPC.PatientCaseID
	,4
	,defaultcasedatesunabletoworkstartdate
	,defaultcasedatesunabletoworkenddate 
	,GETDATE()	,0	,GETDATE()	,0
FROM dbo.[_import_20120621_Patient] impCase
INNER JOIN dbo.PatientCase realPC ON impCase.ptid = realPC.VendorID AND realPC.VendorImportID = @VendorImportID
WHERE defaultcasedatesunabletoworkstartdate <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Case Dates
PRINT ''
PRINT 'Inserting records into PatientCaseDate ...'
INSERT INTO dbo.PatientCaseDate (
	PracticeID ,	PatientCaseID ,	PatientCaseDateTypeID ,	StartDate ,	EndDate ,	CreatedDate ,	CreatedUserID ,	ModifiedDate ,	ModifiedUserID
)
SELECT DISTINCT 
	@PracticeID
	,realPC.PatientCaseID
	,5
	,defaultcasedatesrelateddisabilitystartdate
	,defaultcasedatesrelateddisabilityenddate 
	,GETDATE()	,0	,GETDATE()	,0
FROM dbo.[_import_20120621_Patient] impCase
INNER JOIN dbo.PatientCase realPC ON impCase.ptid = realPC.VendorID AND realPC.VendorImportID = @VendorImportID
WHERE defaultcasedatesrelateddisabilitystartdate <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




-- Patient Case Dates
PRINT ''
PRINT 'Inserting records into PatientCaseDate ...'
INSERT INTO dbo.PatientCaseDate (
	PracticeID ,	PatientCaseID ,	PatientCaseDateTypeID ,	StartDate ,	EndDate ,	CreatedDate ,	CreatedUserID ,	ModifiedDate ,	ModifiedUserID
)
SELECT DISTINCT 
	@PracticeID
	,realPC.PatientCaseID
	,6
	,defaultcasedatesrelatedhospitalizationstartdate
	,defaultcasedatesrelatedhospitalizationenddate 
	,GETDATE()	,0	,GETDATE()	,0
FROM dbo.[_import_20120621_Patient] impCase
INNER JOIN dbo.PatientCase realPC ON impCase.ptid = realPC.VendorID AND realPC.VendorImportID = @VendorImportID
WHERE defaultcasedatesrelatedhospitalizationstartdate <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Case Dates
PRINT ''
PRINT 'Inserting records into PatientCaseDate ...'
INSERT INTO dbo.PatientCaseDate (
	PracticeID ,	PatientCaseID ,	PatientCaseDateTypeID ,	StartDate ,	EndDate ,	CreatedDate ,	CreatedUserID ,	ModifiedDate ,	ModifiedUserID
)
SELECT DISTINCT 
	@PracticeID
	,realPC.PatientCaseID
	,7
	,defaultcasedateslastmenstrualperioddate
	,'' 
	,GETDATE()	,0	,GETDATE()	,0
FROM dbo.[_import_20120621_Patient] impCase
INNER JOIN dbo.PatientCase realPC ON impCase.ptid = realPC.VendorID AND realPC.VendorImportID = @VendorImportID
WHERE defaultcasedateslastmenstrualperioddate <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient Case Dates
PRINT ''
PRINT 'Inserting records into PatientCaseDate ...'
INSERT INTO dbo.PatientCaseDate (
	PracticeID ,	PatientCaseID ,	PatientCaseDateTypeID ,	StartDate ,	EndDate ,	CreatedDate ,	CreatedUserID ,	ModifiedDate ,	ModifiedUserID
)
SELECT DISTINCT 
	@PracticeID
	,realPC.PatientCaseID
	,8
	,defaultcasedateslastseendate
	,'' 
	,GETDATE()	,0	,GETDATE()	,0
FROM dbo.[_import_20120621_Patient] impCase
INNER JOIN dbo.PatientCase realPC ON impCase.ptid = realPC.VendorID AND realPC.VendorImportID = @VendorImportID
WHERE defaultcasedateslastseendate <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- Patient Case Dates
PRINT ''
PRINT 'Inserting records into PatientCaseDate ...'
INSERT INTO dbo.PatientCaseDate (
	PracticeID ,	PatientCaseID ,	PatientCaseDateTypeID ,	StartDate ,	EndDate ,	CreatedDate ,	CreatedUserID ,	ModifiedDate ,	ModifiedUserID
)
SELECT DISTINCT 
	@PracticeID
	,realPC.PatientCaseID
	,9
	,defaultcasedatesreferraldate
	,'' 
	,GETDATE()	,0	,GETDATE()	,0
FROM dbo.[_import_20120621_Patient] impCase
INNER JOIN dbo.PatientCase realPC ON impCase.ptid = realPC.VendorID AND realPC.VendorImportID = @VendorImportID
WHERE defaultcasedatesreferraldate <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient Case Dates
PRINT ''
PRINT 'Inserting records into PatientCaseDate ...'
INSERT INTO dbo.PatientCaseDate (
	PracticeID ,	PatientCaseID ,	PatientCaseDateTypeID ,	StartDate ,	EndDate ,	CreatedDate ,	CreatedUserID ,	ModifiedDate ,	ModifiedUserID
)
SELECT DISTINCT 
	@PracticeID
	,realPC.PatientCaseID
	,10
	,defaultcasedatesacutemanifestationdate
	,'' 
	,GETDATE()	,0	,GETDATE()	,0
FROM dbo.[_import_20120621_Patient] impCase
INNER JOIN dbo.PatientCase realPC ON impCase.ptid = realPC.VendorID AND realPC.VendorImportID = @VendorImportID
WHERE defaultcasedatesacutemanifestationdate <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Case Dates
PRINT ''
PRINT 'Inserting records into PatientCaseDate ...'
INSERT INTO dbo.PatientCaseDate (
	PracticeID ,	PatientCaseID ,	PatientCaseDateTypeID ,	StartDate ,	EndDate ,	CreatedDate ,	CreatedUserID ,	ModifiedDate ,	ModifiedUserID
)
SELECT DISTINCT 
	@PracticeID
	,realPC.PatientCaseID
	,11
	,defaultcasedateslastxraydate
	,'' 
	,GETDATE()	,0	,GETDATE()	,0
FROM dbo.[_import_20120621_Patient] impCase
INNER JOIN dbo.PatientCase realPC ON impCase.ptid = realPC.VendorID AND realPC.VendorImportID = @VendorImportID
WHERE defaultcasedateslastxraydate <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient Case Dates
PRINT ''
PRINT 'Inserting records into PatientCaseDate ...'
INSERT INTO dbo.PatientCaseDate (
	PracticeID ,	PatientCaseID ,	PatientCaseDateTypeID ,	StartDate ,	EndDate ,	CreatedDate ,	CreatedUserID ,	ModifiedDate ,	ModifiedUserID
)
SELECT DISTINCT 
	@PracticeID
	,realPC.PatientCaseID
	,12
	,defaultcasedatesaccidentdate
	,'' 
	,GETDATE()	,0	,GETDATE()	,0
FROM dbo.[_import_20120621_Patient] impCase
INNER JOIN dbo.PatientCase realPC ON impCase.ptid = realPC.VendorID AND realPC.VendorImportID = @VendorImportID
WHERE defaultcasedatesaccidentdate <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'





COMMIT TRAN