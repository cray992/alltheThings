-- Action P.M. & R.
-- PracticeID = 111
-- VendorImportID = 2
-- Modified script by adding ReferringPhysicianID to PatientCase

/* Make sure that vendorImportID column has been added to Patient, PatientCase, InsuranceCompany, InsurancePolicy, InsuranceCompanyPlan, ReferringPhysician
	by executing AlterVendorImportAndAddVendorImportStatusTables_superbill_0001_script
and that all ActionPMR_XYZ tables have been populated using ActionPMR_MMImport_0001_DTS.dts package on k0

*/

--BEGIN TRANSACTION

DECLARE @PracticeID int
DECLARE @VendorImportID int

INSERT INTO VendorImport (VendorName, Notes, VendorFormat) VALUES ('Action P.M. & R.', 'MM Import - Patient and Insurance data', 'MedicalManager')

SET @VendorImportID = @@IDENTITY
SET @PracticeID = 111


-- ReferringPhysician		Note: did not consider that some of them may already exist (UPIN numbers are not unique)
-- ActionPMR_refffile

INSERT INTO ReferringPhysician (PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, UPIN, 
WorkPhone, AddressLine1, AddressLine2, City, State, ZipCode, MM_ref_dr_no, VendorID, VendorImportID)
SELECT @PracticeID, '', 
CASE WHEN FirstName IS NOT NULL THEN LTRIM(RTRIM(FirstName)) ELSE '' END,
CASE WHEN MiddleName IS NOT NULL THEN LTRIM(RTRIM(MiddleName)) ELSE '' END,
CASE WHEN LastName IS NOT NULL THEN LTRIM(RTRIM(LastName)) ELSE '' END, '',
CASE WHEN UPIN IS NOT NULL THEN LTRIM(RTRIM(UPIN)) ELSE '' END,
CASE WHEN WorkPhone IS NULL THEN '' ELSE LTRIM(RTRIM(WorkPhone)) END,
CASE WHEN AddressLine1 IS NULL THEN '' ELSE LTRIM(RTRIM(AddressLine1)) END,
CASE WHEN AddressLine2 IS NULL THEN '' ELSE LTRIM(RTRIM(AddressLine2)) END,
CASE WHEN City IS NULL THEN '' ELSE LTRIM(RTRIM(City)) END,
CASE WHEN State IS NULL THEN '' ELSE LTRIM(RTRIM(State)) END,
CASE WHEN ZipCode IS NULL THEN '' ELSE LTRIM(RTRIM(ZipCode)) END,
CASE WHEN MM_ref_dr_no IS NULL THEN '' ELSE CAST(LTRIM(RTRIM(MM_ref_dr_no)) AS INT) END,
CASE WHEN MM_ref_dr_no IS NULL THEN '' ELSE CAST(LTRIM(RTRIM(MM_ref_dr_no)) AS INT) END,
@VendorImportID
FROM ActionPMR_reffile
ORDER BY MM_ref_dr_no

-- Patient (note: the same ssn can correspond to more than 1 PatientID, if patient used more than one practice)
-- ActionPMR_patients

