set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER PROCEDURE [dbo].[AppointmentDataProvider_GetAppointmentsByDates]
	@practice_id INT,
	@appointment_resource_type_id INT = null, 
	@resource_id INT = null, 
	@service_location_id INT = null,
	@start_date DATETIME = null,
	@end_date DATETIME = null,
	@payer_scenario_id INT = null,
	@appointment_id INT = null,
	@patient_id INT = null,
	@include_all_tables BIT = 1

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

	CREATE TABLE #t_appointment(
		PracticeID INT,
		AppointmentID int,
		PatientID int, 
		ServiceLocationID int, 
		Subject varchar(64),
		StartDate datetime, 
		EndDate datetime, 
		RecurringStartDate datetime,
		RecurringEndDate datetime,
		AppointmentType varchar(1), 
		Notes text,
		AppointmentConfirmationStatusCode char(1), 
		AllDay bit, 
--		PatientPrefix varchar(16), 
--		PatientFirstName varchar(64), 
--		PatientMiddleName varchar(64), 
--		PatientLastName varchar(64), 
--		PatientSuffix varchar(16), 
		PrimaryReason varchar(128), 
		Color int,
--		Resources varchar(1024),
--		HasDefaultEncounterTemplate bit,
		UniqueID varchar(32), 
		IsRecurring bit, 
		IsOriginalRecord bit,
		PayerScenarioID int
	)

	CREATE TABLE #t_appointmenttoresource(
		AppointmentID int,
		DoctorID int
	)

	IF @Resource_ID IS NOT NULL
	BEGIN
		INSERT	#t_appointment(
		PracticeID,
		AppointmentID,
		PatientID, 
		ServiceLocationID, 
		Subject,
		StartDate, 
		EndDate, 
		AppointmentType, 
		Notes,
		AppointmentConfirmationStatusCode, 
		AllDay, 
		Color,
		PrimaryReason,
		UniqueID, 
		IsRecurring, 
		IsOriginalRecord,
		PayerScenarioID
		)
		SELECT
			A.PracticeID,
			A.AppointmentID,
			A.PatientID, 
			A.ServiceLocationID, 
			A.Subject,
			A.StartDate,
			A.EndDate,
			A.AppointmentType,
			A.Notes, 
			A.AppointmentConfirmationStatusCode, 
			A.AllDay, 
			AR.DefaultColorCode as Color, 
			AR.Name as PrimaryReason,
			cast(A.AppointmentID as varchar(32)) as UniqueID, 
			Recurrence IsRecurring, 
			1 IsOriginalRecord,
			PC.PayerScenarioID
		FROM
			Appointment A WITH(NOLOCK) 
			INNER JOIN AppointmentToResource ATR WITH(NOLOCK) ON A.AppointmentID=ATR.AppointmentID
			LEFT OUTER JOIN AppointmentToAppointmentReason ATAR ON ATAR.PracticeID=A.PracticeID AND ATAR.AppointmentID = A.AppointmentID AND ATAR.PrimaryAppointment = 1
			LEFT OUTER JOIN AppointmentReason AR ON AR.AppointmentReasonID = ATAR.AppointmentReasonID
			LEFT OUTER JOIN PatientCase PC ON PC.PracticeID = @Practice_ID AND PC.PatientID = A.PatientID AND PC.PatientCaseID = A.PatientCaseID
		WHERE (A.PracticeID=@practice_id AND (StartDKPracticeID>=@StartID AND EndDKPracticeID<=@EndID
		OR StartDKPracticeID < @StartID AND EndDKPracticeID BETWEEN @StartID AND @EndID
		OR StartDKPracticeID < @EndID AND EndDKPracticeID > @EndID) 
		OR A.PracticeID=@practice_id AND StartDKPracticeID<@StartID
		   AND Recurrence=1 AND RecurrenceStartDate<=@end_date AND (RangeEndDate >= dateadd(day, -1, @start_date) OR RangeType = 'N') )
		AND A.AppointmentConfirmationStatusCode <> 'X'		-- case 3884
		AND (A.ServiceLocationID = @service_location_id or @service_location_id IS NULL)			
		AND (A.PatientID = @patient_id or @patient_id is null)
		AND (A.AppointmentID = @appointment_id or @appointment_id is null)
		AND (ATR.ResourceID=@resource_id AND ATR.AppointmentResourceTypeID=@appointment_resource_type_id)
		AND (PC.PayerScenarioID = @payer_scenario_id or @payer_scenario_id is null)
	END
	ELSE
	BEGIN
		INSERT	#t_appointment(
		PracticeID,
		AppointmentID,
		PatientID, 
		ServiceLocationID, 
		Subject,
		StartDate, 
		EndDate, 
		AppointmentType, 
		Notes,
		AppointmentConfirmationStatusCode, 
		AllDay, 
		Color,
		PrimaryReason,
		UniqueID, 
		IsRecurring, 
		IsOriginalRecord,
		PayerScenarioID
		)
		SELECT
			A.PracticeID,
			A.AppointmentID,
			A.PatientID, 
			A.ServiceLocationID, 
			A.Subject,
			A.StartDate,
			A.EndDate,
			A.AppointmentType,
			A.Notes, 
			A.AppointmentConfirmationStatusCode, 
			A.AllDay, 
			AR.DefaultColorCode as Color, 
			AR.Name as PrimaryReason,
			cast(A.AppointmentID as varchar(32)) as UniqueID, 
			Recurrence IsRecurring, 
			1 IsOriginalRecord,
			PC.PayerScenarioID
		FROM
			Appointment A WITH(NOLOCK) 
			LEFT OUTER JOIN AppointmentToAppointmentReason ATAR ON ATAR.PracticeID=A.PracticeID AND ATAR.AppointmentID = A.AppointmentID AND ATAR.PrimaryAppointment = 1
			LEFT OUTER JOIN AppointmentReason AR ON AR.AppointmentReasonID = ATAR.AppointmentReasonID
			LEFT OUTER JOIN PatientCase PC ON PC.PracticeID = @Practice_ID AND PC.PatientID = A.PatientID AND PC.PatientCaseID = A.PatientCaseID
		WHERE (A.PracticeID=@practice_id AND (StartDKPracticeID>=@StartID AND EndDKPracticeID<=@EndID
		OR StartDKPracticeID < @StartID AND EndDKPracticeID BETWEEN @StartID AND @EndID
		OR StartDKPracticeID < @EndID AND EndDKPracticeID > @EndID) 
		OR A.PracticeID=@practice_id AND StartDKPracticeID<@StartID
		   AND Recurrence=1 AND RecurrenceStartDate<=@end_date AND (RangeEndDate >= dateadd(day, -1, @start_date) OR RangeType = 'N') )
		AND A.AppointmentConfirmationStatusCode <> 'X'		-- case 3884
		AND (A.ServiceLocationID = @service_location_id or @service_location_id IS NULL)			
		AND (A.PatientID = @patient_id or @patient_id is null)
		AND (A.AppointmentID = @appointment_id or @appointment_id is null)
		AND (PC.PayerScenarioID = @payer_scenario_id or @payer_scenario_id is null)
	END

	-- Get Recurrences whose original appointment starts within @start_date and @end_date
	-- This list will be deleted, because the insert recurrence will cause a duplicate
	DECLARE @InitialReccurrencesToDelete TABLE(AppointmentID INT, StartDate DATETIME)
	INSERT @InitialReccurrencesToDelete(AppointmentID, StartDate)
	SELECT AppointmentID, StartDate
	FROM #t_Appointment
	WHERE IsRecurring=1 AND StartDate BETWEEN @start_date AND @end_Date

	-- Insert the recurring appointments into our temp table
	CREATE TABLE #Recurrences(AppointmentID INT, StartDate DATETIME, EndDate DATETIME, RecurringStartDate DATETIME, RecurringEndDate DATETIME, Type CHAR(1),
							  DailyNumDays INT, DailyType CHAR(1), WeeklyNumWeeks INT, WeeklyOnSunday BIT,
							  WeeklyOnMonday BIT, WeeklyOnTuesday BIT, WeeklyOnWednesday BIT, WeeklyOnThursday BIT,
							  WeeklyOnFriday BIT, WeeklyOnSaturday BIT, MonthlyType CHAR(1), MonthlyNumMonths INT, MonthlyDayOfMonth INT,
							  MonthlyWeekTypeOfMonth CHAR(1), MonthlyTypeOfDay CHAR(1), YearlyType CHAR(1), YearlyMonth INT,
							  YearlyDayOfMonth INT, YearlyDayTypeOfMonth CHAR(1), YearlyTypeOfDay CHAR(1), DKID INT, WK INT, MoID INT)
	INSERT INTO #Recurrences(AppointmentID, StartDate, EndDate, RecurringStartDate, RecurringEndDate, Type, DailyNumDays, DailyType, WeeklyNumWeeks, WeeklyOnSunday,
							 WeeklyOnMonday, WeeklyOnTuesday, WeeklyOnWednesday, WeeklyOnThursday, WeeklyOnFriday, WeeklyOnSaturday, 
							 MonthlyType, MonthlyNumMonths, MonthlyDayOfMonth, MonthlyWeekTypeOfMonth, MonthlyTypeOfDay, YearlyType, YearlyMonth, YearlyDayOfMonth, 
							 YearlyDayTypeOfMonth, YearlyTypeOfDay)
	SELECT
		A.AppointmentID, 
		A.StartDate,
		A.EndDate,
		CASE WHEN @start_date > CAST(CONVERT(CHAR(10),A.StartDate,110) AS DATETIME) THEN
						@start_date
				      	ELSE
						CAST(CONVERT(CHAR(10),A.StartDate,110) AS DATETIME)
				      	END RecurringStartDate,
		CASE WHEN AR.RangeType = 'N' or @end_date < CAST(CONVERT(CHAR(10),AR.RangeEndDate,110) AS DATETIME) THEN
						dateadd(second, -1, dateadd(Day, 1, @end_date))
					ELSE
						dateadd(second, -1, dateadd(Day, 1, CAST(CONVERT(CHAR(10),AR.RangeEndDate,110) AS DATETIME)))
					END RecurringEndDate,
		AR.Type,
		AR.DailyNumDays,
		AR.DailyType, 
		AR.WeeklyNumWeeks, 
		AR.WeeklyOnSunday, 
		AR.WeeklyOnMonday, 
		AR.WeeklyOnTuesday, 
		AR.WeeklyOnWednesday, 
		AR.WeeklyOnThursday, 
		AR.WeeklyOnFriday, 
		AR.WeeklyOnSaturday,
		AR.MonthlyType,
		AR.MonthlyNumMonths, 
		AR.MonthlyDayOfMonth,
		AR.MonthlyWeekTypeOfMonth, 
		AR.MonthlyTypeOfDay,
		AR.YearlyType,
		AR.YearlyMonth, 
		AR.YearlyDayOfMonth, 
		AR.YearlyDayTypeOfMonth, 
		AR.YearlyTypeOfDay
	FROM
		#t_appointment A
	INNER JOIN 
		AppointmentRecurrence AR 
	ON 	   AR.AppointmentID = A.AppointmentID

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

	INSERT INTO #t_appointment(AppointmentID, StartDate, EndDate, IsRecurring, UniqueID)
	SELECT R.AppointmentID, 
	CONVERT(CHAR(10),DK.Dt,110)+' '+CAST(DATEPART(hh,R.StartDate) AS VARCHAR(2))+':'+CAST(DATEPART(mi,R.StartDate) AS VARCHAR(2)) StartDate,
	CONVERT(CHAR(10),DK.Dt,110)+' '+CAST(DATEPART(hh,R.EndDate) AS VARCHAR(2))+':'+CAST(DATEPART(mi,R.EndDate) AS VARCHAR(2)) EndDate,
	1 IsRecurring, CAST(AppointmentID AS VARCHAR)+'-'+CONVERT(CHAR(10),DK.Dt,110) UniqueID
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

	--Delete duplicate Recurring Appointments
	DELETE t
	FROM #t_Appointment t INNER JOIN @InitialReccurrencesToDelete IRTD
	ON t.AppointmentID=IRTD.AppointmentID AND t.StartDate=IRTD.StartDate AND IsOriginalRecord IS NULL

	-- Update the rest of the information for the recurring appointments with the original appointment info
	update	#t_appointment
	set	PatientID = t2.PatientID, 
		ServiceLocationID = t2.ServiceLocationID, 
		Subject = t2.Subject, 
		AppointmentType = t2.AppointmentType, 
		Notes = t2.Notes,
		AppointmentConfirmationStatusCode = t2.AppointmentConfirmationStatusCode,
		AllDay = t2.AllDay, 
		Color = t2.Color,
		PrimaryReason = t2.PrimaryReason,
		PayerScenarioID = t2.PayerScenarioID
	from	(select * from #t_appointment where IsRecurring = 1 and IsOriginalRecord = 1) t2
	where	#t_appointment.AppointmentID = t2.AppointmentID
	and	#t_appointment.IsRecurring = 1

	-- Remove recurring appointment exceptions from our temp table
	DELETE t
	FROM #t_appointment t INNER JOIN AppointmentRecurrenceException ARE
	ON t.AppointmentID=ARE.AppointmentID AND CONVERT(CHAR(10),t.StartDate,110)=CONVERT(CHAR(10),ARE.ExceptionDate,110)
	WHERE IsRecurring=1

	-- Remove any appointments not in the range
	DELETE FROM #t_appointment
	WHERE	EndDate < @start_date
	OR		StartDate > @end_date

	-- Return the appointments
	select	AppointmentID,
		PatientID, 
		ServiceLocationID, 
		Subject,
		StartDate, 
		EndDate, 
		AppointmentType, 
		Notes,
		AppointmentConfirmationStatusCode, 
		AllDay, 
		Color,
		PrimaryReason,
		UniqueID,
		IsRecurring,
		PayerScenarioID
	from	#t_appointment
--	where	StartDate <= @end_date		-- This drops off any of the recurring appointments we added that we don't need anymore
--	and	EndDate >= @start_date
	ORDER BY AppointmentID

	-- Include all tables only if this bit is true. We won't want all tables if we are being called
	-- from another stored procedure (like AppointmentDataProvider_CreateAppointmentBatch)
	IF @include_all_tables = 1
	BEGIN
		-- Return the patients for these appointments
		select	P.PatientID,
				P.Prefix,
				P.FirstName,
				P.MiddleName,
				P.LastName,
				P.Suffix
		from	Patient P
		inner join
				(select distinct PatientID from #t_appointment) A
		ON		   A.PatientID = P.PatientID

		-- Get the resource associations with each appointment
		INSERT INTO #t_appointmenttoresource
		SELECT	ATR.AppointmentID,
				ATR.ResourceID
		FROM	AppointmentToResource ATR WITH(NOLOCK) 
		INNER JOIN
				#t_appointment A
		ON		   A.AppointmentID = ATR.AppointmentID
		WHERE	ATR.AppointmentResourceTypeID = 1	-- Only get the doctors
		GROUP BY
				ATR.AppointmentID,
				ATR.ResourceID

		select	*
		from	#t_appointmenttoresource

		-- Get the resource names
		SELECT	D.DoctorID,
				D.Prefix,
				D.FirstName,
				D.MiddleName,
				D.LastName,
				D.Suffix,
				D.Degree,
				D.DefaultEncounterTemplateID
		FROM	Doctor D
		INNER JOIN
				(select distinct DoctorID from #t_appointmenttoresource) ATR
		ON		   ATR.DoctorID = D.DoctorID
	END

	DROP TABLE #t_appointment
	DROP TABLE #t_appointmenttoresource
	DROP TABLE #Recurrences

END


