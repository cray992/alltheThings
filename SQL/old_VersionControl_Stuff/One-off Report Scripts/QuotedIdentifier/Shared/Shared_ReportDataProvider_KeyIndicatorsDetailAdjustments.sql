SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_KeyIndicatorsDetailAdjustments]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_KeyIndicatorsDetailAdjustments]
GO


--===========================================================================
-- SRS Key Indicators Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_KeyIndicatorsDetailAdjustments
	@CustomerID int,
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@SummarizeAllProviders bit = 0,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_KeyIndicatorsDetailAdjustments] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = '''+ CAST(@BeginDate AS varchar(40))  + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@ProviderID = ' + CAST(@ProviderID AS varchar(10))
	SET @sql = @sql + ',@SummarizeAllProviders = ' + CAST(@SummarizeAllProviders AS varchar(1))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

