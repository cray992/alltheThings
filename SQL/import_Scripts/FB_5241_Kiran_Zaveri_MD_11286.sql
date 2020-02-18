USE superbill_11286_dev 
--USE superbill_11286_prod
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


PRINT ''
PRINT 'WIPE CURRENT INSURANCE COMPANIES AND PLANS BEFORE IMPORT'

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Plan records deleted'
DELETE FROM dbo.PracticeToInsuranceCompany WHERE PracticeID = @PracticeID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PracticeToInsuranceCompany records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Companies records deleted'


-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.ContractFeeSchedule WHERE ContractID IN (SELECT ContractID FROM dbo.[Contract] WHERE PracticeID = @PracticeID AND CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR))
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractFeeSchedule records deleted'
DELETE FROM dbo.[Contract] WHERE PracticeID = @PracticeID AND CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Contract records deleted'
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
	[name]
	,[contact]
	,[street_1]
	,[street_2]
	,[city]
	,[state]
	,''
	,LEFT(REPLACE([zip_code], '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE([fax], '-', ''), '(', ''), ')', ''),  ' ', ''), 10)	
	,[extension]
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[code] -- it's unique, we verified it!!!
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
FROM dbo._import_1_1_InsuranceCompanies
WHERE
	name <> '' AND
	code NOT IN (SELECT ISNULL(VendorID, '') FROM InsuranceCompany)


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
	PhoneExt,
	Notes,
	CreatedPracticeID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Fax,
	InsuranceCompanyID,
	VendorID,
	VendorImportID
	
)
SELECT DISTINCT 
	impIns.[name]
	,impIns.[street_1]
	,impIns.[street_2]
	,impIns.[city]
	,LEFT(impIns.[state], 2)
	,''
	,LEFT(REPLACE(impIns.[zip_code], '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.[phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(impIns.[extension], 10)
	,impIns.[contact]
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.[fax], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,ic.InsuranceCompanyID
	,impIns.[code]
	,@VendorImportID
FROM dbo._import_1_1_InsuranceCompanies impIns
INNER JOIN dbo.InsuranceCompany ic ON  ic.VendorImportID = @VendorImportID AND
	impIns.code = ic.VendorID
WHERE
	impIns.name <> '' AND
	impIns.code NOT IN (SELECT ISNULL(VendorID, '') FROM InsuranceCompanyPlan)
		
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
	MobilePhone ,
	DOB ,
	SSN ,
	EmailAddress ,
	ResponsibleRelationshipToPatient ,
	MedicalRecordNumber ,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	SendEmailCorrespondence ,
	PhonecallRemindersEnabled ,
	EmergencyName ,
	EmergencyPhone 
	)
SELECT DISTINCT
	@PracticeID
	,''
	,impP.[last_name]
	,impP.[first_name]
	,impP.[middle_initial]
	,''
	,impP.[street_1]
	,impP.[street_2]
	,impP.[city]
	,LEFT(impP.[state], 2)
	,''
	,LEFT(REPLACE(impP.[zip_code], '-', ''), 9)
	,CASE impP.[sex] WHEN 'Female' THEN 'F' WHEN 'Male' THEN 'M' ELSE 'U' END
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[home_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[work_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[mobile_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.date_of_birth) WHEN 1 THEN impP.date_of_birth ELSE NULL END
	,LEFT(REPLACE(impP.[social_security_number], '-', ''), 9)
	,impP.[email]
	,'S'
	,impP.[chart_number]-- It's unique, we verified it, h00ray!!!!
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
	,impP.[emergency_contact]
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[emergency_contact_phone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
FROM dbo._import_1_1_Patients impP

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

		 
-- Patient Case 
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
	,'CASE ' + impCase.description	--CASE NAME ???
	,5 -- 'Commercial' (I was told this is a good default)
	,'Created via data import'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impCase.ID -- Our kareo assigned unique ID
	,@VendorImportID
FROM 
	dbo.[_import_1_1_PatientInsurancePolicies] impCase
INNER JOIN dbo.Patient realP ON impCase.[chart_number] = realP.VendorID AND 
	realP.VendorImportID = @VendorImportID
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
	Copay,
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
	,impPI.[policy_number_#1]
	,impPI.[group_number_#1] 
	,CASE WHEN (impPI.[chart_number] <> impPI.[insured_#1])  THEN		
		CASE impPI.insured_relationship_#1
			--WHEN 'Self' THEN 'S'
			WHEN 'Spounse' THEN 'U'
			WHEN 'Child' THEN 'C'
			ELSE 'O' END
	ELSE 'S' END				   
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impPi.[copayment_amount]
	,impPI.ID -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE WHEN (impPI.insured_#1 <> impPI.chart_number) THEN realP.FirstName ELSE NULL END
	,CASE WHEN (impPI.insured_#1 <> impPI.chart_number) THEN realP.MiddleName ELSE NULL END	
	,CASE WHEN (impPI.insured_#1 <> impPI.chart_number) THEN realP.LastName ELSE NULL END
	,CASE WHEN (impPI.insured_#1 <> impPI.chart_number) THEN realP.DOB ELSE NULL END
	,CASE WHEN (impPI.insured_#1 <> impPI.chart_number) THEN realP.SSN ELSE NULL END 
	,CASE WHEN (impPI.insured_#1 <> impPI.chart_number) THEN realP.Gender ELSE NULL END 
	,CASE WHEN (impPI.insured_#1 <> impPI.chart_number) THEN realP.AddressLine1 ELSE NULL END
	,CASE WHEN (impPI.insured_#1 <> impPI.chart_number) THEN realP.AddressLine2 ELSE NULL END 
	,CASE WHEN (impPI.insured_#1 <> impPI.chart_number) THEN realP.City ELSE NULL END
	,CASE WHEN (impPI.insured_#1 <> impPI.chart_number) THEN realP.[State] ELSE NULL END
	,CASE WHEN (impPI.insured_#1 <> impPI.chart_number) THEN realP.Country ELSE NULL END
	,CASE WHEN (impPI.insured_#1 <> impPI.chart_number) THEN realP.ZipCode ELSE NULL END
	,CASE WHEN (impPI.insured_#1 <> impPI.chart_number) THEN realP.HomePhone ELSE NULL END
FROM dbo.[_import_1_1_PatientInsurancePolicies] impPI
INNER JOIN dbo.PatientCase pc ON impPI.ID = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON impPI.insurance_carrier_#1 = icp.VendorID
INNER JOIN dbo.Patient realP ON realP.VendorID = impPI.insured_#1 AND
	realP.PracticeID = @PracticeID AND
	realP.VendorImportID = @VendorImportID
WHERE
	impPI.[insurance_carrier_#1] <> ''

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
	Copay,
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
	,impPI.[policy_number_#2]
	,impPI.[group_number_#2]
	,CASE WHEN (impPI.[chart_number] <> impPI.insured_#1) THEN		
		CASE impPI.insured_relationship_#2
			WHEN 'Self' THEN 'S'
			WHEN 'Spounse' THEN 'U'
			WHEN 'Child' THEN 'C'
			ELSE 'O' END
	ELSE 'S' END				   
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impPi.[copayment_amount]
	,impPI.ID -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE WHEN impPI.insured_#2 <> impPI.chart_number THEN realP.FirstName ELSE NULL END
	,CASE WHEN impPI.insured_#2 <> impPI.chart_number THEN realP.MiddleName ELSE NULL END	
	,CASE WHEN impPI.insured_#2 <> impPI.chart_number THEN realP.LastName ELSE NULL END
	,CASE WHEN impPI.insured_#2 <> impPI.chart_number THEN realP.DOB ELSE NULL END
	,CASE WHEN impPI.insured_#2 <> impPI.chart_number THEN realP.SSN ELSE NULL END 
	,CASE WHEN impPI.insured_#2 <> impPI.chart_number THEN realP.Gender ELSE NULL END 
	,CASE WHEN impPI.insured_#2 <> impPI.chart_number THEN realP.AddressLine1 ELSE NULL END
	,CASE WHEN impPI.insured_#2 <> impPI.chart_number THEN realP.AddressLine2 ELSE NULL END 
	,CASE WHEN impPI.insured_#2 <> impPI.chart_number THEN realP.City ELSE NULL END
	,CASE WHEN impPI.insured_#2 <> impPI.chart_number THEN realP.[State] ELSE NULL END
	,CASE WHEN impPI.insured_#2 <> impPI.chart_number THEN realP.Country ELSE NULL END
	,CASE WHEN impPI.insured_#2 <> impPI.chart_number THEN realP.ZipCode ELSE NULL END
	,CASE WHEN impPI.insured_#2 <> impPI.chart_number THEN realP.HomePhone ELSE NULL END
FROM dbo.[_import_1_1_PatientInsurancePolicies] impPI
INNER JOIN dbo.PatientCase pc ON impPI.ID = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON impPI.insurance_carrier_#2 = icp.VendorID
INNER JOIN dbo.Patient realP ON realP.VendorID = impPI.insured_#2 AND
	realP.PracticeID = @PracticeID AND
	realP.VendorImportID = @VendorImportID

WHERE
	pc.VendorImportID = @VendorImportID AND
	impPI.[insurance_carrier_#2] <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Insurance Policy #3
PRINT ''
PRINT 'Inserting records into InsurancePolicy #3 ...'
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
	Copay,
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
	,impPI.[policy_number_#3]
	,impPI.[group_number_#3]
	,CASE WHEN (impPI.[chart_number] <> impPI.insured_#3) THEN		
		CASE impPI.insured_relationship_#3
			WHEN 'Self' THEN 'S'
			WHEN 'Spounse' THEN 'U'
			WHEN 'Child' THEN 'C'
			ELSE 'O' END
	ELSE 'S' END				   
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impPI.[copayment_amount]
	,impPI.ID -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE WHEN impPI.insured_#3 <> impPI.chart_number THEN realP.FirstName ELSE NULL END
	,CASE WHEN impPI.insured_#3 <> impPI.chart_number THEN realP.MiddleName ELSE NULL END	
	,CASE WHEN impPI.insured_#3 <> impPI.chart_number THEN realP.LastName ELSE NULL END
	,CASE WHEN impPI.insured_#3 <> impPI.chart_number THEN realP.DOB ELSE NULL END
	,CASE WHEN impPI.insured_#3 <> impPI.chart_number THEN realP.SSN ELSE NULL END 
	,CASE WHEN impPI.insured_#3 <> impPI.chart_number THEN realP.Gender ELSE NULL END 
	,CASE WHEN impPI.insured_#3 <> impPI.chart_number THEN realP.AddressLine1 ELSE NULL END
	,CASE WHEN impPI.insured_#3 <> impPI.chart_number THEN realP.AddressLine2 ELSE NULL END 
	,CASE WHEN impPI.insured_#3 <> impPI.chart_number THEN realP.City ELSE NULL END
	,CASE WHEN impPI.insured_#3 <> impPI.chart_number THEN realP.[State] ELSE NULL END
	,CASE WHEN impPI.insured_#3 <> impPI.chart_number THEN realP.Country ELSE NULL END
	,CASE WHEN impPI.insured_#3 <> impPI.chart_number THEN realP.ZipCode ELSE NULL END
	,CASE WHEN impPI.insured_#3 <> impPI.chart_number THEN realP.HomePhone ELSE NULL END
FROM dbo.[_import_1_1_PatientInsurancePolicies] impPI
INNER JOIN dbo.PatientCase pc ON impPI.ID = pc.VendorID AND pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON impPI.insurance_carrier_#3 = icp.VendorID
INNER JOIN dbo.Patient realP ON realP.VendorID = impPI.insured_#3 AND
	realP.PracticeID = @PracticeID AND
	realP.VendorImportID = @VendorImportID

WHERE
	pc.VendorImportID = @VendorImportID AND
	impPI.[insurance_carrier_#3] <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



COMMIT TRAN

