SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_KeyIndicatorsSummaryComparePreviousYear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_KeyIndicatorsSummaryComparePreviousYear]
GO


--===========================================================================
-- SRS Key Indicators Summary Compare Previous Year
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_KeyIndicatorsSummaryComparePreviousYear
	@CustomerID int,
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@SummarizeAllProviders bit = 0,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@ReportType INT = 1,

	@GroupBy Char(1) = 'P',	-- P=Provider, S=ServiceLocation, D=Department	
	@DepartmentID INT = 0,	
	@ServiceLocationID INT = 0
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_KeyIndicatorsSummaryComparePreviousYear] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@ProviderID = ' + CAST(@ProviderID AS varchar(10))
	SET @sql = @sql + ',@SummarizeAllProviders = ' + CAST(@SummarizeAllProviders AS varchar(1))
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@ReportType = ' + CAST( isnull(@ReportType, 0) AS varchar )

	SET @sql = @sql + ',@GroupBy = ''' + ISNULL(@GroupBy, 'P') + ''''
	SET @sql = @sql + ',@DepartmentID = ' + CAST( ISNULL(@DepartmentID, 0) as varchar)
	SET @sql = @sql + ',@ServiceLocationID = ' + CAST( ISNULL(@ServiceLocationID, 0) as varchar)

	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

