-- 022006 k0_218 import
-- HealthClaimsPlus superbill_0218
-- PracticeID = 22
-- VendorImportID = 1

/* Make sure that vendorImportID column has been added to Patient, PatientCase, InsuranceCompany, InsurancePolicy, InsuranceCompanyPlan, ReferringPhysician
	by executing AlterVendorImportAndAddVendorImportStatusTables_superbill_0001_script
and that all HCP tables have been populated 
*/

BEGIN TRANSACTION

DECLARE @PracticeID int
DECLARE @VendorImportID int

INSERT INTO VendorImport (VendorName, Notes, VendorFormat) VALUES ('Winnie-Stowell EMS', 'HealthClaimsPlus Import - Patient and Insurance data', 'MediSoft')

SET @VendorImportID = @@IDENTITY
SET @PracticeID = 22 -- Winnie Stowell


-- ReferringPhysician		Note: did not consider that some of them may already exist (UPIN numbers are not unique)
-- MWRPH

INSERT INTO ReferringPhysician (PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, Degree, UPIN, 
	    WorkPhone, FaxPhone, AddressLine1, AddressLine2, City, State, ZipCode, VendorID, VendorImportID)
SELECT @PracticeID, '', 
	CASE WHEN FirstName IS NOT NULL THEN LTRIM(RTRIM(FirstName)) ELSE '' END,
	CASE WHEN MiddleInitial IS NOT NULL THEN LTRIM(RTRIM(MiddleInitial)) ELSE '' END,
	CASE WHEN LastName IS NOT NULL THEN LTRIM(RTRIM(LastName)) ELSE '' END, '',
	CASE WHEN Credentials IS NOT NULL THEN LTRIM(RTRIM(Credentials)) ELSE '' END,
	CASE WHEN UPIN IS NOT NULL THEN LTRIM(RTRIM(UPIN)) ELSE '' END,
	--CASE WHEN Office IS NULL THEN '' ELSE LTRIM(RTRIM(Office)) END,
CASE WHEN Office IS NOT NULL THEN LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(Office, '-', ''), '(', ''), ')', ''))) ELSE '' END,
	--CASE WHEN Fax IS NULL THEN '' ELSE LTRIM(RTRIM(Fax)) END,
CASE WHEN Fax IS NOT NULL THEN LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(Fax, '-', ''), '(', ''), ')', ''))) ELSE '' END,
	CASE WHEN Street1 IS NULL THEN '' ELSE LTRIM(RTRIM(Street1)) END,
	CASE WHEN Street2 IS NULL THEN '' ELSE LTRIM(RTRIM(Street2)) END,
	CASE WHEN City IS NULL THEN '' ELSE LTRIM(RTRIM(City)) END,
	CASE WHEN State IS NULL THEN '' ELSE LTRIM(RTRIM(State)) END,
	CASE WHEN ZipCode IS NULL THEN '' ELSE LTRIM(RTRIM(REPLACE(ZipCode,'-',''))) END,
	CASE WHEN Code IS NULL THEN '' ELSE LTRIM(RTRIM(Code)) END,
	@VendorImportID
FROM HCPWS_MWRPH
ORDER BY Code

-- Patient (note: the same ssn can correspond to more than 1 PatientID, if patient used more than one practice)
-- TODO: insert patients for HCP excluding Guarantor (where Patient Type <> 'Guarantor'
--Create table with Patients and their Guarantors
CREATE TABLE #PG (PatientChartNumber varchar(50), GuarantorChartNumber varchar(50),ResponsibleDifferentThanPatient BIT, ResponsibleFirstName varchar(50), 
ResponsibleMiddleName varchar(50), ResponsibleLastName varchar(50), ResponsibleAddressLine1 varchar(50), ResponsibleAddressLine2 varchar(50), 
ResponsibleCity varchar(50), ResponsibleState varchar(50), ResponsibleZipCode varchar(50), ResponsibleRelationsipToPatient varchar(50))

INSERT INTO #PG (PatientChartNumber, GuarantorChartNumber, ResponsibleDifferentThanPatient, ResponsibleFirstName, ResponsibleMiddleName, 
	ResponsibleLastName, ResponsibleAddressLine1, ResponsibleAddressLine2, 
	ResponsibleCity, ResponsibleState, ResponsibleZipCode, ResponsibleRelationsipToPatient)
SELECT LTRIM(RTRIM(cas.ChartNumber)), LTRIM(RTRIM(cas.Guarantor)), 1, 
	LTRIM(RTRIM(pat.FirstName)), 
	CASE WHEN (pat.MiddleName IS NULL) THEN '' ELSE LTRIM(RTRIM(pat.MiddleName)) END,
	LTRIM(RTRIM(pat.LastName)), 
	CASE WHEN pat.Street1 IS NULL THEN '' ELSE LTRIM(RTRIM(pat.Street1)) END, 
	CASE WHEN pat.Street2 IS NULL THEN '' ELSE LTRIM(RTRIM(pat.Street2)) END,
	CASE WHEN pat.City IS NULL THEN '' ELSE LTRIM(RTRIM(pat.City)) END, 
	CASE WHEN pat.State IS NULL THEN '' ELSE LTRIM(RTRIM(pat.State)) END, 
	CASE WHEN pat.ZipCode IS NULL THEN '' ELSE LTRIM(RTRIM(REPLACE(ZipCode,'-',''))) END, 'U'
FROM HCPWS_MWPAT pat
INNER JOIN HCPWS_MWCAS cas ON cas.Guarantor = pat.ChartNumber
WHERE cas.ChartNumber <> cas.Guarantor
AND  UPPER(LTRIM(RTRIM(CAS.ChartNumber))) <> 'VOIDRUNS' 

INSERT INTO Patient(VendorImportID, VendorID, PracticeID, ReferringPhysicianID, 
	Prefix, FirstName, MiddleName, LastName, Suffix,
	AddressLine1, AddressLine2, City, State, ZipCode, Gender, MaritalStatus,
	HomePhone, WorkPhone, WorkPhoneExt,DOB, SSN, ResponsibleDifferentThanPatient, 
	ResponsibleFirstName, ResponsibleMiddleName, ResponsibleLastName, ResponsibleAddressLine1, 
	ResponsibleAddressLine2, ResponsibleCity, ResponsibleState, ResponsibleZipCode, PrimaryProviderID)
