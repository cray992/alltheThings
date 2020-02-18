SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_DeleteReportEdition]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_DeleteReportEdition]
GO


--===========================================================================
-- DELETE REPORT EDITION
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_DeleteReportEdition
	@edition_id INT
AS
BEGIN
	DELETE	ReportEdition
	WHERE	ReportEditionID = @edition_id
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

