


CREATE PROCEDURE [dbo].[ReportdataProvider_Beta_EssentialBilling_Payment_Stats]
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@PreviousBeginDate DATETIME ,
	@PreviousEndDate DATETIME ,
	@PracticeID INT

AS

-----DEBUG-------
--DECLARE	
--	@BeginDate DATETIME,
--	@EndDate DATETIME,
--	@PreviousBeginDate DATETIME ,
--	@PreviousEndDate DATETIME ,
--	@PracticeID INT

--SELECT  @BeginDate = '9/1/2014' ,
--		@EndDate = '9/20/2014' ,
--		@PreviousBeginDate = '8/1/2014' ,
--		@PreviousEndDate = '8/20/2014'  ,
--		@PracticeID = 3 


DECLARE @EndOfDayEndDate DATETIME ,
		@EndOfDayPreviousEndDate DATETIME,
		@PreviousPayments MONEY ,
		@Payments Money ,
		@PaymentsAverage MONEY,
		@PaymentsTotal Money,
		@PaymentsHighDate DATETIME,
		@MaxPayments Money 


CREATE TABLE #Payments
	(Payments MONEY,  [Date] DATETIME)
SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))
SET @EndOfDayPreviousEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@PreviousEndDate)))


INSERT INTO #Payments
          ( Payments,  Date )
SELECT SUM(P.PaymentAmount) , P.PostingDate
FROM    dbo.Payment AS P
WHERE  P.PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
	AND P.PracticeID = @PracticeID
	GROUP BY P.PostingDate	


SET @PaymentsAverage = (SELECT SUM(Payments)/COUNT(Payments) FROM #Payments )
SET @PaymentsTotal = (SELECT SUM(Payments) FROM #Payments)
SET @PreviousPayments =  (SELECT SUM(P.PaymentAmount) FROM dbo.Payment AS P  
							WHERE P.PostingDate BETWEEN @PreviousBeginDate AND @EndOfDayPreviousEndDate
								AND P.PracticeID = @PracticeID )             
SET @PaymentsHighDate = (SELECT Date FROM #Payments WHERE Payments = (SELECT MAX(Payments) FROM #Payments))
SET @MaxPayments = (SELECT MAX(Payments) FROM #Payments)



SELECT  @PaymentsTotal AS 'Total', @PaymentsAverage AS 'Average',  @PreviousPayments AS 'Previous Results ',
		@MaxPayments AS 'High', @PaymentsHighDate AS 'High Date'


DROP TABLE #Payments