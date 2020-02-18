SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardDataProvider_GetKeyIndicatorsForDisplay]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DashboardDataProvider_GetKeyIndicatorsForDisplay]
GO

CREATE PROCEDURE dbo.DashboardDataProvider_GetKeyIndicatorsForDisplay
	@PracticeID int = NULL,
	@ComparePeriodType char(1) = 'M'
AS
BEGIN
	SET NOCOUNT ON

	IF NOT EXISTS ( 
		SELECT * 
		FROM dbo.DashboardKeyIndicatorDisplay 
		WHERE PracticeID = @PracticeID 
			AND CreatedDate > DATEADD(hour, -1, GETDATE()) ) 
	BEGIN
		/* Cache the dashboard data now ... */
		exec dbo.DashboardDataProvider_UpdateKeyIndicatorsVolatileJobForPractice @PracticeID
	END

	DECLARE @flat TABLE (
		[PracticeID] [int] NULL ,
		[ComparePeriodType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
		[Procedures] [varchar](100) NULL ,
		[PercentOfProcedures] [varchar](100) NULL ,
		[Charges] [varchar](100) NULL ,
		[PercentOfCharges] [varchar](100) NULL ,
		[Adjustments] [varchar](100) NULL ,
		[PercentOfAdjustments] [varchar](100) NULL ,
		[Receipts] [varchar](100) NULL ,
		[PercentOfReceipts] [varchar](100) NULL ,
		[Refunds] [varchar](100) NULL ,
		[PercentOfRefunds] [varchar](100) NULL ,
		[ARBalance] [varchar](100) NULL ,
		[PercentOfARBalance] [varchar](100) NULL ,
		[DaysInAR] [varchar](100) NULL ,
		[PercentOfDaysInAR] [varchar](100) NULL ,
		[DaysRevenueOutstanding] [varchar](100) NULL ,
		[PercentOfDaysRevenueOutstanding] [varchar](100) NULL ,
		[DaysToSubmission] [varchar](100) NULL ,
		[PercentOfDaysToSubmission] [varchar](100) NULL ,
		[DaysToBill] [varchar](100) NULL ,
		[PercentOfDaysToBill] [varchar](100) NULL ,
		[CreatedDate] [datetime] NULL
	)
	
	INSERT @flat(	
		PracticeID, 
		ComparePeriodType, 
		Procedures, 
		PercentOfProcedures, 
		Charges, 
		PercentOfCharges, 
		Adjustments, 
		PercentOfAdjustments, 
		Receipts, 
		PercentOfReceipts, 
		Refunds, 
		PercentOfRefunds, 
		ARBalance, 
		PercentOfARBalance, 
		DaysInAR, 
		PercentOfDaysInAR, 
		DaysRevenueOutstanding, 
		PercentOfDaysRevenueOutstanding, 
		DaysToSubmission, 
		PercentOfDaysToSubmission, 
		DaysToBill, 
		PercentOfDaysToBill, 
		CreatedDate
	)
	SELECT PracticeID, 
		ComparePeriodType, 
		CONVERT(varchar, CONVERT(int, Procedures)), 
		CONVERT(varchar, PercentOfProcedures), 
		'$' + CONVERT(varchar, CONVERT(int, Charges)), 
		CONVERT(varchar, PercentOfCharges), 
		'$' + CONVERT(varchar, CONVERT(int, Adjustments)), 
		CONVERT(varchar, PercentOfAdjustments), 
		'$' + CONVERT(varchar, CONVERT(int, Receipts)), 
		CONVERT(varchar, PercentOfReceipts), 
		'$' + CONVERT(varchar, CONVERT(int, Refunds)), 
		CONVERT(varchar, PercentOfRefunds), 
		'$' + CONVERT(varchar, CONVERT(int, ARBalance)), 
		CONVERT(varchar, PercentOfARBalance), 
		CONVERT(varchar, CONVERT(int, DaysInAR)), 
		CONVERT(varchar, PercentOfDaysInAR), 
		CONVERT(varchar, CONVERT(int, DaysRevenueOutstanding)), 
		CONVERT(varchar, PercentOfDaysRevenueOutstanding), 
		CONVERT(varchar, CONVERT(int, DaysToSubmission)), 
		CONVERT(varchar, PercentOfDaysToSubmission), 
		CONVERT(varchar, CONVERT(int, DaysToBill)), 
		CONVERT(varchar, PercentOfDaysToBill), 
		CreatedDate
	FROM dbo.DashboardKeyIndicatorDisplay
	WHERE PracticeID = @PracticeID
		AND ComparePeriodType = @ComparePeriodType

	DECLARE @list TABLE(
		ID int identity(1,1),
		Indicator varchar(100),
		Amount varchar(100),
		PercentOfChange varchar(100)
	)
	
	--1. Procedures
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Procedures', Procedures, PercentOfProcedures
	FROM @flat
	--2. Charges
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Charges', Charges, PercentOfCharges FROM @flat
	--3. Adjustments
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Adjustments', Adjustments, PercentOfAdjustments
	FROM @flat
	--4. Receipts
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Receipts', Receipts, PercentOfReceipts
	FROM @flat
	--5. Refunds
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Refunds', Refunds, PercentOfRefunds
	FROM @flat
	--6. A/R Balance
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'A/R Balance', ARBalance, PercentOfARBalance
	FROM @flat
	--7. Days in A/R
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Days in A/R', DaysInAR, PercentOfDaysInAR
	FROM @flat
	--8. Days Revenue Outstanding
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Days Revenue Outstanding', DaysRevenueOutstanding, PercentOfDaysRevenueOutstanding
	FROM @flat	
	--9. Days to Submission
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Days To Submission', DaysToSubmission, PercentOfDaysToSubmission
	FROM @flat	
	--10. Days to Bill
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'Days to Bill', DaysToBill, PercentOfDaysToBill
	FROM @flat		
	--11. CreatedDate
	INSERT @list(Indicator, Amount, PercentOfChange)
	SELECT 'CreatedDate', CreatedDate, '0'
	FROM @flat			

	SELECT *
	FROM @list 
	ORDER BY ID ASC

	SET NOCOUNT OFF
END
