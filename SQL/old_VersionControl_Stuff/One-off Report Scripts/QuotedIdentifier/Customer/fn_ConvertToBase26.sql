IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  Name = N'fn_ConvertToBase26')
	DROP FUNCTION fn_ConvertToBase26
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION dbo.fn_ConvertToBase26(@i INT)
RETURNS VARCHAR(100) 
AS  

/*=============================================================================
   Date: 4/13/2006
Purpose: To convert an unsigned integer to alphabets using a base 26 encoding.
=============================================================================*/

BEGIN 
	DECLARE @base INT,
		@base_start INT, 
		@result VARCHAR(100), 
		@remainder INT, 
		@next_char INT 
	
	SET @base = 26	
	SET @base_start = ASCII('A')
	SET @result = ''

	WHILE ( @i > 0 )
	BEGIN
		SET @remainder = @i % @base
		SET @i = @i / @base
		SET @next_char = @base_start + @remainder
		SET @result = CHAR(@next_char) + @result
	END

	RETURN @result
END

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON 
GO
