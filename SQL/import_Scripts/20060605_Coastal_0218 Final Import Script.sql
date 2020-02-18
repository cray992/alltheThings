--06052006 kdev01_0218 HCPlus - New Coastal EMS import script (test) - includes Facilities imported as referring physicians; removes patient records with multiple guarantors; imports all patientcases
-- PracticeID = 31
-- VendorImportID = ? -- 

--select * from doctor where practiceid = 31 -- Coastal
BEGIN TRANSACTION

DECLARE @PracticeID int
DECLARE @VendorImportID int

INSERT INTO VendorImport (VendorName, Notes, VendorFormat) VALUES ('Coastal EMS', 'Final Import - Patients, Ref.Ph., Facil. & Ins.', 'MediSoft')

SET @VendorImportID = @@IDENTITY
SET @PracticeID = 31 -- Coastal EMS

/*
INSERT INTO Doctor (PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, Degree, SSN, --TaxonomyCode, 		
	    WorkPhone, FaxNumber, AddressLine1, AddressLine2, City, State, ZipCode, VendorID, VendorImportID, [External])
SELECT @PracticeID, '', 
	CASE WHEN FirstName IS NOT NULL THEN LTRIM(RTRIM(FirstName)) ELSE '' END,
	CASE WHEN MiddleInitial IS NOT NULL THEN LTRIM(RTRIM(MiddleInitial)) ELSE '' END,
	CASE WHEN LastName IS NOT NULL THEN LTRIM(RTRIM(LastName)) ELSE '' END, '',
	CASE WHEN Credentials IS NOT NULL THEN LTRIM(RTRIM(Credentials)) ELSE '' END,
	--CASE WHEN UPIN IS NOT NULL THEN LTRIM(RTRIM(UPIN)) ELSE '' END,
	CASE WHEN SSNOrFedTaxID IS NOT NULL THEN LTRIM(RTRIM(SSNOrFedTaxID)) ELSE '' END,
	--CASE WHEN TaxonomyCode IS NOT NULL THEN LTRIM(RTRIM(TaxonomyCode)) ELSE NULL END,
	CASE WHEN Phone IS NOT NULL THEN LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(Phone, '-', ''), '(', ''), ')', ''))) ELSE '' END,
	CASE WHEN Fax IS NOT NULL THEN LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(Fax, '-', ''), '(', ''), ')', ''))) ELSE '' END,
	CASE WHEN Street1 IS NULL THEN '' ELSE LTRIM(RTRIM(Street1)) END,
	CASE WHEN Street2 IS NULL THEN '' ELSE LTRIM(RTRIM(Street2)) END,
	CASE WHEN City IS NULL THEN '' ELSE LTRIM(RTRIM(City)) END,
	CASE WHEN State IS NULL THEN '' ELSE LTRIM(RTRIM(State)) END,
	CASE WHEN ZipCode IS NULL THEN '' ELSE LTRIM(RTRIM(REPLACE(ZipCode,'-',''))) END,
	CASE WHEN Code IS NULL THEN '' ELSE LTRIM(RTRIM(Code)) END,
	@VendorImportID,
	0
FROM Coastal_MWPHY
ORDER BY Code
*/

-- ReferringPhysician		
-- MWRPH

INSERT INTO Doctor (PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, Degree, SSN, --TaxonomyCode, 
	    WorkPhone, FaxNumber, AddressLine1, AddressLine2, City, State, ZipCode, VendorID, VendorImportID, [External])
SELECT @PracticeID, '', 
	CASE WHEN FirstName IS NOT NULL THEN LTRIM(RTRIM(FirstName)) ELSE '' END,
	CASE WHEN MiddleInitial IS NOT NULL THEN LTRIM(RTRIM(MiddleInitial)) ELSE '' END,
	CASE WHEN LastName IS NOT NULL THEN LTRIM(RTRIM(LastName)) ELSE '' END, '',
	CASE WHEN Credentials IS NOT NULL THEN LTRIM(RTRIM(Credentials)) ELSE '' END,
	--CASE WHEN UPIN IS NOT NULL THEN LTRIM(RTRIM(UPIN)) ELSE '' END,
	CASE WHEN SSNOrFedTaxID IS NOT NULL THEN LTRIM(RTRIM(SSNOrFedTaxID)) ELSE '' END,
	--CASE WHEN TaxonomyCode IS NOT NULL THEN LTRIM(RTRIM(TaxonomyCode)) ELSE NULL END,
	CASE WHEN Phone IS NOT NULL THEN LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(Phone, '-', ''), '(', ''), ')', ''))) ELSE '' END,
	CASE WHEN Fax IS NOT NULL THEN LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(Fax, '-', ''), '(', ''), ')', ''))) ELSE '' END,
	CASE WHEN Street1 IS NULL THEN '' ELSE LTRIM(RTRIM(Street1)) END,
	CASE WHEN Street2 IS NULL THEN '' ELSE LTRIM(RTRIM(Street2)) END,
	CASE WHEN City IS NULL THEN '' ELSE LTRIM(RTRIM(City)) END,
	CASE WHEN State IS NULL THEN '' ELSE LTRIM(RTRIM(State)) END,
	CASE WHEN ZipCode IS NULL THEN '' ELSE LEFT(LTRIM(RTRIM(REPLACE(ZipCode,'-',''))), 9) END,
	CASE WHEN Code IS NULL THEN '' ELSE LTRIM(RTRIM(Code)) END,
	@VendorImportID, 1
