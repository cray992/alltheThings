-- Customer : Promed Billing Associates.
-- Customer ID : 649
-- Case No. : 14002

-- Import Contract Fee Schedule.

-- Important.
-- ==========
-- VendorImportID column ( New Column ) needs to be created on ContractFeeSchedule Table.
-- Alter Table ContractFeeSchedule Add VendorImportID Int
-- Create Synonym iFeeSchedule For impMWPRO14002
-- Select * From iFeeSchedule

Set NoCount On

Use superbill_0649_prod
Go

Declare @VendorImportID		Int
		  , @ContractID		Int
        , @PracticeID		Int
		  , @Rows				Int

Begin Transaction
Begin

	Insert Into VendorImport
	( VendorName
	  , Notes
	  , VendorFormat
	)
	Values
	( 'Rajat Prakash Practice'
	  , 'Case 14002 :- Import Fee Schedule'
	  , 'MediSoft'
	 )

	Select @VendorImportID = @@Identity

	Print 'Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )

	Select @PracticeID = PracticeID
		From Practice
		Where [Name] Like 'Rajat%'

	Insert Into Contract
	( PracticeID
      , ContractName
      , Description
      , EffectiveStartDate
      , EffectiveEndDate
	   , NoResponseTriggerPaper
	   , NoResponseTriggerElectronic
    )
	Select
      @PracticeID
      , 'Standard Fee Schedule'
      , 'Standard Fees'
      , GetDate()
      , DateAdd( yy , 1 , GetDate() )
      , 45
      , 45

	Select @ContractID = @@Identity

	-- Add New CPT Codes for the customer.
	Insert Into ProcedureCodeDictionary
	( ProcedureCode
      , OfficialName
   )
	Select A.Code1
		   , A.Description As OfficialName
	From iFeeSchedule A
			Left Outer Join ProcedureCodeDictionary B On A.Code1 = B.ProcedureCode
	Where B.ProcedureCode Is Null

	Select @Rows = @@RowCount
	Print Convert( Varchar(10) , @Rows ) + ' Rows Added in ProcedureCodeDictionary Table.'

	Insert Into ContractFeeSchedule
	( ProcedureCodeDictionaryID
	  , ContractID
	  , Modifier
	  , Gender
	  , StandardFee
     , Allowable
	  , RVU
	  , VendorImportID
	)
	Select
	  B.ProcedureCodeDictionaryID
	  , @ContractID
     , Case
		  When C.ProcedureModifierCode Is Not Null Then A.DefaultModifier1
		  Else Null
	    End
	  , 'B'
	  , Convert( Money , A.AmountA ) As StandardFee
	  , Convert( Money , A.AmountB ) As Allowable
     , 0 As RVU
     , @VendorImportID
	From iFeeSchedule A
			Inner Join ProcedureCodeDictionary B On A.Code1 = B.ProcedureCode
         Left Outer Join ProcedureModifier C On A.DefaultModifier1 = C.ProcedureModifierCode

	Select @Rows = @@RowCount
	Print Convert( Varchar(10) , @Rows ) + ' Rows Added in ContractFeeSchdule Table.'

End
-- Rollback
-- Commit Transaction
