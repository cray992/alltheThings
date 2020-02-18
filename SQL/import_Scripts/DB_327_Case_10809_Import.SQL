-- California Medical Billing - Dr. Simpson Import Script.
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

Use superbill_0327_dev
Go

Set NoCount On

Declare	@Rows Int

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
    (
      'Dr. Simpson'
    , 'California Medical Billing'
    , 'MediSoft'
    )

Set @VendorImportID = @@IDENTITY
Set @PracticeID = 1

Print 'Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )
Print ' '

-- Import Physicians.
Insert Into Doctor
    ( PracticeID
      , Prefix
      , FirstName
      , MiddleName
      , LastName
      , Suffix
      , Degree
      , SSN
      -- TaxonomyCode
      , WorkPhone
      , FaxNumber
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , VendorID
      , VendorImportID
      , [External]
      )
Select
    @PracticeID
    , ''
    , Case When FirstName Is Not Null Then LTRIM(RTRIM( FirstName ) ) Else '' End
	, Case When MiddleInitial Is Not Null Then LTRIM(RTRIM( MiddleInitial ) ) Else '' End
	, Case When LastName Is Not Null Then LTRIM(RTRIM(LastName)) Else '' End
	, ''
	, Case When Credentials Is Not Null Then LTRIM(RTRIM(Credentials)) Else '' End
	-- , Case When UPIN Is Not Null Then LTRIM(RTRIM(UPIN)) Else '' End
	, Case When SSNOrFedTaxID Is Not Null Then LTRIM(RTRIM(SSNOrFedTaxID)) Else '' End
	-- , Case When TaxonomyCode Is Not Null Then LTRIM(RTRIM(TaxonomyCode)) Else NULL End
	, Case When Phone Is Not Null Then LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(Phone, '-', ''), '(', ''), ')', ''))) Else '' End
	, Case When Fax Is Not Null Then LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(Fax, '-', ''), '(', ''), ')', ''))) Else '' End
	, Case When Street1 IS NULL Then '' Else LTRIM(RTRIM(Street1)) End
	, Case When Street2 IS NULL Then '' Else LTRIM(RTRIM(Street2)) End
	, Case When City IS NULL Then '' Else LTRIM(RTRIM(City)) End
	, Case When State IS NULL Then '' Else LTRIM(RTRIM(State)) End
	, Case When ZipCode IS NULL Then '' Else LTRIM(RTRIM(REPLACE(ZipCode,'-',''))) End
	, Case When Code IS NULL Then '' Else LTRIM(RTRIM(Code)) End
	, @VendorImportID
	, 0
From CMB1_MWPHY
-- Where Code = 'MS'
-- Order By Code

Select @Rows = @@RowCount
Print Convert( Varchar(20) , @Rows ) + ' rows added in Doctor table for Physicians.'

-- Import Referring Physicians.
-- MWRPH
Insert Into Doctor
    ( PracticeID
      , Prefix
      , FirstName
      , MiddleName
      , LastName
      , Suffix
      , Degree
      , SSN
      -- , TaxonomyCode
	  , WorkPhone
	  , FaxNumber
	  , AddressLine1
	  , AddressLine2
	  , City
	  , State
	  , ZipCode
	  , VendorID
	  , VendorImportID
	  , [External]
    )
Select
    @PracticeID
    , ''
    , Case When FirstName Is Not Null Then LTRIM(RTRIM(FirstName)) Else '' End
	, Case When MiddleInitial Is Not Null Then LTRIM(RTRIM(MiddleInitial)) Else '' End
	, Case When LastName Is Not Null Then LTRIM(RTRIM(LastName)) Else '' End, ''
	, Case When Credentials Is Not Null Then LTRIM(RTRIM(Credentials)) Else '' End
	-- , Case When UPIN Is Not Null Then LTRIM(RTRIM(UPIN)) Else '' End
	, Case When SSNOrFedTaxID Is Not Null Then LTRIM(RTRIM(SSNOrFedTaxID)) Else '' End
	-- , Case When TaxonomyCode Is Not Null Then LTRIM(RTRIM(TaxonomyCode)) Else NULL End
	, Case When Phone Is Not Null Then LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(Phone, '-', ''), '(', ''), ')', ''))) Else '' End
	, Case When Fax Is Not Null Then LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(Fax, '-', ''), '(', ''), ')', ''))) Else '' End
	, Case When Street1 IS NULL Then '' Else LTRIM(RTRIM(Street1)) End
	, Case When Street2 IS NULL Then '' Else LTRIM(RTRIM(Street2)) End
	, Case When City IS NULL Then '' Else LTRIM(RTRIM(City)) End
	, Case When State IS NULL Then '' Else LTRIM(RTRIM(State)) End
	, Case When ZipCode IS NULL Then '' Else LEFT(LTRIM(RTRIM(REPLACE(ZipCode,'-',''))), 9) End
	, Case When Code IS NULL Then '' Else LTRIM(RTRIM(Code)) End
	, @VendorImportID
	, 1
