SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_GetReports]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_GetReports]
GO


--===========================================================================
-- GET REPORTS
-- ReportDataProvider_GetReports 1, 'B'
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_GetReports
	@report_category_id INT,
	@SoftwareApplicationID char(1)
AS
BEGIN
	SELECT		*
	FROM		Report R
	INNER JOIN	ReportToSoftwareApplication S
	ON		   S.ReportID = R.ReportID
	AND		   S.SoftwareApplicationID = @SoftwareApplicationID
	WHERE		ReportCategoryID = @report_category_id
	AND 		DisplayOrder > 0
	ORDER BY	DisplayOrder
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

