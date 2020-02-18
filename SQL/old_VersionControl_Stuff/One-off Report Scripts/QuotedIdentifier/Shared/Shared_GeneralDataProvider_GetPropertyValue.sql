IF EXISTS (
	SELECT	*
	FROM	dbo.sysobjects
	WHERE	id = object_id(N'[dbo].[Shared_GeneralDataProvider_GetPropertyValue]')
	AND	xtype IN (N'FN', N'IF', N'TF'))

DROP FUNCTION [dbo].[Shared_GeneralDataProvider_GetPropertyValue]

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--===========================================================================
-- LOOKUP SYSTEM WIDE PROPERTY VALUES
--===========================================================================
CREATE FUNCTION dbo.Shared_GeneralDataProvider_GetPropertyValue (
	@PropertyName varchar(128)
	)
RETURNS varchar(MAX)
AS
BEGIN
	DECLARE @Returns varchar(MAX)
	
	SELECT @Returns = SSPV.Value
	FROM dbo.SharedSystemPropertiesAndValues SSPV
	WHERE SSPV.PropertyName = @PropertyName

	RETURN @Returns
END

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON 
GO