From CMB1_MWRPH
-- Order By Code

Select @Rows = @@RowCount
Print Convert( Varchar(20) , @Rows ) + ' rows added in Doctor table for Referring Physicians.'

-- Insert UPIN for Referring Physicians -- TODO in final data import
Insert Into ProviderNumber
    ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
      , AttachConditionsTypeID
    )
Select
    DoctorID
    , 25
    , LTRIM( RTRIM( UPIN ) )
    , 1
From Doctor D
    Inner Join CMB1_mwrph A
        ON D.VendorImportID = @VendorImportID
             AND D.VendorID = A.Code
Where LTRIM(RTRIM( UPIN ) ) <> '' AND UPIN Is Not Null AND [External] = 1

Select @Rows = @@RowCount
Print Convert( Varchar(20) , @Rows ) + ' rows added in ProviderNumber table.'


/*
-- Exclude all except 10 most recent Cases for each chartnumber
Declare @LOOP INT
Declare @COUNT INT
Declare @CHARTNUMBER VARCHAR(50)
Declare @MAXID INT

CREATE TABLE #CasesToIgnore(CNUM VARCHAR(50))

CREATE TABLE #ChartNumbersWithTooManyCases(CID INT IDENTITY(1,1),CHARTNUM varchar(50), CaseNUM varchar(50))
Insert Into #ChartNumbersWithTooManyCases(CHARTNUM, CaseNUM)
Select chartnumber, Casenumber From CMB1_mwcas
Where chartnumber in (
Select chartnumber
From CMB1_mwcas
GROUP BY chartnumber				--
HAVING count(Casenumber) > 10		--
)
Order By chartnumber, cast(Casenumber as int)
-- Select * From #ChartNumbersWithTooManyCases

CREATE TABLE #DISTINCTCHARTNUMBERS(DCID INT IDENTITY(1,1), CHART VARCHAR(50))
Insert Into #DISTINCTCHARTNUMBERS(CHART)
Select DISTINCT CHARTNUM From #ChartNumbersWithTooManyCases
Order By CHARTNUM

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
*/

