SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_GetReportCategoriesAndReports]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_GetReportCategoriesAndReports]
GO


--===========================================================================
-- GET REPORT CATEGORIES AND REPORTS
-- dbo.ReportDataProvider_GetReportCategoriesAndReports 'B'
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_GetReportCategoriesAndReports
	@SoftwareApplicationID char(1)
AS
BEGIN
	SELECT		RC.ReportCategoryID,
			RC.DisplayOrder,
			RC.Image,
			RC.Name,
			RC.Description,
			RC.TaskName,
			R.ReportID,
			R.DisplayOrder AS ReportDisplayOrder,
			R.Image AS ReportImage,
			R.Name AS ReportName,
			R.Description AS ReportDescription,
			R.TaskName AS ReportTaskName,
			R.ReportPath,
			R.ReportParameters,
			R.PermissionValue
	FROM		ReportCategory RC
	INNER JOIN	ReportCategoryToSoftwareApplication S1
	ON		   S1.ReportCategoryID = RC.ReportCategoryID
	AND		   S1.SoftwareApplicationID = @SoftwareApplicationID
	INNER JOIN	Report R
	ON		R.ReportCategoryID = RC.ReportCategoryID
	INNER JOIN	ReportToSoftwareApplication S2
	ON		   S2.ReportID = R.ReportID
	AND		   S2.SoftwareApplicationID = @SoftwareApplicationID
	WHERE 		RC.DisplayOrder > 0 AND R.DisplayOrder > 0
	ORDER BY	RC.DisplayOrder, R.DisplayOrder
/*
	SELECT	1 AS Tag, NULL AS Parent,
		RC.ReportCategoryID  AS [ReportCategory!1!ReportCategoryID],
		RC.Name AS [ReportCategory!1!ReportCategoryName],
		RC.Description AS [ReportCategory!1!ReportCategoryDescription]

	FROM		ReportCategory RC
	ORDER BY	RC.DisplayOrder

	FOR XML EXPLICIT
*/
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

