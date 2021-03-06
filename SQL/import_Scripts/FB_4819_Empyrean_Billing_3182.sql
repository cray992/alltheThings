USE superbill_3182_dev
--USE superbill_3182_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @VendorName VARCHAR(100)
DECLARE @ImportNote VARCHAR(100)

-- This script eill have to be run for each practice (38, 39, 40, 41, 42, 43, 44, 45, 46 ,47 ,48 ,49)
SET @PracticeID = ??
SET @VendorName = 'Empyrean Billing Solutions, Inc'
SET @ImportNote = 'Initial import for customer 3182. FBID: 4819.'

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
	PracticeID,
	Prefix,
	LastName,
	FirstName,
	MiddleName,
	Suffix,
	AddressLine1,
	AddressLine2,
	City,
	[State],
	Country,
	ZipCode,
	Gender,
	HomePhone,
	WorkPhone,
	DOB,
	SSN,
	ResponsibleRelationshipToPatient,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	MedicalRecordNumber,
	VendorID,
	VendorImportID ,
	CollectionCategoryID,
	Active,
	SendEmailCorrespondence,
	PhonecallRemindersEnabled
	)
SELECT DISTINCT
	PracticeID
	,''
	,impP.[Last Name]
	,impP.[First Name]
	,impP.MI
	,''
	,impP.Address1
	,impP.Address2
	,impP.City
	,LEFT(impP.St, 2)
	,'USA'
	,LEFT(REPLACE(impP.[Zip Code], '-', ''), 9)
	,CASE impP.Sex 
		WHEN 'M' THEN 'M'
		WHEN 'F' THEN 'F' 
		ELSE 'U' 
	END
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[Home Phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[Work Phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.DOB) WHEN 1 THEN impP.DOB ELSE NULL END 
	,REPLACE(impP.SS#, '-', '')
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impP.[Chart #]
	,impP.[Chart #]
	,@VendorImportID
	,1
	,1
	,1
	,1
FROM dbo.[_importPatient] impP
WHERE impP.PracticeID = @PracticeID

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT TRAN