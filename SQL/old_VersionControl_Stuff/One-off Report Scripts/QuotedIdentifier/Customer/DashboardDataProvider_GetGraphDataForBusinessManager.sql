SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardDataProvider_GetGraphDataForBusinessManager]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DashboardDataProvider_GetGraphDataForBusinessManager]
GO


CREATE PROCEDURE dbo.DashboardDataProvider_GetGraphDataForBusinessManager
	@PracticeID int = 40

WITH RECOMPILE
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @EndDate datetime
	SET @EndDate = GETDATE()
	
	SET @EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))
	
	CREATE TABLE #AR (ClaimID INT, ARAmount MONEY)
	INSERT INTO #AR(ClaimID, ARAmount)
	SELECT ClaimID, SUM(ARAmount)
	FROM ClaimAccounting
	WHERE PracticeID=@PracticeID AND Status=0 AND PostingDate<=@EndDate
	GROUP BY ClaimID
	HAVING SUM(ARAmount)<>0
	
	--Get Last Billed Info
	CREATE TABLE #BLLMax (ClaimID INT, ClaimTransactionID INT)
	INSERT INTO #BLLMax(ClaimID, ClaimTransactionID)
	SELECT CAB.ClaimID, MAX(ClaimTransactionID) ClaimTransactionID
	FROM ClaimAccounting_Billings CAB INNER JOIN #AR AR ON CAB.ClaimID=AR.ClaimID
	WHERE PracticeID=@PracticeID AND Status=0 AND PostingDate<=@EndDate 
	GROUP BY CAB.ClaimID
	
	CREATE TABLE #BLL(ClaimID INT, PostingDate DATETIME)
	INSERT #BLL(ClaimID, PostingDate)
	SELECT CAB.ClaimID, CAB.PostingDate
	FROM ClaimAccounting_Billings CAB INNER JOIN #BLLMax BM ON CAB.ClaimTransactionID=BM.ClaimTransactionID
	WHERE PracticeID=@PracticeID AND Status=0 AND PostingDate<=@EndDate
	
	CREATE TABLE #FinalCalc(CurrentBalance MONEY, Age31_60 MONEY, Age61_90 MONEY, Age91_120 MONEY, AgeOver120 MONEY)
	INSERT INTO #FinalCalc(CurrentBalance, Age31_60, Age61_90, Age91_120, AgeOver120)
	SELECT 
	SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 0 AND 30 THEN ARAmount ELSE 0 END) CurrentBalance,
	SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 31 AND 60 THEN ARAmount ELSE 0 END) Age31_60,
	SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 61 AND 90 THEN ARAmount ELSE 0 END) Age61_90,
	SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) BETWEEN 91 AND 120 THEN ARAmount ELSE 0 END) Age91_120,
	SUM(CASE WHEN (DATEDIFF(D, BLL.PostingDate, @EndDate)) >=120 THEN ARAmount ELSE 0 END) AgeOver120
	FROM #AR AR INNER JOIN #BLL BLL ON AR.ClaimID=BLL.ClaimID

	DECLARE @UpdateDate DATETIME
	SET @UpdateDate=GETDATE()

	SELECT @PracticeID PracticeID, 1 ID, ISNULL(CurrentBalance,0)/1000.00 Amount, '<30' DaysInARText, @UpdateDate CreatedDate
	FROM #FinalCalc
	UNION	
	SELECT @PracticeID PracticeID, 2 ID, ISNULL(Age31_60,0)/1000.00 Amount, '30-60' DaysInARText, @UpdateDate CreatedDate
	FROM #FinalCalc
	UNION
	SELECT @PracticeID PracticeID, 3 ID, ISNULL(Age61_90,0)/1000.00 Amount, '61-90' DaysInARText, @UpdateDate CreatedDate
	FROM #FinalCalc
	UNION
	SELECT @PracticeID PracticeID, 4 ID, ISNULL(Age91_120,0)/1000.00 Amount, '91-120' DaysInARText, @UpdateDate CreatedDate
	FROM #FinalCalc
	UNION
	SELECT @PracticeID PracticeID, 5 ID, ISNULL(AgeOver120,0)/1000.00 Amount, '120+' DaysInARText, @UpdateDate CreatedDate
	FROM #FinalCalc

	DROP TABLE #AR
	DROP TABLE #BLL
	DROP TABLE #BLLMax
	DROP TABLE #FinalCalc

	RETURN
END
