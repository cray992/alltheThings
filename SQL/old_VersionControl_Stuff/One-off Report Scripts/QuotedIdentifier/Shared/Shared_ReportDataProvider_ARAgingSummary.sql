SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_ARAgingSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_ARAgingSummary]
GO


--===========================================================================
-- SRS AR Aging
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_ARAgingSummary
	@CustomerID int,
	@PracticeID int = NULL,
	@DateType Char(1) = 'B', -- B="Last Billed Date", P="Post Date", S="Service Date", 
	@EndDate datetime,
	@ProviderID int = -1,
	@BatchID VARCHAR(50) = NULL,
	@ServiceLocationID INT = -1,
	@DepartmentID INT = -1,
	@PayerScenarioID INT = -1,
	@ContractID INT = -1
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_ARAgingSummary] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))

	SET @sql = @sql + ',@DateType = ' + '''' + @DateType + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''

	SET @sql = @sql + ',@ProviderID = ' + CAST(@ProviderID AS varchar(10))

	IF @BatchID IS NOT NULL AND @BatchID <> ''
		SET @sql = @sql + ',@BatchID = ''' + CAST(@BatchID AS varchar(50)) + ''''

	SET @sql = @sql + ', @ServiceLocationID = ' + CAST(@ServiceLocationID AS varchar(10))
	SET @sql = @sql + ', @DepartmentID = ' + CAST(@DepartmentID AS varchar(10))
	SET @sql = @sql + ', @PayerScenarioID = ' + CAST(@PayerScenarioID AS varchar(10))
	SET @sql = @sql + ', @ContractID = ' + CAST(@ContractID AS varchar )

	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