FROM Coastal_MWRPH
ORDER BY Code

-- Insert UPIN for Referring Physicians -- TODO in final data import

INSERT INTO ProviderNumber(DoctorID, ProviderNumberTypeID, ProviderNumber, AttachConditionsTypeID)
SELECT DoctorID, 25, LTRIM(RTRIM(rph.UPIN)), 1
FROM Doctor D INNER JOIN Coastal_mwrph rph
ON D.VendorImportID=@VendorImportID AND D.VendorID=LTRIM(RTRIM(rph.Code))
WHERE D.PracticeID=@PracticeID 
	AND rph.UPIN IS NOT NULL 
	AND LEN(LTRIM(RTRIM(rph.UPIN))) > 0
	AND [External] = 1

-- Import Facilities as referring physicians
-- MWADD

INSERT INTO Doctor (PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, Degree, SSN, --TaxonomyCode, 
	    WorkPhone, WorkPhoneExt, FaxNumber, AddressLine1, AddressLine2, City, State, ZipCode, Notes, VendorID, VendorImportID, [External])
SELECT @PracticeID, '', '', '',
	CASE WHEN [Name] IS NOT NULL THEN LTRIM(RTRIM([Name])) ELSE '' END, '', '', '',
	CASE WHEN Phone IS NOT NULL THEN LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(Phone, '-', ''), '(', ''), ')', ''), ' ', ''))) ELSE '' END,
	CASE WHEN Extension IS NULL THEN '' ELSE LEFT(LTRIM(RTRIM(Extension)), 10) END,
	CASE WHEN Fax IS NOT NULL THEN LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(Fax, '-', ''), '(', ''), ')', ''), ' ', ''))) ELSE '' END,
	CASE WHEN Street1 IS NULL THEN '' ELSE LTRIM(RTRIM(Street1)) END,
	CASE WHEN Street2 IS NULL THEN '' ELSE LTRIM(RTRIM(Street2)) END,
	CASE WHEN City IS NULL THEN '' ELSE LTRIM(RTRIM(City)) END,
	CASE WHEN State IS NULL THEN '' ELSE LTRIM(RTRIM(State)) END,
	CASE WHEN ZipCode IS NULL THEN '' ELSE LEFT(LTRIM(RTRIM(REPLACE(ZipCode,'-',''))), 9) END,
	CASE WHEN Code IS NULL THEN '' ELSE LTRIM(RTRIM(Contact)) END,
	CASE WHEN Contact IS NULL THEN '' ELSE LTRIM(RTRIM(Code)) END,
	@VendorImportID, 1
FROM Coastal_MWADD
WHERE LTRIM(RTRIM(Type)) = 'Facility' 
ORDER BY Code

-- Patient (note: the same ssn can correspond to more than 1 PatientID, if patient used more than one practice)
-- Insert patients excluding Guarantor (where Patient Type <> 'Guarantor'
--Create table with Patients and their Guarantors
CREATE TABLE #PG (PatientChartNumber varchar(50), GuarantorChartNumber varchar(50),ResponsibleDifferentThanPatient BIT, ResponsibleFirstName varchar(50), 
ResponsibleMiddleName varchar(50), ResponsibleLastName varchar(50), ResponsibleAddressLine1 varchar(50), ResponsibleAddressLine2 varchar(50), 
ResponsibleCity varchar(50), ResponsibleState varchar(50), ResponsibleZipCode varchar(50), ResponsibleRelationsipToPatient varchar(50), CaseNumber varchar(50))

INSERT INTO #PG (PatientChartNumber, GuarantorChartNumber, ResponsibleDifferentThanPatient, ResponsibleFirstName, ResponsibleMiddleName, 
	ResponsibleLastName, ResponsibleAddressLine1, ResponsibleAddressLine2, 
	ResponsibleCity, ResponsibleState, ResponsibleZipCode, ResponsibleRelationsipToPatient, CaseNumber)
SELECT DISTINCT LTRIM(RTRIM(cas.ChartNumber)), LTRIM(RTRIM(cas.Guarantor)), 1, 
	LTRIM(RTRIM(pat.FirstName)), 
	CASE WHEN (pat.MiddleName IS NULL) THEN '' ELSE LTRIM(RTRIM(pat.MiddleName)) END,
	LTRIM(RTRIM(pat.LastName)), 
	CASE WHEN pat.Street1 IS NULL THEN '' ELSE LTRIM(RTRIM(pat.Street1)) END, 
	CASE WHEN pat.Street2 IS NULL THEN '' ELSE LTRIM(RTRIM(pat.Street2)) END,
	CASE WHEN pat.City IS NULL THEN '' ELSE LTRIM(RTRIM(pat.City)) END, 
	CASE WHEN pat.State IS NULL THEN '' ELSE LTRIM(RTRIM(pat.State)) END, 
	CASE WHEN pat.ZipCode IS NULL THEN '' ELSE LTRIM(RTRIM(REPLACE(ZipCode,'-',''))) END, 'U', cas.CaseNumber
