SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_GetReportEditions]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_GetReportEditions]
GO


--===========================================================================
-- GET REPORT EDITIONS
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_GetReportEditions
	@practice_id INT
AS
BEGIN
	SELECT	ReportEditionID,
		PracticeID,
		PublishDate,
		ReportTitle,
		ReportStartDate,
		ReportEndDate,
		PageOrientation
	FROM	ReportEdition
	WHERE	PracticeID = @practice_id
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

