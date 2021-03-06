USE superbill_10587_dev
--USE superbill_10587_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @VendorName VARCHAR(100)
DECLARE @ImportNote VARCHAR(100)

-- This script eill have to be run for each practice (4,6,15,9,19,11,10,14,12,7,5,1,13,8,16,18,20,2,3,17)
SET @PracticeID = ??
SET @VendorName = 'Podiatry Billing Services'
SET @ImportNote = 'Initial import for customer 10587. FBID: 4733.'

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
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
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
	Phone,
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
	policy_group_name
	,address_1
	,address_2
	,city
	,[state]
	,'USA'
	,LEFT(REPLACE(plan_zip + zip4, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(fax, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,PracticeID
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
FROM dbo.[_importInsuranceCompany]
WHERE
	PracticeID = @PracticeID AND
	policy_group_name <> ''

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
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	CreatedPracticeID,
	Fax,
	VendorID,
	VendorImportID,
	InsuranceCompanyID
)
SELECT DISTINCT
	impIns.policy_group_name
	,impIns.address_1
	,impIns.address_2
	,impIns.city
	,impIns.state
	,'USA'
	,LEFT(REPLACE(impIns.plan_zip + impIns.zip4, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,GETDATE()
	,0
	,GETDATE()
	,0
	,PracticeID
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.fax, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,0
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_importInsuranceCompany] impIns
INNER JOIN dbo.InsuranceCompany ic ON 
	ic.VendorImportID = @VendorImportID AND
	impIns.PracticeID = ic.CreatedPracticeID AND
	impIns.policy_group_name = ic.InsuranceCompanyName AND
	impIns.address_1 = ic.AddressLine1 AND
	impIns.address_2 = ic.AddressLine2 AND
	impIns.city = ic.City AND
	impIns.state = ic.State AND
	LEFT(REPLACE(impIns.plan_zip + impIns.zip4, '-',''), 9) = ic.ZipCode AND
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10) = ic.Phone AND
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impIns.fax, '-', ''), '(', ''), ')', ''), ' ', ''), 10) = ic.Fax
WHERE
	impIns.PracticeID = @PracticeID AND
	impIns.policy_group_name <> ''
		
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
	Notes,
	ActiveDoctor,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Degree,
	VendorID,
	VendorImportID,
	FaxNumber,
	[External],
	NPI,
	ProviderTypeID
)
SELECT
	PracticeID
	,''
	,[First Name]
	,Middle
	,[Last Name]
	,''
	,[Address 1]
	,[Address 2]
	,City
	,State
	,'USA'
	,LEFT(REPLACE([Zip Code] + [Zip 4], '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(Phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,[ID #]
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,Degree
	,[ID]
	,@VendorImportID
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(Fax, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,1
	,LEFT(NPI, 10)
	,1
FROM dbo.[_importReferringDoctor]
WHERE PracticeID = @PracticeID

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Patient
PRINT ''
PRINT 'Inserting records into Patient ...'
INSERT INTO dbo.Patient (
	PracticeID ,
	ReferringPhysicianID,
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
	PrimaryCarePhysicianID,
	VendorID ,
	VendorImportID ,
	CollectionCategoryID ,
	Active ,
	SendEmailCorrespondence ,
	PhonecallRemindersEnabled
	)
SELECT 
	@PracticeID
	,referring.DoctorID
	,''
	,impP.[last_name]
	,impP.[first_name]
	,impP.[middle_name]
	,''
	,impP.address1
	,impP.address2
	,impP.[city]
	,impP.[state]
	,'USA'
	,LEFT(REPLACE(impP.zip + impP.zip4, '-', ''), 9)
	,CASE impP.gender 
		WHEN '' THEN 'U' 
		ELSE impP.gender 
	END
	,CASE impP.marital_status 
		WHEN '' THEN 'U' 
		WHEN 'X' THEN 'U'
		ELSE impP.marital_status
	END
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.home_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.business_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.dob) WHEN 1 THEN impP.dob ELSE NULL END 
	,REPLACE(impP.ssn, '-', '')
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'U'
	,impP.chart_no
	,provider.DoctorID
	,impP.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,1
	,1
	,1
	,1
FROM dbo.[_importPatient] impP
LEFT OUTER JOIN 
(
	SELECT DISTINCT DoctorID, FirstName, LastName, NPI FROM dbo.Doctor WHERE PracticeID = @PracticeID AND [External] = 0
) provider ON 
	impP.provider_first_name = provider.FirstName AND
	impP.provider_last_name = provider.LastName AND
	impP.provider_npi = provider.NPI
LEFT OUTER JOIN 
(
	SELECT DISTINCT DoctorID, CAST(Notes AS VARCHAR) AS 'Notes' FROM dbo.Doctor WHERE PracticeID = @PracticeID AND [External] = 1
) referring ON
	impP.referring_id = referring.Notes
WHERE impP.PracticeID = @PracticeID

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
	,impP.chart_no
	,impP.[ID]
	,@VendorImportID
FROM 
	dbo.[_importPatient] impP
INNER JOIN dbo.Patient realP ON 
	impP.ID = realP.VendorID AND 
	realP.VendorImportID = @VendorImportID AND
	impP.PracticeID = realP.PracticeID
WHERE
	impP.PracticeID = @PracticeID AND
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
	,impP.[primary_plan_policy]
	,impP.[primary_plan_group]
	,CASE ISDATE(impP.[primary_effective_date_from]) WHEN 1 THEN impP.[primary_effective_date_from] ELSE NULL END
	,CASE ISDATE(impP.[primary_effective_date_to]) WHEN 1 THEN impP.[primary_effective_date_to] ELSE NULL END
	,CASE impP.[primary_relation]
		WHEN 'SELF' THEN 'S' 
		WHEN 'CHILD' THEN 'C'
		WHEN 'SPOUSE' THEN 'U'
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impP.[primary_co_pay_amount]
	,impP.PracticeID
	,impP.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE impP.[primary_relation] WHEN 'SELF' THEN NULL ELSE insured.FirstName END
	,CASE impP.[primary_relation] WHEN 'SELF' THEN NULL ELSE insured.MiddleName END
	,CASE impP.[primary_relation] WHEN 'SELF' THEN NULL ELSE insured.LastName END
	,CASE impP.[primary_relation] WHEN 'SELF' THEN NULL ELSE insured.DOB END
	,CASE impP.[primary_relation] WHEN 'SELF' THEN NULL ELSE insured.SSN END
	,CASE impP.[primary_relation] WHEN 'SELF' THEN NULL ELSE insured.Gender END
	,CASE impP.[primary_relation] WHEN 'SELF' THEN NULL ELSE insured.AddressLine1 END
	,CASE impP.[primary_relation] WHEN 'SELF' THEN NULL ELSE insured.AddressLine2 END
	,CASE impP.[primary_relation] WHEN 'SELF' THEN NULL ELSE insured.City END
	,CASE impP.[primary_relation] WHEN 'SELF' THEN NULL ELSE insured.State END
	,CASE impP.[primary_relation] WHEN 'SELF' THEN NULL ELSE insured.Country END
	,CASE impP.[primary_relation] WHEN 'SELF' THEN NULL ELSE insured.ZipCode END
	,CASE impP.[primary_relation] WHEN 'SELF' THEN NULL ELSE insured.HomePhone END
FROM dbo.[_importPatient] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.[ID] = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID AND
	impP.PracticeID = pc.PracticeID
LEFT OUTER JOIN dbo.Patient insured ON
	insured.VendorImportID = @VendorImportID AND
	impP.PracticeID = insured.PracticeID AND
	impP.primary_insured_first_name = insured.FirstName AND
	impP.primary_insured_last_name = insured.LastName AND
	impP.primary_insured_address1 = insured.AddressLine1 AND
	impP.primary_insured_city = insured.City AND
	impP.primary_insured_state = insured.State
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impP.PracticeID = icp.CreatedPracticeID AND
	impP.primary_plan_policy_name = icp.PlanName AND
	impP.primary_plan_address1 = icp.AddressLine1 AND
	impP.primary_plan_address2 = icp.AddressLine2 AND
	impP.primary_plan_city = icp.City AND
	impP.primary_plan_state = icp.State AND
	LEFT(REPLACE(impP.primary_plan_zip + impP.primary_plan_zip4, '-',''), 9) = icp.ZipCode AND
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.primary_plan_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10) = icp.Phone AND
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.primary_plan_fax, '-', ''), '(', ''), ')', ''), ' ', ''), 10) = icp.Fax
WHERE
	impP.PracticeID = @PracticeID AND
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
	,impP.[secondary_plan_policy]
	,impP.[secondary_plan_group]
	,CASE ISDATE(impP.[secondary_effective_date_from]) WHEN 1 THEN impP.[secondary_effective_date_from] ELSE NULL END
	,CASE ISDATE(impP.[secondary_effective_date_to]) WHEN 1 THEN impP.[secondary_effective_date_to] ELSE NULL END
	,CASE impP.[secondary_relation]
		WHEN 'SELF' THEN 'S' 
		WHEN 'CHILD' THEN 'C'
		WHEN 'SPOUSE' THEN 'U'
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impP.[secondary_co_pay_amount]
	,impP.PracticeID
	,impP.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE impP.[secondary_relation] WHEN 'SELF' THEN NULL ELSE insured.FirstName END
	,CASE impP.[secondary_relation] WHEN 'SELF' THEN NULL ELSE insured.MiddleName END
	,CASE impP.[secondary_relation] WHEN 'SELF' THEN NULL ELSE insured.LastName END
	,CASE impP.[secondary_relation] WHEN 'SELF' THEN NULL ELSE insured.DOB END
	,CASE impP.[secondary_relation] WHEN 'SELF' THEN NULL ELSE insured.SSN END
	,CASE impP.[secondary_relation] WHEN 'SELF' THEN NULL ELSE insured.Gender END
	,CASE impP.[secondary_relation] WHEN 'SELF' THEN NULL ELSE insured.AddressLine1 END
	,CASE impP.[secondary_relation] WHEN 'SELF' THEN NULL ELSE insured.AddressLine2 END
	,CASE impP.[secondary_relation] WHEN 'SELF' THEN NULL ELSE insured.City END
	,CASE impP.[secondary_relation] WHEN 'SELF' THEN NULL ELSE insured.State END
	,CASE impP.[secondary_relation] WHEN 'SELF' THEN NULL ELSE insured.Country END
	,CASE impP.[secondary_relation] WHEN 'SELF' THEN NULL ELSE insured.ZipCode END
	,CASE impP.[secondary_relation] WHEN 'SELF' THEN NULL ELSE insured.HomePhone END
