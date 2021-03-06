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

-- FULL WIPE BECAUSE CUSTOMER ALREADY STARTED USING DATA OMG HERE WE GO

UPDATE Practice SET EOSchedulingProviderID = NULL WHERE EOSchedulingProviderID IN (SELECT DoctorID FROM dbo.Doctor WHERE VendorImportID = @VendorImportID)

UPDATE Practice SET EORenderingProviderID = NULL WHERE EORenderingProviderID IN (SELECT DoctorID FROM dbo.Doctor WHERE VendorImportID = @VendorImportID)

UPDATE Practice SET EligibilityDefaultProviderID = NULL WHERE EligibilityDefaultProviderID IN (SELECT DoctorID FROM dbo.Doctor WHERE VendorImportID = @VendorImportID)

DELETE FROM dbo.EnrollmentDoctor WHERE DoctorID IN (SELECT DoctorID FROM dbo.Doctor WHERE VendorImportID = @VendorImportID)

DELETE FROM dbo.ContractToDoctor WHERE 
	DoctorID IN (SELECT DoctorID FROM Doctor WHERE VendorImportID = @VendorImportID) OR
	ContractID IN (SELECT ContractID FROM dbo.[Contract] WHERE CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR))
	
DELETE FROM dbo.ContractToServiceLocation WHERE ContractID IN (SELECT ContractID FROM dbo.[Contract] WHERE CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR))

DELETE FROM dbo.EligibilityHistory WHERE InsurancePolicyID IN (SELECT InsurancePolicyID FROM InsurancePolicy WHERE VendorImportID = @VendorImportID)

DELETE FROM dbo.PracticeToInsuranceCompany WHERE InsuranceCompanyID IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID)

DELETE FROM dbo.ClaimSettings WHERE 
	InsuranceCompanyID IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID) OR
	DoctorID IN (SELECT DoctorID FROM dbo.Doctor WHERE VendorImportID = @VendorImportID)

DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM Patient WHERE VendorImportID = @VendorImportID))

DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM Patient WHERE VendorImportID = @VendorImportID))

DELETE FROM dbo.ClaimTransaction WHERE ClaimID IN (SELECT ClaimID FROM dbo.Claim WHERE PatientID IN (SELECT PatientID FROM Patient WHERE VendorImportID = @VendorImportID))

DELETE FROM dbo.PaymentPatient WHERE PaymentID IN
(
	SELECT PaymentID FROM dbo.Payment WHERE 
		AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM Patient WHERE VendorImportID = @VendorImportID))
		OR
		SourceEncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE VendorImportID = @VendorImportID OR	
									PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID) OR
									DoctorID IN (SELECT DoctorID FROM dbo.Doctor WHERE VendorImportID = @VendorImportID))
)

DELETE FROM dbo.PaymentEncounter WHERE PaymentID IN
(
	SELECT PaymentID FROM dbo.Payment WHERE 
		AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM Patient WHERE VendorImportID = @VendorImportID))
		OR
		SourceEncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE VendorImportID = @VendorImportID OR	
									PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID) OR
									DoctorID IN (SELECT DoctorID FROM dbo.Doctor WHERE VendorImportID = @VendorImportID))
)

DELETE FROM dbo.Payment WHERE 
	AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM Patient WHERE VendorImportID = @VendorImportID))
	OR
	SourceEncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE VendorImportID = @VendorImportID OR	
								PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID) OR
								DoctorID IN (SELECT DoctorID FROM dbo.Doctor WHERE VendorImportID = @VendorImportID))

DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM Patient WHERE VendorImportID = @VendorImportID)
														
DELETE FROM dbo.BillClaim WHERE ClaimID IN (SELECT ClaimID FROM dbo.Claim WHERE PatientID IN (SELECT PatientID FROM Patient WHERE VendorImportID = @VendorImportID))

DELETE FROM dbo.Claim WHERE PatientID IN (SELECT PatientID FROM Patient WHERE VendorImportID = @VendorImportID)

DELETE FROM dbo.EncounterProcedure WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE
														VendorImportID = @VendorImportID OR	
														PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID) OR
														DoctorID IN (SELECT DoctorID FROM dbo.Doctor WHERE VendorImportID = @VendorImportID))

DELETE FROM dbo.EncounterDiagnosis WHERE EncounterID IN (SELECT EncounterID FROM dbo.Encounter WHERE
														VendorImportID = @VendorImportID OR	
														PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID) OR
														DoctorID IN (SELECT DoctorID FROM dbo.Doctor WHERE VendorImportID = @VendorImportID))
														
