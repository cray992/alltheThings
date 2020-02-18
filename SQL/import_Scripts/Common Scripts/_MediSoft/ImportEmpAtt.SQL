-- Customer  : 
-- Practice  : 
-- Case ID   : 


-- Tables Populated.
-- =================
-- 1. Employers
-- 2. Attorney

-- Important.
-- ==========
-- 1. Add Practice records in Practice table.
-- 2. Add VendorID and VendorImportID columns to Employers table.
-- 3. Add VendorID and VendorImportID columns to Attorney table.

USE superbill_0980_prod

SET NOCOUNT ON

IF OBJECT_ID('tempdb..#Vars') IS NOT NULL
	DROP TABLE [#Vars]

CREATE TABLE #Vars(VarName varchar(50), VarValue varchar(200))

-- %%%%%% INSERT VARIABLES HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INSERT INTO #Vars (VarName, VarValue) VALUES ('x_EmployerAndAttorney', 'dbo.impMWADD4049')
INSERT INTO #Vars (VarName, VarValue) VALUES ('VendorName', '18531 - Initial Data Import')
--INSERT INTO #Vars (VarName, VarValue) VALUES ('PracticeID', '')
--INSERT INTO #Vars (VarName, VarValue) VALUES ('PracticeName', '')

-- ==================================================================
-- Make sure the destination tables have VendorID columns
------------------------ Employers
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Employers') and name='VendorID')
	ALTER TABLE Employers ADD VendorID varchar(50)
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Employers') and name='VendorImportID')
	ALTER TABLE Employers ADD VendorImportID int
------------------------ Attorney
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Attorney') and name='VendorID')
	ALTER TABLE Attorney ADD VendorID varchar(50)
IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Attorney') and name='VendorImportID')
	ALTER TABLE Attorney ADD VendorImportID int
IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'x_EmployerAndAttorney')
	DROP SYNONYM [dbo].x_EmployerAndAttorney
