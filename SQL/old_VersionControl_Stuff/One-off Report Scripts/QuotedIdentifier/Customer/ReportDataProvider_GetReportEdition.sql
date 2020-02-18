SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_GetReportEdition]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_GetReportEdition]
GO


--===========================================================================
-- GET REPORT EDITION
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_GetReportEdition
	@edition_id INT
AS
BEGIN
	SELECT	ReportEditionID,
		PracticeID,
		PublishDate,
		ReportTitle,
		ReportStartDate,
		ReportEndDate,
		ReportContents,
		PageOrientation, 
		ReportContentsEMF
	FROM	ReportEdition
	WHERE	ReportEditionID = @edition_id
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

