USE superbill_10322_dev
--USE superbill_10322_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @VendorName VARCHAR(100)
DECLARE @ImportNote VARCHAR(100)

-- This script assumes practice #1 already exists
SET @PracticeID = 1
SET @VendorName = 'Bridge City Family Medical Clinic'
SET @ImportNote = 'Initial import for customer 10322. FBID: 4735.'

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
	ZipCode ,
	Gender,
	MaritalStatus,
	HomePhone ,
	DOB ,
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
SELECT 
	@PracticeID
	,''
	,lastname
	,firstname
	,middleinitial
	,''
	,street
	,STREET2
	,city
	,CASE LEN(state)
		WHEN 2 THEN state
		ELSE 'OR'
	END
	,'USA'
	,LEFT(REPLACE(zipcode, '-', ''), 9)
	,CASE sex
		WHEN 'Unknown' THEN 'U'
		ELSE sex
	END
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(homephone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(birthdate) WHEN 1 THEN birthdate ELSE NULL END 
	,GETDATE()
	,0
	,GETDATE()
	,0
	,ID -- auto ID we added to temp table
	,@VendorImportID
	,1
	,1
	,1
	,1
FROM dbo.[_importPatient]

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



COMMIT TRAN