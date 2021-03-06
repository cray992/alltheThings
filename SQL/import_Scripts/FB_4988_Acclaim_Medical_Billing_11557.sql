USE superbill_11557_dev 
--USE superbill_11557_prod
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


-- Table var for insurance info
DECLARE @InsuranceCompany TABLE (
	InsCode VARCHAR(100),
	InsName VARCHAR(100),
	InsAddr1 VARCHAR(100),
	InsAddr2 VARCHAR(100),
	InsCity VARCHAR(100),
	InsState VARCHAR(100),
	InsZip VARCHAR(100),
	InsPhone VARCHAR(100)
)

INSERT INTO @InsuranceCompany
	( 
	InsCode,
	InsName ,
	InsAddr1 ,
	InsAddr2 ,
	InsCity ,
	InsState ,
	InsZip,
	InsPhone
	)
SELECT DISTINCT [pri_ins_co_cd], [pri_ins_co_nm], [pri_ins_address_1], [pri_ins_address_2], [pri_ins_city], [pri_ins_state], [pri_ins_zip], [pri_ins_phone] FROM dbo.[_import_1_1_DataImportfor#11557] WHERE [pri_ins_co_cd] <> ''
UNION All
SELECT DISTINCT [sec_ins_co_cd], [sec_ins_co_nm], [sec_ins_address_1], [sec_ins_address_2], [sec_ins_city], [sec_ins_state], [sec_ins_zip], [sec_ins_phone] FROM dbo.[_import_1_1_DataImportfor#11557] WHERE [sec_ins_co_cd] <> ''
UNION All
SELECT DISTINCT [add_ins_co_cd], [add_ins_co_nm], [add_ins_address_1], [add_ins_address_2], [add_ins_city], [add_ins_state], [add_ins_zip], [add_ins_phone] FROM dbo.[_import_1_1_DataImportfor#11557] WHERE [add_ins_co_cd] <> ''



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
	InsName
	,InsAddr1
	,InsAddr2
	,InsCity
	,InsState
	,'USA'
	,LEFT(REPLACE(InsZip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(InsPhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,InsCode -- Hope it's unique!
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
FROM @InsuranceCompany

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
	impIns.InsName
	,impIns.InsAddr1
	,impIns.InsAddr2
	,impIns.InsCity
	,impIns.InsState
	,'USA'
	,LEFT(REPLACE(impIns.InsZip, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.InsPhone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,impIns.InsCode
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM @InsuranceCompany impIns
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorImportID = @VendorImportID AND
	impIns.InsCode = ic.VendorID
		
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
	DOB ,
	SSN ,
	EmailAddress,
	ResponsibleDifferentThanPatient,
	ResponsiblePrefix,
	ResponsibleFirstName,
	ResponsibleMiddleName,
	ResponsibleLastName,
	ResponsibleSuffix,
	ResponsibleRelationshipToPatient,
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
	MedicalRecordNumber,
	PrimaryCarePhysicianID,
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
	,last_nm
	,first_nm
	,mid_nm
	,''
	,addr1
	,addr2
	,city
	,LEFT(state, 2)
	,'USA'
	,LEFT(REPLACE(zip, '-', ''), 9)
	,sex
	,CASE marital
		WHEN 'D' THEN 'D'
		WHEN 'M' THEN 'M'
		WHEN 'S' THEN 'S'
		WHEN 'W' THEN 'W'
		ELSE 'U'
	END
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(hm_phn, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(wk_phn, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(cell_phn, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(dob) WHEN 1 THEN dob ELSE NULL END 
	,LEFT(REPLACE(ssn, '-', ''), 9)
	,email
	,CASE
		WHEN last_nm <> [resp_party_last_nm] AND first_nm <> [resp_party_first_nm] THEN 1
		ELSE 0
	END -- ResponsibleDifferentThanPatient
	,CASE
		WHEN last_nm <> [resp_party_last_nm] AND first_nm <> [resp_party_first_nm] THEN ''
		ELSE NULL
	END -- ResponsiblePrefix
	,CASE
		WHEN last_nm <> [resp_party_last_nm] AND first_nm <> [resp_party_first_nm] THEN resp_party_first_nm
		ELSE NULL
	END -- ResponsibleFirstName
	,CASE
		WHEN last_nm <> [resp_party_last_nm] AND first_nm <> [resp_party_first_nm] THEN resp_party_mid_nm
		ELSE NULL
	END -- ResponsibleMiddleName
	,CASE
		WHEN last_nm <> [resp_party_last_nm] AND first_nm <> [resp_party_first_nm] THEN resp_party_last_nm
		ELSE NULL
	END -- ResponsibleLastName
	,CASE
		WHEN last_nm <> [resp_party_last_nm] AND first_nm <> [resp_party_first_nm] THEN ''
		ELSE NULL
	END -- ResponsibleSuffix
	,CASE
		WHEN last_nm <> [resp_party_last_nm] AND first_nm <> [resp_party_first_nm] THEN 'O'
		ELSE NULL
	END -- ResponsibleRelationshipToPatient
	,CASE
		WHEN last_nm <> [resp_party_last_nm] AND first_nm <> [resp_party_first_nm] THEN resp_party_addr1
		ELSE NULL
	END -- ResponsibleAddressLine1
	,CASE
		WHEN last_nm <> [resp_party_last_nm] AND first_nm <> [resp_party_first_nm] THEN resp_party_addr2
		ELSE NULL
	END -- ResponsibleAddressLine2
	,CASE
		WHEN last_nm <> [resp_party_last_nm] AND first_nm <> [resp_party_first_nm] THEN resp_party_city
		ELSE NULL
	END -- ResponsibleCity
	,CASE
		WHEN last_nm <> [resp_party_last_nm] AND first_nm <> [resp_party_first_nm] THEN resp_party_state
		ELSE NULL
	END -- ResponsibleState
	,CASE
		WHEN last_nm <> [resp_party_last_nm] AND first_nm <> [resp_party_first_nm] THEN 'USA'
		ELSE NULL
	END -- ResponsibleCountry
	,CASE
		WHEN last_nm <> [resp_party_last_nm] AND first_nm <> [resp_party_first_nm] THEN LEFT(REPLACE(resp_party_zip, '-', ''), 9)
		ELSE NULL
	END -- ResponsibleZipCode
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'U' -- Employment Status
	,acct -- MedicalRecordNumber
	,1 -- PrimaryCarePhysicianID
	,ID -- VendorID (Our ID)
	,@VendorImportID
	,1
	,1
	,CASE WHEN email <> '' THEN 1 ELSE 0 END
	,1
FROM dbo.[_import_1_1_DataImportfor#11557]

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
	,impCase.acct
	,impCase.ID
	,@VendorImportID
FROM 
	dbo.[_import_1_1_DataImportfor#11557] impCase
INNER JOIN dbo.Patient realP ON 
	realP.VendorImportID = @VendorImportID AND
	impCase.ID = realP.VendorID
WHERE
	realP.VendorImportID = @VendorImportID -- This is very important as previous vendor imports can potentially contain VendorIDs that collide with this import. 
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient Case - Additional Insurance case
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
	,'Additional Insurance'
	,5 -- 'Commercial' (I was told this is a good default)
	,'Created via data import'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,impCase.acct
	,impCase.ID
	,@VendorImportID
FROM 
	dbo.[_import_1_1_DataImportfor#11557] impCase
INNER JOIN dbo.Patient realP ON 
	realP.VendorImportID = @VendorImportID AND
	impCase.ID = realP.VendorID
WHERE
	realP.VendorImportID = @VendorImportID AND -- This is very important as previous vendor imports can potentially contain VendorIDs that collide with this import. 
	impCase.add_ins_co_cd <> ''
	
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
	HolderMiddleName,
	HolderLastName,
	HolderDOB,
	HolderGender
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,pri_ins_policy
	,pri_ins_group
	,CASE ISDATE(pri_ins_eff_from_date) WHEN 1 THEN pri_ins_eff_from_date ELSE NULL END
	,CASE ISDATE(pri_ins_eff_to_date) WHEN 1 THEN pri_ins_eff_to_date ELSE NULL END
	,CASE pri_ins_relation
		WHEN '1' THEN 'S' 
		WHEN '3' THEN 'C'
		WHEN '2' THEN 'U'
		ELSE 'O' END
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
	,CASE WHEN pri_ins_relation <> '1' THEN pri_ins_first_nm ELSE NULL END
	,CASE WHEN pri_ins_relation <> '1' THEN pri_ins_mid_nm ELSE NULL END
	,CASE WHEN pri_ins_relation <> '1' THEN pri_ins_last_nm ELSE NULL END
	,CASE WHEN pri_ins_relation <> '1' THEN CASE ISDATE(pri_ins_dob) WHEN 1 THEN pri_ins_dob ELSE NULL END ELSE NULL END
	,CASE WHEN pri_ins_relation <> '1' THEN pri_ins_sex ELSE NULL END
FROM dbo.[_import_1_1_DataImportfor#11557] impPC
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorImportID = @VendorImportID AND 
	impPC.ID = pc.VendorID AND 
	pc.Name = 'Default Case' -- Default case
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.pri_ins_co_cd = icp.VendorID
WHERE
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID AND
	impPC.pri_ins_co_cd <> ''

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
	HolderMiddleName,
	HolderLastName,
	HolderDOB,
	HolderGender
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,2
	,sec_ins_policy
	,sec_ins_group
	,CASE ISDATE(sec_ins_eff_from_date) WHEN 1 THEN sec_ins_eff_from_date ELSE NULL END
	,CASE ISDATE(sec_ins_eff_to_date) WHEN 1 THEN sec_ins_eff_to_date ELSE NULL END
	,CASE sec_ins_relation
		WHEN '1' THEN 'S' 
		WHEN '3' THEN 'C'
		WHEN '2' THEN 'U'
		ELSE 'O' END
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
	,CASE WHEN sec_ins_relation <> '1' THEN sec_ins_first_nm ELSE NULL END
	,CASE WHEN sec_ins_relation <> '1' THEN sec_ins_mid_nm ELSE NULL END
	,CASE WHEN sec_ins_relation <> '1' THEN sec_ins_last_nm ELSE NULL END
	,CASE WHEN sec_ins_relation <> '1' THEN CASE ISDATE(sec_ins_dob) WHEN 1 THEN sec_ins_dob ELSE NULL END ELSE NULL END
	,CASE WHEN sec_ins_relation <> '1' THEN sec_ins_sex ELSE NULL END
FROM dbo.[_import_1_1_DataImportfor#11557] impPC
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorImportID = @VendorImportID AND 
	impPC.ID = pc.VendorID AND 
	pc.Name = 'Default Case' -- Default case
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.sec_ins_co_cd = icp.VendorID
WHERE
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID AND
	impPC.sec_ins_co_cd <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy - ADDitional Insurance
PRINT ''
PRINT 'Inserting records into InsurancePolicy Additional...'
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
	HolderMiddleName,
	HolderLastName,
	HolderDOB,
	HolderGender
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,add_ins_policy
	,add_ins_group
	,CASE ISDATE(add_ins_eff_from_date) WHEN 1 THEN add_ins_eff_from_date ELSE NULL END
	,CASE ISDATE(add_ins_eff_to_date) WHEN 1 THEN add_ins_eff_to_date ELSE NULL END
	,CASE add_ins_relation
		WHEN '1' THEN 'S' 
		WHEN '3' THEN 'C'
		WHEN '2' THEN 'U'
		ELSE 'O' END
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
	,CASE WHEN add_ins_relation <> '1' THEN add_ins_first_nm ELSE NULL END
	,CASE WHEN add_ins_relation <> '1' THEN add_ins_mid_nm ELSE NULL END
	,CASE WHEN add_ins_relation <> '1' THEN add_ins_last_nm ELSE NULL END
	,CASE WHEN add_ins_relation <> '1' THEN CASE ISDATE(add_ins_dob) WHEN 1 THEN add_ins_dob ELSE NULL END ELSE NULL END
	,CASE WHEN add_ins_relation <> '1' THEN add_ins_sex ELSE NULL END
FROM dbo.[_import_1_1_DataImportfor#11557] impPC
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorImportID = @VendorImportID AND 
	impPC.ID = pc.VendorID AND 
	pc.Name = 'Additional Insurance' -- Additional Insurance
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impPC.add_ins_co_cd = icp.VendorID
WHERE
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID AND
	impPC.add_ins_co_cd <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Set cases without policies to self-pay (11)
PRINT ''
PRINT 'Setting cases without policies to Self-Pay'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11 
WHERE 
	@VendorImportID = VendorImportID AND 
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy) AND
	PayerScenarioID <> 11
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records updated'



COMMIT TRAN