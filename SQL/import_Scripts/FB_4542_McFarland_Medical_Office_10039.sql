USE superbill_10039_dev
GO

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @VendorName VARCHAR(30)
DECLARE @ImportNote VARCHAR(30)

SET @PracticeID = 1
SET @VendorName = 'McFarland Medical Office'
SET @ImportNote = 'jgunder first import'

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

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID

-- Clear out invalid records in the import
PRINT ''
PRINT 'Purging bad/duplicate records from import source table'
DELETE FROM dbo._patient WHERE [Last Name Patient] = '' AND [First Name Patient] = ''
DELETE FROM dbo._patient WHERE [ID] IN (
										SELECT p1.[ID]
										FROM dbo._patient p1
										INNER JOIN Patient p2 ON 
											p1.[First Name Patient] = p2.FirstName AND
											p1.[Last Name Patient] = p2.LastName AND
											p1.[Address Line 1 Patient] = p2.AddressLine1
										)
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted'
PRINT ''
PRINT ''

-- Insurance Company
PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany (
	InsuranceCompanyName,
	AddressLine1,
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
	VendorImportID
)
SELECT 
	DISTINCT([Insurance Company Name])
	,[Address Line 1]
	,[City]
	,[State]
	,'USA'
	,REPLACE([Zip Code], '-','')
	,REPLACE(REPLACE(REPLACE(REPLACE([Phone Number], '-', ''), '(', ''), ')', ''), ' ', '')
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@VendorImportID
FROM dbo._patient
WHERE
	NOT([Insurance Company Name] IS NULL) AND RTRIM(LTRIM([Insurance Company Name])) <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- Insurance Company Plan
PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan (
	PlanName,
	AddressLine1,
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
	InsuranceCompanyID
)
SELECT
	DISTINCT(tmpP.[Insurance Company Name])
	,tmpP.[Address Line 1]
	,tmpP.[City]
	,tmpP.[State]
	,'USA'
	,REPLACE(tmpP.[Zip Code], '-','')
	,REPLACE(REPLACE(REPLACE(REPLACE(tmpP.[Phone Number], '-', ''), '(', ''), ')', ''), ' ', '')
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,0
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo._patient tmpP
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorImportID = @VendorImportID AND
	tmpP.[Insurance Company Name] = ic.InsuranceCompanyName AND 
	tmpP.[Address Line 1] = ic.AddressLine1 AND
	tmpP.[City] = ic.City AND
	tmpP.[State] = ic.[State] AND
	ic.Country = 'USA' AND
	REPLACE(tmpP.[Zip Code], '-','') = ic.ZipCode AND
	REPLACE(REPLACE(REPLACE(REPLACE(tmpP.[Phone Number], '-', ''), '(', ''), ')', ''), ' ', '') = ic.Phone
WHERE
	NOT([Insurance Company Name] IS NULL) AND RTRIM(LTRIM([Insurance Company Name])) <> ''
		
		
		
		
		
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

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
	City ,
	[State] ,
	Country ,
	ZipCode ,
	Gender ,
	MaritalStatus ,
	HomePhone ,
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
	EmergencyName,
	EmergencyPhone
	)
SELECT 
	@PracticeID
	,''
	,[First Name Patient]
	,[Middle Initial Patient]
	,[Last Name Patient]
	,''
	,[Address Line 1 Patient]
	,[City Patient]
	,[State Patient]
	,'USA'
	,LEFT(REPLACE([Zipcode Patient], '-', ''), 9)
	,[Sex Of Patient]
	,CASE [Marital Status Patient] WHEN 'M' THEN 'M' WHEN 'S' THEN 'S' ELSE 'U' END
	,REPLACE(REPLACE(REPLACE(REPLACE([Home Phone Patient], '-', ''), '(', ''), ')', ''), ' ', '')
	,CASE ISDATE([Date Of Birth Patient]) WHEN 1 THEN [Date Of Birth Patient] ELSE NULL END 
	,REPLACE([Social Security Number], '-', '')
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'U'
	,[Account Number]
	,[ID] -- auto ID we added to temp table
	,@VendorImportID
	,1
	,1
	,0
	,1
	,[Emercency Contact]
	,REPLACE(REPLACE(REPLACE(REPLACE([Emergency Contact Phone], '-', ''), '(', ''), ')', ''), ' ', '')
FROM dbo._patient

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- Patient Case (Depends on patient records already being imported, can only run after)
PRINT ''
PRINT 'Inserting records into PatientCase ...'
INSERT INTO dbo.PatientCase (
	PatientID,
	[Name],
	PayerScenarioID,
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
	,'Default Case'
	,5 -- 'Commercial' (I was told this is a 
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,realP.VendorID
	,@VendorImportID
FROM 
	dbo._patient tmpP
INNER JOIN dbo.Patient realP ON tmpP.ID = realP.VendorID AND realP.VendorImportID = @VendorImportID
WHERE
	realP.PracticeID = @PracticeID AND
	realP.VendorImportID = @VendorImportID -- This is very important as previous vendor imports can potentially contain VendorIDs that collide with this import. 
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- Insurance Policy
PRINT ''
PRINT 'Inserting records into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	PolicyNumber,
	GroupNumber,
	PatientRelationshipToInsured,
	HolderFirstName,
	HolderMiddleName,
	HolderLastName,
	HolderDOB,
	HolderSSN,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	HolderGender,
	HolderAddressLine1,
	HolderCity,
	HolderState,
	HolderCountry,
	HolderZipCode,
	HolderPhone,
	Notes,
	Copay,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT 
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,tmpP.[Prefix + Policy No]
	,tmpP.[Group Number]
	,'S'
	,tmpP.[First Name Patient]
	,tmpP.[Middle Initial Patient]
	,tmpP.[Last Name Patient]
	,CASE ISDATE(tmpP.[Date Of Birth Patient]) WHEN 1 THEN tmpP.[Date Of Birth Patient] ELSE NULL END 
	,REPLACE(tmpP.[Social Security Number], '-', '')
	,GETDATE()
	,0
	,GETDATE()
	,0
	,tmpP.[Sex Of Patient]
	,tmpP.[Address Line 1 Patient]
	,tmpP.[City Patient]
	,tmpP.[State Patient]
	,'USA'
	,LEFT(REPLACE(tmpP.[Zipcode Patient], '-', ''), 9)
	,REPLACE(REPLACE(REPLACE(REPLACE(tmpP.[Home Phone Patient], '-', ''), '(', ''), ')', ''), ' ', '')
	,'Record created via data import, please review.'
	,tmpP.[Co Pay]
	,@PracticeID
	,tmpP.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
FROM dbo._patient tmpP
INNER JOIN dbo.PatientCase pc ON tmpP.ID = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	tmpP.[Insurance Company Name] = icp.PlanName AND 
	tmpP.[Address Line 1] = icp.AddressLine1 AND
	tmpP.[City] = icp.City AND
	tmpP.[State] = icp.[State] AND
	icp.Country = 'USA' AND
	REPLACE(tmpP.[Zip Code], '-','') = icp.ZipCode AND
	REPLACE(REPLACE(REPLACE(REPLACE(tmpP.[Phone Number], '-', ''), '(', ''), ')', ''), ' ', '') = icp.Phone
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'
