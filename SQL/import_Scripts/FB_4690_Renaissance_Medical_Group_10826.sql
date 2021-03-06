USE superbill_10826_dev
--USE superbill_10826_prod
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
SET @VendorName = 'Renaissance Medical Group LLC'
SET @ImportNote = 'Initial import for customer 10826 - FB 4690'

-- If the VendorImport record doesn't exist create it
IF NOT EXISTS (SELECT * FROM dbo.VendorImport WHERE VendorName = @VendorName AND Notes = @ImportNote)
BEGIN
	INSERT INTO dbo.VendorImport (VendorName, VendorFormat, DateCreated, Notes) 
	VALUES (@VendorName, 'CSV', GETDATE(), @ImportNote)
END

SET @VendorImportID = (SELECT VendorImportID FROM dbo.VendorImport WHERE VendorName = @VendorName AND Notes = @ImportNote)

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clean up the import table
DELETE FROM dbo.[_import-FB4690] WHERE PatientAccountNumber = ''

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID

-- Insurance Company
PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany (
	InsuranceCompanyName,
	AddressLine1,
	AddressLine2,
	City,
	[State],
	Country,
	ZipCode,
	Phone,
	CompanyTextID,
	CreatedPracticeID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	BillSecondaryInsurance ,
	EClaimsAccepts ,
	BillingFormID ,
	InsuranceProgramCode ,
	HCFADiagnosisReferenceFormatCode ,
	HCFASameAsInsuredFormatCode ,
	DefaultAdjustmentCode ,
	ReferringProviderNumberTypeID ,
	NDCFormat ,
	UseFacilityID ,
	AnesthesiaType ,
	InstitutionalBillingFormID,
	SecondaryPrecedenceBillingFormID 
	)
