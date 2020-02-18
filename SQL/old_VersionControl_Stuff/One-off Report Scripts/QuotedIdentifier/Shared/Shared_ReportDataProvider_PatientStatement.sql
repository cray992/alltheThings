SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_PatientStatement]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_PatientStatement]
GO


--===========================================================================
-- SRS AR Aging
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_PatientStatement
	@CustomerID int,
	@PracticeID int,
	@PatientID INT,
	@EndDate datetime,
	@ReportType CHAR(1) = 'O',
	@IncludeUnappliedPayments BIT
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_PatientStatement] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@PatientID = ' + CAST(@PatientID AS varchar(10))
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@ReportType =''' + @ReportType + ''''
	SET @sql = @sql + ',@IncludeUnappliedPayments = ' + CAST(@IncludeUnappliedPayments AS VARCHAR(10))
	
	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