-- Patient (note: the same ssn can correspond to more than 1 PatientID, if patient used more than one practice)
-- Insert patients excluding Guarantor (Where Patient Type <> 'Guarantor'
-- Create table with Patients and their Guarantors
Create Table #PG
    ( PatientChartNumber                Varchar(50)
      , GuarantorChartNumber            Varchar(50)
      , ResponsibleDifferentThanPatient Bit
      , ResponsibleFirstName            Varchar(50)
      , ResponsibleMiddleName           Varchar(50)
      , ResponsibleLastName             Varchar(50)
      , ResponsibleAddressLine1         Varchar(50)
      , ResponsibleAddressLine2         Varchar(50)
      , ResponsibleCity                 Varchar(50)
      , ResponsibleState                Varchar(50)
      , ResponsibleZipCode              Varchar(50)
      , ResponsibleRelationsipToPatient Varchar(50)
      , CaseNumber                      Varchar(50)
    )

Insert Into #PG
    ( PatientChartNumber
      , GuarantorChartNumber
      , ResponsibleDifferentThanPatient
      , ResponsibleFirstName
      , ResponsibleMiddleName
      , ResponsibleLastName
      , ResponsibleAddressLine1
      , ResponsibleAddressLine2
      , ResponsibleCity
      , ResponsibleState
      , ResponsibleZipCode
      , ResponsibleRelationsipToPatient
      , CaseNumber
    )
Select Distinct
    LTRIM( RTRIM( CAS.ChartNumber ) )
    , LTRIM( RTRIM( CAS.Guarantor ) )
    , 1
    , LTRIM( RTRIM( PAT.FirstName ) )
    , Case When ( PAT.MiddleName IS NULL) Then '' Else LTRIM(RTRIM( PAT.MiddleName ) ) End
	, LTrim( RTrim( PAT.LastName ) )
	, Case When pat.Street1 IS NULL Then '' Else LTRIM(RTRIM( pat.Street1 ) ) End
	, Case When pat.Street2 IS NULL Then '' Else LTRIM(RTRIM( pat.Street2 ) ) End
	, Case When pat.City IS NULL Then '' Else LTRIM(RTRIM( pat.City ) ) End
	, Case When pat.State IS NULL Then '' Else LTRIM(RTRIM( pat.State ) ) End
	, Case When pat.ZipCode IS NULL Then '' Else LTRIM( RTRIM( REPLACE( ZipCode , '-' , '' ) ) ) End
	, 'U'
	, cas.CaseNumber
From CMB1_MWPAT PAT
    Inner Join CMB1_MWCAS CAS On CAS.Guarantor = PAT.ChartNumber
Where CAS.ChartNumber <> CAS.Guarantor

-- Delete duplicate patients with guarantors; use guarantor listed for the most recent Case
Delete From #PG
Where Exists
	( Select * From #PG As PG
    	Where PG.PatientChartNumber= #PG.PatientChartNumber
    	        And CAST( pg.CaseNumber AS INT ) > CAST( #PG.CaseNumber AS INT ) )

-- Import Patients.
Insert Into Patient
    ( VendorImportID
      , VendorID
      , PracticeID
      , Prefix
      , FirstName
      , MiddleName
      , LastName
      , Suffix
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , Gender
      , MaritalStatus
      , HomePhone
      , WorkPhone
      , WorkPhoneExt
      , DOB
      , SSN
      , ResponsibleDifferentThanPatient
      , ResponsibleFirstName
      , ResponsibleMiddleName
      , ResponsibleLastName
      , ResponsibleAddressLine1
      , ResponsibleAddressLine2
      , ResponsibleCity
      , ResponsibleState
      , ResponsibleZipCode
      , PrimaryProviderID
      , MobilePhone
    )
Select
    @VendorImportID
    , pat.ChartNumber
    , @PracticeID
    -- , pg.PatientChartNumber
    -- , pg.GuarantorChartNumber
	, ''
	, Case When pat.FirstName IS NULL Then '' Else LTRIM(RTRIM(pat.FirstName)) End
	, Case When pat.MiddleName IS NULL Then '' Else LTRIM(RTRIM(pat.MiddleName)) End
	, Case When pat.LastName IS NULL Then '' Else LTRIM(RTRIM(pat.LastName)) End
	, ''
	, Case When pat.Street1 IS NULL Then '' Else LTRIM(RTRIM(pat.Street1)) End
	, Case When pat.Street2 IS NULL Then '' Else LTRIM(RTRIM(pat.Street2)) End
	, Case When pat.City Is Not Null Then LTRIM(RTRIM(pat.City)) Else '' End
	, Case When pat.State Is Not Null AND LEN(LTRIM(RTRIM(pat.State))) < 3 Then LTRIM(RTRIM(pat.State)) Else NULL End
	, Case When pat.ZipCode Is Not Null AND LTRIM(RTRIM(pat.ZipCode)) <> '' Then LEFT(LTRIM(RTRIM(REPLACE(ZipCode,'-',''))), 9) Else NULL End
	, Case When LTRIM(RTRIM(pat.GEnder)) = 'Male' Then 'M'
     		When LTRIM(RTRIM(pat.GEnder)) = 'Female' Then 'F'
     		Else 'U' End
	, 'U'
	-- MariatalStatus not available in patients table
	, Case When pat.Phone1 Is Not Null AND LTRIM(RTRIM(pat.Phone1)) <> '' Then LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.Phone1, '-', ''), '(', ''), ')', ''))), 10) Else '' End
	, Case When pat.WorkPhone Is Not Null AND LTRIM(RTRIM(pat.WorkPhone)) <> '' Then LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.WorkPhone, '-', ''), '(', ''), ')', ''))), 10) Else '' End
	, Case When pat.WorkExtension Is Not Null AND LTRIM(RTRIM(pat.WorkExtension)) <> '' Then LEFT(LTRIM(RTRIM(pat.WorkExtension)), 10) End
	, Case When (pat.DateOfBirth Is Not Null AND LTRIM(RTRIM(pat.DateOfBirth)) <> '' AND ISDATE(LTRIM(RTRIM(pat.DateOfBirth))) = 1) Then CAST(LTRIM(RTRIM(pat.DateOfBirth)) AS DATETIME) Else NULL End
	, Case When (pat.SocialSecurityNumber Is Not Null AND LTRIM(RTRIM(pat.SocialSecurityNumber)) <> '') Then LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.SocialSecurityNumber, '-', ''), '+', ''), '/', ''))), 9) Else NULL End
	, Case When pg.PatientChartNumber Is Not Null Then 1 Else 0 End
	, Case When pg.PatientChartNumber Is Not Null Then pg.ResponsibleFirstName Else NULL End
	, Case When pg.PatientChartNumber Is Not Null Then pg.ResponsibleMiddleName Else NULL End
	, Case When pg.PatientChartNumber Is Not Null Then pg.ResponsibleLastName Else NULL End
	, Case When pg.PatientChartNumber Is Not Null Then pg.ResponsibleAddressLine1 Else NULL End
	, Case When pg.PatientChartNumber Is Not Null Then pg.ResponsibleAddressLine2 Else NULL End
	, Case When pg.PatientChartNumber Is Not Null Then pg.ResponsibleCity Else NULL End
	, Case When pg.PatientChartNumber Is Not Null Then pg.ResponsibleState Else NULL End
	, Case When pg.PatientChartNumber Is Not Null AND LTRIM(RTRIM(pg.PatientChartNumber)) <> '' Then LEFT(pg.ResponsibleZipCode, 9) Else NULL End, NULL
	, Case When pat.Phone2 Is Not Null AND LTRIM(RTRIM(pat.Phone2)) <> '' Then LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(pat.Phone2, '-', ''), '(', ''), ')', ''))), 10) Else '' End
