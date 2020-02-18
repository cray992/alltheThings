-- C:\Work\Data Imports\Physician's Electronic Billing Solutions (613)\Case 14621\Scripts\Import.SQL

/*
    
    Source File         Intermediate File       Notes
    -----------         -----------------       -----

    drfile.dat          tab_doctors.txt         Doctors.
    reffile.dat         tab_reffile.txt         Referring Physicians.
    carrier.dme         tab_carrier.txt         Insurance Companies.
    clmfile.dat         tab_insplan.txt         Insurance Company Plans.
    patfile.dat         tab_patients.txt        Patients.
    insfile.dat         tab_patins.txt          Patient Insurance Policies.
    iprfile.dat         tab_patipr.txt          Patient Insured Party.


    Use superbill_0613_prod
    -- Use superbill_0670_prod

    -- Facial Plastic Practice.

    Drop Synonym iDoctor
    Go
    Drop Synonym iRefPhy
    Go
    Drop Synonym iPatient
    Go
    Drop Synonym iInsCompany
    Go
    Drop Synonym iInsPlan
    Go
    Drop Synonym iInsPolicy
    Go
    Drop Synonym iInsParty
    Go

    Create Synonym iDoctor For impDoctors14621
    Go
    Create Synonym iRefPhy For impReffile14621
    Go
    Create Synonym iPatient For impPatients14621
    Go
    Create Synonym iInsCompany For impCarrier14621
    Go
    Create Synonym iInsPlan For impInsPlan14621
    Go
    Create Synonym iInsPolicy For impPatIns14621
    Go
    Create Synonym iInsParty For impPatIpr14621
    Go

    -- Blumenthal Practice.

    Drop Synonym iDoctorB
    Go
    Drop Synonym iRefPhyB
    Go
    Drop Synonym iPatientB
    Go
    Drop Synonym iInsCompany
    Go
    Drop Synonym iInsPlan
    Go
    Drop Synonym iInsPolicyB
    Go
    Drop Synonym iInsPartyB
    Go
    Drop Synonym iFeesB
    Go

    Create Synonym iDoctorB For impDoctors14621B
    Go
    Create Synonym iRefPhyB For impReffile14621B
    Go
    Create Synonym iPatientB For impPatients14621B
    Go
    Create Synonym iInsCompany For impCarrier14621
    Go
    Create Synonym iInsPlan For impInsPlan14621
    Go
    Create Synonym iInsPolicyB For impPatIns14621B
    Go
    Create Synonym iInsPartyB For impPatIpr14621B
    Go
    Create Synonym iFeesB For impProcedureCodes14621B
    Go
*/

Set NoCount On

Use superbill_0613_prod

