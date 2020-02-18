SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_ARAgingDetail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_ARAgingDetail]
GO


--===========================================================================
-- SRS AR Aging Detail
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_ARAgingDetail
	@CustomerID int,
	@PracticeID int = NULL,
	@AgeRange VARCHAR(20) = 'All', --Can be All, Current, Age31_60, Age61_90, Age91_120, AgeOver120
	@BalanceRange VARCHAR(20) = 'All', --Can be All, $10+,$50+,$100+,$1000+,$5000+,$10000+,$100000
	@VelocitySort BIT = 0, --0 no sort on @AgeRange Balance otherwise sort desc on @AgeRange Balance
	@EndDate datetime = NULL,
	@RespType char(1) = I,
	@Responsibility BIT =0, --Can be currently assigned=0 or ultimate responsibility=1
	@RespID int = 0,
	@BatchID VARCHAR(50) = NULL
AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_ARAgingDetail] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@AgeRange = ''' + @AgeRange + ''''
	SET @sql = @sql + ',@BalanceRange = ''' + @BalanceRange + ''''
	SET @sql = @sql + ',@VelocitySort = ' + CAST(@VelocitySort AS VARCHAR(1))
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	SET @sql = @sql + ',@RespType = ''' + CAST(@RespType AS varchar(1)) + ''''
	SET @sql = @sql + ',@Responsibility = ' + CAST(@Responsibility AS CHAR(1))
	SET @sql = @sql + ',@RespID = ' + CAST(@RespID AS varchar(10))
	
	IF @BatchID IS NOT NULL AND @BatchID <> ''
		SET @sql = @sql + ',@BatchID = ''' + CAST(@BatchID AS varchar(50)) + ''''

	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

