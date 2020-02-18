USE superbill_9767_dev 
--USE superbill_9767_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @VendorName VARCHAR(100)
DECLARE @ImportNote VARCHAR(100)

SET @PracticeID = 1
SET @VendorName = 'Castle Dermatology Institute'
SET @ImportNote = 'Initial import for customer 9767. FBID: 4968'

-- If the VendorImport record doesn't exist create it
IF NOT EXISTS (SELECT * FROM dbo.VendorImport WHERE VendorName = @VendorName AND Notes = @ImportNote)
BEGIN
	INSERT INTO dbo.VendorImport (VendorName, VendorFormat, DateCreated, Notes) 
	VALUES (@VendorName, 'XLSX', GETDATE(), @ImportNote)
END

SET @VendorImportID = (SELECT VendorImportID FROM dbo.VendorImport WHERE VendorName = @VendorName AND Notes = @ImportNote)

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


-- Clear out any existing records for this import, (makes the script safe to run multiple times)
-- Since customer is requesting a full wipe of their practice we're ommiting the vendorimportid qualifer in these delete statements, (scary)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

-- And also, here are some other tables i had to purge to enable the deletes below to work

/*
UPDATE Practice SET
	EOSchedulingProviderID = NULL,
	EORenderingProviderID = NULL,
	EligibilityDefaultProviderID = NULL
WHERE PracticeID = @PracticeID

DELETE FROM dbo.ContractToDoctor WHERE ContractID IN(SELECT ContractID FROM Contract WHERE PracticeID = @PracticeID)
DELETE FROM dbo.ContractToServiceLocation WHERE ContractID IN(SELECT ContractID FROM Contract WHERE PracticeID = @PracticeID)
DELETE FROM dbo.EligibilityHistory WHERE InsurancePolicyID IN(SELECT InsurancePolicyID FROM InsurancePolicy WHERE PracticeID = @PracticeID)
DELETE FROM dbo.PracticeToInsuranceCompany WHERE PracticeID = @PracticeID
DELETE FROM dbo.ClaimSettings WHERE InsuranceCompanyID IN(SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID)
DELETE FROM dbo.ClaimSettings WHERE DoctorID IN(SELECT DoctorID FROM dbo.Doctor WHERE PracticeID = @PracticeID)
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN(SELECT AppointmentID FROM dbo.Appointment WHERE PracticeID = @PracticeID)
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN(SELECT AppointmentID FROM dbo.Appointment WHERE PracticeID = @PracticeID)
DELETE FROM dbo.AppointmentReason WHERE PracticeID = @PracticeID
DELETE FROM Payment WHERE PracticeID = @PracticeID
DELETE FROM dbo.Appointment WHERE PracticeID = @PracticeID
DELETE FROM dbo.EncounterProcedure WHERE PracticeID = @PracticeID
DELETE FROM dbo.EncounterDiagnosis WHERE PracticeID = @PracticeID
DELETE FROM dbo.Encounter WHERE PracticeID = @PracticeID
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM Patient WHERE PracticeID = @PracticeID)
*/