From CMB1_MWPAT PAT
    Left Join #PG PG On PAT.ChartNumber = PG.PatientChartNumber
Where UPPER( LTRIM( RTRIM( PAT.PatientType ) ) ) <> 'Guarantor'
		And PAT.ChartNumber Not In ( 'BAUKE000' , 'DOVER000' , 'GAEGR000' , 'GILMA001' , 'HAM00000' , 'HENDA001' , 'JOHKI001' , 'JONBI000' , 'METTA001' )
-- The above chart numbers are duplicate patients. Import only one patient record for a duplicate record.

Select @Rows = @@RowCount
Print Convert( Varchar(20) , @Rows ) + ' rows added in Patient table.'

Declare @RefToPatient TABLE
    ( ChartNumber            VARCHAR(50)
      , ReferringProvider   VARCHAR(50)
    )

Insert @RefToPatient
    ( ChartNumber
      , ReferringProvider
    )
Select Distinct
    ChartNumber
    , ReferringProvider
From CMB1_MWCAS
Where LEN( ReferringProvider ) > 0

Update P
    SET ReferringPhysicianID = D.DoctorID
    From Patient P INNER JOIN @RefToPatient RTP
        ON P.VendorImportID = @VendorImportID AND P.VendorID = RTP.ChartNumber
        INNER JOIN Doctor D ON D.VendorImportID = @VendorImportID AND RTP.ReferringProvider = D.VendorID

-- InsuranceCompany
-- MWINS - Assume that insurance company is the same as insuranceplan
-- Create temporary table to hold insurance companies that already exist in InsuranceCompany table
CREATE TABLE #EIC
    ( InsuranceCompanyID            Int
      , InsuranceCompanyName        varchar(255)
      , AddressLine1                varchar(255)
      , AddressLine2                varchar(255)
      , City                        varchar(255)
      , State                       varchar(255)
      , ZipCode                     varchar(255)
      , Phone                       varchar(255)
      , PhoneExt                    varchar(255)
      , ReviewCode                  varchar(255)
      , Code                        varchar(255)
    )

Insert Into #EIC
    ( InsuranceCompanyID
      , InsuranceCompanyName
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , Phone
      , PhoneExt
      , ReviewCode
      , Code
    )
Select Max( ico.InsuranceCompanyID ) InsuranceCompanyID
        , ic.Name
        , ic.Street1
        , ic.Street2
        , ic.City
        , ic.State
        , ic.ZipCode
        , ic.Phone
        , ic.Extension
        , ico.ReviewCode
        , ic.Code
From CMB1_MWINS ic
    Join InsuranceCompany ico On LTRIM( RTRIM( ico.InsuranceCompanyName ) ) = LTRIM( RTRIM( ic.Name ) )
Where LTRIM(RTRIM( ico.City ) ) = LTRIM(RTRIM( ic.City ) )
        AND LEFT(ico.ZipCode, 5) = LEFT(ic.ZipCode, 5)
    	AND LTRIM(RTRIM(ico.State)) = LTRIM(RTRIM(ic.State))
    	AND LTRIM(RTRIM(ico.InsuranceCompanyName)) = LTRIM(RTRIM(ic.Name))
    	AND REPLACE(REPLACE(ico.AddressLine1, ' ', ''), '.', '') = REPLACE(REPLACE(ic.Street1, ' ', ''), '.', '')
GROUP BY ic.Name, ic.Street1, ic.Street2, ic.City, ic.State, ic.ZipCode, ic.Phone, ic.Extension, ico.ReviewCode, ic.Code

-- Store insurance companies that do not exist in InsuranceCompany table in another temporary table #NIC
CREATE TABLE #NIC
    ( Code                      varchar(255)
      , InsuranceCompanyName    varchar(255)
      , AddressLine1            varchar(255)
      , AddressLine2            varchar(255)
      , City                    varchar(255)
      , State                   varchar(255)
      , ZipCode                 varchar(255)
      , Phone                   varchar(255)
      , PhoneExt                varchar(255)
      , ReviewCode              varchar(255)
    )

Insert Into #NIC
    ( Code
      , InsuranceCompanyName
      , AddressLine1
      , AddressLine2
      , City, State
      , ZipCode
      , Phone
      , PhoneExt
      , ReviewCode
      )
Select
      ic.Code
      , ic.Name
      , ic.Street1
      , ic.Street2
      , ic.City
      , ic.State
      , ic.ZipCode
      , ic.Phone
      , ic.Extension
      , 'R'
