-- DB_327_Case_10860_Import
-- ========================
--
-- California Medical Billing - Dr. Wang Import Script.
-- PracticeID = 1

-- Tables Populated.
-- =================
-- 1. Doctor
-- 2. ProviderNumber
-- 3. Patient
-- 4. PatientCase
-- 5. InsuranceCompany
-- 6. InsuranceCompanyPlan
-- 7. InsurancePolicy

-- Select * From doctor Where practiceid = 1

Use superbill_0327_dev
Go

Begin Transaction

-- Rollback
-- Commit

Declare @PracticeID int
Declare @VendorImportID int

Insert Into VendorImport
    ( VendorName
      , Notes
      , VendorFormat
    )
    Values
    ( 'Dr. Wang'
      , 'California Medical Billing'
      , 'MediSoft'
    )

Select @VendorImportID = @@IDENTITY

-- Dr Wang Practice.
Select @PracticeID = 2

Insert Into Doctor (PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, Degree, SSN, --TaxonomyCode,
	    WorkPhone, FaxNumber, AddressLine1, AddressLine2, City, State, ZipCode, VendorID, VendorImportID, [External])
Select @PracticeID, '',
	Case When FirstName Is Not Null Then LTRIM(RTRIM(FirstName)) Else '' End,
	Case When MiddleInitial Is Not Null Then LTRIM(RTRIM(MiddleInitial)) Else '' End,
	Case When LastName Is Not Null Then LTRIM(RTRIM(LastName)) Else '' End, '',
	Case When Credentials Is Not Null Then LTRIM(RTRIM(Credentials)) Else '' End,
	-- Case When UPIN Is Not Null Then LTRIM(RTRIM(UPIN)) Else '' End,
	Case When SSNOrFedTaxID Is Not Null Then LTRIM(RTRIM(SSNOrFedTaxID)) Else '' End,
	-- Case When TaxonomyCode Is Not Null Then LTRIM(RTRIM(TaxonomyCode)) Else NULL End,
	Case When Phone Is Not Null Then LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(Phone, '-', ''), '(', ''), ')', ''))) Else '' End,
	Case When Fax Is Not Null Then LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(Fax, '-', ''), '(', ''), ')', ''))) Else '' End,
	Case When Street1 IS NULL Then '' Else LTRIM(RTRIM(Street1)) End,
	Case When Street2 IS NULL Then '' Else LTRIM(RTRIM(Street2)) End,
	Case When City IS NULL Then '' Else LTRIM(RTRIM(City)) End,
	Case When State IS NULL Then '' Else LTRIM(RTRIM(State)) End,
	Case When ZipCode IS NULL Then '' Else LTRIM(RTRIM(REPLACE(ZipCode,'-',''))) End,
	Case When Code IS NULL Then '' Else LTRIM(RTRIM(Code)) End,
	@VendorImportID,
	0
From CMB2_MWPHY
Where Code = 'LTW'
Order By Code

-- ReferringPhysician
-- MWRPH
Insert Into Doctor (PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, Degree, SSN, --TaxonomyCode,
	    WorkPhone, FaxNumber, AddressLine1, AddressLine2, City, State, ZipCode, VendorID, VendorImportID, [External])
Select @PracticeID, '',
	Case When FirstName Is Not Null Then LTRIM(RTRIM(FirstName)) Else '' End,
	Case When MiddleInitial Is Not Null Then LTRIM(RTRIM(MiddleInitial)) Else '' End,
	Case When LastName Is Not Null Then LTRIM(RTRIM(LastName)) Else '' End, '',
	Case When Credentials Is Not Null Then LTRIM(RTRIM(Credentials)) Else '' End,
	--Case When UPIN Is Not Null Then LTRIM(RTRIM(UPIN)) Else '' End,
	Case When SSNOrFedTaxID Is Not Null Then LTRIM(RTRIM(SSNOrFedTaxID)) Else '' End,
	--Case When TaxonomyCode Is Not Null Then LTRIM(RTRIM(TaxonomyCode)) Else NULL End,
	Case When Phone Is Not Null Then LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(Phone, '-', ''), '(', ''), ')', ''))) Else '' End,
	Case When Fax Is Not Null Then LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(Fax, '-', ''), '(', ''), ')', ''))) Else '' End,
	Case When Street1 IS NULL Then '' Else LTRIM(RTRIM(Street1)) End,
	Case When Street2 IS NULL Then '' Else LTRIM(RTRIM(Street2)) End,
	Case When City IS NULL Then '' Else LTRIM(RTRIM(City)) End,
	Case When State IS NULL Then '' Else LTRIM(RTRIM(State)) End,
	Case When ZipCode IS NULL Then '' Else LEFT(LTRIM(RTRIM(REPLACE(ZipCode,'-',''))), 9) End,
	Case When Code IS NULL Then '' Else LTRIM(RTRIM(Code)) End,
	@VendorImportID , 1
From CMB2_MWRPH
Order By Code

