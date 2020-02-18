SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_ProcedurePaymentsSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_ProcedurePaymentsSummary]
GO

--===========================================================================
-- SRS Procedure Payments Summary
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_ProcedurePaymentsSummary
	@CustomerID int,
	@PracticeID int = NULL,
	@ProviderID int = NULL,
	@ProcedureCode int = NULL,
	@GroupByProvider bit = 1,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_ProcedurePaymentsSummary] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@ProviderID = ' + CAST(ISNULL(@ProviderID, 0) AS varchar(10))
	SET @sql = @sql + ',@GroupByProvider = ' + CAST(@GroupByProvider AS varchar(1))
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@ProcedureCode = ' + CAST(ISNULL(@ProcedureCode, 0) AS varchar(40))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

