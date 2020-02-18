

 DECLARE
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@BucketType VARCHAR(10)= 'ww', --dd-day, ww-Week, mm-Month, yy-year
	@PracticeID INT,
	@ProviderID INT=NULL,
	@PreviousBeginDate DATETIME ,
	@PreviousEndDate DATETIME 

--SELECT  @BeginDate = '1/1/2015' ,
--        @EndDate = '1/30/2015' ,
--		@PracticeID =3 ,
--		@PreviousBeginDate ='12/1/2014' ,
--		@PreviousEndDate = '12/31/2014' ,
--		@ProviderID=null

	
DECLARE @EndOfDayEndDate DATETIME,
		@EndOfDayPreviousEndDate DATETIME,
		@ReceiptsRefund MONEY ,
		@CurrentDate DATETIME ,
        @DaysInCurrMonth INT ,
		@DaysInCurrYear INT ,
		@Adjustments Money ,
		@CurrBucket INT
		
  
        
CREATE Table  #BucketTable ( BucketID INT IDENTITY, BeginPeriod DateTime, EndPeriod DateTime)      
CREATE TABLE #Adjustments
	(Adjustments MONEY,  InsCoID INT, InsName VARCHAR(MAX),  [Date] DATETIME)
CREATE TABLE #FinalData
	(BucketID INT IDENTITY, BeginPeriod DATETIME, EndPeriod DATETIME, Adjustments MONEY)
	
SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))
SET @CurrentDate = CAST(@BeginDate AS DATE)


--Build the buckettable with buckets of either days, weeks, months or years. It will have the start and end of each period
WHILE (@CurrentDate <= @EndOfDayEndDate)
BEGIN
		--Get the Current Day of the Month and Current Day of Year 
		SET @DaysInCurrMonth = (Select MAX(Day_of_Month) FROM dbo.Calendar 
						WHERE YEAR = (SELECT year FROM dbo.Calendar WHERE date = @CurrentDate)
						AND Month = (SELECT month FROM dbo.calendar WHERE date = @CurrentDate))
		SET @DaysInCurrYear = (Select MAX(Day_of_Year) FROM dbo.Calendar 
						WHERE YEAR = (SELECT year FROM dbo.Calendar WHERE date = @CurrentDate))
		
		INSERT INTO #BucketTable 
		        ( BeginPeriod , EndPeriod)
		SELECT  @CurrentDate, 
				CASE @BucketType WHEN 'dd' THEN --This returns the 11:59 of current day
											CASE WHEN DATEADD(s, -1, DATEADD(d, 1, @CurrentDate)) > @EndofDayEndDate  
												THEN @EndofDayEndDate ELSE DATEADD(s, -1, DATEADD(d, 1, @CurrentDate)) END              
								 WHEN 'ww' THEN -- This returns saturday night of the current week
											CASE WHEN DATEADD(s, -1, DATEADD(d, 1, DATEADD(d, (8 - C.day_of_Week ), @CurrentDate))) > @EndOfDayEndDate 
												THEN @EndOfDayEndDate ELSE DATEADD(s, -1, DATEADD(d, 1, DATEADD(d, (8 - C.day_of_Week ), @CurrentDate))) END
								 WHEN 'mm' THEN -- This returns the last day of the month
											CASE WHEN DATEADD(s, -1, DATEADD(d, 1, DATEADD(d, (@DaysInCurrMonth - C.Day_Of_Month) , @CurrentDate))) > @EndOfDayEndDate
												THEN @EndOfDayEndDate ELSE DATEADD(s, -1, DATEADD(d, 1, DATEADD(d, (@DaysInCurrMonth - C.Day_Of_Month) , @CurrentDate))) END
								 WHEN 'yy' THEN --This will return the last day of the year
											CASE WHEN DATEADD(s, -1, DATEADD(d, 1, DATEADD(d, (@DaysInCurrYear - C.Day_Of_Year ), @CurrentDate))) > @EndOfDayEndDate
												THEN @EndOfDayEndDate ELSE DATEADD(s, -1, DATEADD(d, 1, DATEADD(d, (@DaysInCurrYear - C.Day_Of_Year ), @CurrentDate))) END											
					END
				FROM dbo.Calendar AS C WHERE C.Date = @CurrentDate
		--Change the current Date to the next day after the EndPeriod
		SET @CurrentDate = (SELECT CASE @BucketType WHEN 'dd' THEN DATEADD(d, 1, @CurrentDate) 
													WHEN 'ww' THEN DATEADD(d, 1, DATEADD(d, (8 - C.day_of_Week ), @CurrentDate))
													WHEN 'mm' THEN DATEADD(d, 1, DATEADD(d, (@DaysInCurrMonth - C.Day_Of_Month) , @CurrentDate))
													WHEN 'yy' THEN DATEADD(d, 1, DATEADD(d, (@DaysInCurrYear - C.Day_Of_Year ), @CurrentDate)) END
							 FROM dbo.Calendar AS C WHERE C.Date = @CurrentDate)                                         

END

--populate finaldata with all insurancecompanies
INSERT INTO #FinalData
	( BeginPeriod, EndPeriod )
SELECT DISTINCT BeginPeriod, EndPeriod 
FROM #BucketTable 

--Adjustments
INSERT INTO #Adjustments
        ( Adjustments, Date )
SELECT SUM(CASE WHEN ClaimTransactionTypecode='ADJ' THEN ca.Amount END) AS Adjustments, 
		Ca.PostingDate
FROM    dbo.ClaimAccounting AS CA
WHERE   ca.ClaimTransactionTypeCode =  'ADJ'
	AND ca.PostingDate BETWEEN @beginDate AND @EndOfDayEndDate
	AND ca.PracticeID = @PracticeID
	AND ca.ProviderID=Isnull(@ProviderID,ca.Providerid)-- Filter by Provider
	GROUP BY CA.PostingDate
	


SET @CurrBucket = 1
--Iterates Sums up the Adjustments and puts them in corresponding buckets based on dates
WHILE @CurrBucket <= (SELECT MAX(BucketID) FROM #FinalData)
BEGIN
	SET @Adjustments = (SELECT SUM(A.Adjustments) 
								FROM #Adjustments A
								INNER JOIN #FinalData AS FD ON FD.BucketID = @CurrBucket
								WHERE A.Date BETWEEN FD.BeginPeriod AND FD.EndPeriod )								
	UPDATE #FinalData 
	SET Adjustments = ISNULL(@Adjustments,0)
		WHERE BucketID = @CurrBucket

	SET @CurrBucket = @CurrBucket + 1

END


SELECT  BeginPeriod, EndPeriod, Adjustments FROM #FinalData --WHERE Adjustments <> '0.00'


DROP TABLE  #FinalData, #BucketTable, #Adjustments
