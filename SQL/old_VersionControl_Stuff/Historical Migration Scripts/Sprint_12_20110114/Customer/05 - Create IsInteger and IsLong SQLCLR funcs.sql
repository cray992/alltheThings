-- IsInteger()
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsInteger]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[IsInteger]
GO

CREATE FUNCTION [dbo].[IsInteger](@s [nvarchar](4000))
RETURNS [bit] WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [Kareo.Database.Helper].[NumericFunctions].[IsInteger]
GO

-- IsLong()
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IsLong]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[IsLong]
GO

CREATE FUNCTION [dbo].[IsLong](@s [nvarchar](4000))
RETURNS [bit] WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [Kareo.Database.Helper].[NumericFunctions].[IsLong]
GO

