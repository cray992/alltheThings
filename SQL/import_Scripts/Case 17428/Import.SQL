-- C:\Work\Data Imports\Case 17428\Scripts\Import.SQL

-- Customer  : Automatic Claims Processing (0966).
-- Practice  : Jared T. Clegg.
-- Case ID   : 17428


-- Tables Populated.
-- =================
-- 1. Doctor
-- 2. Patient
-- 3. PatientCase
-- 4. PatientCaseDate
-- 4. InsuranceCompany
-- 5. InsuranceCompanyPlan
-- 6. InsurancePolicy
-- 7. InsuracePolicyAuthorization

/*
Production DB : superbill_0966_prod

Select CustomerID , CompanyName , City, State, Zip
    From superbill_shared.dbo.Customer 
    Where CustomerID = 966

*/

-- Important.
-- ==========
-- Make sure that the synonymn are created for each PRACTICE before running this script.
-- Make sure to run another import script before running this script to add employers to the employers table
-- and attorneys to the attorneys table.
-- Add New VendorImportID column to PatientCaseDate and InsurancePolicyAuthorization tables.

/*
Alter Table PatientCaseDate
    Add VendorImportID Int

Alter Table InsurancePolicyAuthorization
    Add VendorImportID Int

*/


/*
    -- QA DB ( Data Import #1 ).
    Use superbill_0670_prod

    -- Production Database.
    -- Use superbill_0966_prod

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

    -- Practice ID : 2 ( Jared T. Clegg )
    -- ================================================
    Create Synonym iPatient For impMWPAT17428
    Go
    Create Synonym iPatientCase For impMWCAS17428
    Go
    Create Synonym iDoctor For impMWPHY17428
    Go
    Create Synonym iRefPhy For impMWRPH17428
    Go
    Create Synonym iInsCompany For impMWINS17428
    Go
    Create Synonym iAddress For impMWADD17428
    Go

    Insert Into Practice
    ( [Name] )
    Select [Name] 
        From superbill_0966_prod.dbo.Practice

    Insert Into Practice
    ( [Name] )
    Values
    ( 'Jared T. Clegg' )

    Select * From Practice
*/


