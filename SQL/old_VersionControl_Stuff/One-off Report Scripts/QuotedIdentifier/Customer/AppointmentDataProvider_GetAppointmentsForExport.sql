SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
IF EXISTS(SELECT * FROM dbo.sysobjects s WHERE s.name = 'AppointmentDataProvider_GetAppointmentsForExport')
	DROP PROCEDURE AppointmentDataProvider_GetAppointmentsForExport
	
GO

CREATE PROCEDURE dbo.AppointmentDataProvider_GetAppointmentsForExport
	@practice_id INT,
	@appointment_resource_type_id INT = null, 
	@resource_id INT = null, 
	@service_location_id INT = null,
	@start_date DATETIME = null,
	@end_date DATETIME = null,
	@payer_scenario_id INT = null,
	@appointment_id INT = null,
	@patient_id INT = null

AS
BEGIN
	SET NOCOUNT ON

	DECLARE @MinID INT, @MaxID INT, @StartID INT, @EndID INT

	DECLARE @Qry TABLE(MinID INT, MaxID INT, StartID INT, EndID INT)
	INSERT @Qry(MinID, MaxID, StartID, EndID)
	SELECT MIN(MinDKPracticeID) MinID, MAX(MaxDKPracticeID), MIN(DKPracticeID) StartID, MAX(DKPracticeID) EndID
	FROM DateKeyToPractice
	WHERE PracticeID=@practice_id AND 
	Dt BETWEEN CAST(CONVERT(CHAR(10),@start_date,110) AS DATETIME) AND CAST(CONVERT(CHAR(10),@end_date,110) AS DATETIME)

	SELECT @MinID=MinID, @MaxID=MaxID, @StartID=StartID, @EndID=EndID
	FROM @Qry

	IF @Resource_ID IS NOT NULL
	BEGIN
		INSERT	##t_appointment(
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
		PatientPrefix, 
		PatientFirstName, 
		PatientMiddleName, 
		PatientLastName, 
		PatientSuffix, 
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
			P.Prefix AS PatientPrefix, 
			P.FirstName AS PatientFirstName,
			P.MiddleName AS PatientMiddleName,
			P.LastName AS PatientLastName,
			P.Suffix AS PatientSuffix, 
			AR.DefaultColorCode as Color, 
			AR.Name as PrimaryReason,
			cast(A.AppointmentID as varchar(32)) as UniqueID, 
			Recurrence IsRecurring, 
			1 IsOriginalRecord,
			PC.PayerScenarioID
		FROM
			Appointment A WITH (NOLOCK)
			INNER JOIN AppointmentToResource ATR WITH (NOLOCK) ON A.AppointmentID=ATR.AppointmentID
			LEFT OUTER JOIN Patient P ON P.PracticeID = @practice_id AND P.PatientID = A.PatientID
			LEFT OUTER JOIN AppointmentToAppointmentReason ATAR ON ATAR.PracticeID=A.PracticeID AND ATAR.AppointmentID = A.AppointmentID AND ATAR.PrimaryAppointment = 1
			LEFT OUTER JOIN AppointmentReason AR ON AR.AppointmentReasonID = ATAR.AppointmentReasonID
			LEFT OUTER JOIN PatientCase PC ON PC.PracticeID = @Practice_ID AND PC.PatientID = A.PatientID AND PC.PatientCaseID = A.PatientCaseID
		WHERE (A.PracticeID=@practice_id AND (StartDKPracticeID>=@StartID AND EndDKPracticeID<=@EndID
		OR StartDKPracticeID BETWEEN @MinID AND @StartID AND EndDKPracticeID BETWEEN @StartID AND @EndID
		OR StartDKPracticeID BETWEEN @MinID AND @EndID AND EndDKPracticeID >=@EndID) 
		OR A.PracticeID=@practice_id AND StartDKPracticeID >=@MinID AND StartDKPracticeID<@StartID
		   AND Recurrence=1 AND RecurrenceStartDate<=@end_date AND (RangeEndDate >= dateadd(day, -1, @start_date) OR RangeType = 'N') )
		AND A.AppointmentConfirmationStatusCode <> 'X'		-- case 3884
		AND (A.ServiceLocationID = @service_location_id or @service_location_id IS NULL)			
		AND (A.PatientID = @patient_id or @patient_id is null)
		AND (A.AppointmentID = @appointment_id or @appointment_id is null)
		AND (ATR.ResourceID=@resource_id)
		AND (ATR.AppointmentResourceTypeID=@appointment_resource_type_id OR @appointment_resource_type_id IS NULL)
		AND (PC.PayerScenarioID = @payer_scenario_id or @payer_scenario_id is null)

		-- Get the first resource for any appointments

		UPDATE		T
		SET		Resources = LTRIM(ISNULL(D.Prefix + ' ','')) + RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + RTRIM(ISNULL(D.Suffix + ' ','') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), '')),
				HasDefaultEncounterTemplate = CASE WHEN D.DefaultEncounterTemplateID IS NULL THEN 0 ELSE 1 END,
				ProviderID=D.DoctorID
		FROM		##t_appointment T
		INNER JOIN	Doctor D
		ON		   D.PracticeID=@Practice_ID AND D.DoctorID = @Resource_ID
	END
	ELSE
	BEGIN
		INSERT	##t_appointment(
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
		PatientPrefix, 
		PatientFirstName, 
		PatientMiddleName, 
		PatientLastName, 
		PatientSuffix, 
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
			P.Prefix AS PatientPrefix, 
			P.FirstName AS PatientFirstName,
			P.MiddleName AS PatientMiddleName,
			P.LastName AS PatientLastName,
			P.Suffix AS PatientSuffix, 
			AR.DefaultColorCode as Color, 
			AR.Name as PrimaryReason,
			cast(A.AppointmentID as varchar(32)) as UniqueID, 
			0 IsRecurring, 
			1 IsOriginalRecord,
			PC.PayerScenarioID
		FROM
			Appointment A
			LEFT OUTER JOIN Patient P ON P.PracticeID = @practice_id AND P.PatientID = A.PatientID
			LEFT OUTER JOIN AppointmentToAppointmentReason ATAR ON ATAR.PracticeID=A.PracticeID AND ATAR.AppointmentID = A.AppointmentID AND ATAR.PrimaryAppointment = 1
			LEFT OUTER JOIN AppointmentReason AR ON AR.AppointmentReasonID = ATAR.AppointmentReasonID
			LEFT OUTER JOIN PatientCase PC ON PC.PracticeID = @Practice_ID AND PC.PatientID = A.PatientID AND PC.PatientCaseID = A.PatientCaseID
		WHERE (A.PracticeID=@practice_id AND (StartDKPracticeID>=@StartID AND EndDKPracticeID<=@EndID
		OR StartDKPracticeID BETWEEN @MinID AND @StartID AND EndDKPracticeID BETWEEN @StartID AND @EndID
		OR StartDKPracticeID BETWEEN @MinID AND @EndID AND EndDKPracticeID >=@EndID) 
		OR A.PracticeID=@practice_id AND StartDKPracticeID >=@MinID AND StartDKPracticeID<@StartID
		   AND Recurrence=1 AND RecurrenceStartDate<=@end_date AND (RangeEndDate >= dateadd(day, -1, @start_date) OR RangeType = 'N') )
		AND A.AppointmentConfirmationStatusCode <> 'X'		-- case 3884
		AND (A.ServiceLocationID = @service_location_id or @service_location_id IS NULL)			
		AND (A.PatientID = @patient_id or @patient_id is null)
		AND (A.AppointmentID = @appointment_id or @appointment_id is null)
		AND (PC.PayerScenarioID = @payer_scenario_id or @payer_scenario_id is null)

		-- Get the first resource for any appointments

		INSERT ##FirstResource(PracticeID, AppointmentID, AppointmentToResourceID)
		SELECT ATR.PracticeID, ATR.AppointmentID, MIN(ATR.AppointmentToResourceID) AppointmentToResourceID
		FROM AppointmentToResource ATR INNER JOIN ##t_appointment t
		ON ATR.AppointmentID=t.AppointmentID AND ATR.AppointmentResourceTypeID=1 AND ATR.PracticeID=t.PracticeID
		GROUP BY ATR.PracticeID, ATR.AppointmentID

		UPDATE		t
		SET		Resources = LTRIM(ISNULL(D.Prefix + ' ','')) + RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + RTRIM(ISNULL(D.Suffix + ' ','') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), '')),
				HasDefaultEncounterTemplate = CASE WHEN D.DefaultEncounterTemplateID IS NULL THEN 0 ELSE 1 END,
				ProviderID=D.DoctorID
		FROM		##t_appointment t INNER JOIN ##FirstResource FR
		ON t.AppointmentID=FR.AppointmentID
		INNER JOIN AppointmentToResource ATR
		ON FR.AppointmentID=ATR.AppointmentID AND FR.AppointmentToResourceID=ATR.AppointmentToResourceID AND ATR.AppointmentResourceTypeID=1 AND FR.PracticeID=ATR.PracticeID
		INNER JOIN Doctor D
		ON ATR.PracticeID=D.PracticeID AND ATR.ResourceID=D.DoctorID
	END

	-- For any appointments with more than one doctor create the resources string
	DECLARE @ResourcesList varchar(1024)
	DECLARE @HasDefaultEncounterTemplate bit
	DECLARE @appointmentID int
	DECLARE	@maxRecords int
	DECLARE @Loop int
	DECLARE @Counter int


	INSERT		##t_appointment_multiple_resources (AppointmentID)

	SELECT		ATR.AppointmentID
	FROM		AppointmentToResource ATR
	INNER JOIN	##t_appointment T
	ON		   T.AppointmentID = ATR.AppointmentID AND ATR.AppointmentResourceTypeID = 1
	WHERE		ATR.PracticeID=@Practice_ID
	GROUP BY	ATR.AppointmentID
	HAVING		COUNT(AppointmentToResourceID) > 1

	SET @Loop=@@ROWCOUNT
	SET @Counter=0

	INSERT ##ProviderList(AppointmentID, Prefix, FirstName, MiddleName, LastName, Suffix, Degree, DefaultEncounterTemplateID)
	SELECT T.AppointmentID, Prefix, FirstName, MiddleName, LastName, Suffix, Degree, DefaultEncounterTemplateID
	FROM 		##t_appointment_multiple_resources T
	INNER JOIN 	AppointmentToResource ATR
	ON		   ATR.PracticeID=@Practice_ID AND ATR.AppointmentID = T.AppointmentID
	INNER JOIN Doctor D 
	ON 		   D.PracticeID=@Practice_ID AND D.DoctorID = ATR.ResourceID 
	AND 		   ATR.AppointmentResourceTypeID = 1

	WHILE @Counter<@Loop
	BEGIN
		SET @Counter=@Counter+1
		SELECT @appointmentID=AppointmentID
		FROM ##t_appointment_multiple_resources
		WHERE TID=@Counter

		SELECT 		@ResourcesList = COALESCE(@ResourcesList + ', ', '') + 
					LTRIM(ISNULL(Prefix + ' ','')) + RTRIM(ISNULL(FirstName + ' ','') + ISNULL(MiddleName + ' ', '')) + ISNULL(' ' + LastName,'') + RTRIM(ISNULL(Suffix + ' ','') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(Degree), '')),
				@HasDefaultEncounterTemplate = CASE WHEN DefaultEncounterTemplateID IS NULL THEN 0 ELSE 1 END
		FROM ##ProviderList
		Where AppointmentID=@appointmentID
	
		UPDATE		T
		SET		Resources = @ResourcesList,
				HasDefaultEncounterTemplate = HasDefaultEncounterTemplate | @HasDefaultEncounterTemplate
		FROM ##t_appointment T
		WHERE		AppointmentID = @appointmentID

		SET @ResourcesList = null

	END

	-- Get Recurrences whose original appointment starts within @start_date and @end_date
	-- This list will be deleted, because the insert recurrence will cause a duplicate
	INSERT ##InitialReccurrencesToDelete(AppointmentID, StartDate)
	SELECT AppointmentID, StartDate
	FROM ##t_Appointment
	WHERE IsRecurring=1 AND StartDate BETWEEN @start_date AND @end_Date

	-- Insert the recurring appointments into our temp table
	INSERT ##Recurrences(AppointmentID, StartDate, EndDate, RecurringStartDate, RecurringEndDate, Type, DailyNumDays, DailyType, WeeklyNumWeeks, WeeklyOnSunday,
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
		##t_appointment A
	INNER JOIN 
		AppointmentRecurrence AR 
	ON 	   AR.AppointmentID = A.AppointmentID

	UPDATE R SET DKID=DK.DKID
	FROM DateKey DK INNER JOIN ##Recurrences R
	ON DK.Dt=CAST(CONVERT(CHAR(10),R.StartDate,110) AS DATETIME)
	WHERE Type='D' AND DailyType='X'

	UPDATE R SET WK=DK.WK
	FROM DateKey DK INNER JOIN ##Recurrences R
	ON DK.Dt=CAST(CONVERT(CHAR(10),R.StartDate,110) AS DATETIME)
	WHERE Type='W'

	UPDATE R SET MoID=DK.MoID
	FROM DateKey DK INNER JOIN ##Recurrences R
	ON DK.Dt=CAST(CONVERT(CHAR(10),R.StartDate,110) AS DATETIME)
	WHERE Type='M'	

	INSERT ##t_appointment(AppointmentID, StartDate, EndDate, IsRecurring, UniqueID)
	SELECT R.AppointmentID, 
	CONVERT(CHAR(10),DK.Dt,110)+' '+CAST(DATEPART(hh,R.StartDate) AS VARCHAR(2))+':'+CAST(DATEPART(mi,R.StartDate) AS VARCHAR(2)) StartDate,
	CONVERT(CHAR(10),DK.Dt,110)+' '+CAST(DATEPART(hh,R.EndDate) AS VARCHAR(2))+':'+CAST(DATEPART(mi,R.EndDate) AS VARCHAR(2)) EndDate,
	1 IsRecurring, CAST(AppointmentID AS VARCHAR)+'-'+CONVERT(CHAR(10),DK.Dt,110) UniqueID
	FROM DateKey DK INNER JOIN ##Recurrences R
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
	FROM ##t_Appointment t INNER JOIN ##InitialReccurrencesToDelete IRTD
	ON t.AppointmentID=IRTD.AppointmentID AND t.StartDate=IRTD.StartDate AND IsOriginalRecord IS NULL

	-- Update the rest of the information for the recurring appointments with the original appointment info
	update	t
	set	PatientID = t2.PatientID, 
		ServiceLocationID = t2.ServiceLocationID, 
		Subject = t2.Subject, 
		AppointmentType = t2.AppointmentType, 
		Notes = t2.Notes,
		AppointmentConfirmationStatusCode = t2.AppointmentConfirmationStatusCode,
		AllDay = t2.AllDay, 
		PatientPrefix = t2.PatientPrefix, 
		PatientFirstName = t2.PatientFirstName, 
		PatientMiddleName = t2.PatientMiddleName, 
		PatientLastName = t2.PatientLastName, 
		PatientSuffix = t2.PatientSuffix, 
		Color = t2.Color,
		PrimaryReason = t2.PrimaryReason,
		Resources = t2.Resources,
		HasDefaultEncounterTemplate = t2.HasDefaultEncounterTemplate,
		PayerScenarioID = t2.PayerScenarioID
	from	##t_Appointment t INNER JOIN (select * from ##t_appointment where IsRecurring = 1 and IsOriginalRecord = 1) t2
	ON	t.AppointmentID = t2.AppointmentID
	and	t.IsRecurring = 1

	-- Remove recurring appointment exceptions from our temp table
	DELETE t
	FROM ##t_appointment t INNER JOIN AppointmentRecurrenceException ARE
	ON t.AppointmentID=ARE.AppointmentID AND CONVERT(CHAR(10),t.StartDate,110)=CONVERT(CHAR(10),ARE.ExceptionDate,110)
	WHERE IsRecurring=1

	select	PatientID, 
		CONVERT(char(10), StartDate, 101) AS ApptDate,
		LEFT(CONVERT(char(12), StartDate, 114),5) AS ApptTime, 
		AppointmentConfirmationStatusCode AS Status, 
		ProviderID,
		ServiceLocationID AS LocationID, 
		PrimaryReason AS VisitType,
		AppointmentID
	from	##t_appointment
	where	StartDate <= @end_date		-- This drops off any of the recurring appointments we added that we don't need anymore
	and	EndDate >= @start_date AND ISNULL(PatientID,0)>0
	ORDER BY AppointmentID

	DROP TABLE ##t_appointment
	DROP TABLE ##FirstResource
	DROP TABLE ##t_appointment_multiple_resources
	DROP TABLE ##ProviderList 
	DROP TABLE ##InitialReccurrencesToDelete
	DROP TABLE ##Recurrences
END

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON 
GO