Begin Transaction
Begin

    -- Source Table         Target Table.
    -- =======================================
    -- Reffile              Referring Physician
    -- Patients             Patient
    -- Carrier              InsuranceCompany
    -- InsPlan              InsuranceCompanyPlan
    -- PatIns               InsurancePolicy
    -- PatIpr               InsurancePolicy.HolderInfo

    Update IP
        Set ZipCode = Replace( ZipCode , ' ' , '' )
        From iInsPlan IP

    Declare @Rows       Int
            , @Message  Varchar(75)

    Declare @PracticeID         Int
            , @VendorImportID   Int
            , @ContractID       Int

    Insert Into VendorImport
    ( VendorName
      , VendorFormat
      , Notes
    )
    Values
    ( 'Case 14621 :- Blumenthal Practice.'
      , 'Medical Manager Data Format'
      , 'Import Patients, Ref. Phys., Ins Companies & Plans, Ins Policies & Ins Holders.'
    )

    Select @VendorImportID = @@Identity

    Print 'Vendor Import ID :- ' + Convert( Varchar(5) , @VendorImportID )
    Print ''

    Select @PracticeID = 2

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
      , FaxNumber
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , [External]
      , VendorID
      , VendorImportID
    )
    Select
      @PracticeID
      , '' As Prefix
      , FirstName
      , MiddleName
      , LastName
      , '' As Suffix
      , '' As Degree
      , SSN
      , Phone As WorkPhone
      , '' As FaxNumber
      , AddressLine1
      , Null As AddressLine2
      , City
      , State
      , ZipCode
      , 0 As [External]
      , A.ProviderID As VendorID
      , @VendorImportID
    From iDoctorB A
    Where A.ProviderID = '1'

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for Providers '
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
      , WorkPhone
      , FaxNumber
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , [External]
      , VendorID
      , VendorImportID
    )
    Select
      @PracticeID
      , '' As Prefix
      , FirstName
      , MiddleName
      , LastName
      , '' As Suffix
      , '' As Degree
      , '' As SSN
      , WorkPhone        
      , '' As FaxNumber
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , 1 As [External]
      , MM_ref_dr_no As VendorID
      , @VendorImportID
    From iRefPhyB
    Where MM_Ref_Dr_No <> '1'
    Order By Convert( Int , MM_Ref_Dr_No )

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for Referring Physicians '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

	 -- Added UPIN records for Providers.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select A.DoctorID
           , 25
           , B.UPIN
		From Doctor A
				Inner Join iRefPhyB B On A.VendorID = B.MM_Ref_Dr_No
		Where IsNull( B.UPIN , '' ) <> ''
				And A.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for UPIN (Providers) '
    Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


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
      , Gender
      , MaritalStatus
      , HomePhone
      , WorkPhone
      , DOB
      , SSN
      , ResponsibleDifferentThanPatient
      , MedicalRecordNumber
      , VendorID
      , VendorImportID
    )
    Select
      @PracticeID
      , '' As Prefix
      , FirstName
      , MiddleName
      , LastName
      , '' As Suffix
      , AddressLine1
      , AddressLine2
      , Upper( City )
      , State
      , ZipCode
      , Gender
      , MaritalStatus
      , HomePhone
      , WorkPhone
      , Convert( Datetime , DOB )
      , SSN
      , 0 As ResponsibleDifferentThanPatient
      , PatientAccountID As MedicalRecordNumber
      , PatientAccountID As VendorID
      , @VendorImportID
    From iPatientB A
    Where A.SSN Not In ( Select P.SSN From Patient P Where P.PracticeID = @PracticeID )
    Order By A.LastName , A.FirstName

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Patient Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Update A
        Set ReferringPhysicianID = C.DoctorID
        From Patient A
                Inner Join iPatientB B On B.PatientAccountID = A.VendorID
                Inner Join Doctor C On C.VendorID = B.ReferringPhysicianID
        Where A.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for ReferringPhysicianID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Update A
        Set PrimaryProviderID = C.DoctorID
        From Patient A
                Inner Join iPatientB B On B.PatientAccountID = A.VendorID
                Inner Join Doctor C On C.VendorID = B.PrimaryProviderID
        Where A.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in Patient Table for PrimaryProviderID '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Insurance Companies.
    Insert Into InsuranceCompany
    ( InsuranceCompanyName
      , ReviewCode
      , VendorID
      , VendorImportID
    )
    Select
        InsuranceCompanyName
        , 'R' As ReviewCode
        , InsuranceCompanyCode As VendorID
        , @VendorImportID
    From iInsCompany

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsuranceCompany Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Insurance Company Plans.
    -- Find out insurance plans that already exists.
    Select
        A.InsuranceCompanyPlanID
        , B.InsurancePlanNo
        Into #IP
    From InsuranceCompanyPlan A
            Inner Join  iInsPlan B On A.VendorID = B.MM_CompanyID
    Where A.ZipCode = B.ZipCode
            And A.PlanName = B.PlanName
            And A.AddressLine1 = B.AddressLine1

    -- Select * From #IP

    -- Import insurance plans that don't exist in InsuranceCompanyPlan table.
    Insert Into InsuranceCompanyPlan
    ( PlanName
      , InsuranceCompanyID
      , AddressLine1
      , City
      , State
      , ZipCode
      , Phone
      , PhoneExt
      , Copay
      , ReviewCode
      , VendorID
      , VendorImportID
    )
    Select
        A.PlanName
        , B.InsuranceCompanyID
        , A.AddressLine1
        , Upper( A.City )
        , A.State
        , A.ZipCode
        , A.Phone
        , A.PhoneExt
        , Convert( Money , A.Copay )
        , 'R' As ReviewCode
        , A.InsurancePlanNo As VendorID
        , @VendorImportID
    From iInsPlan A
        Inner Join InsuranceCompany B On A.MM_CompanyID = B.VendorID And B.VendorImportID = @VendorImportID
    Where A.InsurancePlanNo Not In ( Select InsurancePlanNo From #IP )

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

    -- Import Primary Insurance.
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
        D.PatientCaseID
        , E.InsuranceCompanyPlanID
        , 1 As Precedence
        , A.InsurancePolicyNumber
        , A.InsurancePolicyGroupNumber
        , Case 
            When IsNull( A.PolicyStartDate , '' ) = '' Then Null
            Else Convert( Datetime , A.PolicyStartDate )
            End As PolicyStartDate
        , Case 
            When IsNull( A.PolicyEndDate , '' ) = '' Then Null
            Else Convert( Datetime , A.PolicyEndDate )
            End As PolicyEndDate
        , 'S' As PatientRelationShipToInsured
        , 1 As Active
        , 0 As CoPay
        , @PracticeID
        , A.InsurancePolicyID As VendorID
        , @VendorImportID
        From iInsPolicyB A
                Inner Join iPatientB B On B.PatientAccountID = A.InsurancePolicyID And B.InsurancePlan1 = A.InsurancePlanNumber
                Inner Join Patient C On C.VendorID = B.PatientAccountID
                Inner Join PatientCase D On D.PatientID = C.PatientID
                Inner Join InsuranceCompanyPlan E On E.VendorID = B.InsurancePlan1
        Where IsNull( B.InsurancePlan1 , '' ) <> ''
                And C.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Primary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Secondary Insurance.
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
        D.PatientCaseID
        , E.InsuranceCompanyPlanID
        , 2 As Precedence
        , A.InsurancePolicyNumber
        , A.InsurancePolicyGroupNumber
        , Case 
            When IsNull( A.PolicyStartDate , '' ) = '' Then Null
            Else Convert( Datetime , A.PolicyStartDate )
            End As PolicyStartDate
        , Case 
            When IsNull( A.PolicyEndDate , '' ) = '' Then Null
            Else Convert( Datetime , A.PolicyEndDate )
            End As PolicyEndDate
        , 'S' As PatientRelationShipToInsured
        , 1 As Active
        , 0 As CoPay
        , @PracticeID
        , A.InsurancePolicyID As VendorID
        , @VendorImportID
        From iInsPolicyB A
                Inner Join iPatientB B On B.PatientAccountID = A.InsurancePolicyID And B.InsurancePlan2 = A.InsurancePlanNumber
                Inner Join Patient C On C.VendorID = B.PatientAccountID
                Inner Join PatientCase D On D.PatientID = C.PatientID
                Inner Join InsuranceCompanyPlan E On E.VendorID = B.InsurancePlan2
        Where IsNull( B.InsurancePlan2 , '' ) <> ''
                And C.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Secondary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Tertiary Insurance.
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
        D.PatientCaseID
        , E.InsuranceCompanyPlanID
        , 3 As Precedence
        , A.InsurancePolicyNumber
        , A.InsurancePolicyGroupNumber
        , Case 
            When IsNull( A.PolicyStartDate , '' ) = '' Then Null
            Else Convert( Datetime , A.PolicyStartDate )
            End As PolicyStartDate
        , Case 
            When IsNull( A.PolicyEndDate , '' ) = '' Then Null
            Else Convert( Datetime , A.PolicyEndDate )
            End As PolicyEndDate
        , 'S' As PatientRelationShipToInsured
        , 1 As Active
        , 0 As CoPay
        , @PracticeID
        , A.InsurancePolicyID As VendorID
        , @VendorImportID
        From iInsPolicyB A
                Inner Join iPatientB B On B.PatientAccountID = A.InsurancePolicyID And B.InsurancePlan3 = A.InsurancePlanNumber
                Inner Join Patient C On C.VendorID = B.PatientAccountID
                Inner Join PatientCase D On D.PatientID = C.PatientID
                Inner Join InsuranceCompanyPlan E On E.VendorID = B.InsurancePlan3
        Where IsNull( B.InsurancePlan3 , '' ) <> ''
                And C.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in InsurancePolicy Table for Tertiary Insurance '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Insurance Policy Holder.
    Update A
        Set HolderFirstName = D.InsuredPartyFirstName
            , HolderMiddleName = D.InsuredPartyMiddleName
            , HolderLastName = D.InsuredPartyLastName
            , HolderAddressLine1 = D.InsuredPartyAddressLine1
            -- , HolderAddressLine2 = 
            , HolderCity = D.InsuredPartyCity
            , HolderState = D.InsuredPartyState
            -- , HolderCountry = D.Country
            , HolderZipCode = D.InsuredPartyZipCode
            , HolderPhone = D.InsuredPartyPhone
            -- , HolderPhoneExt = D.WorkPhoneExt
            , PatientRelationshipToInsured = 'O'
            , HolderDOB = Convert( Datetime , D.InsuredPartyDOB )
            , HolderSSN = ( Select Replace( D.InsuredPartyPolicyNumber , '-' , '' ) )
            , HolderGender = D.InsuredPartyGender
        From InsurancePolicy A
                Inner Join InsuranceCompanyPlan B On B.InsuranceCompanyPlanID = A.InsuranceCompanyPlanID
                Inner Join iInsPolicyB C On C.InsurancePolicyID = A.VendorID And C.InsurancePlanNumber = B.VendorID
                Inner Join iInsPartyB D On D.InsuredPartyNo = C.InsuredPartyNo
                Inner Join PatientCase E On E.PatientCaseID = A.PatientCaseID
                Inner Join Patient F On F.PatientID = E.PatientID
        Where A.VendorImportID = @VendorImportID
                And IsNull( C.InsuredPartyNo , '' ) <> ''

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in InsurancePolicy Table for Holder Details '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Contract Fee Schedule Processing.

    Update A
        Set LocalName = B.Description
            , ModifiedDate = GetDate()
        From ProcedureCodeDictionary A
                Inner Join iFeesB B On B.ProcedureCode = A.ProcedureCode
        Where IsNull( Convert( Decimal(10,2) , B.StandardFee ) , 0 ) <> 0

    Select @Rows = @@RowCount
    Select @Message = 'Rows Updated in ProcedureCodeDictionary Table for LocalName '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Add New Procedure Codes Records.
    Insert Into ProcedureCodeDictionary
    ( ProcedureCode
      , OfficialName
    )
    Select Distinct
          A.ProcedureCode
          , A.Description As OfficialName
    From iFeesB A
            Left Outer Join ProcedureCodeDictionary B On A.ProcedureCode = B.ProcedureCode
    Where B.ProcedureCode Is Null
            And IsNull( Convert( Decimal(10,2) , A.StandardFee ) , 0 ) <> 0
            And IsNumeric( A.ProcedureCode ) = 1

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProcedureCodeDictionary Table '
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
      , 'S'
      , GetDate()
      , DateAdd( yy , 1 , GetDate() )
      , 45
      , 45

    Select @ContractID = @@Identity

    Print 'Contract ID : ' + Convert( Varchar(20) , @ContractID )
    Print ''

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
    Select
     B.ProcedureCodeDictionaryID
     , @ContractID
     , Null As Modifier
     , 'B'
     , Convert( Decimal(10,2) , A.StandardFee )
     , 0 As Allowable
     , 0 As ExpectedReimbursement
     , 0 As RVU
     , @VendorImportID
    From iFeesB A
		    Inner Join ProcedureCodeDictionary B On A.ProcedureCode = B.ProcedureCode
    Where IsNull( Convert( Decimal(10,2) , A.StandardFee ) , 0 ) <> 0

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ContractFeeSchedule Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Drop Table #IP

End
-- Commit Transaction
-- Rollback