-- QA DB ( Data Import #1 )
-- Use superbill_0670_prod
-- Go

-- Production Database.
Use superbill_0966_prod
Go

Set NoCount On

Declare @Rows               Int
        , @Message          Varchar(75)
        , @PracticeID       Int
        , @VendorImportID   Int
        , @VendorName       Varchar(100)

If Not Exists ( Select Object_ID( 'dbo.fn_GetNumber' , 'FN' ) )
Begin
    RaisError( 'Function fn_GetNumber missing. Cannot Proceed.' , 11 , -1 )
    Return
End

Begin Transaction
Begin

    -- Select * From Practice

    -- Jared T. Clegg Practice.
    -- =============================
    Set @PracticeID = 2
    -- =============================

    If @PracticeID = 2
        Select @VendorName = 'Case 17428 :- Jared T. Clegg Practice.'

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

    Set @VendorImportID = @@Identity

    Print 'Data Import Date & Time : ' + Convert( Varchar(20) , GetDate() )
    Print ''

    Print 'Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )
    Print ''

    Print 'DataBase : ' + DB_Name()
    Print ''

    Print 'Practice ID : ' + Convert( Char(1) , @PracticeID )
    Print ''

    Update iDoctor
        Set ZipCode = dbo.fn_GetNumber( ZipCode )

    Update iDoctor
        Set Phone = dbo.fn_GetNumber( Phone )
            , Office = dbo.fn_GetNumber( Office )
            , Cell = dbo.fn_GetNumber( Cell )
            , Fax = dbo.fn_GetNumber( Fax )
            , SSNOrFedTaxID = dbo.fn_GetNumber( SSNOrFedTaxID )

    Update iRefPhy
        Set SSNOrFedTaxID = dbo.fn_GetNumber( SSNOrFedTaxID )
    	      , Phone = dbo.fn_GetNumber( Phone )
            , Office = dbo.fn_GetNumber( Office )
            , Cell = dbo.fn_GetNumber( Cell )
        	   , Fax = dbo.fn_GetNumber( Fax )
        	   , ZipCode = dbo.fn_GetNumber( ZipCode )

    Update iPatient
        Set Phone1 = dbo.fn_GetNumber( Phone1 )
            , Phone2 = dbo.fn_GetNumber( Phone2 )
            , WorkPhone = dbo.fn_GetNumber( WorkPhone )
            , ZipCode = dbo.fn_GetNumber( ZipCode )
            , SocialSecurityNumber = dbo.fn_GetNumber( SocialSecurityNumber )

    Update iInsCompany
        Set ZipCode = dbo.fn_GetNumber( ZipCode )
            , Phone = dbo.fn_GetNumber( Phone )
            , Fax = dbo.fn_GetNumber( Fax )

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
      , MobilePhone
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
      , FirstName
    	, IsNull( MiddleInitial , '' ) As MiddleName
    	, LastName
    	, ''
    	, Credentials
    	-- , Case When UPIN Is Not Null Then LTrim(RTrim(UPIN)) Else '' End
    	, SSNOrFedTaxID
    	-- , Case When TaxonomyCode Is Not Null Then LTrim(RTrim(TaxonomyCode)) Else NULL End
    	, IsNull( Office , '' ) As WorkPhone
      , IsNull( Cell , '' ) As MobilePhone
    	, Fax
    	, Street1
    	, Street2
    	, City
    	, State
    	, ZipCode
    	, Code
    	, @VendorImportID
    	, 0 As [External]
    From iDoctor

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

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Providers (NPI) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Select Distinct A.ReferringProvider Into #RefPhy
        From iPatientCase A
                Inner Join iPatient B On B.ChartNumber = A.ChartNumber
        Where B.PatientType <> 'Guarantor'
                And IsNull( A.ReferringProvider , '' ) <> ''

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
	   , WorkPhone
      , MobilePhone
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
      , '' As Prefix
      , FirstName
    	, IsNull( MiddleInitial , '' ) As MiddleName
    	, LastName
    	, '' As Suffix
    	, Credentials
    	, SSNOrFedTaxID
    	, IsNull( Office , '' ) As WorkPhone
      , IsNull( Cell , '' ) As MobilePhone
    	, Fax
    	, Street1
    	, Street2
    	, City
    	, State
    	, ZipCode
    	, Code
    	, @VendorImportID
    	, 1 As [External]
    From iRefPhy A
            Inner Join #RefPhy B On B.ReferringProvider = A.Code
    Where Not Exists ( Select * 
                            From Doctor B
                            Where B.PracticeID = @PracticeID
                                    And B.FirstName = A.FirstName
                                    And B.LastName = A.LastName 
                                    And B.VendorImportID Is Null 
                                    And B.[External] = 1 )

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
      , PAT.ChartNumber
      , @PracticeID
    	, ''
    	, PAT.FirstName
    	, IsNull( PAT.MiddleInitial , '' ) As MiddleName
    	, PAT.LastName
    	, ''
    	, PAT.Street1
    	, PAT.Street2
    	, PAT.City
    	, PAT.State
    	, PAT.ZipCode
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

    -- Update Patient's Marital Status.
    Update A
        Set MaritalStatus =
                Case
                    When B.MaritalStatus = 'Single' Then 'S'
                    When B.MaritalStatus = 'Married' Then 'M'
                    When B.MaritalStatus = 'Divorced' Then 'D'
                    When B.MaritalStatus = 'Unknown' Then 'U'
                    Else 'U'
                End
        From Patient A
                Inner Join ( Select Distinct ChartNumber , MaritalStatus 
                                From iPatientCase 
                                Where IsNull( MaritalStatus , '' ) <> '' ) B On B.ChartNumber = A.VendorID
        Where A.VendorImportID = @VendorImportID
                And A.PracticeID = @PracticeID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Marital Status '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    /*
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
    */

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
    ( Code                      VarChar(255)
      , InsuranceCompanyName    VarChar(255)
      , AddressLine1            VarChar(255)
      , AddressLine2            VarChar(255)
      , City                    VarChar(255)
      , State                   VarChar(255)
      , ZipCode                 VarChar(255)
      , Phone                   VarChar(255)
      , PhoneExt                VarChar(255)
      , ReviewCode              VarChar(255)
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
      IsNull( Code , '' )
      , @VendorImportID
      , InsuranceCompanyName
    	, AddressLine1
    	, AddressLine2
    	, City
    	, State
    	, ZipCode
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
    Select Max( ICP.InsuranceCompanyPlanID ) As InsuranceCompanyPlanID
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
    	        And LTrim( RTrim( ICP.State ) ) = LTrim( RTrim( IP.State ) )
              And Left( ICP.ZipCode , 5 ) = Left( IP.ZipCode , 5 )
              And LTrim( RTrim( ICP.PlanName ) ) = LTrim( RTrim( IP.Name ) )
              And Replace( Replace( ICP.AddressLine1 , ' ' , '' ) , '.' , '' ) = Replace( Replace( IP.Street1 , ' ' , '' ) , '.' , '' )
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
    	0 As Copay,
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
    	      , Convert( Varchar(50) , Max( CaseNumber ) ) As CaseNumber Into #RecentCases
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
      -- , ReferringPhysicianID
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
        , DC.CaseNumber As VendorID
        , @VendorImportID
        -- , P.ReferringPhysicianID
        , DC.RelatedToEmployment
        , Case When IsNull( DC.RelatedToAccident , '' ) = 'AUTO' Then 1 Else 0 End
        , DC.AccidentState
        , DC.Notes
    From Patient P
    	Inner Join iPatientCase DC ON P.VendorID = DC.ChartNumber
    	-- Inner Join #RecentCases RC On DC.ChartNumber = RC.ChartNumber And DC.CaseNumber = RC.CaseNumber
    Where P.VendorID Is Not Null
    	      And VendorImportID = @VendorImportID
    	      And P.PracticeID = @PracticeID
    Order By P.LastName , P.FirstName , DC.CaseNumber

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

    -- Update ReferringPhysicianID on PatientCase Table.
    Update A
        Set ReferringPhysicianID = D.DoctorID
        From PatientCase A
                Inner Join Patient B On B.PatientID = A.PatientID
                Inner Join iPatientCase C On C.ChartNumber = B.VendorID And Convert( Varchar(20) , C.CaseNumber ) = A.VendorID
                Inner Join Doctor D On D.VendorID = C.ReferringProvider
        Where A.VendorImportID = @VendorImportID
                And D.[External] = 1
                And IsNull( C.ReferringProvider , '' ) <> ''

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in PatientCase Table for Referring Physician ID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Update ReferringPhysicianID on Patient Table.
    Update A
        Set ReferringPhysicianID = B.ReferringPhysicianID
        From Patient A
                Inner Join PatientCase B On B.PatientID = A.PatientID
                Inner Join #RecentCases C On C.ChartNumber = A.VendorID And C.CaseNumber = B.VendorID
        Where A.VendorImportID = @VendorImportID
                And IsNull( B.ReferringPhysicianID , 0 ) <> 0

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Referring Physician ID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Date of Injury Records.
    Insert Into PatientCaseDate
    ( PracticeID
      , PatientCaseID
      , PatientCaseDateTypeID
      , StartDate
      , VendorImportID
    )
    Select 
        B.PracticeID
        , A.PatientCaseID
        , 2 As PatientCaseDateTypeID
        , Convert( DateTime , IsNull( C.DateOfInjury , '' ) ) As StartDate
        , @VendorImportID
    From PatientCase A
            Inner Join Patient B On B.PatientID = A.PatientID
            Inner Join iPatientCase C On C.CaseNumber = A.VendorID And C.ChartNumber = B.VendorID
    Where B.VendorImportID = @VendorImportID
            And A.PracticeID = @PracticeID
            And A.[Name] <> 'Default Case'
            And IsNull( C.DateOfInjury , '' ) <> ''
            And IsDate( C.DateOfInjury ) = 1
        
    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in PatientCaseDate Table for Date of Injury '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Primary Insurance Policy.
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
		    When IsNull( DC.Insured1 , '' ) <> '' And IsNull( DC.Insured1 , '' ) <> DC.ChartNumber Then
				Case
					When Upper( DC.InsuredRelationship1 ) = 'OTHER' Then 'O'	-- Other
					When Upper( DC.InsuredRelationship1 ) = 'CHILD' Then 'C' 	-- Child
					When Upper( DC.InsuredRelationship1 ) = 'SPOUSE' Then 'U'	-- Spouse
					Else 'U'
				End
		    Else 'O'
		    End As PatientRelationshipToInsured
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then DP.LastName Else NULL End HolderLastName
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then DP.FirstName Else NULL End HolderFirstName
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then DP.MiddleInitial Else NULL End HolderMiddleName
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then DP.Street1 Else NULL End HolderAddressLine1
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then DP.Street2 Else NULL End HolderAddressLine2
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then DP.City Else NULL End HolderCity
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then Left( DP.State , 2 ) Else NULL End HolderState
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then Left( DP.ZipCode , 9 ) Else NULL End HolderZipCode
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then 
                Case When DP.Sex = 'Female' Then 'F' Else 'M' End Else NULL End HolderGEnder
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then Left( DP.Phone1 , 10 ) Else NULL End HolderPhone
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then DP.DateOfBirth Else NULL End HolderDOB
        , Case When IsNull( DC.Insured1 , '' ) <> DC.ChartNumber And IsNull( DC.Insured1 , '' ) <> '' Then Left( DP.SocialSecurityNumber , 9 ) Else NULL End HolderSSN
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

    -- Insurance Secondary Insurance Policy.
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
        , Left(LTrim(RTrim(PolicyNumber2)),32) PolicyNumber
        , Left(LTrim(RTrim(GroupNumber2)),32) GroupNumber
        , 2
        , Policy2StartDate PolicyStartDate
        , Policy2EndDate PolicyEndDate
        , Case
		    When IsNull( DC.Insured2 , '' ) <> '' And IsNull( DC.Insured2 , '' ) = DC.ChartNumber Then 'S'
		    When IsNull( DC.Insured2 , '' ) <> '' And IsNull( DC.Insured2 , '' ) <> DC.ChartNumber Then
				Case
					When Upper( DC.InsuredRelationship2 ) = 'OTHER' Then 'O'	-- Other
					When Upper( DC.InsuredRelationship2 ) = 'CHILD' Then 'C' 	-- Child
					When Upper( DC.InsuredRelationship2 ) = 'SPOUSE' Then 'U'	-- Spouse
					Else 'U'
				End
		   Else 'O'
		   End As PatientRelationshipToInsured
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then DP.LastName Else Null End HolderLastName
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then DP.FirstName Else Null End HolderFirstName
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then DP.MiddleInitial Else Null End HolderMiddleName
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then DP.Street1 Else Null End HolderAddressLine1
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then DP.Street2 Else Null End HolderAddressLine2
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then DP.City Else Null End HolderCity
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then Left( DP.State , 2 ) Else Null End HolderState
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then Left( DP.ZipCode , 9 ) Else Null End HolderZipCode
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then 
                Case When DP.Sex = 'Female' Then 'F' Else 'M' End Else Null End HolderGender
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then Left( DP.Phone1 , 10 ) Else Null End HolderPhone
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then DP.DateOfBirth Else Null End HolderDOB
        , Case When IsNull( DC.Insured2 , '' ) <> DC.ChartNumber And IsNull( DC.Insured2 , '' ) <> '' Then Left( DP.SocialSecurityNumber , 9 ) Else Null End HolderSSN
        , DC.InsuranceCarrier2
        , @VendorImportID
    From iPatientCase DC
        Inner Join PatientCase PC ON PC.VendorImportID = @VendorImportID And Convert( Varchar(50) , DC.CaseNumber ) = PC.VendorID
        Left Join InsuranceCompanyPlan ICP ON ICP.VendorImportID = @VendorImportID AND DC.InsuranceCarrier2 = ICP.VendorID
        Left Join #EIP EIP ON DC.InsuranceCarrier2 = EIP.Code
        Left Join iPatient DP ON DC.Insured2 = DP.ChartNumber
    Where IsNull( DC.InsuranceCarrier2 , '' ) <> '' 
            And IsNull( EIP.InsuranceCompanyPlanID , ICP.InsuranceCompanyPlanID ) Is Not Null

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Secondary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Tertiary Insurance Policy.
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
        , PolicyNumber3 PolicyNumber
        , GroupNumber3 GroupNumber
        , 3
        , Policy3StartDate PolicyStartDate
        , Policy3EndDate PolicyEndDate
        , Case
		  When IsNull( DC.Insured3 , '' ) <> '' And IsNull( DC.Insured3 , '' ) = DC.ChartNumber Then 'S'
		  When IsNull( DC.Insured3 , '' ) <> '' And IsNull( DC.Insured3 , '' ) <> DC.ChartNumber Then
				Case
					When Upper( DC.InsuredRelationship3 ) = 'OTHER' Then 'O'	-- Other
					When Upper( DC.InsuredRelationship3 ) = 'CHILD' Then 'C' 	-- Child
					When Upper( DC.InsuredRelationship3 ) = 'SPOUSE' Then 'U'	-- Spouse
					Else 'U'
				End
		  Else 'O'
		  End As PatientRelationshipToInsured
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then DP.LastName Else Null End HolderLastName
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then DP.FirstName Else Null End HolderFirstName
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then DP.MiddleInitial Else Null End HolderMiddleName
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then DP.Street1 Else Null End HolderAddressLine1
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then DP.Street2 Else Null End HolderAddressLine2
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then DP.City Else Null End HolderCity
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then Left( DP.State , 2 ) Else Null End HolderState
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then Left( DP.ZipCode , 9 ) Else Null End HolderZipCode
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then 
            Case When DP.Sex = 'Female' Then 'F' Else 'M' End Else Null End HolderGender
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then Left( DP.Phone1 , 10 ) Else Null End HolderPhone
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then DP.DateOfBirth Else Null End HolderDOB
        , Case When IsNull( DC.Insured3 , '' ) <> DC.ChartNumber And IsNull( DC.Insured3 , '' ) <> '' Then Left( DP.SocialSecurityNumber , 9 ) Else Null End HolderSSN
        , DC.InsuranceCarrier3
        , @VendorImportID
    From iPatientCase DC
        Inner Join PatientCase PC On PC.VendorImportID = @VendorImportID And Convert( Varchar(50) , DC.CaseNumber ) = PC.VendorID
        Left Join InsuranceCompanyPlan ICP On ICP.VendorImportID = @VendorImportID And DC.InsuranceCarrier3 = ICP.VendorID
        Left Join #EIP EIP On DC.InsuranceCarrier3 = EIP.Code
        Left Join iPatient DP On DC.Insured3 = DP.ChartNumber
    Where IsNull( DC.InsuranceCarrier3 , '' ) <> ''
            And IsNull( EIP.InsuranceCompanyPlanID , ICP.InsuranceCompanyPlanID ) Is Not Null

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Tertiary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Insurance Policy Authorization.
    Insert Into InsurancePolicyAuthorization
    ( InsurancePolicyID
      , AuthorizationNumber
      , AuthorizedNumberOfVisits
      , StartDate
      , EndDate
      , VendorImportID
    )
    Select
        A.InsurancePolicyID
        , IsNull( D.VisitAuthorizationNo , '' ) As AuthorizationNumber
        , IsNull( D.AuthorizedNoOfVisits , 0 ) As AuthorizedNumberOfVisits
        , '01/01/2000' As StartDate
        , D.TreatmentAuthThrough As EndDate
        , @VendorImportID
    From InsurancePolicy A
            Inner Join PatientCase B On B.PatientCaseID = A.PatientCaseID
            Inner Join Patient C On C.PatientID = B.PatientID
            Inner Join iPatientCase D On Convert( Varchar(20) , D.CaseNumber ) = B.VendorID And D.ChartNumber = C.VendorID
    Where A.VendorImportID = @VendorImportID
            And A.Precedence = 1
            And ( ( IsNull( D.AuthorizedNoOfVisits , 0 ) <> 100 And IsNull( D.AuthorizedNoOfVisits , 0 ) <> 0 )
                    Or IsNull( D.VisitAuthorizationNo , '' ) <> ''
                    Or IsNull( D.TreatmentAuthThrough , '' ) <> '' )


    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicyAuthorization Table '
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
            Inner Join Employers C On C.VendorID = B.Employer
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
                And IsNull( D.AddressLine1 , '' ) = IsNull( C.Street1 , '' )
                And IsNull( D.AddressLine2 , '' ) = IsNull( C.Street2 , '' )
                And IsNull( D.City , '' ) = IsNull( C.City , '' )
                And IsNull( D.State , '' ) = IsNull( C.State , '' )
                And IsNull( D.ZipCode , '' ) = IsNull( C.ZipCode , '' )
        Where A.PracticeID = @PracticeID
            And B.PatientType <> 'Guarantor'
            And IsNull( D.VendorID , '' ) = ''

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Duplicate Employer ID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Drop Table #PCToUpdate
    Drop Table #PG
    Drop Table #EIC
    Drop Table #NIC
    Drop Table #EIP
    Drop Table #NIP
    Drop Table #RecentCases
    Drop Table #RefPhy

End
-- ROLLBACK
-- Commit Transaction

Set NoCount Off
