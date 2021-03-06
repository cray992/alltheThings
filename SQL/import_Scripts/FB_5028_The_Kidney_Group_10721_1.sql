USE superbill_10721_dev 
--USE superbill_10721_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 4 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

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
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'



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
	ins_company_name
	,street_1
	,street_2
	,city
	,[state]
	,'USA'
	,LEFT(REPLACE(zip, '-',''), 9)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,ID
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
FROM dbo.[_import_4_1_Insurancecompanies]

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
	impIns.ins_company_name
	,impIns.street_1
	,impIns.street_2
	,impIns.city
	,impIns.[state]
	,'USA'
	,LEFT(REPLACE(impIns.zip, '-',''), 9)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impIns.ID
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_import_4_1_Insurancecompanies] impIns
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorImportID = @VendorImportID AND
	impIns.ID = ic.VendorID
		
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Doctor Referring
PRINT ''
PRINT 'Inserting records into Doctor (Referring) ...'
INSERT INTO dbo.Doctor ( 
	PracticeID,
	Prefix,
	FirstName,
	MiddleName,
	LastName,
	Suffix,
	AddressLine1,
	AddressLine2,
	City,
	STATE,
	Country,
	ZipCode,
	WorkPhone,
	FaxNumber,
	MobilePhone,
	ActiveDoctor,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Degree,
	VendorID,
	VendorImportID,
	[External],
	NPI,
	ProviderTypeID
)
SELECT DISTINCT
	@PracticeID
	,''
	,first_name
	,middle_initial
	,last_name
	,''
	,[address]
	,address_2
	,city
	,LEFT(state, 2)
	,'USA'
	,LEFT(REPLACE(zipcode, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(fax, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(mobile_number, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,LEFT(title, 8)
	,ID -- Our ID we add during upload
	,@VendorImportID
	,1
	,npi_number
	,1
FROM dbo.[_import_4_1_Referringproviders]
WHERE last_name <> ''

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
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	EmploymentStatus ,
	MedicalRecordNumber,
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
	,last_name
	,first_name
	,middle_initial
	,''
	,address_1
	,address_2
	,city_
	,LEFT(state, 2)
	,'USA'
	,LEFT(REPLACE(zip, '-', ''), 9)
	,gender
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(home_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(dob) WHEN 1 THEN dob ELSE NULL END 
	,LEFT(REPLACE([ss#], '-', ''), 9)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'U'
	,[pat_id_#] -- MedicalRecordNumber
	,ID -- VendorID (Our ID)
	,@VendorImportID
	,1
	,1
	,0
	,1
FROM dbo.[_import_4_1_Patientdemos]

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Case - All records
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
	,impCase.ID
	,@VendorImportID
FROM 
	dbo.[_import_4_1_Patientdemos] impCase
INNER JOIN dbo.Patient realP ON 
	realP.VendorImportID = @VendorImportID AND
	impCase.ID = realP.VendorID
WHERE
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
	HolderGender
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,primary_ins_id
	,primary_ins_grp
	,CASE 
		WHEN policyholder_1st_name <> first_name OR policyholder_last_name <> last_name THEN 'O'
		ELSE 'S'
	END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,ID -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE WHEN policyholder_1st_name <> first_name OR policyholder_last_name <> last_name THEN policyholder_1st_name ELSE NULL END
	,CASE WHEN policyholder_1st_name <> first_name OR policyholder_last_name <> last_name THEN policy_holder__middlie_initial ELSE NULL END
	,CASE WHEN policyholder_1st_name <> first_name OR policyholder_last_name <> last_name THEN policyholder_last_name ELSE NULL END
	,CASE WHEN policyholder_1st_name <> first_name OR policyholder_last_name <> last_name THEN CASE ISDATE(policy_holder_dob) WHEN 1 THEN policy_holder_dob ELSE NULL END ELSE NULL END
	,CASE WHEN policyholder_1st_name <> first_name OR policyholder_last_name <> last_name THEN policy_holder_sex ELSE NULL END
FROM dbo.[_import_4_1_Patientdemos] impPC
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorImportID = @VendorImportID AND 
	impPC.ID = pc.VendorID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.primary_insurance = icp.PlanName AND impPC.prim_ins_address = icp.AddressLine1
WHERE
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID AND
	impPC.primary_insurance <> ''

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
	HolderGender
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,2
	,sec_ins_id
	,sec_ins_grp
	,CASE 
		WHEN policyholder_1st_name <> first_name AND policyholder_last_name <> last_name THEN 'O'
		ELSE 'S'
	END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,ID -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE WHEN policyholder_1st_name <> first_name AND policyholder_last_name <> last_name THEN policyholder_1st_name ELSE NULL END
	,CASE WHEN policyholder_1st_name <> first_name AND policyholder_last_name <> last_name THEN policy_holder__middlie_initial ELSE NULL END
	,CASE WHEN policyholder_1st_name <> first_name AND policyholder_last_name <> last_name THEN policyholder_last_name ELSE NULL END
	,CASE WHEN policyholder_1st_name <> first_name AND policyholder_last_name <> last_name THEN CASE ISDATE(policy_holder_dob) WHEN 1 THEN policy_holder_dob ELSE NULL END ELSE NULL END
	,CASE WHEN policyholder_1st_name <> first_name AND policyholder_last_name <> last_name THEN policy_holder_sex ELSE NULL END
FROM dbo.[_import_4_1_Patientdemos] impPC
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorImportID = @VendorImportID AND 
	impPC.ID = pc.VendorID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.sec_ins_name = icp.PlanName AND impPC.sec_ins_address = icp.AddressLine1
WHERE
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID AND
	impPC.sec_ins_name <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT TRAN