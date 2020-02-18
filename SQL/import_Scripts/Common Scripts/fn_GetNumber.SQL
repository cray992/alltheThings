-- SQL Function for parsing numbers and getting rid of special characters.
IF  EXISTS ( SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT') )
BEGIN
	DROP FUNCTION [dbo].[fn_GetNumber]
	PRINT 'FUNCTION fn_GetNumber DROPPED...'
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION dbo.fn_GetNumber( @string Varchar(255) )
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
	Select @string = Replace( @string , '_' , '' )

	If LTrim( RTrim( @string ) ) = ''
		Select @string = Null

	Select @number = Left( @string , 20 )

	Return @number
End
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetNumber]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	PRINT 'FUNCTION fn_GetNumber CREATED...'
GO
