SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_ProviderProductivity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_ProviderProductivity]
GO


--===========================================================================
-- SRS Provider Productivity
--Shared_ReportDataProvider_ProviderProductivity 1,122,0,0,0,0,'P','5-1-06','5-7-06','10'
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_ProviderProductivity
	@CustomerID int,
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@ServiceLocationID int = 0,
	@GroupByLocation bit = 1,
	@GroupByProvider bit = 1,
	@DateType CHAR(1)='P',
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@BatchID VARCHAR(50) = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_ProviderProductivity] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@ProviderID = ' + CAST(@ProviderID AS varchar(10))
	SET @sql = @sql + ',@ServiceLocationID = ' + CAST(@ServiceLocationID AS varchar(10))
	SET @sql = @sql + ',@GroupByLocation = ' + CAST(@GroupByLocation AS varchar(1))
	SET @sql = @sql + ',@GroupByProvider = ' + CAST(@GroupByProvider AS varchar(1))
	SET @sql = @sql + ',@DateType = ''' + @DateType + ''''
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@BatchID = ' + CASE WHEN @BatchID IS NULL OR LTRIM(RTRIM(@BatchID))='' THEN 'NULL' ELSE ''''+@BatchID+'''' END + ''
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