DELETE FROM dbo.Encounter WHERE VendorImportID = @VendorImportID OR	
								PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID) OR
								DoctorID IN (SELECT DoctorID FROM dbo.Doctor WHERE VendorImportID = @VendorImportID)

DELETE FROM dbo.ContractToInsurancePlan WHERE ContractID IN (SELECT ContractID FROM dbo.[Contract] WHERE CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR))

DELETE FROM dbo.ContractFeeSchedule WHERE ContractID IN (SELECT ContractID FROM dbo.[Contract] WHERE CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR))

DELETE FROM dbo.[Contract] WHERE CAST([Description] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)

DELETE FROM dbo.Bill_EDI WHERE PayerInsurancePolicyID IN (SELECT InsurancePolicyID FROM dbo.InsurancePolicy WHERE VendorImportID = @VendorImportID OR
															PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID)))

DELETE FROM dbo.InsurancePolicyAuthorization WHERE InsurancePolicyID IN
(
	SELECT InsurancePolicyID FROM dbo.InsurancePolicy WHERE VendorImportID = @VendorImportID OR
									PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID))
)


DELETE FROM dbo.InsurancePolicy WHERE VendorImportID = @VendorImportID OR
									PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID))

DELETE FROM dbo.PatientCase WHERE VendorImportID = @VendorImportID OR
									PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID)

DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM Patient WHERE VendorImportID = @VendorImportID)

DELETE FROM dbo.PaymentPatient WHERE PatientID IN (SELECT PatientID FROM Patient WHERE VendorImportID = @VendorImportID)

DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID)

DELETE FROM dbo.Patient WHERE VendorImportID = @VendorImportID

DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND DoctorID NOT IN (SELECT PrimaryCarePhysicianID FROM dbo.Patient)

DELETE FROM dbo.ContractToInsurancePlan WHERE PlanID IN 
(
	SELECT InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID AND InsuranceCompanyPlanID NOT IN (SELECT InsuranceCompanyPlanID FROM dbo.InsurancePolicy)
)

DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID AND InsuranceCompanyPlanID NOT IN (SELECT InsuranceCompanyPlanID FROM dbo.InsurancePolicy)

DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID AND InsuranceCompanyID NOT IN (SELECT InsuranceCompanyID FROM dbo.InsuranceCompanyPlan)

-- Even though customer supplied a separate insurance sheet, we're going to ignore it because it has no reliable linkage to the policies data in the patient demo sheet.
-- So we're going to harvent the ins companies from the patient demo sheet.

-- Table var for insurance info
DECLARE @InsuranceCompany TABLE (
	InsName VARCHAR(100),
	InsAddr1 VARCHAR(100),
	InsCity VARCHAR(100),
	InsState VARCHAR(100),
	InsZip VARCHAR(100)
)

INSERT INTO @InsuranceCompany
	( 
	InsName,
	InsAddr1,
	InsCity,
	InsState,
	InsZip
	)
SELECT DISTINCT [primary_insurance], [prim_ins_address], [prim_ins_city_], LEFT([prim_ins_state], 2), LEFT(REPLACE([prim_ins_zip], '-',''), 9) FROM dbo.[_import_4_1_Patientdemos] WHERE [primary_insurance] <> ''
UNION
SELECT DISTINCT [sec_ins_name], [sec_ins_address], [sec_ins_city], LEFT([sec_ins_state], 2), LEFT(REPLACE([sec_ins_zip], '-',''), 9) FROM dbo.[_import_4_1_Patientdemos] WHERE [sec_ins_name] <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records distilled from import data'

-- Unfortunately some of these ins companies already exist in kareo so we need to refine our list a little
DELETE tmp FROM @InsuranceCompany tmp
INNER JOIN InsuranceCompany ic ON
	tmp.InsName = ic.InsuranceCompanyName AND
	tmp.InsAddr1 = ic.AddressLine1 AND
	tmp.InsCity = ic.City AND
	tmp.InsState = ic.State AND
	tmp.InsZip = ic.ZipCode

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records culled from distillation because they are already in Kareo'

