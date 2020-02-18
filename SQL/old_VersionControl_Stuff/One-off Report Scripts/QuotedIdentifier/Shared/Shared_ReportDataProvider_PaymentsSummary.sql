SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_PaymentsSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_PaymentsSummary]
GO


--===========================================================================
-- SRS Payment Summary
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PaymentsSummary
	@CustomerID int,
	@PracticeID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@PaymentMethodCode varchar(1) = '',
	@BatchID varchar(50) = NULL, 
	@PaymentTypeID INT = -1
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PaymentsSummary] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = '''+ CAST(@BeginDate AS varchar(40))  + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''

	IF @PaymentMethodCode IS NOT NULL 
		SET @sql = @sql + ',@PaymentMethodCode = ''' + CAST(@PaymentMethodCode AS varchar(1)) + ''''
	
	IF @BatchID IS NOT NULL
		SET @sql = @sql + ',@BatchID = ''' + CAST(@BatchID AS varchar(50)) + ''''

	SET @sql = @sql + ',@PaymentTypeID = ' + CAST(@PaymentTypeID AS varchar )

	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