INSERT INTO Patient(VendorImportID, VendorID, PracticeID, ReferringPhysicianID, 
Prefix, FirstName, MiddleName, LastName, Suffix,
AddressLine1, AddressLine2, City, State, ZipCode, Gender, MaritalStatus,
HomePhone, WorkPhone, DOB, SSN, Notes, ResponsibleDifferentThanPatient, PrimaryProviderID)
SELECT  @VendorImportID, PatientAccountID, @PracticeID, 
ReferringPhysicianID = (SELECT DISTINCT ReferringPhysicianID from ReferringPhysician rp 
WHERE rp.VendorImportID = @VendorImportID AND rp.MM_ref_dr_no = mp.ReferringPhysicianID 
and rp.PracticeID = @PracticeID), '',
CASE WHEN FirstName IS NULL THEN '' ELSE LTRIM(RTRIM(FirstName)) END, 
CASE WHEN MiddleName IS NULL THEN '' ELSE LTRIM(RTRIM(MiddleName)) END,
CASE WHEN LastName IS NULL THEN '' ELSE LTRIM(RTRIM(LastName)) END, '',
CASE WHEN AddressLine1 IS NULL THEN '' ELSE LTRIM(RTRIM(AddressLine1)) END, 
CASE WHEN AddressLine2 IS NULL THEN '' ELSE LTRIM(RTRIM(AddressLine2)) END, 
CASE WHEN City IS NOT NULL THEN LTRIM(RTRIM(City)) ELSE NULL END, 
CASE WHEN State IS NOT NULL AND LEN(LTRIM(RTRIM(State))) < 3 THEN LTRIM(RTRIM(State)) ELSE NULL END, 
CASE WHEN ZipCode IS NOT NULL THEN LTRIM(RTRIM(REPLACE(ZipCode,'*',''))) ELSE NULL END, 
CASE WHEN Gender IS NOT NULL THEN LTRIM(RTRIM(Gender)) ELSE 'U' END, 
CASE WHEN MaritalStatus IS NOT NULL AND LEN(LTRIM(RTRIM(MaritalStatus))) < 2 THEN LTRIM(RTRIM(MaritalStatus)) ELSE 'U' END, 
CASE WHEN HomePhone IS NOT NULL THEN LTRIM(RTRIM(HomePhone)) ELSE NULL END, 
CASE WHEN WorkPhone IS NOT NULL THEN LTRIM(RTRIM(WorkPhone)) ELSE NULL END, 
CASE WHEN DOB IS NOT NULL AND LEN(DOB) = 8 THEN CAST(LTRIM(RTRIM(DOB)) AS DATETIME) ELSE NULL END, 
CASE WHEN SSN IS NOT NULL THEN (LTRIM(RTRIM(SSN))) ELSE NULL END, 
CASE WHEN Notes IS NOT NULL THEN (LTRIM(RTRIM(Notes))) ELSE NULL END, 0,
CASE WHEN LTRIM(RTRIM(mp.PrimaryProviderID)) = '8' THEN 240			-- Gary W Golden		-- DOCTOR ID?
     WHEN LTRIM(RTRIM(mp.PrimaryProviderID)) = '4' THEN 242			-- Arins Patalot
     WHEN LTRIM(RTRIM(mp.PrimaryProviderID)) IN ('1', '5', '7', '9') THEN 241	-- John D Mikuzis
     WHEN LTRIM(RTRIM(mp.PrimaryProviderID)) = '2' THEN NULL			-- Steven Bardfield - no longer in this practice (per Adren/PAT)			
     WHEN LTRIM(RTRIM(mp.PrimaryProviderID)) = '3' THEN NULL			-- Richard Kiang    - no longer in this practice
     WHEN LTRIM(RTRIM(mp.PrimaryProviderID)) = '6' THEN NULL			-- Stefania Chase   - no longer in this practice
     WHEN LTRIM(RTRIM(mp.PrimaryProviderID)) = '0' THEN NULL		-- Rehab Consultants, Mohave Neuro
     ELSE NULL END
    FROM ActionPMR_patients mp 
WHERE mp.SSN NOT IN (SELECT p.SSN from Patient p WHERE p.PracticeID = @PracticeID)

-- InsuranceCompany
-- ActionPMR_carrier

-- Need to check if any of these companies are already in InsuranceCompany table in _0001 DB - impossible without address and zip code
-- Assume that duplicates are OK and insert into InsuranceCompany table

INSERT INTO InsuranceCompany
( VendorID, VendorImportID, CompanyTextID, InsuranceCompanyName, ReviewCode)
SELECT LTRIM(RTRIM(InsuranceCompanyCode)), @VendorImportID, LTRIM(RTRIM(InsuranceCompanyCode)), LTRIM(RTRIM(InsuranceCompanyName)), 'R' 
FROM ActionPMR_carrier		-- use InsuranceCompanyCode as VendorID


-- InsuranceCompanyPlan
-- Insert plans that do not already exist  in InsuranceCompanyPlan

