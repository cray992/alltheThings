SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_AppointmentsSummary]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_AppointmentsSummary]
GO


--===========================================================================
-- SRS Appointments Summary
--===========================================================================
CREATE  PROCEDURE dbo.Shared_ReportDataProvider_AppointmentsSummary
	@CustomerID int,
	@PracticeID int = NULL,
	@AppointmentResourceTypeID int = NULL, 
	@ResourceID int = NULL,
	@Status varchar(64)=NULL,
	@PatientID int = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL, 
	@TimeOffset int = 0,
	@ServiceLocationID INT = -1,
	@MinuteInterval INT = NULL,
	@StartTime varchar(50) = NULL,
	@EndTime varchar(50) = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_AppointmentsSummary] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@BeginDate = ''' + CAST(@BeginDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@TimeOffset = ' + CAST(@TimeOffset AS varchar(10))
	IF @AppointmentResourceTypeID IS NOT NULL SET @sql = @sql + ',@AppointmentResourceTypeID = ' + CAST(@AppointmentResourceTypeID AS varchar(10))
	IF @ResourceID IS NOT NULL SET @sql = @sql + ',@ResourceID = ' + CAST(@ResourceID AS varchar(10))
	IF @PatientID IS NOT NULL SET @sql = @sql + ',@PatientID = ' + CAST(@PatientID AS varchar(10))
	IF @Status IS NOT NULL SET @sql = @sql + ',@Status = ''' + LTRIM(RTRIM(@Status)) + ''''
	IF @MinuteInterval IS NOT NULL SET @sql = @sql + ',@MinuteInterval = ' + CAST(@MinuteInterval AS varchar)
	IF @StartTime IS NOT NULL SET @sql = @sql + ',@StartTime = ''' + LTRIM(RTRIM(@StartTime)) + ''''
	IF @EndTime IS NOT NULL SET @sql = @sql + ',@EndTime = ''' + LTRIM(RTRIM(@EndTime)) + ''''


	SET @sql = @sql + ',@ServiceLocationID = ' + CAST(@ServiceLocationID AS varchar )

	EXEC (@sql)
	
	RETURN
END


GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

