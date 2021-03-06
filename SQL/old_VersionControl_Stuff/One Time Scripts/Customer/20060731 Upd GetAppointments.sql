set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


ALTER PROCEDURE [dbo].[AppointmentDataProvider_GetAppointments]
	@practice_id INT,
	@start_date DATETIME = null,
	@end_date DATETIME = null,
	@query_domain VARCHAR(50) = NULL,
	@query VARCHAR(50) = NULL,
	@startRecord int = 0,
	@maxRecords int = 25,
	@totalRecords int = NULL OUTPUT,
	@appointment_type varchar(15) = 'All'
AS
BEGIN

	DECLARE @ISINT BIT
	SET @ISINT=0

	IF ISNUMERIC(@query)=1
	BEGIN
		DECLARE @BIGNumber BIGINT
		DECLARE @MAXINT BIGINT
		DECLARE @MAXBIG FLOAT

		IF CHARINDEX('-',@query)=0 AND CHARINDEX('.',@query)=0 AND CHARINDEX('\',@query)=0 AND CHARINDEX('/',@query)=0
		AND CHARINDEX('+',@query)=0
		BEGIN
			SET @query=REPLACE(REPLACE(@query,',',''),'$','')
			SET @MAXINT=2147483647
			SET @MAXBIG=9223372036854775807

			IF (@MAXBIG-CAST(@query AS FLOAT))>0
			BEGIN
				SET @BIGNumber=CAST(@query AS BIGINT)	
				SET @BIGNumber=@BIGNumber-@MAXINT

				IF @BIGNumber<0 AND @BIGNumber<>0
				BEGIN
					SET @ISINT=1
				END
			END
		END
	END

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
		AppointmentID int,
		ServiceLocationName varchar(128), 
		Subject varchar(64),
		StartDate datetime, 
		EndDate datetime, 
		RecurringStartDate datetime,
		RecurringEndDate datetime,
		AppointmentType varchar(1), 
		AppointmentTypeDescription varchar(32), 
		AppointmentConfirmationStatusCode varchar(1), 
		AppointmentConfirmationStatusDescription varchar(64), 
		PatientPrefix varchar(16), 
		PatientFirstName varchar(64), 
		PatientMiddleName varchar(64), 
		PatientLastName varchar(64), 
		PatientSuffix varchar(16), 
		PrimaryReasonName varchar(128), 
		Resources varchar(1024), 
		Deletable bit, 
		IsRecurring bit, 
		UniqueID varchar(32),
		IsOriginalRecord bit
	)

	CREATE TABLE #t_appointment_return(
		TicketNumber varchar(100),
		AppointmentID int,
		ServiceLocationName varchar(128), 
		Subject varchar(64),
		StartDate datetime, 
		EndDate datetime, 
		AppointmentType varchar(1), 
		AppointmentTypeDescription varchar(32), 
		AppointmentConfirmationStatusCode varchar(1), 
		AppointmentConfirmationStatusDescription varchar(64), 
		PatientPrefix varchar(16), 
		PatientFirstName varchar(64), 
		PatientMiddleName varchar(64), 
		PatientLastName varchar(64), 
		PatientSuffix varchar(16), 
		PrimaryReasonName varchar(128), 
		Resources varchar(1024), 
		Deletable bit, 
		IsRecurring bit, 
		UniqueID varchar(32), 
		RID int IDENTITY(0,1)
	)

	--Main Query

		INSERT	#t_appointment(
		AppointmentID,
		ServiceLocationName, 
		Subject,
		StartDate, 
		EndDate, 
		AppointmentType, 
		AppointmentTypeDescription, 
		AppointmentConfirmationStatusCode, 
		AppointmentConfirmationStatusDescription, 
		PatientPrefix, 
		PatientFirstName, 
		PatientMiddleName, 
		PatientLastName, 
		PatientSuffix, 
		PrimaryReasonName,
		Deletable,
		IsRecurring, 
		IsOriginalRecord, 
		UniqueID
		)
		SELECT
			DISTINCT A.AppointmentID,
			SL.Name as ServiceLocationName, 
			A.Subject,
			A.StartDate,
			A.EndDate,
			A.AppointmentType,
			[AT].AppointmentType,
			A.AppointmentConfirmationStatusCode,
			ACS.[Name],
			P.Prefix AS PatientPrefix, 
			P.FirstName AS PatientFirstName,
			P.MiddleName AS PatientMiddleName,
			P.LastName AS PatientLastName,
			P.Suffix AS PatientSuffix, 
			AR.Name as PrimaryReasonName,
			CAST(1 AS BIT) as Deletable,	-- update this when we can tell if this is deletable
			Recurrence IsRecurring, 
			1 IsOriginalRecord, 
			CAST(A.AppointmentID as varchar(32)) as UniqueID
		FROM
			Appointment A WITH(NOLOCK) 
			INNER JOIN AppointmentConfirmationStatus ACS ON ACS.AppointmentConfirmationStatusCode = A.AppointmentConfirmationStatusCode
			INNER JOIN AppointmentType AT ON AT.AppointmentType = A.AppointmentType
			LEFT JOIN AppointmentToResource ATR WITH(NOLOCK) ON A.AppointmentID=ATR.AppointmentID
			LEFT JOIN Doctor D ON ATR.ResourceID=D.DoctorID AND ATR.AppointmentResourceTypeID = 1
			LEFT JOIN PracticeResource PR ON ATR.ResourceID=PR.PracticeResourceID AND ATR.AppointmentResourceTypeID = 2
			LEFT JOIN Patient P ON A.PatientID = P.PatientID
			LEFT JOIN AppointmentToAppointmentReason ATAR ON A.AppointmentID= ATAR.AppointmentID AND ATAR.PrimaryAppointment = 1
			LEFT JOIN AppointmentReason AR ON AR.AppointmentReasonID = ATAR.AppointmentReasonID
			LEFT JOIN ServiceLocation SL ON SL.ServiceLocationID = A.ServiceLocationID
		WHERE (A.PracticeID=@practice_id AND (StartDKPracticeID>=@StartID AND EndDKPracticeID<=@EndID
		OR StartDKPracticeID < @StartID AND EndDKPracticeID BETWEEN @StartID AND @EndID
		OR StartDKPracticeID < @EndID AND EndDKPracticeID > @EndID) 
		OR A.PracticeID=@practice_id AND StartDKPracticeID < @StartID
		   AND Recurrence=1 AND RecurrenceStartDate<=@end_date AND (RangeEndDate >= dateadd(day, -1, @start_date) OR RangeType = 'N') )
			AND 
			(
				(@query_domain IS NULL OR @query IS NULL)
				OR (
					((@query_domain = 'Resource' AND ATR.AppointmentResourceTypeID = 1) OR @query_domain = 'All')
					AND (
						D.FirstName LIKE '%' + @query + '%' 
						OR D.LastName LIKE '%' + @query + '%'
						OR D.MiddleName LIKE '%' + @query + '%' 
						OR D.Prefix LIKE '%' + @query + '%' 
						OR D.Suffix LIKE '%' + @query + '%' 
							OR (D.FirstName + D.LastName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%' 
						OR (D.LastName + D.FirstName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%' 
							OR (D.FirstName + D.MiddleName + D.LastName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
					)
				)
				OR (
					((@query_domain = 'Resource' AND ATR.AppointmentResourceTypeID = 2) OR @query_domain = 'All')
					AND (
						PR.ResourceName LIKE '%' + @query + '%'
					)
				)
				OR (
					(@query_domain = 'Patient' OR @query_domain = 'All')
					AND (
						   (A.PatientID=CASE WHEN @ISINT=1 THEN CAST(@query AS INT) END OR @query='')
						OR P.FirstName LIKE '%' + @query + '%' 
						OR P.LastName LIKE '%' + @query + '%'
						OR P.MiddleName LIKE '%' + @query + '%' 
						OR P.Prefix LIKE '%' + @query + '%' 
						OR P.Suffix LIKE '%' + @query + '%' 
					        OR (P.FirstName + P.LastName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
						OR (P.LastName + P.FirstName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
					        OR (P.FirstName + P.MiddleName + P.LastName) LIKE  '%' + REPLACE(REPLACE(@query,' ',''),',','') + '%'
					)
				)
				OR (
					(@query_domain = 'Subject' OR @query_domain = 'All')
					AND (
						A.Subject LIKE '%' + @query + '%'
					)
				)
				OR (
					(@query_domain = 'Location' OR @query_domain = 'All')
					AND (
						SL.Name LIKE '%' + @query + '%'
					)
				)
				OR (
					(@query_domain = 'Notes' OR @query_domain = 'All')
					AND (
						A.Notes LIKE '%' + @query + '%'
					)
				)
				OR (
					(@query_domain = 'Reason' OR @query_domain = 'All')
					AND (
						AR.Name LIKE '%' + @query + '%'
					)
				)
				OR (
					(@query_domain = 'Status' OR @query_domain = 'All')
					AND (
						ACS.[Name] LIKE '%' + @query + '%'
					)
				)
				OR (
					(@query_domain = 'TicketNumber' OR @query_domain = 'All')
					AND (
						A.AppointmentID LIKE '%' + @query + '%'
					)
				)
			)

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

	INSERT INTO #t_appointment(AppointmentID, StartDate, EndDate, IsRecurring ,UniqueID)
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
	set	ServiceLocationName = t2.ServiceLocationName, 
		Subject = t2.Subject, 
		AppointmentType = t2.AppointmentType, 
		AppointmentTypeDescription = t2.AppointmentTypeDescription, 
		AppointmentConfirmationStatusCode = t2.AppointmentConfirmationStatusCode, 
		AppointmentConfirmationStatusDescription = t2.AppointmentConfirmationStatusDescription, 
		PatientPrefix = t2.PatientPrefix, 
		PatientFirstName = t2.PatientFirstName, 
		PatientMiddleName = t2.PatientMiddleName, 
		PatientLastName = t2.PatientLastName, 
		PatientSuffix = t2.PatientSuffix, 
		PrimaryReasonName = t2.PrimaryReasonName, 
		Resources = t2.Resources, 
		Deletable = t2.Deletable
	from	(select * from #t_appointment where IsRecurring = 1 and IsOriginalRecord = 1) t2
	where	#t_appointment.AppointmentID = t2.AppointmentID
	and	#t_appointment.IsRecurring = 1

	-- Remove recurring appointment exceptions from our temp table
	DELETE t
	FROM #t_appointment t INNER JOIN AppointmentRecurrenceException ARE
	ON t.AppointmentID=ARE.AppointmentID AND CONVERT(CHAR(10),t.StartDate)=CONVERT(CHAR(10),ARE.ExceptionDate)
	WHERE IsRecurring=1

	-- Insert it into a different temp table so we can create a valid RID
	INSERT
	INTO #t_appointment_return(
		TicketNumber,
		AppointmentID,
		ServiceLocationName, 
		Subject,
		StartDate, 
		EndDate, 
		AppointmentType, 
		AppointmentTypeDescription, 
		AppointmentConfirmationStatusCode,
		AppointmentConfirmationStatusDescription,
		PatientPrefix, 
		PatientFirstName, 
		PatientMiddleName, 
		PatientLastName, 
		PatientSuffix, 
		PrimaryReasonName, 
		Deletable, 
		IsRecurring, 
		UniqueID
	)
	SELECT
		dbo.AppointmentDataProvider_GetTicketNumber(AppointmentID, StartDate, IsRecurring),
		AppointmentID,
		ServiceLocationName, 
		Subject,
		StartDate, 
		EndDate, 
		AppointmentType, 
		AppointmentTypeDescription, 
		AppointmentConfirmationStatusCode,
		AppointmentConfirmationStatusDescription,
		PatientPrefix, 
		PatientFirstName, 
		PatientMiddleName, 
		PatientLastName, 
		PatientSuffix, 
		PrimaryReasonName, 
		Deletable, 
		IsRecurring, 
		UniqueID
	FROM	#t_appointment
	WHERE	
		StartDate < @end_date
		AND	EndDate > @start_date
		AND ( (@appointment_type = 'All') 
			OR ((@appointment_type = 'Other') AND (AppointmentType = 'O'))
			OR ((@appointment_type = 'Patient') AND (AppointmentType = 'P')) )
	ORDER BY
		StartDate, 
		EndDate


	SELECT @totalRecords = COUNT(*)
	FROM #t_appointment_return

	-- Create the resources string for any of the records we are to return
	DECLARE @ResourcesList varchar(1024)
	DECLARE @i int

	SET @i = @startRecord

	WHILE @i <= @maxRecords + @startRecord
	BEGIN
		SELECT 		@ResourcesList = COALESCE(@ResourcesList + ', ', '') + 
				CASE 
				   WHEN ATR.AppointmentResourceTypeID = 1 THEN
					LTRIM(ISNULL(D.Prefix + ' ','')) + RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + RTRIM(ISNULL(D.Suffix + ' ','') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), ''))
				   WHEN ATR.AppointmentResourceTypeID = 2 THEN
					Pr.ResourceName
				END
		FROM 		#t_appointment_return T
		INNER JOIN 	AppointmentToResource ATR WITH(NOLOCK) 
		ON		   ATR.AppointmentID = T.AppointmentID
		LEFT OUTER JOIN Doctor D 
		ON 		   D.DoctorID = ATR.ResourceID 
		AND 		   ATR.AppointmentResourceTypeID = 1
		LEFT OUTER JOIN PracticeResource PR 
		ON 		   PR.PracticeResourceID = ATR.ResourceID 
		AND 		   ATR.AppointmentResourceTypeID = 2
		WHERE 		T.RID = @i
	
		UPDATE		#t_appointment_return
		SET		Resources = @ResourcesList
		WHERE		RID = @i

		SET @i = @i + 1
		SET @ResourcesList = null
	END

	SELECT 	*
	FROM #t_appointment_return T
	WHERE RID BETWEEN @startRecord AND (@startRecord + @maxRecords - 1)

	DROP TABLE #t_appointment
	DROP TABLE #t_appointment_return
	RETURN
END