From CMB1_MWINS ic
Where ic.Code Not In ( Select Code From #EIC )

-- Insert Into InsuranceCompany those ins.companies that do not already exist
Insert Into InsuranceCompany
    ( VendorID
      , VendorImportID
      , InsuranceCompanyName
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , Phone
      , PhoneExt
      , ReviewCode
    )
Select
    LTRIM(RTRIM(Code))
    , @VendorImportID
    , LTRIM(RTRIM(InsuranceCompanyName))
	, LTRIM(RTRIM(AddressLine1))
	, LTRIM(RTRIM(AddressLine2))
	, LTRIM(RTRIM(City))
	, LTRIM(RTRIM(State))
	, Case When ZipCode Is Not Null AND LTRIM(RTRIM(ZipCode)) <> '' Then LEFT(LTRIM(RTRIM(REPLACE(REPLACE(ZipCode,'-',''), ' ', ''))), 9) Else NULL End
	, Case When Phone Is Not Null AND LTRIM(RTRIM(Phone)) <> '' Then LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Phone,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10) Else NULL End
	, Case When PhoneExt IS NULL Then '' Else LTRIM(RTRIM(LEFT(PhoneExt, 10))) End
	, 'R'
From #NIC

Select @Rows = @@RowCount
Print Convert( Varchar(20) , @Rows ) + ' rows added in InsuranceCompany table.'

-- InsuranceCompanyPlan
-- Insert plans that do not already exist  in InsuranceCompanyPlan
-- 1) find which ones exist;  Code - same as InsuranceCarrier #1, #2 and 3# in MWCAS)
-- Existing InsuranceCompanyPlans
CREATE TABLE #EIP
    ( InsuranceCompanyPlanID    int
      , Code                    varchar(255)
      , PlanName                varchar(255)
      , AddressLine1            varchar(255)
      , AddressLine2            varchar(255)
      , City                    varchar(255)
      , State                   varchar(255)
      , ZipCode                 varchar(255)
      , Phone                   varchar(255)
      , PhoneExt                varchar(255)
    )

-- Insert plans that already exist in InsuranceCompanyPlan table
Insert Into #EIP
( InsuranceCompanyPlanID
  , Code
  , PlanName
  , AddressLine1
  , AddressLine2
  , City
  , State
  , ZipCode
  , Phone
  , PhoneExt
  )
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
From CMB1_MWINS ip
 JOIN InsuranceCompanyPlan icp ON LTRIM(RTRIM(icp.PlanName)) = LTRIM(RTRIM(ip.Name))
	Where LTRIM(RTRIM(icp.City)) = LTRIM(RTRIM(ip.City))
	        AND LTRIM(RTRIM(icp.State)) = LTRIM(RTRIM(ip.State))
        	AND LEFT(icp.ZipCode, 5) = LEFT(ip.ZipCode, 5)
        	AND LTRIM(RTRIM(icp.PlanName)) = LTRIM(RTRIM(ip.Name))
        	AND REPLACE(REPLACE(icp.AddressLine1, ' ', ''), '.', '') = REPLACE(REPLACE(ip.Street1, ' ', ''), '.', '')
GROUP BY LTRIM(RTRIM(ip.Code)),
	LTRIM(RTRIM(ip.Name)),
	LTRIM(RTRIM(ip.Street1)),
	LTRIM(RTRIM(ip.Street2)),
	LTRIM(RTRIM(ip.City)),
	LEFT(LTRIM(RTRIM(ip.State)), 2),
	LTRIM(RTRIM(REPLACE(ip.ZipCode,'-',''))),
	LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Phone,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10))),
	LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ip.Extension,'-',''), '(', ''), ')', ''), ' ', ''), '-', ''))), 10)))

-- Create temporary table with plans that do not exist in InsuranceCompanyPlan table
CREATE TABLE #NIP
    ( Code                  varchar(255)
      , PlanName            varchar(255)
      , InsuranceCompanyID  int
      , AddressLine1        varchar(255)
      , AddressLine2        varchar(255)
      , City                varchar(255)
      , State               varchar(255)
      , ZipCode             varchar(255)
      , Phone               varchar(255)
      , PhoneExt            varchar(255)
    )

Insert Into #NIP			-- Insert plans that do not already exist in InsuranceCompanyPlan table
( Code
  , PlanName
  , InsuranceCompanyID
  , AddressLine1
  , AddressLine2
  , City
  , State
  , ZipCode
  , Phone
  , PhoneExt
  )
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
From CMB1_MWINS ip
    LEFT JOIN InsuranceCompany ic on ic.VendorImportID=@VendorImportID and ip.Code=ic.VendorID
    LEFT JOIN #EIC eic on ip.code=eic.Code
