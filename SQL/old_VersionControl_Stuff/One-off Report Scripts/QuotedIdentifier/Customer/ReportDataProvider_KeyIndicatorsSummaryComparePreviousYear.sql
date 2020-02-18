SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ReportDataProvider_KeyIndicatorsSummaryComparePreviousYear]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ReportDataProvider_KeyIndicatorsSummaryComparePreviousYear]
GO


CREATE PROCEDURE dbo.ReportDataProvider_KeyIndicatorsSummaryComparePreviousYear
	@PracticeID int = NULL,
	@ProviderID int = 0,
	@SummarizeAllProviders bit = 0,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL,
	@ReportType INT = 1,

	@GroupBy Char(1) = 'P',	-- P=Provider, S=ServiceLocation, D=Department	
	@DepartmentID INT = 0,	
	@ServiceLocationID INT = 0
AS
BEGIN
	CREATE TABLE #KISStructure (
		ProviderID int,
		ProviderFullname varchar(128),	
		Charges money,
		Adjustments money,
		Receipts money,
		Refunds money ,
		ARBalance money,
		DaysInAR decimal(10,2),
		DaysRevenueOutstanding decimal(10,2),
		DaysToSubmission decimal(10,2),
		DaysToBill decimal(10,2),
		UnappliedBeginBalance MONEY, 
		UnappliedEndBalance MONEY
		)
		
		
	CREATE TABLE #KISCompareStructure (
		ProviderID int,
		ProviderFullname varchar(128),	
		Current_Charges money,
		Current_Adjustments money,
		Current_Receipts money,
		Current_Refunds money ,
		Current_ARBalance money,
		Current_DaysInAR decimal(10,2),
		Current_DaysRevenueOutstanding decimal(10,2),
		Current_DaysToSubmission decimal(10,2),
		Current_DaysToBill decimal(10,2),
		Current_UnappliedBalance money,
		Previous_Charges money,
		Previous_Adjustments money,
		Previous_Receipts money,
		Previous_Refunds money ,
		Previous_ARBalance money,
		Previous_DaysInAR decimal(10,2),
		Previous_DaysRevenueOutstanding decimal(10,2),
		Previous_DaysToSubmission decimal(10,2),
		Previous_DaysToBill decimal(10,2),
		Previous_UnappliedBalance money
		)
	
	
	INSERT #KISStructure
	EXEC dbo.ReportDataProvider_KeyIndicatorsSummary @PracticeID, @ProviderID, @SummarizeAllProviders, @BeginDate, @EndDate, @ReportType, @GroupBy, @DepartmentID, @ServiceLocationID
	
	INSERT #KISCompareStructure(
		ProviderID,
		ProviderFullname,
		Current_Charges,
		Current_Adjustments,
		Current_Receipts,
		Current_Refunds,
		Current_ARBalance,
		Current_DaysInAR,
		Current_DaysRevenueOutstanding,
		Current_DaysToSubmission,
		Current_DaysToBill,
		Current_UnappliedBalance
	)
	SELECT KIS.ProviderID, 
		KIS.ProviderFullname, 
		KIS.Charges, 
		KIS.Adjustments, 
		KIS.Receipts, 
		KIS.Refunds,
		KIS.ARBalance,
		KIS.DaysInAR,
		KIS.DaysRevenueOutstanding,
		KIS.DaysToSubmission,
		KIS.DaysToBill,
		KIS.UnappliedEndBalance - KIS.UnappliedBeginBalance
	FROM #KISStructure KIS

	DELETE #KISStructure
	
	SET @BeginDate = DATEADD(yy,-1,@BeginDate)
	SET @EndDate = DATEADD(yy,-1,@EndDate)
	
	INSERT #KISStructure
	EXEC dbo.ReportDataProvider_KeyIndicatorsSummary @PracticeID, @ProviderID, @SummarizeAllProviders, @BeginDate, @EndDate, @ReportType, @GroupBy, @DepartmentID, @ServiceLocationID

	UPDATE K
		SET Previous_Charges= KIS.Charges,
			Previous_Adjustments = KIS.Adjustments,
			Previous_Receipts = KIS.Receipts,
			Previous_Refunds = KIS.Refunds,
			Previous_ARBalance = KIS.ARBalance,
			Previous_DaysInAR = KIS.DaysInAR,
			Previous_DaysRevenueOutstanding = KIS.DaysRevenueOutstanding,
			Previous_DaysToSubmission = KIS.DaysToSubmission,
			Previous_DaysToBill = KIS.DaysToBill,
			Previous_UnappliedBalance = KIS.UnappliedEndBalance - KIS.UnappliedBeginBalance
	FROM #KISCompareStructure K
		INNER JOIN #KISStructure KIS
		ON K.ProviderID = KIS.ProviderID

	SELECT *
	FROM #KISCompareStructure	
		
	DROP TABLE #KISStructure
	DROP TABLE #KISCompareStructure
	
	RETURN
	
END


GO
SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

