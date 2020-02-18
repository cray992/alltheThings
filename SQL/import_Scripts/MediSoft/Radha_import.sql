/***********************************************************************************

			Function Declaration

**************************************************************************************/
use superbill_0112_dev
BEGIN
IF  EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_clean]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT') )
	BEGIN
		DROP FUNCTION [dbo].[fn_clean]
		PRINT 'FUNCTION fn_clean DROPPED...'
	END
IF  EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT') )
	BEGIN
		DROP FUNCTION [dbo].[fn_GetNumber]
		PRINT 'FUNCTION fn_GetNumber DROPPED...'
	END
IF  EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_getprovider]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT') )
	BEGIN
		DROP FUNCTION [dbo].[fn_getprovider]
		PRINT 'FUNCTION fn_getprovider DROPPED...'
	END


END
GO
BEGIN
	SET ANSI_NULLS ON

	SET QUOTED_IDENTIFIER ON
END
GO

CREATE    function [dbo].[fn_clean]
(
--Strips out double whitespace and unprintable chars
@input varchar(8000)
)
RETURNS varchar(8000)
AS
BEGIN
	IF @input IS NULL 
	BEGIN
		--Just return NULL if input string is NULL
		RETURN NULL
	END
	
	--Character variable declarations
	DECLARE @output varchar(8000)
	--Integer variable declarations
	DECLARE @ctr int,  @len int
	--Constant declarations

	--Variable/Constant initializations
	SET @ctr = 1

	SET @output = ''    	
	set @len = len(@input)	
	
	--Take care of first pos whitespace
	IF ( ascii(SUBSTRING(@input,@ctr,1))= 32 )
	BEGIN 	
		set @ctr = @ctr +1	
	END

	
	WHILE @ctr <= @Len
	BEGIN
		--Strip out unprintables line feeds ,CR and whatnot
		IF ( ascii(SUBSTRING(@input,@ctr,1))>= 0 and ascii(SUBSTRING(@input,@ctr,1)) <= 31 )
		BEGIN
			set @ctr = @ctr + 1
							
		END
		
		--Remove double white space
		ELSE IF ( ascii(SUBSTRING(@input,@ctr,1))= 32 and ascii(SUBSTRING(@input,@ctr+1,1)) = 32)
		BEGIN
			set @ctr = @ctr + 1
		END

		else set @output = @output + SUBSTRING(@input,@ctr,1)	
		set @ctr = @ctr + 1	
	
			
	END
	
RETURN @output
END
GO

CREATE FUNCTION [dbo].[fn_GetNumber]( @string Varchar(255) )
	RETURNS Varchar(20)
	AS
	Begin
		
		Declare @number Varchar(20)

		Select @string = Replace( @string , '(' , '' )
		Select @string = Replace( @string , ')' , '' )
		Select @string = Replace( @string , '-' , '' )
		Select @string = Replace( @string , ' ' , '' )
		Select @string = Replace( @string , ',' , '' )
		Select @string = Replace( @string , '.' , '' )
		Select @string = Replace( @string , '$' , '' )
		Select @string = Replace( @string , '%' , '' )
			
		If LTrim( RTrim( @string ) ) = ''
			Select @string = Null

		Select @number = Left( @string , 20 )

		declare @ctr int;
		declare @len int;
		set @len = len(@number);
		WHILE @ctr <= @Len
		BEGIN
		--Strip out unprintables line feeds ,CR and whatnot
			IF ( ascii(SUBSTRING(@number,@ctr,1))>= 49 and ascii(SUBSTRING(@number,@ctr,1)) <= 122 )
			BEGIN
				set @ctr = @ctr + 1
			END
			
			else set @number = @number + SUBSTRING(@number,@ctr,1)	
			set @ctr = @ctr + 1	
	
		END

		Return @number
	End
GO
Create function [dbo].[fn_getprovider](@rf varchar(50),@practiceid int)
returns varchar(50)
	as
	begin
	declare @result varchar(50);
		select @result = vendorid
						from doctor
						where upper(vendorid) = upper(@rf)
						and practiceid = @practiceid 

		
		select @result = vendorid
						from doctor
						where upper(lastName)= upper(@rf)
						and practiceid = @practiceid 

	return @result
	end
GO


BEGIN
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_clean]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	PRINT 'FUNCTION fn_clean CREATED...'
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	PRINT 'FUNCTION fn_GetNumber CREATED...'
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_getprovider]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	PRINT 'FUNCTION getprovider CREATED...'

END
GO

/***********************************End Functions*******************************************************/

