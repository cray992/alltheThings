/**********************************************************************************************
** Name		: ReportDataProvider_UpdateReportMedicalOfficeMaxDate
**
** Desc         : Update the max date the medical office is allowed to run a report for
**
***********************************************************************************************/

IF EXISTS (
	SELECT	*
	FROM	SYSOBJECTS
	WHERE	Name = 'ReportDataProvider_UpdateReportMedicalOfficeMaxDate'
	AND	TYPE = 'P'
)
	DROP PROCEDURE dbo.ReportDataProvider_UpdateReportMedicalOfficeMaxDate
GO

CREATE PROCEDURE dbo.ReportDataProvider_UpdateReportMedicalOfficeMaxDate
	@PracticeID INT, 
	@MedicalOfficeReportMaxDate DATETIME = NULL
AS
BEGIN

	UPDATE		Practice
	SET		MedicalOfficeReportMaxDate = @MedicalOfficeReportMaxDate
	WHERE		PracticeID = @PracticeID

END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