FROM Coastal_MWPAT pat
INNER JOIN Coastal_MWCAS cas ON cas.Guarantor = pat.ChartNumber
WHERE cas.ChartNumber <> cas.Guarantor

-- Delete duplicate patients with guarantors; use guarantor listed for the most recent case

DELETE FROM #PG
WHERE EXISTS
	(SELECT * FROM #PG AS pg
	WHERE pg.PatientChartNumber= #PG.PatientChartNumber
	AND CAST(pg.CaseNumber AS INT) > CAST(#PG.CaseNumber AS INT))

INSERT INTO Patient(VendorImportID, VendorID, PracticeID,  
	Prefix, FirstName, MiddleName, LastName, Suffix,
	AddressLine1, AddressLine2, City, State, ZipCode, Gender, MaritalStatus,
	HomePhone, WorkPhone, WorkPhoneExt,DOB, SSN, ResponsibleDifferentThanPatient, 
	ResponsibleFirstName, ResponsibleMiddleName, ResponsibleLastName, ResponsibleAddressLine1, 
	ResponsibleAddressLine2, ResponsibleCity, ResponsibleState, ResponsibleZipCode, PrimaryProviderID, MobilePhone)
SELECT  @VendorImportID, pat.ChartNumber, @PracticeID, 		-- pg.PatientChartNumber, pg.GuarantorChartNumber, 
	'', CASE WHEN pat.FirstName IS NULL THEN '' ELSE LTRIM(RTRIM(pat.FirstName)) END, 
	CASE WHEN pat.MiddleName IS NULL THEN '' ELSE LTRIM(RTRIM(pat.MiddleName)) END,
	CASE WHEN pat.LastName IS NULL THEN '' ELSE LTRIM(RTRIM(pat.LastName)) END, '',
	CASE WHEN pat.Street1 IS NULL THEN '' ELSE LTRIM(RTRIM(pat.Street1)) END, 
	CASE WHEN pat.Street2 IS NULL THEN '' ELSE LTRIM(RTRIM(pat.Street2)) END, 
	CASE WHEN pat.City IS NOT NULL THEN LTRIM(RTRIM(pat.City)) ELSE '' END, 
	CASE WHEN pat.State IS NOT NULL AND LEN(LTRIM(RTRIM(pat.State))) < 3 THEN LTRIM(RTRIM(pat.State)) ELSE NULL END, 
	CASE WHEN pat.ZipCode IS NOT NULL AND LTRIM(RTRIM(pat.ZipCode)) <> '' THEN LEFT(LTRIM(RTRIM(REPLACE(ZipCode,'-',''))), 9) ELSE NULL END, 
	CASE WHEN LTRIM(RTRIM(pat.Gender)) = 'Male' THEN 'M'
     		WHEN LTRIM(RTRIM(pat.Gender)) = 'Female' THEN 'F'
     		ELSE 'U' END,
	'U', -- MariatalStatus not available in patients table
	CASE WHEN pat.Phone1 IS NOT NULL AND LTRIM(RTRIM(pat.Phone1)) <> '' THEN LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.Phone1, '-', ''), '(', ''), ')', ''))), 10) ELSE '' END, 
	CASE WHEN pat.WorkPhone IS NOT NULL AND LTRIM(RTRIM(pat.WorkPhone)) <> '' THEN LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.WorkPhone, '-', ''), '(', ''), ')', ''))), 10) ELSE '' END, 
	CASE WHEN pat.WorkExtension IS NOT NULL AND LTRIM(RTRIM(pat.WorkExtension)) <> '' THEN LEFT(LTRIM(RTRIM(pat.WorkExtension)), 10) END,
	CASE WHEN (pat.DateOfBirth IS NOT NULL AND LTRIM(RTRIM(pat.DateOfBirth)) <> '' AND ISDATE(LTRIM(RTRIM(pat.DateOfBirth))) = 1) THEN CAST(LTRIM(RTRIM(pat.DateOfBirth)) AS DATETIME) ELSE NULL END, 
	CASE WHEN (pat.SocialSecurityNumber IS NOT NULL AND LTRIM(RTRIM(pat.SocialSecurityNumber)) <> '') THEN LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.SocialSecurityNumber, '-', ''), '+', ''), '/', ''))), 9) ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN 1 ELSE 0 END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN pg.ResponsibleFirstName ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN pg.ResponsibleMiddleName ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN pg.ResponsibleLastName ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN pg.ResponsibleAddressLine1 ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN pg.ResponsibleAddressLine2 ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN pg.ResponsibleCity ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL THEN pg.ResponsibleState ELSE NULL END,
	CASE WHEN pg.PatientChartNumber IS NOT NULL AND LTRIM(RTRIM(pg.PatientChartNumber)) <> '' THEN LEFT(pg.ResponsibleZipCode, 9) ELSE NULL END, NULL,
	CASE WHEN pat.Phone2 IS NOT NULL AND LTRIM(RTRIM(pat.Phone2)) <> '' THEN LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.Phone2, '-', ''), '(', ''), ')', ''))), 10) ELSE '' END  