SELECT  DISTINCT @VendorImportID, pat.ChartNumber, @PracticeID, 		-- pg.PatientChartNumber, pg.GuarantorChartNumber, 
 		(SELECT DISTINCT rp.ReferringPhysicianID FROM ReferringPhysician rp 
 				WHERE cas.ReferringProvider = rp.VendorID 
 				AND rp.VendorImportID = @VendorImportID 			
 				AND cas.ChartNumber = pat.ChartNumber   
 				AND rp.PracticeID = @PracticeID),
	'', CASE WHEN pat.FirstName IS NULL THEN '' ELSE LTRIM(RTRIM(pat.FirstName)) END, 
	CASE WHEN pat.MiddleName IS NULL THEN '' ELSE LTRIM(RTRIM(pat.MiddleName)) END,
	CASE WHEN pat.LastName IS NULL THEN '' ELSE LTRIM(RTRIM(pat.LastName)) END, '',
	CASE WHEN pat.Street1 IS NULL THEN '' ELSE LTRIM(RTRIM(pat.Street1)) END, 
	CASE WHEN pat.Street2 IS NULL THEN '' ELSE LTRIM(RTRIM(pat.Street2)) END, 
	CASE WHEN pat.City IS NOT NULL THEN LTRIM(RTRIM(pat.City)) ELSE '' END, 
	CASE WHEN pat.State IS NOT NULL AND LEN(LTRIM(RTRIM(pat.State))) < 3 THEN LTRIM(RTRIM(pat.State)) ELSE NULL END, 
	CASE WHEN pat.ZipCode IS NOT NULL THEN LEFT(LTRIM(RTRIM(REPLACE(ZipCode,'-',''))), 10) ELSE NULL END, 
	CASE WHEN LTRIM(RTRIM(pat.Gender)) = 'Male' THEN 'M'
     		WHEN LTRIM(RTRIM(pat.Gender)) = 'Female' THEN 'F'
     		ELSE 'U' END,
	'U', -- MariatalStatus not available in patients table
	CASE WHEN pat.HomePhone IS NOT NULL THEN LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.HomePhone, '-', ''), '(', ''), ')', ''))), 10) ELSE '' END, 
	CASE WHEN pat.WorkPhone IS NOT NULL THEN LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.WorkPhone, '-', ''), '(', ''), ')', ''))), 10) ELSE '' END, 
	CASE WHEN pat.WorkExtension IS NOT NULL THEN LEFT(LTRIM(RTRIM(pat.WorkExtension)), 10) END,
	CASE WHEN pat.DateOfBirth IS NOT NULL THEN CAST(LTRIM(RTRIM(pat.DateOfBirth)) AS DATETIME) ELSE NULL END, 
	CASE WHEN pat.SocialSecurityNumber IS NOT NULL THEN LEFT((LTRIM(RTRIM(REPLACE(pat.SocialSecurityNumber, '-', '')))), 9) ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN 1 ELSE 0 END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN pg.ResponsibleFirstName ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN pg.ResponsibleMiddleName ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL  THEN pg.ResponsibleLastName ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN pg.ResponsibleAddressLine1 ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN pg.ResponsibleAddressLine2 ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN pg.ResponsibleCity ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN pg.ResponsibleState ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN LEFT(pg.ResponsibleZipCode, 9) ELSE NULL END, NULL
FROM HCPWS_MWPAT pat
	LEFT OUTER JOIN #PG pg ON pat.ChartNumber = pg.PatientChartNumber
	JOIN HCPWS_MWCAS cas ON cas.ChartNumber = pat.ChartNumber
WHERE UPPER(LTRIM(RTRIM(pat.PatientType))) <> 'Guarantor' 
	AND UPPER(LTRIM(RTRIM(pat.ChartNumber))) <> 'VOIDRUNS'


--LEFT JOIN #PG pg ON pat.ChartNumber = pg.PatientChartNumber
--WHERE UPPER(LTRIM(RTRIM(pat.PatientType))) = 'PATIENT' AND pat.SocialSecurityNumber NOT IN (SELECT p.SSN from Patient p WHERE p.PracticeID = @PracticeID)

-- InsuranceCompany
-- MWINS - Assume that insurance company is the same as insuranceplan 
-- Create temporary table to hold insurance companies that already exist in InsuranceCompany table
CREATE TABLE #EIC (InsuranceCompanyID int, InsuranceCompanyName varchar(255), AddressLine1 varchar(255), AddressLine2 varchar(255), City varchar(255),
State varchar(255), ZipCode varchar(255), Phone varchar(255), PhoneExt varchar(255), ReviewCode varchar(255), Code varchar(255))

INSERT INTO #EIC (InsuranceCompanyID, InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt, ReviewCode, Code)
SELECT ico.InsuranceCompanyID, ic.Name, ic.Street1, ic.Street2, ic.City, ic.State, ic.ZipCode, ic.Phone, ic.Extension, ico.ReviewCode, ic.Code
FROM HCPWS_MWINS ic
JOIN InsuranceCompany ico
ON LTRIM(RTRIM(ico.VendorID)) = LTRIM(RTRIM(ic.Code))
WHERE LTRIM(RTRIM(ico.City)) = LTRIM(RTRIM(ic.City))
	AND LEFT(ico.ZipCode, 5) = LEFT(ic.ZipCode, 5) 
	AND LTRIM(RTRIM(ico.State)) = LTRIM(RTRIM(ic.State))
	AND LTRIM(RTRIM(ico.InsuranceCompanyName)) = LTRIM(RTRIM(ic.Name))
	AND REPLACE(REPLACE(ico.AddressLine1, ' ', ''), '.', '') = REPLACE(REPLACE(ic.Street1, ' ', ''), '.', '')
ORDER BY ic.Name

-- Store insurance companies that do not exist in InsuranceCompany table in another temporary table #NIC
CREATE TABLE #NIC (Code varchar(255), InsuranceCompanyName varchar(255), AddressLine1 varchar(255), AddressLine2 varchar(255), City varchar(255),
State varchar(255), ZipCode varchar(255), Phone varchar(255), PhoneExt varchar(255), ReviewCode varchar(255))