-- 1) find which ones exist;  use InsurancePlanNo (clm_co_no as VendorID - same as plan 1, 2 and 3 in patient)

CREATE TABLE #IP (InsuranceCompanyPlanID int, InsurancePlanNo varchar(255), PlanName varchar(255), AddressLine1 varchar(255), 
City varchar(255), State varchar(255), ZipCode varchar(255), Phone varchar(255), MM_CompanyID varchar(255), 
Copay varchar(255), PhoneExt varchar(255))

INSERT INTO #IP			-- Insert plans that already exist in InsuranceCompanyPlan table
(InsuranceCompanyPlanID, InsurancePlanNo, PlanName, AddressLine1, City, State, ZipCode, Phone, MM_CompanyID, Copay, PhoneExt)
SELECT icp.InsuranceCompanyPlanID, ip.InsurancePlanNo, ip.PlanName, ip.AddressLine1, ip.City, ip.State, ip.ZipCode, ip.Phone, ip.MM_CompanyID, 
ip.Copay, ip.PhoneExt FROM ActionPMR_insplan ip
JOIN InsuranceCompanyPlan icp
ON icp.MM_CompanyID = ip.MM_CompanyID
WHERE LEFT(icp.ZipCode, 5) = LEFT(ip.ZipCode, 5) 
AND icp.PlanName = ip.PlanName
AND REPLACE(REPLACE(icp.AddressLine1, ' ', ''), '.', '') = REPLACE(REPLACE(ip.AddressLine1, ' ', ''), '.', '')
ORDER BY ip.PlanName


--select * from #IP
-- Insert plans that do not already exist in InsuranceCompanyPlan table
INSERT INTO InsuranceCompanyPlan(VendorImportID, VendorID, PlanName, InsuranceCompanyID, AddressLine1, City, State, ZipCode, Phone, MM_CompanyID, Copay, PhoneExt, ReviewCode)
SELECT 
	@VendorImportID, 
	ip.InsurancePlanNo, 
	ip.PlanName, 
	ic.InsuranceCompanyID, 
	ip.AddressLine1, 
	ip.City, 
	CASE WHEN LEN(ip.State) <= 2 THEN ip.State ELSE NULL END,
	CASE WHEN LEN(ip.ZipCode) <= 9 THEN ip.ZipCode ELSE NULL END, 
	ip.Phone, 
	ip.MM_CompanyID, 
	COALESCE(CAST(ip.Copay AS money),0), 
	ip.PhoneExt, 
	'R' 
from ActionPMR_insplan ip
	inner join insurancecompany ic on ic.CompanyTextID = ip.MM_CompanyID and ic.VendorImportID = @VendorImportID