Where ip.Code NOT IN ( Select Code From #EIP )
Order By ip.Name

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

Select @Rows = @@RowCount
Print Convert( Varchar(20) , @Rows ) + ' rows added in InsuranceCompanyPlan table.'

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
From Patient P INNER JOIN CMB1_MWCAS DC
ON P.VendorID=DC.ChartNumber
Where VendorID Is Not Null -- VendorID is ChartNumber
	AND VendorImportID=@VendorImportID
	AND PracticeID=@PracticeID
	AND DC.CaseNumber NOT IN (Select CNUM From #CasesToIgnore) -- Exclude all but 10 most recent Casenumbers
*/

-- Ashish - 06/15/2006.
Select chartnumber
	   , Convert( Varchar(50) , Max( Convert( int , casenumber ) ) ) As casenumber Into #RecentCases
	From cmb1_mwcas
	Group By chartnumber
	Order By chartnumber

Insert Into PatientCase
( PatientID
  , Name
  , PracticeID
  , PayerScenarioID
  , VendorID
  , VendorImportID
  , ReferringPhysicianID
  , EmploymentRelatedFlag
  , AutoAccidentRelatedFlag
  , AutoAccidentRelatedState
  , Notes
)
Select
    P.PatientID
    , Description
    , P.PracticeID
    , 5
    , DC.CaseNumber
    , @VendorImportID
    , P.ReferringPhysicianID
    , Case When UPPER(LTRIM(RTRIM( DC.RelatedToEmployment ) ) ) = 'TRUE' Then 1 Else 0 End
    , Case When UPPER(LTRIM(RTRIM( DC.RelatedToAccident ) ) ) = 'AUTO' Then 1 Else 0 End
    , DC.AccidentState
    , DC.Notes
From Patient P
	Inner Join CMB1_MWCAS DC ON P.VendorID = DC.ChartNumber
	Inner Join #RecentCases RC On DC.ChartNumber = RC.ChartNumber And DC.CaseNumber = RC.CaseNumber
Where VendorID Is Not Null
	AND VendorImportID = @VendorImportID
	AND PracticeID = @PracticeID

Select @Rows = @@RowCount
Print Convert( Varchar(20) , @Rows ) + ' rows added in PatientCase table.'

-- Create Default Patient Cases for patients with no chartnumber in mwcas table
Insert Into
	PatientCase(PatientID, name, PayerScenarioID, ReferringPhysicianID, PracticeID, VendorID, VendorImportID)
Select
	p.PatientID, 'Default Case', 5, p.ReferringPhysicianID, @PracticeID, p.VendorID, @VendorImportID
From Patient P
Where P.VendorImportID = @VendorImportID
		And P.VendorID NOT IN (Select DISTINCT ChartNumber From CMB1_mwcas)

Select @Rows = @@RowCount
Print Convert( Varchar(20) , @Rows ) + ' rows added in PatientCase table for default case.'

CREATE INDEX IX_PatientCase_VendorID ON PatientCase (VendorID)

CREATE INDEX IX_InsuranceCompanyPlan_VendorID ON InsuranceCompanyPlan (VendorID)

IF  EXISTS (Select * From sys.indexes Where object_id = OBJECT_ID(N'[dbo].[InsurancePolicy]')
                AND name = N'CI_InsurancePolicy_PracticeID_InsurancePolicyID')
    DROP INDEX [CI_InsurancePolicy_PracticeID_InsurancePolicyID] ON [dbo].[InsurancePolicy] WITH ( ONLINE = OFF )

IF  EXISTS (Select * From sys.indexes Where object_id = OBJECT_ID(N'[dbo].[InsurancePolicy]')
                AND name = N'IX_InsurancePolicy_InsuranceCompanyPlanID')
    DROP INDEX [IX_InsurancePolicy_InsuranceCompanyPlanID] ON [dbo].[InsurancePolicy] WITH ( ONLINE = OFF )

IF  EXISTS (Select * From sys.indexes Where object_id = OBJECT_ID(N'[dbo].[InsurancePolicy]') AND name = N'IX_InsurancePolicy_PatientCaseID')
    DROP INDEX [IX_InsurancePolicy_PatientCaseID] ON [dbo].[InsurancePolicy] WITH ( ONLINE = OFF )

-- Insurance Carrier 1.
Insert Into InsurancePolicy
   ( PatientCaseID
	, PracticeID
	, InsuranceCompanyPlanID
	, PolicyNumber
	, GroupNumber
	, Precedence
	, PolicyStartDate
	, PolicyEndDate
	, PatientRelationshipToInsured
	, HolderLastName
	, HolderFirstName
	, HolderMiddleName
	, HolderAddressLine1
	, HolderAddressLine2
	, HolderCity
	, HolderState
	, HolderZipCode
	, HolderGEnder
	, HolderPhone
	, HolderDOB
	, HolderSSN
	, VendorID
	, VendorImportID
	)
Select
    PC.PatientCaseID
    , PC.PracticeID
    , ISNULL(EIP.InsuranceCompanyPlanID , ICP.InsuranceCompanyPlanID) InsuranceCompanPlanID
    , LEFT(LTRIM(RTRIM(PolicyNumber1)),32) PolicyNumber
    , LEFT(LTRIM(RTRIM(GroupNumber1)),32) GroupNumber
    , 1
    , Policy1StartDate PolicyStartDate
    , Policy1EndDate PolicyEndDate
    , Case When ISNULL(DC.Insured1,'') <> LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'') <> '' Then
        Case When UPPER(DC.InsuredRelationship1) = 'OTHER' Then 'O'	-- other
        When UPPER(DC.InsuredRelationship1) = 'CHILD' Then 'C' 	-- child
        When UPPER(DC.InsuredRelationship1) = 'SPOUSE' Then 'U'	-- spouse
            Else 'U' End Else 'S' End PatientRelationshipToInsured
    , Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
            Then DP.LastName Else NULL End HolderLastName
    , Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
            Then DP.FirstName Else NULL End HolderFirstName
    , Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
            Then DP.MiddleName Else NULL End HolderMiddleName
    , Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
            Then DP.Street1 Else NULL End HolderAddressLine1
    , Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
            Then DP.Street2 Else NULL End HolderAddressLine2
    , Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
            Then DP.City Else NULL End HolderCity
    , Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
            Then LEFT(LTRIM(RTRIM(DP.State)),2) Else NULL End HolderState
    , Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
            Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.ZipCode)),9))) Else NULL End HolderZipCode
    , Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
            Then Case When DP.GEnder='Female' Then 'F' Else 'M' End Else NULL End HolderGEnder
    , Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
            Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.Phone1)),10))) Else NULL End HolderPhone
    , Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
            Then LTRIM(RTRIM(DP.DateOfBirth)) Else NULL End HolderDOB
    , Case When ISNULL(DC.Insured1,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured1,'')<>''
            Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(DP.SocialSecurityNumber, '-', ''), '+', ''), '/', ''))), 9))) Else NULL End HolderSSN
    , DC.InsuranceCarrier1
    , @VendorImportID