/**************************************************************************************
			TABLE SETUP and IMPORT
-- Tables Populated.
-- =================

-- 1. Patient

--****NOTE******
--Change Database connection to destination db
--Build these Tables on prior to running this script if they dont exist already
/*
	drop table impPAT_Radha

*/
*********************************************************************************************/
--***DESTINAION DB declaration

Declare @NewImport bit;



Declare @ExitStat bit;
Declare @Rows Int
        , @Message Varchar(75);

Declare @PracticeID int;
Declare @VendorImportID int;
Declare @VendorName varchar(100),@Notes varchar(2000),@Format varchar(50)

/************************************************************
		Initialize Import Variables
	@Newimport  0 = new import  1 = not new..
***********************************************************/
set @NewImport = 1;
set @VendorName = 'Radha'
set @Notes = 'Import :- Patients'
set  @Format = 'MediSoft'




-- Important.
-- ==========
-- Make sure that the synonymn are created for each case before running this script.
--
--Clear out old data
   --truncate table impPAT_Radha


--need to run an import script here
/*
    Drop Synonym iPatient_Radha
	
    create synonym iPatient_Radha for impPAT_Radha
     
*/

Begin Transaction
BEGIN

    -- ==========
    Insert Into VendorImport
    ( VendorName
      , Notes
      , VendorFormat
    )
    Values
    (
      @VendorName
      , @Notes
      , @Format
    )

	BEGIN
		Set @VendorImportID = @@IDENTITY
		Set @PracticeID = 3

		--*********TEST DEBUG
		--select * from VendorImport


		Print 'Customer : Med EClaims'
		Print @VendorName
		Print 'FogBugz Case ID : 14230'
		Print ''
		Print 'Vendor Import ID : ' + Convert( Varchar(20) , @VendorImportID )
		Print ''

		update impPat_Radha
			set SSN = dbo.fn_GetNumber ( ssn )
			, HomePhone = dbo.fn_GetNumber( HomePhone )

		Update iPatient_Radha
			Set HomePhone = dbo.fn_GetNumber( HomePhone )

		  , SSN = dbo.fn_GetNumber( SSN )
		  , addressline1 = dbo.fn_clean(addressline1)
		 Update iPatient_radha
		  set lastname = substring(lastname,1, charindex(' ',lastname) - 1) + substring(lastname,charindex(' ',lastname) + 1,len(lastname) - charindex(' ',lastname) - 1 ) 
		    where charindex(' ',lastname) > 0  
		Update iPatient_radha
		set firstname = substring(firstname,1, charindex(' ',firstname) - 1) + substring(firstname,charindex(' ',firstname) + 1,len(firstname)-charindex(' ',firstname) - 1) 
		    where charindex(' ',firstname) > 0 
	END
	   
/********************************************************************
		INSERT PATIENTS
IDNum
AccountNo
LastName
FirstName
MI
Generation
Street1
Street2
City
State
Zip
HomePhone
SSN
Birthdate
Sex

drop table #Pat_pri

**********************************************************************/


--do a cleanup of duplicate records

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
      , City
      , State
      , Gender
       , HomePhone
      , DOB
      , SSN
	  , MedicalRecordNumber
	  ,MaritalStatus 
	  ,EmploymentStatus
     )
   
/********************************************************
			table cols for iPatient_Radha


*******************************************************/
    Select
      @VendorImportID
      , PAT.AccountNo
      , @PracticeID
    	, ''
    	, PAT.FirstName
    	, PAT.MI
    	, PAT.LastName
    	, ''
    	, dbo.fn_clean(PAT.AddressLine1)
    	, PAT.City
    	, PAT.State
    	, case PAT.SEX 	when '' then  null   else pat.sex end
      	, case PAT.HomePhone when '' then null  else right(PAT.HomePhone,10) end
    	, PAT.BirthDate
    	,case  PAT.SSN when '' then null else right(PAT.SSN,9) end 
        , PAT.AccountNo 
		,'U' --marital status
		,'U' --employment status
 
    From iPatient_Radha PAT
			
    Where ( isnull(PAT.lastname,'') <> ''
		or isnull(PAT.Firstname,'') <> '' )

    and Not Exists ( Select * From Patient A 
						Where A.PracticeID = 3 
                            And PAT.FirstName = A.FirstName 
                            And PAT.LastName = A.LastName )
	and accountno <>'';


    Select @Rows = @@RowCount
    Select @Message = 'Rows Added in Patient Table '
    Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

   

 
--Rollback
--Commit

END