FROM Coastal_MWPAT pat
LEFT JOIN #PG pg ON pat.ChartNumber = pg.PatientChartNumber
WHERE UPPER(LTRIM(RTRIM(pat.PatientType))) <> 'Guarantor'


DECLARE @RefToPatient TABLE(ChartNumber VARCHAR(50), ReferringProvider VARCHAR(50))
INSERT @RefToPatient(ChartNumber, ReferringProvider)
SELECT DISTINCT ChartNumber, ReferringProvider
FROM Coastal_MWCAS
WHERE LEN(ReferringProvider)>0

UPDATE P SET ReferringPhysicianID=D.DoctorID
FROM Patient P INNER JOIN @RefToPatient RTP
ON P.VendorImportID=@VendorImportID AND P.VendorID=RTP.ChartNumber
INNER JOIN Doctor D
ON D.VendorImportID=@VendorImportID AND RTP.ReferringProvider=D.VendorID

-- InsuranceCompany
-- MWINS - Assume that insurance company is the same as insuranceplan 
-- Create temporary table to hold insurance companies that already exist in InsuranceCompany table
CREATE TABLE #EIC (InsuranceCompanyID int, InsuranceCompanyName varchar(255), AddressLine1 varchar(255), AddressLine2 varchar(255), City varchar(255),
State varchar(255), ZipCode varchar(255), Phone varchar(255), PhoneExt varchar(255), ReviewCode varchar(255), Code varchar(255))

INSERT INTO #EIC (InsuranceCompanyID, InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt, ReviewCode, Code)
SELECT MAX(ico.InsuranceCompanyID) InsuranceCompanyID, ic.Name, ic.Street1, ic.Street2, ic.City, ic.State, ic.ZipCode, ic.Phone, ic.Extension, ico.ReviewCode, ic.Code
FROM Coastal_MWINS ic
JOIN InsuranceCompany ico
ON LTRIM(RTRIM(ico.InsuranceCompanyName)) = LTRIM(RTRIM(ic.Name))
WHERE
	LTRIM(RTRIM(ico.City)) = LTRIM(RTRIM(ic.City))
	AND LEFT(ico.ZipCode, 5) = LEFT(ic.ZipCode, 5) 
	AND LTRIM(RTRIM(ico.State)) = LTRIM(RTRIM(ic.State))
	AND LTRIM(RTRIM(ico.InsuranceCompanyName)) = LTRIM(RTRIM(ic.Name))
	AND REPLACE(REPLACE(ico.AddressLine1, ' ', ''), '.', '') = REPLACE(REPLACE(ic.Street1, ' ', ''), '.', '')
GROUP BY ic.Name, ic.Street1, ic.Street2, ic.City, ic.State, ic.ZipCode, ic.Phone, ic.Extension, ico.ReviewCode, ic.Code

-- Store insurance companies that do not exist in InsuranceCompany table in another temporary table #NIC
CREATE TABLE #NIC (Code varchar(255), InsuranceCompanyName varchar(255), AddressLine1 varchar(255), AddressLine2 varchar(255), City varchar(255),
State varchar(255), ZipCode varchar(255), Phone varchar(255), PhoneExt varchar(255), ReviewCode varchar(255))

INSERT INTO #NIC (Code, InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt, ReviewCode)
SELECT ic.Code, ic.Name, ic.Street1, ic.Street2, ic.City, ic.State, ic.ZipCode, ic.Phone, ic.Extension, 'R'
FROM Coastal_MWINS ic
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
	CASE WHEN ZipCode IS NOT NULL AND LTRIM(RTRIM(ZipCode)) <> '' THEN LEFT(LTRIM(RTRIM(REPLACE(REPLACE(ZipCode,'-',''), ' ', ''))), 9) ELSE NULL END, 
	CASE WHEN Phone IS NOT NULL AND LTRIM(RTRIM(Phone)) <> '' THEN LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Phone,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10) ELSE NULL END,
	CASE WHEN PhoneExt IS NULL THEN '' ELSE LTRIM(RTRIM(LEFT(PhoneExt, 10))) END, 'R' 
FROM #NIC	

--select count(*) from #NIC
-- rollback	

-- InsuranceCompanyPlan
-- Insert plans that do not already exist  in InsuranceCompanyPlan