From CMB1_MWCAS DC
    INNER JOIN PatientCase PC ON PC.VendorImportID = @VendorImportID AND DC.CaseNumber = PC.VendorID
    LEFT JOIN InsuranceCompanyPlan ICP ON ICP.VendorImportID=@VendorImportID AND DC.InsuranceCarrier1=ICP.VendorID
    LEFT JOIN #EIP EIP ON DC.InsuranceCarrier1=EIP.Code
    LEFT JOIN CMB1_MWPAT DP ON DC.Insured1=DP.ChartNumber
Where LTRIM(RTRIM(ISNULL(DC.InsuranceCarrier1,'')))<>'' AND ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) Is Not Null

Select @Rows = @@RowCount
Print Convert( Varchar(20) , @Rows ) + ' rows added in InsurancePolicy table for Primary Insurance.'

-- Insurance Carrier 2.
Insert Into InsurancePolicy
   ( PatientCaseID
     , PracticeID
     , InsuranceCompanyPlanID
     , PolicyNumber
     , GroupNumber
     , Precedence
     , PolicyStartDate
     , PolicyEndDate
     , PatientRelationshipToInsured
     , HolderLastName
	 , HolderFirstName
     , HolderMiddleName
	 , HolderAddressLine1
	 , HolderAddressLine2
	 , HolderCity
	 , HolderState
	 , HolderZipCode
	 , HolderGEnder
	 , HolderPhone
	 , HolderDOB
	 , HolderSSN
	 , VendorID
	 , VendorImportID
	)
Select
    PC.PatientCaseID
    , PC.PracticeID
    , ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) InsuranceCompanPlanID
    , LEFT(LTRIM(RTRIM(PolicyNumber2)),32) PolicyNumber
    , LEFT(LTRIM(RTRIM(GroupNumber2)),32) GroupNumber
    , 2
    , Policy2StartDate PolicyStartDate
    , Policy2EndDate PolicyEndDate
    , Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
        Then Case
            When UPPER(DC.InsuredRelationship2) = 'OTHER' Then 'O'	-- other
            When UPPER(DC.InsuredRelationship2) = 'CHILD' Then 'C' 	-- child
            When UPPER(DC.InsuredRelationship2) = 'SPOUSE' Then 'U'	-- spouse
            Else 'U' End Else 'S' End PatientRelationshipToInsured
    , Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
        Then DP.LastName Else NULL End HolderLastName
    , Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
        Then DP.FirstName Else NULL End HolderFirstName
    , Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
        Then DP.MiddleName Else NULL End HolderMiddleName
    , Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
        Then DP.Street1 Else NULL End HolderAddressLine1
    , Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
        Then DP.Street2 Else NULL End HolderAddressLine2
    , Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
        Then DP.City Else NULL End HolderCity
    , Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
        Then LEFT(LTRIM(RTRIM(DP.State)),2) Else NULL End HolderState
    , Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
        Then LEFT(LTRIM(RTRIM(DP.ZipCode)),9) Else NULL End HolderZipCode
    , Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
        Then Case When DP.GEnder='Female' Then 'F' Else 'M' End Else NULL End HolderGEnder
    , Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
        Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.Phone1)),10))) Else NULL End HolderPhone
    , Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
        Then LTRIM(RTRIM(DP.DateOfBirth)) Else NULL End HolderDOB
    , Case When ISNULL(DC.Insured2,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured2,'')<>''
        Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(DP.SocialSecurityNumber, '-', ''), '+', ''), '/', ''))), 9))) Else NULL End HolderSSN
    , DC.InsuranceCarrier2
    , @VendorImportID
