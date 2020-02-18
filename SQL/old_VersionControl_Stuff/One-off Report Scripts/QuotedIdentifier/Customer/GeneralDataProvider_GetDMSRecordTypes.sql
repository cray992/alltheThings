SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GeneralDataProvider_GetDMSRecordTypes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GeneralDataProvider_GetDMSRecordTypes]
GO


--===========================================================================
-- GET RECORD TYPES
--===========================================================================
CREATE  PROCEDURE dbo.GeneralDataProvider_GetDMSRecordTypes
AS
BEGIN
	SELECT	
		RecordTypeID,
		TableName,
		[Name],
		[Description],
		SortOrder,
		Visible
	FROM	
		DMSRecordType
	ORDER BY
		SortOrder
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

