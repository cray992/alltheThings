-- SQL Function for parsing lastname, firstname and middlename.
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
	DROP FUNCTION [dbo].[fn_GetName]
	PRINT 'FUNCTION fn_GetName DROPPED...'
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_GetName( @full_name Varchar(255) , @name_type Char(1) )
RETURNS Varchar(30)
AS
Begin
	Declare @patient_name	Varchar(50)
			, @start_pos	Int
			, @end_pos		Int

	Select @full_name = IsNull( @full_name , '' )

	-- Extract last name.
	If @name_type = 'L'
	Begin
		Select @patient_name = Left( @full_name , CharIndex( ' ' , @full_name ) )
	End

	-- Extract first name.
	If @name_type = 'F'
	Begin
		Select @start_pos = CharIndex( ' ' , @full_name )
		       , @end_pos = CharIndex( ' ' , @full_name , @start_pos + 1 )

		If IsNull( @end_pos , 0 ) = 0
			Select @end_pos = Len( @full_name )

		-- Extract first name.
		Select @patient_name = SubString( @full_name , @start_pos + 1 , @end_pos )

		Select @start_pos = CharIndex( ' ' , @patient_name )

		-- Get rid of middle initial from the first name.
		If IsNull( @start_pos , 0 ) > 0
			Select @patient_name = Left( @patient_name , @start_pos )
	End

	-- Extract middle name.
	If @name_type = 'M'
	Begin
		-- BRYANT TILLMAN LAWRENCE J      BRYANT                         TILLMAN                         LAWRENC
		Select @start_pos = CharIndex( ' ' , @full_name )
		       -- , @end_pos = CharIndex( ' ' , @full_name , @start_pos + 1 )

		-- If IsNull( @end_pos , 0 ) = 0
			Select @end_pos = Len( @full_name )

		-- Extract first name.
		Select @patient_name = SubString( @full_name , @start_pos + 1 , @end_pos )

		Select @start_pos = CharIndex( ' ' , @patient_name )

		-- Extract middle initial or name from the first name.
		If IsNull( @start_pos , 0 ) > 0
			Select @patient_name = SubString( @patient_name , @start_pos + 1 , 255 )
		Else
			Select @patient_name = ''
	End

	Select @patient_name = LTrim( RTrim( @patient_name ) )

	Return @patient_name
End
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	PRINT 'FUNCTION fn_GetName CREATED...'
GO