-- Insert UPIN for Referring Physicians -- TODO in final data import
Insert Into ProviderNumber(DoctorID, ProviderNumberTypeID, ProviderNumber, AttachConditionsTypeID)
Select DoctorID, 25, LTRIM(RTRIM(UPIN)), 1
From Doctor D
    Inner Join CMB2_mwrph a
ON D.VendorImportID=@VendorImportID AND D.VendorID=a.Code
Where LTRIM(RTRIM(UPIN))<> '' AND UPIN Is Not Null AND [External] = 1

-- Exclude all except 10 most recent Cases for each chartnumber
Declare @LOOP INT
Declare @COUNT INT
Declare @CHARTNUMBER VARCHAR(50)
Declare @MAXID INT

CREATE TABLE #CasesToIgnore(CNUM VARCHAR(50))

CREATE TABLE #ChartNumbersWithTooManyCases(CID INT IDENTITY(1,1),CHARTNUM varchar(50), CaseNUM varchar(50))
Insert Into #ChartNumbersWithTooManyCases(CHARTNUM, CaseNUM)
Select chartnumber, Casenumber From CMB2_mwcas
Where chartnumber in (
Select chartnumber
From CMB2_mwcas
GROUP BY chartnumber				--
HAVING count(Casenumber) > 10		--
)
Order By chartnumber, cast(Casenumber as int)
-- Select * From #ChartNumbersWithTooManyCases

CREATE TABLE #DISTINCTCHARTNUMBERS(DCID INT IDENTITY(1,1), CHART VARCHAR(50))
Insert Into #DISTINCTCHARTNUMBERS(CHART)
Select DISTINCT CHARTNUM From #ChartNumbersWithTooManyCases
Order By CHARTNUM
-- Select * From #DISTINCTCHARTNUMBERS

SET @LOOP=@@ROWCOUNT -- distinct chart numbers
SET @COUNT= 0
WHILE @COUNT < @LOOP
Begin
	SET @COUNT = @COUNT + 1
	Select @CHARTNUMBER = CHART
	From #DISTINCTCHARTNUMBERS
	Where DCID = @COUNT
	-- For current chartnumber, Select all but 10 recent Cases and Insert as Cases to ignore
	Select @MAXID = MAX(CAST(CID AS INT)) From #ChartNumbersWithTooManyCases
	Where CHARTNUM = @CHARTNUMBER

	Insert Into #CasesToIgnore(CNUM)
	Select CaseNUM From #ChartNumbersWithTooManyCases
	Where CHARTNUM = @CHARTNUMBER
	AND CID <= (@MAXID - 10)
End
-- Select * From #CasesToIgnore
--

-- Patient (note: the same ssn can correspond to more than 1 PatientID, if patient used more than one practice)
-- Insert patients excluding Guarantor (Where Patient Type <> 'Guarantor'
--Create table with Patients and their Guarantors
CREATE TABLE #PG (PatientChartNumber varchar(50), GuarantorChartNumber varchar(50),ResponsibleDifferentThanPatient BIT, ResponsibleFirstName varchar(50),
ResponsibleMiddleName varchar(50), ResponsibleLastName varchar(50), ResponsibleAddressLine1 varchar(50), ResponsibleAddressLine2 varchar(50),
ResponsibleCity varchar(50), ResponsibleState varchar(50), ResponsibleZipCode varchar(50), ResponsibleRelationsipToPatient varchar(50), CaseNumber varchar(50))

Insert Into #PG (PatientChartNumber, GuarantorChartNumber, ResponsibleDifferentThanPatient, ResponsibleFirstName, ResponsibleMiddleName,
	ResponsibleLastName, ResponsibleAddressLine1, ResponsibleAddressLine2,
	ResponsibleCity, ResponsibleState, ResponsibleZipCode, ResponsibleRelationsipToPatient, CaseNumber)
Select DISTINCT LTRIM(RTRIM(cas.ChartNumber)), LTRIM(RTRIM(cas.Guarantor)), 1,
	LTRIM(RTRIM(pat.FirstName)),
	Case When (pat.MiddleName IS NULL) Then '' Else LTRIM(RTRIM(pat.MiddleName)) End,
	LTRIM(RTRIM(pat.LastName)),
	Case When pat.Street1 IS NULL Then '' Else LTRIM(RTRIM(pat.Street1)) End,
	Case When pat.Street2 IS NULL Then '' Else LTRIM(RTRIM(pat.Street2)) End,
	Case When pat.City IS NULL Then '' Else LTRIM(RTRIM(pat.City)) End,
	Case When pat.State IS NULL Then '' Else LTRIM(RTRIM(pat.State)) End,
	Case When pat.ZipCode IS NULL Then '' Else LTRIM(RTRIM(REPLACE(ZipCode,'-',''))) End, 'U', cas.CaseNumber
From CMB2_MWPAT pat
INNER JOIN CMB2_MWCAS cas ON cas.Guarantor = pat.ChartNumber
Where cas.ChartNumber <> cas.Guarantor

-- Delete duplicate patients with guarantors; use guarantor listed for the most recent Case

