USE superbill_10299_dev
--USE superbill_10299_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @VendorName VARCHAR(100)
DECLARE @ImportNote VARCHAR(100)

-- This script ASSUMES that someone has created the first practice record.
SET @PracticeID = 1
SET @VendorName = 'Mercy Clinic'
SET @ImportNote = 'Initial import for customer 10299 - FB 4702'

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
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records purged'


-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	Prefix ,
	FirstName ,
	MiddleName ,
	LastName ,
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
	WorkPhone ,
	DOB ,
	SSN ,
	ResponsibleRelationshipToPatient,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	EmploymentStatus ,
	MedicalRecordNumber ,
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	SendEmailCorrespondence ,
	PhonecallRemindersEnabled,
	EmergencyName
	)
SELECT 
	@PracticeID
	,''
	,Pt_First_Name
	,pt_mi_name
	,Pt_Last_Name
	,''
	,Pt_Address
	,''
	,Pt_City
	,Pt_State
	,'USA'
	,LEFT(REPLACE(Pt_Zip, '-', ''), 9)
	,Pt_Sex
	,CASE Pt_Marital_Status WHEN 'O' THEN 'U' WHEN '' THEN 'U' ELSE Pt_Marital_Status END
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Pt_Phone, '-', ''), '(', ''), ')', ''), ' ', ''), '_', ''), 'x', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Pt_Work_Phone, '-', ''), '(', ''), ')', ''), ' ', ''), '_', ''), 'x', ''), 10)
	,CASE ISDATE(Pt_DOB) WHEN 1 THEN Pt_DOB ELSE NULL END 
	,REPLACE(Pt_SSN, '-', '')
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,CASE Pt_Employed_Status 
		WHEN 'E' THEN 'E' 
		WHEN 'R' THEN 'R' 
		WHEN 'RT' THEN 'R' 
		WHEN 'F' THEN 'S' 
		WHEN 'P' THEN 'T' 
		ELSE 'U' 
		END
	,Pt_Chart_No
	,VendorID -- auto ID we added to temp table
	,@VendorImportID
	,1
	,1
	,1
	,1
	,LEFT(Pt_Emergency_Contact, 128)
FROM dbo._importFB4702

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT TRAN