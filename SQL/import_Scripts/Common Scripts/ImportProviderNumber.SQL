Set NoCount On

Use superbill_0280_prod
Go

Print 'Customer : SLM Billing Solutions.'
Print 'Case No. : 12703 to 12710.'
Print 'Import Providers and Referring Physicians for all Practices.'
Print ''

Declare @VendorImportID    Int
        , @Rows				Int
        , @Message			VarChar(100)


Begin Transaction
Begin

    Insert Into VendorImport
    ( VendorName
      , VendorFormat
      , Notes
    )
    Values
    ( 'Case IDs : 12703 to 12710 - Import Providers & Referring Physicians.'
      , 'Microsoft Access Database'
      , 'Exported Provider and Practice Access Tables to text files and merged them.'
     )

    Select @VendorImportID = @@Identity

    Print 'Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )

	 -- Import Providers.
     Insert Into Doctor
	 ( PracticeID
	   , Prefix
	   , FirstName
	   , MiddleName
	   , LastName
	   , Suffix
	   , SSN
      , TaxonomyCode
	   , AddressLine1
	   , AddressLine2
	   , City
	   , State
	   , ZipCode
	   , HomePhone
	   , WorkPhone
      , WorkPhoneExt
	   , MobilePhone
      , EmailAddress
	   , ActiveDoctor
	   , Degree
	   , FaxNumber
      , [External]
      , VendorID
      , VendorImportID
	)
	Select
	   A.PracticeID
      , '' As Prefix
      , A.FirstName
      , A.Middle As MiddleName
      , A.LastName
      , '' As Suffix
      , Null As SSN
      , Null As TaxonomyCode
	   , B.AddressOne As AddressLine1
	   , B.AddressTwo As AddressLine2
	   , B.City As City
	   , B.State As State
	   , B.ZipCode As ZipCode
	   , Null As HomePhone
	   , B.Telephone As WorkPhone
       , Null As WorkPhoneExt
	   , Null As MobilePhone
      , B.Email As EmailAddress
	   , 1 As ActiveDoctor
	   , Null As Degree
	   , B.Fax As FaxNumber
       , 0 As [External]
       , A.ID
       , @VendorImportID
	 From impProvider A
            Inner Join impPractice B On A.APracticeID = B.ID And A.PracticeID = B.PracticeID
    Where FirstName <> 'Rodney' And LastName <> 'Small'

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for Providers '
    Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- UPIN :- 25 ( UPIN )
    -- LicenseNumber :-  7 ( Medical License Number )
    -- MedicareID :- 23 ( Medicare Provider Number )
    -- MedicaidID :- 24 ( Medicaid Provider Number )
    -- BlueShieldID :- 22 ( Blue Shield Provider Number )
    -- BlueCrossID :- 39 ( Blue Cross Provider Number )
    -- RailRoadID :- 6 ( Medicare Railroad Number )
    -- ChampusID :- 26 ( Champus Identification Number )
    -- NPI :- 8 ( National Provider Number )

	 -- Added UPIN records for Providers.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select D.DoctorID
           , 25
           , TP.UPIN
		From Doctor D
				Inner Join impProvider TP On D.FirstName = TP.FirstName And D.LastName = TP.LastName
		Where IsNull( TP.UPIN , '' ) <> ''
				And D.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for UPIN (Providers) '
    Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Medical License Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select D.DoctorID
           , 7
           , TP.LicenseNumber
		From Doctor D
				Inner Join impProvider TP On D.FirstName = TP.FirstName And D.LastName = TP.LastName
		Where IsNull( TP.LicenseNumber , '' ) <> ''
				And D.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Medical License Number (Providers) '
    Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Medicare Provider Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select D.DoctorID
           , 23
           , TP.MedicareID
		From Doctor D
				Inner Join impProvider TP On D.FirstName = TP.FirstName And D.LastName = TP.LastName
		Where IsNull( TP.MedicareID , '' ) <> ''
				And D.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Medicare Provider Number (Providers) '
    Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Medicaid Provider Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select D.DoctorID
           , 24
           , TP.MedicaidID
		From Doctor D
				Inner Join impProvider TP On D.FirstName = TP.FirstName And D.LastName = TP.LastName
		Where IsNull( TP.MedicaidID , '' ) <> ''
				And D.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Medicaid Provider Number (Providers) '
    Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import BlueShield Provider Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select D.DoctorID
           , 22
           , TP.BlueShieldID
		From Doctor D
				Inner Join impProvider TP On D.FirstName = TP.FirstName And D.LastName = TP.LastName
		Where IsNull( TP.BlueShieldID , '' ) <> ''
				And D.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for BlueShield Provider Number (Providers) '
    Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import BlueCross Provider Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select D.DoctorID
           , 39
           , TP.BlueCrossID
		From Doctor D
				Inner Join impProvider TP On D.FirstName = TP.FirstName And D.LastName = TP.LastName
		Where IsNull( TP.BlueCrossID , '' ) <> ''
				And D.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for BlueCross Provider Number (Providers) '
    Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Medicare RailRoad Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select D.DoctorID
           , 6
           , TP.RailRoadID
		From Doctor D
				Inner Join impProvider TP On D.FirstName = TP.FirstName And D.LastName = TP.LastName
		Where IsNull( TP.RailRoadID , '' ) <> ''
				And D.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Medicare RailRoad Number (Providers) '
    Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Champus Identification Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select D.DoctorID
           , 26
           , TP.ChampusID
		From Doctor D
				Inner Join impProvider TP On D.FirstName = TP.FirstName And D.LastName = TP.LastName
		Where IsNull( TP.ChampusID , '' ) <> ''
				And D.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for Champus Identification Number (Providers) '
    Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import National Provider Number.
	 Insert Into ProviderNumber
	 ( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select D.DoctorID
           , 8
           , TP.NPI
		From Doctor D
				Inner Join impProvider TP On D.FirstName = TP.FirstName And D.LastName = TP.LastName
		Where IsNull( TP.NPI , '' ) <> ''
				And D.VendorImportID = @VendorImportID

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for National Provider Number (Providers) '
    Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Referring Physicians.
    Insert Into Doctor
	( PracticeID
	  , Prefix
	  , FirstName
	  , MiddleName
	  , LastName
	  , Suffix
	  , SSN
     , TaxonomyCode
	  , AddressLine1
	  , AddressLine2
	  , City
	  , State
	  , ZipCode
	  , HomePhone
	  , WorkPhone
      , WorkPhoneExt
	  , MobilePhone
	  , ActiveDoctor
	  , Degree
	  , FaxNumber
      , [External]
      , VendorID
      , VendorImportID
	)
    Select
    	PracticeID
    	, '' As Prefix
    	, FirstName
      , Middle
      , LastName
      , '' As Suffix
    	, TaxID As SSN
      , Null As TaxonomyCode
      , AddressOne As AddressLine1
    	, AddressTwo As AddressLine2
      , City
      , State
      , ( Select dbo.fn_GetNumber( ZipCode ) ) As ZipCode
      , Null As HomePhone
      , Telephone As WorkPhone
      , Extension As WorkPhoneExt
    	, Null As MobilePhone
      , 1 As ActiveDoctor
      , Null As Degree
      , Fax As FaxNumber
      , 1 As [External]
      , ID
      , @VendorImportID
    From impReferral

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Doctor Table for Referring Physicians '
    Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

	-- Add UPIN records for Referring Physicians.
	Insert Into ProviderNumber
	( DoctorID
      , ProviderNumberTypeID
      , ProviderNumber
    )
	Select D.DoctorID
           , 25
           , TP.UPIN
		From Doctor D
				Inner Join impReferral TP On D.FirstName = TP.FirstName And D.LastName = TP.LastName And D.VendorID = TP.ID
		Where IsNull( TP.UPIN , '' ) <> ''
				And D.VendorImportID = @VendorImportID
				And D.[External] = 1

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in ProviderNumber Table for UPIN (Referring Physicians) '
    Print @Message + Replicate( '.' , 100 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

End
-- Commit Transaction
-- RollBack