DELETE From #PG
Where EXISTS
	(Select * From #PG AS pg
	Where pg.PatientChartNumber= #PG.PatientChartNumber
	AND CAST(pg.CaseNumber AS INT) > CAST(#PG.CaseNumber AS INT))

Insert Into Patient
	(VendorImportID
     , VendorID, PracticeID,
	 Prefix, FirstName, MiddleName, LastName, Suffix,
	AddressLine1, AddressLine2, City, State, ZipCode, GEnder, MaritalStatus,
	HomePhone, WorkPhone, WorkPhoneExt,DOB, SSN, ResponsibleDifferentThanPatient,
	ResponsibleFirstName, ResponsibleMiddleName, ResponsibleLastName, ResponsibleAddressLine1,
	ResponsibleAddressLine2, ResponsibleCity, ResponsibleState, ResponsibleZipCode, PrimaryProviderID, MobilePhone)
Select  @VendorImportID, pat.ChartNumber, @PracticeID, 		-- pg.PatientChartNumber, pg.GuarantorChartNumber,
	'', Case When pat.FirstName IS NULL Then '' Else LTRIM(RTRIM(pat.FirstName)) End,
	Case When pat.MiddleName IS NULL Then '' Else LTRIM(RTRIM(pat.MiddleName)) End,
	Case When pat.LastName IS NULL Then '' Else LTRIM(RTRIM(pat.LastName)) End, '',
	Case When pat.Street1 IS NULL Then '' Else LTRIM(RTRIM(pat.Street1)) End,
	Case When pat.Street2 IS NULL Then '' Else LTRIM(RTRIM(pat.Street2)) End,
	Case When pat.City Is Not Null Then LTRIM(RTRIM(pat.City)) Else '' End,
	Case When pat.State Is Not Null AND LEN(LTRIM(RTRIM(pat.State))) < 3 Then LTRIM(RTRIM(pat.State)) Else NULL End,
	Case When pat.ZipCode Is Not Null AND LTRIM(RTRIM(pat.ZipCode)) <> '' Then LEFT(LTRIM(RTRIM(REPLACE(ZipCode,'-',''))), 9) Else NULL End,
	Case When LTRIM(RTRIM(pat.GEnder)) = 'Male' Then 'M'
     		When LTRIM(RTRIM(pat.GEnder)) = 'Female' Then 'F'
     		Else 'U' End,
	'U', -- MariatalStatus not available in patients table
	Case When pat.Phone1 Is Not Null AND LTRIM(RTRIM(pat.Phone1)) <> '' Then LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.Phone1, '-', ''), '(', ''), ')', ''))), 10) Else '' End,
	Case When pat.WorkPhone Is Not Null AND LTRIM(RTRIM(pat.WorkPhone)) <> '' Then LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.WorkPhone, '-', ''), '(', ''), ')', ''))), 10) Else '' End,
	Case When pat.WorkExtension Is Not Null AND LTRIM(RTRIM(pat.WorkExtension)) <> '' Then LEFT(LTRIM(RTRIM(pat.WorkExtension)), 10) End,
	Case When (pat.DateOfBirth Is Not Null AND LTRIM(RTRIM(pat.DateOfBirth)) <> '' AND ISDATE(LTRIM(RTRIM(pat.DateOfBirth))) = 1) Then CAST(LTRIM(RTRIM(pat.DateOfBirth)) AS DATETIME) Else NULL End,
	Case When (pat.SocialSecurityNumber Is Not Null AND LTRIM(RTRIM(pat.SocialSecurityNumber)) <> '') Then LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.SocialSecurityNumber, '-', ''), '+', ''), '/', ''))), 9) Else NULL End,
	Case When pg.PatientChartNumber Is Not Null Then 1 Else 0 End,
	Case When pg.PatientChartNumber Is Not Null Then pg.ResponsibleFirstName Else NULL End,
	Case When pg.PatientChartNumber Is Not Null Then pg.ResponsibleMiddleName Else NULL End,
	Case When pg.PatientChartNumber Is Not Null Then pg.ResponsibleLastName Else NULL End,
	Case When pg.PatientChartNumber Is Not Null Then pg.ResponsibleAddressLine1 Else NULL End,
	Case When pg.PatientChartNumber Is Not Null Then pg.ResponsibleAddressLine2 Else NULL End,
	Case When pg.PatientChartNumber Is Not Null Then pg.ResponsibleCity Else NULL End,
	Case When pg.PatientChartNumber Is Not Null Then pg.ResponsibleState Else NULL End,
	Case When pg.PatientChartNumber Is Not Null AND LTRIM(RTRIM(pg.PatientChartNumber)) <> '' Then LEFT(pg.ResponsibleZipCode, 9) Else NULL End, NULL,
	Case When pat.Phone2 Is Not Null AND LTRIM(RTRIM(pat.Phone2)) <> '' Then LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.Phone2, '-', ''), '(', ''), ')', ''))), 10) Else '' End
From CMB2_MWPAT pat
LEFT JOIN #PG pg ON pat.ChartNumber = pg.PatientChartNumber
Where UPPER(LTRIM(RTRIM(pat.PatientType))) <> 'Guarantor'


