USE superbill_12272_dev 
--USE superbill_12272_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'




-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	Prefix ,
	LastName ,
	FirstName ,
	MiddleName,
	Suffix ,
	AddressLine1 ,
	City ,
	[State] ,
	Country ,
	ZipCode ,
	Gender ,
	MaritalStatus ,
	HomePhone ,
	WorkPhone ,
	MobilePhone ,
	DOB ,
	EmailAddress ,
	ResponsibleRelationshipToPatient ,
	MedicalRecordNumber ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
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
	,impP.[last_name]
	,impP.[first_name]
	,''
	,''
	,impP.[street_address]
	,impP.[city]
	,LEFT(impP.[state], 2)
	,''
	,LEFT(REPLACE(impP.[zip], '-', ''), 9)
	,impP.[gender] 
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[home_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE WHEN LEN(impP.work_phone) > 9 THEN LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[work_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
		ELSE ''
	 END
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[mobile_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.[date_of_birth]) WHEN 1 THEN impP.date_of_birth ELSE NULL END
	,impP.[email]
	,'S'
	,impP.[patient_identifier] -- This is unique but not all patients have it
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impP.[id] -- Kareo assigned ID since customer didn't provide a unique one
	,@VendorImportID
	,1
	,1
	,0
	,1
FROM dbo._import_1_1_patients impP

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT TRAN