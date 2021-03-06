USE superbill_7308_dev 
--USE superbill_7308_prod
GO

/*
This customer provided a kareo export as input.

For an example of a more comprehensive script including insurance companies and policies, 
see C:\SVN\superbill\Software\Data\Script\Import Scripts\FB_4894_Andrew_Roorda_11418.sql
*/

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @VendorName VARCHAR(100)
DECLARE @ImportNote VARCHAR(100)


SET @PracticeID = 1
SET @VendorImportID = 1 -- Imported through tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))


DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient journal notes records deleted'
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
	employername, -- EmployerName - varchar(128)
	GETDATE(), -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE(), -- ModifiedDate - datetime
	0 -- ModifiedUserID - int
FROM dbo.[_import_1_1_PatientDemographics]
WHERE employername NOT IN (SELECT EmployerName FROM dbo.Employers)

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
	EmployerID,
	MedicalRecordNumber,
	VendorID ,
	VendorImportID ,
	PatientReferralSourceID,
	CollectionCategoryID ,
	Active ,
	SendEmailCorrespondence ,
	PhonecallRemindersEnabled,
	EmergencyName,
	EmergencyPhone,
	EmergencyPhoneExt
	)
SELECT DISTINCT
	@PracticeID
	,impP.prefix
	,impP.lastname
	,impP.firstname
	,impP.middlename
	,impP.suffix
	,impP.addressline1
	,impP.addressline2
	,impP.city
	,impP.state
	,impP.country
	,impP.zipcode
	,impP.gender
	,impP.maritalstatus
	,impP.homephone
	,impP.homephoneext
	,impP.workphone
	,impP.workphoneext
	,impP.mobilephone
	,impP.mobilephoneext
	,impP.emailaddress
	,impP.dob
	,impP.ssn
	,impP.guarantordifferentthanpatient
	,GETDATE()
	,0
	,GETDATE()
	,0
	,CASE impP.employmentstatus WHEN 'Employed' THEN 'E' ELSE 'U' END
	,e.EmployerID
	,impP.medicalrecordnumber
	,impP.pt_id 
	,@VendorImportID
	,PRS.PatientReferralSourceID
	,1
	,1
	,0
	,1
	,impP.emergencyname
	,impP.emergencyphone
	,impP.emergencyphoneext
FROM dbo.[_import_1_1_PatientDemographics] impP
LEFT OUTER JOIN dbo.Employers e ON impP.employername = e.EmployerName 
LEFT OUTER JOIN dbo.PatientReferralSource PRS ON impP.referralsource = PRS.PatientReferralSourceCaption
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Alert
PRINT ''
PRINT 'Inserting records into PatientAlert'
INSERT INTO dbo.PatientAlert ( 
	PatientID ,
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
SELECT DISTINCT
	realP.PatientID
	,impP.alertmessage
	,impP.alertshowwhendisplayingpatientdetails
	,impP.alertshowwhenschedulingappointments
	,impP.alertshowwhenenteringencounters
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impP.alertshowwhenviewingclaimdetails
	,impP.alertshowwhenpostingpayments
	,impP.alertshowwhenpreparingpatientstatements
FROM dbo.[_import_1_1_PatientDemographics] impP
INNER JOIN dbo.Patient realP ON impP.pt_id = realP.VendorID AND realP.VendorImportID = @VendorImportID
WHERE impP.alertmessage <> ''

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
FROM dbo.[_import_1_1_PatientDemographics] impP
INNER JOIN dbo.Patient realP ON impP.pt_id = realP.VendorID AND realP.VendorImportID = @VendorImportID
WHERE mostrecentnote1message <> '' AND ISDATE(mostrecentnote1date) = 1

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
FROM dbo.[_import_1_1_PatientDemographics] impP
INNER JOIN dbo.Patient realP ON impP.pt_id = realP.VendorID AND realP.VendorImportID = @VendorImportID
WHERE mostrecentnote2message <> '' AND ISDATE(mostrecentnote2date) = 1

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
FROM dbo.[_import_1_1_PatientDemographics] impP
INNER JOIN dbo.Patient realP ON impP.pt_id = realP.VendorID AND realP.VendorImportID = @VendorImportID
WHERE mostrecentnote3message <> '' AND ISDATE(mostrecentnote3date) = 1

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
FROM dbo.[_import_1_1_PatientDemographics] impP
INNER JOIN dbo.Patient realP ON impP.pt_id = realP.VendorID AND realP.VendorImportID = @VendorImportID
WHERE mostrecentnote4message <> '' AND ISDATE(mostrecentnote4date) = 1

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




COMMIT TRAN