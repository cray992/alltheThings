SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Shared_ReportDataProvider_ARAging]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Shared_ReportDataProvider_ARAging]
GO


--===========================================================================
-- SRS AR Aging
--===========================================================================
CREATE PROCEDURE dbo.Shared_ReportDataProvider_ARAging
	@CustomerID int,
	@PracticeID int = NULL,
	@PayerTypeCode INT, --Can be I, P, or A for all
	@Responsibility BIT =0, --Can be currently assigned=0 or ultimate responsibility=1
	@AgeRange VARCHAR(20) = 'All', --Can be All, Current, Age31_60, Age61_90, Age91_120, AgeOver120
	@BalanceRange VARCHAR(20) = 'All', --Can be All, $10+,$50+,$100+,$1000+,$5000+,$10000+,$100000
	@VelocitySort BIT = 0, --0 no sort on @AgeRange Balance otherwise sort desc on @AgeRange Balance
	@EndDate datetime = NULL,
	@BatchID VARCHAR(50) = NULL,
	@DateType Char(1) = 'B', -- B = Last Billed Date, P = Posting Date, S = Service Date
	@ProviderID INT = -1,
	@ServiceLocationID INT = -1,
	@DepartmentID INT = -1,
	@PayerScenarioID INT = -1,
	@InsuranceCompanyPlanID INT = -1,
	@PatientID INT = -1,
	@ContractID INT = -1

AS
BEGIN
	DECLARE @DatabaseName varchar(128)
	SELECT @DatabaseName = C.DatabaseName
	FROM dbo.Customer C
	WHERE C.CustomerID = @CustomerID
	
	DECLARE @sql varchar(8000)
	DECLARE @PayerTypeCodeChar CHAR(1)
	IF @PayerTypeCode=1
		SET @PayerTypeCodeChar='I'
	ELSE
		SET @PayerTypeCodeChar='P'

	SET @sql = 'EXEC ' + @DatabaseName + '.[dbo].[ReportDataProvider_ARAging] '
	SET @sql = @sql + '@PracticeID = ' + CAST(@PracticeID AS varchar(10))
	SET @sql = @sql + ',@PayerTypeCode = ''' + @PayerTypeCodeChar + ''''
	SET @sql = @sql + ',@Responsibility = ' + CAST(@Responsibility AS CHAR(1))
	SET @sql = @sql + ',@AgeRange = ''' + @AgeRange + ''''
	SET @sql = @sql + ',@BalanceRange = ''' + @BalanceRange + ''''
	SET @sql = @sql + ',@VelocitySort = ' + CAST(@VelocitySort AS VARCHAR(1))
	SET @sql = @sql + ',@EndDate = ''' + CAST(@EndDate AS varchar(40)) + ''''
	
	IF @BatchID IS NOT NULL AND @BatchID <> ''
		SET @sql = @sql + ',@BatchID = ''' + CAST(@BatchID AS varchar(50)) + ''''

	SET @sql = @sql + ',@DateType = ' + '''' + @DateType + ''''
	SET @sql = @sql + ',@ProviderID = ' + CAST(@ProviderID AS varchar(10))
	SET @sql = @sql + ',@ServiceLocationID = ' + CAST(@ServiceLocationID AS varchar(10))
	SET @sql = @sql + ',@DepartmentID = ' + CAST(@DepartmentID AS varchar(10))
	SET @sql = @sql + ',@PayerScenarioID = ' + CAST(@PayerScenarioID AS varchar(10))
	SET @sql = @sql + ',@InsuranceCompanyPlanID = ' + CAST(@InsuranceCompanyPlanID AS varchar(10))
	SET @sql = @sql + ',@PatientID = ' + CAST(@PatientID AS varchar(10))
	SET @sql = @sql + ',@ContractID = ' + CAST(@ContractID AS varchar)


	EXEC (@sql)
	
	RETURN
END

GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

