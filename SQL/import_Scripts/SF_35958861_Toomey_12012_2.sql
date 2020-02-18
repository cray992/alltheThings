USE superbill_12012_dev
--USE superbill_12012_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT


SET @PracticeID = 2
SET @VendorImportID = 2

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))


DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctors records deleted'


-- Doctor Referring
PRINT ''
PRINT 'Inserting records into Doctor (Referring) ...'
INSERT INTO dbo.Doctor ( 
	PracticeID,
	Prefix,
	LastName,
	FirstName,
	MiddleName,
	Suffix,
	AddressLine1,
	AddressLine2,
	City,
	[STATE],
	Country,
	ZipCode,
	WorkPhone,
	FaxNumber,
	ActiveDoctor,
	Degree,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	[External],
	ProviderTypeID
)
SELECT 
	@PracticeID
	,''
	,last_name
    ,first_name
    ,middle_initial
	,''
	,[street_1]
	,[street_2]
	,[city]
	,LEFT([state], 2)
	,''
	,LEFT(REPLACE(zip_code, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([office], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([fax], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,1
	,[credentials]
	,GETDATE()
	,0
	,GETDATE()
	,0
	,id
	,@VendorImportID
	,1
	,1
FROM dbo.[_import_2_2_ReferringProviders]

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
	MobilePhone,
	DOB,
	SSN,
	MedicalRecordNumber,
	PrimaryProviderID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
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
	,impP.last_name
	,impP.first_name
	,impP.middle_initial
	,''
	,LEFT(impP.street_1, 256)
	,LEFT(impP.street_2, 256)
	,impP.city
	,impP.[state]
	,''
	,LEFT(REPLACE(impP.zip_code, '-', ''), 9)
	,CASE impP.sex
		WHEN 'Male' THEN 'M'
		WHEN 'Female' THEN 'F'
		ELSE 'U'
	END
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.home_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.work_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.cell_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.Date_of_birth) WHEN 1 THEN impP.[date_of_birth] ELSE NULL END 
	,LEFT(REPLACE(impP.social_security_number, '-', ''), 9)
	,[medical_record_#]
	,doc.DoctorID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impP.[medical_record_#]-- I verified it's unique
	,@VendorImportID
	,1
	,1
	,0
	,1
FROM dbo.[_import_2_2_Patients] impP
LEFT JOIN dbo.Doctor doc ON doc.VendorImportID = @VendorImportID
	AND doc.FirstName = 'Paula'
	AND doc.LastName LIKE '%Toomey%'

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT TRAN



