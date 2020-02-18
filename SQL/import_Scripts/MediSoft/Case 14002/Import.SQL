-- Customer : Promed Billing Associates (649)
-- Practice : Rajat Prakash
-- FogBugz Case ID : 14002


-- Tables Populated.
-- =================
-- 1. Doctor
-- 2. Patient

-- Important.
-- ==========
-- Make sure that the synonymn are created for each case before running this script.
--
/*
    Use superbill_0649_prod

    Drop Synonym iDoctor
    Go
    Drop Synonym iRefPhy
    Go
    Drop Synonym iPatient
    Go
    Drop Synonym iPatientCase
    Go
    Drop Synonym iFeeSchedule
    Go

    Create Synonym iDoctor For impMWPHY14002
    Go
    Create Synonym iRefPhy For impMWRPH14002
    Go
    Create Synonym iPatient For impMWPAT14002
    Go
    Create Synonym iPatientCase For impMWCAS14002
    Go
    Create Synonym iFeeSchedule For impMWPRO14002
    Go

*/

Use superbill_0649_prod
Go

Set NoCount On

Declare @Rows Int
        , @Message Varchar(75)

Declare @PracticeID int
Declare @VendorImportID int

If Not Exists ( Select Object_ID( 'dbo.fn_GetNumber' , 'FN' ) )
Begin
    RaisError( 'Function fn_GetNumber missing. Cannot Proceed.' , 11 , -1 )
    Return
End

Begin Transaction
Begin

    Insert Into VendorImport
    ( VendorName
      , Notes
      , VendorFormat
    )
    Values
    (
      'Rajat Prakash Practice'
      , 'Case 14002 :- Import Physicians, Ref. Physicians and Patients.'
      , 'MediSoft'
    )

    Set @VendorImportID = @@IDENTITY

    Set @PracticeID = 1

    Print 'Customer : Promed Billing Associates.'
    Print 'FogBugz Case ID : 14002'
    Print ''
    Print 'Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )
    Print ''
    Print 'Current Date & Time : ' + Convert( Varchar(20) , GetDate() )
    Print ''

    Update iDoctor
        Set ZipCode = dbo.fn_GetNumber( ZipCode )

    Update iDoctor
        Set Phone = dbo.fn_GetNumber( Phone )

    Update iDoctor
        Set Fax = dbo.fn_GetNumber( Fax )

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
        Set Phone3 = dbo.fn_GetNumber( Phone3 )

    Update iPatient
        Set Phone4 = dbo.fn_GetNumber( Phone4 )

    Update iPatient
        Set Phone5 = dbo.fn_GetNumber( Phone5 )

    Update iPatient
        Set WorkPhone = dbo.fn_GetNumber( WorkPhone )

    Update iPatient
        Set ZipCode = dbo.fn_GetNumber( ZipCode )

    Update iPatient
        Set SocialSecurityNumber = dbo.fn_GetNumber( SocialSecurityNumber )

    Update iPatient
        Set ContactPhone1 = dbo.fn_GetNumber( ContactPhone1 )

    Update iPatient
        Set ContactPhone2 = dbo.fn_GetNumber( ContactPhone2 )

    -- Import Tables Order.
    -- ====================
    -- Physicians
    -- Referring Physicians
    -- Patients

    /*
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
      , FirstName
    	, MiddleInitial
    	, LastName
    	, ''
    	, Credentials
    	-- , Case When UPIN Is Not Null Then LTrim(RTrim(UPIN)) Else '' End
    	, SSNOrFedTaxID
    	-- , Case When TaxonomyCode Is Not Null Then LTrim(RTrim(TaxonomyCode)) Else NULL End
    	, Phone
    	, Fax
    	, Street1
    	, Street2
    	, City
    	, State
    	, ZipCode
    	, 'PRA00' As Code
    	, @VendorImportID
    	, 0
    From iDoctor
    Where Code = 'RP01'

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for Physicians '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
    */

    /*
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
    Select
      @PracticeID
      , '' As Prefix
      , FirstName
    	, MiddleInitial
    	, LastName
    	, '' As Suffix
    	, Credentials
    	-- , Case When UPIN Is Not Null Then LTrim(RTrim(UPIN)) Else '' End
    	, SSNOrFedTaxID
    	-- , Case When TaxonomyCode Is Not Null Then LTrim(RTrim(TaxonomyCode)) Else NULL End
    	, Phone
    	, Fax
    	, Street1
    	, Street2
    	, City
    	, State
    	, ZipCode
    	, Code
    	, @VendorImportID
    	, 1
    From iRefPhy
    Where Code Not In ( 'BRA00' , 'DRPEN' )

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for Referring Physicians '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
    */

    Update Doctor
        Set VendorID = 'PRA00'

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
    	, PAT.MiddleInitial
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
    	-- MariatalStatus not available in patients table
    	, 'U' As MaritalStatus
    	, PAT.Phone1
    	, PAT.WorkPhone
    	, PAT.WorkExtension
    	, PAT.DateOfBirth
    	, Case
            When Len( PAT.SocialSecurityNumber ) = 9 Then PAT.SocialSecurityNumber
            Else Null
        End
      , PAT.ChartNumber
    	, Case When PG.PatientChartNumber Is Not Null Then 1 Else 0 End
    	, Case When PG.PatientChartNumber Is Not Null Then pg.ResponsibleFirstName Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then pg.ResponsibleMiddleName Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then pg.ResponsibleLastName Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then pg.ResponsibleAddressLine1 Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then pg.ResponsibleAddressLine2 Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then pg.ResponsibleCity Else NULL End
    	, Case When PG.PatientChartNumber Is Not Null Then pg.ResponsibleState Else NULL End
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

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Patient Table '
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
            Inner Join @RefToPatient RTP On P.VendorImportID = @VendorImportID AND P.VendorID = RTP.ChartNumber
            Inner Join Doctor D On RTP.ReferringProvider = D.VendorID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Referring Physicians '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


End
-- ROLLBACK
-- Commit Transaction

Set NoCount Off