INSERT INTO #NIC (Code, InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt, ReviewCode)
SELECT ic.Code, ic.Name, ic.Street1, ic.Street2, ic.City, ic.State, ic.ZipCode, ic.Phone, ic.Extension, 'R'
FROM HCPWS_MWINS ic
WHERE ic.Code NOT IN (SELECT Code FROM #EIC)


-- Insert into InsuranceCompany those ins.companies that do not already exist
INSERT INTO InsuranceCompany
( VendorID, VendorImportID, InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt, ReviewCode)
SELECT LTRIM(RTRIM(Code)), @VendorImportID, 
	LTRIM(RTRIM(InsuranceCompanyName)), 
	LTRIM(RTRIM(AddressLine1)), 
	LTRIM(RTRIM(AddressLine2)),
	LTRIM(RTRIM(City)), 
	LTRIM(RTRIM(State)), 
	CASE WHEN ZipCode IS NOT NULL THEN LEFT(LTRIM(RTRIM(REPLACE(REPLACE(ZipCode,'-',''), ' ', ''))), 9) ELSE NULL END, 
	CASE WHEN Phone IS NOT NULL THEN LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Phone,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10) ELSE NULL END,
	CASE WHEN PhoneExt IS NULL THEN '' ELSE LEFT(PhoneExt, 10) END, 'R' 
FROM #NIC		


-- InsuranceCompanyPlan
-- Insert plans that do not already exist  in InsuranceCompanyPlan

-- 1) find which ones exist;  Code - same as InsuranceCarrier #1, #2 and 3# in MWCAS)
-- Existing InsuranceCompanyPlans
CREATE TABLE #EIP (InsuranceCompanyPlanID int, Code varchar(255), PlanName varchar(255), AddressLine1 varchar(255), AddressLine2 varchar(255),
City varchar(255), State varchar(255), ZipCode varchar(255), Phone varchar(255), PhoneExt varchar(255))

INSERT INTO #EIP			-- Insert plans that already exist in InsuranceCompanyPlan table
(InsuranceCompanyPlanID, Code, PlanName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt)
SELECT icp.InsuranceCompanyPlanID, 
	LTRIM(RTRIM(ip.Code)), 
	LTRIM(RTRIM(ip.Name)), 
	LTRIM(RTRIM(ip.Street1)), 
	LTRIM(RTRIM(ip.Street2)), 
	LTRIM(RTRIM(ip.City)), 
	LEFT(LTRIM(RTRIM(ip.State)), 2), 
	--LTRIM(RTRIM(ip.ZipCode)),
	LTRIM(RTRIM(REPLACE(ip.ZipCode,'-',''))), 
	--LTRIM(RTRIM(ip.Phone)), 
	LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Phone,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10),
	--LTRIM(RTRIM(ip.Extension))
	LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Extension,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10) 
FROM HCPWS_MWINS ip
JOIN InsuranceCompanyPlan icp ON LTRIM(RTRIM(icp.VendorID)) = LTRIM(RTRIM(ip.Code))
WHERE LTRIM(RTRIM(icp.City)) = LTRIM(RTRIM(ip.City))
	AND LTRIM(RTRIM(icp.State)) = LTRIM(RTRIM(ip.State))
	AND LEFT(icp.ZipCode, 5) = LEFT(ip.ZipCode, 5) 
	AND LTRIM(RTRIM(icp.PlanName)) = LTRIM(RTRIM(ip.Name))
	AND REPLACE(REPLACE(icp.AddressLine1, ' ', ''), '.', '') = REPLACE(REPLACE(ip.Street1, ' ', ''), '.', '')
ORDER BY ip.Name

-- Create temporary table with plans that do not exist in InsuranceCompanyPlan table

CREATE TABLE #NIP (Code varchar(255), PlanName varchar(255), 
InsuranceCompanyID int, AddressLine1 varchar(255), AddressLine2 varchar(255), 
City varchar(255), State varchar(255), ZipCode varchar(255), Phone varchar(255), PhoneExt varchar(255))

INSERT INTO #NIP			-- Insert plans that do not already exist in InsuranceCompanyPlan table
(Code, PlanName, InsuranceCompanyID, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt)
SELECT LTRIM(RTRIM(ip.Code)), 
	LTRIM(RTRIM(ip.Name)),
	LTRIM(RTRIM(ic.InsuranceCompanyID)), 
	LTRIM(RTRIM(ip.Street1)), 
	LTRIM(RTRIM(ip.Street2)), 
	LTRIM(RTRIM(ip.City)), 
	LTRIM(RTRIM(ip.State)), 
	LTRIM(RTRIM(REPLACE(ip.ZipCode,'-',''))),
	LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Phone,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10), 
	LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Extension,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10) 
