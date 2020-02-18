SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_GetReportCategories]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_GetReportCategories]
GO


--===========================================================================
-- GET REPORTS
-- ReportDataProvider_GetReportCategories 'B'
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_GetReportCategories
	@SoftwareApplicationID char(1)
AS
BEGIN
	SELECT		RC.ReportCategoryID,
			RC.DisplayOrder,
			RC.Image,
			RC.Name,
			RC.Description,
			RC.TaskName
	FROM		ReportCategory RC
	INNER JOIN	ReportCategoryToSoftwareApplication S
	ON		   S.ReportCategoryID = RC.ReportCategoryID
	AND		   S.SoftwareApplicationID = @SoftwareApplicationID
	WHERE 		RC.DisplayOrder > 0
	ORDER BY	RC.DisplayOrder

	SELECT		RC.Name, 
			R.PermissionValue
	FROM		Report R
	INNER JOIN	ReportToSoftwareApplication S1
	ON		   S1.ReportID = R.ReportID
	AND		   S1.SoftwareApplicationID = @SoftwareApplicationID
	INNER JOIN	ReportCategory RC
	ON		   RC.ReportCategoryID = R.ReportCategoryID
	INNER JOIN	ReportCategoryToSoftwareApplication S2
	ON		   S2.ReportCategoryID = RC.ReportCategoryID
	AND		   S2.SoftwareApplicationID = @SoftwareApplicationID
	ORDER BY	RC.Name
	
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