Declare @RefToPatient TABLE(ChartNumber VARCHAR(50), ReferringProvider VARCHAR(50))
Insert @RefToPatient(ChartNumber, ReferringProvider)
Select DISTINCT ChartNumber, ReferringProvider
From CMB2_MWCAS
Where LEN(ReferringProvider)>0

UPDATE P SET ReferringPhysicianID=D.DoctorID
From Patient P INNER JOIN @RefToPatient RTP
ON P.VendorImportID=@VendorImportID AND P.VendorID=RTP.ChartNumber
INNER JOIN Doctor D
ON D.VendorImportID=@VendorImportID AND RTP.ReferringProvider=D.VendorID

-- InsuranceCompany
-- MWINS - Assume that insurance company is the same as insuranceplan
-- Create temporary table to hold insurance companies that already exist in InsuranceCompany table
CREATE TABLE #EIC (InsuranceCompanyID int, InsuranceCompanyName varchar(255), AddressLine1 varchar(255), AddressLine2 varchar(255), City varchar(255),
State varchar(255), ZipCode varchar(255), Phone varchar(255), PhoneExt varchar(255), ReviewCode varchar(255), Code varchar(255))

Insert Into #EIC (InsuranceCompanyID, InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt, ReviewCode, Code)
Select MAX(ico.InsuranceCompanyID) InsuranceCompanyID, ic.Name, ic.Street1, ic.Street2, ic.City, ic.State, ic.ZipCode, ic.Phone, ic.Extension, ico.ReviewCode, ic.Code
From CMB2_MWINS ic
JOIN InsuranceCompany ico
ON LTRIM(RTRIM(ico.InsuranceCompanyName)) = LTRIM(RTRIM(ic.Name))
Where
	LTRIM(RTRIM(ico.City)) = LTRIM(RTRIM(ic.City))
	AND LEFT(ico.ZipCode, 5) = LEFT(ic.ZipCode, 5)
	AND LTRIM(RTRIM(ico.State)) = LTRIM(RTRIM(ic.State))
	AND LTRIM(RTRIM(ico.InsuranceCompanyName)) = LTRIM(RTRIM(ic.Name))
	AND REPLACE(REPLACE(ico.AddressLine1, ' ', ''), '.', '') = REPLACE(REPLACE(ic.Street1, ' ', ''), '.', '')
GROUP BY ic.Name, ic.Street1, ic.Street2, ic.City, ic.State, ic.ZipCode, ic.Phone, ic.Extension, ico.ReviewCode, ic.Code

-- Store insurance companies that do not exist in InsuranceCompany table in another temporary table #NIC
CREATE TABLE #NIC (Code varchar(255), InsuranceCompanyName varchar(255), AddressLine1 varchar(255), AddressLine2 varchar(255), City varchar(255),
State varchar(255), ZipCode varchar(255), Phone varchar(255), PhoneExt varchar(255), ReviewCode varchar(255))

Insert Into #NIC (Code, InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt, ReviewCode)
Select ic.Code, ic.Name, ic.Street1, ic.Street2, ic.City, ic.State, ic.ZipCode, ic.Phone, ic.Extension, 'R'
From CMB2_MWINS ic
Where ic.Code NOT IN (Select Code From #EIC)

-- Insert Into InsuranceCompany those ins.companies that do not already exist
Insert Into InsuranceCompany
( VendorID, VendorImportID, InsuranceCompanyName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt, ReviewCode)
Select LTRIM(RTRIM(Code)), @VendorImportID,
	LTRIM(RTRIM(InsuranceCompanyName)),
	LTRIM(RTRIM(AddressLine1)),
	LTRIM(RTRIM(AddressLine2)),
	LTRIM(RTRIM(City)),
	LTRIM(RTRIM(State)),
	Case When ZipCode Is Not Null AND LTRIM(RTRIM(ZipCode)) <> '' Then LEFT(LTRIM(RTRIM(REPLACE(REPLACE(ZipCode,'-',''), ' ', ''))), 9) Else NULL End,
	Case When Phone Is Not Null AND LTRIM(RTRIM(Phone)) <> '' Then LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Phone,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10) Else NULL End,
	Case When PhoneExt IS NULL Then '' Else LTRIM(RTRIM(LEFT(PhoneExt, 10))) End, 'R'
From #NIC

--Select count(*) From #NIC
-- rollback

-- InsuranceCompanyPlan
-- Insert plans that do not already exist  in InsuranceCompanyPlan

-- 1) find which ones exist;  Code - same as InsuranceCarrier #1, #2 and 3# in MWCAS)
-- Existing InsuranceCompanyPlans
CREATE TABLE #EIP (InsuranceCompanyPlanID int, Code varchar(255), PlanName varchar(255), AddressLine1 varchar(255), AddressLine2 varchar(255),
City varchar(255), State varchar(255), ZipCode varchar(255), Phone varchar(255), PhoneExt varchar(255))

