-- Customer : Department B
-- Practice : Dr. Gary Ray.
-- Case No. : 15935.

/*

    Alter Table Employers
        Add VendorImportID Int

*/

Set NoCount On

-- Testing.
-- Use superbill_0875_prod
-- Go

-- Production Deployment.
Use superbill_0001_prod
Go

Declare @PracticeID		    Int
		, @VendorID			    Varchar(10)
      , @Rows				    Int
      , @Message			    VarChar(75)
      , @VendorImportID     Int
      , @ContractID         Int

Begin Transaction
Begin

    Insert Into VendorImport
    ( VendorName
      , VendorFormat
      , Notes
    )
    Values
    ( 'Case 15935 :- Dr. Gary Ray Practice.'
      , 'CSV'
      , 'Case 15935 :- Import Patient Demographics and Insurance Policies.'
    )

    Select @VendorImportID = @@Identity

    Print 'Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )
    Print ''

    -- Dr. Gary Ray Practice.
    Select @PracticeID = 124
    
    Insert Into Patient
    ( PracticeID
      , Prefix
      , LastName
      , FirstName
      , MiddleName
      , Suffix
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , HomePhone
      , WorkPhone
      , WorkPhoneExt
      , MobilePhone
      , Gender
      , MaritalStatus
      , DOB
      , SSN
      , EmailAddress
      , EmploymentStatus
      , MedicalRecordNumber
      , VendorID
      , VendorImportID
    )
    Select Distinct
        @PracticeID
        , '' As Prefix
        , A.LastName
        , A.FirstName
        , A.MiddleInitial As MiddleName
        , '' As Suffix
        , B.AddressLine1
        , B.AddressLine2
        , B.City
        , B.State
        , B.ZipCode + IsNull( B.ZipCodeExt , '' )
        , B.AreaCode + B.Phone As HomePhone
        , A.EmployerAreaCode + A.EmployerPhone As WorkPhone
        , Null As WorkPhoneExt
        , Null As MobilePhone
        , A.Sex As Gender
        , Null As MaritalStatus
        , Case
            When IsNull( A.BirthDate , '' ) = '' Then Null
            Else Convert( DateTime , Left( A.BirthDate , 2 ) + '/' + SubString( A.BirthDate , 3 , 2 ) + '/' + Right( A.BirthDate , 4 ) ) 
            End As DOB
        , A.SSN
        , Null As EmailAddress
        , Null As EmploymentStatus
        , A.AccountNo As MedicalRecordNumber
        , A.AccountNo + A.PatientNumber As VendorID
        , @VendorImportID
    From impPatient15935 A
            Inner Join impResponsible15935 B On B.AccountNo = A.AccountNo And B.[Column 1] = A.[Column 1]
    Order By A.LastName , A.FirstName

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Patient Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Not needed for deployment into production. Record is already present.
    /*
    Insert Into Doctor
    ( PracticeID
      , Prefix
      , FirstName
      , MiddleName
      , LastName
      , Suffix
      , Degree
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , WorkPhone
      , [External]
      , VendorID
      , VendorImportID
    )
    Select
      @PracticeID
      , '' As Prefix
      , 'Gary' As FirstName
      , '' As MiddleName
      , 'Ray' As LastName
      , '' As Suffix
      , 'MD' As Degree
      , A.AddressLine1
      , A.AddressLine2
      , A.City
      , A.State
      , A.ZipCode + IsNull( A.ZipCodeExt , '' )
      , A.AreaCode + A.Phone As WorkPhone
      , 0 As [External]
      , A.DoctorID As VendorID
      , @VendorImportID
    From impRefPhy15935 A
    Where A.DoctorID = '2'

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for Provider '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- NPI Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	 Select D.DoctorID
           , 8
           , TP.NPI
		From Doctor D
				Inner Join impRefPhy15935 TP On D.VendorID = TP.DoctorID
		Where IsNull( TP.NPI , '' ) <> ''
				And D.VendorImportID = @VendorImportID
            And TP.DoctorID = '2'

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for NPI (Provider) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- MedicaidID Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	 Select D.DoctorID
           , 24
           , TP.MedicaidID
		From Doctor D
				Inner Join impRefPhy15935 TP On D.VendorID = TP.DoctorID
		Where IsNull( TP.MedicaidID , '' ) <> ''
				And D.VendorImportID = @VendorImportID
            And TP.DoctorID = '2'

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for MedicaidID (Provider) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
    */

    Insert Into Doctor
    ( PracticeID
      , Prefix
      , FirstName
      , MiddleName
      , LastName
      , Suffix
      , Degree
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , WorkPhone
      , [External]
      , VendorID
      , VendorImportID
    )
    Select
      @PracticeID
      , '' As Prefix
      , dbo.fn_GetName2( A.FirstName , 'F' , 'FM' ) As FirstName
      , IsNull( dbo.fn_GetName2( A.FirstName , 'M' , 'FM' ) , '' ) As MiddleName
      , A.LastName2
      , '' As Suffix
      , A.Degree
      , A.AddressLine1
      , A.AddressLine2
      , A.City
      , A.State
      , A.ZipCode + IsNull( A.ZipCodeExt , '' )
      , A.AreaCode + A.Phone As WorkPhone
      , 1 As [External]
      , A.DoctorID As VendorID
      , @VendorImportID
    From impRefPhy15935 A
    Where A.DoctorID <> '2'

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for Referring Physicians '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- NPI Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	 Select D.DoctorID
           , 8
           , TP.NPI
		From Doctor D
				Inner Join impRefPhy15935 TP On D.VendorID = TP.DoctorID
		Where IsNull( TP.NPI , '' ) <> ''
				And D.VendorImportID = @VendorImportID
            And TP.DoctorID <> '2'

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for NPI (Referring Physician) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- MedicaidID Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	 Select D.DoctorID
           , 24
           , TP.MedicaidID
		From Doctor D
				Inner Join impRefPhy15935 TP On D.VendorID = TP.DoctorID
		Where IsNull( TP.MedicaidID , '' ) <> ''
				And D.VendorImportID = @VendorImportID
            And TP.DoctorID <> '2'

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for MedicaidID (Referring Physician) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Update A
        Set PrimaryProviderID = C.DoctorID
        From Patient A
                Inner Join impPatient15935 B On B.AccountNo + B.PatientNumber = A.VendorID
                Inner Join Doctor C On C.VendorID = B.DoctorNumber
        Where IsNull( B.DoctorNumber , '' ) <> ''
                And A.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Rendering Provider '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Update A
        Set ReferringPhysicianID = C.DoctorID
        From Patient A
                Inner Join impPatient15935 B On B.AccountNo + B.PatientNumber = A.VendorID
                Inner Join Doctor C On C.VendorID = B.ReferringDoctor
        Where IsNull( B.ReferringDoctor , '' ) <> ''
                And A.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Referring Physician '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Insert Into InsuranceCompany
    ( InsuranceCompanyName
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , Phone
      , ContactFirstName
      , ReviewCode
      , VendorID
      , VendorImportID
    )
    Select 
        A.CarrierName As InsuranceCompanyName
        , A.AddressLine1
        , A.AddressLine2
        , A.City
        , A.State
        , A.ZipCode + IsNull( A.ZipCodeExt , '' )
        , A.AreaCode + A.Phone
        , A.ContactName
        , 'R' As ReviewCode
        , A.CarrierID As VendorID
        , @VendorImportID
    From impCarrier15935 A

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsuranceCompany Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Insert Into InsuranceCompanyPlan
    ( InsuranceCompanyID
      , PlanName
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , Phone
      , ContactFirstName
      , ReviewCode
      , VendorID
      , VendorImportID
    )
    Select
        A.InsuranceCompanyID
        , A.InsuranceCompanyName As PlanName
        , A.AddressLine1
        , A.AddressLine2
        , A.City
        , A.State
        , A.ZipCode
        , A.Phone
        , A.ContactFirstName
        , A.ReviewCode
        , A.VendorID
        , A.VendorImportID
    From InsuranceCompany A
    Where A.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsuranceCompanyPlan Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Insert Into PatientCase
    ( PatientID
      , [Name]
      , PayerScenarioID
      , PracticeID
      , VendorID
      , VendorImportID
    )
    Select Distinct
      A.PatientID
      , 'Default Case'
      , 5 As PayerScenarioID
      , A.PracticeID
      , A.VendorID
      , @VendorImportID
    From Patient A
	 Where A.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in PatientCase Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Primary Insurance Policy.
    Insert Into InsurancePolicy
    ( PatientCaseID
      , InsuranceCompanyPlanID
      , Precedence
      , PolicyNumber
      , GroupNumber
      , PolicyStartDate
      , PolicyEndDate
      , PatientRelationShiptoInsured
      , Active
      , CoPay
      , PracticeID
      , VendorID
      , VendorImportID
    )
    Select
      C.PatientCaseID
      , D.InsuranceCompanyPlanID
      , 1 As Precedence
      , B.PolicyNumber1
      , B.GroupNumber1
      , Null As PolicyStartDate
      , Null As PolicyEndDate
      , 'S' As PatientRelationShipToInsured
      , 1 As Active
      , 0 As CoPay
      , @PracticeID
      , B.AccountNo As VendorID
      , @VendorImportID
    From Patient A
            Inner Join impPatient15935 B On B.AccountNo + B.PatientNumber = A.VendorID 
            Inner Join PatientCase C On C.PatientID = A.PatientID
            Inner Join InsuranceCompanyPlan D On D.VendorID = B.NewCarrierID1
            Inner Join InsuranceCompany E On E.InsuranceCompanyID = D.InsuranceCompanyID
    Where A.VendorImportID = @VendorImportID
            And IsNull( B.NewCarrierID1 , '' ) <> ''

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Primary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Secondary Insurance Policy.
    Insert Into InsurancePolicy
    ( PatientCaseID
      , InsuranceCompanyPlanID
      , Precedence
      , PolicyNumber
      , GroupNumber
      , PolicyStartDate
      , PolicyEndDate
      , PatientRelationShiptoInsured
      , Active
      , CoPay
      , PracticeID
      , VendorID
      , VendorImportID
    )
    Select
      C.PatientCaseID
      , D.InsuranceCompanyPlanID
      , 2 As Precedence
      , B.PolicyNumber2
      , B.GroupNumber2
      , Null As PolicyStartDate
      , Null As PolicyEndDate
      , 'S' As PatientRelationShipToInsured
      , 1 As Active
      , 0 As CoPay
      , @PracticeID
      , B.AccountNo As VendorID
      , @VendorImportID
    From Patient A
            Inner Join impPatient15935 B On B.AccountNo + B.PatientNumber = A.VendorID 
            Inner Join PatientCase C On C.PatientID = A.PatientID
            Inner Join InsuranceCompanyPlan D On D.VendorID = B.NewCarrierID2
            Inner Join InsuranceCompany E On E.InsuranceCompanyID = D.InsuranceCompanyID
    Where A.VendorImportID = @VendorImportID
            And IsNull( B.NewCarrierID2 , '' ) <> ''

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Secondary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Tertiary Insurance Policy.
    Insert Into InsurancePolicy
    ( PatientCaseID
      , InsuranceCompanyPlanID
      , Precedence
      , PolicyNumber
      , GroupNumber
      , PolicyStartDate
      , PolicyEndDate
      , PatientRelationShiptoInsured
      , Active
      , CoPay
      , PracticeID
      , VendorID
      , VendorImportID
    )
    Select
      C.PatientCaseID
      , D.InsuranceCompanyPlanID
      , 3 As Precedence
      , B.PolicyNumber3
      , B.GroupNumber3
      , Null As PolicyStartDate
      , Null As PolicyEndDate
      , 'S' As PatientRelationShipToInsured
      , 1 As Active
      , 0 As CoPay
      , @PracticeID
      , B.AccountNo As VendorID
      , @VendorImportID
    From Patient A
            Inner Join impPatient15935 B On B.AccountNo + B.PatientNumber = A.VendorID 
            Inner Join PatientCase C On C.PatientID = A.PatientID
            Inner Join InsuranceCompanyPlan D On D.VendorID = B.NewCarrierID3
            Inner Join InsuranceCompany E On E.InsuranceCompanyID = D.InsuranceCompanyID
    Where A.VendorImportID = @VendorImportID
            And IsNull( B.NewCarrierID3 , '' ) <> ''

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Tertirary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Update A
        Set PayerScenarioID = 11
        From PatientCase A
                Left Outer Join InsurancePolicy B On B.PatientCaseID = A.PatientCaseID
        Where A.VendorImportID = @VendorImportID
                And B.PatientCaseID Is Null

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in PatientCase Table for Self-Pay '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Insert Into Employers
    ( EmployerName 
      , VendorImportID )
    Select Distinct 
            A.EmployerName 
            , @VendorImportID
        From impPatient15935 A
        Where IsNull( A.EmployerName , '' ) <> ''
                And A.EmployerName Not In ( Select EmployerName From Employers )

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Employers Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Update A
        Set EmployerID = C.EmployerID
        From Patient A
                Inner Join impPatient15935 B On B.AccountNo + B.PatientNumber = A.VendorID
                Inner Join Employers C On C.EmployerName = B.EmployerName
        Where A.VendorImportID = @VendorImportID
                And IsNull( B.EmployerName , '' ) <> ''

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for EmployerID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

End
-- Commit Transaction
-- RollBack