FROM HCPWS_MWINS ip 
INNER JOIN InsuranceCompany ic ON ip.Code = ic.VendorID 
WHERE --LTRIM(RTRIM(ic.City)) = LTRIM(RTRIM(ip.City))
	--AND LTRIM(RTRIM(ic.InsuranceCompanyName)) = LTRIM(RTRIM(ip.Name))
	--AND LTRIM(RTRIM(ip.State)) = LTRIM(RTRIM(ic.State))
	--AND LEFT(ip.ZipCode, 5) = LEFT(ic.ZipCode, 5) 
	--AND REPLACE(REPLACE(ip.Street1, ' ', ''), '.', '') = REPLACE(REPLACE(ic.AddressLine1, ' ', ''), '.', '') 
	ip.Code NOT IN (SELECT Code FROM #EIP)
ORDER BY ip.Name

-- Insert plans that do not already exist into InsuranceCompanyPlan table

INSERT INTO InsuranceCompanyPlan(VendorImportID, VendorID, PlanName, InsuranceCompanyID, AddressLine1, AddressLine2, City, State, ZipCode, Phone, Copay, PhoneExt, ReviewCode)
SELECT 
	@VendorImportID, 
	nip.Code, 
	nip.PlanName, 
	nip.InsuranceCompanyID,  
	nip.AddressLine1,
	nip.AddressLine2, 
	nip.City, 
	CASE WHEN LEN(nip.State) <= 2 THEN nip.State ELSE NULL END,
	CASE WHEN LEN(nip.ZipCode) <= 9 THEN nip.ZipCode ELSE NULL END, 
	nip.Phone, 
	--COALESCE(CAST(ip.Copay AS money),0),
	CAST(0.00 AS money), 
	nip.PhoneExt, 
	'R' 
FROM #NIP nip
INNER JOIN InsuranceCompany ic ON ic.VendorID = nip.Code
WHERE
	LTRIM(RTRIM(nip.State)) = LTRIM(RTRIM(ic.State))
	AND LTRIM(RTRIM(ic.InsuranceCompanyName)) = LTRIM(RTRIM(nip.PlanName))
	AND LEFT(nip.ZipCode, 5) = LEFT(ic.ZipCode, 5) 
	AND REPLACE(REPLACE(nip.AddressLine1, ' ', ''), '.', '') = REPLACE(REPLACE(ic.AddressLine1, ' ', ''), '.', '') 

-- Insurance plans that did not exist will have VendorImportID for this import and and VendorID = MWINS.Code
-- for those that did exist, match InsuranceCompanyPlanID from #EIP 
-- select InsuranceCompanyPlanID from #EIP 

DECLARE @Loop INT 
DECLARE @Count INT
DECLARE @PatientID INT
DECLARE @PatientVendorID VARCHAR(50)
DECLARE @NewPatientCaseID INT

DECLARE @RefPhysID INT
DECLARE @ChartNumber VARCHAR(50)
--DECLARE @CaseID VARCHAR(50)
--DECLARE @CaseName VARCHAR(50)
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
DECLARE @InsuredParty1AddressLine2 VARCHAR(256)
DECLARE @InsuredParty1City VARCHAR(128)
DECLARE @InsuredParty1State VARCHAR(2)
DECLARE @InsuredParty1ZipCode VARCHAR(9)
DECLARE @InsuredParty1PolicyNumber VARCHAR(50)
DECLARE @InsuredParty1Gender CHAR(1)
DECLARE @InsuredParty1Phone VARCHAR(10)
DECLARE @InsuredParty1DOB DATETIME
DECLARE @InsuredParty1SSN Varchar(50)
DECLARE @InsuredParty1Employer VARCHAR(128)
DECLARE @PatientRelationshipToInsured1 CHAR(1)
DECLARE @InsuredRelationship1 VARCHAR(50)
DECLARE @HolderDifferentThanPatient1 BIT

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
DECLARE @InsuredParty2AddressLine2 VARCHAR(256)
DECLARE @InsuredParty2City VARCHAR(128)
DECLARE @InsuredParty2State VARCHAR(2)
DECLARE @InsuredParty2ZipCode VARCHAR(9)
DECLARE @InsuredParty2PolicyNumber VARCHAR(50)
DECLARE @InsuredParty2Gender CHAR(1)
DECLARE @InsuredParty2Phone VARCHAR(10)
DECLARE @InsuredParty2DOB DATETIME
DECLARE @InsuredParty2SSN Varchar(50)
DECLARE @InsuredParty2Employer VARCHAR(128)
DECLARE @PatientRelationshipToInsured2 CHAR(1)
DECLARE @InsuredRelationship2 VARCHAR(50)	
DECLARE @HolderDifferentThanPatient2 BIT

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
DECLARE @InsuredParty3AddressLine2 VARCHAR(256)
DECLARE @InsuredParty3City VARCHAR(128)
DECLARE @InsuredParty3State VARCHAR(2) 
DECLARE @InsuredParty3ZipCode VARCHAR(9)
DECLARE @InsuredParty3PolicyNumber VARCHAR(50)
DECLARE @InsuredParty3Gender CHAR(1)
DECLARE @InsuredParty3Phone VARCHAR
DECLARE @InsuredParty3DOB DATETIME
DECLARE @InsuredParty3SSN Varchar(50)
DECLARE @InsuredParty3Employer VARCHAR(128)
DECLARE @PatientRelationshipToInsured3 CHAR(1)
DECLARE @InsuredRelationship3 VARCHAR(50)
DECLARE @HolderDifferentThanPatient3 BIT	

-- For new patients create new 'Case 1', for existing: ignore (consider adding new cases later?)
-- HCP: For new patients use existing case id as VendorID and description as case name?
-- some patients in MWCas have more than one case
-- Create PatientCases for each new patient and insert InsurancePolicy data
-- Create temp patient table with all newely entered patients for this practice and importid

CREATE TABLE #P(PID INT IDENTITY(1,1), PatientID INT, VendorID VARCHAR(50), VendorImportID INT, PracticeID INT, RefPhysID INT) 		-- NEW PATIENTS ONLY 

INSERT INTO #P(PatientID, VendorID, VendorImportID, PracticeID, RefPhysID)		
SELECT PatientID, VendorID, VendorImportID, PracticeID, ReferringPhysicianID
FROM Patient
WHERE VendorID IS NOT NULL -- VendorID is ChartNumber
	AND VendorImportID=@VendorImportID
	AND PracticeID=@PracticeID

-- Create temp Guarantor table
--CREATE TABLE #G(GuarantorID, LastName, FirstName, MiddleInitial, Street1, Street2, City, State, ZipCode, Phone1, SSN, Gender, DOB)
--INSERT INTO #G(ChartNumber, LastName, FirstName, MiddleInitial, Street1, Street2, City, State, ZipCode, Phone1, SocialSecurity, Gender, DOB)
----SELECT ChartNumber, LastName, FirstName, MiddleInitial, Street1, Street2, City, State, ZipCode, Phone1, SocialSecurity, Gender, DOB
--FROM MWPAT g
--WHERE LTRIM(RTRIM(g.PatientType)) = 'Guarantor'
--INNER JOIN MWCAS c ON c.

-- select * from #P

SET @Loop=@@ROWCOUNT
PRINT @Loop
SET @Count=0

WHILE @Count<@Loop
BEGIN
	SET @Count=@Count+1

	--IF (@Count % 100) = 0  
	--BEGIN
	--	PRINT @Count
	--END

	SELECT @PatientID=PatientID, @PatientVendorID=VendorID, @RefPhysID=RefPhysID
	FROM #P
	WHERE PID=@Count

-- HCP: For each patient id select all cases from MWCAS and insert into a table #C, set row count 
-- and loop through the rows and insert each into patientcase wiht this patientid

	DECLARE @CASELOOP INT 
	DECLARE @CASECOUNT INT

	-- Create temp case table for this patient and drop at the end of this patient's loop; this table contains patient insurance info 1, 2 and 3 and plan code from MWCAS
	CREATE TABLE #C(CID INT IDENTITY(1,1), VendorID VARCHAR(50), VendorImportID INT, PracticeID INT, PatientID INT,
		ChartNumber VARCHAR(50), Description VARCHAR(50), Guarantor VARCHAR(50), 
		Insured1 VARCHAR(50), InsuredRelationship1 VARCHAR(50), InsuranceCarrier1 VARCHAR(50), 
		PolicyNumber1 VARCHAR(50), GroupNumber1 VARCHAR(50), Policy1StartDate VARCHAR(50), Policy1EndDate VARCHAR(50), 
		Insured2 VARCHAR(50), InsuredRelationship2 VARCHAR(50), InsuranceCarrier2 VARCHAR(50), 
		PolicyNumber2 VARCHAR(50), GroupNumber2 VARCHAR(50), Policy2StartDate VARCHAR(50), Policy2EndDate VARCHAR(50), 
		Insured3 VARCHAR(50), InsuredRelationship3 VARCHAR(50), InsuranceCarrier3 VARCHAR(50), 
		PolicyNumber3 VARCHAR(50), GroupNumber3 VARCHAR(50), Policy3StartDate VARCHAR(50), Policy3EndDate VARCHAR(50),
		RelatedToEmployment VARCHAR(50), RelatedToAccident VARCHAR(50), DateOfInjuryIllness VARCHAR(50), DateFirstConsulted VARCHAR(50),
		DateUnableToWorkFrom VARCHAR(50), DateUnableToWorkTo VARCHAR(50), DateTotDisabilityFrom VARCHAR(50), DateTotDisabilityTo VARCHAR(50),
		AccidentState VARCHAR(50), DateSimilarSymptoms VARCHAR(50), ReferringProvider VARCHAR(50), Notes VARCHAR(255))
	INSERT INTO #C(VendorID, VendorImportID, PracticeID, PatientID, ChartNumber, Description, Guarantor, 
		Insured1, InsuredRelationship1, InsuranceCarrier1, 
		PolicyNumber1, GroupNumber1, Policy1StartDate, Policy1EndDate, 
		Insured2, InsuredRelationship2, InsuranceCarrier2, 
		PolicyNumber2, GroupNumber2, Policy2StartDate, Policy2EndDate, 
		Insured3 , InsuredRelationship3, InsuranceCarrier3, 
		PolicyNumber3, GroupNumber3, Policy3StartDate, Policy3EndDate,
		RelatedToEmployment, RelatedToAccident, DateOfInjuryIllness, DateFirstConsulted,
		DateUnableToWorkFrom, DateUnableToWorkTo, DateTotDisabilityFrom, DateTotDisabilityTo,
		AccidentState, DateSimilarSymptoms, ReferringProvider, Notes)
	SELECT CaseNumber, @VendorImportID, @PracticeID, @PatientID, ChartNumber, Description, Guarantor, 
		Insured1, InsuredRelationship1, InsuranceCarrier1, 
		PolicyNumber1, GroupNumber1, Policy1StartDate, Policy1EndDate, 
		Insured2, InsuredRelationship2, InsuranceCarrier2, 
		PolicyNumber2, GroupNumber2, Policy2StartDate, Policy2EndDate, 
		Insured3 , InsuredRelationship3, InsuranceCarrier3, 
		PolicyNumber3, GroupNumber3, Policy3StartDate, Policy3EndDate,
		RelatedToEmployment, RelatedToAccident, DateOfInjuryIllness, DateFirstConsulted,
		DateUnableToWorkFrom, DateUnableToWorkTo, DateTotDisabilityFrom, DateTotDisabilityTo,
		AccidentState, DateSimilarSymptoms, ReferringProvider, Notes
	FROM HCPWS_MWCAS 
		WHERE ChartNumber = @PatientVendorID
	
	SET @CASELOOP=@@ROWCOUNT
	PRINT @CASELOOP
	SET @CASECOUNT=0

	WHILE @CASECOUNT<@CASELOOP
	 BEGIN
	   SET @CASECOUNT=@CASECOUNT+1