-- 1) find which ones exist;  Code - same as InsuranceCarrier #1, #2 and 3# in MWCAS)
-- Existing InsuranceCompanyPlans
CREATE TABLE #EIP (InsuranceCompanyPlanID int, Code varchar(255), PlanName varchar(255), AddressLine1 varchar(255), AddressLine2 varchar(255),
City varchar(255), State varchar(255), ZipCode varchar(255), Phone varchar(255), PhoneExt varchar(255))

INSERT INTO #EIP			-- Insert plans that already exist in InsuranceCompanyPlan table
(InsuranceCompanyPlanID, Code, PlanName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt)
SELECT MAX(icp.InsuranceCompanyPlanID) InsuranceCompanyPlanID, 
	LTRIM(RTRIM(ip.Code)), 
	LTRIM(RTRIM(ip.Name)), 
	LTRIM(RTRIM(ip.Street1)), 
	LTRIM(RTRIM(ip.Street2)), 
	LTRIM(RTRIM(ip.City)), 
	LEFT(LTRIM(RTRIM(ip.State)), 2), 
	LTRIM(RTRIM(REPLACE(ip.ZipCode,'-',''))), 
	LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Phone,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10))),
	LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Extension,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10))) 
FROM Coastal_MWINS ip
JOIN InsuranceCompanyPlan icp ON LTRIM(RTRIM(icp.PlanName)) = LTRIM(RTRIM(ip.Name))
	WHERE LTRIM(RTRIM(icp.City)) = LTRIM(RTRIM(ip.City))
	AND LTRIM(RTRIM(icp.State)) = LTRIM(RTRIM(ip.State))
	AND LEFT(icp.ZipCode, 5) = LEFT(ip.ZipCode, 5) 
	AND LTRIM(RTRIM(icp.PlanName)) = LTRIM(RTRIM(ip.Name))
	AND REPLACE(REPLACE(icp.AddressLine1, ' ', ''), '.', '') = REPLACE(REPLACE(ip.Street1, ' ', ''), '.', '')
GROUP BY 	LTRIM(RTRIM(ip.Code)), 
	LTRIM(RTRIM(ip.Name)), 
	LTRIM(RTRIM(ip.Street1)), 
	LTRIM(RTRIM(ip.Street2)), 
	LTRIM(RTRIM(ip.City)), 
	LEFT(LTRIM(RTRIM(ip.State)), 2), 
	LTRIM(RTRIM(REPLACE(ip.ZipCode,'-',''))), 
	LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Phone,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10))),
	LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Extension,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10))) 

--select * from #EIP where code='1'

-- Create temporary table with plans that do not exist in InsuranceCompanyPlan table

CREATE TABLE #NIP (Code varchar(255), PlanName varchar(255), 
InsuranceCompanyID int, AddressLine1 varchar(255), AddressLine2 varchar(255), 
City varchar(255), State varchar(255), ZipCode varchar(255), Phone varchar(255), PhoneExt varchar(255))

INSERT INTO #NIP			-- Insert plans that do not already exist in InsuranceCompanyPlan table
(Code, PlanName, InsuranceCompanyID, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt)
SELECT LTRIM(RTRIM(ip.Code)), 
	LTRIM(RTRIM(ip.Name)),
	LTRIM(RTRIM(ISNULL(eic.InsuranceCompanyID,ic.InsuranceCompanyID))), 
	LTRIM(RTRIM(ip.Street1)), 
	LTRIM(RTRIM(ip.Street2)), 
	LTRIM(RTRIM(ip.City)), 
	LTRIM(RTRIM(ip.State)), 
	LTRIM(RTRIM(REPLACE(ip.ZipCode,'-',''))),
	LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Phone,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10))), 
	LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Extension,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10))) 
