SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_PaymentsDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_PaymentsDetail]
GO


--===========================================================================
-- SRS Payment Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PaymentsDetail
	@CustomerID int,
	@PracticeID int = NULL,
	@ProviderID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@PaymentMethodCode varchar(1) = '',
	@PaymentTypeID INT = -1,
	@BatchID varchar(50)=NULL,
	@ReportType char(1) = 'A'
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PaymentsDetail] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))

	IF @ProviderID IS NOT NULL
		SET @sql = @sql + ',@ProviderID = ' + CAST(@ProviderID AS varchar(10))

	SET @sql = @sql + ',@BeginDate = '''+ CAST(@BeginDate AS varchar(40))  + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	
	IF @PaymentMethodCode IS NOT NULL
		SET @sql = @sql + ',@PaymentMethodCode = ''' + CAST(@PaymentMethodCode AS varchar(40)) + ''''
		
	IF @BatchID IS NOT NULL
		SET @sql = @sql + ',@BatchID = ''' + CAST(@BatchID AS varchar(50)) + ''''

	SET @sql = @sql + ISNULL( ',@PaymentTypeID = ' + CAST(@PaymentTypeID AS varchar), '')
	SET @sql = @sql + ISNULL( ',@ReportType = ' + CAST(@ReportType AS varchar), '')


	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