Insert Into #EIP			-- Insert plans that already exist in InsuranceCompanyPlan table
(InsuranceCompanyPlanID, Code, PlanName, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt)
Select MAX(icp.InsuranceCompanyPlanID) InsuranceCompanyPlanID,
	LTRIM(RTRIM(ip.Code)),
	LTRIM(RTRIM(ip.Name)),
	LTRIM(RTRIM(ip.Street1)),
	LTRIM(RTRIM(ip.Street2)),
	LTRIM(RTRIM(ip.City)),
	LEFT(LTRIM(RTRIM(ip.State)), 2),
	LTRIM(RTRIM(REPLACE(ip.ZipCode,'-',''))),
	LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Phone,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10))),
	LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Extension,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10)))
From CMB2_MWINS ip
JOIN InsuranceCompanyPlan icp ON LTRIM(RTRIM(icp.PlanName)) = LTRIM(RTRIM(ip.Name))
	Where LTRIM(RTRIM(icp.City)) = LTRIM(RTRIM(ip.City))
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

--Select * From #EIP Where code='1'

-- Create temporary table with plans that do not exist in InsuranceCompanyPlan table

CREATE TABLE #NIP (Code varchar(255), PlanName varchar(255),
InsuranceCompanyID int, AddressLine1 varchar(255), AddressLine2 varchar(255),
City varchar(255), State varchar(255), ZipCode varchar(255), Phone varchar(255), PhoneExt varchar(255))

Insert Into #NIP			-- Insert plans that do not already exist in InsuranceCompanyPlan table
(Code, PlanName, InsuranceCompanyID, AddressLine1, AddressLine2, City, State, ZipCode, Phone, PhoneExt)
Select LTRIM(RTRIM(ip.Code)),
	LTRIM(RTRIM(ip.Name)),
	LTRIM(RTRIM(ISNULL(eic.InsuranceCompanyID,ic.InsuranceCompanyID))),
	LTRIM(RTRIM(ip.Street1)),
	LTRIM(RTRIM(ip.Street2)),
	LTRIM(RTRIM(ip.City)),
	LTRIM(RTRIM(ip.State)),
	LTRIM(RTRIM(REPLACE(ip.ZipCode,'-',''))),
	LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Phone,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10))),
	LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Extension,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10)))
