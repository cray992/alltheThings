SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardDataProvider_UpdateKeyIndicatorsForVolatile]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DashboardDataProvider_UpdateKeyIndicatorsForVolatile]
GO

--return
--
--CREATE PROCEDURE dbo.DashboardDataProvider_UpdateKeyIndicatorsForVolatile
--	@PracticeID int = NULL,
--	@ComparePeriodType char(1) = 'M'
--AS
--BEGIN
--	--M=Month, Q=Quarter, Y=Year
--	DECLARE @Current_BeginDate datetime 
--	DECLARE @Current_EndDate datetime
--	DECLARE @Prior_BeginDate datetime
--	DECLARE @Prior_EndDate datetime
--	DECLARE @CurrentMonth int
--	DECLARE @QuarterBeginMonth int
--		
--	DECLARE @PercentThreshold int
--	DECLARE @PercentThresholdErrorValue float
--	SET @PercentThreshold = 9999
--	SET @PercentThresholdErrorValue = 9999.99
--		
--	SET @Current_EndDate = GETDATE()
--	
--	IF @ComparePeriodType = 'M'
--	BEGIN
--		SET @Current_BeginDate = CAST(MONTH(@Current_EndDate) AS varchar(2)) + '/1/' + CAST(YEAR(@Current_EndDate) AS varchar(4))
--		SET @Prior_BeginDate = DATEADD(m,-1,@Current_BeginDate)
--		SET @Prior_EndDate = DATEADD(m,-1,@Current_EndDate)
----		SET @Prior_EndDate = DATEADD(ms,-10,DATEADD(m,1,@Prior_BeginDate))
--	END
--	ELSE IF @ComparePeriodType = 'Q'
--	BEGIN
--		SET @CurrentMonth = MONTH(@Current_EndDate)
--		IF @CurrentMonth IN (1,2,3)
--			SET @QuarterBeginMonth = 1
--		ELSE IF @CurrentMonth IN (4,5,6)
--			SET @QuarterBeginMonth = 4
--		ELSE IF @CurrentMonth IN (7,8,9)
--			SET @QuarterBeginMonth = 7
--		ELSE
--			SET @QuarterBeginMonth = 10	
--	
--		SET @Current_BeginDate = CAST(@QuarterBeginMonth AS varchar(2)) + '/1/' + CAST(YEAR(@Current_EndDate) AS varchar(4))
--		SET @Prior_BeginDate = DATEADD(q,-1,@Current_BeginDate)
--		SET @Prior_EndDate = DATEADD(q,-1,@Current_EndDate)
----		SET @Prior_EndDate = DATEADD(ms,-10,DATEADD(q,1,@Prior_BeginDate))			
--	END
--	ELSE
--	BEGIN
--		SET @Current_BeginDate = '1/1/' + CAST(YEAR(@Current_EndDate) AS varchar(4))
--		SET @Prior_BeginDate = DATEADD(yyyy,-1,@Current_BeginDate)
--		SET @Prior_EndDate = DATEADD(yyyy,-1,@Current_EndDate)
----		SET @Prior_EndDate = DATEADD(ms,-10,DATEADD(yyyy,1,@Prior_BeginDate))		
--	END
--	
--	--Remove the existing record, may or may NOT exist
--	DELETE dbo.DashboardKeyIndicatorVolatile
--	WHERE PracticeID = @PracticeID
--		AND ComparePeriodType = @ComparePeriodType
--	
--	CREATE TABLE #ki_table(
--		ID int PRIMARY KEY,
--		Procedures int,
--		Charges money,
--		Adjustments money,
--		Receipts money,
--		Refunds money,
--		ARBalance money,
--		DaysInAR decimal(10,2),
--		DaysRevenueOutstanding decimal(10,2),
--		DaysToSubmission decimal(10,2),
--		DaysToBill decimal(10,2)
--	)
--
--	INSERT #ki_table (
--		ID,
--		Procedures,
--		Charges,
--		Adjustments,
--		Receipts,
--		Refunds,
--		ARBalance,
--		DaysInAR,
--		DaysRevenueOutstanding,
--		DaysToSubmission,
--		DaysToBill
--	)
--	EXECUTE dbo.DashboardDataProvider_GetKeyIndicators @PracticeID, @Current_BeginDate, @Current_EndDate
--
--	INSERT dbo.DashboardKeyIndicatorVolatile(
--		PracticeID, 
--		ComparePeriodType
--	)
--	VALUES(
--		@PracticeID, 
--		@ComparePeriodType
--	)
--
--	UPDATE V
--		SET Procedures = U.Procedures,
--			Charges = U.Charges,
--			Adjustments = U.Adjustments,
--			Receipts = U.Receipts,
--			Refunds = U.Refunds,
--			ARBalance = U.ARBalance,
--			DaysInAR = U.DaysInAR,
--			DaysRevenueOutstanding = U.DaysRevenueOutstanding,
--			DaysToSubmission = U.DaysToSubmission,
--			DaysToBill = U.DaysToBill
--		FROM #ki_table U
--			CROSS JOIN dbo.DashboardKeyIndicatorVolatile V
--		WHERE V.PracticeID = @PracticeID
--			AND V.ComparePeriodType = @ComparePeriodType
--
--	--Clear the TABLE and then get the prior values
--	DELETE #ki_table
--
--	INSERT #ki_table (
--		ID,
--		Procedures,
--		Charges,
--		Adjustments,
--		Receipts,
--		Refunds,
--		ARBalance,
--		DaysInAR,
--		DaysRevenueOutstanding,
--		DaysToSubmission,
--		DaysToBill
--	)
--	EXECUTE dbo.DashboardDataProvider_GetKeyIndicators @PracticeID, @Prior_BeginDate, @Prior_EndDate
--	
--	UPDATE V
--		SET PercentOfProcedures = 	CASE WHEN U.Procedures > 0 THEN
--										CASE WHEN (cast(V.Procedures as decimal) - cast(U.Procedures as decimal)) / cast(U.Procedures as decimal) > @PercentThreshold THEN @PercentThresholdErrorValue
--										ELSE (cast(V.Procedures as decimal) - cast(U.Procedures as decimal)) / cast(U.Procedures as decimal)
--										END
--									ELSE
--										0
--									END,
--			PercentOfCharges = 		CASE WHEN U.Charges > 0.0 THEN
--										CASE WHEN (V.Charges - U.Charges) / U.Charges > @PercentThreshold THEN @PercentThresholdErrorValue
--										ELSE (V.Charges - U.Charges) / U.Charges
--										END
--									ELSE
--										0
--									END,
--			PercentOfAdjustments = CASE WHEN U.Adjustments > 0.0001 THEN
--										CASE WHEN (V.Adjustments - U.Adjustments) / U.Adjustments > @PercentThreshold THEN @PercentThresholdErrorValue
--										ELSE (V.Adjustments - U.Adjustments) / U.Adjustments
--										END
--									ELSE
--										0
--									END,
--			PercentOfReceipts = 	CASE WHEN U.Receipts > 0.0001 THEN
--										CASE WHEN (V.Receipts - U.Receipts) / U.Receipts > @PercentThreshold THEN @PercentThresholdErrorValue
--										ELSE (V.Receipts - U.Receipts) / U.Receipts
--										END
--									ELSE
--										0
--									END,
--			PercentOfRefunds = 		CASE WHEN U.Refunds > 0.0001 THEN
--										CASE WHEN (V.Refunds - U.Refunds) / U.Refunds > @PercentThreshold THEN @PercentThresholdErrorValue
--										ELSE (V.Refunds - U.Refunds) / U.Refunds
--										END
--									ELSE
--										0
--									END,
--			PercentOfARBalance = 	CASE WHEN U.ARBalance > 0.0001 THEN
--										CASE WHEN (V.ARBalance - U.ARBalance) / U.ARBalance > @PercentThreshold THEN @PercentThresholdErrorValue
--										ELSE (V.ARBalance - U.ARBalance) / U.ARBalance
--										END
--									ELSE
--										0
--									END,
--			PercentOfDaysInAR = 	CASE WHEN U.DaysInAR > 0 THEN
--										CASE WHEN (V.DaysInAR - U.DaysInAR) / U.DaysInAR > @PercentThreshold THEN @PercentThresholdErrorValue
--										ELSE (V.DaysInAR - U.DaysInAR) / U.DaysInAR
--										END
--									ELSE
--										0
--									END,
--			PercentOfDaysRevenueOutstanding = CASE WHEN U.DaysRevenueOutstanding > 0 THEN
--										CASE WHEN (V.DaysRevenueOutstanding - U.DaysRevenueOutstanding) / U.DaysRevenueOutstanding > @PercentThreshold THEN @PercentThresholdErrorValue
--										ELSE (V.DaysRevenueOutstanding - U.DaysRevenueOutstanding) / U.DaysRevenueOutstanding
--										END
--									ELSE
--										0
--									END,
--			PercentOfDaysToSubmission = CASE WHEN U.DaysToSubmission > 0 THEN
--										CASE WHEN (V.DaysToSubmission - U.DaysToSubmission) / U.DaysToSubmission > @PercentThreshold THEN @PercentThresholdErrorValue
--										ELSE (V.DaysToSubmission - U.DaysToSubmission) / U.DaysToSubmission
--										END
--									ELSE
--										0
--									END,
--			PercentOfDaysToBill = 	CASE WHEN U.DaysToBill > 0 THEN
--										CASE WHEN (V.DaysToBill - U.DaysToBill)/ U.DaysToBill > @PercentThreshold THEN @PercentThresholdErrorValue
--										ELSE (V.DaysToBill - U.DaysToBill)/ U.DaysToBill
--										END
--									ELSE
--										0
--									END
--		FROM #ki_table U
--			CROSS JOIN dbo.DashboardKeyIndicatorVolatile V
--		WHERE V.PracticeID = @PracticeID
--			AND V.ComparePeriodType = @ComparePeriodType
--/*
--		SELECT *
--		FROM #ki_table U
--			CROSS JOIN dbo.DashboardKeyIndicatorVolatile V
--		WHERE V.PracticeID = @PracticeID
--			AND V.ComparePeriodType = @ComparePeriodType
--*/	
--	DROP TABLE #ki_table
--	
--	RETURN
--END
