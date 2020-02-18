USE superbill_4267_dev
--USE superbill_4267_prod
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

DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'




-- Doctor 
PRINT ''
PRINT 'Inserting records into Doctor  ...'
INSERT INTO dbo.Doctor ( 
	PracticeID,
	Prefix,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	ActiveDoctor,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	[External],
	ProviderTypeID
)
SELECT DISTINCT
	@PracticeID
	,''
	,provider_Fname
	,''
	,provider_Lname
	,''
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,0
	,@VendorImportID
	,0
	,1
FROM dbo.[_import_1_1_HPC_export2012_csvformat]
WHERE
	NOT EXISTS(SELECT * FROM dbo.Doctor WHERE
		FirstName = provider_Fname AND
		LastName = provider_Lname)
		
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
	WorkPhone ,
	SSN ,
	DOB ,
	PrimaryProviderID ,
	ResponsibleRelationshipToPatient,
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
	,impP.[address_1]
	,impP.[address_2]
	,impP.[city]
	,LEFT(impP.[state], 2)
	,''
	,LEFT(REPLACE(impP.[zip], '-', ''), 9)
	,CASE impP.[gender] WHEN 'F' THEN 'F' WHEN 'M' THEN 'M' ELSE 'U' END
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[home_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[work_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(impP.[ssn], '-', ''), 9)
	,CASE 
		WHEN LEN(birthdate) = 8 THEN LEFT(birthdate, 2)
		ELSE '0' + LEFT(birthdate, 1)  
	END + '/' + SUBSTRING(RIGHT(birthdate, 6), 1, 2) + '/' + RIGHT(birthdate,4)
	,doc.DoctorID
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impP.[chart_number] -- It's unique, we verified it, h00ray!!!!
	,@VendorImportID
	,1
	,1
	,0
	,1
FROM dbo.[_import_1_1_HPC_export2012_csvformat] impP
LEFT JOIN dbo.doctor doc ON
	impP.renderingDoctorID = doc.DoctorID
WHERE 
	LEFT(REPLACE(impP.ssn, '-', ''), 9) NOT IN (SELECT SSN FROM dbo.Patient WITH (NOLOCK) WHERE PracticeID = @PracticeID AND SSN <> '' AND NOT (SSN IS NULL))
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



COMMIT TRAN