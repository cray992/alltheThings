--USE superbill_11660_dev
USE superbill_11660_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT


SET @PracticeID = 1
SET @VendorImportID = 3

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
	SSN,
	MedicalRecordNumber,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	CollectionCategoryID,
	Active,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	@PracticeID
	,''
	,[LASTNAME]
	,[FIRSTNAME]
	,[MI]
	,''
	,[STREET1]
	,[STREET2]
	,[CITY]
	,LEFT([STATE], 2)
	,''
	,LEFT(REPLACE([ZIP], '-', ''), 9)
	,CASE WHEN [SEX] = 'F' THEN 'F' WHEN [SEX] = 'M' THEN 'M' ELSE 'U' END 
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([PHONE], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([WORK_PHONE], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE([SSN], '-', ''), 9)
	,[medical_record_#]
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[medical_record_#]
	,@VendorImportID
	,1
	,1
	,1
FROM dbo.[_import_3_1_Patients82712] 
	WHERE 
		NOT EXISTS(SELECT * FROM patient 
			WHERE MedicalRecordNumber = medical_record_#)

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT TRAN 

