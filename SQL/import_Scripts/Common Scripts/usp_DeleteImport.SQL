If OBJECT_ID( 'usp_DeleteImport' , 'P' ) Is Not Null
Begin
    Drop Procedure usp_DeleteImport
    Print 'usp_DeleteImport SP dropped...'
End
Go

Create Procedure usp_DeleteImport
( @VendorImportID Int )
As
Begin

    Set NoCount On

    Declare @RCount                     Int
            , @Rows                     Int
            , @Message                  Varchar(75)
            , @ContractID               Int
            , @PatientID                Int
            , @PatientJournalNoteID     Int
            , @PatientCaseID            Int
            , @InsurancePolicyID        Int
            , @InsuranceCompanyID       Int
            , @InsuranceCompanyPlanID   Int
            , @DoctorID                 Int
            , @ContractFeeScheduleID    Int
            , @ProviderNumberID         Int
            , @EmployerID               Int

    If IsNull( @VendorImportID , 0 ) = 0
    Begin
        RaisError( 'VendorImportID parameter missing.' , 11 , -1 )
        Return -1
    End

    Print 'Deleting Rows for Vendor Import ID : ' + Convert( Varchar(10) , @VendorImportID )
    Print ''

    Update Patient
        Set ReferringPhysicianID = Null
        Where VendorImportID = @VendorImportID

    Update Patient
        Set PrimaryProviderID = Null
        Where VendorImportID = @VendorImportID

    Update Patient
        Set EmployerID = Null
        Where VendorImportID = @VendorImportID

    -- Employers Table.
    Delete From Employers
        Where VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Deleted From Employers Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )
        
    -- InsurancePolicy Table.
    Delete From InsurancePolicy
        Where VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Deleted From InsurancePolicy Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- PatientCase Table.
    Delete From PatientCase
        Where VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Deleted From PatientCase Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- PatientJournalNote Table.
    Delete PJN
	    From PatientJournalNote PJN
			Inner Join Patient P On PJN.PatientID = P.PatientID
        Where P.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Deleted From PatientJournalNote Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Patient Table.
    Delete From Patient
        Where VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Deleted From Patient Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- ContractToInsurancePlan Table.
    Delete A
        From ContractToInsurancePlan A
                Inner Join InsuranceCompanyPlan B On A.PlanID = B.InsuranceCompanyPlanID
        Where B.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Deleted From ContractToInsurancePlan Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- InsuranceCompanyPlan Table.
    Delete From InsuranceCompanyPlan
        Where VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Deleted From InsuranceCompanyPlan Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- InsuranceCompany Table.
    Delete From InsuranceCompany
        Where VendorImportID = @VendorImportID
                And InsuranceCompanyID Not In ( Select InsuranceCompanyID From InsuranceCompanyPlan )

    Select @Rows = @@RowCount
    Select @Message = 'Rows Deleted From InsuranceCompany Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- ProviderNumber Table.
    Delete A
        From ProviderNumber A
                Inner Join Doctor B On A.DoctorID = B.DoctorID
        Where B.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Deleted From ProviderNumber Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- ContractToDoctor Table.
    Delete A
        From ContractToDoctor A
                Inner Join Doctor B On A.DoctorID = B.DoctorID
        Where B.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Deleted From ContractToDoctor Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Doctor Table.
    Delete From Doctor
        Where VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Deleted From Doctor Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )


    /*
    Select @RCount = Count(*)
        From sys.columns SC
        Where Object_Name( Object_ID ) = 'Employers'
                And Name = 'VendorImportID'

    If IsNull( @RCount , 0 ) > 0
    Begin

        -- Employers Table.
        Delete From Employers
            Where VendorImportID = @VendorImportID

        Select @Rows = @@RowCount
        Select @Message = 'Rows Deleted From Employers Table '
        Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    End

    Select @RCount = Count(*)
        From sys.columns SC
        Where Object_Name( Object_ID ) = 'ContractFeeSchedule'
                And Name = 'VendorImportID'

    If IsNull( @RCount , 0 ) > 0
    Begin

        Select @ContractID = Top 1 ContractID
            From ContractFeeSchedule
            Where VendorImportID = @VendorImportID

        -- ContractFeeSchedule Table.
        Delete From ContractFeeSchedule
            Where VendorImportID = @VendorImportID

        Select @Rows = @@RowCount
        Select @Message = 'Rows Deleted From ContractFeeSchedule Table '
        Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

        Delete From Contract
            Where ContractID = @ContractID
    End
    */

    Select Top 1 @ContractID = ContractID
        From ContractFeeSchedule
        Where VendorImportID = @VendorImportID

    Select @ContractID = IsNull( @ContractID , 0 )

    -- ContractFeeSchedule Table.
    Delete From ContractFeeSchedule
        Where VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 
        Case When @ContractID > 0 Then 'Rows Deleted From ContractFeeSchedule Table for Contract ID ' + Convert( Varchar(2) , @ContractID )
        Else 'Rows Deleted From ContractFeeSchedule Table '
        End
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Delete From Contract
        Where ContractID = @ContractID

    Delete From VendorImport
        Where VendorImportID = @VendorImportID

    -- Reset Identity Values.
    Print ''
    Print 'Resetting Identity Values ... '
    Print ''

    Select @PatientID = Max( PatientID ) From Patient
    Select @PatientID = IsNull( @PatientID , 0 )

    Select @PatientJournalNoteID = Max( PatientJournalNoteID ) From PatientJournalNote
    Select @PatientJournalNoteID = IsNull( @PatientJournalNoteID , 0 )

    Select @PatientCaseID = Max( PatientCaseID ) From PatientCase
    Select @PatientCaseID = IsNull( @PatientCaseID , 0 )

    Select @InsurancePolicyID = Max( InsurancePolicyID ) From InsurancePolicy
    Select @InsurancePolicyID = IsNull( @InsurancePolicyID , 0 )

    Select @InsuranceCompanyID = Max( InsuranceCompanyID ) From InsuranceCompany
    Select @InsuranceCompanyID = IsNull( @InsuranceCompanyID , 0 )

    Select @InsuranceCompanyPlanID = Max( InsuranceCompanyPlanID ) From InsuranceCompanyPlan
    Select @InsuranceCompanyPlanID = IsNull( @InsuranceCompanyPlanID , 0 )
    
    Select @DoctorID = Max( DoctorID ) From Doctor
    Select @DoctorID = IsNull( @DoctorID , 0 )

    Select @ProviderNumberID = Max( ProviderNumberID ) From ProviderNumber
    Select @ProviderNumberID = IsNull( @ProviderNumberID , 0 )
    
    Select @ContractFeeScheduleID = Max( ContractFeeScheduleID ) From ContractFeeSchedule
    Select @ContractFeeScheduleID = IsNull( @ContractFeeScheduleID , 0 )
    
    Select @ContractID = Max( ContractID ) From Contract
    Select @ContractID = IsNull( @ContractID , 0 )

    Select @EmployerID = Max( EmployerID ) From Employers
    Select @EmployerID = IsNull( @EmployerID , 0 )

    Print 'Resetting Identity Column for Patient Table ... '
    DBCC CHECKIDENT( 'Patient' , 'RESEED' , @PatientID ) WITH NO_INFOMSGS

    Print 'Resetting Identity Column for PatientJournalNote Table ... '
    DBCC CHECKIDENT( 'PatientJournalNote' , 'RESEED' , @PatientJournalNoteID ) WITH NO_INFOMSGS

    Print 'Resetting Identity Column for PatientCase Table ... '
    DBCC CHECKIDENT( 'PatientCase' , 'RESEED' , @PatientCaseID ) WITH NO_INFOMSGS

    Print 'Resetting Identity Column for InsurancePolicy Table ... '
    DBCC CHECKIDENT( 'InsurancePolicy' , 'RESEED' , @InsurancePolicyID ) WITH NO_INFOMSGS

    Print 'Resetting Identity Column for InsuranceCompany Table ... '
    DBCC CHECKIDENT( 'InsuranceCompany' , 'RESEED' , @InsuranceCompanyID ) WITH NO_INFOMSGS

    Print 'Resetting Identity Column for InsuranceCompanyPlan Table ... '
    DBCC CHECKIDENT( 'InsuranceCompanyPlan' , 'RESEED' , @InsuranceCompanyPlanID ) WITH NO_INFOMSGS

    Print 'Resetting Identity Column for ProviderNumber Table ... '
    DBCC CHECKIDENT( 'ProviderNumber' , 'RESEED' , @ProviderNumberID ) WITH NO_INFOMSGS

    Print 'Resetting Identity Column for Doctor Table ... '
    DBCC CHECKIDENT( 'Doctor' , 'RESEED' , @DoctorID ) WITH NO_INFOMSGS

    Print 'Resetting Identity Column for ContractFeeSchedule Table ... '
    DBCC CHECKIDENT( 'ContractFeeSchedule' , 'RESEED' , @ContractFeeScheduleID ) WITH NO_INFOMSGS

    Print 'Resetting Identity Column for Contract Table ... '
    DBCC CHECKIDENT( 'Contract' , 'RESEED' , @ContractID ) WITH NO_INFOMSGS

    Print 'Resetting Identity Column for Employers Table ... '
    DBCC CHECKIDENT( 'Employers' , 'RESEED' , @EmployerID ) WITH NO_INFOMSGS

    Set NoCount Off

End
Go

If OBJECT_ID( 'usp_DeleteImport' , 'P' ) Is Not Null
    Print 'usp_DeleteImport SP created...'
Go
