USE superbill_10623_dev 
--USE superbill_10623_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @VendorName VARCHAR(100)
DECLARE @ImportNote VARCHAR(100)

-- This script ASSUMES that someone has created the first practice record. On dev I did this myself
-- But on prod please make sure her practive exists first, (and it's ID is 1).
SET @PracticeID = 1
SET @VendorName = 'Natalie Johnson Practice'
SET @ImportNote = 'Initial import for customer 10623. FBID: 4585'

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

DELETE FROM dbo.ContractToInsurancePlan WHERE ContractID IN (SELECT ContractID FROM dbo.[Contract] WHERE PracticeID = @PracticeID AND CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR))
DELETE FROM dbo.ContractFeeSchedule WHERE ContractID IN (SELECT ContractID FROM dbo.[Contract] WHERE PracticeID = @PracticeID AND CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR))
DELETE FROM dbo.[Contract] WHERE PracticeID = @PracticeID AND CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)


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
	Notes,
	AddressLine1,
	AddressLine2,
	City,
	[State],
	Country,
	ZipCode,
	Phone,
	PhoneExt,
	Fax,
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
	Name
	,[Code]
	,[Street 1]
	,[Street 2]
	,[City]
	,[State]
	,'USA'
	,REPLACE([Zip Code], '-','')
	,REPLACE(REPLACE(REPLACE(REPLACE([Phone], '-', ''), '(', ''), ')', ''), ' ', '')
	,Extension
	,REPLACE(REPLACE(REPLACE(REPLACE([Fax], '-', ''), '(', ''), ')', ''), ' ', '')
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[ID]
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
FROM dbo._importInsurance
WHERE
	NOT([Name] IS NULL) AND RTRIM(LTRIM([Name])) <> ''

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
	Notes,
	CreatedPracticeID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	InsuranceCompanyID
)
SELECT DISTINCT 
	impIns.[Name] + ' - ' + impIns.[Type]
	,impIns.[Street 1]
	,impIns.[City]
	,impIns.[State]
	,'USA'
	,REPLACE(impIns.[Zip Code], '-','')
	,REPLACE(REPLACE(REPLACE(REPLACE(impIns.[Phone], '-', ''), '(', ''), ')', ''), ' ', '')
	,impIns.Code
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impIns.[ID]
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo._importInsurance impIns
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorImportID = @VendorImportID AND
	impIns.Code = CAST(ic.Notes AS VARCHAR(10))
WHERE
	NOT([Name] IS NULL) AND RTRIM(LTRIM([Name])) <> ''
		
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
	,[Last Name]
	,[First Name]
	,[Middle Initial]
	,''
	,[Street 1]
	,[Street 2]
	,[City ]
	,[State]
	,[Country]
	,LEFT(REPLACE([Zip Code], '-', ''), 9)
	,CASE [Sex] WHEN 'Female' THEN 'F' WHEN 'Male' THEN 'M' ELSE 'U' END
	,'U'
	,REPLACE(REPLACE(REPLACE(REPLACE([Phone 1], '-', ''), '(', ''), ')', ''), ' ', '')
	,CASE ISDATE([Date Of Birth]) WHEN 1 THEN [Date Of Birth] ELSE NULL END 
	,REPLACE([Social Security Number], '-', '')
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'U'
	,[Chart Number]
	,[ID] -- auto ID we added to temp table
	,@VendorImportID
	,1
	,1
	,1
	,1
	,[Contact Name]
	,REPLACE(REPLACE(REPLACE(REPLACE([Contact Phone 1], '-', ''), '(', ''), ')', ''), ' ', '')
FROM dbo._importPatient

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
	CaseNumber,
	VendorID,
	VendorImportID
)
SELECT
	realP.PatientID
	,[Description]
	,5 -- 'Commercial' (I was told this is a good default)
	,'Created via data import'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,[Case Number]
	,[ID]
	,@VendorImportID
FROM 
	dbo._importPatientCase impCase
