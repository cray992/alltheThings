set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[TimeblockDataProvider_GetTimeblockResourcesOverbooked]
	@PracticeID int, 
	@XMLParameters XML
AS
BEGIN

	CREATE TABLE #Resources(Type INT, ResourceID INT)
	INSERT INTO #Resources(Type, ResourceID)
	SELECT Resources.row.value('@AppointmentResourceTypeID','INT') Type,
	Resources.row.value('@ResourceID','INT') ResourceID
	FROM @XMLParameters.nodes('/Timeblock/Resources/Resource') AS Resources(row)

	DECLARE @TimeblockID INT
	DECLARE @StartDate DATETIME
	DECLARE @OGStartDate DATETIME
	DECLARE @EndDate DATETIME
	DECLARE @OGEndDate DATETIME
	DECLARE @AllDay BIT

	DECLARE @TimeblockDetail TABLE(TimeblockID INT, ServiceLocationID INT, StartDate DATETIME,
							 EndDate DATETIME, AllDay BIT)
	INSERT @TimeblockDetail(TimeblockID, ServiceLocationID, StartDate, EndDate, AllDay)
	SELECT TimeblockDetail.row.value('@TimeblockID','INT') TimeblockID,
	TimeblockDetail.row.value('@ServiceLocationID','INT') ServiceLocationID,
	TimeblockDetail.row.value('@StartDate','DATETIME') StartDate,
	TimeblockDetail.row.value('@EndDate','DATETIME') EndDate,
	TimeblockDetail.row.value('@AllDay','BIT') AllDay
	FROM @XMLParameters.nodes('/Timeblock/TimeblockDetail') AS TimeblockDetail(row)

	SELECT @TimeblockID=TimeblockID, @StartDate=CAST(CONVERT(CHAR(10),StartDate,110) AS DATETIME),
	@OGStartDate=StartDate, @EndDate=EndDate,
	@OGEndDate=CASE WHEN @AllDay=1 THEN DATEADD(SS,-1,DATEADD(D,1,CAST(CONVERT(CHAR(10),@StartDate,110) AS DATETIME))) ELSE EndDate END
	FROM @TimeblockDetail

	CREATE TABLE #Recurrence(TimeblockID INT, Type CHAR(1), DailyType CHAR(1), DailyNumDays INT,
	WeeklyNumWeeks INT, WeeklyOnSunday BIT, WeeklyOnMonday BIT, WeeklyOnTuesday BIT, WeeklyOnWednesDay BIT,
	WeeklyOnThursday BIT, WeeklyOnFriday BIT, WeeklyOnSaturday BIT, MonthlyType CHAR(1), 
	MonthlyNumMonths INT, MonthlyDayOfMonth INT, MonthlyWeekTypeOfMonth CHAR(1), 
	MonthlyTypeOfDay CHAR(1), YearlyType CHAR(1), YearlyDayTypeOfMonth CHAR(1),
	YearlyTypeOfDay CHAR(1), YearlyMonth INT, YearlyDayOfMonth INT, RangeType CHAR(1),
	RangeEndOccurrences INT, RangeEndDate DATETIME, StartDate DATETIME, EndDate DATETIME, RecurringStartDate DATETIME, RecurringEndDate DATETIME,
	DKID INT, WK INT, MoID INT)
	INSERT #Recurrence(
	TimeblockID, Type, DailyType, DailyNumDays,
	WeeklyNumWeeks, WeeklyOnSunday, WeeklyOnMonday, WeeklyOnTuesday, WeeklyOnWednesDay,
	WeeklyOnThursday, WeeklyOnFriday, WeeklyOnSaturday, MonthlyType, 
	MonthlyNumMonths, MonthlyDayOfMonth, MonthlyWeekTypeOfMonth, 
	MonthlyTypeOfDay, YearlyType, YearlyDayTypeOfMonth,
	YearlyTypeOfDay, YearlyMonth, YearlyDayOfMonth, RangeType,
	RangeEndOccurrences, RangeEndDate)
	SELECT Recurrence.row.value('@TimeblockID','INT') TimeblockID,
	Recurrence.row.value('@Type','CHAR') Type,
	Recurrence.row.value('@DailyType','CHAR') DailyType,
	Recurrence.row.value('@DailyNumDays','INT') DailyNumDays,
	Recurrence.row.value('@WeeklyNumWeeks','INT') WeeklyNumWeeks,
	Recurrence.row.value('@WeeklyOnSunday','BIT') WeeklyOnSunday,
	Recurrence.row.value('@WeeklyOnMonday','BIT') WeeklyOnMonday,
	Recurrence.row.value('@WeeklyOnTuesday','BIT') WeeklyOnTuesday,
	Recurrence.row.value('@WeeklyOnWednesday','BIT') WeeklyOnWednesday,
	Recurrence.row.value('@WeeklyOnThursday','BIT') WeeklyOnThursday,
	Recurrence.row.value('@WeeklyOnFriday','BIT') WeeklyOnFriday,
	Recurrence.row.value('@WeeklyOnSaturday','BIT') WeeklyOnSaturday,
	Recurrence.row.value('@MonthlyType','CHAR') MonthlyType,
	Recurrence.row.value('@MonthlyNumMonths','INT') MonthlyNumMonths,
	Recurrence.row.value('@MonthlyDayOfMonth','INT') MonthlyDayOfMonth,
	Recurrence.row.value('@MonthlyWeekTypeOfMonth','CHAR') MonthlyWeekTypeOfMonth,
	Recurrence.row.value('@MonthlyTypeOfDay','CHAR') MonthlyTypeOfDay,
	Recurrence.row.value('@YearlyType','CHAR') YearlyType,
	Recurrence.row.value('@YearlyDayTypeOfMonth','CHAR') YearlyDayTypeOfMonth,
	Recurrence.row.value('@YearlyTypeOfDay','CHAR') YearlyTypeOfDay,
	Recurrence.row.value('@YearlyMonth','INT') YearlyMonth,
	Recurrence.row.value('@YearlyDayOfMonth','INT') YearlyDayOfMonth,
	Recurrence.row.value('@RangeType','CHAR') RangeType,
	Recurrence.row.value('@RangeEndOccurrences','INT') RangeEndOccurrences,
	Recurrence.row.value('@RangeEndDate','DATETIME') RangeEndDate
	FROM @XMLParameters.nodes('/Timeblock/RecurrenceDetail') AS Recurrence(row)

	IF NOT EXISTS(SELECT * FROM #Recurrence)
		SET @EndDate=DATEADD(D,1,@EndDate)

	IF EXISTS(SELECT * FROM #Recurrence)
		SET @EndDate=DATEADD(YY,1,@StartDate)

	DECLARE @MinID INT, @MaxID INT, @StartID INT, @EndID INT

	DECLARE @Qry TABLE(MinID INT, MaxID INT, StartID INT, EndID INT)
	INSERT @Qry(MinID, MaxID, StartID, EndID)
	SELECT MIN(MinDKPracticeID) MinID, MAX(MaxDKPracticeID), MIN(DKPracticeID) StartID, MAX(DKPracticeID) EndID
	FROM DateKeyToPractice
	WHERE PracticeID=@PracticeID AND 
	Dt BETWEEN CAST(CONVERT(CHAR(10),@StartDate,110) AS DATETIME) AND CAST(CONVERT(CHAR(10),@EndDate,110) AS DATETIME)

	SELECT @MinID=MinID, @MaxID=MaxID, @StartID=StartID, @EndID=EndID
	FROM @Qry

	CREATE TABLE #t_Timeblock(
		PracticeID INT,
		TimeblockID int,
		StartDate datetime, 
		EndDate datetime, 
		RecurringStartDate datetime,
		RecurringEndDate datetime,
		IsRecurring bit, 
		UniqueID varchar(32)
	)

	CREATE TABLE #checkdates(
		StartDate datetime, 
		EndDate datetime
	)

	CREATE TABLE #t_Timeblock_overbooked(
		TimeblockID int,
		StartDate datetime,
		EndDate datetime
	)

	INSERT INTO #t_Timeblock(
		PracticeID, 
		TimeblockID, 
		StartDate, 
		EndDate, 
		IsRecurring)
	SELECT
		T.PracticeID,
		T.TimeblockID,
		T.StartDate,
		T.EndDate,
		0 IsRecurring
	FROM
		Timeblock T
		INNER JOIN #Resources R ON T.AppointmentResourceTypeID=R.Type AND T.ResourceID=R.ResourceID
	WHERE (T.PracticeID=@PracticeID AND (StartDKPracticeID>=@StartID AND EndDKPracticeID<=@EndID
	OR StartDKPracticeID < @StartID AND EndDKPracticeID BETWEEN @StartID AND @EndID
	OR StartDKPracticeID < @EndID AND EndDKPracticeID > @EndID) 
	OR T.PracticeID=@PracticeID AND StartDKPracticeID<@StartID
	   AND IsRecurring=1 AND RecurrenceStartDate<=@EndDate AND (RangeEndDate >= dateadd(day, -1, @StartDate) OR RangeType = 'N') )		

	DELETE #t_Timeblock WHERE TimeblockID=@TimeblockID

	-- Insert the recurring Timeblocks into our temp table
	CREATE TABLE #Recurrences(TimeblockID INT, StartDate DATETIME, EndDate DATETIME, RecurringStartDate DATETIME, RecurringEndDate DATETIME, Type CHAR(1),
							  DailyNumDays INT, DailyType CHAR(1), WeeklyNumWeeks INT, WeeklyOnSunday BIT,
							  WeeklyOnMonday BIT, WeeklyOnTuesday BIT, WeeklyOnWednesday BIT, WeeklyOnThursday BIT,
							  WeeklyOnFriday BIT, WeeklyOnSaturday BIT, MonthlyType CHAR(1), MonthlyNumMonths INT, MonthlyDayOfMonth INT,
							  MonthlyWeekTypeOfMonth CHAR(1), MonthlyTypeOfDay CHAR(1), YearlyType CHAR(1), YearlyMonth INT,
							  YearlyDayOfMonth INT, YearlyDayTypeOfMonth CHAR(1), YearlyTypeOfDay CHAR(1), DKID INT, WK INT, MoID INT)
	INSERT INTO #Recurrences(TimeblockID, StartDate, EndDate, RecurringStartDate, RecurringEndDate, Type, DailyNumDays, DailyType, WeeklyNumWeeks, WeeklyOnSunday,
							 WeeklyOnMonday, WeeklyOnTuesday, WeeklyOnWednesday, WeeklyOnThursday, WeeklyOnFriday, WeeklyOnSaturday, 
							 MonthlyType, MonthlyNumMonths, MonthlyDayOfMonth, MonthlyWeekTypeOfMonth, MonthlyTypeOfDay, YearlyType, YearlyMonth, YearlyDayOfMonth, 
							 YearlyDayTypeOfMonth, YearlyTypeOfDay)
	SELECT
		t.TimeblockID, 
		t.StartDate,
		t.EndDate,
		CASE WHEN @StartDate > CAST(CONVERT(CHAR(10),t.StartDate,110) AS DATETIME) THEN
						@StartDate
				      	ELSE
						CAST(CONVERT(CHAR(10),t.StartDate,110) AS DATETIME)
				      	END RecurringStartDate,
		CASE WHEN TR.RangeType = 'N' or @EndDate < CAST(CONVERT(CHAR(10),TR.RangeEndDate,110) AS DATETIME) THEN
						dateadd(second, -1, dateadd(Day, 1, @EndDate))
					ELSE
						dateadd(second, -1, dateadd(Day, 1, CAST(CONVERT(CHAR(10),TR.RangeEndDate,110) AS DATETIME)))
					END RecurringEndDate,
		TR.Type,
		TR.DailyNumDays,
		TR.DailyType, 
		TR.WeeklyNumWeeks, 
		TR.WeeklyOnSunday, 
		TR.WeeklyOnMonday, 
		TR.WeeklyOnTuesday, 
		TR.WeeklyOnWednesday, 
		TR.WeeklyOnThursday, 
		TR.WeeklyOnFriday, 
		TR.WeeklyOnSaturday,
		TR.MonthlyType,
		TR.MonthlyNumMonths, 
		TR.MonthlyDayOfMonth,
		TR.MonthlyWeekTypeOfMonth, 
		TR.MonthlyTypeOfDay,
		TR.YearlyType,
		TR.YearlyMonth, 
		TR.YearlyDayOfMonth, 
		TR.YearlyDayTypeOfMonth, 
		TR.YearlyTypeOfDay
	FROM
		#t_Timeblock t
	INNER JOIN 
		TimeblockRecurrence TR 
	ON 	   t.TimeblockID = TR.TimeblockID

	UPDATE R SET DKID=DK.DKID
	FROM DateKey DK INNER JOIN #Recurrences R
	ON DK.Dt=CAST(CONVERT(CHAR(10),R.StartDate,110) AS DATETIME)
	WHERE Type='D' AND DailyType='X'

	UPDATE R SET WK=DK.WK
	FROM DateKey DK INNER JOIN #Recurrences R
	ON DK.Dt=CAST(CONVERT(CHAR(10),R.StartDate,110) AS DATETIME)
	WHERE Type='W'

	UPDATE R SET MoID=DK.MoID
	FROM DateKey DK INNER JOIN #Recurrences R
	ON DK.Dt=CAST(CONVERT(CHAR(10),R.StartDate,110) AS DATETIME)
	WHERE Type='M'	

	INSERT INTO #t_Timeblock(TimeblockID, StartDate, EndDate, IsRecurring, UniqueID)
	SELECT R.TimeblockID, 
	CONVERT(CHAR(10),DK.Dt,110)+' '+CAST(DATEPART(hh,R.StartDate) AS VARCHAR(2))+':'+CAST(DATEPART(mi,R.StartDate) AS VARCHAR(2)) StartDate,
	CONVERT(CHAR(10),DK.Dt,110)+' '+CAST(DATEPART(hh,R.EndDate) AS VARCHAR(2))+':'+CAST(DATEPART(mi,R.EndDate) AS VARCHAR(2)) EndDate,
	1 IsRecurring, CAST(TimeblockID AS VARCHAR)+'-'+CONVERT(CHAR(10),DK.Dt,110) UniqueID
	FROM DateKey DK INNER JOIN #Recurrences R
	ON DK.Dt BETWEEN R.RecurringStartDate AND R.RecurringEndDate AND R.Type='D' AND R.DailyType='W' AND DK.WD IN (2,3,4,5,6)
	OR DK.Dt BETWEEN R.RecurringStartDate AND R.RecurringEndDate AND R.Type='D' AND R.DailyType='X' AND (DK.DKID-R.DKID)%R.DailyNumDays=0
	OR DK.Dt BETWEEN R.RecurringStartDate AND R.RecurringEndDate AND R.Type='W' AND (DK.WK-R.WK)%R.WeeklyNumWeeks=0
		AND ((R.WeeklyOnSunday=1 AND WD=1) OR (R.WeeklyOnMonday=1 AND WD=2) OR (R.WeeklyOnTuesday=1 AND WD=3) OR
				 (R.WeeklyOnWednesday=1 AND WD=4) OR (R.WeeklyOnThursday=1 AND WD=5) OR (R.WeeklyOnFriday=1 AND WD=6) OR
				 (R.WeeklyOnSaturday=1 AND WD=7))
	OR DK.Dt BETWEEN R.RecurringStartDate AND R.RecurringEndDate AND R.Type='M' AND R.MonthlyType='D'
		AND (DK.MoID-R.MoID)%R.MonthlyNumMonths=0
		AND (((R.MonthlyDayOfMonth<=DK.MoDays) AND (DK.D=R.MonthlyDayOfMonth)) OR ((R.MonthlyDayOfMonth>DK.MoDays) AND (DK.LastDay=1)))
	OR DK.Dt BETWEEN R.RecurringStartDate AND R.RecurringEndDate AND R.Type='M' AND R.MonthlyType='T'
		AND (DK.MoID-R.MoID)%R.MonthlyNumMonths=0
		AND ((R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='D' AND LastDay=1)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='K' AND LastWKDay=1)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='E' AND LastWEDay=1)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='S' AND LastWD=1 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='M' AND LastWD=1 AND WD=2)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='T' AND LastWD=1 AND WD=3)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='W' AND LastWD=1 AND WD=4)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='R' AND LastWD=1 AND WD=5)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='F' AND LastWD=1 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='A' AND LastWD=1 AND WD=7)
			 OR (R.MonthlyTypeOfDay='D' AND R.MonthlyWeekTypeOfMonth<>'L' AND D=CASE WHEN ISNUMERIC(R.MonthlyWeekTypeOfMonth)=1 THEN CAST(R.MonthlyWeekTypeOfMonth AS INT) END)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='K' AND WDIM=1 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='E' AND WDIM=1 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='S' AND WDIM=1 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='M' AND WDIM=1 AND WD=2)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='T' AND WDIM=1 AND WD=3)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='W' AND WDIM=1 AND WD=4)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='R' AND WDIM=1 AND WD=5)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='F' AND WDIM=1 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='A' AND WDIM=1 AND WD=7)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='K' AND WDIM=2 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='E' AND WDIM=2 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='S' AND WDIM=2 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='M' AND WDIM=2 AND WD=2)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='T' AND WDIM=2 AND WD=3)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='W' AND WDIM=2 AND WD=4)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='R' AND WDIM=2 AND WD=5)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='F' AND WDIM=2 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='A' AND WDIM=2 AND WD=7)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='K' AND WDIM=3 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='E' AND WDIM=3 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='S' AND WDIM=3 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='M' AND WDIM=3 AND WD=2)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='T' AND WDIM=3 AND WD=3)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='W' AND WDIM=3 AND WD=4)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='R' AND WDIM=3 AND WD=5)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='F' AND WDIM=3 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='A' AND WDIM=3 AND WD=7)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='K' AND WDIM=4 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='E' AND WDIM=4 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='S' AND WDIM=4 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='M' AND WDIM=4 AND WD=2)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='T' AND WDIM=4 AND WD=3)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='W' AND WDIM=4 AND WD=4)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='R' AND WDIM=4 AND WD=5)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='F' AND WDIM=4 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='A' AND WDIM=4 AND WD=7))
	OR DK.Dt BETWEEN R.RecurringStartDate AND R.RecurringEndDate AND R.Type='Y' AND R.YearlyType='D' AND
	   DK.Mo=R.YearlyMonth AND DK.D=R.YearlyDayOfMonth
	OR DK.Dt BETWEEN R.RecurringStartDate AND R.RecurringEndDate AND R.Type='Y' AND R.YearlyType='T' AND
	   DK.Mo=R.YearlyMonth 
	   AND ((R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='D' AND LastDay=1)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='K' AND LastWKDay=1)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='E' AND LastWEDay=1)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='S' AND LastWD=1 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='M' AND LastWD=1 AND WD=2)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='T' AND LastWD=1 AND WD=3)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='W' AND LastWD=1 AND WD=4)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='R' AND LastWD=1 AND WD=5)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='F' AND LastWD=1 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='A' AND LastWD=1 AND WD=7)
			 OR (R.YearlyTypeOfDay='D' AND R.YearlyDayTypeOfMonth<>'L' AND D=CASE WHEN ISNUMERIC(R.YearlyDayTypeOfMonth)=1 THEN CAST(R.YearlyDayTypeOfMonth AS INT) END)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='K' AND WDIM=1 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='E' AND WDIM=1 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='S' AND WDIM=1 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='M' AND WDIM=1 AND WD=2)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='T' AND WDIM=1 AND WD=3)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='W' AND WDIM=1 AND WD=4)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='R' AND WDIM=1 AND WD=5)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='F' AND WDIM=1 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='A' AND WDIM=1 AND WD=7)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='K' AND WDIM=2 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='E' AND WDIM=2 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='S' AND WDIM=2 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='M' AND WDIM=2 AND WD=2)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='T' AND WDIM=2 AND WD=3)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='W' AND WDIM=2 AND WD=4)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='R' AND WDIM=2 AND WD=5)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='F' AND WDIM=2 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='A' AND WDIM=2 AND WD=7)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='K' AND WDIM=3 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='E' AND WDIM=3 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='S' AND WDIM=3 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='M' AND WDIM=3 AND WD=2)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='T' AND WDIM=3 AND WD=3)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='W' AND WDIM=3 AND WD=4)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='R' AND WDIM=3 AND WD=5)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='F' AND WDIM=3 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='A' AND WDIM=3 AND WD=7)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='K' AND WDIM=4 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='E' AND WDIM=4 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='S' AND WDIM=4 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='M' AND WDIM=4 AND WD=2)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='T' AND WDIM=4 AND WD=3)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='W' AND WDIM=4 AND WD=4)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='R' AND WDIM=4 AND WD=5)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='F' AND WDIM=4 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='A' AND WDIM=4 AND WD=7))

	-- Remove recurring Timeblock exceptions from our temp table
	DELETE t
	FROM #t_Timeblock t INNER JOIN TimeblockRecurrenceException TRE
	ON t.TimeblockID=TRE.TimeblockID AND CONVERT(CHAR(10),t.StartDate,110)=CONVERT(CHAR(10),TRE.ExceptionDate,110)
	WHERE IsRecurring=1

	UPDATE #Recurrence SET StartDate=@OGStartDate, EndDate=@OGEndDate,
	RecurringStartDate=CAST(CONVERT(CHAR(10),@StartDate,110) AS DATETIME), 
	RecurringEndDate=CASE WHEN RangeType = 'N' or @EndDate < CAST(CONVERT(CHAR(10),RangeEndDate,110) AS DATETIME) THEN
						dateadd(second, -1, dateadd(Day, 1, @EndDate))
					ELSE
						dateadd(second, -1, dateadd(Day, 1, CAST(CONVERT(CHAR(10),RangeEndDate,110) AS DATETIME)))
					END 

	UPDATE R SET DKID=DK.DKID
	FROM DateKey DK INNER JOIN #Recurrence R
	ON DK.Dt=CAST(CONVERT(CHAR(10),R.StartDate,110) AS DATETIME)
	WHERE Type='D' AND DailyType='X'

	UPDATE R SET WK=DK.WK
	FROM DateKey DK INNER JOIN #Recurrence R
	ON DK.Dt=CAST(CONVERT(CHAR(10),R.StartDate,110) AS DATETIME)
	WHERE Type='W'

	UPDATE R SET MoID=DK.MoID
	FROM DateKey DK INNER JOIN #Recurrence R
	ON DK.Dt=CAST(CONVERT(CHAR(10),R.StartDate,110) AS DATETIME)
	WHERE Type='M'	

	INSERT INTO #checkdates(StartDate, EndDate)
	SELECT 
	CONVERT(CHAR(10),DK.Dt,110)+' '+CAST(DATEPART(hh,R.StartDate) AS VARCHAR(2))+':'+CAST(DATEPART(mi,R.StartDate) AS VARCHAR(2)) StartDate,
	CONVERT(CHAR(10),DK.Dt,110)+' '+CAST(DATEPART(hh,R.EndDate) AS VARCHAR(2))+':'+CAST(DATEPART(mi,R.EndDate) AS VARCHAR(2)) EndDate
	FROM DateKey DK INNER JOIN #Recurrence R
	ON DK.Dt BETWEEN R.RecurringStartDate AND R.RecurringEndDate AND R.Type='D' AND R.DailyType='W' AND DK.WD IN (2,3,4,5,6)
	OR DK.Dt BETWEEN R.RecurringStartDate AND R.RecurringEndDate AND R.Type='D' AND R.DailyType='X' AND (DK.DKID-R.DKID)%R.DailyNumDays=0
	OR DK.Dt BETWEEN R.RecurringStartDate AND R.RecurringEndDate AND R.Type='W' AND (DK.WK-R.WK)%R.WeeklyNumWeeks=0
		AND ((R.WeeklyOnSunday=1 AND WD=1) OR (R.WeeklyOnMonday=1 AND WD=2) OR (R.WeeklyOnTuesday=1 AND WD=3) OR
				 (R.WeeklyOnWednesday=1 AND WD=4) OR (R.WeeklyOnThursday=1 AND WD=5) OR (R.WeeklyOnFriday=1 AND WD=6) OR
				 (R.WeeklyOnSaturday=1 AND WD=7))
	OR DK.Dt BETWEEN R.RecurringStartDate AND R.RecurringEndDate AND R.Type='M' AND R.MonthlyType='D'
		AND (DK.MoID-R.MoID)%R.MonthlyNumMonths=0
		AND (((R.MonthlyDayOfMonth<=DK.MoDays) AND (DK.D=R.MonthlyDayOfMonth)) OR ((R.MonthlyDayOfMonth>DK.MoDays) AND (DK.LastDay=1)))
	OR DK.Dt BETWEEN R.RecurringStartDate AND R.RecurringEndDate AND R.Type='M' AND R.MonthlyType='T'
		AND (DK.MoID-R.MoID)%R.MonthlyNumMonths=0
		AND ((R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='D' AND LastDay=1)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='K' AND LastWKDay=1)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='E' AND LastWEDay=1)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='S' AND LastWD=1 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='M' AND LastWD=1 AND WD=2)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='T' AND LastWD=1 AND WD=3)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='W' AND LastWD=1 AND WD=4)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='R' AND LastWD=1 AND WD=5)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='F' AND LastWD=1 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='L' AND R.MonthlyTypeOfDay='A' AND LastWD=1 AND WD=7)
			 OR (R.MonthlyTypeOfDay='D' AND R.MonthlyWeekTypeOfMonth<>'L' AND D=CASE WHEN ISNUMERIC(R.MonthlyWeekTypeOfMonth)=1 THEN CAST(R.MonthlyWeekTypeOfMonth AS INT) END)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='K' AND WDIM=1 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='E' AND WDIM=1 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='S' AND WDIM=1 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='M' AND WDIM=1 AND WD=2)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='T' AND WDIM=1 AND WD=3)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='W' AND WDIM=1 AND WD=4)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='R' AND WDIM=1 AND WD=5)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='F' AND WDIM=1 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='1' AND R.MonthlyTypeOfDay='A' AND WDIM=1 AND WD=7)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='K' AND WDIM=2 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='E' AND WDIM=2 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='S' AND WDIM=2 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='M' AND WDIM=2 AND WD=2)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='T' AND WDIM=2 AND WD=3)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='W' AND WDIM=2 AND WD=4)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='R' AND WDIM=2 AND WD=5)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='F' AND WDIM=2 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='2' AND R.MonthlyTypeOfDay='A' AND WDIM=2 AND WD=7)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='K' AND WDIM=3 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='E' AND WDIM=3 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='S' AND WDIM=3 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='M' AND WDIM=3 AND WD=2)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='T' AND WDIM=3 AND WD=3)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='W' AND WDIM=3 AND WD=4)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='R' AND WDIM=3 AND WD=5)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='F' AND WDIM=3 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='3' AND R.MonthlyTypeOfDay='A' AND WDIM=3 AND WD=7)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='K' AND WDIM=4 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='E' AND WDIM=4 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='S' AND WDIM=4 AND WD=1)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='M' AND WDIM=4 AND WD=2)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='T' AND WDIM=4 AND WD=3)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='W' AND WDIM=4 AND WD=4)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='R' AND WDIM=4 AND WD=5)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='F' AND WDIM=4 AND WD=6)
			 OR (R.MonthlyWeekTypeOfMonth='4' AND R.MonthlyTypeOfDay='A' AND WDIM=4 AND WD=7))
	OR DK.Dt BETWEEN R.RecurringStartDate AND R.RecurringEndDate AND R.Type='Y' AND R.YearlyType='D' AND
	   DK.Mo=R.YearlyMonth AND DK.D=R.YearlyDayOfMonth
	OR DK.Dt BETWEEN R.RecurringStartDate AND R.RecurringEndDate AND R.Type='Y' AND R.YearlyType='T' AND
	   DK.Mo=R.YearlyMonth 
	   AND ((R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='D' AND LastDay=1)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='K' AND LastWKDay=1)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='E' AND LastWEDay=1)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='S' AND LastWD=1 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='M' AND LastWD=1 AND WD=2)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='T' AND LastWD=1 AND WD=3)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='W' AND LastWD=1 AND WD=4)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='R' AND LastWD=1 AND WD=5)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='F' AND LastWD=1 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='L' AND R.YearlyTypeOfDay='A' AND LastWD=1 AND WD=7)
			 OR (R.YearlyTypeOfDay='D' AND R.YearlyDayTypeOfMonth<>'L' AND D=CASE WHEN ISNUMERIC(R.YearlyDayTypeOfMonth)=1 THEN CAST(R.YearlyDayTypeOfMonth AS INT) END)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='K' AND WDIM=1 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='E' AND WDIM=1 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='S' AND WDIM=1 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='M' AND WDIM=1 AND WD=2)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='T' AND WDIM=1 AND WD=3)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='W' AND WDIM=1 AND WD=4)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='R' AND WDIM=1 AND WD=5)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='F' AND WDIM=1 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='1' AND R.YearlyTypeOfDay='A' AND WDIM=1 AND WD=7)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='K' AND WDIM=2 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='E' AND WDIM=2 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='S' AND WDIM=2 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='M' AND WDIM=2 AND WD=2)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='T' AND WDIM=2 AND WD=3)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='W' AND WDIM=2 AND WD=4)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='R' AND WDIM=2 AND WD=5)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='F' AND WDIM=2 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='2' AND R.YearlyTypeOfDay='A' AND WDIM=2 AND WD=7)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='K' AND WDIM=3 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='E' AND WDIM=3 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='S' AND WDIM=3 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='M' AND WDIM=3 AND WD=2)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='T' AND WDIM=3 AND WD=3)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='W' AND WDIM=3 AND WD=4)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='R' AND WDIM=3 AND WD=5)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='F' AND WDIM=3 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='3' AND R.YearlyTypeOfDay='A' AND WDIM=3 AND WD=7)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='K' AND WDIM=4 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='E' AND WDIM=4 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='S' AND WDIM=4 AND WD=1)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='M' AND WDIM=4 AND WD=2)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='T' AND WDIM=4 AND WD=3)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='W' AND WDIM=4 AND WD=4)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='R' AND WDIM=4 AND WD=5)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='F' AND WDIM=4 AND WD=6)
			 OR (R.YearlyDayTypeOfMonth='4' AND R.YearlyTypeOfDay='A' AND WDIM=4 AND WD=7))

	IF @@ROWCOUNT=0
	BEGIN
		INSERT INTO #checkdates(StartDate, EndDate)
		VALUES(@OGStartDate, @OGEndDate)
	END

	INSERT INTO #t_Timeblock_overbooked
	SELECT t.TimeblockID, t.StartDate, t.EndDate
	FROM #t_Timeblock t INNER JOIN #checkdates cd
	ON t.StartDate<cd.EndDate AND t.EndDate>cd.StartDate OR t.StartDate=cd.StartDate AND t.EndDate=cd.EndDate

	SELECT TOP 20 tob.StartDate,
		tob.EndDate,
		cast(T.AppointmentResourceTypeID as int), 
		cast(T.ResourceID as int), 
		CASE 
		   WHEN T.AppointmentResourceTypeID = 1 THEN
			LTRIM(ISNULL(D.Prefix + ' ','')) + RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + RTRIM(ISNULL(D.Suffix + ' ','') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), ''))
		   WHEN T.AppointmentResourceTypeID = 2 THEN
			PR.ResourceName
		END AS Name
	FROM #t_Timeblock_overbooked tob INNER JOIN Timeblock T 
	ON tob.TimeblockID = T.TimeblockID
	INNER JOIN #Resources R
	ON T.AppointmentResourceTypeID=R.Type AND T.ResourceID=R.ResourceID
	LEFT JOIN Doctor D 
	ON D.DoctorID = T.ResourceID AND T.AppointmentResourceTypeID = 1
	LEFT JOIN PracticeResource PR 
	ON PR.PracticeResourceID = T.ResourceID AND T.AppointmentResourceTypeID = 2
	GROUP BY tob.StartDate, 
			tob.EndDate, 
			T.AppointmentResourceTypeID, 
			T.ResourceID, 
			D.Prefix,
			D.FirstName, 
			D.MiddleName, 
			D.LastName, 
			D.Suffix, 
			D.Degree, 
			PR.ResourceName
	ORDER BY tob.StartDate, CASE 
		   WHEN T.AppointmentResourceTypeID = 1 THEN
			LTRIM(ISNULL(D.Prefix + ' ','')) + RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + RTRIM(ISNULL(D.Suffix + ' ','') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), ''))
		   WHEN T.AppointmentResourceTypeID = 2 THEN
			PR.ResourceName
		END

	DROP TABLE #t_Timeblock
	DROP TABLE #t_Timeblock_overbooked
	DROP TABLE #Resources
	DROP TABLE #Recurrence
	DROP TABLE #Recurrences
	DROP TABLE #checkdates

END

