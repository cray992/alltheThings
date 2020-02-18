SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_CreateReportEdition]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_CreateReportEdition]
GO


--===========================================================================
-- CREATE REPORT EDITION
--===========================================================================
CREATE PROCEDURE dbo.ReportDataProvider_CreateReportEdition
	@practice_id INT,
	@title VARCHAR(250),
	@start_date DATETIME = NULL,
	@end_date DATETIME = NULL,
	@contents TEXT = NULL,
	@page_orientation INT = 0, 
	@contents_emf IMAGE = NULL
AS
BEGIN
	INSERT	ReportEdition (
		PracticeID,
		PublishDate,
		ReportTitle,
		ReportStartDate,
		ReportEndDate,
		ReportContents,
		PageOrientation, 
		ReportContentsEMF)
	VALUES	(
		@practice_id,
		GETDATE(),
		@title,
		@start_date,
		@end_date,
		@contents,
		@page_orientation, 
		@contents_emf)
	
	RETURN SCOPE_IDENTITY()
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