FROM dbo.[_importPatient] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.[ID] = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID AND
	impP.PracticeID = pc.PracticeID
LEFT OUTER JOIN dbo.Patient insured ON
	insured.VendorImportID = @VendorImportID AND
	impP.PracticeID = insured.PracticeID AND
	impP.secondary_insured_first_name = insured.FirstName AND
	impP.secondary_insured_last_name = insured.LastName AND
	impP.secondary_insured_address1 = insured.AddressLine1 AND
	impP.secondary_insured_city = insured.City AND
	impP.secondary_insured_state = insured.State
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impP.PracticeID = icp.CreatedPracticeID AND
	impP.secondary_plan_policy_name = icp.PlanName AND
	impP.secondary_plan_address1 = icp.AddressLine1 AND
	impP.secondary_plan_address2 = icp.AddressLine2 AND
	impP.secondary_plan_city = icp.City AND
	impP.secondary_plan_state = icp.State AND
	LEFT(REPLACE(impP.secondary_plan_zip + impP.secondary_plan_zip4, '-',''), 9) = icp.ZipCode AND
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.secondary_plan_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10) = icp.Phone AND
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.secondary_plan_fax, '-', ''), '(', ''), ')', ''), ' ', ''), 10) = icp.Fax
WHERE
	impP.PracticeID = @PracticeID AND
	pc.VendorImportID = @VendorImportID 

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
	,impP.[tertiary_plan_policy]
	,impP.[tertiary_plan_group]
	,CASE ISDATE(impP.[tertiary_effective_date_from]) WHEN 1 THEN impP.[tertiary_effective_date_from] ELSE NULL END
	,CASE ISDATE(impP.[tertiary_effective_date_to]) WHEN 1 THEN impP.[tertiary_effective_date_to] ELSE NULL END
	,CASE impP.[tertiary_relation]
		WHEN 'SELF' THEN 'S' 
		WHEN 'CHILD' THEN 'C'
		WHEN 'SPOUSE' THEN 'U'
		ELSE 'O' END
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,impP.[tertiary_co_pay_amount]
	,impP.PracticeID
	,impP.[ID] -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
	,''
	,''
	,CASE impP.[tertiary_relation] WHEN 'SELF' THEN NULL ELSE insured.FirstName END
	,CASE impP.[tertiary_relation] WHEN 'SELF' THEN NULL ELSE insured.MiddleName END
	,CASE impP.[tertiary_relation] WHEN 'SELF' THEN NULL ELSE insured.LastName END
	,CASE impP.[tertiary_relation] WHEN 'SELF' THEN NULL ELSE insured.DOB END
	,CASE impP.[tertiary_relation] WHEN 'SELF' THEN NULL ELSE insured.SSN END
	,CASE impP.[tertiary_relation] WHEN 'SELF' THEN NULL ELSE insured.Gender END
	,CASE impP.[tertiary_relation] WHEN 'SELF' THEN NULL ELSE insured.AddressLine1 END
	,CASE impP.[tertiary_relation] WHEN 'SELF' THEN NULL ELSE insured.AddressLine2 END
	,CASE impP.[tertiary_relation] WHEN 'SELF' THEN NULL ELSE insured.City END
	,CASE impP.[tertiary_relation] WHEN 'SELF' THEN NULL ELSE insured.State END
	,CASE impP.[tertiary_relation] WHEN 'SELF' THEN NULL ELSE insured.Country END
	,CASE impP.[tertiary_relation] WHEN 'SELF' THEN NULL ELSE insured.ZipCode END
	,CASE impP.[tertiary_relation] WHEN 'SELF' THEN NULL ELSE insured.HomePhone END
