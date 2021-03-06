IF EXISTS(SELECT 1 FROM sys.objects WHERE name='KAPI_fn_TrimInput' AND type='FN')
	DROP FUNCTION KAPI_fn_TrimInput

GO

CREATE FUNCTION [dbo].[KAPI_fn_TrimInput] (@input VARCHAR(MAX))
RETURNS VARCHAR(MAX)

AS
BEGIN

	RETURN COALESCE(LTRIM(RTRIM(@input)),'')

END

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='KAPI_fn_TrimOrNULL' AND type='FN')
	DROP FUNCTION KAPI_fn_TrimOrNULL

GO

CREATE FUNCTION [dbo].[KAPI_fn_TrimOrNULL] (@input VARCHAR(MAX))
RETURNS VARCHAR(MAX)

AS
BEGIN

	RETURN LTRIM(RTRIM(@input))

END

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='KAPI_fn_StripNonNumeric' AND type='FN')
	DROP FUNCTION KAPI_fn_StripNonNumeric

GO

CREATE FUNCTION [dbo].[KAPI_fn_StripNonNumeric] (@input VARCHAR(MAX))
RETURNS VARCHAR(MAX)

AS
BEGIN

	IF @input IS NULL
		SET @input=''
	ELSE
	BEGIN
		SET @input=LTRIM(RTRIM(@input))
		SET @input=REPLACE(@input,'-','')
		SET @input=REPLACE(@input,'.','')
		SET @input=REPLACE(@input,'(','')
		SET @input=REPLACE(@input,')','')

		IF ISNUMERIC(@input)=0
			SET @input=''
	END

	RETURN @input
END

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='KAPI_fn_StripNonNumericOrNULL' AND type='FN')
	DROP FUNCTION KAPI_fn_StripNonNumericOrNULL

GO

CREATE FUNCTION [dbo].[KAPI_fn_StripNonNumericOrNULL] (@input VARCHAR(MAX))
RETURNS VARCHAR(MAX)

AS
BEGIN

	IF @input IS NULL
		SET @input=NULL
	ELSE
	BEGIN
		SET @input=LTRIM(RTRIM(@input))
		SET @input=REPLACE(@input,'-','')
		SET @input=REPLACE(@input,'.','')
		SET @input=REPLACE(@input,'(','')
		SET @input=REPLACE(@input,')','')

		IF ISNUMERIC(@input)=0
			SET @input=NULL
	END

	RETURN @input
END

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='KAPI_fn_ConvertToBIT' AND type='FN')
	DROP FUNCTION KAPI_fn_ConvertToBIT

GO

CREATE FUNCTION [dbo].[KAPI_fn_ConvertToBIT] (@input VARCHAR(MAX))
RETURNS BIT

AS
BEGIN
	RETURN CAST(CASE WHEN dbo.fn_ZeroLengthStringToNull(@input) IN ('y','yes','1','true','t') THEN 1 ELSE CASE WHEN @input IS NULL THEN NULL ELSE 0 END END AS BIT)
END

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='KAPI_fn_ConvertToINT' AND type='FN')
	DROP FUNCTION KAPI_fn_ConvertToINT

GO

CREATE FUNCTION [dbo].[KAPI_fn_ConvertToINT] (@input VARCHAR(MAX), @returnDefault BIT, @defaultValue INT)
RETURNS INT

AS
BEGIN
	RETURN CASE WHEN ISNUMERIC(@input)=1 THEN CAST(CAST(@input AS REAL) AS INT)
			ELSE CASE 
					WHEN @returnDefault=1 THEN 
						CASE WHEN @defaultValue IS NOT NULL THEN @defaultValue
						ELSE NULL END
				 ELSE NULL END 
		   END
END

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='KAPI_fn_ConvertToDateTime' AND type='FN')
	DROP FUNCTION KAPI_fn_ConvertToDateTime

GO

CREATE FUNCTION [dbo].[KAPI_fn_ConvertToDateTime] (@input VARCHAR(MAX), @returnDefault BIT, @defaultValue DATETIME)
RETURNS DATETIME

AS
BEGIN
	RETURN CASE WHEN ISDATE(@input)=1 THEN CAST(@input AS DATETIME) 
			ELSE CASE 
					WHEN @returnDefault=1 THEN 
						CASE WHEN @defaultValue IS NOT NULL THEN @defaultValue
						ELSE NULL END
				 ELSE NULL END 
		   END
END

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='KAPI_fn_ConvertToGenderCode' AND type='FN')
	DROP FUNCTION KAPI_fn_ConvertToGenderCode

GO

CREATE FUNCTION [dbo].[KAPI_fn_ConvertToGenderCode] (@input VARCHAR(MAX))
RETURNS CHAR(1)

AS
BEGIN
	RETURN CASE LTRIM(RTRIM(@input))
			WHEN 'Male' THEN 'M'
			WHEN 'M' THEN 'M'
			WHEN 'Female' THEN 'F'
			WHEN 'F' THEN 'F'
		   ELSE CASE WHEN @input IS NULL THEN NULL ELSE 'U' END END
END

GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE name='KAPI_fn_ConvertToMoney' AND type='FN')
	DROP FUNCTION KAPI_fn_ConvertToMoney

GO

CREATE FUNCTION [dbo].[KAPI_fn_ConvertToMoney] (@input VARCHAR(MAX), @returnDefault BIT, @defaultValue INT)
RETURNS MONEY

AS
BEGIN
	RETURN CASE WHEN ISNUMERIC(@input)=1 THEN CAST(CAST(@input AS REAL) AS MONEY)
			ELSE CASE 
					WHEN @returnDefault=1 THEN 
						CASE WHEN @defaultValue IS NOT NULL THEN @defaultValue
						ELSE NULL END
				 ELSE NULL END 
		   END
END