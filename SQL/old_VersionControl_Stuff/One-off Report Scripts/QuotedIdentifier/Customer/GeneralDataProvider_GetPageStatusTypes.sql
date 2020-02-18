SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[GeneralDataProvider_GetPageStatusTypes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[GeneralDataProvider_GetPageStatusTypes]
GO


--===========================================================================
-- GET PAGE STATUS TYPES
--===========================================================================
CREATE  PROCEDURE dbo.GeneralDataProvider_GetPageStatusTypes
AS
BEGIN
	SELECT	PageStatusTypeID,
		[Name]
	FROM	PageStatusType
	ORDER BY
		SortOrder
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