From CMB2_MWINS ip
LEFT JOIN InsuranceCompany ic
on ic.VendorImportID=@VendorImportID and ip.Code=ic.VendorID
LEFT JOIN #EIC eic
on ip.code=eic.Code
Where ip.Code NOT IN (Select Code From #EIP)
Order By ip.Name

--Select * From #NIP Where code='1'
-- Insert plans that do not already exist Into InsuranceCompanyPlan table

Insert Into InsuranceCompanyPlan
( VendorImportID
  , VendorID
  , PlanName
  , InsuranceCompanyID
  , AddressLine1
  , AddressLine2
  , City
  , State
  , ZipCode
  , Phone
  , Copay
  , PhoneExt
  , ReviewCode
)
Select
	@VendorImportID,
	nip.Code,
	nip.PlanName,
	nip.InsuranceCompanyID,
	nip.AddressLine1,
	nip.AddressLine2,
	nip.City,
	Case When LEN(nip.State) <= 2 Then nip.State Else NULL End,
	Case When LEN(nip.ZipCode) <= 9 Then nip.ZipCode Else NULL End,
	nip.Phone,
	--COALESCE(CAST(ip.Copay AS money),0),
	CAST(0.00 AS money),
	nip.PhoneExt,
	'R'
From #NIP nip

-- Insurance plans that did not exist will have VendorImportID for this import and and VendorID = MWINS.Code
-- for those that did exist, match InsuranceCompanyPlanID From #EIP
-- Select InsuranceCompanyPlanID From #EIP

/*
Insert Into PatientCase
(PatientID, Name, PracticeID, PayerScenarioID, VendorID, VendorImportID, ReferringPhysicianID,
EmploymentRelatedFlag, AutoAccidentRelatedFlag, AutoAccidentRelatedState, Notes)
Select P.PatientID, Description, P.PracticeID, 5, DC.CaseNumber, @VendorImportID, P.ReferringPhysicianID,
Case When UPPER(LTRIM(RTRIM(RelatedToEmployment)))= 'TRUE' Then 1 Else 0 End,
Case When UPPER(LTRIM(RTRIM(RelatedToAccident))) = 'AUTO' Then 1 Else 0 End,
AccidentState, DC.Notes
From Patient P INNER JOIN CMB2_MWCAS DC
ON P.VendorID=DC.ChartNumber
Where VendorID Is Not Null -- VendorID is ChartNumber
	AND VendorImportID=@VendorImportID
	AND PracticeID=@PracticeID
	AND DC.CaseNumber NOT IN (Select CNUM From #CasesToIgnore) -- Exclude all but 10 most recent Casenumbers
*/

-- Ashish - 06/15/2006.
Select chartnumber
	   , Convert( Varchar(50) , Max( Convert( int , casenumber ) ) ) As casenumber Into #RecentCases
	From CMB2_mwcas
	Group By chartnumber
	Order By chartnumber

Insert Into PatientCase
(PatientID, Name, PracticeID, PayerScenarioID, VendorID, VendorImportID, ReferringPhysicianID,
EmploymentRelatedFlag, AutoAccidentRelatedFlag, AutoAccidentRelatedState, Notes)
Select P.PatientID, Description, P.PracticeID, 5, DC.CaseNumber, @VendorImportID, P.ReferringPhysicianID,
Case When UPPER(LTRIM(RTRIM(RelatedToEmployment)))= 'TRUE' Then 1 Else 0 End,
Case When UPPER(LTRIM(RTRIM(RelatedToAccident))) = 'AUTO' Then 1 Else 0 End,
AccidentState, DC.Notes
From Patient P
	INNER JOIN CMB2_MWCAS DC ON P.VendorID = DC.ChartNumber
	Inner Join #RecentCases RC On DC.ChartNumber = RC.ChartNumber And DC.CaseNumber = RC.CaseNumber
Where VendorID Is Not Null -- VendorID is ChartNumber
	AND VendorImportID = @VendorImportID
	AND PracticeID = @PracticeID

-- Create Default Patient Cases for patients with no chartnumber in mwcas table
Insert Into
	PatientCase(PatientID, name, PayerScenarioID, ReferringPhysicianID, PracticeID, VendorID, VendorImportID)
Select
	p.PatientID, 'Default Case', 5, p.ReferringPhysicianID, @PracticeID, p.VendorID, @VendorImportID
From Patient P
Where P.VendorImportID = @VendorImportID
		And P.VendorID NOT IN (Select DISTINCT ChartNumber From CMB2_mwcas)

CREATE INDEX IX_PatientCase_VendorID
ON PatientCase (VendorID)

CREATE INDEX IX_InsuranceCompanyPlan_VendorID
ON InsuranceCompanyPlan (VendorID)

IF  EXISTS (Select * From sys.indexes Where object_id = OBJECT_ID(N'[dbo].[InsurancePolicy]') AND name = N'CI_InsurancePolicy_PracticeID_InsurancePolicyID')
DROP INDEX [CI_InsurancePolicy_PracticeID_InsurancePolicyID] ON [dbo].[InsurancePolicy] WITH ( ONLINE = OFF )

IF  EXISTS (Select * From sys.indexes Where object_id = OBJECT_ID(N'[dbo].[InsurancePolicy]') AND name = N'IX_InsurancePolicy_InsuranceCompanyPlanID')
DROP INDEX [IX_InsurancePolicy_InsuranceCompanyPlanID] ON [dbo].[InsurancePolicy] WITH ( ONLINE = OFF )

IF  EXISTS (Select * From sys.indexes Where object_id = OBJECT_ID(N'[dbo].[InsurancePolicy]') AND name = N'IX_InsurancePolicy_PatientCaseID')
DROP INDEX [IX_InsurancePolicy_PatientCaseID] ON [dbo].[InsurancePolicy] WITH ( ONLINE = OFF )

Insert Into InsurancePolicy(
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
	HolderGEnder,
	HolderPhone,
	HolderDOB,
	HolderSSN,
	VendorID,
	VendorImportID
	)
Select PC.PatientCaseID, PC.PracticeID,
ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) InsuranceCompanPlanID,
LEFT(LTRIM(RTRIM(PolicyNumber1)),32) PolicyNumber, LEFT(LTRIM(RTRIM(GroupNumber1)),32) GroupNumber, 1,
Policy1StartDate PolicyStartDate, Policy1EndDate PolicyEndDate,
Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
Then Case When UPPER(DC.InsuredRelationship1) = 'OTHER' Then 'O'	-- other
When UPPER(DC.InsuredRelationship1) = 'CHILD' Then 'C' 	-- child
When UPPER(DC.InsuredRelationship1) = 'SPOUSE' Then 'U'	-- spouse
Else 'U' End Else 'S' End PatientRelationshipToInsured,
Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
Then DP.LastName Else NULL End HolderLastName,
Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
Then DP.FirstName Else NULL End HolderFirstName,
Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
Then DP.MiddleName Else NULL End HolderMiddleName,
Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
Then DP.Street1 Else NULL End HolderAddressLine1,
Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
Then DP.Street2 Else NULL End HolderAddressLine2,
Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
Then DP.City Else NULL End HolderCity,
Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
Then LEFT(LTRIM(RTRIM(DP.State)),2) Else NULL End HolderState,
Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.ZipCode)),9))) Else NULL End HolderZipCode,
Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
Then Case When DP.GEnder='Female' Then 'F' Else 'M' End Else NULL End HolderGEnder,
Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.Phone1)),10))) Else NULL End HolderPhone,
Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
Then LTRIM(RTRIM(DP.DateOfBirth)) Else NULL End HolderDOB,
Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(DP.SocialSecurityNumber, '-', ''), '+', ''), '/', ''))), 9))) Else NULL End HolderSSN, DC.InsuranceCarrier1, @VendorImportID
From CMB2_MWCAS DC INNER JOIN PatientCase PC
ON PC.VendorImportID=@VendorImportID AND DC.CaseNumber=PC.VendorID
LEFT JOIN InsuranceCompanyPlan ICP
ON ICP.VendorImportID=@VendorImportID AND DC.InsuranceCarrier1=ICP.VendorID
LEFT JOIN #EIP EIP
ON DC.InsuranceCarrier1=EIP.Code
LEFT JOIN CMB2_MWPAT DP
ON DC.Insured1=DP.ChartNumber
Where LTRIM(RTRIM(ISNULL(DC.InsuranceCarrier1,'')))<>'' AND ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) Is Not Null

