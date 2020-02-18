SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_GroupNumbers]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_GroupNumbers]
GO


--===========================================================================
-- SRS Refunds Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_GroupNumbers
	@CustomerID int,
	@PracticeID int,
	@ServiceLocationID INT = -1,
	@InsuranceCompanyID INT = -1
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_GroupNumbers] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ', @ServiceLocationID = ' + CAST(@ServiceLocationID AS varchar )
	SET @sql = @sql + ', @InsuranceCompanyID = ' + CAST(@InsuranceCompanyID AS varchar )

	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

