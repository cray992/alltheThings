
------DEBUG----
 DECLARE
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@BucketType VARCHAR(10)= 'ww', --dd-day, ww-Week, mm-Month, yy-year
	@PracticeID INT,
	@NumberOfIns INT,
	@ProviderId INT=NULL,
	@PreviousBeginDate DATETIME,
	@PreviousEndDate DATETIME


SELECT  @BeginDate = '4/1/2015' ,
        @EndDate = '6/30/2015' ,
		@PracticeID = 3,
		@PreviousBeginDate ='4/1/2014' ,
		@PreviousEndDate = '6/30/2014' ,
		@NumberOfIns = 5,
		@ProviderId =NULL

	
DECLARE @EndOfDayEndDate DATETIME,
		@CurrentDate DATETIME ,
        @DaysInCurrMonth INT ,
		@DaysInCurrYear INT ,
		@Encounters INT ,
		@NumOfColumns INT ,
		@CurrBucket INT
  
        
CREATE Table  #BucketTable ( BucketID INT IDENTITY, BeginPeriod DateTime, EndPeriod DateTime)      
CREATE TABLE #InsuranceCompanies
	(INSID INT IDENTITY, InsCoID INT , CompanyName VARCHAR(MAX))
CREATE TABLE #Encounters 
	( Encounters INT, InsuranceName VARCHAR(MAX), InsCoID INT, [Date] DATETIME)
CREATE TABLE #FinalData
	(BucketID INT IDENTITY, InsCoID INT, InsName VARCHAR(MAX), BeginPeriod DATETIME, EndPeriod DATETIME, 
	Result INT, [Rank] INT, [GROUP] Varchar(3)) 
CREATE TABLE  #TempFinal
	(InsCoId INT , InsName VARCHAR(MAX), BeginPeriod DATETIME , EndPeriod DATETIME, Result INT , 
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
INSERT INTO #InsuranceCompanies (InsCoID, CompanyName) 
SELECT DISTINCT IC.InsuranceCompanyID, IC.InsuranceCompanyName
FROM dbo.InsuranceCompany AS IC

--Gets only the Encounters that belong to the time periods
INSERT INTO #Encounters
        ( Encounters, InsuranceName, InsCoID,  Date )
SELECT COUNT(E.EncounterID), IC.InsuranceCompanyName , IC.InsuranceCompanyID, E.PostingDate 
		FROM dbo.Encounter AS E
		INNER JOIN dbo.InsurancePolicy AS IP ON E.PatientCaseID = IP.PatientCaseID 
		INNER JOIN dbo.InsuranceCompanyPlan AS ICP ON IP.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
		INNER JOIN dbo.InsuranceCompany AS IC ON ICP.InsuranceCompanyID = IC.InsuranceCompanyID 
		WHERE E.PostingDate BETWEEN @BeginDate AND @EndOfDayEndDate
			AND E.EncounterStatusID = 3 AND E.PracticeID = @PracticeID AND IP.Precedence = 1
			AND e.DoctorID=isnull(@ProviderId, e.doctorid)
		GROUP BY E.PostingDate, IC.InsuranceCompanyName, IC.InsuranceCompanyID
		HAVING COUNT(E.EncounterID) > 0
		

DELETE FROM #InsuranceCompanies WHERE InsCoID NOT IN (SELECT InsCoID FROM #Encounters AS E)

--populate finaldata with all insurancecompanies
INSERT INTO #FinalData
	(InsCoID , InsName, BeginPeriod, EndPeriod )
SELECT DISTINCT InsCoID, CompanyName, BeginPeriod, EndPeriod 
FROM #InsuranceCompanies AS IC
CROSS JOIN #BucketTable AS BT

SET @CurrBucket = 1

--Iterates over Encounters by date and associates them with the corresponding Insurance Company for the dates
WHILE @CurrBucket <= (SELECT MAX(BucketID) FROM #FinalData)
BEGIN
	SET @Encounters = (SELECT SUM(E.Encounters) 
								FROM #Encounters E
								INNER JOIN #FinalData AS FD ON E.InsCoID = FD.InsCoID
								WHERE FD.BucketID = @CurrBucket AND
								E.Date BETWEEN FD.BeginPeriod AND FD.EndPeriod )
								
	UPDATE #FinalData 
	SET Result = ISNULL(@Encounters,0)
		WHERE BucketID = @CurrBucket

	SET @CurrBucket = @CurrBucket + 1

END

----Move over all data and add ranking 
INSERT INTO #TempFinal
(InsCoId, InsName, BeginPeriod, EndPeriod, Result, [Rank], [Group])
SELECT InsCoID, InsName, BeginPeriod, EndPeriod, Result, ROW_NUMBER() OVER (PARTITION BY BeginPeriod ORDER BY Result DESC, InsCoID ),
CASE WHEN (ROW_NUMBER() OVER (PARTITION BY BeginPeriod ORDER BY Result DESC)) < @NumberOfIns THEN 'I'  ELSE 'G' END
FROM #FinalData 

--Delete everything from FinalData so we can put the data back in ordered and sum up Other
DELETE FROM #FinalData

INSERT INTO #FinalData ( InsCoId, InsName, BeginPeriod, EndPeriod, Result, [Rank], [Group])
SELECT InsCoId, InsName, F.BeginPeriod, F.EndPeriod, Result, [Rank], [Group]
FROM #TempFinal AS F
RIGHT JOIN #BucketTable AS BT ON BT.BeginPeriod = F.BeginPeriod
WHERE [Group] = 'I' 

INSERT INTO #FinalData ( InsName, BeginPeriod, EndPeriod, Result, [Rank], [Group])
SELECT DISTINCT 'All Others', F.BeginPeriod, F.EndPeriod, ISNULL(SUM(Result), 0), @NumberOfIns , 'G'
FROM #TempFinal AS F
Right JOIN #BucketTable AS BT ON BT.BeginPeriod = F.BeginPeriod
WHERE [Group] = 'G' 
GROUP BY F.BeginPeriod, F.EndPeriod


SELECT InsCoID, InsName, BeginPeriod, EndPeriod, Result, [Rank]
FROM #FinalData 
WHERE (Result <> 0 OR (Result=0 AND INSNAME='All Others')OR [InsName] = 'All Others' )
ORDER BY BeginPeriod, [Rank]
 

DROP TABLE #InsuranceCompanies, #FinalData, #BucketTable, #Encounters,#TempFinal

