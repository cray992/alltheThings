--USE superbill_0881_prod

-- Customer  : Case 15236 :- Inland Pulmonary Medical Group. (0327)
-- Practices :

-- Case ID   : 15236

-- Tables Populated.
-- =================
-- 1. Doctor
-- 2. Patient
-- 3. PatientCase
-- 4. InsuranceCompany
-- 5. InsuranceCompanyPlan
-- 6. InsurancePolicy

-- Important.
-- ==========
-- Make sure that the synonymn are created for each PRACTICE before running this script.
-- Make sure to run another import script before running this script to add employers to the employers table
-- and attorneys to the attorneys table.


DECLARE @tablesForColumnSearch TABLE (Name varchar(256), ColumnName varchar(256), ColumnType varchar(100))
INSERT INTO @tablesForColumnSearch VALUES ('Practice','VendorImportID','int')
INSERT INTO @tablesForColumnSearch VALUES ('InsuranceCompany','VendorID','varchar(50)')
INSERT INTO @tablesForColumnSearch VALUES ('InsuranceCompany','VendorImportID','int')
INSERT INTO @tablesForColumnSearch VALUES ('InsuranceCompanyPlan','VendorID','varchar(50)')
INSERT INTO @tablesForColumnSearch VALUES ('InsuranceCompanyPlan','VendorImportID','int')
INSERT INTO @tablesForColumnSearch VALUES ('Employers','VendorID','varchar(50)')
INSERT INTO @tablesForColumnSearch VALUES ('Employers','VendorImportID','int')
INSERT INTO @tablesForColumnSearch VALUES ('Doctor','VendorID','varchar(50)')
INSERT INTO @tablesForColumnSearch VALUES ('Doctor','VendorImportID','int')
INSERT INTO @tablesForColumnSearch VALUES ('Patient','VendorID','varchar(50)')
INSERT INTO @tablesForColumnSearch VALUES ('Patient','VendorImportID','int')
INSERT INTO @tablesForColumnSearch VALUES ('PatientCase','VendorID','varchar(50)')
INSERT INTO @tablesForColumnSearch VALUES ('PatientCase','VendorImportID','int')
INSERT INTO @tablesForColumnSearch VALUES ('InsurancePolicy','VendorID','varchar(50)')
INSERT INTO @tablesForColumnSearch VALUES ('InsurancePolicy','VendorImportID','int')
INSERT INTO @tablesForColumnSearch VALUES ('ServiceLocation','VendorID','varchar(50)')
INSERT INTO @tablesForColumnSearch VALUES ('ServiceLocation','VendorImportID','int')

--INSERT INTO @tablesForColumnSearch VALUES ('lytec_insurance','InsuranceCompanyID','int')
--INSERT INTO @tablesForColumnSearch VALUES ('lytec_insurance','InsuranceCompanyPlanID','int')

DECLARE @searchTable varchar(256)
DECLARE @searchColumnName varchar(256)
DECLARE @searchColumnType varchar(100)
DECLARE @searchSQL varchar(max)

DECLARE TableSearch CURSOR FOR
SELECT Name, ColumnName, ColumnType FROM @tablesForColumnSearch

OPEN TableSearch

FETCH NEXT FROM TableSearch INTO @searchTable, @searchColumnName, @searchColumnType

WHILE @@FETCH_STATUS = 0
	BEGIN
		IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id(@searchTable) and name=@searchColumnName)
		BEGIN
			SET @searchSQL = 'ALTER TABLE {0} ADD {1} {2}'
			SET @searchSQL = REPLACE(@searchSQL,'{0}',@searchTable)
			SET @searchSQL = REPLACE(@searchSQL,'{1}',@searchColumnName)
			SET @searchSQL = REPLACE(@searchSQL,'{2}',@searchColumnType)
			EXEC (@searchSQL)
			PRINT 'Added column ' + @searchColumnName + ' to table ' + @searchTable
		END

		FETCH NEXT FROM TableSearch INTO @searchTable, @searchColumnName, @searchColumnType
	END
CLOSE TableSearch
DEALLOCATE TableSearch
GO


-- SQL Function for parsing numbers and getting rid of special characters.
IF  EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT') )
BEGIN
	DROP FUNCTION [dbo].[fn_GetNumber]
	PRINT 'FUNCTION fn_GetNumber DROPPED...'
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_GetNumber( @string Varchar(255) )
RETURNS Varchar(20)
AS
Begin
	
	Declare @number Varchar(20)

	Select @string = Replace( @string , '(' , '' )
	Select @string = Replace( @string , ')' , '' )
	Select @string = Replace( @string , '-' , '' )
	Select @string = Replace( @string , ' ' , '' )
	Select @string = Replace( @string , ',' , '' )
	Select @string = Replace( @string , '.' , '' )
	Select @string = Replace( @string , '$' , '' )
	Select @string = Replace( @string , '%' , '' )

	If LTrim( RTrim( @string ) ) = ''
		Select @string = Null

	Select @number = Left( @string , 20 )

	Return @number
End
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	PRINT 'FUNCTION fn_GetNumber CREATED...'
GO

--sp_addlinkedserver kdev01

    Drop Synonym iPatient
    Go
    Drop Synonym iPatientCase
    Go
    Drop Synonym iDoctor
    Go
    Drop Synonym iRefPhy
    Go
    Drop Synonym iInsCompany
    Go
    Drop Synonym iAddress
    Go

    -- ================================================
    Create Synonym iPatient For superbill_0881_prod.dbo.impMWPAT15236
    Go
    Create Synonym iPatientCase For superbill_0881_prod.dbo.impMWCAS15236
    Go
    Create Synonym iDoctor For superbill_0881_prod.dbo.impMWPHY15236
    Go
    Create Synonym iRefPhy For superbill_0881_prod.dbo.impMWRPH15236
    Go
    Create Synonym iInsCompany For superbill_0881_prod.dbo.impMWINS15236
    Go
    Create Synonym iAddress For superbill_0881_prod.dbo.impMWADD15236
    Go


