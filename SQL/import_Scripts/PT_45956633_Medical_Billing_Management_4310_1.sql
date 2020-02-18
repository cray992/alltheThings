--USE superbill_4310_dev
USE superbill_4310_prod
GO


 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 10
SET @VendorImportID = 1 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientJournalNote records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientCaseDate WHERE PracticeID = @PracticeID AND PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID) 
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCaseDate records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientAler records deleted'	
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
	



PRINT ''
PRINT 'Inserting into Insurance Company ...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReviewCode ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
		  ic.[primaryinsurancepolicycompanyname] , -- InsuranceCompanyName - varchar(128)
          ic.[primaryinsurancepolicyplanaddressline1]  , -- AddressLine1 - varchar(256)
          ic.[primaryinsurancepolicyplanaddressline2] , -- AddressLine2 - varchar(256)
          ic.[primaryinsurancepolicyplancity] , -- City - varchar(128)
          ic.[primaryinsurancepolicyplanstate] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(ic.[primaryinsurancepolicyplanzipcode], '-', ''), 9) ,-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(ic.[primaryinsurancepolicyplanphonenumber],'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(ic.[primaryinsurancepolicyplanphonenumberExt],'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(ic.[primaryinsurancepolicyplanFaxnumber],'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(ic.[primaryinsurancepolicyplanFaxnumberExt],'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'R', 
          13, -- SecondaryPrecedenceBillingFormID - int
          ic.[primaryinsurancepolicycompanyid] , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          NULL , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM [dbo].[_import_1_10_PatientDemographics] ic
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--InsuranceCompanyPlan
PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
		  AddressLine1 ,
		  AddressLine2 ,
		  city ,
		  State ,
		  ZipCode ,
		  Phone ,
		  PhoneExt ,
		  Fax ,
		  FaxExt ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT 
		  ic.[primaryinsurancepolicyplanname] , -- PlanName - varchar(128)
		  icp.addressline1 ,
		  icp.addressline2 ,
		  icp.city ,
		  icp.[State] ,
		  icp.zipcode ,
		  icp.phone ,
		  icp.phoneext ,
		  icp.fax ,
		  icp.faxext ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          icp.InsuranceCompanyID , -- InsuranceCompanyID - int
          ic.[primaryinsurancepolicyplanid] , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany icp 
JOIN [dbo].[_import_1_10_PatientDemographics] ic ON
	icp.VendorID = ic.primaryinsurancepolicycompanyid
WHERE icp.CreatedPracticeID = @PracticeID AND 
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--Referring Doctors
PRINT ''
PRINT 'Inserting records into Doctor ...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          WorkPhone ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          [External] ,
          NPI 
        )
SELECT 
		  @PracticeID , -- PracticeID - int
          '', -- Prefix - varchar(16)
          ref.firstname , -- FirstName - varchar(64)
          ref.middlename , -- MiddleName - varchar(64)
          ref.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          ref.addressline1 , -- AddressLine1 - varchar(256)
          ref.addressline2 , -- AddressLine2 - varchar(256)
          ref.city , -- City - varchar(128)
          ref.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ref.zipcode , -- ZipCode - varchar(9)
          ref.workphone , -- WorkPhone - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ref.degree , -- Degree - varchar(8)
          ref.doctorid , -- VendorID - varchar(50)
		  @VendorImportID , -- VendorImportID - int
          1 , -- External - bit
          ref.npi  -- NPI - varchar(10)
FROM dbo.[_import_1_10_ReferringProviders] ref
PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'



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
	HomePhoneExt ,
	WorkPhone ,
	WorkPhoneExt ,
	DOB ,
	SSN ,
	EmailAddress,
	ResponsibleRelationshipToPatient,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	PrimaryProviderID,
	DefaultServiceLocationID,
	MedicalRecordNumber,
	MobilePhone ,
	MobilePhoneExt ,
	VendorID,
	VendorImportID,
	CollectionCategoryID ,
	Active ,
	SendEmailCorrespondence ,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,CASE WHEN impP.referringproviderid <> '' THEN doc.DoctorID END AS DoctorID
	,impP.[prefix]
	,impP.[lastName]
	,impP.[FirstName]
	,impP.[MiddleName]
	,impP.[suffix]
	,impP.[addressline1]
	,impP.[addressline2]
	,impP.[City]
	,LEFT(impP.[State], 2)
	,impP.country
	,LEFT(REPLACE(impP.[ZipCode], '-', ''), 9)
	,CASE impP.[gender] WHEN 'F' THEN 'F' WHEN 'M' THEN 'M' ELSE 'U' END
	,impP.[maritalstatus]
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[homephone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[homephoneext], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[workphone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[workphoneext], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.[dob]) WHEN 1 THEN impP.[dob] ELSE NULL END 
	,LEFT(REPLACE(impP.[ssn], '-', ''), 9)
	,impP.emailaddress
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,CASE WHEN impP.defaultrenderingproviderfullname = 'Ari  Weitzner' THEN 1 END
	,1 -- default service location
	,impP.medicalrecordnumber
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[mobilephone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[mobilephoneext], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,impP.ID -- Unique Import Assigned ID (or the export tool's patient id?)
	,@VendorImportID
	,1
	,1
	,CASE WHEN impP.emailaddress <> '' THEN 1 ELSE 0 END
	,1
FROM dbo.[_import_1_10_PatientDemographics] impP
LEFT JOIN dbo.Doctor doc ON doc.DoctorID = impP.[referringproviderid]

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Journal note
PRINT ''
PRINT 'Inserting records into PatientJournalNote ...'
INSERT INTO dbo.PatientJournalNote (
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	PatientID ,
	UserName ,
	SoftwareApplicationID ,
	NoteMessage
)
SELECT DISTINCT 
	GETDATE()
	,0
	,GETDATE()
	,0
	,realP.PatientID
	,impNote.mostrecentnote1user
	,'K'
	,impNote.mostrecentnote1message
FROM dbo.[_import_1_10_PatientDemographics] impNote
JOIN dbo.Patient realP ON 
	realP.VendorImportID = @VendorImportID AND
	impNote.[id] = realP.VendorID
WHERE impNote.mostrecentnote1message <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Another Patient Journal Note
PRINT ''
PRINT 'Inserting records into Patient Journal Note ...'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
          Hidden ,
          NoteMessage ,
          NoteTypeCode 
        )
SELECT 
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          realP.patientID , -- PatientID - int
          0 , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
          0 , -- Hidden - bit
          impNote.statementnote, -- NoteMessage - varchar(max)
          2  -- NoteTypeCode - int
FROM dbo.[_import_1_10_PatientDemographics] impNote
JOIN dbo.Patient realP ON 
	realP.VendorImportID = @VendorImportID AND
	impNote.[id] = realP.VendorID
WHERE impNOTE.statementnote <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Alert
PRINT ''
PRINT 'Inserting records into PatientAlert ...'
INSERT INTO dbo.PatientAlert
        ( PatientID ,
          AlertMessage ,
          ShowInPatientFlag ,
          ShowInAppointmentFlag ,
          ShowInEncounterFlag ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ShowInClaimFlag ,
          ShowInPaymentFlag ,
          ShowInPatientStatementFlag
        )
SELECT 
		  realP.PatientID  , -- PatientID - int
          pat.alertmessage , -- AlertMessage - text
          pat.alertshowwhendisplayingpatientdetails , -- ShowInPatientFlag - bit
          pat.alertshowwhenschedulingappointments , -- ShowInAppointmentFlag - bit
          pat.alertshowwhenenteringencounters , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.alertshowwhenviewingclaimdetails , -- ShowInClaimFlag - bit
          pat.alertshowwhenpostingpayments , -- ShowInPaymentFlag - bit
          pat.alertshowwhenpreparingpatientstatements  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_1_10_PatientDemographics] pat
JOIN dbo.Patient realP ON 
	pat.id = realP.VendorID
WHERE pat.alertmessage <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient Case
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
	VendorImportID,
	StatementActive
)
SELECT DISTINCT
	realP.PatientID
	,impCase.defaultcasename
	,ps.PayerScenarioID 
	,impCase.defaultcasedescription
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impCase.defaultcaseid -- Case ID FROM Kareo
	,impCase.defaultcaseid -- Unique Case ID FROM Kareo
	,@VendorImportID
	,impCase.defaultcasesendpatientstatements
FROM 
	dbo.[_import_1_10_PatientDemographics] impCase
INNER JOIN dbo.PayerScenario ps ON impCase.defaultcasepayerscenario = ps.Name
INNER JOIN dbo.Patient realP ON 
	impCase.ID = realP.VendorID AND 
	realP.VendorImportID = @VendorImportID
WHERE impCase.DefaultCaseID <> ''
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting records into PatientCaseDate ...'
INSERT INTO dbo.PatientCaseDate
( 
	PracticeID , 
	PatientCaseID , 
	PatientCaseDateTypeID , 
	StartDate , 
	EndDate , 
	CreatedDate , 
	CreatedUserID , 
	ModifiedDate , 
	ModifiedUserID
)
SELECT DISTINCT
	@PracticeID , -- PracticeID - int
	PC.PatientCaseID , -- PatientCaseID - int
	8 , -- PatientCaseDateTypeID - int
	IPD.lastencounterdate , -- StartDate - datetime
	NULL , -- EndDate - datetime
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0  -- ModifiedUserID - int
FROM dbo.[_import_1_10_PatientDemographics] AS IPD
JOIN dbo.Patient AS PAT ON 
	PAT.VendorID = IPD.ID AND 
	PAT.VendorImportID = @VendorImportID
JOIN dbo.PatientCase AS PC ON 
	PC.PatientID = PAT.PatientID AND 
	PC.PatientCaseID = (SELECT MIN(PatientCaseID) FROM dbo.PatientCase PC2 WHERE PC2.PatientID = PAT.PatientID)
WHERE ISDATE(IPD.lastencounterdate) = 1
PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy #1
PRINT ''
PRINT 'Inserting records into InsurancePolicy #1...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
	Copay,
	Deductible,
	PolicyStartDate,
	PolicyEndDate,
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
	HolderSSN,
	HolderGender,
	HolderAddressLine1,
	HolderAddressLine2,
	HolderCity,
	HolderState,
	HolderCountry,
	HolderZipCode
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,impPC.primaryinsurancepolicynumber
	,impPC.primaryinsurancepolicygroupnumber
	,impPC.primaryinsurancepolicycopay
	,impPC.primaryinsurancepolicydeductible
	,CASE ISDATE(impPC.primaryinsurancepolicyeffectivestartdate) WHEN 1 THEN impPC.primaryinsurancepolicyeffectivestartdate ELSE NULL END
	,CASE ISDATE(impPC.primaryinsurancepolicyeffectiveenddate) WHEN 1 THEN impPC.primaryinsurancepolicyeffectiveenddate ELSE NULL END
	,CASE WHEN impPC.primaryinsurancepolicypatientrelationshiptoinsured = '' THEN 'S' ELSE impPC.primaryinsurancepolicypatientrelationshiptoinsured END 
	,GETDATE()
	,0
	,GETDATE()
	,0
	,primaryinsurancepolicyinsurednotes
	,@PracticeID
	,0
	,@VendorImportID
	,'Y'
	,''
	,''
	,LEFT(primaryinsurancepolicyinsuredfullname, 64)
	,primaryinsurancepolicyinsuredsocialsecuritynumber
	,primaryinsurancepolicyinsuredgender
	,primaryinsurancepolicyinsuredaddressline1
	,primaryinsurancepolicyinsuredaddressline2
	,primaryinsurancepolicyinsuredcity
	,primaryinsurancepolicyinsuredstate
	,primaryinsurancepolicyinsuredcountry
	,primaryinsurancepolicyinsuredzipcode
FROM dbo.[_import_1_10_PatientDemographics] impPC
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorImportID = @VendorImportID AND
	impPC.defaultcaseid = pc.VendorID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.primaryinsurancepolicyplanid = icp.VendorID
WHERE
	pc.VendorImportID = @VendorImportID AND
	impPC.primaryinsurancepolicynumber <> ''

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
	Copay,
	Deductible,
	PolicyStartDate,
	PolicyEndDate,
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
	HolderSSN,
	HolderGender,
	HolderAddressLine1,
	HolderAddressLine2,
	HolderCity,
	HolderState,
	HolderCountry,
	HolderZipCode
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,2
	,impPC.secondaryinsurancepolicynumber
	,impPC.secondaryinsurancepolicygroupnumber
	,impPC.secondaryinsurancepolicycopay
	,impPC.secondaryinsurancepolicydeductible
	,CASE ISDATE(impPC.secondaryinsurancepolicyeffectivestartdate) WHEN 1 THEN impPC.secondaryinsurancepolicyeffectivestartdate ELSE NULL END
	,CASE ISDATE(impPC.secondaryinsurancepolicyeffectiveenddate) WHEN 1 THEN impPC.secondaryinsurancepolicyeffectiveenddate ELSE NULL END
	,CASE WHEN impPC.secondaryinsurancepolicypatientrelationshiptoinsured = '' THEN 'S' ELSE  impPC.secondaryinsurancepolicypatientrelationshiptoinsured END 
	,GETDATE()
	,0
	,GETDATE()
	,0
	,secondaryinsurancepolicyinsurednotes
	,@PracticeID
	,0
	,@VendorImportID
	,'Y'
	,''
	,''
	,LEFT(secondaryinsurancepolicyinsuredfullname, 64)
	,secondaryinsurancepolicyinsuredsocialsecuritynumber
	,secondaryinsurancepolicyinsuredgender
	,secondaryinsurancepolicyinsuredaddressline1
	,secondaryinsurancepolicyinsuredaddressline2
	,secondaryinsurancepolicyinsuredcity
	,secondaryinsurancepolicyinsuredstate
	,secondaryinsurancepolicyinsuredcountry
	,secondaryinsurancepolicyinsuredzipcode
FROM dbo.[_import_1_10_PatientDemographics] impPC
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorImportID = @VendorImportID AND
	impPC.defaultcaseid = pc.VendorID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.secondaryinsurancepolicyplanid  = icp.VendorID
WHERE
	pc.VendorImportID = @VendorImportID AND
	impPC.secondaryinsurancepolicynumber <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT TRAN