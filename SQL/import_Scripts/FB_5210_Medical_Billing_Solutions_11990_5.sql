--USE superbill_11990_dev 
USE superbill_11990_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 5
SET @VendorImportID = 2 -- Vendor import record created through import tool

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
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientJournalNote records deleted'
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
	ReviewCode,
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
	insurance_name
	,[street_1_]
	,[street_2]
	,[city]
	,[state]
	,'USA'
	,LEFT(REPLACE([zip], '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,insurance_company_uid -- it's unique, we verified it!!!
	,@VendorImportID
	,0  -- BillSecondaryInsurance - bit
	,0 -- EClaimsAccepts - bit
	,13  -- BillingFormID - int
	,'R' -- ReviewCode
	,'CI' -- InsuranceProgramCode - char(2)
	,'C'  -- HCFADiagnosisReferenceFormatCode - char(1)
	,'D'  -- HCFASameAsInsuredFormatCode - char(1)
	,NULL  -- DefaultAdjustmentCode - varchar(10)
	,NULL  -- ReferringProviderNumberTypeID - int
	,1  -- NDCFormat - int
	,1 -- UseFacilityID - bit
	,'U'  -- AnesthesiaType - varchar(1)
	,18  -- InstitutionalBillingFormID - int,
	,13
FROM dbo._import_4_5_InsuranceList
WHERE
	insurance_name <> '' AND
	insurance_company_uid NOT IN (SELECT ISNULL(VendorID, '') FROM InsuranceCompany)


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
	impIns.insurance_name
	,impIns.[street_1_]
	,impIns.[street_2]
	,impIns.[city]
	,impIns.[state]
	,'USA'
	,LEFT(REPLACE(impIns.zip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impIns.insurance_company_uid
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo._import_4_5_InsuranceList impIns
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorImportID = @VendorImportID AND
	impIns.insurance_company_uid = ic.VendorID
WHERE
	impIns.insurance_name <> '' AND
	impIns.insurance_company_uid NOT IN (SELECT ISNULL(VendorID, '') FROM InsuranceCompanyPlan)
		
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Employers
PRINT ''
PRINT 'Inserting records into Employer ...'
INSERT INTO dbo.Employers (
	EmployerName,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID
)
SELECT DISTINCT
	employer_name,
	GETDATE(),
	0,
	GETDATE(),
	0
FROM dbo._import_4_5_PatientDemographics
WHERE employer_name NOT IN (SELECT EmployerName FROM Employers)

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
	MobilePhone,
	SSN ,
	ResponsibleRelationshipToPatient,
	MedicalRecordNumber,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	EmploymentStatus ,
	EmployerID,
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
	,impP.[middle_name]
	,''
	,impP.[street_1]
	,impP.[street_2]
	,impP.[city]
	,LEFT(impP.[state], 2)
	,'USA'
	,LEFT(REPLACE(impP.[zip_code], '-', ''), 9)
	,CASE impP.[Gender] WHEN 'Female' THEN 'F' WHEN 'Male' THEN 'M' ELSE 'U' END
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[home_telephone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[employer_phone_number], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[cell_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(impP.[ssn], '-', ''), 9)
	,'S'
	,[chart_number]
	,GETDATE()
	,0
	,GETDATE()
	,0
	,CASE 
		WHEN impP.employer_name = 'RETIRED' THEN 'R'
		WHEN impP.employer_name <> '' THEN 'E' 
		ELSE 'U' 
	END
	,emp.EmployerID
	,impP.[chart_number] -- It's unique, we verified it, h00ray!!!!
	,@VendorImportID
	,1
	,1
	,0
	,1
FROM dbo._import_4_5_PatientDemographics impP
LEFT OUTER JOIN dbo.Employers emp ON impP.employer_name = emp.EmployerName

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- PatientJornal Note
PRINT ''
PRINT 'Inserting records into PatientJournalNote ...'
INSERT INTO [dbo].[PatientJournalNote] (
	[CreatedDate]
	,[CreatedUserID]
	,[ModifiedDate]
	,[ModifiedUserID]
	,[PatientID]
	,[UserName]
	,[SoftwareApplicationID]
	,[NoteMessage]
)
SELECT DISTINCT
	GETDATE(),
	0,
	GETDATE(),
	0,
	realP.PatientID,
	'',
	'K',
	notes
FROM _import_4_5_PatientDemographics impP
INNER JOIN Patient realP ON impP.[chart_number] = realP.vendorID
WHERE impP.notes <> ''

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
	,'Case ' + impCase.[policy]
	,5 -- 'Commercial' (I was told this is a good default)
	,'Created via data import'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,ID -- This is our Kareo assigned ID, it's unique
	,@VendorImportID
FROM 
	dbo.[_import_4_5_PolicyInformation] impCase
INNER JOIN dbo.Patient realP ON impCase.[chart_number] = realP.VendorID AND realP.VendorImportID = @VendorImportID
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
	ReleaseOfInformation	
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,impPI.[policy]
	,impPI.[group_number]
	,'S' 
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impPI.ID -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
FROM dbo.[_import_4_5_PolicyInformation] impPI
INNER JOIN dbo.PatientCase pc ON impPI.ID = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	impPI.[ins_company_uid] = icp.VendorID
WHERE
	pc.VendorImportID = @VendorImportID AND
	impPI.[policy] <> ''

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
	,'8/16/2012'
	,'8/17/2013'
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
	,[unit_price]
	,0
	,0
	,0
	,pcd.ProcedureCodeDictionaryID
	,0
	,0
	,base_units
FROM dbo.[_import_4_5_FeeSchedule] impFS
INNER JOIN dbo.[Contract] c ON CAST(c.Notes AS VARCHAR) = CAST(@VendorImportID AS VARCHAR)
INNER JOIN dbo.ProcedureCodeDictionary pcd ON REPLACE(impFS.cpt, '-1', '') = pcd.ProcedureCode
WHERE
	CAST(unit_price AS MONEY) > 0
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- CLean up notes fields
UPDATE dbo.[Contract] 
SET
	Notes = ''
WHERE
	PracticeID = @PracticeID AND
	LEN(CAST(Notes AS VARCHAR)) < 7



COMMIT TRAN