--    Insert Into Practice
--    ( [Name] )
--    Select [Name] 
--        From superbill_0847_prod.dbo.Practice
--
--    Select * From Practice


Set NoCount On

Declare @Rows               Int
        , @Message          Varchar(75)
        , @PracticeID       Int
        , @VendorImportID   Int
        , @VendorName       Varchar(100)


Begin Transaction
Begin
	-- *******SET PRACTICE ID ******************************
    -- ===============================
    Set @PracticeID = 5
    -- ===============================

    Select @VendorName = 'Case 15236 :- Inland Pulmonary Medical Group.'

    -- =====================
    Insert Into VendorImport
    ( VendorName
      , VendorFormat
      , Notes
    )
    Values
    (
      @VendorName
      , 'MediSoft'
      , 'Import Patients, Doctors, Ref. Physicians, InsCompanies & Policies.'
    )

    Set @VendorImportID = @@IDENTITY

    Print 'Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )
    Print ''

    Print 'Practice ID : ' + Convert( Char(1) , @PracticeID )
    Print ''

    Update iDoctor
        Set ZipCode = dbo.fn_GetNumber( ZipCode )

    Update iDoctor
        Set Phone = dbo.fn_GetNumber( Phone )

    Update iDoctor
        Set Fax = dbo.fn_GetNumber( Fax )
            , SSNOrFedTaxID = dbo.fn_GetNumber( SSNOrFedTaxID )

    Update iRefPhy
        Set SSNOrFedTaxID = dbo.fn_GetNumber( SSNOrFedTaxID )
    	      , Phone = dbo.fn_GetNumber( Phone )
        	   , Fax = dbo.fn_GetNumber( Fax )
        	   , ZipCode = dbo.fn_GetNumber( ZipCode )

    Update iPatient
        Set Phone1 = dbo.fn_GetNumber( Phone1 )

    Update iPatient
        Set Phone2 = dbo.fn_GetNumber( Phone2 )

    Update iPatient
        Set WorkPhone = dbo.fn_GetNumber( WorkPhone )

    Update iPatient
        Set ZipCode = dbo.fn_GetNumber( ZipCode )

    Update iPatient
        Set SocialSecurityNumber = dbo.fn_GetNumber( SocialSecurityNumber )

    Update iInsCompany
        Set ZipCode = dbo.fn_GetNumber( ZipCode )

    Update iInsCompany
        Set Phone = dbo.fn_GetNumber( Phone )

    Update iInsCompany
        Set Fax = dbo.fn_GetNumber( Fax )

    -- Import Tables Order.
    -- ====================
    -- Physicians
    -- Referring Physicians
    -- Patients
    -- Insurance Companies
    -- Insurance Company Plans
    --

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
    SELECT DISTINCT
      @PracticeID
      , ''
      , ISNULL(iDoctor.FirstName, '') As FirstName
    	, IsNull( iDoctor.MiddleInitial , '' ) As MiddleName
    	, iDoctor.LastName
    	, ''
    	, iDoctor.Credentials
    	-- , Case When UPIN Is Not Null Then LTrim(RTrim(UPIN)) Else '' End
    	, SSNOrFedTaxID
    	-- , Case When TaxonomyCode Is Not Null Then LTrim(RTrim(TaxonomyCode)) Else NULL End
    	, iDoctor.Phone
    	, iDoctor.Fax
    	, iDoctor.Street1
    	, iDoctor.Street2
    	, iDoctor.City
    	, iDoctor.State
    	, iDoctor.ZipCode
    	, iDoctor.Code
    	, @VendorImportID
    	, 0 As [External]
    From iDoctor
	INNER JOIN
      (SELECT  MIN(Code) AS MinCode, FirstName, LastName
        FROM  iDoctor
        GROUP BY FirstName, LastName) AS UniquePhy ON iDoctor.Code = UniquePhy.MinCode

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for Physicians '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Medical License Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	 Select A.DoctorID
           , 7
           , B.LicenseNumber
		From Doctor A
				Inner Join iDoctor B On A.VendorID = B.Code
		Where IsNull( B.LicenseNumber , '' ) <> ''
				And A.VendorImportID = @VendorImportID
				AND A.[External] = 0

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Providers (License Number) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import UPIN Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select A.DoctorID
           , 25
           , B.UPIN
		From Doctor A
				Inner Join iDoctor B On A.VendorID = B.Code
		Where IsNull( B.UPIN , '' ) <> '' And IsNull( UPIN , '' ) Not Like '%NO%'
				And A.VendorImportID = @VendorImportID
				AND A.[External] = 0

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Providers (UPIN) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import NPI Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select A.DoctorID
           , 8
           , B.NPI
		From Doctor A
				Inner Join iDoctor B On A.VendorID = B.Code
		Where IsNull( B.NPI , '' ) <> ''
				And A.VendorImportID = @VendorImportID
				AND A.[External] = 0

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Providers (NPI) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Referring Physicians.
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
    SELECT DISTINCT
      @PracticeID
      , '' As Prefix
      , ISNULL(iRefPhy.FirstName, '') As FirstName
    	, IsNull( iRefPhy.MiddleInitial , '' ) As MiddleName
    	, iRefPhy.LastName
    	, '' As Suffix
    	, iRefPhy.Credentials
    	-- , Case When UPIN Is Not Null Then LTrim(RTrim( UPIN ) ) Else '' End
    	, iRefPhy.SSNOrFedTaxID
    	-- , Case When TaxonomyCode Is Not Null Then LTrim( RTrim( TaxonomyCode ) ) Else NULL End
    	, iRefPhy.Phone
    	, iRefPhy.Fax
    	, iRefPhy.Street1
    	, iRefPhy.Street2
    	, iRefPhy.City
    	, iRefPhy.State
    	, iRefPhy.ZipCode
    	, iRefPhy.Code
    	, @VendorImportID
    	, 1 As [External]
    From iRefPhy
	INNER JOIN
	(
		SELECT  MIN(Code) AS MinCode, FirstName, LastName
		FROM iRefPhy
		GROUP BY FirstName, LastName
	) AS UniquePhy ON iRefPhy.Code = UniquePhy.MinCode
	LEFT OUTER JOIN Doctor
	ON dbo.Doctor.FirstName = iRefPhy.FirstName 
	AND dbo.Doctor.LastName = iRefPhy.LastName
	WHERE (dbo.Doctor.DoctorID IS NULL)

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for Referring Physicians '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Medical License Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	 Select A.DoctorID
           , 7
           , B.LicenseNumber
		From Doctor A
				Inner Join iRefPhy B On A.VendorID = B.Code
		Where IsNull( B.LicenseNumber , '' ) <> ''
				And A.VendorImportID = @VendorImportID
				AND A.[External] = 1

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Ref. Physicians (License Number) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import UPIN Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select A.DoctorID
           , 25
           , B.UPIN
		From Doctor A
				Inner Join iRefPhy B On A.VendorID = B.Code
		Where IsNull( B.UPIN , '' ) <> '' And IsNull( UPIN , '' ) Not Like '%NO%'
				And A.VendorImportID = @VendorImportID
				AND A.[External] = 1

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Ref. Physicians (UPIN) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import NPI Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select A.DoctorID
           , 8
           , B.NPI
		From Doctor A
				Inner Join iRefPhy B On A.VendorID = B.Code
		Where IsNull( B.NPI , '' ) <> ''
				And A.VendorImportID = @VendorImportID
				AND A.[External] = 1

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Ref. Physicians (NPI) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


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
      , ResponsibleRelationshipToPatient Varchar(50)
      , CaseNumber                      Varchar(50)
    )

    -- Process Responsible Persons.
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
      , ResponsibleRelationshipToPatient
      , CaseNumber
    )
    Select Distinct
      CAS.ChartNumber
      , CAS.Guarantor
      , 1
      , PAT.FirstName
      , PAT.MiddleInitial
    	, PAT.LastName
    	, PAT.Street1
    	, PAT.Street2
    	, PAT.City
    	, PAT.State
    	, PAT.ZipCode
      , Case
		  When CAS.Guarantor = CAS.Insured1 Then
				Case
					When Upper( CAS.InsuredRelationship1 ) = 'OTHER' Then 'O'
					When Upper( CAS.InsuredRelationship1 ) = 'CHILD' Then 'O'
					When Upper( CAS.InsuredRelationship1 ) = 'SPOUSE' Then 'U'
					When Upper( CAS.InsuredRelationship1 ) = 'SELF' Then 'S'
					Else 'O'
				End
			Else 'O'
		  End As ResponsibleRelationshipToPatient
    	, CAS.CaseNumber
    From iPatient PAT
        Inner Join iPatientCase CAS On CAS.Guarantor = PAT.ChartNumber
    Where CAS.ChartNumber <> CAS.Guarantor

    -- Delete duplicate patients with guarantors; use guarantor listed for the most recent Case
    Delete From #PG
    Where Exists
    	( Select * From #PG As Z
        	Where Z.PatientChartNumber = #PG.PatientChartNumber
        	        And Convert( Int , Z.CaseNumber ) > Convert( Int , #PG.CaseNumber ) )

    -- Select * From #PG Order By PatientChartNumber

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
      , EmploymentStatus
      , HomePhone
      , WorkPhone
      , WorkPhoneExt
      , EmailAddress
      , DOB
      , SSN
	  , MedicalRecordNumber
      , ResponsibleDifferentThanPatient
      , ResponsibleFirstName
      , ResponsibleMiddleName
      , ResponsibleLastName
      , ResponsibleAddressLine1
      , ResponsibleAddressLine2
      , ResponsibleCity
      , ResponsibleState
      , ResponsibleZipCode
	  , ResponsibleRelationshipToPatient
      , PrimaryProviderID
      , MobilePhone
    )
    Select
      @VendorImportID
      , CONVERT(varChar(50), PAT.ChartNumber) AS ChartNumber
      , @PracticeID
    	, ''
    	, CONVERT(varChar(64), ISNULL(PAT.FirstName, '')) As FirstName
    	, CONVERT(varChar(64), IsNull( PAT.MiddleInitial , '' )) As MiddleName
    	, CONVERT(varChar(64), PAT.LastName) AS LastName
    	, ''
    	, CONVERT(varChar(256), PAT.Street1)
    	, CONVERT(varChar(256), PAT.Street2)
    	, CONVERT(varChar(128), PAT.City)
    	, CONVERT(varChar(2), PAT.State)
    	, CONVERT(varChar(9), PAT.ZipCode)
    	, Case
			When LTrim( RTrim( PAT.Sex ) ) = 'Male' Then 'M'
         	When LTrim( RTrim( PAT.Sex ) ) = 'Female' Then 'F'
         	Else 'U'
		  End As Gender
    	, 'U' As MaritalStatus
      , Case
            When PAT.EmploymentStatus = 'Full time' Then 'E'
            When PAT.EmploymentStatus = 'Part time' Then 'E'
            When PAT.EmploymentStatus = 'Retired' Then 'R'
            Else 'U'
        End As EmploymentStatus
    	, PAT.Phone1
    	, PAT.WorkPhone
    	, PAT.WorkExtension
      , PAT.Email
    	, PAT.DateOfBirth
    	, Case
            When Len( PAT.SocialSecurityNumber ) = 9 Then PAT.SocialSecurityNumber
            Else Null
        End
      , PAT.ChartNumber
    	, Case When PG.PatientChartNumber Is Not Null Then 1 Else 0 End
    	, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleFirstName Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleMiddleName Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleLastName Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleAddressLine1 Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleAddressLine2 Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleCity Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleState Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then Left( PG.ResponsibleZipCode , 9 ) Else NULL End
		, Case When PG.PatientChartNumber Is Not Null Then PG.ResponsibleRelationShipToPatient End
		, Null
    	, PAT.Phone2
    From iPatient PAT
        Left Join #PG PG On PAT.ChartNumber = PG.PatientChartNumber
    Where Upper( LTrim( RTrim( PAT.PatientType ) ) ) <> 'GUARANTOR'
            And Not Exists 
                ( Select * From Patient A 
                    Where A.PracticeID = @PracticeID 
                            And PAT.FirstName = A.FirstName 
                            And PAT.LastName = A.LastName )
    Order By PAT.LastName , PAT.FirstName

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Patient Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Update P
        Set PrimaryProviderID = C.DoctorID
        From Patient P
                Inner Join iPatient B On P.VendorID = B.ChartNumber
                Inner Join Doctor C On C.VendorID = B.AssignedProvider
        Where P.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Rendering Provider ID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Declare @RefToPatient Table
    ( ChartNumber           Varchar(50)
      , ReferringProvider   Varchar(50)
    )

    Insert @RefToPatient
    ( ChartNumber
      , ReferringProvider
    )
    Select Distinct
        ChartNumber
        , ReferringProvider
    From iPatientCase
    Where IsNull( ReferringProvider , '' ) <> ''

    Update P
        Set ReferringPhysicianID = D.DoctorID
        From Patient P
            Inner Join @RefToPatient RTP On P.VendorImportID = @VendorImportID And P.VendorID = RTP.ChartNumber
            -- Inner Join Doctor D On D.VendorImportID = @VendorImportID AND RTP.ReferringProvider = D.VendorID
            Inner Join Doctor D On RTP.ReferringProvider = D.VendorID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Referring Physicians '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- InsuranceCompany
    -- MWINS - Assume that insurance company is the same as insuranceplan
    -- Create temporary table to hold insurance companies that already exist in InsuranceCompany table
    Create Table #EIC
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
    Select
        Max( ICO.InsuranceCompanyID ) As InsuranceCompanyID
        , IC.Name
        , IC.Street1
        , IC.Street2
        , IC.City
        , IC.State
        , IC.ZipCode
        , IC.Phone
        , IC.Extension
        , ICO.ReviewCode
        , IC.Code
    From iInsCompany IC
        Inner Join InsuranceCompany ICO On LTrim( RTrim( ICO.InsuranceCompanyName ) ) = LTrim( RTrim( IC.Name ) )
    Where LTrim(RTrim( ICO.City ) ) = LTrim(RTrim( IC.City ) )
            AND Left( ICO.ZipCode , 5 ) = Left( IC.ZipCode , 5 )
        	AND LTrim( RTrim( ICO.State ) ) = LTrim(RTrim( IC.State ) )
        	AND LTrim( RTrim( ICO.InsuranceCompanyName ) ) = LTrim( RTrim( IC.Name ) )
        	AND Replace( Replace( ICO.AddressLine1, ' ' , '' ) , '.' , '' ) = Replace( Replace( IC.Street1 , ' ', '' ) , '.' , '' )
    Group By IC.Name , IC.Street1 , IC.Street2 , IC.City , IC.State , IC.ZipCode , IC.Phone , IC.Extension , ICO.ReviewCode , IC.Code

    -- Debug.
    -- Select * From #EIC

    -- Store insurance companies that do not exist in InsuranceCompany table in another temporary table #NIC
    Create Table #NIC
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
      IsNull( IC.Code , '' )
      , IC.Name
      , IC.Street1
      , IC.Street2
      , IC.City
      , IC.State
      , IC.ZipCode
      , IC.Phone
      , IC.Extension
      , 'R'
    From iInsCompany IC
    Where IC.Code Not In ( Select Code From #EIC )

    -- Insert Into InsuranceCompany those insurance companies that do not already exist.
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
      CONVERT(VarChar(50), IsNull( Code , '' )) AS VendorID
      , @VendorImportID
      , CONVERT(VarChar(128), InsuranceCompanyName)
    	, CONVERT(VarChar(256), AddressLine1)
    	, CONVERT(VarChar(256), AddressLine2)
    	, CONVERT(VarChar(128), City)
    	, CONVERT(VarChar(2), State)
    	, CONVERT(VarChar(9), ZipCode)
    	, Phone
    	, PhoneExt
    	, 'R'
    From #NIC

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsuranceCompany Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- InsuranceCompanyPlan
    -- Insert plans that do not already exist  in InsuranceCompanyPlan
    -- 1) find which ones exist;  Code - same as InsuranceCarrier #1, #2 and 3# in MWCAS)
    -- Existing InsuranceCompanyPlans
    Create Table #EIP
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
    Select MAX( ICP.InsuranceCompanyPlanID ) As InsuranceCompanyPlanID
    	, IsNull( IP.Code , '' )
    	, IP.Name
    	, IP.Street1
    	, IP.Street2
    	, IP.City
    	, IP.State
    	, IP.ZipCode
    	, IP.Phone
    	, IP.Extension
    From iInsCompany IP
        Join InsuranceCompanyPlan ICP On LTrim( RTrim( ICP.PlanName ) ) = LTrim( RTrim( IP.Name ) )
    	Where LTrim( RTrim( ICP.City ) ) = LTrim( RTrim( IP.City ) )
    	        And LTrim( RTrim( icp.State ) ) = LTrim(RTrim( ip.State ) )
              And Left( icp.ZipCode , 5 ) = Left( ip.ZipCode , 5 )
              And LTrim(RTrim( icp.PlanName ) ) = LTrim(RTrim( ip.Name ) )
              And Replace( Replace( icp.AddressLine1, ' ' , '' ) , '.' , '' ) = Replace(Replace( ip.Street1 , ' ' , '') , '.' , '' )
    Group By IP.Code
		       , IP.Name
		       , IP.Street1
	          , IP.Street2
	          , IP.City
	          , IP.State
	          , IP.ZipCode
	          , IP.Phone
	          , IP.Extension

    -- Create temporary table with plans that do not exist in InsuranceCompanyPlan table
    Create Table #NIP
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

    -- Insert plans that do not already exist in InsuranceCompanyPlan table
    Insert Into #NIP
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
    Select
      IsNull( IP.Code , '' )
    	, IP.Name
    	, IsNull( EIC.InsuranceCompanyID , IC.InsuranceCompanyID )
    	, IP.Street1
    	, IP.Street2
    	, IP.City
    	, IP.State
    	, IP.ZipCode
    	, IP.Phone
    	, IP.Extension
    From iInsCompany IP
        Left Join InsuranceCompany IC On IC.VendorImportID = @VendorImportID And IP.Code = IC.VendorID
        Left Join #EIC EIC On IP.code = EIC.Code
    Where IP.Code Not In ( Select Code From #EIP )
    Order By IP.Name

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
    	NIP.Code,
    	NIP.PlanName,
    	NIP.InsuranceCompanyID,
    	NIP.AddressLine1,
    	NIP.AddressLine2,
    	NIP.City,
    	Case When Len( NIP.State ) <= 2 Then NIP.State Else NULL End,
    	Case When Len( NIP.ZipCode ) <= 9 Then NIP.ZipCode Else NULL End,
    	NIP.Phone,
    	--COALESCE(CAST(ip.Copay AS money),0),
    	CAST(0.00 AS money),
    	NIP.PhoneExt,
    	'R'
    From #NIP NIP

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsuranceCompanyPlan Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Insurance plans that did not exist will have VendorImportID for this import and and VendorID = MWINS.Code
    -- for those that did exist, match InsuranceCompanyPlanID From #EIP
    -- Select InsuranceCompanyPlanID From #EIP

    Select ChartNumber
    	      , Convert( Varchar(50) , Max( Convert( Int , casenumber ) ) ) As CaseNumber Into #RecentCases
    	From iPatientCase
    	Group By ChartNumber
    	Order By ChartNumber

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
        , Case 
            When IsNull( DC.Description , '' ) = '' Then 'Default Case'
            Else DC.Description
          End
        , P.PracticeID
        , 5
        , DC.CaseNumber
        , @VendorImportID
        , P.ReferringPhysicianID
        , Case When UPPER( LTrim( RTrim( DC.RelatedToEmployment ) ) ) = 'TRUE' Then 1 Else 0 End
        , Case When UPPER( LTrim( RTrim( DC.RelatedToAccident ) ) ) = 'AUTO' Then 1 Else 0 End
        , DC.AccidentState
        , DC.Notes
    From Patient P
    	Inner Join iPatientCase DC ON P.VendorID = DC.ChartNumber
	Inner Join (
		SELECT ChartNumber, MAX(CaseNumber) AS MaxCaseNo
		FROM iPatientCase
		GROUP BY ChartNumber
		) AS lastCase
	ON DC.CaseNumber = lastCase.MaxCaseNo
    	Inner Join #RecentCases RC On DC.ChartNumber = RC.ChartNumber And DC.CaseNumber = RC.CaseNumber
    Where VendorID Is Not Null
    	      And VendorImportID = @VendorImportID
    	      And PracticeID = @PracticeID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in PatientCase Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Create Default Patient Cases for patients with no chartnumber in mwcas table
    Insert Into PatientCase
    ( PatientID
      , [Name]
      , PayerScenarioID
      , ReferringPhysicianID
      , PracticeID
      , VendorID
      , VendorImportID
     )
    Select
    	P.PatientID
    	, 'Default Case'
    	, 5
    	, P.ReferringPhysicianID
    	, @PracticeID
    	, P.VendorID
    	, @VendorImportID
    From Patient P
    Where P.VendorImportID = @VendorImportID
    		And P.VendorID Not In ( Select Distinct ChartNumber From iPatientCase )

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in PatientCase Table for Default Case '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

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
        , IsNull( EIP.InsuranceCompanyPlanID , ICP.InsuranceCompanyPlanID ) As InsuranceCompanyPlanID
        , Left( LTrim( RTrim( DC.PolicyNumber1 ) ) , 32 ) As PolicyNumber
        , Left( LTrim( RTrim( DC.GroupNumber1 ) ) , 32 ) As GroupNumber
        , 1
        , DC.Policy1StartDate As PolicyStartDate
        , DC.Policy1EndDate As PolicyEndDate
        , Case
		    When IsNull( DC.Insured1 , '' ) <> '' And IsNull( DC.Insured1 , '' ) = DC.ChartNumber Then 'S'
		    When IsNull( DC.Insured1 , '' ) <> ''
					And IsNull( DC.Insured1 , '' ) <> DC.ChartNumber
					And IsNull( DC.Insured1 , '' ) = IsNull( DC.Guarantor , '' ) Then
				Case
					When Upper( DC.InsuredRelationship1 ) = 'OTHER' Then 'O'	-- Other
					When Upper( DC.InsuredRelationship1 ) = 'CHILD' Then 'C' 	-- Child
					When Upper( DC.InsuredRelationship1 ) = 'SPOUSE' Then 'U'	-- Spouse
					Else 'U'
				End
		    Else 'O'
		    End As PatientRelationshipToInsured
        , Case When IsNull( DC.Insured1 , '' ) <> LTrim( RTrim( DC.ChartNumber ) ) AND IsNull( DC.Insured1 , '' ) <> ''
                Then DP.LastName Else NULL End HolderLastName
        , Case When IsNull( DC.Insured1 ,'' ) <> LTrim( RTrim( DC.ChartNumber ) ) AND IsNull( DC.Insured1 , '' ) <> ''
                Then DP.FirstName Else NULL End HolderFirstName
        , Case When IsNull( DC.Insured1 , '' ) <> LTrim( RTrim( DC.ChartNumber ) ) AND IsNull( DC.Insured1 , '' ) <> ''
                Then DP.MiddleInitial Else NULL End HolderMiddleName
        , Case When IsNull( DC.Insured1 , '' ) <> LTrim( RTrim( DC.ChartNumber ) ) AND IsNull( DC.Insured1 , '' ) <> ''
                Then DP.Street1 Else NULL End HolderAddressLine1
        , Case When IsNull( DC.Insured1 , '') <> LTrim( RTrim( DC.ChartNumber ) ) AND IsNull( DC.Insured1 , '' ) <> ''
                Then DP.Street2 Else NULL End HolderAddressLine2
        , Case When IsNull( DC.Insured1 , '' )<> LTrim( RTrim( DC.ChartNumber ) ) AND IsNull( DC.Insured1 , '' ) <> ''
                Then DP.City Else NULL End HolderCity
        , Case When IsNull( DC.Insured1 , '' ) <> LTrim( RTrim( DC.ChartNumber ) ) AND IsNull( DC.Insured1 , '' ) <> ''
                Then Left( LTrim( RTrim( DP.State ) ) , 2 ) Else NULL End HolderState
        , Case When IsNull( DC.Insured1 ,'' ) <> LTrim( RTrim( DC.ChartNumber ) ) AND IsNull( DC.Insured1 , '' ) <> ''
                Then LTrim( RTrim( Left( LTrim( RTrim( DP.ZipCode ) ) , 9 ) ) ) Else NULL End HolderZipCode
        , Case When IsNull( DC.Insured1 , '' ) <> LTrim( RTrim( DC.ChartNumber ) ) AND IsNull( DC.Insured1 , '' ) <> ''
                Then Case When DP.Sex = 'Female' Then 'F' Else 'M' End Else NULL End HolderGEnder
        , Case When IsNull( DC.Insured1 , '' ) <> LTrim( RTrim( DC.ChartNumber ) ) AND IsNull( DC.Insured1 , '' ) <> ''
                Then LTrim( RTrim( Left( LTrim( RTrim( DP.Phone1 ) ) , 10 ) ) ) Else NULL End HolderPhone
        , Case When IsNull( DC.Insured1 , '' ) <> LTrim( RTrim( DC.ChartNumber ) ) AND IsNull( DC.Insured1 , '' ) <> ''
                Then LTrim(RTrim( DP.DateOfBirth ) ) Else NULL End HolderDOB
        , Case When IsNull( DC.Insured1 , '' ) <> LTrim( RTrim( DC.ChartNumber ) ) AND IsNull( DC.Insured1 ,'' ) <> ''
                Then LTrim( RTrim( Left( LTrim( RTrim( Replace( Replace( Replace( DP.SocialSecurityNumber , '-' , '' ) , '+' , '' ) , '/' , '' ) ) ) , 9 ) ) ) Else NULL End HolderSSN
        , DC.InsuranceCarrier1
        , @VendorImportID
    From iPatientCase DC
        Inner Join PatientCase PC On PC.VendorImportID = @VendorImportID And Convert( Varchar(50) , DC.CaseNumber ) = PC.VendorID
        Left Join InsuranceCompanyPlan ICP On ICP.VendorImportID = @VendorImportID And DC.InsuranceCarrier1 = ICP.VendorID
        Left Join #EIP EIP On DC.InsuranceCarrier1 = EIP.Code
        Left Join iPatient DP On DC.Insured1 = DP.ChartNumber
    Where LTrim( RTrim( IsNull( DC.InsuranceCarrier1 , '' ) ) ) <> ''
            And IsNull( EIP.InsuranceCompanyPlanID , ICP.InsuranceCompanyPlanID ) Is Not Null

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Primary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

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
        , IsNull(EIP.InsuranceCompanyPlanID, ICP.InsuranceCompanyPlanID) InsuranceCompanPlanID
        -- , ICP.InsuranceCompanyPlanID
        , Left(LTrim(RTrim(PolicyNumber2)),32) PolicyNumber
        , Left(LTrim(RTrim(GroupNumber2)),32) GroupNumber
        , 2
        , Policy2StartDate PolicyStartDate
        , Policy2EndDate PolicyEndDate
        , Case
		    When IsNull( DC.Insured2 , '' ) <> '' And IsNull( DC.Insured2 , '' ) = DC.ChartNumber Then 'S'
		    When IsNull( DC.Insured2 , '' ) <> ''
					And IsNull( DC.Insured2 , '' ) <> DC.ChartNumber
					And IsNull( DC.Insured2 , '' ) = IsNull( DC.Guarantor , '' ) Then
				Case
					When Upper( DC.InsuredRelationship2 ) = 'OTHER' Then 'O'	-- Other
					When Upper( DC.InsuredRelationship2 ) = 'CHILD' Then 'C' 	-- Child
					When Upper( DC.InsuredRelationship2 ) = 'SPOUSE' Then 'U'	-- Spouse
					Else 'U'
				End
		   Else 'O'
		   End As PatientRelationshipToInsured
        , Case When IsNull(DC.Insured2,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured2,'')<>''
            Then DP.LastName Else NULL End HolderLastName
        , Case When IsNull(DC.Insured2,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured2,'')<>''
            Then DP.FirstName Else NULL End HolderFirstName
        , Case When IsNull(DC.Insured2,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured2,'')<>''
            Then DP.MiddleInitial Else NULL End HolderMiddleName
        , Case When IsNull(DC.Insured2,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured2,'')<>''
            Then DP.Street1 Else NULL End HolderAddressLine1
        , Case When IsNull(DC.Insured2,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured2,'')<>''
            Then DP.Street2 Else NULL End HolderAddressLine2
        , Case When IsNull(DC.Insured2,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured2,'')<>''
            Then DP.City Else NULL End HolderCity
        , Case When IsNull(DC.Insured2,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured2,'')<>''
            Then Left(LTrim(RTrim(DP.State)),2) Else NULL End HolderState
        , Case When IsNull(DC.Insured2,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured2,'')<>''
            Then Left(LTrim(RTrim(DP.ZipCode)),9) Else NULL End HolderZipCode
        , Case When IsNull(DC.Insured2,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured2,'')<>''
            Then Case When DP.Sex='Female' Then 'F' Else 'M' End Else NULL End HolderGEnder
        , Case When IsNull(DC.Insured2,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured2,'')<>''
            Then LTrim(RTrim(Left(LTrim(RTrim(DP.Phone1)),10))) Else NULL End HolderPhone
        , Case When IsNull(DC.Insured2,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured2,'')<>''
            Then LTrim(RTrim(DP.DateOfBirth)) Else NULL End HolderDOB
        , Case When IsNull(DC.Insured2,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured2,'')<>''
            Then LTrim(RTrim(Left(LTrim(RTrim(Replace(Replace(Replace(DP.SocialSecurityNumber, '-', ''), '+', ''), '/', ''))), 9))) Else NULL End HolderSSN
        , DC.InsuranceCarrier2
        , @VendorImportID
    From iPatientCase DC
        Inner Join PatientCase PC ON PC.VendorImportID = @VendorImportID And Convert( Varchar(50) , DC.CaseNumber ) = PC.VendorID
        Left Join InsuranceCompanyPlan ICP ON ICP.VendorImportID = @VendorImportID AND DC.InsuranceCarrier2 = ICP.VendorID
        Left Join #EIP EIP ON DC.InsuranceCarrier2 = EIP.Code
        Left Join iPatient DP ON DC.Insured2 = DP.ChartNumber
    Where LTrim( RTrim( IsNull( DC.InsuranceCarrier2 , '' ) ) ) <> '' 
            And IsNull( EIP.InsuranceCompanyPlanID , ICP.InsuranceCompanyPlanID ) Is Not Null

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Secondary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

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
        , IsNull( EIP.InsuranceCompanyPlanID , ICP.InsuranceCompanyPlanID ) InsuranceCompanPlanID
        -- , ICP.InsuranceCompanyPlanID
        , PolicyNumber3 PolicyNumber
        , GroupNumber3 GroupNumber
        , 3
        , Policy3StartDate PolicyStartDate
        , Policy3EndDate PolicyEndDate
        , Case
		  When IsNull( DC.Insured3 , '' ) <> '' And IsNull( DC.Insured3 , '' ) = DC.ChartNumber Then 'S'
		  When IsNull( DC.Insured3 , '' ) <> ''
					And IsNull( DC.Insured3 , '' ) <> DC.ChartNumber
					And IsNull( DC.Insured3 , '' ) = IsNull( DC.Guarantor , '' ) Then
				Case
					When Upper( DC.InsuredRelationship3 ) = 'OTHER' Then 'O'	-- Other
					When Upper( DC.InsuredRelationship3 ) = 'CHILD' Then 'C' 	-- Child
					When Upper( DC.InsuredRelationship3 ) = 'SPOUSE' Then 'U'	-- Spouse
					Else 'U'
				End
		  Else 'O'
		  End As PatientRelationshipToInsured
        , Case When IsNull(DC.Insured3,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured3,'')<>''
            Then DP.LastName Else NULL End HolderLastName
        , Case When IsNull(DC.Insured3,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured3,'')<>''
            Then DP.FirstName Else NULL End HolderFirstName
        , Case When IsNull(DC.Insured3,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured3,'')<>''
            Then DP.MiddleInitial Else NULL End HolderMiddleName
        , Case When IsNull(DC.Insured3,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured3,'')<>''
            Then DP.Street1 Else NULL End HolderAddressLine1
        , Case When IsNull(DC.Insured3,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured3,'')<>''
            Then DP.Street2 Else NULL End HolderAddressLine2
        , Case When IsNull(DC.Insured3,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured3,'')<>''
            Then DP.City Else NULL End HolderCity
        , Case When IsNull(DC.Insured3,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured3,'')<>''
            Then Left(LTrim(RTrim(DP.State)),2) Else NULL End HolderState
        , Case When IsNull(DC.Insured3,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured3,'')<>''
            Then LTrim(RTrim(Left(LTrim(RTrim(DP.ZipCode)),9))) Else NULL End HolderZipCode
        , Case When IsNull(DC.Insured3,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured3,'')<>''
            Then Case When DP.Sex='Female' Then 'F' Else 'M' End Else NULL End HolderGEnder
        , Case When IsNull(DC.Insured3,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured3,'')<>''
            Then LTrim(RTrim(Left(LTrim(RTrim(DP.Phone1)),10))) Else NULL End HolderPhone
        , Case When IsNull(DC.Insured3,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured3,'')<>''
            Then LTrim(RTrim(DP.DateOfBirth)) Else NULL End HolderDOB
        , Case When IsNull(DC.Insured3,'')<>LTrim(RTrim(DC.ChartNumber)) AND IsNull(DC.Insured3,'')<>''
            Then LTrim(RTrim(Left(LTrim(RTrim(Replace(Replace(Replace(DP.SocialSecurityNumber, '-', ''), '+', ''), '/', ''))), 9))) Else NULL End HolderSSN
        , DC.InsuranceCarrier3
        , @VendorImportID
    From iPatientCase DC
        Inner Join PatientCase PC On PC.VendorImportID = @VendorImportID And Convert( Varchar(50) , DC.CaseNumber ) = PC.VendorID
        Left Join InsuranceCompanyPlan ICP On ICP.VendorImportID = @VendorImportID And DC.InsuranceCarrier3 = ICP.VendorID
        Left Join #EIP EIP On DC.InsuranceCarrier3 = EIP.Code
        Left Join iPatient DP On DC.Insured3 = DP.ChartNumber
    Where LTrim( RTrim( IsNull( DC.InsuranceCarrier3 , '' ) ) ) <>''
            And IsNull( EIP.InsuranceCompanyPlanID , ICP.InsuranceCompanyPlanID ) Is Not Null

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Tertiary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Create Table #PCToUpdate
    ( PatientCaseID Int )

    Insert Into #PCToUpdate
    ( PatientCaseID )
    Select
        PC.PatientCaseID
    From PatientCase PC
        Left Join InsurancePolicy IP On PC.PatientCaseID = IP.PatientCaseID
    Where PC.PracticeID = @PracticeID
    Group By PC.PatientCaseID Having Count(*) = 0

    Update PC
        Set PayerScenarioID = 11
        From PatientCase PC
            Inner Join #PCToUpdate PCU On PC.PatientCaseID = PCU.PatientCaseID

    -- Edit GroupNumber, PolicyStartDate and PolicyEndDate
    Update InsurancePolicy
        Set GroupNumber = ''
        Where VendorImportID = @VendorImportID
                And Upper( IsNull( GroupNumber , '' ) ) = 'NONE'

    Update InsurancePolicy
        Set PolicyStartDate = Null
        Where Convert( Char(10) , IsNull( PolicyStartDate , '' ) , 101 ) = '01/01/1900'
                And VendorImportID = @VendorImportID

    Update InsurancePolicy
        Set PolicyEndDate = Null
        Where Convert( Char(10) , IsNull( PolicyEndDate , '' ) , 101 ) = '01/01/1900'
                And VendorImportID = @VendorImportID

    Update InsurancePolicy
        Set HolderDOB = Null
        Where Convert( Char(10) , IsNull( HolderDOB , '' ) , 101 ) = '01/01/1900'
                And VendorImportID = @VendorImportID

    -- Update EmployerID.
    Update A
        Set EmployerID = C.EmployerID
        From Patient A
            Inner Join iPatient B On B.ChartNumber = A.VendorID
            Inner Join Employers C On C.VendorID = Convert( Char(1) , @PracticeID ) + B.Employer
        Where A.PracticeID = @PracticeID
                And B.PatientType <> 'Guarantor'

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Distinct Employer ID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- If duplicate employer, update employer id based on employername and address.
    Update A
        Set EmployerID = D.EmployerID
        From Patient A
            Inner Join iPatient B On B.ChartNumber = A.VendorID
            Inner Join iAddress C On C.Code = B.Employer
            Inner Join Employers D On 
                D.EmployerName = C.Name 
                And D.AddressLine1 = C.[Street 1]
                And D.AddressLine2 = C.[Street 2] 
                And D.City = C.City 
                And D.State = C.State 
                And IsNull( D.ZipCode , '' ) = IsNull( C.[Zip Code] , '' )
        Where A.PracticeID = @PracticeID
            And B.PatientType <> 'Guarantor'
            And IsNull( D.VendorID , '' ) = ''

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Duplicate Employer ID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


-- Create Self Pay Case for each patient

    Insert Into PatientCase
    ( PatientID
      , [Name]
      , PayerScenarioID
      , ReferringPhysicianID
      , PracticeID
      , VendorID
      , VendorImportID
     )
    Select DISTINCT
    	P.PatientID
    	, 'Self Pay Case'
    	, 11
    	, P.ReferringPhysicianID
    	, @PracticeID
    	, P.VendorID
    	, @VendorImportID
    From Patient P
    Where P.VendorImportID = @VendorImportID
    		

    Drop Table #PCToUpdate
    Drop Table #PG
    Drop Table #EIC
    Drop Table #NIC
    Drop Table #EIP
    Drop Table #NIP
    Drop Table #RecentCases


End
-- ROLLBACK
-- Commit Transaction

Set NoCount Off
