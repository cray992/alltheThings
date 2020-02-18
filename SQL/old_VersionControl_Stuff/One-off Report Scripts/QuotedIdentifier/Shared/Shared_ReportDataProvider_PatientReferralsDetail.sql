SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_PatientReferralsDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_PatientReferralsDetail]
GO


--===========================================================================
-- SRS Patient Referrals Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PatientReferralsDetail
	@CustomerID int,
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@ServiceLocationID int = NULL,
	@ReferringProviderID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PatientReferralsDetail] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@ProviderID = ' + CAST(@ProviderID AS varchar(10))
	SET @sql = @sql + ',@ReferringProviderID = ' + CAST(@ReferringProviderID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = '''+ CAST(@BeginDate AS varchar(40))  + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	
	IF @ServiceLocationID IS NOT NULL
		SET @sql = @sql + ',@ServiceLocationID = ' + CAST(@ServiceLocationID AS varchar(10))
	
	EXEC sp_executesql @sql
	
	SET NOCOUNT OFF
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