FROM Coastal_MWINS ip 
LEFT JOIN InsuranceCompany ic
on ic.VendorImportID=@VendorImportID and ip.Code=ic.VendorID
LEFT JOIN #EIC eic
on ip.code=eic.Code
WHERE ip.Code NOT IN (SELECT Code FROM #EIP)
ORDER BY ip.Name

--select * from #NIP where code='1'
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

-- Insurance plans that did not exist will have VendorImportID for this import and and VendorID = MWINS.Code
-- for those that did exist, match InsuranceCompanyPlanID from #EIP 
-- select InsuranceCompanyPlanID from #EIP 

INSERT INTO PatientCase(PatientID, Name, PracticeID, PayerScenarioID, VendorID, VendorImportID, ReferringPhysicianID,
EmploymentRelatedFlag, AutoAccidentRelatedFlag, AutoAccidentRelatedState, Notes)
SELECT P.PatientID, Description, P.PracticeID, 5, DC.CaseNumber, @VendorImportID, P.ReferringPhysicianID, 
CASE WHEN UPPER(LTRIM(RTRIM(RelatedToEmployment)))= 'TRUE' THEN 1 ELSE 0 END, 
CASE WHEN UPPER(LTRIM(RTRIM(RelatedToAccident))) = 'AUTO' THEN 1 ELSE 0 END, 
AccidentState, DC.Notes
FROM Patient P INNER JOIN Coastal_MWCAS DC
ON P.VendorID=DC.ChartNumber
WHERE VendorID IS NOT NULL -- VendorID is ChartNumber
	AND VendorImportID=@VendorImportID
	AND PracticeID=@PracticeID

-- Create Default Patient Cases for patients with no chartnumber in mwcas table
INSERT INTO 
	PatientCase(PatientID, name, PayerScenarioID, ReferringPhysicianID, PracticeID, VendorID, VendorImportID)
SELECT
	p.PatientID, 'Default Case', 5, p.ReferringPhysicianID, @PracticeID, p.VendorID, @VendorImportID
FROM
	Patient p
WHERE
	p.VendorImportID = @VendorImportID 
	AND p.VendorID NOT IN (SELECT DISTINCT ChartNumber FROM Coastal_mwcas) 
	

CREATE INDEX IX_PatientCase_VendorID
ON PatientCase (VendorID)

CREATE INDEX IX_InsuranceCompanyPlan_VendorID
ON InsuranceCompanyPlan (VendorID)

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[InsurancePolicy]') AND name = N'CI_InsurancePolicy_PracticeID_InsurancePolicyID')
DROP INDEX [CI_InsurancePolicy_PracticeID_InsurancePolicyID] ON [dbo].[InsurancePolicy] WITH ( ONLINE = OFF )

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[InsurancePolicy]') AND name = N'IX_InsurancePolicy_InsuranceCompanyPlanID')
DROP INDEX [IX_InsurancePolicy_InsuranceCompanyPlanID] ON [dbo].[InsurancePolicy] WITH ( ONLINE = OFF )

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[InsurancePolicy]') AND name = N'IX_InsurancePolicy_PatientCaseID')
DROP INDEX [IX_InsurancePolicy_PatientCaseID] ON [dbo].[InsurancePolicy] WITH ( ONLINE = OFF )

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
	HolderGender,
	HolderPhone,
	HolderDOB,
	HolderSSN,
	VendorID,
	VendorImportID
	)
SELECT PC.PatientCaseID, PC.PracticeID, 
ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) InsuranceCompanPlanID,
LEFT(LTRIM(RTRIM(PolicyNumber1)),32) PolicyNumber, LEFT(LTRIM(RTRIM(GroupNumber1)),32) GroupNumber, 1, 
Policy1StartDate PolicyStartDate, Policy1EndDate PolicyEndDate,
CASE WHEN ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
THEN CASE WHEN UPPER(DC.InsuredRelationship1) = 'OTHER' THEN 'O'	-- other		
WHEN UPPER(DC.InsuredRelationship1) = 'CHILD' THEN 'C' 	-- child
WHEN UPPER(DC.InsuredRelationship1) = 'SPOUSE' THEN 'U'	-- spouse						
ELSE 'U' END ELSE 'S' END PatientRelationshipToInsured,
CASE WHEN ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
THEN DP.LastName ELSE NULL END HolderLastName,
CASE WHEN ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
THEN DP.FirstName ELSE NULL END HolderFirstName,
CASE WHEN ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
THEN DP.MiddleName ELSE NULL END HolderMiddleName,
CASE WHEN ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
THEN DP.Street1 ELSE NULL END HolderAddressLine1,
CASE WHEN ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
THEN DP.Street2 ELSE NULL END HolderAddressLine2,
CASE WHEN ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
THEN DP.City ELSE NULL END HolderCity,
CASE WHEN ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
THEN LEFT(LTRIM(RTRIM(DP.State)),2) ELSE NULL END HolderState,
CASE WHEN ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
THEN LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.ZipCode)),9))) ELSE NULL END HolderZipCode,
CASE WHEN ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
THEN CASE WHEN DP.Gender='Female' THEN 'F' ELSE 'M' END ELSE NULL END HolderGender,
CASE WHEN ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
THEN LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.Phone1)),10))) ELSE NULL END HolderPhone,
CASE WHEN ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
THEN LTRIM(RTRIM(DP.DateOfBirth)) ELSE NULL END HolderDOB,
CASE WHEN ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
THEN LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(DP.SocialSecurityNumber, '-', ''), '+', ''), '/', ''))), 9))) ELSE NULL END HolderSSN, DC.InsuranceCarrier1, @VendorImportID
FROM Coastal_MWCAS DC INNER JOIN PatientCase PC
ON PC.VendorImportID=@VendorImportID AND DC.CaseNumber=PC.VendorID
LEFT JOIN InsuranceCompanyPlan ICP
ON ICP.VendorImportID=@VendorImportID AND DC.InsuranceCarrier1=ICP.VendorID
LEFT JOIN #EIP EIP
ON DC.InsuranceCarrier1=EIP.Code
LEFT JOIN Coastal_MWPAT DP
ON DC.Insured1=DP.ChartNumber
WHERE LTRIM(RTRIM(ISNULL(DC.InsuranceCarrier1,'')))<>'' AND ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) IS NOT NULL

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
	HolderGender,
	HolderPhone,
	HolderDOB,
	HolderSSN,
	VendorID,
	VendorImportID
	)
