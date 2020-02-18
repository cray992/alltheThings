IF EXISTS (SELECT * 
	   FROM   sysobjects 
	   WHERE  Name = N'fn_ConvertFromBase26')
	DROP FUNCTION fn_ConvertFromBase26
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION dbo.fn_ConvertFromBase26(@s VARCHAR(100))
RETURNS INT
AS  

/*=============================================================================
   Date: 4/13/2006
Purpose: To convert an Base 26 string to an integer.
=============================================================================*/

BEGIN 
	DECLARE @base INT,
		@base_start INT, 
		@result INT,
		@last INT,
		@length INT,
		@index INT,
		@next_digit VARCHAR(1)
	
	SET @s = RTRIM(@s)
	SET @base = 26	
	SET @base_start = ASCII('A')
	SET @length = LEN(@s)
	SET @last = @length
	SET @index = 0
	SET @next_digit = ''
	SET @result = 0

	WHILE ( @index < @length )
	BEGIN
		SET @next_digit = SUBSTRING(@s, (@last - @index), 1)
		SET @result = @result + (POWER(@base, @index) * (ASCII(@next_digit) - @base_start));
		SET @index = @index + 1
	END

	RETURN @result
END

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON 
GO
