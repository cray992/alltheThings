SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_UpdateReportEdition]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_UpdateReportEdition]
GO


--===========================================================================
-- UPDATE REPORT EDITION
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_UpdateReportEdition
	@edition_id INT,
	@practice_id INT,
	@title VARCHAR(250),
	@start_date DATETIME = NULL,
	@end_date DATETIME = NULL,
	@contents TEXT = NULL,
	@page_orientation INT, 
	@contents_emf IMAGE = NULL
AS
BEGIN
	UPDATE	ReportEdition
	SET	PracticeID = @practice_id,
		PublishDate = GETDATE(),
		ReportTitle = @title,
		ReportStartDate = @start_date,
		ReportEndDate = @end_date,
		ReportContents = @contents,
		PageOrientation = @page_orientation, 
		ReportContentsEMF = @contents_emf
	WHERE	ReportEditionID = @edition_id
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