Insert Into InsurancePolicy(
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
	HolderGEnder,
	HolderPhone,
	HolderDOB,
	HolderSSN,
	VendorID,
	VendorImportID
	)
Select PC.PatientCaseID, PC.PracticeID,
ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) InsuranceCompanPlanID,
LEFT(LTRIM(RTRIM(PolicyNumber2)),32) PolicyNumber, LEFT(LTRIM(RTRIM(GroupNumber2)),32) GroupNumber, 2,
Policy2StartDate PolicyStartDate, Policy2EndDate PolicyEndDate,
Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
Then Case When UPPER(DC.InsuredRelationship2) = 'OTHER' Then 'O'	-- other
When UPPER(DC.InsuredRelationship2) = 'CHILD' Then 'C' 	-- child
When UPPER(DC.InsuredRelationship2) = 'SPOUSE' Then 'U'	-- spouse
Else 'U' End Else 'S' End PatientRelationshipToInsured,
Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
Then DP.LastName Else NULL End HolderLastName,
Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
Then DP.FirstName Else NULL End HolderFirstName,
Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
Then DP.MiddleName Else NULL End HolderMiddleName,
Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
Then DP.Street1 Else NULL End HolderAddressLine1,
Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
Then DP.Street2 Else NULL End HolderAddressLine2,
Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
Then DP.City Else NULL End HolderCity,
Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
Then LEFT(LTRIM(RTRIM(DP.State)),2) Else NULL End HolderState,
Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
Then LEFT(LTRIM(RTRIM(DP.ZipCode)),9) Else NULL End HolderZipCode,
Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
Then Case When DP.GEnder='Female' Then 'F' Else 'M' End Else NULL End HolderGEnder,
Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.Phone1)),10))) Else NULL End HolderPhone,
Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
Then LTRIM(RTRIM(DP.DateOfBirth)) Else NULL End HolderDOB,
Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(DP.SocialSecurityNumber, '-', ''), '+', ''), '/', ''))), 9))) Else NULL End HolderSSN, DC.InsuranceCarrier2, @VendorImportID
From CMB2_MWCAS DC INNER JOIN PatientCase PC
ON PC.VendorImportID=@VendorImportID AND DC.CaseNumber=PC.VendorID
LEFT JOIN InsuranceCompanyPlan ICP
ON ICP.VendorImportID=@VendorImportID AND DC.InsuranceCarrier2=ICP.VendorID
LEFT JOIN #EIP EIP
ON DC.InsuranceCarrier2=EIP.Code
LEFT JOIN CMB2_MWPAT DP
ON DC.Insured2=DP.ChartNumber
Where LTRIM(RTRIM(ISNULL(DC.InsuranceCarrier2,'')))<>'' AND ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) Is Not Null

Insert Into InsurancePolicy(
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
	HolderGEnder,
	HolderPhone,
	HolderDOB,
	HolderSSN,
	VendorID,
	VendorImportID
	)
Select PC.PatientCaseID, PC.PracticeID,
ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) InsuranceCompanPlanID,
PolicyNumber3 PolicyNumber, GroupNumber3 GroupNumber, 3,
Policy3StartDate PolicyStartDate, Policy3EndDate PolicyEndDate,
Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
Then Case When UPPER(DC.InsuredRelationship3) = 'OTHER' Then 'O'	-- other
When UPPER(DC.InsuredRelationship3) = 'CHILD' Then 'C' 	-- child
When UPPER(DC.InsuredRelationship3) = 'SPOUSE' Then 'U'	-- spouse
Else 'U' End Else 'S' End PatientRelationshipToInsured,
Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
Then DP.LastName Else NULL End HolderLastName,
Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
Then DP.FirstName Else NULL End HolderFirstName,
Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
Then DP.MiddleName Else NULL End HolderMiddleName,
Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
Then DP.Street1 Else NULL End HolderAddressLine1,
Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
Then DP.Street2 Else NULL End HolderAddressLine2,
Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
Then DP.City Else NULL End HolderCity,
Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
Then LEFT(LTRIM(RTRIM(DP.State)),2) Else NULL End HolderState,
Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.ZipCode)),9))) Else NULL End HolderZipCode,
Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
Then Case When DP.GEnder='Female' Then 'F' Else 'M' End Else NULL End HolderGEnder,
Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.Phone1)),10))) Else NULL End HolderPhone,
Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
Then LTRIM(RTRIM(DP.DateOfBirth)) Else NULL End HolderDOB,
Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(DP.SocialSecurityNumber, '-', ''), '+', ''), '/', ''))), 9))) Else NULL End HolderSSN, DC.InsuranceCarrier3, @VendorImportID
From CMB2_MWCAS DC INNER JOIN PatientCase PC
ON PC.VendorImportID=@VendorImportID AND DC.CaseNumber=PC.VendorID
LEFT JOIN InsuranceCompanyPlan ICP
ON ICP.VendorImportID=@VendorImportID AND DC.InsuranceCarrier3=ICP.VendorID
LEFT JOIN #EIP EIP
ON DC.InsuranceCarrier3=EIP.Code
LEFT JOIN CMB2_MWPAT DP
ON DC.Insured3=DP.ChartNumber
Where LTRIM(RTRIM(ISNULL(DC.InsuranceCarrier3,'')))<>'' AND ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) Is Not Null

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
Insert Into #PCToUpdate(PatientCaseID)
Select PC.PatientCaseID
From PatientCase PC LEFT JOIN InsurancePolicy IP
ON PC.PatientCaseID=IP.PatientCaseID
Where PC.PracticeID=@PracticeID
GROUP BY PC.PatientCaseID
HAVING COUNT(InsurancePolicyID)=0