FROM dbo.[_importPatient] impP
INNER JOIN dbo.PatientCase pc ON 
	impP.[ID] = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID AND
	impP.PracticeID = pc.PracticeID
LEFT OUTER JOIN dbo.Patient insured ON
	insured.VendorImportID = @VendorImportID AND
	impP.PracticeID = insured.PracticeID AND
	impP.tertiary_insured_first_name = insured.FirstName AND
	impP.tertiary_insured_last_name = insured.LastName AND
	impP.tertiary_insured_address1 = insured.AddressLine1 AND
	impP.tertiary_insured_city = insured.City AND
	impP.tertiary_insured_state = insured.State
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	impP.PracticeID = icp.CreatedPracticeID AND
	impP.tertiary_plan_policy_name = icp.PlanName AND
	impP.tertiary_plan_address1 = icp.AddressLine1 AND
	impP.tertiary_plan_address2 = icp.AddressLine2 AND
	impP.tertiary_plan_city = icp.City AND
	impP.tertiary_plan_state = icp.State AND
	LEFT(REPLACE(impP.tertiary_plan_zip + impP.tertiary_plan_zip4, '-',''), 9) = icp.ZipCode AND
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.tertiary_plan_phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10) = icp.Phone AND
	LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.tertiary_plan_fax, '-', ''), '(', ''), ')', ''), ' ', ''), 10) = icp.Fax
WHERE
	impP.PracticeID = @PracticeID AND
	pc.VendorImportID = @VendorImportID 

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT TRAN