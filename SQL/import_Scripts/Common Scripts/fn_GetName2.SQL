-- SQL Function for parsing lastname, firstname and middlename.
IF  EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetName2]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT') )
BEGIN
	DROP FUNCTION [dbo].[fn_GetName2]
	PRINT 'FUNCTION fn_GetName2 DROPPED...'
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_GetName2( @full_name Varchar(255) , @name_type Char(1) , @format VarChar(3))
RETURNS Varchar(30)
AS
Begin

	Declare @patient_name	Varchar(50)
			, @start_pos	Int
			, @end_pos		Int
			, @len1         Int

	Select @full_name = IsNull( @full_name , '' )
	        , @len1 = Len( @full_name )

	If @format = 'FML'
	Begin

		-- Extract first name.
		If @name_type = 'F'
		Begin
			Select @patient_name = Left( @full_name , CharIndex( ' ' , @full_name ) )
		End

		-- Extract middle initial.
		If @name_type = 'M'
		Begin
			Select @start_pos = CharIndex( ' ' , @full_name )
			If SubString( @full_name , @start_pos + 2 , 1 ) = ' '
    			Select @patient_name = SubString( @full_name , @start_pos + 1 , 1 )
		End

		-- Extract last name.
		If @name_type = 'L'
		Begin
			Select @start_pos = CharIndex( ' ' , @full_name )
			Select @end_pos = CharIndex( ' ' , @full_name , @start_pos + 1 )

			If @end_pos > 0
				Select @patient_name = SubString( @full_name , @end_pos + 1 , @len1 )
			Else
				Select @patient_name = SubString( @full_name , @start_pos + 1 , @len1 )

		End
	End

	If @format = 'LFM'
	Begin

		-- Extract last name.
		If @name_type = 'L'
		Begin
			Select @patient_name = Left( @full_name , CharIndex( ' ' , @full_name ) )
		End

		-- Extract first name.
		If @name_type = 'F'
		Begin
			Select @start_pos = CharIndex( ' ' , @full_name )
			Select @end_pos = CharIndex( ' ' , @full_name , @start_pos + 1 )

			If @end_pos > 0
				Select @patient_name = SubString( @full_name , @start_pos , @end_pos - @start_pos + 1 )
			Else
				Select @patient_name = SubString( @full_name , @start_pos + 1 , @len1 )
		End

		-- Extract middle initial.
		If @name_type = 'M'
		Begin
			Select @start_pos = CharIndex( ' ' , @full_name )
			Select @end_pos = CharIndex( ' ' , @full_name , @start_pos + 1 )

			If @end_pos > 0
				Select @patient_name = SubString( @full_name , @end_pos , @len1 )
		End

	End

	If @format = 'FM'
	Begin

		-- Extract first name.
		If @name_type = 'F'
		Begin
			Select @start_pos = CharIndex( ' ' , @full_name )
			Select @end_pos = CharIndex( ' ' , @full_name , @start_pos + 1 )

         Select @start_pos = IsNull( @start_pos , 0 )

         -- Firstname is after the middle initial rather than before the middle initial.
         If @start_pos = 2
            Select @patient_name = SubString( @full_name , @start_pos + 1 , @Len1 )

			If @start_pos > 0 And @start_pos <> 2
				Select @patient_name = Left( @full_name , @start_pos )
			
         If @start_pos = 0
				Select @patient_name = @full_name
		End

		-- Extract middle initial.
		If @name_type = 'M'
		Begin
			Select @start_pos = CharIndex( ' ' , @full_name )
			Select @end_pos = @start_pos + 1 -- CharIndex( ' ' , @full_name , @start_pos + 1 )

         -- Middle Inital is before firstname rather than after firstname.
         If @start_pos = 2
         Begin
            Select @patient_name = Left( @full_name , 1 )
            Select @end_pos = 0
         End

			If @end_pos > 1
				Select @patient_name = SubString( @full_name , @end_pos , @len1 )
		End

	End


	Select @patient_name = LTrim( RTrim( @patient_name ) )
	Select @patient_name = Replace( Replace( @patient_name , ',' , '' ) , '.' , '' )

	Return @patient_name
End
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetName2]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	PRINT 'FUNCTION fn_GetName2 CREATED...'
GO
