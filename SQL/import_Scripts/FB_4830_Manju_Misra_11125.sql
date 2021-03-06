USE superbill_11125_dev 
--USE superbill_11125_prod
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
SET @VendorName = 'Manju Misra MD PC'
SET @ImportNote = 'Initial import for customer 11125. FBID: 4830'

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
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractToInsurancePlan records deleted'
DELETE FROM dbo.ContractFeeSchedule WHERE ContractID IN (SELECT ContractID FROM dbo.[Contract] WHERE PracticeID = @PracticeID AND CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR))
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractFeeSchedule records deleted'
DELETE FROM dbo.[Contract] WHERE PracticeID = @PracticeID AND CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Contract records deleted'


DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'


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
	,[Street_1]
	,[Street_2]
	,[City]
	,[State]
	,'USA'
	,LEFT(REPLACE([Zip_Code], '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([Phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,Extension
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([Fax], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
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
FROM dbo.[_import_20120613_Insurance]
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
	,impIns.[Street_1]
	,impIns.[City]
	,impIns.[State]
	,'USA'
	,LEFT(REPLACE(impIns.[Zip_Code], '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.[Phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,impIns.Code
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impIns.[ID]
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_import_20120613_Insurance] impIns
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
SELECT DISTINCT
	@PracticeID
	,''
	,[Last_Name]
	,[First_Name]
	,[Middle_Initial]
	,''
	,[Street_1]
	,[Street_2]
	,[City]
	,[State]
	,[Country]
	,LEFT(REPLACE([Zip_Code], '-', ''), 9)
	,CASE [Sex] WHEN 'Female' THEN 'F' WHEN 'Male' THEN 'M' ELSE 'U' END
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([Phone_1], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE([Date_Of_Birth]) WHEN 1 THEN [Date_Of_Birth] ELSE NULL END 
	,REPLACE([Social_Security_Number], '-', '')
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'U'
	,[Chart_Number]
	,[ID] -- auto ID we added to temp table
	,@VendorImportID
	,1
	,1
	,1
	,1
	,[Contact_Name]
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([Contact_Phone_1], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
FROM dbo.[_import_20120613_Patient]

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
	,[Case_Number]
	,[ID]
	,@VendorImportID
FROM 
	dbo.[_import_20120613_PatientCase] impCase
INNER JOIN dbo.Patient realP ON impCase.[Chart_Number] = realP.MedicalRecordNumber AND realP.VendorImportID = @VendorImportID
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
	,impPC.[Policy_Number_#1]
	,impPC.[Group_Number_#1]
	,CASE ISDATE(impPC.[Policy_#1_Start_Date]) WHEN 1 THEN impPC.[Policy_#1_Start_Date] ELSE NULL END
	,CASE ISDATE(impPC.[Policy_#1_End_Date]) WHEN 1 THEN impPC.[Policy_#1_End_Date] ELSE NULL END
	,CASE impPC.[Insured_Relationship_#1]
		WHEN 'Self' THEN 'S' 
		WHEN 'Child' THEN 'C'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impPC.[Copayment_Amount]
	,@PracticeID
	,impPC.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE impPC.[Insured_Relationship_#1] WHEN 'Self' THEN NULL ELSE holder.[First_Name] END
	,CASE impPC.[Insured_Relationship_#1] WHEN 'Self' THEN NULL ELSE holder.[Middle_Initial] END
	,CASE impPC.[Insured_Relationship_#1] WHEN 'Self' THEN NULL ELSE holder.[Last_Name] END
	,CASE impPC.[Insured_Relationship_#1] WHEN 'Self' THEN NULL ELSE CASE ISDATE(holder.[Date_Of_Birth]) WHEN 1 THEN holder.[Date_Of_Birth] ELSE NULL END END
	,CASE impPC.[Insured_Relationship_#1] WHEN 'Self' THEN NULL ELSE REPLACE(holder.[Social_Security_Number], '-', '') END
	,CASE impPC.[Insured_Relationship_#1] WHEN 'Self' THEN NULL ELSE CASE holder.[Sex]
		WHEN 'Male' THEN 'M' 
		WHEN 'Female' THEN 'F'
		ELSE 'U' END END
	,CASE impPC.[Insured_Relationship_#1] WHEN 'Self' THEN NULL ELSE holder.[Street_1] END
	,CASE impPC.[Insured_Relationship_#1] WHEN 'Self' THEN NULL ELSE holder.[Street_2] END
	,CASE impPC.[Insured_Relationship_#1] WHEN 'Self' THEN NULL ELSE holder.[City] END
	,CASE impPC.[Insured_Relationship_#1] WHEN 'Self' THEN NULL ELSE holder.[State] END
	,CASE impPC.[Insured_Relationship_#1] WHEN 'Self' THEN NULL ELSE holder.[Country] END
	,CASE impPC.[Insured_Relationship_#1] WHEN 'Self' THEN NULL ELSE LEFT(REPLACE(holder.[Zip_Code], '-', ''), 9) END
	,CASE impPC.[Insured_Relationship_#1] WHEN 'Self' THEN NULL ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone_1], '-', ''), '(', ''), ')', ''), ' ', ''), 10) END
FROM dbo.[_import_20120613_PatientCase] impPC
INNER JOIN dbo.PatientCase pc ON impPC.[ID] = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN (
	SELECT DISTINCT [Chart_Number], [Last_Name], [First_Name], [Middle_Initial], [Street_1], [Street_2], [City], [State], [Zip_Code], [Phone_1], [Social_Security_Number], [Sex], [Date_of_Birth], [Country] FROM dbo.[_import_20120613_Patient]
) holder ON holder.[Chart_Number] = impPC.Guarantor
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.[Insurance_Carrier_#1] = CAST(icp.Notes AS VARCHAR) --notes field of import table holds insurance carrier code
WHERE
	pc.PracticeID = @PracticeID AND
	pc.VendorImportID = @VendorImportID AND
	impPC.[Policy_Number_#1] <> ''

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
	,impPC.[Policy_Number_#2]
	,impPC.[Group_Number_#2]
	,CASE ISDATE(impPC.[Policy_#2_Start_Date]) WHEN 1 THEN impPC.[Policy_#2_Start_Date] ELSE NULL END
	,CASE ISDATE(impPC.[Policy_#2_End_Date]) WHEN 1 THEN impPC.[Policy_#2_End_Date] ELSE NULL END
	,CASE impPC.[Insured_Relationship_#2]
		WHEN 'Self' THEN 'S' 
		WHEN 'Child' THEN 'C'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impPC.[Copayment_Amount]
	,@PracticeID
	,impPC.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE impPC.[Insured_Relationship_#2] WHEN 'Self' THEN NULL ELSE holder.[First_Name] END
	,CASE impPC.[Insured_Relationship_#2] WHEN 'Self' THEN NULL ELSE holder.[Middle_Initial] END
	,CASE impPC.[Insured_Relationship_#2] WHEN 'Self' THEN NULL ELSE holder.[Last_Name] END
	,CASE impPC.[Insured_Relationship_#2] WHEN 'Self' THEN NULL ELSE CASE ISDATE(holder.[Date_Of_Birth]) WHEN 1 THEN holder.[Date_Of_Birth] ELSE NULL END END
	,CASE impPC.[Insured_Relationship_#2] WHEN 'Self' THEN NULL ELSE REPLACE(holder.[Social_Security_Number], '-', '') END
	,CASE impPC.[Insured_Relationship_#2] WHEN 'Self' THEN NULL ELSE CASE holder.[Sex]
		WHEN 'Male' THEN 'M' 
		WHEN 'Female' THEN 'F'
		ELSE 'U' END END
	,CASE impPC.[Insured_Relationship_#2] WHEN 'Self' THEN NULL ELSE holder.[Street_1] END
	,CASE impPC.[Insured_Relationship_#2] WHEN 'Self' THEN NULL ELSE holder.[Street_2] END
	,CASE impPC.[Insured_Relationship_#2] WHEN 'Self' THEN NULL ELSE holder.[City] END
	,CASE impPC.[Insured_Relationship_#2] WHEN 'Self' THEN NULL ELSE holder.[State] END
	,CASE impPC.[Insured_Relationship_#2] WHEN 'Self' THEN NULL ELSE holder.[Country] END
	,CASE impPC.[Insured_Relationship_#2] WHEN 'Self' THEN NULL ELSE LEFT(REPLACE(holder.[Zip_Code], '-', ''), 9) END
	,CASE impPC.[Insured_Relationship_#2] WHEN 'Self' THEN NULL ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone_1], '-', ''), '(', ''), ')', ''), ' ', ''), 10) END
FROM dbo.[_import_20120613_PatientCase] impPC
INNER JOIN dbo.PatientCase pc ON impPC.[ID] = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN (
	SELECT DISTINCT [Chart_Number], [Last_Name], [First_Name], [Middle_Initial], [Street_1], [Street_2], [City], [State], [Zip_Code], [Phone_1], [Social_Security_Number], [Sex], [Date_of_Birth], [Country] FROM dbo.[_import_20120613_Patient]
) holder ON holder.[Chart_Number] = impPC.Guarantor
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.[Insurance_Carrier_#2] = CAST(icp.Notes AS VARCHAR) --notes field of import table holds insurance carrier code
WHERE
	pc.PracticeID = @PracticeID AND
	pc.VendorImportID = @VendorImportID AND
	impPC.[Policy_Number_#2] <> ''

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
	,impPC.[Policy_Number_#3]
	,impPC.[Group_Number_#3]
	,CASE ISDATE(impPC.[Policy_#3_Start_Date]) WHEN 1 THEN impPC.[Policy_#3_Start_Date] ELSE NULL END
	,CASE ISDATE(impPC.[Policy_#3_End_Date]) WHEN 1 THEN impPC.[Policy_#3_End_Date] ELSE NULL END
	,CASE impPC.[Insured_Relationship_#3]
		WHEN 'Self' THEN 'S' 
		WHEN 'Child' THEN 'C'
		WHEN 'Spouse' THEN 'U'
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impPC.[Copayment_Amount]
	,@PracticeID
	,impPC.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE impPC.[Insured_Relationship_#3] WHEN 'Self' THEN NULL ELSE holder.[First_Name] END
	,CASE impPC.[Insured_Relationship_#3] WHEN 'Self' THEN NULL ELSE holder.[Middle_Initial] END
	,CASE impPC.[Insured_Relationship_#3] WHEN 'Self' THEN NULL ELSE holder.[Last_Name] END
	,CASE impPC.[Insured_Relationship_#3] WHEN 'Self' THEN NULL ELSE CASE ISDATE(holder.[Date_Of_Birth]) WHEN 1 THEN holder.[Date_Of_Birth] ELSE NULL END END
	,CASE impPC.[Insured_Relationship_#3] WHEN 'Self' THEN NULL ELSE REPLACE(holder.[Social_Security_Number], '-', '') END
	,CASE impPC.[Insured_Relationship_#3] WHEN 'Self' THEN NULL ELSE CASE holder.[Sex]
		WHEN 'Male' THEN 'M' 
		WHEN 'Female' THEN 'F'
		ELSE 'U' END END
	,CASE impPC.[Insured_Relationship_#3] WHEN 'Self' THEN NULL ELSE holder.[Street_1] END
	,CASE impPC.[Insured_Relationship_#3] WHEN 'Self' THEN NULL ELSE holder.[Street_2] END
	,CASE impPC.[Insured_Relationship_#3] WHEN 'Self' THEN NULL ELSE holder.[City] END
	,CASE impPC.[Insured_Relationship_#3] WHEN 'Self' THEN NULL ELSE holder.[State] END
	,CASE impPC.[Insured_Relationship_#3] WHEN 'Self' THEN NULL ELSE holder.[Country] END
	,CASE impPC.[Insured_Relationship_#3] WHEN 'Self' THEN NULL ELSE LEFT(REPLACE(holder.[Zip_Code], '-', ''), 9) END
	,CASE impPC.[Insured_Relationship_#3] WHEN 'Self' THEN NULL ELSE LEFT(REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone_1], '-', ''), '(', ''), ')', ''), ' ', ''), 10) END
FROM dbo.[_import_20120613_PatientCase] impPC
INNER JOIN dbo.PatientCase pc ON impPC.[ID] = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN (
	SELECT DISTINCT [Chart_Number], [Last_Name], [First_Name], [Middle_Initial], [Street_1], [Street_2], [City], [State], [Zip_Code], [Phone_1], [Social_Security_Number], [Sex], [Date_of_Birth], [Country] FROM dbo.[_import_20120613_Patient]
) holder ON holder.[Chart_Number] = impPC.Guarantor
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.[Insurance_Carrier_#3] = CAST(icp.Notes AS VARCHAR) --notes field of import table holds insurance carrier code
WHERE
	pc.PracticeID = @PracticeID AND
	pc.VendorImportID = @VendorImportID AND
	impPC.[Policy_Number_#3] <> ''

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
	,'S'
	,45
	,45
	,CAST(@VendorImportID AS VARCHAR)
	,0
	,15
	,NULL
	,'6/13/2012'
	,'6/14/2013'
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
	,[Amount_A]
	,0
	,0
	,0
	,pcd.ProcedureCodeDictionaryID
	,0
	,0
	,0
FROM dbo.[_import_20120613_StandardFeeSchedule] impFS
INNER JOIN dbo.[Contract] c ON CAST(c.Notes AS VARCHAR) = CAST(@VendorImportID AS VARCHAR)
INNER JOIN dbo.ProcedureCodeDictionary pcd ON impFS.[Code_1] = pcd.ProcedureCode
WHERE
	CAST([Amount_A] AS MONEY) > 0
	
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
	,[Insurance_Code]
	,'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
	,'P'
	,30
	,30
	,CAST(@VendorImportID AS VARCHAR) + [Insurance_Code]
	,0
	,15
	,NULL
	,'6/13/2012'
	,'6/14/2013'
	,'NULL'
FROM dbo.[_import_20120613_InsuranceFeeSchedule] IFS
WHERE
	CAST(Amount AS MONEY) > 0 AND NOT([Insurance_Code]) IS NULL AND [Insurance_Code] <> ''
	
	
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
FROM dbo.[_import_20120613_InsuranceFeeSchedule] impIFS
INNER JOIN dbo.[Contract] c ON CAST(@VendorImportID AS VARCHAR) + [Insurance_Code] = CAST(c.Notes AS VARCHAR)
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
FROM dbo.[_import_20120613_InsuranceFeeSchedule] impIFS
INNER JOIN dbo.[Contract] c ON CAST(@VendorImportID AS VARCHAR) + [Insurance_Code] = CAST(c.Notes AS VARCHAR)
INNER JOIN dbo.InsuranceCompanyPlan icp ON impIFS.[Insurance_Code] = CAST(icp.Notes AS VARCHAR)
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