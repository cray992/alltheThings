SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_PatientTransactionsSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].Shared_ReportDataProvider_PatientTransactionsSummary
GO

--Shared_ReportDataProvider_PatientTransactionsSummary 1,13,NULL,'3-1-06','4-1-06','ABC'
--===========================================================================
-- SRS Patient Transaction Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PatientTransactionsSummary
	@CustomerID int,
	@PracticeID int = NULL,
	@PatientID int = NULL, 
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@BatchID AS varchar(50) = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PatientTransactionsSummary] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''

	IF @PatientID IS NOT NULL
		SET @sql = @sql + ',@PatientID = ' + CAST(@PatientID AS varchar(10))

	IF @BatchID IS NOT NULL
		SET @sql = @sql + ',@BatchID = ''' + CAST(@BatchID AS varchar(50)) + ''''

	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