DELETE FROM dbo.ContractToInsurancePlan WHERE ContractID IN (SELECT ContractID FROM dbo.[Contract] WHERE PracticeID = @PracticeID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractToInsurancePlan records deleted'
DELETE FROM dbo.ContractFeeSchedule WHERE ContractID IN (SELECT ContractID FROM dbo.[Contract] WHERE PracticeID = @PracticeID)
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' ContractFeeSchedule records deleted'
DELETE FROM dbo.[Contract] WHERE PracticeID = @PracticeID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Contract records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID
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
	,code -- Hope it's unique!
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
FROM dbo.[_import_20120702_Insurance_1]
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
	,impIns.code
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM dbo.[_import_20120702_Insurance_1] impIns
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorImportID = @VendorImportID AND
	ic.CreatedPracticeID = @PracticeID AND
	impIns.Code = ic.VendorID
WHERE
	NOT([Name] IS NULL) AND RTRIM(LTRIM([Name])) <> ''
		
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Doctor
PRINT ''
PRINT 'Inserting records into Doctor ...'
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
	ProviderTypeID
)
SELECT DISTINCT
	@PracticeID
	,''
	,first_name
	,middle_initial
	,last_name
	,''
	,street_1
	,street_2
	,city
	,LEFT(state, 2)
	,'USA'
	,LEFT(REPLACE(zip_code, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(fax, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(cell, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,[credentials]
	,code -- Appears to be unique in source data
	,@VendorImportID
	,0
	,1
FROM dbo.[_import_20120702_Doctor_1]
WHERE last_name <> ''

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
	EmailAddress,
	ActiveDoctor,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Degree,
	VendorID,
	VendorImportID,
	[External],
	ProviderTypeID
)
SELECT DISTINCT
	@PracticeID
	,''
	,first_name
	,middle_initial
	,last_name
	,''
	,street_1
	,street_2
	,city
	,LEFT(state, 2)
	,'USA'
	,LEFT(REPLACE(zip_code, '-',''), 9)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(fax, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(cell, '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,email
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,LEFT([credentials], 8)
	,code -- Appears to be unique in source data
	,@VendorImportID
	,1
	,1
FROM dbo.[_import_20120702_ReferringDoctor_1]
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
	WorkPhone,
	MobilePhone,
	DOB ,
	SSN ,
	EmailAddress,
	ResponsibleRelationshipToPatient,
	CreatedDate ,
	CreatedUserID ,
	ModifiedDate ,
	ModifiedUserID ,
	EmploymentStatus ,
	PrimaryCarePhysicianID,
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
	,impP.[Last_Name]
	,impP.[First_Name]
	,impP.[Middle_Initial]
	,''
	,impP.[Street_1]
	,impP.[Street_2]
	,impP.[City]
	,impP.[State]
	,impP.[Country]
	,LEFT(REPLACE(impP.[Zip_Code], '-', ''), 9)
	,CASE impP.[Sex] WHEN 'Female' THEN 'F' WHEN 'Male' THEN 'M' ELSE 'U' END
	,'U'
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[Phone_1], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[Phone_2], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[Phone_3], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,CASE ISDATE(impP.[Date_Of_Birth]) WHEN 1 THEN impP.[Date_Of_Birth] ELSE NULL END 
	,LEFT(REPLACE(impP.[Social_Security_Number], '-', ''), 9)
	,impP.email
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'U'
	,pcp.DoctorID
	,impP.[Chart_Number] -- Hope it's unique!
	,@VendorImportID
	,1
	,1
	,1
	,1
	,impP.[Contact_Name]
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(impP.[Contact_Phone_1], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
FROM dbo.[_import_20120702_Patient_1] impP
LEFT OUTER JOIN dbo.Doctor pcp ON 
	@VendorImportID = pcp.VendorImportID AND 
	@PracticeID = pcp.PracticeID AND
	impP.assigned_provider = pcp.VendorID AND 
	pcp.[External] = 0

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
	,chart_number
	,ID -- Auto ID added by Kareo process MUST BE UNIQUE PER CASE record, so the chart_number, (patient handle), won't work here. since a patient can have multiple "cases" (aka polciies in kareo world)
	,@VendorImportID
FROM 
	dbo.[_import_20120702_PatientCase_1] impCase
INNER JOIN dbo.Patient realP ON 
	impCase.[Chart_Number] = realP.VendorID AND 
	realP.VendorImportID = @VendorImportID AND
	realP.PracticeID = @PracticeID
	
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
	,CASE impPC.[Insured_Relationship_#1] WHEN 'Self' THEN NULL ELSE LEFT(REPLACE(holder.[Social_Security_Number], '-', ''), 9) END
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
FROM dbo.[_import_20120702_PatientCase_1] impPC
INNER JOIN dbo.PatientCase pc ON impPC.ID = pc.VendorID AND pc.VendorImportID = @VendorImportID AND pc.PracticeID = @PracticeID
INNER JOIN (
	SELECT DISTINCT [Chart_Number], [Last_Name], [First_Name], [Middle_Initial], [Street_1], [Street_2], [City], [State], [Zip_Code], [Phone_1], [Social_Security_Number], [Sex], [Date_of_Birth], [Country] FROM dbo.[_import_20120702_Patient_1]
) holder ON holder.[Chart_Number] = impPC.Guarantor
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	icp.CreatedPracticeID = @PracticeID AND
	impPC.[Insurance_Carrier_#1] = icp.VendorID
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
	,CASE impPC.[Insured_Relationship_#2] WHEN 'Self' THEN NULL ELSE LEFT(REPLACE(holder.[Social_Security_Number], '-', ''), 9) END
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
FROM dbo.[_import_20120702_PatientCase_1] impPC
INNER JOIN dbo.PatientCase pc ON impPC.ID = pc.VendorID AND pc.VendorImportID = @VendorImportID AND pc.PracticeID = @PracticeID
INNER JOIN (
	SELECT DISTINCT [Chart_Number], [Last_Name], [First_Name], [Middle_Initial], [Street_1], [Street_2], [City], [State], [Zip_Code], [Phone_1], [Social_Security_Number], [Sex], [Date_of_Birth], [Country] FROM dbo.[_import_20120702_Patient_1]
) holder ON holder.[Chart_Number] = impPC.Guarantor
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	icp.CreatedPracticeID = @PracticeID AND
	impPC.[Insurance_Carrier_#2] = icp.VendorID
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
	,CASE impPC.[Insured_Relationship_#3] WHEN 'Self' THEN NULL ELSE LEFT(REPLACE(holder.[Social_Security_Number], '-', ''), 9) END
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
FROM dbo.[_import_20120702_PatientCase_1] impPC
INNER JOIN dbo.PatientCase pc ON impPC.ID = pc.VendorID AND pc.VendorImportID = @VendorImportID AND pc.PracticeID = @PracticeID
INNER JOIN (
	SELECT DISTINCT [Chart_Number], [Last_Name], [First_Name], [Middle_Initial], [Street_1], [Street_2], [City], [State], [Zip_Code], [Phone_1], [Social_Security_Number], [Sex], [Date_of_Birth], [Country] FROM dbo.[_import_20120702_Patient_1]
) holder ON holder.[Chart_Number] = impPC.Guarantor
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	icp.VendorImportID = @VendorImportID AND
	icp.CreatedPracticeID = @PracticeID AND
	impPC.[Insurance_Carrier_#3] = icp.VendorID
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
FROM dbo.[_import_20120702_StandardFeeSchedule_1] impFS
INNER JOIN dbo.[Contract] c ON 
	CAST(c.Notes AS VARCHAR) = CAST(@VendorImportID AS VARCHAR) AND
	c.PracticeID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON impFS.[Code_1] = pcd.ProcedureCode
WHERE
	CAST([Amount_A] AS MONEY) > 0
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


-- Clean up notes fields
UPDATE dbo.[Contract] 
SET
	Notes = ''
WHERE
	PracticeID = @PracticeID AND
	LEN(CAST(Notes AS VARCHAR)) < 7


-- Set cases without policies to self-pay (11)
PRINT ''
PRINT 'Setting cases without policies to Self-Pay'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11 
WHERE 
	@VendorImportID = VendorImportID AND 
	@PracticeID = PracticeID AND
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID) AND
	PayerScenarioID <> 11
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records updated'


COMMIT TRAN