WHERE 
	ip.InsurancePlanNo NOT IN (SELECT InsurancePlanNo FROM #IP)


-- Insurance plans that did not exist will have VendorImportID and VendorID = ActionPMR_insplan.InsurancePlanNo
-- for those that did exist, match InsuranceComapnyPlanID from #IP 
-- select InsuranceCompanyPlanID from #IP 

DECLARE @Loop INT 
DECLARE @Count INT
DECLARE @PatientID INT
DECLARE @PatientVendorID VARCHAR(50)
DECLARE @NewPatientCaseID INT
-- add referring physicianid
DECLARE @RefPhysID INT

DECLARE @InsVendorID1 VARCHAR(50)
DECLARE @Ins1Policy VARCHAR(32)
DECLARE @Ins1Group Varchar(32)
DECLARE @Ins1CompanyPlanID INT
DECLARE @Policy1StartDate DATETIME		
DECLARE @Policy1EndDate DATETIME
DECLARE @InsuredParty1No VARCHAR(50)
DECLARE @InsuredParty1LastName VARCHAR(64)
DECLARE @InsuredParty1FirstName VARCHAR(64)
DECLARE @InsuredParty1MiddleName VARCHAR(64)
DECLARE @InsuredParty1AddressLine1 VARCHAR(256)
DECLARE @InsuredParty1City VARCHAR(128)
DECLARE @InsuredParty1State VARCHAR(2)
DECLARE @InsuredParty1ZipCode VARCHAR(9)
DECLARE @InsuredParty1PolicyNumber VARCHAR(50)
DECLARE @InsuredParty1Gender CHAR(1)
DECLARE @InsuredParty1Phone VARCHAR(10)
DECLARE @InsuredParty1DOB DATETIME
DECLARE @InsuredParty1Employer VARCHAR(128)
DECLARE @PatientRelationshipToInsured1 CHAR(1)	
--DECLARE @HolderDifferentThanPatient1 BIT  -- This field has been removed by Sergei

DECLARE @InsVendorID2 VARCHAR(50)
DECLARE @Ins2Policy VARCHAR(32)
DECLARE @Ins2Group Varchar(32)
DECLARE @Ins2CompanyPlanID INT
DECLARE @Policy2StartDate DATETIME
DECLARE @Policy2EndDate DATETIME
DECLARE @InsuredParty2No VARCHAR(50)
DECLARE @InsuredParty2LastName VARCHAR(64)
DECLARE @InsuredParty2FirstName VARCHAR(64)
DECLARE @InsuredParty2MiddleName VARCHAR(64)
DECLARE @InsuredParty2AddressLine1 VARCHAR(256)
DECLARE @InsuredParty2City VARCHAR(128)
DECLARE @InsuredParty2State VARCHAR(2)
DECLARE @InsuredParty2ZipCode VARCHAR(9)
DECLARE @InsuredParty2PolicyNumber VARCHAR(50)
DECLARE @InsuredParty2Gender CHAR(1)
DECLARE @InsuredParty2Phone VARCHAR(10)
DECLARE @InsuredParty2DOB DATETIME
DECLARE @InsuredParty2Employer VARCHAR(128)
DECLARE @PatientRelationshipToInsured2 CHAR(1)	
--DECLARE @HolderDifferentThanPatient2 BIT 

DECLARE @InsVendorID3 VARCHAR(50)
DECLARE @Ins3Policy VARCHAR(32)
DECLARE @Ins3Group Varchar(32)
DECLARE @Ins3CompanyPlanID INT
DECLARE @Policy3StartDate DATETIME
DECLARE @Policy3EndDate DATETIME
DECLARE @InsuredParty3No VARCHAR(50)
DECLARE @InsuredParty3LastName VARCHAR(64)
DECLARE @InsuredParty3FirstName VARCHAR(64)
DECLARE @InsuredParty3MiddleName VARCHAR(64)
DECLARE @InsuredParty3AddressLine1 VARCHAR(256)
DECLARE @InsuredParty3City VARCHAR(128)
DECLARE @InsuredParty3State VARCHAR(2) 
DECLARE @InsuredParty3ZipCode VARCHAR(9)
DECLARE @InsuredParty3PolicyNumber VARCHAR(50)
DECLARE @InsuredParty3Gender CHAR(1)
DECLARE @InsuredParty3Phone VARCHAR(10)
DECLARE @InsuredParty3DOB DATETIME
DECLARE @InsuredParty3Employer VARCHAR(128)
DECLARE @PatientRelationshipToInsured3 CHAR(1)	
--DECLARE @HolderDifferentThanPatient3 BIT 

-- For new patients create new 'Case 1', for existing: ignore (consider adding new cases later?)

-- Create PatientCase for each new patient and insert InsurancePolicy data

CREATE TABLE #P(PID INT IDENTITY(1,1), PatientID INT, VendorID VARCHAR(50), VendorImportID INT, PracticeID INT, RefPhysID INT) 		-- NEW PATIENTS ONLY 
INSERT INTO #P(PatientID, VendorID, VendorImportID, PracticeID, RefPhysID)		
SELECT PatientID, VendorID, VendorImportID, PracticeID, ReferringPhysicianID
FROM Patient
WHERE VendorID IS NOT NULL
AND VendorImportID=@VendorImportID
AND PracticeID = 111

-- select * from #P

SET @Loop=@@ROWCOUNT
PRINT @Loop
SET @Count=0

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1

	IF (@Count % 100) = 0  
	BEGIN
		PRINT @Count
	END

	SELECT @PatientID=PatientID, @PatientVendorID=VendorID, @RefPhysID=RefPhysID
	FROM #P
	WHERE PID=@Count

	INSERT INTO PatientCase (PatientID, Name, PracticeID, PayerScenarioID, VendorImportID, ReferringPhysicianID)
	VALUES(@PatientID, 'Case 1', 111, 5, @VendorImportID, @RefPhysID)						-- PracticeID = 111		

	SET @NewPatientCaseID=@@IDENTITY

	SET @InsVendorID1=''
	SET @InsVendorID2=''
	SET @InsVendorID3=''

	SELECT @InsVendorID1=LTRIM(RTRIM([InsurancePlan1])), --InsurancePlanNo in ActionPMR_insplan and InsurancePlanNumber in ActionPMR_patins
	       
	       @InsVendorID2=LTRIM(RTRIM([InsurancePlan2])), 

	       @InsVendorID3=LTRIM(RTRIM([InsurancePlan3]))
	       
	FROM [ActionPMR_patients]
	WHERE [PatientAccountID]=@PatientVendorID	-- VendorID in #P


	IF @InsVendorID1<>''		-- InsurancePlan1
	BEGIN
		SET @Ins1CompanyPlanID = NULL -- new
		SELECT @Ins1CompanyPlanID=InsuranceCompanyPlanID
		FROM InsuranceCompanyPlan
		WHERE VendorID=@InsVendorID1 AND VendorImportID = @VendorImportID -- NOTE: ONLY NEWLY ADDED PLANS ARE FOUND HERE, EXISTING ONES DO NOT HAVE VENDORID
										  -- GET THE EXISTING ONES FROM #IP

		IF @Ins1CompanyPlanID IS NULL
		BEGIN
			SELECT @Ins1CompanyPlanID = InsuranceCompanyPlanID FROM #IP WHERE InsurancePlanNo = @InsVendorID1 -- EXISTING ID FOR THIS PLAN #
		END

	SELECT @Ins1Policy=InsurancePolicyNumber,		
       		@Ins1Group=InsurancePolicyGroupNumber,
       		--@UserComment1=UserComment,
		@Policy1StartDate=PolicyStartDate,
		@Policy1EndDate=PolicyEndDate,
		@InsuredParty1No=InsuredPartyNo
	FROM ActionPMR_patins
	WHERE InsurancePlanNumber = @InsVendorID1
	AND InsurancePolicyID=@PatientVendorID


	IF @InsuredParty1No IS NOT NULL	-- set PatientRelationshipToInsured to 'U', add insured party information			
	BEGIN 				-- select insurance holder information
		SELECT
			@InsuredParty1LastName=InsuredPartyLastName,
			@InsuredParty1FirstName=InsuredPartyFirstName,
			@InsuredParty1MiddleName=InsuredPartyMiddleName,
			@InsuredParty1AddressLine1=InsuredPartyAddressLine1,
			@InsuredParty1City=InsuredPartyCity,
			@InsuredParty1State=InsuredPartyState,
			@InsuredParty1ZipCode=InsuredPartyZipCode,
			@InsuredParty1PolicyNumber=InsuredPartyPolicyNumber,
			@InsuredParty1Gender=InsuredPartyGender,
			@InsuredParty1Phone=InsuredPartyPhone,
			@InsuredParty1DOB=InsuredPartyDOB,
			@InsuredParty1Employer=InsuredPartyEmployer
		FROM ActionPMR_patipr
		WHERE InsuredPartyNo=@InsuredParty1No 

		SET @PatientRelationshipToInsured1 = 'U'	
		--SET @HolderDifferentThanPatient1 = 1

	END
	ELSE	-- set PatientRelationshipToInsured to 'S' in InsurancePolicy
	BEGIN	
		SET @PatientRelationshipToInsured1 = 'S' 
		--SET @HolderDifferentThanPatient1 = 0

		-- reset Insured Party information to null
		SET @InsuredParty1LastName=NULL
		SET @InsuredParty1FirstName=NULL
		SET @InsuredParty1MiddleName=NULL
		SET @InsuredParty1AddressLine1=NULL
		SET @InsuredParty1City=NULL
		SET @InsuredParty1State=NULL
		SET @InsuredParty1ZipCode=NULL
		SET @InsuredParty1PolicyNumber=NULL
		SET @InsuredParty1Gender=NULL
		SET @InsuredParty1Phone=NULL
		SET @InsuredParty1DOB=NULL
		SET @InsuredParty1Employer=NULL

	END


	INSERT INTO InsurancePolicy(
		PatientCaseID, PracticeID, InsuranceCompanyPlanID, PolicyNumber, GroupNumber, Precedence, 
		PolicyStartDate, PolicyEndDate, PatientRelationshipToInsured, 
		HolderLastName,
		HolderFirstName,
		HolderMiddleName,
		HolderAddressLine1,
		HolderCity,
		HolderState,
		HolderZipCode,
		--HolderPolicyNumber, --???
		HolderGender,
		HolderPhone,
		HolderDOB,
		HolderEmployerName,
		VendorID,
		VendorImportID
		)
		VALUES(
		@NewPatientCaseID, @PracticeID, @Ins1CompanyPlanID, @Ins1Policy, @Ins1Group, 1, 
		@Policy1StartDate, @Policy1EndDate, @PatientRelationshipToInsured1, 
		@InsuredParty1LastName,										
		@InsuredParty1FirstName,
		@InsuredParty1MiddleName,
		@InsuredParty1AddressLine1,
		@InsuredParty1City,
		@InsuredParty1State,
		@InsuredParty1ZipCode,
		--@InsuredParty1PolicyNumber,
		@InsuredParty1Gender,
		@InsuredParty1Phone,
		@InsuredParty1DOB,
		@InsuredParty1Employer,
		@InsuredParty1No,
		@VendorImportID
		)


	END		-- END of InsurancePlan1


	IF @InsVendorID2<>''
	BEGIN
		SET @Ins2CompanyPlanID = NULL	
		-- set PRECEDENCE = 2
		SELECT @Ins2CompanyPlanID=InsuranceCompanyPlanID
		FROM InsuranceCompanyPlan
		WHERE VendorID=@InsVendorID2 AND VendorImportID = @VendorImportID


		IF @Ins2CompanyPlanID IS NULL 

		BEGIN
			SELECT @Ins2CompanyPlanID = InsuranceCompanyPlanID FROM #IP WHERE InsurancePlanNo = @InsVendorID2 
		END


	SELECT @Ins2Policy=InsurancePolicyNumber,		
       		@Ins2Group=InsurancePolicyGroupNumber,
       		--@UserComment2=UserComment,
		@Policy2StartDate=PolicyStartDate,
		@Policy2EndDate=PolicyEndDate,
		@InsuredParty2No=InsuredPartyNo
	FROM ActionPMR_patins
	WHERE InsurancePlanNumber = @InsVendorID2
	AND InsurancePolicyID=@PatientVendorID

	IF @InsuredParty2No IS NOT NULL		-- set PatientRelationshipToInsured to 'U', add insured party information			
	BEGIN -- select insurance holder information
		SELECT
			@InsuredParty2LastName=InsuredPartyLastName,
			@InsuredParty2FirstName=InsuredPartyFirstName,
			@InsuredParty2MiddleName=InsuredPartyMiddleName,
			@InsuredParty2AddressLine1=InsuredPartyAddressLine1,
			@InsuredParty2City=InsuredPartyCity,
			@InsuredParty2State=InsuredPartyState,
			@InsuredParty2ZipCode=InsuredPartyZipCode,
			@InsuredParty2PolicyNumber=InsuredPartyPolicyNumber,
			@InsuredParty2Gender=InsuredPartyGender,
			@InsuredParty2Phone=InsuredPartyPhone,
			@InsuredParty2DOB=InsuredPartyDOB,
			@InsuredParty2Employer=InsuredPartyEmployer
		FROM ActionPMR_patipr
		WHERE InsuredPartyNo=@InsuredParty2No 

		SET @PatientRelationshipToInsured2 = 'U'	
		--SET @HolderDifferentThanPatient2 = 1

	END
	ELSE	-- set PatientRelationshipToInsured to 'S' in InsurancePolicy
	BEGIN	
		SET @PatientRelationshipToInsured2 = 'S' 
		--SET @HolderDifferentThanPatient2 = 0
		-- reset Insured Party information to null
		SET @InsuredParty2LastName=NULL
		SET @InsuredParty2FirstName=NULL
		SET @InsuredParty2MiddleName=NULL
		SET @InsuredParty2AddressLine1=NULL
		SET @InsuredParty2City=NULL
		SET @InsuredParty2State=NULL
		SET @InsuredParty2ZipCode=NULL
		SET @InsuredParty2PolicyNumber=NULL
		SET @InsuredParty2Gender=NULL
		SET @InsuredParty2Phone=NULL
		SET @InsuredParty2DOB=NULL
		SET @InsuredParty2Employer=NULL

	END


	INSERT INTO InsurancePolicy(
		PatientCaseID, PracticeID, InsuranceCompanyPlanID, PolicyNumber, GroupNumber, Precedence, 
		PolicyStartDate, PolicyEndDate, PatientRelationshipToInsured, 
		HolderLastName,
		HolderFirstName,
		HolderMiddleName,
		HolderAddressLine1,
		HolderCity,
		HolderState,
		HolderZipCode,
		--HolderPolicyNumber, --???
		HolderGender,
		HolderPhone,
		HolderDOB,
		HolderEmployerName,
		VendorID,
		VendorImportID
		)
		VALUES(
		@NewPatientCaseID, @PracticeID, @Ins2CompanyPlanID, @Ins2Policy, @Ins2Group, 2, 			-- Precedence 2
		@Policy2StartDate, @Policy2EndDate, @PatientRelationshipToInsured2, 
		@InsuredParty2LastName,											
		@InsuredParty2FirstName,
		@InsuredParty2MiddleName,
		@InsuredParty2AddressLine1,
		@InsuredParty2City,
		@InsuredParty2State,
		@InsuredParty2ZipCode,
		--@InsuredParty2PolicyNumber,
		@InsuredParty2Gender,
		@InsuredParty2Phone,
		@InsuredParty2DOB,
		@InsuredParty2Employer,
		@InsuredParty2No,
		@VendorImportID
		)


	END		-- END of InsurancePlan2


	IF @InsVendorID3<>''
	BEGIN
		SET @Ins3CompanyPlanID = NULL		-- reset
		-- set PRECEDENCE = 3, change numbers in variables to 3
		SELECT @Ins3CompanyPlanID=InsuranceCompanyPlanID
		FROM InsuranceCompanyPlan
		WHERE VendorID=@InsVendorID3 AND VendorImportID = @VendorImportID

		IF @Ins3CompanyPlanID IS NULL 
		BEGIN
			SELECT @Ins3CompanyPlanID = InsuranceCompanyPlanID FROM #IP WHERE InsurancePlanNo = @InsVendorID3 
		END

	SELECT @Ins3Policy=InsurancePolicyNumber,		-- declare these variables above
       		@Ins3Group=InsurancePolicyGroupNumber,
       		--@UserComment3=UserComment,
		@Policy3StartDate=PolicyStartDate,
		@Policy3EndDate=PolicyEndDate,
		@InsuredParty3No=InsuredPartyNo
	FROM ActionPMR_patins
	WHERE InsurancePlanNumber = @InsVendorID3
	AND InsurancePolicyID=@PatientVendorID

	IF @InsuredParty3No IS NOT NULL	-- set PatientRelationshipToInsured to 'U', add insured party information			
	BEGIN -- select insurance holder information
		SELECT
			@InsuredParty3LastName=InsuredPartyLastName,
			@InsuredParty3FirstName=InsuredPartyFirstName,
			@InsuredParty3MiddleName=InsuredPartyMiddleName,
			@InsuredParty3AddressLine1=InsuredPartyAddressLine1,
			@InsuredParty3City=InsuredPartyCity,
			@InsuredParty3State=InsuredPartyState,
			@InsuredParty3ZipCode=InsuredPartyZipCode,
			@InsuredParty3PolicyNumber=InsuredPartyPolicyNumber,
			@InsuredParty3Gender=InsuredPartyGender,
			@InsuredParty3Phone=InsuredPartyPhone,
			@InsuredParty3DOB=InsuredPartyDOB,
			@InsuredParty3Employer=InsuredPartyEmployer
		FROM ActionPMR_patipr
		WHERE InsuredPartyNo=@InsuredParty3No 

		SET @PatientRelationshipToInsured3 = 'U'	
		--SET @HolderDifferentThanPatient3 = 1

	END
	ELSE	-- set PatientRelationshipToInsured to 'S' in InsurancePolicy
	BEGIN	
		SET @PatientRelationshipToInsured3 = 'S' 
		--SET @HolderDifferentThanPatient3 = 0

		-- reset Insured Party information to null
		SET @InsuredParty3LastName=NULL
		SET @InsuredParty3FirstName=NULL
		SET @InsuredParty3MiddleName=NULL
		SET @InsuredParty3AddressLine1=NULL
		SET @InsuredParty3City=NULL
		SET @InsuredParty3State=NULL
		SET @InsuredParty3ZipCode=NULL
		SET @InsuredParty3PolicyNumber=NULL
		SET @InsuredParty3Gender=NULL
		SET @InsuredParty3Phone=NULL
		SET @InsuredParty3DOB=NULL
		SET @InsuredParty3Employer=NULL
	END


	INSERT INTO InsurancePolicy(
		PatientCaseID, PracticeID, InsuranceCompanyPlanID, PolicyNumber, GroupNumber, Precedence, 
		PolicyStartDate, PolicyEndDate, PatientRelationshipToInsured, 
		HolderLastName,
		HolderFirstName,
		HolderMiddleName,
		HolderAddressLine1,
		HolderCity,
		HolderState,
		HolderZipCode,
		--HolderPolicyNumber, --???
		HolderGender,
		HolderPhone,
		HolderDOB,
		HolderEmployerName,
		VendorID,
		VendorImportID
		)
		VALUES(
		@NewPatientCaseID, @PracticeID, @Ins3CompanyPlanID, @Ins3Policy, @Ins3Group, 3, 				-- Precedence 3
		@Policy3StartDate, @Policy1EndDate, @PatientRelationshipToInsured3,
		@InsuredParty3LastName,										-- TODO: CHECK FOR NULL VALUES
		@InsuredParty3FirstName,
		@InsuredParty3MiddleName,
		@InsuredParty3AddressLine1,
		@InsuredParty3City,
		@InsuredParty3State,
		@InsuredParty3ZipCode,
		--@InsuredParty3PolicyNumber,
		@InsuredParty3Gender,
		@InsuredParty3Phone,
		@InsuredParty3DOB,
		@InsuredParty3Employer,
		@InsuredParty3No,
		@VendorImportID
		)

	END		-- END of InsurancePlan3

	IF (@InsVendorID1 = '' OR @InsVendorID1 IS NULL) AND (@InsVendorID2 = '' OR @InsVendorID2 IS NULL) AND (@InsVendorID3 = '' OR @InsVendorID3 IS NULL)
	BEGIN
		UPDATE PatientCase SET PayerScenarioID = 11 WHERE PatientCaseID = @NewPatientCaseID		-- 'Self Pay'
	END

END

DROP TABLE #P

-- TODO: create aditional patient cases for existing patients and insert insurance policy data

DROP TABLE #IP

-- ROLLBACK
-- COMMIT

