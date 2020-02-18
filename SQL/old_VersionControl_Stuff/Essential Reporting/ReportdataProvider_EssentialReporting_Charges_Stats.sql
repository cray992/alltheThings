USE superbill_22109_dev
GO

DECLARE
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@PreviousBeginDate DATETIME ,
	@PreviousEndDate DATETIME ,
	@PracticeID INT,
	@ProviderID INT=NULL


----DEBUG----
-- DECLARE
--	@BeginDate DATETIME,
--	@EndDate DATETIME,
--	@PreviousBeginDate DATETIME ,
--	@PreviousEndDate DATETIME ,
--	@PracticeID INT
	

--SELECT  @BeginDate = '6/1/2014' ,
--        @EndDate = '7/15/2014' ,
--		@PreviousBeginDate ='5/1/2014' ,
--		@PreviousEndDate = '6/15/2014' ,
--		@PracticeID =3 ,
--		@ProviderId=20



DECLARE @EndOfDayEndDate DATETIME,
		@EndOfDayPreviousEndDate DATETIME,
		@PreviousCharges MONEY ,
		@ChargesAverage MONEY,
		@ChargesTotal Money,
		@ChargesHighDate DATETIME,
		@MaxCharges Money 
  

SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))
SET @EndOfDayPreviousEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@PreviousEndDate)))
CREATE TABLE #Charges (Charges MONEY,  [Date] DATETIME)

--Charges
INSERT INTO #Charges
        ( Charges, Date )
SELECT SUM(ca.Amount ) , 
		Ca.PostingDate
FROM    dbo.ClaimAccounting AS CA
WHERE   ca.ClaimTransactionTypeCode ='CST'
	AND ca.PostingDate BETWEEN @beginDate AND @EndOfDayEndDate
	AND ca.PracticeID = @PracticeID
	AND ca.ProviderID=isnull(@ProviderID, ca.ProviderID)
	GROUP BY CA.PostingDate

SET @ChargesAverage = (SELECT SUM(Charges)/COUNT(Charges) FROM #Charges)
SET @ChargesTotal = (SELECT SUM(Charges) FROM #Charges)
SET @PreviousCharges =  (SELECT SUM(CASE WHEN ClaimTransactionTypecode='CST' THEN ca.Amount END) 
							FROM    dbo.ClaimAccounting AS CA WHERE ca.ClaimTransactionTypeCode = 'CST'
								AND ca.PostingDate BETWEEN 	@PreviousBeginDate AND @EndOfDayPreviousEndDate 
								AND ca.PracticeID = @PracticeID
								AND ca.ProviderID=ISNULL(@ProviderID,ca.ProviderId)		)                   
SET @ChargesHighDate = (SELECT Date FROM #Charges WHERE Charges = (SELECT MAX(Charges) FROM #Charges))
SET @MaxCharges = (SELECT MAX(Charges) FROM #Charges)



SELECT  @ChargesTotal AS 'Total', @ChargesAverage AS 'Average',  @PreviousCharges AS 'Previous Charges',
		@MaxCharges AS 'High', @ChargesHighDate AS 'High Date'



DROP TABLE   #Charges