SELECT DISTINCT 
	sourceIC.[Name]
	,sourceIC.Street1
	,sourceIC.Street2
	,sourceIC.City
	,sourceIC.[State]
	,'USA'
	,LEFT(REPLACE(sourceIC.Zip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(sourceIC.Phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,sourceIC.[ID]
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,0
	,@VendorImportID,
	0 , -- BillSecondaryInsurance - bit
	0, -- EClaimsAccepts - bit
	13 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	NULL , -- DefaultAdjustmentCode - varchar(10)
	NULL , -- ReferringProviderNumberTypeID - int
	1 , -- NDCFormat - int
	1, -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 , -- InstitutionalBillingFormID - int,
	13
FROM
(
	SELECT DISTINCT Insurance1ID AS 'ID', Insurance1Name AS 'Name', Insurance1Address1 AS 'Street1', Insurance1Address2 AS 'Street2', Insurance1City AS 'City', Insurance1State AS 'State', Insurance1Zip AS 'Zip', Insurance1Phone AS 'Phone' FROM [_import-FB4690]
	UNION ALL
	SELECT DISTINCT Insurance2ID AS 'ID', Insurance2Name AS 'Name', Insurance2Address1 AS 'Street1', Insurance2Address2 AS 'Street2', Insurance2City AS 'City', Insurance2State AS 'State', Insurance2Zip AS 'Zip', Insurance2Phone AS 'Phone' FROM [_import-FB4690]
	UNION ALL
	SELECT DISTINCT Insurance3ID AS 'ID', Insurance3Name AS 'Name', Insurance3Address1 AS 'Street1', Insurance3Address2 AS 'Street2', Insurance3City AS 'City', Insurance3State AS 'State', Insurance3Zip AS 'Zip', Insurance3Phone AS 'Phone' FROM [_import-FB4690]
) AS sourceIC
WHERE sourceIC.ID <> '' AND LEN(sourceIC.ID) < 8

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Insurance Company Plan
PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan (
	PlanName,
	AddressLine1,
	AddressLine2,
	City,
	[State],
	Country,
	ZipCode,
	Phone,
	Notes,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	CreatedPracticeID,
	VendorID,
	VendorImportID,
	InsuranceCompanyID
)
SELECT
 DISTINCT 
	sourceIC.[Name]
	,sourceIC.Street1
	,sourceIC.Street2
	,sourceIC.City
	,sourceIC.[State]
	,'USA'
	,LEFT(REPLACE(sourceIC.Zip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(sourceIC.Phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,ic.CompanyTextID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,0
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM
(
	SELECT DISTINCT Insurance1ID AS 'ID', Insurance1Name AS 'Name', Insurance1Address1 AS 'Street1', Insurance1Address2 AS 'Street2', Insurance1City AS 'City', Insurance1State AS 'State', Insurance1Zip AS 'Zip', Insurance1Phone AS 'Phone' FROM [_import-FB4690]
	UNION ALL
	SELECT DISTINCT Insurance2ID AS 'ID', Insurance2Name AS 'Name', Insurance2Address1 AS 'Street1', Insurance2Address2 AS 'Street2', Insurance2City AS 'City', Insurance2State AS 'State', Insurance2Zip AS 'Zip', Insurance2Phone AS 'Phone' FROM [_import-FB4690]
	UNION ALL
	SELECT DISTINCT Insurance3ID AS 'ID', Insurance3Name AS 'Name', Insurance3Address1 AS 'Street1', Insurance3Address2 AS 'Street2', Insurance3City AS 'City', Insurance3State AS 'State', Insurance3Zip AS 'Zip', Insurance3Phone AS 'Phone' FROM [_import-FB4690]
) AS sourceIC
INNER JOIN dbo.InsuranceCompany ic ON sourceIC.[ID] = ic.CompanyTextID
WHERE 
	ic.VendorImportID = @VendorImportID AND 
	sourceIC.ID <> '' AND 
	LEN(sourceIC.ID) < 8
		
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
	AddressLine2 ,
	City ,
	[State] ,
	Country ,
	ZipCode ,
	Gender ,
	MaritalStatus ,
	HomePhone ,
	WorkPhone,
	DOB ,
	SSN ,
	ResponsibleDifferentThanPatient,
	ResponsibleRelationshipToPatient,
	ResponsiblePrefix,
	ResponsibleFirstName,
	ResponsibleMiddleName,
	ResponsibleLastName,
	ResponsibleSuffix,
	ResponsibleAddressLine1,
	ResponsibleAddressLine2,
	ResponsibleCity,
	ResponsibleState,
	ResponsibleCountry,
	ResponsibleZipCode,
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
	PhonecallRemindersEnabled
	)
SELECT
	@PracticeID
	,''
	,PatientFirstName
	,PatientMiddleName
	,PatientLastName
	,''
	,PatientAddress1
	,PatientAddress2
	,PatientCity
	,PatientState
	,'USA'
	,LEFT(REPLACE(PatientZip, '-', ''), 9)
	,PatientGender
	,CASE PatientMaritalStatus
		WHEN 'married' THEN 'M'
		WHEN 'divorced' THEN 'D'
		WHEN 'widowed' THEN 'W'
		WHEN 'single' THEN 'S'
		ELSE 'U'
	END
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(PatientHomePhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(PatientWorkPhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(PatientDOB) WHEN 1 THEN PatientDOB ELSE NULL END 
	,REPLACE(PatientSSN, '-', '')
	,CASE GuarantorRelationshipToPatient
		WHEN 'Self' THEN 0
		ELSE 1
	END
	,CASE GuarantorRelationshipToPatient
		WHEN 'Child' THEN 'C'
		WHEN 'Self' THEN 'S'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O'
	END
	,''
	,CASE GuarantorRelationshipToPatient WHEN 'Self' THEN NULL ELSE GuarantorFirstName END
	,CASE GuarantorRelationshipToPatient WHEN 'Self' THEN NULL ELSE GuarantorMiddleName END
	,CASE GuarantorRelationshipToPatient WHEN 'Self' THEN NULL ELSE GuarantorLastName END
	,''
	,CASE GuarantorRelationshipToPatient WHEN 'Self' THEN NULL ELSE GuarantorAddress1 END
	,CASE GuarantorRelationshipToPatient WHEN 'Self' THEN NULL ELSE GuarantorAddress2 END
	,CASE GuarantorRelationshipToPatient WHEN 'Self' THEN NULL ELSE GuarantorCity END
	,CASE GuarantorRelationshipToPatient WHEN 'Self' THEN NULL ELSE GuarantorState END
	,CASE GuarantorRelationshipToPatient WHEN 'Self' THEN NULL ELSE 'USA' END
	,CASE GuarantorRelationshipToPatient WHEN 'Self' THEN NULL ELSE LEFT(REPLACE(GuarantorZip, '-', ''), 9) END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,CASE PatientEmploymentStatus
		WHEN 'E' THEN 'E'
		ELSE 'U'
	END
	,PatientAccountNumber
	,VendorID -- auto ID we added to temp table
	,@VendorImportID
	,1
	,1
	,1
	,1
FROM dbo.[_import-FB4690]

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Patient Case (Depends on patient records already being imported, can only run after)
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
	VendorID,
	VendorImportID
)
SELECT
	realP.PatientID
	,'Default Case'
	,5 -- 'Commercial' (I was told this is a good default)
	,'Created via data import'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,[_import-FB4690].VendorID
	,@VendorImportID
FROM 
	dbo.[_import-FB4690]
INNER JOIN dbo.Patient realP ON [_import-FB4690].VendorID = realP.VendorID AND realP.VendorImportID = @VendorImportID
WHERE
	realP.PracticeID = @PracticeID AND
	realP.VendorImportID = @VendorImportID -- This is very important as previous vendor imports can potentially contain VendorIDs that collide with this import. 
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy #1
PRINT ''
PRINT 'Inserting records into InsurancePolicy #1...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
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
	HolderLastName,
	HolderDOB,
	HolderSSN
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,impPC.Insurance1PolicyIDNumber
	,impPC.Insurance1GroupNumber
	,CASE ISDATE(impPC.Insurance1PolicyStartDate) WHEN 1 THEN impPC.Insurance1PolicyStartDate ELSE NULL END
	,CASE ISDATE(impPC.Insurance1PolicyEndDate) WHEN 1 THEN impPC.Insurance1PolicyEndDate ELSE NULL END
	,CASE impPC.Insured1RelationToPatient
		WHEN 'Self' THEN 'S' 
		WHEN 'Child' THEN 'C'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impPC.VendorID -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE impPC.Insured1RelationToPatient WHEN 'Self' THEN NULL ELSE Insured1Name END
	,CASE impPC.Insured1RelationToPatient WHEN 'Self' THEN NULL ELSE Insured1Name END
	,CASE impPC.Insured1RelationToPatient WHEN 'Self' THEN NULL ELSE CASE ISDATE(Insured1DOB) WHEN 1 THEN Insured1DOB ELSE NULL END END
	,CASE impPC.Insured1RelationToPatient WHEN 'Self' THEN NULL ELSE REPLACE(Insured1SSN, '-', '') END
FROM dbo.[_import-FB4690] impPC
INNER JOIN dbo.PatientCase pc ON impPC.VendorID = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.VendorImportID = @VendorImportID AND impPC.Insurance1ID = CAST(icp.Notes AS VARCHAR) --notes field of icp holds insuranceid
WHERE
	pc.PracticeID = @PracticeID AND
	pc.VendorImportID = @VendorImportID AND
	Insurance1ID <> ''

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
	HolderLastName,
	HolderDOB,
	HolderSSN
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,2
	,impPC.Insurance2PolicyIDNumber
	,impPC.Insurance2GroupNumber
	,CASE ISDATE(impPC.Insurance2PolicyStartDate) WHEN 1 THEN impPC.Insurance2PolicyStartDate ELSE NULL END
	,CASE ISDATE(impPC.Insurance2PolicyEndDate) WHEN 1 THEN impPC.Insurance2PolicyEndDate ELSE NULL END
	,CASE impPC.Insured2RelationToPatient
		WHEN 'Self' THEN 'S' 
		WHEN 'Child' THEN 'C'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impPC.VendorID -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE impPC.Insured2RelationToPatient WHEN 'Self' THEN NULL ELSE Insured2Name END
	,CASE impPC.Insured2RelationToPatient WHEN 'Self' THEN NULL ELSE Insured2Name END
	,CASE impPC.Insured2RelationToPatient WHEN 'Self' THEN NULL ELSE CASE ISDATE(Insured2DOB) WHEN 1 THEN Insured2DOB ELSE NULL END END
	,CASE impPC.Insured2RelationToPatient WHEN 'Self' THEN NULL ELSE REPLACE(Insured2SSN, '-', '') END
FROM dbo.[_import-FB4690] impPC
INNER JOIN dbo.PatientCase pc ON impPC.VendorID = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.VendorImportID = @VendorImportID AND impPC.Insurance2ID = CAST(icp.Notes AS VARCHAR) --notes field of icp holds insuranceid
WHERE
	pc.PracticeID = @PracticeID AND
	pc.VendorImportID = @VendorImportID AND
	Insurance2ID <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy #3
PRINT ''
PRINT 'Inserting records into InsurancePolicy #3...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	GroupNumber,
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
	HolderLastName,
	HolderDOB,
	HolderSSN
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,3
	,impPC.Insurance3PolicyIDNumber
	,impPC.Insurance3GroupNumber
	,CASE ISDATE(impPC.Insurance3PolicyStartDate) WHEN 1 THEN impPC.Insurance3PolicyStartDate ELSE NULL END
	,CASE ISDATE(impPC.Insurance3PolicyEndDate) WHEN 1 THEN impPC.Insurance3PolicyEndDate ELSE NULL END
	,CASE impPC.Insured3RelationToPatient
		WHEN 'Self' THEN 'S' 
		WHEN 'Child' THEN 'C'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impPC.VendorID -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE impPC.Insured3RelationToPatient WHEN 'Self' THEN NULL ELSE Insured3Name END
	,CASE impPC.Insured3RelationToPatient WHEN 'Self' THEN NULL ELSE Insured3Name END
	,CASE impPC.Insured3RelationToPatient WHEN 'Self' THEN NULL ELSE CASE ISDATE(Insured3DOB) WHEN 1 THEN Insured3DOB ELSE NULL END END
	,CASE impPC.Insured3RelationToPatient WHEN 'Self' THEN NULL ELSE REPLACE(Insured3SSN, '-', '') END
FROM dbo.[_import-FB4690] impPC
INNER JOIN dbo.PatientCase pc ON impPC.VendorID = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON icp.VendorImportID = @VendorImportID AND impPC.Insurance3ID = CAST(icp.Notes AS VARCHAR) --notes field of icp holds insuranceid
WHERE
	pc.PracticeID = @PracticeID AND
	pc.VendorImportID = @VendorImportID AND
	Insurance3ID <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT TRAN