INNER JOIN dbo.Patient realP ON impCase.[Chart Number] = realP.MedicalRecordNumber AND realP.VendorImportID = @VendorImportID
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
	Copay,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation,
	HolderPrefix,
	HolderSuffix,
	HolderFirstName,
	HolderMiddleName,
	HolderLastName,
	HolderDOB,
	HolderSSN,
	HolderGender,
	HolderAddressLine1,
	HolderAddressLine2,
	HolderCity,
	HolderState,
	HolderCountry,
	HolderZipCode,
	HolderPhone
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,impPC.[Policy Number #1]
	,impPC.[Group Number #1]
	,CASE ISDATE(impPC.[Policy #1 Start Date]) WHEN 1 THEN impPC.[Policy #1 Start Date] ELSE NULL END
	,CASE ISDATE(impPC.[Policy #1 End Date]) WHEN 1 THEN impPC.[Policy #1 End Date] ELSE NULL END
	,CASE impPC.[Insured Relationship #1]
		WHEN 'Self' THEN 'S' 
		WHEN 'Child' THEN 'C'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impPC.[Copayment Amount]
	,@PracticeID
	,impPC.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE impPC.[Insured Relationship #1] WHEN 'Self' THEN NULL ELSE holder.[First Name] END
	,CASE impPC.[Insured Relationship #1] WHEN 'Self' THEN NULL ELSE holder.[Middle Initial] END
	,CASE impPC.[Insured Relationship #1] WHEN 'Self' THEN NULL ELSE holder.[Last Name] END
	,CASE impPC.[Insured Relationship #1] WHEN 'Self' THEN NULL ELSE CASE ISDATE(holder.[Date Of Birth]) WHEN 1 THEN holder.[Date Of Birth] ELSE NULL END END
	,CASE impPC.[Insured Relationship #1] WHEN 'Self' THEN NULL ELSE REPLACE(holder.[Social Security Number], '-', '') END
	,CASE impPC.[Insured Relationship #1] WHEN 'Self' THEN NULL ELSE CASE holder.[Sex]
		WHEN 'Male' THEN 'M' 
		WHEN 'Female' THEN 'F'
		ELSE 'U' END END
	,CASE impPC.[Insured Relationship #1] WHEN 'Self' THEN NULL ELSE holder.[Street 1] END
	,CASE impPC.[Insured Relationship #1] WHEN 'Self' THEN NULL ELSE holder.[Street 2] END
	,CASE impPC.[Insured Relationship #1] WHEN 'Self' THEN NULL ELSE holder.[City] END
	,CASE impPC.[Insured Relationship #1] WHEN 'Self' THEN NULL ELSE holder.[State] END
	,CASE impPC.[Insured Relationship #1] WHEN 'Self' THEN NULL ELSE holder.[Country] END
	,CASE impPC.[Insured Relationship #1] WHEN 'Self' THEN NULL ELSE LEFT(REPLACE(holder.[Zip Code], '-', ''), 9) END
	,CASE impPC.[Insured Relationship #1] WHEN 'Self' THEN NULL ELSE REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone 1], '-', ''), '(', ''), ')', ''), ' ', '') END
FROM dbo._importPatientCase impPC
INNER JOIN dbo.PatientCase pc ON impPC.[ID] = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN (
	SELECT DISTINCT [Chart Number], [Last Name], [First Name], [Middle Initial], [Street 1], [Street 2], [City], [State], [Zip Code], [Phone 1], [Social Security Number], [Sex], [Date of Birth], [Country] FROM _importPatient
) holder ON holder.[Chart Number] = impPC.Guarantor
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.[Insurance Carrier #1] = CAST(icp.Notes AS VARCHAR) --notes field of import table holds insurance carrier code
WHERE
	pc.PracticeID = @PracticeID AND
	pc.VendorImportID = @VendorImportID 

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
	Copay,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation,
	HolderPrefix,
	HolderSuffix,
	HolderFirstName,
	HolderMiddleName,
	HolderLastName,
	HolderDOB,
	HolderSSN,
	HolderGender,
	HolderAddressLine1,
	HolderAddressLine2,
	HolderCity,
	HolderState,
	HolderCountry,
	HolderZipCode,
	HolderPhone
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,2
	,impPC.[Policy Number #2]
	,impPC.[Group Number #2]
	,CASE ISDATE(impPC.[Policy #2 Start Date]) WHEN 1 THEN impPC.[Policy #2 Start Date] ELSE NULL END
	,CASE ISDATE(impPC.[Policy #2 End Date]) WHEN 1 THEN impPC.[Policy #2 End Date] ELSE NULL END
	,CASE impPC.[Insured Relationship #2]
		WHEN 'Self' THEN 'S' 
		WHEN 'Child' THEN 'C'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impPC.[Copayment Amount]
	,@PracticeID
	,impPC.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE impPC.[Insured Relationship #2] WHEN 'Self' THEN NULL ELSE holder.[First Name] END
	,CASE impPC.[Insured Relationship #2] WHEN 'Self' THEN NULL ELSE holder.[Middle Initial] END
	,CASE impPC.[Insured Relationship #2] WHEN 'Self' THEN NULL ELSE holder.[Last Name] END
	,CASE impPC.[Insured Relationship #2] WHEN 'Self' THEN NULL ELSE CASE ISDATE(holder.[Date Of Birth]) WHEN 1 THEN holder.[Date Of Birth] ELSE NULL END END
	,CASE impPC.[Insured Relationship #2] WHEN 'Self' THEN NULL ELSE REPLACE(holder.[Social Security Number], '-', '') END
	,CASE impPC.[Insured Relationship #2] WHEN 'Self' THEN NULL ELSE CASE holder.[Sex]
		WHEN 'Male' THEN 'M' 
		WHEN 'Female' THEN 'F'
		ELSE 'U' END END
	,CASE impPC.[Insured Relationship #2] WHEN 'Self' THEN NULL ELSE holder.[Street 1] END
	,CASE impPC.[Insured Relationship #2] WHEN 'Self' THEN NULL ELSE holder.[Street 2] END
	,CASE impPC.[Insured Relationship #2] WHEN 'Self' THEN NULL ELSE holder.[City] END
	,CASE impPC.[Insured Relationship #2] WHEN 'Self' THEN NULL ELSE holder.[State] END
	,CASE impPC.[Insured Relationship #2] WHEN 'Self' THEN NULL ELSE holder.[Country] END
	,CASE impPC.[Insured Relationship #2] WHEN 'Self' THEN NULL ELSE LEFT(REPLACE(holder.[Zip Code], '-', ''), 9) END
	,CASE impPC.[Insured Relationship #2] WHEN 'Self' THEN NULL ELSE REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone 1], '-', ''), '(', ''), ')', ''), ' ', '') END
FROM dbo._importPatientCase impPC
INNER JOIN dbo.PatientCase pc ON impPC.[ID] = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN (
	SELECT DISTINCT [Chart Number], [Last Name], [First Name], [Middle Initial], [Street 1], [Street 2], [City], [State], [Zip Code], [Phone 1], [Social Security Number], [Sex], [Date of Birth], [Country] FROM _importPatient
) holder ON holder.[Chart Number] = impPC.Guarantor
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.[Insurance Carrier #2] = CAST(icp.Notes AS VARCHAR) --notes field of import table holds insurance carrier code
WHERE
	pc.PracticeID = @PracticeID AND
	pc.VendorImportID = @VendorImportID AND
	NOT([Insured #2] IS NULL) AND [Insured #2] <> ''

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
	Copay,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation,
	HolderPrefix,
	HolderSuffix,
	HolderFirstName,
	HolderMiddleName,
	HolderLastName,
	HolderDOB,
	HolderSSN,
	HolderGender,
	HolderAddressLine1,
	HolderAddressLine2,
	HolderCity,
	HolderState,
	HolderCountry,
	HolderZipCode,
	HolderPhone
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,3
	,impPC.[Policy Number #3]
	,impPC.[Group Number #3]
	,CASE ISDATE(impPC.[Policy #3 Start Date]) WHEN 1 THEN impPC.[Policy #3 Start Date] ELSE NULL END
	,CASE ISDATE(impPC.[Policy #3 End Date]) WHEN 1 THEN impPC.[Policy #3 End Date] ELSE NULL END
	,CASE impPC.[Insured Relationship #3]
		WHEN 'Self' THEN 'S' 
		WHEN 'Child' THEN 'C'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impPC.[Copayment Amount]
	,@PracticeID
	,impPC.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE impPC.[Insured Relationship #3] WHEN 'Self' THEN NULL ELSE holder.[First Name] END
	,CASE impPC.[Insured Relationship #3] WHEN 'Self' THEN NULL ELSE holder.[Middle Initial] END
	,CASE impPC.[Insured Relationship #3] WHEN 'Self' THEN NULL ELSE holder.[Last Name] END
	,CASE impPC.[Insured Relationship #3] WHEN 'Self' THEN NULL ELSE CASE ISDATE(holder.[Date Of Birth]) WHEN 1 THEN holder.[Date Of Birth] ELSE NULL END END
	,CASE impPC.[Insured Relationship #3] WHEN 'Self' THEN NULL ELSE REPLACE(holder.[Social Security Number], '-', '') END
	,CASE impPC.[Insured Relationship #3] WHEN 'Self' THEN NULL ELSE CASE holder.[Sex]
		WHEN 'Male' THEN 'M' 
		WHEN 'Female' THEN 'F'
		ELSE 'U' END END
	,CASE impPC.[Insured Relationship #3] WHEN 'Self' THEN NULL ELSE holder.[Street 1] END
	,CASE impPC.[Insured Relationship #3] WHEN 'Self' THEN NULL ELSE holder.[Street 2] END
	,CASE impPC.[Insured Relationship #3] WHEN 'Self' THEN NULL ELSE holder.[City] END
	,CASE impPC.[Insured Relationship #3] WHEN 'Self' THEN NULL ELSE holder.[State] END
	,CASE impPC.[Insured Relationship #3] WHEN 'Self' THEN NULL ELSE holder.[Country] END
	,CASE impPC.[Insured Relationship #3] WHEN 'Self' THEN NULL ELSE LEFT(REPLACE(holder.[Zip Code], '-', ''), 9) END
	,CASE impPC.[Insured Relationship #3] WHEN 'Self' THEN NULL ELSE REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone 1], '-', ''), '(', ''), ')', ''), ' ', '') END
FROM dbo._importPatientCase impPC
INNER JOIN dbo.PatientCase pc ON impPC.[ID] = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN (
	SELECT DISTINCT [Chart Number], [Last Name], [First Name], [Middle Initial], [Street 1], [Street 2], [City], [State], [Zip Code], [Phone 1], [Social Security Number], [Sex], [Date of Birth], [Country] FROM _importPatient
) holder ON holder.[Chart Number] = impPC.Guarantor
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.[Insurance Carrier #3] = CAST(icp.Notes AS VARCHAR) --notes field of import table holds insurance carrier code
WHERE
	pc.PracticeID = @PracticeID AND
	pc.VendorImportID = @VendorImportID AND
	NOT([Insured #3] IS NULL) AND [Insured #3] <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




-- Contract for fee schedule
PRINT ''
PRINT 'Inserting records into Contract ...'
INSERT INTO dbo.[Contract] (
	PracticeID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	ContractName,
	[Description],
	ContractType,
	NoResponseTriggerPaper,
	NoResponseTriggerElectronic,
	Notes,
	Capitated,
	AnesthesiaTimeIncrement,
	RecordTimeStamp,
	EffectiveStartDate,
	EffectiveEndDate,
	PolicyValidator
)
VALUES 
(
	@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Default contract'
	,'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
	,'P'
	,45
	,45
	,CAST(@VendorImportID AS VARCHAR)
	,0
	,15
	,NULL
	,'5/18/2012'
	,'5/19/2013'
	,'NULL'
)

	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Contract Fee Schedule
PRINT ''
PRINT 'Inserting records into ContractFeeSchedule ...'
INSERT INTO dbo.ContractFeeSchedule (
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	ContractID,
	Gender,
	StandardFee,
	Allowable,
	ExpectedReimbursement,
	RVU,
	ProcedureCodeDictionaryID,
	PracticeRVU,
	MalpracticeRVU,
	BaseUnits
)
SELECT
	GETDATE()
	,0
	,GETDATE()
	,0
	,c.ContractID
	,'B'
	,[Amount A]
	,0
	,0
	,0
	,pcd.ProcedureCodeDictionaryID
	,0
	,0
	,0
FROM dbo._importFeeSchedule impFS
INNER JOIN dbo.[Contract] c ON CAST(c.Notes AS VARCHAR) = CAST(@VendorImportID AS VARCHAR)
INNER JOIN dbo.ProcedureCodeDictionary pcd ON impFS.[Code 1] = pcd.ProcedureCode
WHERE
	CAST([Amount A] AS MONEY) > 0
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




-- Contract for INSRUANCE fee schedule
PRINT ''
PRINT 'Inserting records into Contract (for insurance fee schedules) ...'
INSERT INTO dbo.[Contract] (
	PracticeID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	ContractName,
	[Description],
	ContractType,
	NoResponseTriggerPaper,
	NoResponseTriggerElectronic,
	Notes,
	Capitated,
	AnesthesiaTimeIncrement,
	RecordTimeStamp,
	EffectiveStartDate,
	EffectiveEndDate,
	PolicyValidator
)
SELECT DISTINCT
	@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[Insurance Code]
	,'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
	,'P'
	,30
	,30
	,CAST(@VendorImportID AS VARCHAR) + [Insurance Code]
	,0
	,15
	,NULL
	,'5/18/2012'
	,'5/19/2013'
	,'NULL'
FROM dbo._importInsuranceFeeSchedule IFS
WHERE
	CAST(Amount AS MONEY) > 0 AND NOT([Insurance Code]) IS NULL AND [Insurance Code] <> ''
	
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Contract Fee Schedule (FOR INSURANCE FEE SCHEDULE)
PRINT ''
PRINT 'Inserting records into ContractFeeSchedule (for insurance fee schedules) ...'
INSERT INTO dbo.ContractFeeSchedule (
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	ContractID,
	Gender,
	StandardFee,
	Allowable,
	ExpectedReimbursement,
	RVU,
	ProcedureCodeDictionaryID,
	PracticeRVU,
	MalpracticeRVU,
	BaseUnits
)
SELECT
	GETDATE()
	,0
	,GETDATE()
	,0
	,c.ContractID
	,'B'
	,Amount
	,0
	,0
	,0
	,pcd.ProcedureCodeDictionaryID
	,0
	,0
	,0
FROM dbo._importInsuranceFeeSchedule impIFS
INNER JOIN dbo.[Contract] c ON CAST(@VendorImportID AS VARCHAR) + [Insurance Code] = CAST(c.Notes AS VARCHAR)
INNER JOIN dbo.ProcedureCodeDictionary pcd ON impIFS.[Procedure] = pcd.ProcedureCode
WHERE
	CAST(Amount AS MONEY) > 0
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Contract To Insurance Plan
PRINT ''
PRINT 'Inserting records into ContractToInsurancePlan ...'
INSERT INTO dbo.ContractToInsurancePlan (
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	ContractID,
	PlanID
)
SELECT DISTINCT
	GETDATE()
	,0
	,GETDATE()
	,0
	,c.ContractID
	,icp.InsuranceCompanyPlanID
FROM dbo._importInsuranceFeeSchedule impIFS
INNER JOIN dbo.[Contract] c ON CAST(@VendorImportID AS VARCHAR) + [Insurance Code] = CAST(c.Notes AS VARCHAR)
INNER JOIN dbo.InsuranceCompanyPlan icp ON impIFS.[Insurance Code] = CAST(icp.Notes AS VARCHAR)
WHERE
	CAST(Amount AS MONEY) > 0

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

-- CLean up notes fields
UPDATE dbo.[Contract] 
SET
	Notes = ''
WHERE
	PracticeID = @PracticeID AND
	LEN(CAST(Notes AS VARCHAR)) < 7


COMMIT TRAN