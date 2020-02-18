SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_RefundsDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_RefundsDetail]
GO


--===========================================================================
-- SRS Refunds Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_RefundsDetail
	@CustomerID int,
	@PracticeID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@PaymentMethodCode varchar(1) = ''
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_RefundsDetail] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''

	IF @PaymentMethodCode <> ''
		SET @sql = @sql + ',@PaymentMethodCode = ''' + CAST(@PaymentMethodCode AS varchar(1)) + ''''
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