PRINT @CASECOUNT
	   INSERT INTO PatientCase(PatientID, Name, PracticeID, PayerScenarioID, VendorID, VendorImportID, ReferringPhysicianID,
		EmploymentRelatedFlag, AutoAccidentRelatedFlag, AutoAccidentRelatedState, Notes)
	   	SELECT @PatientID, Description, @PracticeID, 5, VendorID, @VendorImportID, @RefPhysID, 
  		CASE WHEN UPPER(LTRIM(RTRIM(RelatedToEmployment)))= 'TRUE' THEN 1 ELSE 0 END, 
 		CASE WHEN UPPER(LTRIM(RTRIM(RelatedToAccident))) = 'AUTO' THEN 1 ELSE 0 END, 
		AccidentState, Notes
	   FROM #C 
	   WHERE CID=@CASECOUNT

	   SET @NewPatientCaseID=@@IDENTITY
	
		SET @InsVendorID1=''
		SET @InsVendorID2=''
		SET @InsVendorID3=''

		SELECT @InsVendorID1=LTRIM(RTRIM(InsuranceCarrier1)), --InsuranceCarrier# in MWCAS and Code in MWINS
	       
	       		@InsVendorID2=LTRIM(RTRIM(InsuranceCarrier2)), 

	       		@InsVendorID3=LTRIM(RTRIM(InsuranceCarrier3))
	       
		FROM #C
		WHERE CID=@CASECOUNT
			
		--get insurance 1, 2 and 3 from #C
		--for each policy, if not null, find holder, insert into insurance policy
		--update patientscenario in patientcase if necessary (self insured)	
		
		IF @InsVendorID1 <> ''	-- Insurance Plan #1
			BEGIN
				SET @Ins1CompanyPlanID = NULL -- new
				SELECT @Ins1CompanyPlanID=InsuranceCompanyPlanID
				FROM InsuranceCompanyPlan
				WHERE VendorID=@InsVendorID1 AND VendorImportID = @VendorImportID -- NOTE: ONLY NEWLY ADDED PLANS ARE FOUND HERE, EXISTING ONES DO NOT HAVE VENDORID
												  -- GET THE EXISTING ONES FROM #EIP
		
				IF @Ins1CompanyPlanID IS NULL
				BEGIN
					SELECT @Ins1CompanyPlanID = InsuranceCompanyPlanID FROM #EIP WHERE Code = @InsVendorID1 -- EXISTING ID FOR THIS PLAN #
				END
		
				SELECT @Ins1Policy=PolicyNumber1,		
		       			@Ins1Group=GroupNumber1,		       			
					@Policy1StartDate=Policy1StartDate,
					@Policy1EndDate=Policy1EndDate,
					@InsuredParty1No=LTRIM(RTRIM(Insured1)),
					@InsuredRelationship1=LTRIM(RTRIM(InsuredRelationship1)),
					@ChartNumber = LTRIM(RTRIM(ChartNumber))
					--@InsuranceCarrier1
				FROM #C
				WHERE CID=@CASECOUNT
				--WHERE InsurancePlanNumber = @InsVendorID1
				--AND InsurancePolicyID=@PatientVendorID
		
		
				IF (@InsuredParty1No IS NOT NULL AND @InsuredParty1No <> '' AND @ChartNumber <> @InsuredParty1No) -- set PatientRelationshipToInsured to 'U'?, add insured party information from G#			
				   BEGIN 				-- select insurance holder information
					SELECT
					@InsuredParty1LastName=LastName,
					@InsuredParty1FirstName=FirstName,
					@InsuredParty1MiddleName=MiddleName,
					@InsuredParty1AddressLine1=Street1,
					@InsuredParty1AddressLine1=Street2,			
					@InsuredParty1City=City,
					@InsuredParty1State=State,
					@InsuredParty1ZipCode=ZipCode,
					--@InsuredParty1PolicyNumber=InsuredPartyPolicyNumber,
					@InsuredParty1Gender=Gender,
					@InsuredParty1Phone=HomePhone,
					@InsuredParty1DOB=DateOfBirth,
					@InsuredParty1SSN=SocialSecurityNumber,		
					--@InsuredParty1Employer=InsuredPartyEmployer
					@PatientRelationshipToInsured1=CASE WHEN UPPER(@InsuredRelationship1) = 'OTHER' THEN 'O'	-- other		
     									    WHEN UPPER(@InsuredRelationship1) = 'CHILD' THEN 'C' 	-- child
     				     					    WHEN UPPER(@InsuredRelationship1) = 'SPOUSE' THEN 'U'	-- spouse					
     									    --WHEN UPPER(@InsuredRelationship1) = 'SELF' THEN 'S'		-- self (should not happen here)		
     									    ELSE 'U' END  -- use 'U' ??
					--FROM #G
					FROM HCPWS_MWPAT				
					WHERE ChartNumber=@InsuredParty1No 		
		
					--SET @PatientRelationshipToInsured1 = 'U'	
					SET @HolderDifferentThanPatient1 = 1
				   END
				ELSE	-- set PatientRelationshipToInsured to 'S' in InsurancePolicy
				   BEGIN
				   	IF (@InsuredParty1No IS NOT NULL AND @InsuredParty1No <> '' AND @ChartNumber = @InsuredParty1No) -- patient self-insured
				   		BEGIN	
						SET @PatientRelationshipToInsured1 = 'S' 					
							-- reset Insured Party information to null
							SET @InsuredParty1LastName=NULL
							SET @InsuredParty1FirstName=NULL
							SET @InsuredParty1MiddleName=NULL
							SET @InsuredParty1AddressLine1=NULL
							SET @InsuredParty1AddressLine2=NULL
							SET @InsuredParty1City=NULL
							SET @InsuredParty1State=NULL
							SET @InsuredParty1ZipCode=NULL
							--SET @InsuredParty1PolicyNumber=NULL
							SET @InsuredParty1Gender=NULL
							SET @InsuredParty1Phone=NULL
							SET @InsuredParty1DOB=NULL
							SET @InsuredParty1SSN=NULL
							--SET @InsuredParty1Employer=NULL
						END
				   END		
		
				-- TODO: Syntax error converting the varchar value '103634A0' to a column of data type int.

				   INSERT INTO InsurancePolicy(
						PatientCaseID, PracticeID, InsuranceCompanyPlanID, PolicyNumber, GroupNumber, Precedence, 
						PolicyStartDate, PolicyEndDate, PatientRelationshipToInsured, 
						HolderLastName,
						HolderFirstName,
						HolderMiddleName,
						HolderAddressLine1,
						HolderAddressLine2,
						HolderCity,
						HolderState,
						HolderZipCode,
						--HolderPolicyNumber, --???
						HolderGender,
						HolderPhone,
						HolderDOB,
						HolderSSN,
						--HolderEmployerName,
						VendorID,
						VendorImportID
						)
						VALUES(
						@NewPatientCaseID, @PracticeID, @Ins1CompanyPlanID, @Ins1Policy, @Ins1Group, 1,  -- Precedence = 1
						@Policy1StartDate, @Policy1EndDate, @PatientRelationshipToInsured1, 
						@InsuredParty1LastName,										
						@InsuredParty1FirstName,
						@InsuredParty1MiddleName,
						@InsuredParty1AddressLine1,
						@InsuredParty1AddressLine2,
						@InsuredParty1City,
						@InsuredParty1State,
						@InsuredParty1ZipCode,
						--@InsuredParty1PolicyNumber,
						@InsuredParty1Gender,
						@InsuredParty1Phone,
						@InsuredParty1DOB,
						@InsuredParty1SSN,
						--@InsuredParty1Employer,
						@InsuredParty1No,
						@VendorImportID
						)
			END -- end if @InsVendorID1 <> ''

		IF @InsVendorID2 <> '' -- Insurance Plan #2
	
			BEGIN
				SET @Ins2CompanyPlanID = NULL -- new
				SELECT @Ins2CompanyPlanID=InsuranceCompanyPlanID
				FROM InsuranceCompanyPlan
				WHERE VendorID=@InsVendorID2 AND VendorImportID = @VendorImportID -- NOTE: ONLY NEWLY ADDED PLANS ARE FOUND HERE, EXISTING ONES DO NOT HAVE VENDORID
												  -- GET THE EXISTING ONES FROM #EIP
		
				IF @Ins2CompanyPlanID IS NULL
				BEGIN
					SELECT @Ins2CompanyPlanID = InsuranceCompanyPlanID FROM #EIP WHERE Code = @InsVendorID2 -- EXISTING ID FOR THIS PLAN #
				END
		
				SELECT @Ins2Policy=PolicyNumber2,		
		       			@Ins2Group=GroupNumber2,		       			
					@Policy2StartDate=Policy2StartDate,
					@Policy2EndDate=Policy2EndDate,
					@InsuredParty2No=LTRIM(RTRIM(Insured2)),
					@InsuredRelationship2=LTRIM(RTRIM(InsuredRelationship2)),
					@ChartNumber = LTRIM(RTRIM(ChartNumber))
					--@InsuranceCarrier1
				FROM #C
				WHERE CID=@CASECOUNT	
		
				IF (@InsuredParty2No IS NOT NULL AND @InsuredParty2No <> '' AND @ChartNumber <> @InsuredParty2No) -- set PatientRelationshipToInsured to 'U'?, add insured party information from G#			
				   BEGIN 				-- select insurance holder information
					SELECT
					@InsuredParty2LastName=LastName,
					@InsuredParty2FirstName=FirstName,
					@InsuredParty2MiddleName=MiddleName,
					@InsuredParty2AddressLine1=Street1,
					@InsuredParty2AddressLine1=Street2,			
					@InsuredParty2City=City,
					@InsuredParty2State=State,
					@InsuredParty2ZipCode=ZipCode,
					--@InsuredParty1PolicyNumber=InsuredPartyPolicyNumber,
					@InsuredParty2Gender=Gender,
					@InsuredParty2Phone=HomePhone,
					@InsuredParty2DOB=DateOfBirth,
					@InsuredParty2SSN=SocialSecurityNumber,		
					--@InsuredParty1Employer=InsuredPartyEmployer
					@PatientRelationshipToInsured2=CASE WHEN UPPER(@InsuredRelationship2) = 'OTHER' THEN 'O'	-- other		
     									    WHEN UPPER(@InsuredRelationship2) = 'CHILD' THEN 'C' 	-- child
     				     					    WHEN UPPER(@InsuredRelationship2) = 'SPOUSE' THEN 'U'	-- spouse					
     									    --WHEN UPPER(@InsuredRelationship2) = 'SELF' THEN 'S'		-- self (should not happen here)		
     									    ELSE 'U' END  -- use 'U' ??
					--FROM #G

					FROM HCPWS_MWPAT
					WHERE ChartNumber=@InsuredParty2No
							
		
					--SET @PatientRelationshipToInsured1 = 'U'	
					SET @HolderDifferentThanPatient2 = 1
				   END
				ELSE	-- set PatientRelationshipToInsured to 'S' in InsurancePolicy
				   BEGIN
				   	IF (@InsuredParty2No IS NOT NULL AND @InsuredParty1No <> '' AND @ChartNumber = @InsuredParty1No) -- patient self-insured
				   		BEGIN	
						SET @PatientRelationshipToInsured2 = 'S' 					
							-- reset Insured Party information to null
							SET @InsuredParty2LastName=NULL
							SET @InsuredParty2FirstName=NULL
							SET @InsuredParty2MiddleName=NULL
							SET @InsuredParty2AddressLine1=NULL
							SET @InsuredParty2AddressLine2=NULL
							SET @InsuredParty2City=NULL
							SET @InsuredParty2State=NULL
							SET @InsuredParty2ZipCode=NULL
							--SET @InsuredParty2PolicyNumber=NULL
							SET @InsuredParty2Gender=NULL
							SET @InsuredParty2Phone=NULL
							SET @InsuredParty2DOB=NULL
							SET @InsuredParty2SSN=NULL
							--SET @InsuredParty2Employer=NULL
						END
				   END	
		
				
				   INSERT INTO InsurancePolicy(
						PatientCaseID, PracticeID, InsuranceCompanyPlanID, PolicyNumber, GroupNumber, Precedence, 
						PolicyStartDate, PolicyEndDate, PatientRelationshipToInsured, 
						HolderLastName,
						HolderFirstName,
						HolderMiddleName,
						HolderAddressLine1,
						HolderAddressLine2,
						HolderCity,
						HolderState,
						HolderZipCode,
						--HolderPolicyNumber, --???
						HolderGender,
						HolderPhone,
						HolderDOB,
						HolderSSN,
						--HolderEmployerName,
						VendorID,
						VendorImportID
						)
						VALUES(
						@NewPatientCaseID, @PracticeID, @Ins2CompanyPlanID, @Ins2Policy, @Ins2Group, 2,  -- Precedence = 2
						@Policy2StartDate, @Policy2EndDate, @PatientRelationshipToInsured2, 
						@InsuredParty2LastName,										
						@InsuredParty2FirstName,
						@InsuredParty2MiddleName,
						@InsuredParty2AddressLine1,
						@InsuredParty2AddressLine2,
						@InsuredParty2City,
						@InsuredParty2State,
						@InsuredParty2ZipCode,
						--@InsuredParty1PolicyNumber,
						@InsuredParty2Gender,
						@InsuredParty2Phone,
						@InsuredParty2DOB,
						@InsuredParty2SSN,
						--@InsuredParty1Employer,
						@InsuredParty2No,
						@VendorImportID
						)
			END -- end if @InsVendorID2 <> ''

		IF @InsVendorID3 <> '' -- Insurance Plan #3
			BEGIN
				SET @Ins3CompanyPlanID = NULL -- new
				SELECT @Ins3CompanyPlanID=InsuranceCompanyPlanID
				FROM InsuranceCompanyPlan
				WHERE VendorID=@InsVendorID3 AND VendorImportID = @VendorImportID -- NOTE: ONLY NEWLY ADDED PLANS ARE FOUND HERE, EXISTING ONES DO NOT HAVE VENDORID
												  -- GET THE EXISTING ONES FROM #EIP
		
				IF @Ins3CompanyPlanID IS NULL
				BEGIN
					SELECT @Ins3CompanyPlanID = InsuranceCompanyPlanID FROM #EIP WHERE Code = @InsVendorID3 -- EXISTING ID FOR THIS PLAN #
				END
		
				SELECT @Ins3Policy=PolicyNumber3,		
		       			@Ins3Group=GroupNumber3,		       			
					@Policy3StartDate=Policy3StartDate,
					@Policy3EndDate=Policy3EndDate,
					@InsuredParty3No=LTRIM(RTRIM(Insured3)),
					@InsuredRelationship3=LTRIM(RTRIM(InsuredRelationship3)),
					@ChartNumber = LTRIM(RTRIM(ChartNumber))
					--@InsuranceCarrier1
				FROM #C
				WHERE CID=@CASECOUNT
				--WHERE InsurancePlanNumber = @InsVendorID1
				--AND InsurancePolicyID=@PatientVendorID
		
		
				IF (@InsuredParty3No IS NOT NULL AND @InsuredParty1No <> '' AND @ChartNumber <> @InsuredParty3No) -- set PatientRelationshipToInsured to 'U'?, add insured party information from G#			
				   BEGIN 				-- select insurance holder information
					SELECT
					@InsuredParty3LastName=LastName,
					@InsuredParty3FirstName=FirstName,
					@InsuredParty3MiddleName=MiddleName,
					@InsuredParty3AddressLine1=Street1,
					@InsuredParty3AddressLine1=Street2,			
					@InsuredParty3City=City,
					@InsuredParty3State=State,
					@InsuredParty3ZipCode=ZipCode,
					--@InsuredParty3PolicyNumber=InsuredPartyPolicyNumber,
					@InsuredParty3Gender=Gender,
					@InsuredParty3Phone=HomePhone,
					@InsuredParty3DOB=DateOfBirth,
					@InsuredParty3SSN=SocialSecurityNumber,		
					--@InsuredParty1Employer=InsuredPartyEmployer
					@PatientRelationshipToInsured3=CASE WHEN UPPER(@InsuredRelationship3) = 'OTHER' THEN 'O'	-- other		
     									    WHEN UPPER(@InsuredRelationship3) = 'CHILD' THEN 'C' 	-- child
     				     					    WHEN UPPER(@InsuredRelationship3) = 'SPOUSE' THEN 'U'	-- spouse					
     									    --WHEN UPPER(@InsuredRelationship3) = 'SELF' THEN 'S'		-- self (should not happen here)		
     									    ELSE 'U' END  -- use 'U' ??
	
					FROM HCPWS_MWPAT
					WHERE ChartNumber=@InsuredParty3No 		
		
					--SET @PatientRelationshipToInsured3 = 'U'	
					SET @HolderDifferentThanPatient3 = 1
				   END
				ELSE	-- set PatientRelationshipToInsured to 'S' in InsurancePolicy
				   BEGIN
				   	IF (@InsuredParty3No IS NOT NULL AND @InsuredParty3No <> '' AND @ChartNumber = @InsuredParty3No) -- patient self-insured
				   		BEGIN	
						SET @PatientRelationshipToInsured3 = 'S' 					
							-- reset Insured Party information to null
							SET @InsuredParty3LastName=NULL
							SET @InsuredParty3FirstName=NULL
							SET @InsuredParty3MiddleName=NULL
							SET @InsuredParty3AddressLine1=NULL
							SET @InsuredParty3AddressLine2=NULL
							SET @InsuredParty3City=NULL
							SET @InsuredParty3State=NULL
							SET @InsuredParty3ZipCode=NULL
							--SET @InsuredParty1PolicyNumber=NULL
							SET @InsuredParty3Gender=NULL
							SET @InsuredParty3Phone=NULL
							SET @InsuredParty3DOB=NULL
							SET @InsuredParty3SSN=NULL
							--SET @InsuredParty3Employer=NULL
						END
				   END	
				
				   INSERT INTO InsurancePolicy(
						PatientCaseID, PracticeID, InsuranceCompanyPlanID, PolicyNumber, GroupNumber, Precedence, 
						PolicyStartDate, PolicyEndDate, PatientRelationshipToInsured, 
						HolderLastName,
						HolderFirstName,
						HolderMiddleName,
						HolderAddressLine1,
						HolderAddressLine2,
						HolderCity,
						HolderState,
						HolderZipCode,
						--HolderPolicyNumber, --???
						HolderGender,
						HolderPhone,
						HolderDOB,
						HolderSSN,
						--HolderEmployerName,
						VendorID,
						VendorImportID
						)
						VALUES(
						@NewPatientCaseID, @PracticeID, @Ins3CompanyPlanID, @Ins3Policy, @Ins3Group, 3,  -- Precedence = 3
						@Policy3StartDate, @Policy3EndDate, @PatientRelationshipToInsured3, 
						@InsuredParty3LastName,										
						@InsuredParty3FirstName,
						@InsuredParty3MiddleName,
						@InsuredParty3AddressLine1,
						@InsuredParty3AddressLine2,
						@InsuredParty3City,
						@InsuredParty3State,
						@InsuredParty3ZipCode,
						--@InsuredParty3PolicyNumber,
						@InsuredParty3Gender,
						@InsuredParty3Phone,
						@InsuredParty3DOB,
						@InsuredParty3SSN,
						--@InsuredParty1Employer,
						@InsuredParty3No,
						@VendorImportID
						)
			END -- end if @InsVendorID3 <> ''


		IF (@InsVendorID1 = '' OR @InsVendorID1 IS NULL) AND (@InsVendorID2 = '' OR @InsVendorID2 IS NULL) AND (@InsVendorID3 = '' OR @InsVendorID3 IS NULL)
			BEGIN
				UPDATE PatientCase SET PayerScenarioID = 11 WHERE PatientCaseID = @NewPatientCaseID		-- 'Self Pay'
			END	

	END -- END WHILE @CASECOUNT<@CASELOOP

 	DROP TABLE #C

END -- end of patient loop


DROP TABLE #P
DROP TABLE #PG
DROP TABLE #EIC
DROP TABLE #NIC
DROP TABLE #EIP
DROP TABLE #NIP


-- ROLLBACK
-- COMMIT

--SELECT * FROM VENDORIMPORT
--SELECT * FROM PATIENT WHERE VENDORID = '00000008'
--SELECT * FROM PATIENTCASE WHERE PATIENTID = 9
--SELECT * FROM INSURANCEPOLICY WHERE PATIENTCASEID IN (11, 12, 13, 14)
--SELECT * FROM PATIENT WHERE VENDORID = '00000088'
--SELECT * FROM PATIENTCASE WHERE PATIENTID = 87
--SELECT * FROM INSURANCEPOLICY WHERE PATIENTCASEID = 156