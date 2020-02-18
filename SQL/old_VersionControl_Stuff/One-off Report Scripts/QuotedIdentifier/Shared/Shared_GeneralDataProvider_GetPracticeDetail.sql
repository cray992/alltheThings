SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_GetPracticeDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_GetPracticeDetail]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_GeneralDataProvider_GetPracticeDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_GeneralDataProvider_GetPracticeDetail]
GO

--===========================================================================
-- Gets the practice detail and company name
-- EXEC dbo.Shared_GeneralDataProvider_GetPracticeDetail 1, 19
-- EXEC dbo.Shared_GeneralDataProvider_GetPracticeDetail 40, 1
-- EXEC dbo.Shared_GeneralDataProvider_GetPracticeDetail 1, -1
--===========================================================================
CREATE PROCEDURE dbo.Shared_GeneralDataProvider_GetPracticeDetail
	@CustomerID int,
	@PracticeID int = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	DECLARE @CompanyName varchar(128)

	SELECT 	@DatabaseName = C.DatabaseName,
		@CompanyName = C.CompanyName
	FROM 	dbo.Customer C
	WHERE 	C.CustomerID = @CustomerID

	IF @PracticeID > 0
	BEGIN
	
		DECLARE @sql varchar(8000)
	
		SET @sql = 'SELECT	PracticeID, Name, MedicalOfficeReportMaxDate, CompanyName ' 
		SET @sql = @sql + 'FROM	' + @DatabaseName + '.[dbo].[Practice] '
		SET @sql = @sql + 'INNER JOIN dbo.Customer ON CustomerID = ' + convert(varchar(8), @CustomerID) + ' '
		SET @sql = @sql + 'WHERE PracticeID = ' + convert(varchar(8), @PracticeID)
	
		EXEC (@sql)
	END
	ELSE
	BEGIN
		SELECT 	NULL as PracticeID, 
			NULL as Name,
			NULL as MedicalOfficeReportMaxDate,
			@CompanyName as CompanyName
	END
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

