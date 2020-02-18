
CREATE PROCEDURE [dbo].[ReportdataProvider_Beta_EssentialBilling_Adjustments_Stats]
	@BeginDate DATETIME ,
    @EndDate DATETIME, 
	@PreviousBeginDate DATETIME ,
	@PreviousEndDate DATETIME ,  
    @PracticeID INT

AS
------DEBUG------
-- DECLARE
--	@BeginDate DATETIME,
--	@EndDate DATETIME,
--	@PracticeID INT,
--	@PreviousBeginDate DATETIME ,
--	@PreviousEndDate DATETIME 

--SELECT  @BeginDate = '7/1/2014' ,
--        @EndDate = '7/30/2014' ,
--		@PracticeID =3 ,
--		@PreviousBeginDate ='6/1/2014' ,
--		@PreviousEndDate = '6/30/2014' 

	
DECLARE @EndOfDayEndDate DATETIME,
		@EndOfDayPreviousEndDate DATETIME,
		@PreviousAdjustments MONEY ,
		@AdjustmentsAverage MONEY,
		@AdjustmentsTotal Money,
		@AdjustmentsHighDate DATETIME,
		@MaxAdjustments MONEY,
		@ProviderID INT=NULL 
		
  
 CREATE TABLE #Adjustments
	(Adjustments MONEY,  InsCoID INT, InsName VARCHAR(MAX),  [Date] DATETIME)       
SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))
SET @EndOfDayPreviousEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@PreviousEndDate)))


--Adjustments
INSERT INTO #Adjustments
        ( Adjustments, Date )
SELECT SUM(CASE WHEN ClaimTransactionTypecode='ADJ' THEN ca.Amount END) AS Adjustments, 
		Ca.PostingDate
FROM    dbo.ClaimAccounting AS CA
WHERE   ca.ClaimTransactionTypeCode =  'ADJ'
	AND ca.PostingDate BETWEEN @beginDate AND @EndOfDayEndDate
	AND ca.PracticeID = @PracticeID
	AND ca.ProviderId=Isnull(@ProviderID, ca.Providerid)
	GROUP BY CA.PostingDate
	


SET @AdjustmentsAverage = (SELECT SUM(Adjustments)/COUNT(Adjustments) FROM #Adjustments)
SET @AdjustmentsTotal = (SELECT SUM(Adjustments) FROM #Adjustments)
SET @PreviousAdjustments =  (SELECT SUM(CASE WHEN ClaimTransactionTypecode='ADJ' THEN ca.Amount END) 
							FROM dbo.ClaimAccounting AS CA WHERE ca.ClaimTransactionTypeCode = 'ADJ'
								AND ca.PostingDate BETWEEN 	@PreviousBeginDate AND @EndOfDayPreviousEndDate 
								AND ca.PracticeID = @PracticeID
								AND ca.ProviderId=Isnull(@ProviderID, ca.Providerid))                   
SET @AdjustmentsHighDate = (SELECT Date FROM #Adjustments WHERE Adjustments = (SELECT MAX(Adjustments) FROM #Adjustments))
SET @MaxAdjustments = (SELECT MAX(Adjustments) FROM #Adjustments)


SELECT  @AdjustmentsTotal AS 'Total', @AdjustmentsAverage AS 'Average',  @PreviousAdjustments AS 'Previous Adjustments ',
		@MaxAdjustments AS 'High', @AdjustmentsHighDate AS 'High Date'
 

DROP TABLE  #Adjustments