UPDATE PC SET PayerScenarioID=11
From PatientCase PC INNER JOIN #PCToUpdate PCU
ON PC.PatientCaseID=PCU.PatientCaseID

-- Edit GroupNumber, PolicyStartDate and PolicyEndDate
UPDATE insurancepolicy
SET GroupNumber = ''
Where VendorImportID = @VendorImportID and UPPER(GroupNumber) = 'NONE'

UPDATE InsurancePolicy
SET PolicyStartDate = NULL
Where PolicyStartDate = '1/1/1900'
AND VendorImportID = @VendorImportID

UPDATE InsurancePolicy
SET PolicyEndDate = NULL
Where PolicyEndDate = '1/1/1900'
AND VendorImportID = @VendorImportID

UPDATE InsurancePolicy
SET HolderDOB = NULL
Where HolderDOB = '1/1/1900'
AND VendorImportID = @VendorImportID

UPDATE InsurancePolicy
SET PolicyStartDate = NULL
Where PolicyStartDate = '1900-01-01 12:00:00.000'
AND VendorImportID = @VendorImportID

UPDATE InsurancePolicy
SET PolicyEndDate = NULL
Where PolicyEndDate = '1900-01-01 12:00:00.000'
AND VendorImportID = @VendorImportID

DROP TABLE #PCToUpdate

DROP TABLE #PG
DROP TABLE #EIC
DROP TABLE #NIC
DROP TABLE #EIP
DROP TABLE #NIP
DROP TABLE #CasesToIgnore
DROP TABLE #ChartNumbersWithTooManyCases
DROP TABLE #DISTINCTCHARTNUMBERS
DROP TABLE #RecentCases

-- ROLLBACK
-- COMMIT

--Select * From VendorIMPORT Order By VendorIMPORTID
/*
Select top 100 * From CMB2_mwcas Where chartnumber = '00000050'
--Select * From patient Where Vendorid = '00000050'
--Select * From patientCase Where patientid = '19835'
Select * From insurancepolicy Where patientCaseid = '20770'

Select top 100 * From CMB2_mwcas Where chartnumber = '00000049'
--Select * From patient Where Vendorid = '00000049'
--Select * From patientCase Where patientid = '19834'
Select * From insurancepolicy Where patientCaseid = '20769'
*/

/*
use superbill_0285_dev
delete From providernumber Where Vendorimportid Is Not Null
delete From insurancepolicy Where Vendorimportid Is Not Null
delete From insurancecompanyplan Where Vendorimportid Is Not Null
delete From insurancecompany Where Vendorimportid Is Not Null
delete From patientCase Where Vendorimportid Is Not Null and [External] = 1
delete From patient Where Vendorimportid Is Not Null
delete From doctor Where Vendorimportid Is Not Null
delete From Vendorimport

Select * From patient Where Vendorimportid Is Not Null
Select * From patientCase Where Vendorimportid Is Not Null
Select * From insurancecompany Where Vendorimportid Is Not Null
Select * From insurancecompanyplan Where Vendorimportid Is Not Null
Select * From insurancepolicy Where Vendorimportid Is Not Null
Select * From doctor Where Vendorimportid Is Not Null
Select * From Vendorimport

Select count(*) From patient Where Vendorimportid Is Not Null
Select count(*) From patientCase Where Vendorimportid Is Not Null
Select count(*) From insurancecompany Where Vendorimportid Is Not Null
Select count(*) From insurancecompanyplan Where Vendorimportid Is Not Null
Select count(*) From insurancepolicy Where Vendorimportid Is Not Null
Select count(*) From doctor Where Vendorimportid Is Not Null
Select count(*) From Vendorimport
*/
--Select * From insurancepolicy
--Select * From CMB2_mwpat Where patienttype = 'Patient'