-- Insurance Company
PRINT ''
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany (
	InsuranceCompanyName,
	AddressLine1,
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
	InsName
	,InsAddr1
	,InsCity
	,InsState
	,'USA'
	,InsZip
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
FROM @InsuranceCompany

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
	,impIns.InsCity
	,impIns.InsState
	,'USA'
	,impIns.InsZip
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,0
	,@VendorImportID
	,ic.InsuranceCompanyID
FROM @InsuranceCompany impIns
INNER JOIN dbo.InsuranceCompany ic ON
	ic.VendorImportID = @VendorImportID AND
	impIns.InsName = ic.InsuranceCompanyName AND
	impIns.InsAddr1 = ic.AddressLine1 AND
	impIns.InsCity = ic.City AND
	impIns.InsState = ic.State AND
	impIns.InsZip = ic.ZipCode
		
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
		WHEN policyholder_1st_name <> '' AND (policyholder_1st_name <> first_name OR policyholder_last_name <> last_name) THEN 'O'
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
	,CASE WHEN policyholder_1st_name <> '' AND (policyholder_1st_name <> first_name OR policyholder_last_name <> last_name) THEN policyholder_1st_name ELSE NULL END
	,CASE WHEN policyholder_1st_name <> '' AND (policyholder_1st_name <> first_name OR policyholder_last_name <> last_name) THEN policy_holder__middlie_initial ELSE NULL END
	,CASE WHEN policyholder_1st_name <> '' AND (policyholder_1st_name <> first_name OR policyholder_last_name <> last_name) THEN policyholder_last_name ELSE NULL END
	,CASE WHEN policyholder_1st_name <> '' AND (policyholder_1st_name <> first_name OR policyholder_last_name <> last_name) THEN CASE ISDATE(policy_holder_dob) WHEN 1 THEN policy_holder_dob ELSE NULL END ELSE NULL END
	,CASE WHEN policyholder_1st_name <> '' AND (policyholder_1st_name <> first_name OR policyholder_last_name <> last_name) THEN policy_holder_sex ELSE NULL END
FROM dbo.[_import_4_1_Patientdemos] impPC
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorImportID = @VendorImportID AND 
	impPC.ID = pc.VendorID 
INNER JOIN 
	(
		SELECT MAX(InsuranceCompanyPlanID) AS InsuranceCompanyPlanID, PlanName, AddressLine1, City, State, ZipCode FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID GROUP BY PlanName, AddressLine1, City, State, ZipCode
	) icp ON 
		impPC.primary_insurance = icp.PlanName AND 
		impPC.prim_ins_address = icp.AddressLine1 AND
		impPC.[prim_ins_city_] = icp.City AND
		LEFT(impPC.prim_ins_state, 2) = icp.State AND
		LEFT(REPLACE(impPC.prim_ins_zip, '-',''), 9) = icp.ZipCode
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
	HolderLastName
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,2
	,sec_ins_id
	,sec_ins_grp
	,CASE 
		WHEN sec_ins_ph_1st_name <> '' AND (sec_ins_ph_1st_name <> first_name OR sec_ins_ph_last_name <> last_name) THEN 'O'
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
	,CASE WHEN sec_ins_ph_1st_name <> '' AND (sec_ins_ph_1st_name <> first_name OR sec_ins_ph_last_name <> last_name) THEN sec_ins_ph_1st_name ELSE NULL END
	,CASE WHEN sec_ins_ph_1st_name <> '' AND (sec_ins_ph_1st_name <> first_name OR sec_ins_ph_last_name <> last_name) THEN sec_ph_initial ELSE NULL END
	,CASE WHEN sec_ins_ph_1st_name <> '' AND (sec_ins_ph_1st_name <> first_name OR sec_ins_ph_last_name <> last_name) THEN sec_ins_ph_last_name ELSE NULL END
FROM dbo.[_import_4_1_Patientdemos] impPC
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorImportID = @VendorImportID AND 
	impPC.ID = pc.VendorID 
INNER JOIN 
	(
		SELECT MAX(InsuranceCompanyPlanID) AS InsuranceCompanyPlanID, PlanName, AddressLine1, City, State, ZipCode FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID GROUP BY PlanName, AddressLine1, City, State, ZipCode
	) icp ON 
		impPC.sec_ins_name = icp.PlanName AND 
		impPC.sec_ins_address = icp.AddressLine1 AND
		impPC.sec_ins_city = icp.City AND
		LEFT(impPC.sec_ins_state, 2) = icp.State AND
		LEFT(REPLACE(impPC.sec_ins_zip, '-',''), 9) = icp.ZipCode
WHERE
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID AND
	impPC.sec_ins_name <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


COMMIT TRAN