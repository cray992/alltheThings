USE superbill_10931_dev 
--USE superbill_10931_prod
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
SET @VendorName = 'Alan Olmstead, MD, CHTD'
SET @ImportNote = 'Initial import for customer 10931. FBID: 4753'

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

DELETE FROM dbo.ContractFeeSchedule WHERE ContractID IN (SELECT ContractID FROM dbo.[Contract] WHERE PracticeID = @PracticeID AND CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR))
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractFeeSchedule records deleted'
DELETE FROM dbo.[Contract] WHERE PracticeID = @PracticeID AND CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Contract records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
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
	AddressLine1,
	AddressLine2,
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
	Company
	,Address1
	,Address2
	,City
	,[State]
	,'USA'
	,LEFT(REPLACE(Zip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(Phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,Code -- Using the vendor's identifier here but only because I verified it's unique per record and referenced in other import tables
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
FROM dbo._importInsuranceCompany


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
	impIns.Company
	,impIns.Address1
	,impIns.Address2
	,impIns.City
	,impIns.[State]
	,'USA'
	,LEFT(REPLACE(impIns.Zip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.Phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impIns.Code
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo._importInsuranceCompany impIns
INNER JOIN dbo.InsuranceCompany ic ON @VendorImportID = ic.VendorImportID AND impIns.Code = ic.VendorID

		
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
	WorkPhone,
	DOB ,
	SSN ,
	ResponsibleRelationshipToPatient,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	EmploymentStatus ,
	MedicalRecordNumber ,
	MobilePhone,
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
	,[LastName]
	,[FirstName]
	,[Middle]
	,''
	,[Address1]
	,[Address2]
	,[City]
	,LEFT([State], 2)
	,'USA'
	,LEFT(REPLACE([Zip], '-', ''), 9)
	,CASE [Sex] 
		WHEN 'M' THEN 'M'
		WHEN 'F' THEN 'F'
		ELSE 'U'
	END
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([Phone_Home], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([Phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(BirthDate) WHEN 1 THEN [BirthDate] ELSE NULL END 
	,LEFT(REPLACE([SS], '-', ''), 9)
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'U'
	,[Code]
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([Phone_Cell], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,[Code] -- Using vendor provided code, but only because I've verfied it is unique per record, and used as a foreign key in other import tables
	,@VendorImportID
	,1
	,1
	,1
	,1
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
	,'Default Case'
	,5 -- 'Commercial' (I was told this is a good default)
	,'Created via data import'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impP.Code
	,impP.Code -- Using the vendor supplied ID, I verified it's unique per record 
	,@VendorImportID
FROM 
	dbo._importPatient impP
INNER JOIN dbo.Patient realP ON impP.Code = realP.VendorID
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
	,impP.Ins1_ID
	,impP.Ins1_Group
	,CASE 
		WHEN impP.Code = impP.Ins1_Guar THEN 'S' 
		ELSE 'O'
	END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impP.Code -- Vendor's unique ID
	,@VendorImportID
	,'Y'
	,''
	,''
	,holder.FirstName 
	,holder.Middle 
	,holder.LastName 
	,CASE ISDATE(holder.[BirthDate]) WHEN 1 THEN holder.[BirthDate] ELSE NULL END
	,REPLACE(holder.[SS], '-', '') 
	,CASE holder.[Sex]
		WHEN 'M' THEN 'M' 
		WHEN 'F' THEN 'F'
		ELSE 'U' 
	END
	,holder.[Address1] 
	,holder.[Address2] 
	,holder.[City] 
	,LEFT(holder.[State] , 2)
	,'USA'
	,LEFT(REPLACE(holder.[Zip], '-', ''), 9) 
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone_Home], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
FROM dbo._importPatient impP
INNER JOIN dbo.PatientCase pc ON impP.Code = pc.VendorID
LEFT OUTER JOIN (
	SELECT DISTINCT Code, FirstName, Middle, LastName, Address1, Address2, City, State, Zip, Phone_Home, Sex, SS, BirthDate FROM _importPatient
) holder ON holder.Code = impP.Ins1_Guar
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	@VendorImportID  = icp.VendorImportID AND
	impP.Ins1_Code = icp.VendorID
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
	,impP.Ins2_ID
	,impP.Ins2_Group
	,CASE 
		WHEN impP.Code = impP.Ins2_Guar THEN 'S' 
		ELSE 'O'
	END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impP.Code -- Vendor's unique ID
	,@VendorImportID
	,'Y'
	,''
	,''
	,holder.FirstName 
	,holder.Middle 
	,holder.LastName 
	,CASE ISDATE(holder.[BirthDate]) WHEN 1 THEN holder.[BirthDate] ELSE NULL END
	,REPLACE(holder.[SS], '-', '') 
	,CASE holder.[Sex]
		WHEN 'M' THEN 'M' 
		WHEN 'F' THEN 'F'
		ELSE 'U' 
	END
	,holder.[Address1] 
	,holder.[Address2] 
	,holder.[City] 
	,LEFT(holder.[State] , 2)
	,'USA'
	,LEFT(REPLACE(holder.[Zip], '-', ''), 9) 
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(holder.[Phone_Home], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
FROM dbo._importPatient impP
INNER JOIN dbo.PatientCase pc ON impP.Code = pc.VendorID
LEFT OUTER JOIN (
	SELECT DISTINCT Code, FirstName, Middle, LastName, Address1, Address2, City, State, Zip, Phone_Home, Sex, SS, BirthDate FROM _importPatient
) holder ON holder.Code = impP.Ins2_Guar
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	@VendorImportID  = icp.VendorImportID AND
	impP.Ins2_Code = icp.VendorID
WHERE
	pc.PracticeID = @PracticeID AND
	pc.VendorImportID = @VendorImportID 

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Contract for fee schedule
PRINT ''
PRINT 'Inserting records into Contract  ...'
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
	,'Contract ' + Fee_Code
	,'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
	, CASE Fee_Code WHEN '0' THEN 'S' ELSE 'P' END AS ContractType
	,45
	,45
	,CAST(@VendorImportID AS VARCHAR)
	,0
	,15
	,NULL
	,'6/1/2012'
	,'6/2/2013'
	,'NULL'
FROM _importFeeSChedule

	
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
	,impFS.Amount
	,0
	,0
	,0
	,pcd.ProcedureCodeDictionaryID
	,0
	,0
	,0
FROM dbo._importFeeSchedule impFS
INNER JOIN dbo.[Contract] c ON CAST(c.Notes AS VARCHAR) = CAST(@VendorImportID AS VARCHAR) AND c.ContractName = 'Contract ' + impFS.Fee_Code
INNER JOIN dbo.ProcedureCodeDictionary pcd ON impFS.[CPT_Code] = pcd.ProcedureCode

	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Clean up notes fields
UPDATE dbo.[Contract] 
SET
	Notes = ''
WHERE
	PracticeID = @PracticeID AND
	LEN(CAST(Notes AS VARCHAR)) < 7


COMMIT TRAN