SELECT PC.PatientCaseID, PC.PracticeID, 
ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) InsuranceCompanPlanID,
LEFT(LTRIM(RTRIM(PolicyNumber2)),32) PolicyNumber, LEFT(LTRIM(RTRIM(GroupNumber2)),32) GroupNumber, 2, 
Policy2StartDate PolicyStartDate, Policy2EndDate PolicyEndDate,
CASE WHEN ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
THEN CASE WHEN UPPER(DC.InsuredRelationship2) = 'OTHER' THEN 'O'	-- other		
WHEN UPPER(DC.InsuredRelationship2) = 'CHILD' THEN 'C' 	-- child
WHEN UPPER(DC.InsuredRelationship2) = 'SPOUSE' THEN 'U'	-- spouse						
ELSE 'U' END ELSE 'S' END PatientRelationshipToInsured,
CASE WHEN ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
THEN DP.LastName ELSE NULL END HolderLastName,
CASE WHEN ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
THEN DP.FirstName ELSE NULL END HolderFirstName,
CASE WHEN ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
THEN DP.MiddleName ELSE NULL END HolderMiddleName,
CASE WHEN ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
THEN DP.Street1 ELSE NULL END HolderAddressLine1,
CASE WHEN ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
THEN DP.Street2 ELSE NULL END HolderAddressLine2,
CASE WHEN ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
THEN DP.City ELSE NULL END HolderCity,
CASE WHEN ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
THEN LEFT(LTRIM(RTRIM(DP.State)),2) ELSE NULL END HolderState,
CASE WHEN ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
THEN LEFT(LTRIM(RTRIM(DP.ZipCode)),9) ELSE NULL END HolderZipCode,
CASE WHEN ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
THEN CASE WHEN DP.Gender='Female' THEN 'F' ELSE 'M' END ELSE NULL END HolderGender,
CASE WHEN ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
THEN LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.Phone1)),10))) ELSE NULL END HolderPhone,
CASE WHEN ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
THEN LTRIM(RTRIM(DP.DateOfBirth)) ELSE NULL END HolderDOB,
CASE WHEN ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
THEN LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(DP.SocialSecurityNumber, '-', ''), '+', ''), '/', ''))), 9))) ELSE NULL END HolderSSN, DC.InsuranceCarrier2, @VendorImportID
FROM Coastal_MWCAS DC INNER JOIN PatientCase PC
ON PC.VendorImportID=@VendorImportID AND DC.CaseNumber=PC.VendorID
LEFT JOIN InsuranceCompanyPlan ICP
ON ICP.VendorImportID=@VendorImportID AND DC.InsuranceCarrier2=ICP.VendorID
LEFT JOIN #EIP EIP
ON DC.InsuranceCarrier2=EIP.Code
LEFT JOIN Coastal_MWPAT DP
ON DC.Insured2=DP.ChartNumber
WHERE LTRIM(RTRIM(ISNULL(DC.InsuranceCarrier2,'')))<>'' AND ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) IS NOT NULL

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
	HolderGender,
	HolderPhone,
	HolderDOB,
	HolderSSN,
	VendorID,
	VendorImportID
	)
SELECT PC.PatientCaseID, PC.PracticeID, 
ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) InsuranceCompanPlanID,
PolicyNumber3 PolicyNumber, GroupNumber3 GroupNumber, 3, 
Policy3StartDate PolicyStartDate, Policy3EndDate PolicyEndDate,
CASE WHEN ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
THEN CASE WHEN UPPER(DC.InsuredRelationship3) = 'OTHER' THEN 'O'	-- other		
WHEN UPPER(DC.InsuredRelationship3) = 'CHILD' THEN 'C' 	-- child
WHEN UPPER(DC.InsuredRelationship3) = 'SPOUSE' THEN 'U'	-- spouse						
ELSE 'U' END ELSE 'S' END PatientRelationshipToInsured,
CASE WHEN ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
THEN DP.LastName ELSE NULL END HolderLastName,
CASE WHEN ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
THEN DP.FirstName ELSE NULL END HolderFirstName,
CASE WHEN ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
THEN DP.MiddleName ELSE NULL END HolderMiddleName,
CASE WHEN ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
THEN DP.Street1 ELSE NULL END HolderAddressLine1,
CASE WHEN ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
THEN DP.Street2 ELSE NULL END HolderAddressLine2,
CASE WHEN ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
THEN DP.City ELSE NULL END HolderCity,
CASE WHEN ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
THEN LEFT(LTRIM(RTRIM(DP.State)),2) ELSE NULL END HolderState,
CASE WHEN ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
THEN LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.ZipCode)),9))) ELSE NULL END HolderZipCode,
CASE WHEN ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
THEN CASE WHEN DP.Gender='Female' THEN 'F' ELSE 'M' END ELSE NULL END HolderGender,
CASE WHEN ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
THEN LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.Phone1)),10))) ELSE NULL END HolderPhone,
CASE WHEN ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
THEN LTRIM(RTRIM(DP.DateOfBirth)) ELSE NULL END HolderDOB,
CASE WHEN ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
THEN LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(DP.SocialSecurityNumber, '-', ''), '+', ''), '/', ''))), 9))) ELSE NULL END HolderSSN, DC.InsuranceCarrier3, @VendorImportID
FROM Coastal_MWCAS DC INNER JOIN PatientCase PC
ON PC.VendorImportID=@VendorImportID AND DC.CaseNumber=PC.VendorID
LEFT JOIN InsuranceCompanyPlan ICP
ON ICP.VendorImportID=@VendorImportID AND DC.InsuranceCarrier3=ICP.VendorID
LEFT JOIN #EIP EIP
ON DC.InsuranceCarrier3=EIP.Code
LEFT JOIN Coastal_MWPAT DP
ON DC.Insured3=DP.ChartNumber
WHERE LTRIM(RTRIM(ISNULL(DC.InsuranceCarrier3,'')))<>'' AND ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) IS NOT NULL

