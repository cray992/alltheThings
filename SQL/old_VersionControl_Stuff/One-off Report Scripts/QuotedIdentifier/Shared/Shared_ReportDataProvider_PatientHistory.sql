SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_PatientHistory]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_PatientHistory]
GO


--===========================================================================
-- SRS Patient History
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PatientHistory
	@CustomerID int,
	@PracticeID int = NULL,
	@PatientID int = 0,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PatientHistory] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@PatientID = ' + CAST(@PatientID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