From CMB1_MWCAS DC
    INNER JOIN PatientCase PC ON PC.VendorImportID = @VendorImportID AND DC.CaseNumber = PC.VendorID
    LEFT JOIN InsuranceCompanyPlan ICP ON ICP.VendorImportID = @VendorImportID AND DC.InsuranceCarrier2 = ICP.VendorID
    LEFT JOIN #EIP EIP ON DC.InsuranceCarrier2 = EIP.Code
    LEFT JOIN CMB1_MWPAT DP ON DC.Insured2=DP.ChartNumber
Where LTRIM(RTRIM(ISNULL(DC.InsuranceCarrier2,'')))<>'' AND ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) Is Not Null

Select @Rows = @@RowCount
Print Convert( Varchar(20) , @Rows ) + ' rows added in InsurancePolicy table for Secondary Insurance.'

-- Insurance Carrier 3.
Insert Into InsurancePolicy
   ( PatientCaseID
	, PracticeID
	, InsuranceCompanyPlanID
	, PolicyNumber
	, GroupNumber
	, Precedence
	, PolicyStartDate
	, PolicyEndDate
	, PatientRelationshipToInsured
	, HolderLastName
	, HolderFirstName
	, HolderMiddleName
	, HolderAddressLine1
	, HolderAddressLine2
	, HolderCity
	, HolderState
	, HolderZipCode
	, HolderGEnder
	, HolderPhone
	, HolderDOB
	, HolderSSN
	, VendorID
	, VendorImportID
	)
Select
    PC.PatientCaseID
    , PC.PracticeID
    , ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) InsuranceCompanPlanID
    , PolicyNumber3 PolicyNumber
    , GroupNumber3 GroupNumber
    , 3
    , Policy3StartDate PolicyStartDate
    , Policy3EndDate PolicyEndDate
    , Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
        Then Case
                When UPPER(DC.InsuredRelationship3) = 'OTHER' Then 'O'	-- other
                When UPPER(DC.InsuredRelationship3) = 'CHILD' Then 'C' 	-- child
                When UPPER(DC.InsuredRelationship3) = 'SPOUSE' Then 'U'	-- spouse
                Else 'U' End Else 'S' End PatientRelationshipToInsured
    , Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
        Then DP.LastName Else NULL End HolderLastName
    , Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
        Then DP.FirstName Else NULL End HolderFirstName
    , Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
        Then DP.MiddleName Else NULL End HolderMiddleName
    , Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
        Then DP.Street1 Else NULL End HolderAddressLine1
    , Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
        Then DP.Street2 Else NULL End HolderAddressLine2
    , Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
        Then DP.City Else NULL End HolderCity
    , Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
        Then LEFT(LTRIM(RTRIM(DP.State)),2) Else NULL End HolderState
    , Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
        Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.ZipCode)),9))) Else NULL End HolderZipCode
    , Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
        Then Case When DP.GEnder='Female' Then 'F' Else 'M' End Else NULL End HolderGEnder
    , Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
        Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(DP.Phone1)),10))) Else NULL End HolderPhone
    , Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
        Then LTRIM(RTRIM(DP.DateOfBirth)) Else NULL End HolderDOB
    , Case When ISNULL(DC.Insured3,'')<>LTRIM(RTRIM(DC.ChartNumber)) AND ISNULL(DC.Insured3,'')<>''
        Then LTRIM(RTRIM(LEFT(LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(DP.SocialSecurityNumber, '-', ''), '+', ''), '/', ''))), 9))) Else NULL End HolderSSN
    , DC.InsuranceCarrier3
    , @VendorImportID
From CMB1_MWCAS DC
    INNER JOIN PatientCase PC ON PC.VendorImportID = @VendorImportID AND DC.CaseNumber = PC.VendorID
    LEFT JOIN InsuranceCompanyPlan ICP ON ICP.VendorImportID = @VendorImportID AND DC.InsuranceCarrier3 = ICP.VendorID
    LEFT JOIN #EIP EIP ON DC.InsuranceCarrier3=EIP.Code
    LEFT JOIN CMB1_MWPAT DP ON DC.Insured3=DP.ChartNumber
Where LTRIM(RTRIM(ISNULL(DC.InsuranceCarrier3,'')))<>'' AND ISNULL(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) Is Not Null

Select @Rows = @@RowCount
Print Convert( Varchar(20) , @Rows ) + ' rows added in InsurancePolicy table for Tertiary Insurance.'

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
-- DROP TABLE #CasesToIgnore
-- DROP TABLE #ChartNumbersWithTooManyCases
-- DROP TABLE #DISTINCTCHARTNUMBERS
DROP TABLE #RecentCases

-- ROLLBACK
-- COMMIT

Set NoCount Off