CREATE CLUSTERED INDEX [CI_InsurancePolicy_PracticeID_InsurancePolicyID] ON [dbo].[InsurancePolicy] 
(
	[PracticeID] ASC,
	[InsurancePolicyID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_InsurancePolicy_InsuranceCompanyPlanID] ON [dbo].[InsurancePolicy] 
(
	[InsuranceCompanyPlanID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_InsurancePolicy_PatientCaseID] ON [dbo].[InsurancePolicy] 
(
	[PatientCaseID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

DROP INDEX PatientCase.IX_PatientCase_VendorID
DROP INDEX InsuranceCompanyPlan.IX_InsuranceCompanyPlan_VendorID

CREATE TABLE #PCToUpdate(PatientCaseID INT)
INSERT INTO #PCToUpdate(PatientCaseID)
SELECT PC.PatientCaseID
FROM PatientCase PC LEFT JOIN InsurancePolicy IP
ON PC.PatientCaseID=IP.PatientCaseID
WHERE PC.PracticeID=@PracticeID
GROUP BY PC.PatientCaseID
HAVING COUNT(InsurancePolicyID)=0

UPDATE PC SET PayerScenarioID=11
FROM PatientCase PC INNER JOIN #PCToUpdate PCU
ON PC.PatientCaseID=PCU.PatientCaseID

-- Edit GroupNumber, PolicyStartDate and PolicyEndDate
UPDATE insurancepolicy
SET GroupNumber = ''
WHERE VendorImportID = @VendorImportID and UPPER(GroupNumber) = 'NONE'

UPDATE InsurancePolicy
SET PolicyStartDate = NULL
WHERE PolicyStartDate = '1/1/1900'
AND VendorImportID = @VendorImportID

UPDATE InsurancePolicy
SET PolicyEndDate = NULL
WHERE PolicyEndDate = '1/1/1900'
AND VendorImportID = @VendorImportID

UPDATE InsurancePolicy
SET HolderDOB = NULL
WHERE HolderDOB = '1/1/1900'
AND VendorImportID = @VendorImportID

UPDATE InsurancePolicy
SET PolicyStartDate = NULL
WHERE PolicyStartDate = '1900-01-01 12:00:00.000'
AND VendorImportID = @VendorImportID

UPDATE InsurancePolicy
SET PolicyEndDate = NULL
WHERE PolicyEndDate = '1900-01-01 12:00:00.000'
AND VendorImportID = @VendorImportID

DROP TABLE #PCToUpdate

DROP TABLE #PG
DROP TABLE #EIC
DROP TABLE #NIC
DROP TABLE #EIP
DROP TABLE #NIP


-- ROLLBACK
-- COMMIT
--SELECT * FROM VENDORIMPORT ORDER BY VENDORIMPORTID
/*
select top 100 * from Coastal_mwcas where chartnumber = '00000050'
--select * from patient where vendorid = '00000050'
--select * from patientcase where patientid = '19835'
select * from insurancepolicy where patientcaseid = '20770'

select top 100 * from Coastal_mwcas where chartnumber = '00000049'
--select * from patient where vendorid = '00000049'
--select * from patientcase where patientid = '19834'
select * from insurancepolicy where patientcaseid = '20769'
*/

/*
use superbill_0218_dev
delete from insurancepolicy where vendorimportid is not null
--delete from insurancecompanyplan where vendorimportid is not null
--delete from insurancecompany where vendorimportid is not null
delete from patientcase where vendorimportid is not null and [External] = 1
delete from patient where vendorimportid is not null
delete from doctor where vendorimportid is not null
--delete from vendorimport

select * from patient where vendorimportid is not null
select * from patientcase where vendorimportid is not null
select * from insurancecompany where vendorimportid is not null
select * from insurancecompanyplan where vendorimportid is not null
select * from insurancepolicy where vendorimportid is not null
select * from doctor where vendorimportid is not null
select * from vendorimport
*/
--select * from insurancepolicy
