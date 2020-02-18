-- C:\Work\Data Imports\Case 17428\Scripts\ImportEmpAtt.SQL

-- Customer  : Automatic Claims Processing (0966).
-- Practice  : Jared T. Clegg
-- Case ID   : 17428


-- Tables Populated.
-- =================
-- 1. Employers
-- 2. Attorney

-- Important.
-- ==========
-- 1. Add Practice records in Practice table.
-- 2. Add VendorID and VendorImportID columns to Employers table.
-- 3. Add VendorID and VendorImportID columns to Attorney table.

/*

    -- Use superbill_0966_prod

    usp_columns Employers

    alter table employers
        add VendorID Varchar(50)

    alter table employers
        add VendorImportID Int

    usp_columns Attorney

    alter table attorney
        add VendorID Varchar(50)

    alter table attorney
        add VendorImportID Int

*/

-- Data Import # 1 database
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

    -- =====================
    Insert Into VendorImport
    ( VendorName
      , VendorFormat
      , Notes
    )
    Values
    (
      'Case 17428'
      , 'MediSoft'
      , 'Import Employers and Attorneys'
    )

    Set @VendorImportID = @@IDENTITY

    Print 'Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )
    Print ''

    Print 'Import Employers and Attorneys.'
    Print ''

    -- Format ZipCode.
    Update impMWADD17428
        Set ZipCode = dbo.fn_GetNumber( ZipCode )

    -- Format Phone.
    Update impMWADD17428
        Set Phone = dbo.fn_GetNumber( Phone )

    -- Format Fax.
    Update impMWADD17428
        Set Fax = dbo.fn_GetNumber( Fax )

    Select A.Code As VendorID
            , A.Name As EmployerName
            , IsNull( A.Street1 , '' ) As AddressLine1
            , IsNull( A.Street2 , '' ) As AddressLine2
            , IsNull( A.City , '' ) As City
            , IsNull( A.State , '' ) As State
            , IsNull( A.ZipCode , '' ) As ZipCode
        Into #tmp1
        From impMWADD17428 A
        Where A.[Type] = 'Employer'

    Select
      A.EmployerName
      , IsNull( A.AddressLine1 , '' ) As AddressLine1
      , IsNull( A.AddressLine2 , '' ) As AddressLine2
      , IsNull( A.City , '' ) As City
      , IsNull( A.State , '' ) As State
      , IsNull( A.ZipCode , '' ) As ZipCode
      -- , A.VendorID
      , Count(*) As EmployerCount
     Into #tmp2
     From #tmp1 A
     Group By A.EmployerName , IsNull( A.AddressLine1 , '' ) , IsNull( A.AddressLine2 , '' ) , IsNull( A.City , '' ) 
                , IsNull( A.State , '' ) , IsNull( A.ZipCode , '' ) Having Count(*) > 1

    Insert Into Employers
    ( EmployerName
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , VendorID
      , VendorImportID
     )
    Select
      A.EmployerName
      , A.AddressLine1
      , A.AddressLine2
      , A.City
      , A.State
      , A.ZipCode
      , A.VendorID
      , @VendorImportID
     From #tmp1 A
     Where Not Exists
            ( Select * From #tmp2 B
                Where B.EmployerName = A.EmployerName
                        And IsNull( B.AddressLine1 , '' ) = IsNull( A.AddressLine1 , '' )
                        And IsNull( B.AddressLine2 , '' ) = IsNull( A.AddressLine2 , '' )
                        And IsNull( B.City , '' ) = IsNull( A.City , '' )
                        And IsNull( B.State , '' ) = IsNull( A.State , '' )
                        And IsNull( B.ZipCode , '' ) = IsNull( A.ZipCode , '' ) )
     Order By A.EmployerName

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Employers Table (Distinct Ones) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Insert Into Employers
    ( EmployerName
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , VendorID
      , VendorImportID
     )
    Select
      A.EmployerName
      , A.AddressLine1
      , A.AddressLine2
      , A.City
      , A.State
      , A.ZipCode
      , '' As VendorID
      , @VendorImportID
     From #tmp2 A
     Order By A.EmployerName

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Employers Table (Duplicate Ones) '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    -- Import Attorneys.
    Select A.Name As CompanyName
            , A.Street1 As AddressLine1
            , A.Street2 As AddressLine2
            , A.City As City
            , A.State As State
            , A.ZipCode As ZipCode
            , A.Phone As WorkPhone
            , A.Extension As WorkPhoneExt
            , A.Fax As FaxPhone
            , A.Code As VendorID
        Into #tmp3
        From impMWADD17428 A
        Where A.Type = 'Attorney'

    Insert Into Attorney
    ( CompanyName
      , AddressLine1
      , AddressLine2
      , City
      , State
      , ZipCode
      , WorkPhone
      , WorkPhoneExt
      , FaxPhone
      , Prefix
      , FirstName
      , MiddleName
      , LastName
      , Suffix
      , VendorID
      , VendorImportID
    )
    Select
      A.CompanyName
      , A.AddressLine1
      , A.AddressLine2
      , A.City
      , A.State
      , A.ZipCode
      , A.WorkPhone
      , A.WorkPhoneExt
      , A.FaxPhone
      , '' As Prefix
      , '' As FirstName
      , '' As MiddleName
      , '' As LastName
      , '' As Suffix
      , A.VendorID
      , @VendorImportID
    From #tmp3 A

    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Attorney Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

    Drop Table #tmp1
    Drop Table #tmp2
    Drop Table #tmp3

End
-- ROLLBACK
-- Commit Transaction

Set NoCount Off
