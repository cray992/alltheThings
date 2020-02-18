-- C:\Work\Data Imports\Case 15487\Scripts\Import.SQL
-- Customer : MasterPlan Medical Billing Services.
-- Case No. : 15487.

/*

    Drop Synonym iPatient
    Go
    Drop Synonym iFees
    Go

    Create Synonym iPatient For impPatients15487
    Go
    Create Synonym iFees For impFeeSchedule15487
    Go

    Alter Table Employers
        Add VendorImportID Int
*/

Set NoCount On

-- Use superbill_0670_prod
-- Go

Use superbill_0121_prod
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
    ( 'Case 15487 :- Debra Miller Practice.'
      , 'CSV'
      , 'Case 15487 :- Import Patient Demographics and Insurance Policies.'
    )

    Select @VendorImportID = @@Identity

    Print 'Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )
    Print ''

    -- Debra Miller Practice.
    Select @PracticeID = 4
    
    Insert Into Patient
    ( PracticeID
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
    Select
      @PracticeID
      , '' As Prefix
      , A.FirstName
      , IsNull( A.MiddleInitial , '' ) As MiddleName
      , A.LastName
      , IsNull( A.Suffix , '' ) As Suffix
      , A.Address1
      , A.Address2
      , A.City
      , A.State
      , ( Select dbo.fn_GetNumber( A.ZipCode ) ) As ZipCode
      , ( Select dbo.fn_GetNumber( A.HomePhone ) ) As HomePhone
      , ( Select dbo.fn_GetNumber( Left( A.WorkPhone , 14 ) ) ) As WorkPhone
      , Case When CharIndex( 'x321' , WorkPhone ) > 0 Then '321' Else Null End As WorkPhoneExt
      , ( Select dbo.fn_GetNumber( A.MobilePhone ) ) As MobilePhone
      , Case
            When Sex = 'Male' Then 'M'
            When Sex = 'Female' Then 'F'
            Else 'U'
        End As Gender
      , Case
            When MaritalStatus = 'Single' Then 'S'
            When MaritalStatus = 'Married' Then 'M'
            When MaritalStatus = 'Divorced' Then 'D'
            When MaritalStatus = 'Widowed' Then 'W'
            When IsNull( MaritalStatus , '' ) = '' Then Null
            Else 'U'
        End As MaritalStatus
      , Convert( Datetime , DOB ) As DOB
      , ( Select dbo.fn_GetNumber( A.SSN ) ) As SSN
      , HomeEmail As EmailAddress
      , Case When EmploymentStatus = 'Employment' Then 'E'
             When EmploymentStatus = 'Employment Full time' Then 'E'
             When EmploymentStatus = 'Employment Retired' Then 'R'
             When EmploymentStatus = 'Employment Not employed' Then Null
        Else 'U'
        End As EmploymentStatus
      , A.VendorID As MedicalRecordNumber
      , A.VendorID
      , @VendorImportID
    From iPatient A
    Where Not Exists
            ( Select * From Patient B 
                    Where B.PracticeID = @PracticeID
                            And B.FirstName = A.FirstName
                            And B.LastName = A.LastName )
    Order By A.LastName , A.FirstName
    
    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Patient Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    /*
    Insert Into Doctor
    ( PracticeID
      , Prefix
      , FirstName
      , MiddleName
      , LastName
      , Suffix
      , [External]
      , VendorImportID
    )
    Values
    ( @PracticeID
      , ''
      , 'Debra'
      , 'Carter'
      , 'Miller'
      , ''
      , 1
      , @VendorImportID
    )

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for Referring Physician '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Update A
        Set ReferringPhysicianID = C.DoctorID
        From Patient A
                Inner Join iPatient B On B.VendorID = A.VendorID
                Inner Join Doctor C On C.PracticeID = @PracticeID 
                    And C.FirstName + ' ' + C.MiddleName + ' ' + C.LastName = B.ReferringPhysician
        Where A.VendorImportID = @VendorImportID
                And IsNull( B.ReferringPhysician , '' ) <> ''

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Referring Physician '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    */

    -- Doctor table already has a record for "Debra Miller".
    Update A
        Set ReferringPhysicianID = 138
        From Patient A
                Inner Join iPatient B On B.VendorID = A.VendorID
        Where A.VendorImportID = @VendorImportID
                And IsNull( B.ReferringPhysician , '' ) <> ''

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Referring Physician '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


    Select Distinct PrimaryInsurance As InsuranceCompanyName Into #tmp1 From iPatient Where IsNull( PrimaryInsurance , '' ) <> ''
    Union
    Select Distinct SecondaryInsurance From iPatient Where IsNull( SecondaryInsurance , '' ) <> ''
    Union
    Select Distinct TertiaryInsurance From iPatient Where IsNull( TertiaryInsurance , '' ) <> ''

    Insert Into InsuranceCompany
    ( InsuranceCompanyName
      , ReviewCode
      , VendorImportID
    )
    Select
        A.InsuranceCompanyName
        , 'R' As ReviewCode
        , @VendorImportID
        From #tmp1 A
        Where Not Exists
                ( Select * From InsuranceCompany B
                        Where B.InsuranceCompanyName = A.InsuranceCompanyName )

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsuranceCompany Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Insert Into InsuranceCompanyPlan
    ( InsuranceCompanyID
      , PlanName
      , ReviewCode
      , VendorImportID
    )
    Select
        A.InsuranceCompanyID
        , A.InsuranceCompanyName
        , A.ReviewCode
        , @VendorImportID
        From InsuranceCompany A
        Where Not Exists 
                ( Select * From InsuranceCompanyPlan B Where B.InsuranceCompanyID = A.InsuranceCompanyID )

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsuranceCompanyPlan Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
    
    -- Collect InsuranceCompanyPlanID for Insurance Policies.
    Select Distinct
        A.InsuranceCompanyName
        , B.InsuranceCompanyID
        , ( Select Min( C.InsuranceCompanyPlanID ) From InsuranceCompanyPlan C Where C.InsuranceCompanyID = B.InsuranceCompanyID ) As InsuranceCompanyPlanID
        Into #tmp2
        From #tmp1 A    
                Inner Join ( Select Min( InsuranceCompanyID ) As InsuranceCompanyID
                                     , InsuranceCompanyName 
                                From InsuranceCompany Group By InsuranceCompanyName ) B 
                    On B.InsuranceCompanyName = A.InsuranceCompanyName

    -- Select * From #tmp2 Order By InsuranceCompanyName

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
    Select Distinct
      C.PatientCaseID
      , D.InsuranceCompanyPlanID
      , 1 As Precedence
      , A.PrimaryID As PolicyNumber
      , A.PrimaryGroupNumber As GroupNumber
      , Null As PolicyStartDate
      , Null As PolicyEndDate
      , 'S' As PatientRelationShipToInsured
      , 1 As Active
      , Convert( Money , A.CoPayAmt ) As CoPay
      , @PracticeID
      , A.VendorID
      , @VendorImportID
    From iPatient A
            Inner Join Patient B On B.VendorID = A.VendorID And B.PracticeID = @PracticeID
            Inner Join PatientCase C On C.PatientID = B.PatientID
            Inner Join #tmp2 D On D.InsuranceCompanyName = A.PrimaryInsurance
    Where IsNull( PrimaryInsurance , '' ) <> ''
            And ( IsNull( A.PrimaryGroupNumber , '' ) <> '' Or IsNull( A.PrimaryID , '' ) <> '' )
            And B.VendorImportID = @VendorImportID

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
    Select Distinct
      C.PatientCaseID
      , D.InsuranceCompanyPlanID
      , 2 As Precedence
      , A.SecondaryID As PolicyNumber
      , A.SecondaryGroupNumber As GroupNumber
      , Null As PolicyStartDate
      , Null As PolicyEndDate
      , 'S' As PatientRelationShipToInsured
      , 1 As Active
      , Convert( Money , A.CoPayAmt ) As CoPay
      , @PracticeID
      , A.VendorID
      , @VendorImportID
    From iPatient A
            Inner Join Patient B On B.VendorID = A.VendorID And B.PracticeID = @PracticeID
            Inner Join PatientCase C On C.PatientID = B.PatientID
            Inner Join #tmp2 D On D.InsuranceCompanyName = A.SecondaryInsurance
    Where IsNull( SecondaryInsurance , '' ) <> ''
            And ( IsNull( A.SecondaryGroupNumber , '' ) <> '' Or IsNull( A.SecondaryID , '' ) <> '' )
            And B.VendorImportID = @VendorImportID

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
    Select Distinct
      C.PatientCaseID
      , D.InsuranceCompanyPlanID
      , 3 As Precedence
      , A.TertiaryID As PolicyNumber
      , A.TertiaryGroupNumber As GroupNumber
      , Null As PolicyStartDate
      , Null As PolicyEndDate
      , 'S' As PatientRelationShipToInsured
      , 1 As Active
      , Convert( Money , A.CoPayAmt ) As CoPay
      , @PracticeID
      , A.VendorID
      , @VendorImportID
    From iPatient A
            Inner Join Patient B On B.VendorID = A.VendorID And B.PracticeID = @PracticeID
            Inner Join PatientCase C On C.PatientID = B.PatientID
            Inner Join #tmp2 D On D.InsuranceCompanyName = A.TertiaryInsurance
    Where IsNull( TertiaryInsurance , '' ) <> ''
            And ( IsNull( A.TertiaryGroupNumber , '' ) <> '' Or IsNull( A.TertiaryID , '' ) <> '' )
            And B.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Tertiary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Update Holder Details for Primary Insured Patients.
    Update A
        Set HolderFirstName = ( Select dbo.fn_GetName2( B.PrimaryInsured , 'F' , 'FML' ) ) 
            , HolderMiddleName = ( Select dbo.fn_GetName2( PrimaryInsured , 'M' , 'FML' ) )
            , HolderLastName = ( Select dbo.fn_GetName2( PrimaryInsured , 'L' , 'FML' ) )
            , PatientRelationshipToInsured = 
                Case
                    When PrimaryInsuredRelation = 'Spouse' Then 'U'
                    When PrimaryInsuredRelation = 'Child' Then 'C'
                    Else 'O'
                End
            , HolderDOB = Null
            , HolderSSN = Null
            , HolderGender = Null
            , HolderAddressLine1 = Null
            , HolderAddressLine2 = Null
            , HolderCity = Null
            , HolderState = Null
            , HolderCountry = Null
            , HolderZipCode = Null
            , HolderPhone = Null
            , HolderPhoneExt = Null
            , HolderThroughEmployer =
                Case When PrimaryType = 'Employer' Then 1
                Else 0
                End
        From InsurancePolicy A
                Inner Join iPatient B On B.VendorID = A.VendorID
	             Inner Join Patient C On C.VendorID = B.VendorID And C.PracticeID = @PracticeID
        Where A.VendorImportID = @VendorImportID
                And A.Precedence = 1
                And IsNull( B.PrimaryInsurance , '' ) <> ''
                And ( IsNull( B.PrimaryGroupnumber , '' ) <> '' Or IsNull( B.PrimaryID , '' ) <> '' )
                And B.PrimaryInsured <> 'Self'

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in InsurancePolicy Table for Holder Primary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Update Holder Details for Secondary Insured Patients.
    Update A
        Set HolderFirstName = ( Select dbo.fn_GetName2( B.SecondaryInsured , 'F' , 'FML' ) ) 
            , HolderMiddleName = ( Select dbo.fn_GetName2( SecondaryInsured , 'M' , 'FML' ) )
            , HolderLastName = ( Select dbo.fn_GetName2( SecondaryInsured , 'L' , 'FML' ) )
            , PatientRelationshipToInsured = 
                Case
                    When SecondaryInsuredRelation = 'Spouse' Then 'U'
                    When SecondaryInsuredRelation = 'Child' Then 'C'
                    Else 'O'
                End
            , HolderDOB = Null
            , HolderSSN = Null
            , HolderGender = Null
            , HolderAddressLine1 = Null
            , HolderAddressLine2 = Null
            , HolderCity = Null
            , HolderState = Null
            , HolderCountry = Null
            , HolderZipCode = Null
            , HolderPhone = Null
            , HolderPhoneExt = Null
            , HolderThroughEmployer =
                Case When SecondaryType = 'Employer' Then 1
                Else 0
                End
        From InsurancePolicy A
                Inner Join iPatient B On B.VendorID = A.VendorID
	             Inner Join Patient C On C.VendorID = B.VendorID And C.PracticeID = @PracticeID
        Where A.VendorImportID = @VendorImportID
                And A.Precedence = 2
                And IsNull( B.SecondaryInsurance , '' ) <> ''
                And ( IsNull( B.SecondaryGroupnumber , '' ) <> '' Or IsNull( B.SecondaryID , '' ) <> '' )
                And B.SecondaryInsured <> 'Self'

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in InsurancePolicy Table for Holder Secondary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Employers.
    Insert Into Employers
    ( EmployerName 
      , VendorImportID
    )
    Select
      EmployerAddress1
      , @VendorImportID
    From iPatient Where IsNull( EmployerAddress1 , '' ) <> ''

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Employer Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Update A
        Set EmployerID = C.EmployerID
        From Patient A
                Inner Join iPatient B On B.VendorID = A.VendorID
                Inner Join Employers C On C.EmployerName = B.EmployerAddress1
        Where IsNull( B.EmployerAddress1 , '' ) <> ''
                And A.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for Employer ID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


	Insert Into Contract
	( PracticeID
      , ContractName
      , Description
      , ContractType
      , EffectiveStartDate
      , EffectiveEndDate
	   , NoResponseTriggerPaper
	   , NoResponseTriggerElectronic
    )
	Select
      @PracticeID
      , 'Standard Fee Schedule'
      , 'Standard Fees'
      , 'P'
      , GetDate()
      , DateAdd( yy , 1 , GetDate() )
      , 45
      , 45

	Select @ContractID = @@Identity

   Select @Message = 'New Contract ID '
   Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(2) , @ContractID )

	Insert Into ContractFeeSchedule
	( ProcedureCodeDictionaryID
	  , ContractID
	  , Modifier
	  , Gender
	  , StandardFee
     , Allowable
     , ExpectedReimbursement
	  , RVU
	  , VendorImportID
	)
	Select Distinct
	  B.ProcedureCodeDictionaryID
	  , @ContractID
     , Null As Modifier
	  , 'B' As Gender
	  , Convert( Decimal(10,2) , A.StandardFee ) As StandardFee
	  , 0 As Allowable
	  , 0 As ExpectedReimbursement
	  , 0 As RVU
     , @VendorImportID
	From iFees A
			Inner Join ProcedureCodeDictionary B On B.ProcedureCode = A.ProcedureCode
   Where Convert( Decimal(10,2) , A.StandardFee ) <> 0

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ContractFeeSchedule Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
    Print ''

    Drop Table #tmp1
    Drop Table #tmp2
    
End
-- Commit Transaction
-- RollBack
