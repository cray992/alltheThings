SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_ProcedureAnalysisDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_ProcedureAnalysisDetail]
GO


--===========================================================================
-- SRS Procedure Analysis Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_ProcedureAnalysisDetail
	@CustomerID int,
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@InsuranceCompanyPlanID int = 0,
	@ProcedureCode varchar(20) = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_ProcedureAnalysisDetail] '
	SET @sql = @sql + '@PracticeID = ' + CAST(ISNULL(@PracticeID,0) AS varchar(10))
	SET @sql = @sql + ',@ProviderID = ' + CAST(ISNULL(@ProviderID,0) AS varchar(10))
	SET @sql = @sql + ',@BeginDate = '''+ CAST(@BeginDate AS varchar(40))  + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	
	IF @InsuranceCompanyPlanID IS NOT NULL
		SET @sql = @sql + ',@InsuranceCompanyPlanID = ' + CAST(@InsuranceCompanyPlanID AS varchar(10))
	
	IF LEN(@ProcedureCode) > 0
		SET @sql = @sql + ',@ProcedureCode = ''' + CAST(@ProcedureCode AS varchar(20)) + ''''
		
	PRINT @sql
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

