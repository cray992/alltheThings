USE superbill_22109_dev
Go

----DEBUG----
 DECLARE
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@BucketType VARCHAR(10)= 'ww', --dd-day, ww-Week, mm-Month, yy-year
	@PracticeID INT,
	@PreviousBeginDate DATETIME ,
	@PreviousEndDate DATETIME,
	@ProviderId INT=Null 

--SELECT  @BeginDate = '1/1/2015' ,
--        @EndDate = '1/15/2015' ,
--		@PracticeID =3 ,
--		@PreviousBeginDate ='12/1/2014' ,
--		@PreviousEndDate = '12/15/2014' ,
--		@ProviderID=18
	
DECLARE @EndOfDayEndDate DATETIME,
		@EndOfDayPreviousEndDate DATETIME,
		@CurrentDate DATETIME ,
        @DaysInCurrMonth INT ,
		@DaysInCurrYear INT ,
		@Charges Money ,
		@CurrBucket INT
  
        
CREATE Table  #BucketTable ( BucketID INT IDENTITY, BeginPeriod DateTime, EndPeriod DateTime)      
CREATE TABLE #Charges
	(Charges MONEY,  [Date] DATETIME)
CREATE TABLE #FinalData
	(BucketID INT IDENTITY, BeginPeriod DATETIME, EndPeriod DATETIME, Charges MONEY)
SET @EndOfDayEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@EndDate)))
SET @EndOfDayPreviousEndDate = DATEADD(S, -1, DATEADD(D, 1, dbo.fn_DateOnly(@PreviousEndDate)))
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
SELECT BeginPeriod, EndPeriod 
FROM #BucketTable

--Charges
INSERT INTO #Charges
        ( Charges, Date )
SELECT SUM(ca.Amount ) , 
		Ca.PostingDate
FROM    dbo.ClaimAccounting AS CA
WHERE   ca.ClaimTransactionTypeCode ='CST'
	AND ca.PostingDate BETWEEN @beginDate AND @EndOfDayEndDate
	AND ca.PracticeID = @PracticeID
	AND ca.providerid=isnull(@ProviderId,ca.Providerid)
	GROUP BY CA.PostingDate


SET @CurrBucket = 1
--Iterates though the charges and groups them by date into the final data set
WHILE @CurrBucket <= (SELECT MAX(BucketID) FROM #FinalData)
BEGIN
	SET @Charges = (SELECT SUM(C.Charges) 
								FROM #Charges C
								INNER JOIN  #FinalData AS FD ON  FD.BucketID = @CurrBucket
								WHERE  C.Date BETWEEN FD.BeginPeriod AND FD.EndPeriod)						
	UPDATE #FinalData 
	SET Charges = ISNULL(@Charges,0)
		WHERE BucketID = @CurrBucket

	SET @CurrBucket = @CurrBucket + 1

END

SELECT BeginPeriod, EndPeriod, Charges FROM #FinalData


DROP TABLE  #FinalData, #BucketTable, #Charges