GO
-- ==================================================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetNumberImport]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fn_GetNumberImport]
BEGIN
	execute dbo.sp_executesql @statement = N'
	CREATE FUNCTION [dbo].[fn_GetNumberImport]( @string Varchar(255) )
	RETURNS Varchar(20)
	AS
	BEGIN
		DECLARE @number Varchar(20)
		DECLARE @OldString VARCHAR(255)

		SET @OldString = @string + ''a''
		WHILE LEN(@OldString) > LEN(@String)
			BEGIN
				SET @OldString = @string
				SET	@string = REPLACE(@string, SUBSTRING(@string, PATINDEX(''%[^0-9]%'', @string), 1), '''')
			END

		SET @string = Replace( @string , ''('' , '''' )
		SET @string = Replace( @string , '')'' , '''' )
		SET @string = Replace( @string , ''-'' , '''' )
		SET @string = Replace( @string , '' '' , '''' )
		SET @string = Replace( @string , '','' , '''' )
		SET @string = Replace( @string , ''.'' , '''' )
		SET @string = Replace( @string , ''$'' , '''' )
		SET @string = Replace( @string , ''%'' , '''' )
		SET @string = Replace( @string , ''_'' , '''' )
		SET @string = Replace( @string , ''*'' , '''' )
		SET @string = Replace( @string , ''CHAR(39)'' , '''' )

		If LTrim( RTrim( @string ) ) = ''''
			Select @string = Null

		SET @number = LEFT( @string , 20 )

		RETURN @number
	END
	' 
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetStateImport]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	DROP FUNCTION [dbo].[fn_GetStateImport]
BEGIN
	execute dbo.sp_executesql @statement = N'
	CREATE FUNCTION [dbo].[fn_GetStateImport]( @string Varchar(255) )
	RETURNS Varchar(20)
	AS
	BEGIN
		DECLARE @Return VarChar(20)
		
		SET @Return = 
		CASE @string
			WHEN ''ALABAMA'' THEN ''AL''
			WHEN ''ALASKA'' THEN ''AK''
			WHEN ''AMERICAN SAMOA'' THEN ''AS''
			WHEN ''ARIZONA'' THEN ''AZ''
			WHEN ''ARKANSAS'' THEN ''AR''
			WHEN ''CALIFORNIA'' THEN ''CA''
			WHEN ''COLORADO'' THEN ''CO''
			WHEN ''CONNECTICUT'' THEN ''CT''
			WHEN ''DELAWARE'' THEN ''DE''
			WHEN ''DISTRICT OF COLUMBIA'' THEN ''DC''
			WHEN ''FEDERATED STATES OF MICRONESIA'' THEN ''FM''
			WHEN ''FLORIDA'' THEN ''FL''
			WHEN ''GEORGIA'' THEN ''GA''
			WHEN ''GUAM'' THEN ''GU''
			WHEN ''HAWAII'' THEN ''HI''
			WHEN ''IDAHO'' THEN ''ID''
			WHEN ''ILLINOIS'' THEN ''IL''
			WHEN ''INDIANA'' THEN ''IN''
			WHEN ''IOWA'' THEN ''IA''
			WHEN ''KANSAS'' THEN ''KS''
			WHEN ''KENTUCKY'' THEN ''KY''
			WHEN ''LOUISIANA'' THEN ''LA''
			WHEN ''MAINE'' THEN ''ME''
			WHEN ''MARSHALL ISLANDS'' THEN ''MH''
			WHEN ''MARYLAND'' THEN ''MD''
			WHEN ''MASSACHUSETTS'' THEN ''MA''
			WHEN ''MICHIGAN'' THEN ''MI''
			WHEN ''MINNESOTA'' THEN ''MN''
			WHEN ''MISSISSIPPI'' THEN ''MS''
			WHEN ''MISSOURI'' THEN ''MO''
			WHEN ''MONTANA'' THEN ''MT''
			WHEN ''NEBRASKA'' THEN ''NE''
			WHEN ''NEVADA'' THEN ''NV''
			WHEN ''NEW HAMPSHIRE'' THEN ''NH''
			WHEN ''NEW JERSEY'' THEN ''NJ''
			WHEN ''NEW MEXICO'' THEN ''NM''
			WHEN ''NEW YORK'' THEN ''NY''
			WHEN ''NORTH CAROLINA'' THEN ''NC''
			WHEN ''NORTH DAKOTA'' THEN ''ND''
			WHEN ''NORTHERN MARIANA ISLANDS'' THEN ''MP''
			WHEN ''OHIO'' THEN ''OH''
			WHEN ''OKLAHOMA'' THEN ''OK''
			WHEN ''OREGON'' THEN ''OR''
			WHEN ''PALAU'' THEN ''PW''
			WHEN ''PENNSYLVANIA'' THEN ''PA''
			WHEN ''PUERTO RICO'' THEN ''PR''
			WHEN ''RHODE ISLAND'' THEN ''RI''
			WHEN ''SOUTH CAROLINA'' THEN ''SC''
			WHEN ''SOUTH DAKOTA'' THEN ''SD''
			WHEN ''TENNESSEE'' THEN ''TN''
			WHEN ''TEXAS'' THEN ''TX''
			WHEN ''UTAH'' THEN ''UT''
			WHEN ''VERMONT'' THEN ''VT''
			WHEN ''VIRGIN ISLANDS'' THEN ''VI''
			WHEN ''VIRGINIA '' THEN ''VA''
			WHEN ''WASHINGTON'' THEN ''WA''
			WHEN ''WEST VIRGINIA'' THEN ''WV''
			WHEN ''WISCONSIN'' THEN ''WI''
			WHEN ''WYOMING'' THEN ''WY''
			ELSE @string
		END

		RETURN @string
	END
	' 
END

GO
-- ==================================================================
	DECLARE @x_EmployerAndAttorney varchar(50)
	SELECT @x_EmployerAndAttorney = VarValue FROM #Vars WHERE VarName = 'x_EmployerAndAttorney'
    EXEC ('Create Synonym x_EmployerAndAttorney For ' + @x_EmployerAndAttorney)
GO
-- ==================================================================
SET NOCOUNT ON
  -- Format ZipCode.
    Update x_EmployerAndAttorney
        Set ZipCode = dbo.fn_GetNumberImport( ZipCode )
  -- Format Phone.
    Update x_EmployerAndAttorney
        Set Phone = dbo.fn_GetNumberImport( Phone )
  -- Format Fax.
    Update x_EmployerAndAttorney
        Set Fax = dbo.fn_GetNumberImport( Fax )
GO
-- ===================================================================

SET NOCOUNT ON

DECLARE @Rows               Int
        , @Message          Varchar(75)
--        , @PracticeID       Int
        , @VendorImportID   Int
        , @VendorName       Varchar(100)

--	SELECT @PracticeID = VarValue FROM #Vars WHERE VarName = 'PracticeID'
	SELECT @VendorName = VarValue FROM #Vars WHERE VarName = 'VendorName'

If Not Exists ( Select Object_ID( 'fn_GetNumberImport' , 'FN' ) )
Begin
    RaisError( 'Function fn_GetNumberImport. Cannot Proceed.' , 11 , -1 )
    Return
End

BEGIN TRANSACTION
BEGIN

    -- =====================
    Insert Into VendorImport( VendorName, VendorFormat, Notes)
					Values(@VendorName, 'MediSoft', 'Import Employers and Attorneys')

    Set @VendorImportID = SCOPE_IDENTITY()

	Print 'Import for: ' + @VendorName
    Print 'Import Employers and Attorneys.'
    Print 'Data Import Date & Time : ' + Convert( Varchar(20) , GetDate() )
    Print 'DataBase : ' + DB_Name()
    Print 'Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )

    Select A.Code As VendorID
            , A.Name As EmployerName
            , IsNull( A.Street1 , '' ) As AddressLine1
            , IsNull( A.Street2 , '' ) As AddressLine2
            , IsNull( A.City , '' ) As City
            , IsNull( A.State , '' ) As State
            , IsNull( A.ZipCode , '' ) As ZipCode
        Into #tmp1
        From x_EmployerAndAttorney A
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
        From x_EmployerAndAttorney A
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

END
-- ROLLBACK
-- COMMIT TRANSACTION

SET NOCOUNT OFF
