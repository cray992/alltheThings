SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DashboardDataProvider_GetGraphDataForMedicalOffice]') 
	and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DashboardDataProvider_GetGraphDataForMedicalOffice]
GO


CREATE PROCEDURE dbo.DashboardDataProvider_GetGraphDataForMedicalOffice
	@PracticeID int = 34
AS
BEGIN
	SET NOCOUNT ON
	--Select the type of payer for each section of the report
	DECLARE @EndDate datetime
	SET @EndDate = GETDATE()
	
	DECLARE @Current_BeginDate datetime 
	DECLARE @Current_EndDate datetime
	DECLARE @Prior_BeginDate datetime
	DECLARE @Prior_EndDate datetime
	DECLARE @CurrentMonth int
	DECLARE @QuarterBeginMonth int
	
	DECLARE @receipts TABLE 
	(
		ID int PRIMARY KEY,
		Amount int default (0),
		Period varchar(20)
	)

	INSERT @receipts(ID, Period)
	VALUES(1, 'month to date')
	
	INSERT @receipts(ID, Period)
	VALUES(2, 'last month')
	
	INSERT @receipts(ID, Period)
	VALUES(3, 'quarter to date')
	
	INSERT @receipts(ID, Period)
	VALUES(4, 'year to date')
	
	SET @Current_EndDate = DATEADD(s, -1, DATEADD(d,1,dbo.fn_DateOnly(@EndDate)))
	SET @Current_BeginDate = CAST(MONTH(@Current_EndDate) AS varchar(2)) + '/1/' + CAST(YEAR(@Current_EndDate) AS varchar(4))

	SET @CurrentMonth = MONTH(@Current_EndDate)

	DECLARE @RetrievalBeginDate DATETIME

	IF @CurrentMonth=1
		SET @RetrievalBeginDate=DATEADD(M,-1,@Current_BeginDate)
	ELSE
		SET @RetrievalBeginDate=CAST('1-1-'+CAST(DATEPART(YYYY,@Current_BeginDate) AS VARCHAR(4)) AS DATETIME)

	CREATE TABLE #CAPayments(PostingDate DATETIME, Amount MONEY)
	INSERT INTO #CAPayments(PostingDate, Amount)
	SELECT P.PostingDate, SUM(Amount) Amount
	FROM ClaimAccounting CA 
		INNER JOIN PaymentClaimTransaction PCT
			ON CA.PracticeID = PCT.PracticeID
			AND CA.ClaimTransactionID = PCT.ClaimTransactionID
		INNER JOIN Payment P 
			ON PCT.PracticeID = P.PracticeID
			AND PCT.PaymentID = P.PaymentID
	WHERE CA.PracticeID = @PracticeID 
		AND P.PostingDate BETWEEN @RetrievalBeginDate AND @Current_EndDate 
		AND ClaimTransactionTypeCode='PAY'
	GROUP BY P.PostingDate

	--Month to date	
	UPDATE @receipts 
		SET Amount = 	ISNULL((SELECT SUM(Amount) / 1000.0
						FROM #CAPayments
						WHERE PostingDate BETWEEN @Current_BeginDate AND @Current_EndDate
						),0)
	WHERE ID = 1
	
	--Last month
	SET @Prior_BeginDate = DATEADD(m,-1,@Current_BeginDate)
	SET @Prior_EndDate = DATEADD(ms,-10,DATEADD(m,1,@Prior_BeginDate))

	UPDATE @receipts 
		SET Amount = 	ISNULL((SELECT SUM(Amount) / 1000.0
						FROM #CAPayments
						WHERE PostingDate BETWEEN @Prior_BeginDate AND @Prior_EndDate
						),0)
	WHERE ID = 2
	
	--Quarter to date		
	IF @CurrentMonth IN (1,2,3)
		SET @QuarterBeginMonth = 1
	ELSE IF @CurrentMonth IN (4,5,6)
		SET @QuarterBeginMonth = 4
	ELSE IF @CurrentMonth IN (7,8,9)
		SET @QuarterBeginMonth = 7
	ELSE
		SET @QuarterBeginMonth = 10	
	
	SET @Current_BeginDate = CAST(@QuarterBeginMonth AS varchar(2)) + '/1/' + CAST(YEAR(@Current_EndDate) AS varchar(4))

	UPDATE @receipts 
		SET Amount = 	ISNULL((SELECT SUM(Amount) / 1000.0
						FROM #CAPayments
						WHERE PostingDate BETWEEN @Current_BeginDate AND @Current_EndDate
						),0)
	WHERE ID = 3
		
	--Year to date		
	SET @Current_BeginDate = '1/1/' + CAST(YEAR(@Current_EndDate) AS varchar(4))
	
	UPDATE @receipts 
		SET Amount = 	ISNULL((SELECT SUM(Amount) / 1000.0
						FROM #CAPayments
						WHERE PostingDate BETWEEN @Current_BeginDate AND @Current_EndDate
						),0)
	WHERE ID = 4

	SELECT *
	FROM @receipts
	ORDER BY ID
	
	RETURN
END
