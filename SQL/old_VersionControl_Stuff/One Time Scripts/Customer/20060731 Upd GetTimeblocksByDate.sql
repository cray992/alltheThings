set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[TimeblockDataProvider_GetTimeblocksByDates]
	@practice_id INT,
	@Appointment_resource_type_id INT, 
	@resource_id INT, 
	@start_date DATETIME = null,
	@end_date DATETIME = null,
	@Timeblock_id INT = null

AS
BEGIN

	DECLARE @MinID INT, @MaxID INT, @StartID INT, @EndID INT

	DECLARE @Qry TABLE(MinID INT, MaxID INT, StartID INT, EndID INT)
	INSERT @Qry(MinID, MaxID, StartID, EndID)
	SELECT MIN(MinDKPracticeID) MinID, MAX(MaxDKPracticeID), MIN(DKPracticeID) StartID, MAX(DKPracticeID) EndID
	FROM DateKeyToPractice
	WHERE PracticeID=@practice_id AND 
	Dt BETWEEN CAST(CONVERT(CHAR(10),@start_date,110) AS DATETIME) AND CAST(CONVERT(CHAR(10),@end_date,110) AS DATETIME)

	SELECT @MinID=MinID, @MaxID=MaxID, @StartID=StartID, @EndID=EndID
	FROM @Qry

	CREATE TABLE #t_Timeblock(
		PracticeID INT,
		TimeblockID int,
		StartDate datetime, 
		EndDate datetime,
		Notes text,
		AllDay bit, 
		TimeblockName varchar(128),
		Color int,
		UniqueID varchar(32), 
		IsRecurring bit, 
		IsOriginalRecord bit
	)

	INSERT	#t_Timeblock(
	PracticeID,
	TimeblockID,
	StartDate, 
	EndDate, 
	Notes,
	AllDay, 
	TimeblockName,
	Color,
	UniqueID, 
	IsRecurring, 
	IsOriginalRecord
	)
	SELECT
		T.PracticeID,
		T.TimeblockID,
		T.StartDate,
		T.EndDate,
		T.Notes, 
		T.AllDay, 
		T.TimeblockName,
		T.TimeblockColor Color, 
		cast(T.TimeblockID as varchar(32)) UniqueID, 
		IsRecurring, 
		1 IsOriginalRecord
	FROM
		Timeblock T
	WHERE (T.PracticeID=@practice_id AND (StartDKPracticeID>=@StartID AND EndDKPracticeID<=@EndID
	OR StartDKPracticeID < @StartID AND EndDKPracticeID BETWEEN @StartID AND @EndID
	OR StartDKPracticeID < @EndID AND EndDKPracticeID > @EndID) 
	OR T.PracticeID=@practice_id AND StartDKPracticeID < @StartID
	   AND IsRecurring=1 AND (RangeEndDate >= dateadd(day, -1, @start_date) OR RangeType = 'N') )
	AND (T.TimeblockID = @Timeblock_id or @Timeblock_id is null)
	AND (T.AppointmentResourceTypeID=@Appointment_resource_type_id)
	AND (T.ResourceID=@resource_id)

	-- Get Recurrences whose original Timeblock starts within @start_date and @end_date
	-- This list will be deleted, because the insert recurrence will cause a duplicate
	DECLARE @InitialReccurrencesToDelete TABLE(TimeblockID INT, StartDate DATETIME)
	INSERT @InitialReccurrencesToDelete(TimeblockID, StartDate)
	SELECT TimeblockID, StartDate
	FROM #t_Timeblock
	WHERE IsRecurring=1 AND StartDate BETWEEN @start_date AND @end_Date

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
		T.TimeblockID, 
		T.StartDate,
		T.EndDate,
		CASE WHEN @start_date > CAST(CONVERT(CHAR(10),T.StartDate,110) AS DATETIME) THEN
						@start_date
				      	ELSE
						CAST(CONVERT(CHAR(10),T.StartDate,110) AS DATETIME)
				      	END RecurringStartDate,
		CASE WHEN TR.RangeType = 'N' or @end_date < CAST(CONVERT(CHAR(10),TR.RangeEndDate,110) AS DATETIME) THEN
						dateadd(second, -1, dateadd(Day, 1, @end_date))
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
		#t_Timeblock T
	INNER JOIN 
		TimeblockRecurrence TR 
	ON 	   T.TimeblockID = TR.TimeblockID

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

	--Delete duplicate Recurring Timeblocks
	DELETE t
	FROM #t_Timeblock t INNER JOIN @InitialReccurrencesToDelete IRTD
	ON t.TimeblockID=IRTD.TimeblockID AND t.StartDate=IRTD.StartDate AND IsOriginalRecord IS NULL

	-- Update the rest of the information for the recurring Timeblocks with the original Timeblock info
	update	#t_Timeblock
	set	Notes = t2.Notes,
		AllDay = t2.AllDay,
		TimeblockName = t2.TimeblockName, 
		Color = t2.Color
	from	(select * from #t_Timeblock where IsRecurring = 1 and IsOriginalRecord = 1) t2
	where	#t_Timeblock.TimeblockID = t2.TimeblockID
	and	#t_Timeblock.IsRecurring = 1

	-- Remove recurring Timeblock exceptions from our temp table
	DELETE t
	FROM #t_Timeblock t INNER JOIN TimeblockRecurrenceException ARE
	ON t.TimeblockID=ARE.TimeblockID AND CONVERT(CHAR(10),t.StartDate,110)=CONVERT(CHAR(10),ARE.ExceptionDate,110)
	WHERE IsRecurring=1

	select	TimeblockID,
		StartDate, 
		EndDate, 
		Notes,
		AllDay, 
		TimeblockName, 
		Color,
		UniqueID,
		IsRecurring
	from	#t_Timeblock
	where	StartDate <= @end_date		-- This drops off any of the recurring Timeblocks we added that we don't need anymore
	and	EndDate >= @start_date
	ORDER BY TimeblockID

	DROP TABLE #t_Timeblock
	DROP TABLE #Recurrences

END

