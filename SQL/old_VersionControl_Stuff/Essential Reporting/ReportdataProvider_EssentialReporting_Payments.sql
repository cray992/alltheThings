USE superbill_0028_dev

----DEBUG---
 DECLARE
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@BucketType VARCHAR(10)= 'ww', --dd-day, ww-Week, mm-Month, yy-year
	@PracticeID INT,
	@NumberOfIns int

SELECT  @BeginDate = '4/1/2013' ,
        @EndDate = '6/30/2013' ,
		@PracticeID = 1 ,
		@NumberOfIns =5
	
DECLARE @EndOfDayEndDate DATETIME,
		@CurrentDate DATETIME ,
        @DaysInCurrMonth INT ,
		@DaysInCurrYear INT ,
		@Payments Money ,
		@CurrBucket INT
  

CREATE Table  #BucketTable ( BucketID INT IDENTITY, BeginPeriod DateTime, EndPeriod DateTime)      
CREATE TABLE #InsuranceCompanies
	(INSID INT IDENTITY, InsCoID INT , CompanyName VARCHAR(MAX))
CREATE TABLE #Payments
	(Payments MONEY,  InsCoID INT, InsName VARCHAR(MAX),  [Date] DATETIME)
CREATE TABLE #FinalData
	(BucketID INT IDENTITY, InsCoID INT, InsName VARCHAR(MAX), BeginPeriod DATETIME, EndPeriod DATETIME, 
	Result MONEY, [Rank] INT, [Group] VARCHAR(1))
CREATE TABLE  #TempFinal
	(InsCoId INT , InsName VARCHAR(MAX), BeginPeriod DATETIME , EndPeriod DATETIME, Result MONEY , 
		[Rank] INT , [Group] VARCHAR(1) )
				
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
--Get all InsuranceCompanies 
--INSERT INTO #InsuranceCompanies (InsCoID, CompanyName) 
--SELECT DISTINCT IC.InsuranceCompanyID, IC.InsuranceCompanyName
--FROM dbo.InsuranceCompany AS IC

--Payments  --Grabs all payments and associated Insurance Company
INSERT INTO #Payments
        ( Payments,  InsCoID, InsName, Date )
SELECT SUM(P.PaymentAmount) , 
		IC.InsuranceCompanyID, IC.InsuranceCompanyName, P.PostingDate
FROM dbo.Payment AS P
INNER JOIN dbo.InsuranceCompanyPlan AS ICP ON ICP.InsuranceCompanyPlanID = P.PayerID
INNER JOIN dbo.InsuranceCompany AS IC ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID
WHERE   P.PostingDate BETWEEN @beginDate AND @EndOfDayEndDate
	AND P.PracticeID = @PracticeID
	GROUP BY P.PostingDate, IC.InsuranceCompanyID, IC.InsuranceCompanyName
	
--DELETE FROM #InsuranceCompanies WHERE InsCoID NOT IN (SELECT InsCoID FROM #Payments AS P)

--populate finaldata with all insurancecompanies
--INSERT INTO #FinalData
--	(InsCoID , InsName, BeginPeriod, EndPeriod )
--SELECT DISTINCT InsCoID, CompanyName, BeginPeriod, EndPeriod 
--FROM #InsuranceCompanies AS IC
--INNER JOIN #BucketTable AS BT ON 1 =  1

INSERT INTO #FinalData
( BeginPeriod, EndPeriod, InsCoID, InsName, Result   )
SELECT BeginPeriod, EndPeriod, InsCoId, InsName, Payments
FROM #BucketTable AS BT
LEFT JOIN 
	(SELECT BT.BucketID, SUM(P.Payments) AS Payments, P.InsCoID, P.InsName
	FROM #Payments P 
	JOIN #BucketTable AS BT ON P.Date BETWEEN BT.BeginPeriod AND BT.EndPeriod
	GROUP BY BT.BucketID, P.InsCoId, P.InsName
	) AS X
ON X.BucketID = BT.BucketID

--SET @CurrBucket = 1
----Iterates through all insurance companies by day and puts in Payments
--WHILE @CurrBucket <= (SELECT MAX(BucketID) FROM #FinalData)
--BEGIN
--	SET @Payments = (SELECT SUM(P.Payments) 
--								FROM #Payments P
--								INNER JOIN #FinalData AS FD ON P.InsCoID = FD.InsCoID 
--								WHERE  FD.BucketID = @CurrBucket AND P.Date BETWEEN FD.BeginPeriod AND FD.EndPeriod)

--	UPDATE #FinalData 
--	SET Result = ISNULL(@Payments, 0)
--		WHERE BucketID = @CurrBucket

--	SET @CurrBucket = @CurrBucket + 1

--END

--DELETE FROM #FinalData WHERE Result = '0.00'
--Move over all data and add ranking
INSERT INTO #TempFinal
(InsCoId, InsName, BeginPeriod, EndPeriod, Result, [Rank], [Group])
SELECT InsCoID, InsName, BeginPeriod, EndPeriod, Result, RANK() OVER (PARTITION BY BeginPeriod ORDER BY Result DESC, InsCoID ),
CASE WHEN (RANK() OVER (PARTITION BY BeginPeriod ORDER BY Result DESC)) < @NumberOfIns THEN 'I'  ELSE 'G' END
FROM #FinalData 
--Delete everything from FinalData so we can put the data back in ordered and sum up Other
DELETE FROM #FinalData
--This is inserting individual records that are in the top @NumberOfIns
INSERT INTO #FinalData (InsCoId, InsName, BeginPeriod, EndPeriod, Result, [Rank], [Group])
SELECT InsCoId, InsName, F.BeginPeriod, F.EndPeriod, Result, [Rank], [Group]
FROM #TempFinal AS F
INNER JOIN #BucketTable AS BT ON BT.BeginPeriod = F.BeginPeriod
WHERE [Group] = 'I' 
--This is inserting group of records that are not in the top @NumberOfIns
INSERT INTO #FinalData ( InsName, BeginPeriod, EndPeriod, Result, [Rank], [Group])
SELECT DISTINCT 'Other', F.BeginPeriod, F.EndPeriod, SUM(Result), (@NumberOfIns ) , 'G'
FROM #TempFinal AS F
INNER JOIN #BucketTable AS BT ON BT.BeginPeriod = F.BeginPeriod
WHERE [Group] = 'G' 
GROUP BY F.BeginPeriod, F.EndPeriod


--Only return when there are payments made
SELECT InsCoID, InsName, BeginPeriod, EndPeriod, ISNULL(Result,0)Result, [Rank] 
FROM #FinalData 
--WHERE (Result > '0.00' OR InsName = 'Other' or (result=0 and Insname is null))
ORDER BY BeginPeriod, [Rank]

 

DROP TABLE #InsuranceCompanies, #FinalData, #BucketTable, #Payments, #TempFinal
