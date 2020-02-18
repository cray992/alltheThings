/**********************************************************************************************
** Name		: ReportDataProvider_AppointmentsSummary
**
** Desc         : Gets data from the Appointment table by the date range for the calendar screen. The @TimeOffset passed in
**		  will add that many hours to the start and end times before returning the values. The @BeginDate and @EndDate
**		  should be in the same converted for PST format as the data in the database.
**
** Test		: ReportDataProvider_AppointmentsSummary 19, @TimeOffset = 3
**		: ReportDataProvider_AppointmentsSummary 41, @BeginDate='6/13/2005', @EndDate='6/14/2005', @TimeOffset=3
** 		: ReportDataProvider_AppointmentsSummary 19, @BeginDate='6/13/2005', @EndDate='6/18/2005', @TimeOffset=3
**		: ReportDataProvider_AppointmentsSummary 19, @AppointmentResourceTypeID=1, @ResourceID=36
** 		: ReportDataProvider_AppointmentsSummary 19, @BeginDate='11/4/2005', @EndDate='11/5/2005', @PatientID=199555
***********************************************************************************************/

IF EXISTS ( SELECT	* FROM	SYSOBJECTS WHERE	Name = 'ReportDataProvider_AppointmentsSummary' AND	TYPE = 'P' ) DROP PROCEDURE dbo.ReportDataProvider_AppointmentsSummary

GO


CREATE PROCEDURE dbo.ReportDataProvider_AppointmentsSummary
	@PracticeID int = NULL,
	@AppointmentResourceTypeID int = NULL, 
	@ResourceID int = NULL,
	@PatientID int = NULL,
	@Status varchar(64) = NULL,
	@BeginDate datetime = NULL,
	@EndDate datetime = NULL, 
	@TimeOffset int = 0,
	@ServiceLocationID INT = -1
AS

/*
DECLARE
	@PracticeID int,
	@AppointmentResourceTypeID int, 
	@ResourceID int,
	@PatientID int,
	@Status varchar(64),
	@BeginDate datetime,
	@EndDate datetime, 
	@TimeOffset int,
	@ServiceLocationID INT
SELECT
	@PracticeID  = 65,
	@AppointmentResourceTypeID  = NULL, 
	@ResourceID  = NULL,
	@PatientID  = NULL,
	@Status  = 'Z',
	@BeginDate  = '5/1/06',
	@EndDate  = '5/1/06 23:59', 
	@TimeOffset  = 0,
	@ServiceLocationID = -1
*/
BEGIN
	declare @count int
	
	IF @Status='A'
	BEGIN
		SELECT @Status=NULL
	END

	CREATE TABLE #t_appointment_temp(
		AppointmentID int, 
		Name varchar(256), 
		SortName varchar(64), 
		StartDate datetime, 
		EndDate datetime, 
		AllDay bit, 
		PatientID int,
		PatientName varchar(256), 
		PatientSort varchar(64), 
		Subject varchar(64),
		AppointmentType varchar(1), 
		PatientNumber varchar(10),
		ServiceLocationName varchar(128), 
		Reasons varchar(1024), 
		Status varchar(64), 
		Notes text,
		IsRecurring bit, 
		UniqueID varchar(32),
		IsOriginalRecord bit,
		HasMultipleReasons bit,
		RID int IDENTITY(0,1),
		Copay money,
		Precedence int
	)


	CREATE TABLE #t_appointment_return(
		AppointmentID int, 
		Name varchar(256), 
		SortName varchar(64), 
		StartDate datetime, 
		EndDate datetime, 
		AllDay bit, 
		PatientID int,
		PatientName varchar(256), 
		PatientSort varchar(64), 
		Subject varchar(64),
		AppointmentType varchar(1), 
		PatientNumber varchar(10),
		ServiceLocationName varchar(128), 
		Reasons varchar(1024), 
		Status varchar(64), 
		Notes text,
		IsRecurring bit, 
		UniqueID varchar(32),
		IsOriginalRecord bit,
		Copay money,
		Precedence int
	)


	INSERT
	INTO #t_appointment_temp(
		AppointmentID, 
		Name, 
		SortName, 
		StartDate, 
		EndDate, 
		AllDay, 
		PatientID,
		PatientName, 
		PatientSort, 
		Subject,
		AppointmentType, 
		PatientNumber,
		ServiceLocationName, 
		Reasons, 
		Status, 
		Notes,
		IsRecurring, 
		IsOriginalRecord, 
		UniqueID,
		Copay,
		Precedence
	)
	SELECT
		A.AppointmentID				as AppointmentID, 
		CASE 
		   WHEN ATR.AppointmentResourceTypeID = 1 THEN
			LTRIM(ISNULL(D.Prefix + ' ','')) + RTRIM(ISNULL(D.FirstName + ' ','') + ISNULL(D.MiddleName + ' ', '')) + ISNULL(' ' + D.LastName,'') + RTRIM(ISNULL(D.Suffix + ' ','') + ISNULL(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree), ''))			
		   WHEN ATR.AppointmentResourceTypeID = 2 THEN
			Pr.ResourceName
		END 					as Name, 
		CASE 
		   WHEN ATR.AppointmentResourceTypeID = 1 THEN
			D.LastName
		   WHEN ATR.AppointmentResourceTypeID = 2 THEN
			Pr.ResourceName
		END 					as SortName, 		
		A.StartDate				as StartDate,
		A.EndDate				as EndDate,
		A.AllDay				as AllDay, 
		P.PatientID				as PatientID,
		LTRIM(COALESCE(P.Prefix + ' ','')) +
		   LTRIM(COALESCE(P.FirstName + ' ','')) + 
		   LTRIM(COALESCE(P.MiddleName + ' ','')) + 
		   LTRIM(COALESCE(P.LastName + ' ','')) + 
		   LTRIM(COALESCE(P.Suffix,'')) 	as PatientName, 
		P.LastName				as PatientSort, 
		A.Subject				as Subject,
		A.AppointmentType			as AppointmentType, 
		P.HomePhone				as PatientNumber,
		SL.Name 				as ServiceLocationName,
		AR.Name					as Reasons,
		ACS.Name				as Status, 
		A.Notes					as Notes,
		case 
		   when ARE.AppointmentID is null then
			cast(0 as bit) 
		   else
			cast(1 as bit)
		end 					as IsRecurring, 
		cast(1 as bit) 				as IsOriginalRecord, 
		CAST(A.AppointmentID as varchar(32)) 	as UniqueID,
		IP.Copay, 
		IP.Precedence
	FROM
		Appointment A
		INNER JOIN 	AppointmentType AT 	ON AT.AppointmentType = A.AppointmentType			-- Used to make sure this is a valid appointment type
		INNER JOIN	AppointmentConfirmationStatus ACS ON ACS.AppointmentConfirmationStatusCode = A.AppointmentConfirmationStatusCode		-- Used to get the appointment confirmation status name
		INNER JOIN	AppointmentToResource ATR ON ATR.AppointmentID = A.AppointmentID	-- Used to get or limit by resource		
			AND	(ATR.AppointmentResourceTypeID = @AppointmentResourceTypeID or @AppointmentResourceTypeID is null)
			AND	(ATR.ResourceID = @ResourceID or @ResourceID is null)
		LEFT OUTER JOIN Doctor D ON D.PracticeID = @PracticeID AND D.DoctorID = ATR.ResourceID -- Used to get provider name
			AND ATR.AppointmentResourceTypeID = 1
		LEFT OUTER JOIN PracticeResource PR ON PR.PracticeResourceID = ATR.ResourceID AND ATR.AppointmentResourceTypeID = 2 -- Used to get practice resource name
		LEFT OUTER JOIN Patient P ON P.PracticeID = @PracticeID AND P.PatientID = A.PatientID				-- Used to get patient name and number
		LEFT OUTER JOIN AppointmentToAppointmentReason ATAR ON ATAR.AppointmentID = A.AppointmentID	-- Used to get the primary reason
			AND ATAR.PrimaryAppointment = 1
		LEFT OUTER JOIN AppointmentReason AR ON AR.AppointmentReasonID = ATAR.AppointmentReasonID -- Used to get the reason name
		LEFT OUTER JOIN	ServiceLocation SL	ON SL.PracticeID = @PracticeID -- Used to get the service location name
			AND	SL.ServiceLocationID = A.ServiceLocationID
		LEFT OUTER JOIN AppointmentRecurrence ARE ON ARE.AppointmentID = A.AppointmentID
		LEFT OUTER JOIN PatientCase PC ON pc.PracticeID = @PracticeID AND A.PatientCaseID = PC.PatientCaseID 
		LEFT JOIN InsurancePolicy IP ON IP.PracticeID = @PracticeID AND PC.PatientCaseID = IP.PatientCaseID
	WHERE
		A.PracticeID = @PracticeID
		AND (@ServiceLocationID = -1 OR SL.ServiceLocationID = @ServiceLocationID )
		AND ((@Status <> 'Z' AND A.AppointmentConfirmationStatusCode = @Status) or @Status is null
				or (@Status = 'Z' AND A.AppointmentConfirmationStatusCode<>'X'))
		-- This is to limit by the start and end dates.
		AND ((A.StartDate >= @BeginDate OR @BeginDate IS NULL)
		AND (A.EndDate <= @EndDate OR @EndDate IS NULL)
		AND (A.PatientID = @PatientID or @PatientID is null)
		
-- start copay column condition
		
		AND (
		(IP.Copay IS NOT NULL 
		AND IP.Precedence = 
		[dbo].[fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence](
		A.PatientCaseID, A.StartDate,0))
		OR (IP.Copay IS NULL OR ([dbo].[fn_InsuranceDataProvider_GetMinInsurancePolicyPrecedence](
		A.PatientCaseID, A.StartDate,0)) IS NULL ))
		
-- end copay column condition
		OR  (A.StartDate <= @BeginDate AND A.EndDate >= @BeginDate AND A.EndDate <= @EndDate)-- gets appointments starting in previous day
		OR  (A.StartDate <= @EndDate AND A.EndDate >= @EndDate) 				-- gets appointments starting in previous day
		OR  (A.StartDate <= @EndDate AND (ARE.RangeEndDate >= @BeginDate OR ARE.RangeType = 'N')))			-- gets recurring appointments that end anytime after the start date



----------------------------------------------------------------------------------
--Handle displaying multiple reasons
----------------------------------------------------------------------------------

	-- Mark the records that have multiple reasons
	CREATE TABLE #multiple_reasons(
		AppointmentID int, cntReason INT, Reasons varchar(1024), 
	)

	INSERT	#multiple_reasons( AppointmentID, cntReason)
	SELECT	ATAR.AppointmentID, COUNT(distinct ATAR.AppointmentToAppointmentReasonID)
	FROM	AppointmentToAppointmentReason ATAR,  #t_appointment_temp A
	WHERE A.AppointmentID = ATAR.AppointmentID
	GROUP BY ATAR.AppointmentID
	HAVING	COUNT(distinct ATAR.AppointmentToAppointmentReasonID) > 1


	SELECT 
		IDENTITY(int) rowid,
		T.AppointmentID,
		Reasons = AR.Name,
		maxRow = Cast(Null as INT)
	INTO #Reasons
	FROM  #multiple_reasons T 
		INNER JOIN AppointmentToAppointmentReason ATAR ON ATAR.AppointmentID = T.AppointmentID 			-- Used to get the reasons
		LEFT OUTER JOIN AppointmentReason AR ON AR.AppointmentReasonID = ATAR.AppointmentReasonID		-- Used to get the reason name
	Group by T.AppointmentID, AR.Name


	Update r
	set Reasons = COALESCE(r.Reasons + ', ', '') + r2.Reasons,
		maxRow = r2.rowid
	FROM #Reasons r 
		INNER JOIN #Reasons r2 on r.AppointmentID = r2.AppointmentID AND r.rowid < r2.rowid
		INNER JOIN #multiple_reasons m on m.AppointmentID = r.AppointmentID
	where m.CntReason = 2



	UPDATE	T
	SET	HasMultipleReasons = 1,
		Reasons = r.Reasons
	FROM	#t_appointment_temp T
		INNER JOIN #multiple_reasons M ON M.AppointmentID = T.AppointmentID
		LEFT JOIN #Reasons r on r.AppointmentID = T.AppointmentID and maxrow is not null


	DELETE #Reasons
	FROM #multiple_reasons m
	WHERE #Reasons.AppointmentID = m.AppointmentID
		AND CntReason = 2

	DELETE #multiple_reasons
	WHERE CntReason = 2




	-- Loop through each appointment that has 3 or more multiple reasons to create the reasons string
	DECLARE @i int
	DECLARE @id int
	DECLARE @ReasonsList varchar(1024)


	SELECT	@count = count(AppointmentID)
	FROM	#multiple_reasons

	set	@i = 1

	SELECT	@id = min(AppointmentID)
	FROM	#multiple_reasons

	WHILE @i <= @count
	BEGIN
		-- Create the reasons string for the current appointment record	
		SELECT 		@ReasonsList = COALESCE(@ReasonsList + ', ', '') + r.Reasons
		FROM #multiple_reasons T 
			INNER JOIN #Reasons r on t.AppointmentID = r.AppointmentID
		WHERE		T.AppointmentID = @id


		-- Update the reasons string for the appointment
		UPDATE		#multiple_reasons
		SET		Reasons = @ReasonsList
		WHERE		AppointmentID = @id

		SET	@ReasonsList = NULL
		SET	@i = @i + 1

		SELECT	@id = min(AppointmentID)
		FROM	#multiple_reasons
		WHERE	AppointmentID > @id
	END


	UPDATE	T
	SET	HasMultipleReasons = 1,
		Reasons = M.Reasons
	FROM	#t_appointment_temp T
		INNER JOIN #multiple_reasons M ON M.AppointmentID = T.AppointmentID


	DROP TABLE #Reasons
	DROP TABLE #multiple_reasons

	



----------------------------------------------------------------------------------
--Finish handle displaying multiple reasons
----------------------------------------------------------------------------------

	-- Insert the non-recurring appointments directly to the return temp table since there is nothing to process
	insert into
		#t_appointment_return
		(AppointmentID, 
		Name, 
		SortName, 
		StartDate, 
		EndDate, 
		AllDay, 
		PatientID,
		PatientName, 
		PatientSort, 
		Subject,
		AppointmentType, 
		PatientNumber,
		ServiceLocationName, 
		Reasons, 
		Status, 
		Notes,
		IsRecurring, 
		IsOriginalRecord, 
		UniqueID,
		Copay ,
		Precedence)
	select	AppointmentID, 
		Name, 
		SortName, 
		StartDate, 
		EndDate, 
		AllDay, 
		PatientID,
		PatientName, 
		PatientSort, 
		Subject,
		AppointmentType, 
		PatientNumber,
		ServiceLocationName, 
		Reasons, 
		Status, 
		Notes,
		IsRecurring, 
		IsOriginalRecord, 
		UniqueID,
		Copay,
		Precedence
	from	#t_appointment_temp
	where	IsRecurring = 0

	delete	from
		#t_appointment_temp
	where	IsRecurring = 0




------------ Expands Recurring Appointments -----------------

	-- Get Recurrences whose original appointment starts within @start_date and @end_date
	-- This list will be deleted, because the insert recurrence will cause a duplicate
	SELECT AppointmentID, StartDate
	INTO #InitialReccurrencesToDelete
	FROM #t_appointment_temp
	WHERE IsRecurring=1



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
		CASE WHEN @BeginDate > CAST(CONVERT(CHAR(10),A.StartDate,110) AS DATETIME) THEN
						@BeginDate
				      	ELSE
						CAST(CONVERT(CHAR(10),A.StartDate,110) AS DATETIME)
				      	END RecurringStartDate,
		CASE WHEN AR.RangeType = 'N' or @Enddate < CAST(CONVERT(CHAR(10),AR.RangeEndDate,110) AS DATETIME) THEN
						dateadd(second, -1, dateadd(Day, 1, @Enddate))
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
		#t_appointment_temp A
	INNER JOIN AppointmentRecurrence AR ON AR.AppointmentID = A.AppointmentID

	UPDATE R SET DKID=DK.DKID
	FROM DateKey DK INNER JOIN #Recurrences R
	ON DK.Dt=CAST(CONVERT(CHAR(10),R.StartDate,110) AS DATETIME)
	WHERE Type='D' AND DailyType='X'

	UPDATE R SET WK=DK.WK
	FROM DateKey  DK INNER JOIN #Recurrences R
	ON DK.Dt=CAST(CONVERT(CHAR(10),R.StartDate,110) AS DATETIME)
	WHERE Type='W'

	UPDATE R SET MoID=DK.MoID
	FROM DateKey DK INNER JOIN #Recurrences R
	ON DK.Dt=CAST(CONVERT(CHAR(10),R.StartDate,110) AS DATETIME)
	WHERE Type='M'	



	INSERT INTO #t_appointment_temp(AppointmentID, StartDate, EndDate, IsRecurring, UniqueID)
	SELECT R.AppointmentID, 
	CONVERT(CHAR(10),DK.Dt,110)+' '+CAST(DATEPART(hh,R.StartDate) AS VARCHAR(2))+':'+CAST(DATEPART(mi,R.StartDate) AS VARCHAR(2)) StartDate,
	CONVERT(CHAR(10),DK.Dt,110)+' '+CAST(DATEPART(hh,R.EndDate) AS VARCHAR(2))+':'+CAST(DATEPART(mi,R.EndDate) AS VARCHAR(2)) EndDate,
	1 IsRecurring, CAST(AppointmentID AS VARCHAR)+'-'+CONVERT(CHAR(10),DK.Dt, 101) UniqueID
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



	-- Update the rest of the information for the recurring appointments with the original appointment info
		-- Update the rest of the information for the recurring appointments with the original appointment info
		update	#t_appointment_temp
		set	Name = t2.Name, 
			SortName = t2.SortName, 
			AllDay = t2.AllDay,
			PatientID = t2.PatientID,
			PatientName = t2.PatientName, 
			PatientSort = t2.PatientSort, 
			Subject = t2.Subject, 
			AppointmentType = t2.AppointmentType, 
			PatientNumber = t2.PatientNumber, 
			ServiceLocationName = t2.ServiceLocationName,
			Reasons = t2.Reasons, 
			Status = t2.Status,
			Notes = t2.Notes
		from	(select * from #t_appointment_temp where IsRecurring = 1 and IsOriginalRecord = 1) t2
		where	#t_appointment_temp.AppointmentID = t2.AppointmentID
		and	#t_appointment_temp.IsRecurring = 1


	--Delete duplicate Recurring Appointments
	DELETE t
	FROM #t_appointment_temp t INNER JOIN #InitialReccurrencesToDelete IRTD
	ON t.AppointmentID=IRTD.AppointmentID AND t.StartDate=IRTD.StartDate AND IsOriginalRecord IS NULL


	-- Remove recurring appointment exceptions from our temp table
	DELETE t
	FROM #t_appointment_temp t 
		INNER JOIN AppointmentRecurrenceException ARE ON t.AppointmentID=ARE.AppointmentID
	WHERE IsRecurring=1 
		AND dbo.fn_DateOnly(t.StartDate) = dbo.fn_DateOnly(ARE.ExceptionDate)
		AND @Status  <> 'X'
		


	-- Copy all in the main temp table to the return temp table
	insert into
		#t_appointment_return
	select			
		AppointmentID, 
		Name, 
		SortName, 
		StartDate, 
		EndDate, 
		AllDay, 
		PatientID,
		PatientName, 
		PatientSort, 
		Subject,
		AppointmentType, 
		PatientNumber,
		ServiceLocationName, 
		Reasons, 
		Status, 
		Notes,
		IsRecurring, 
		UniqueID,
		IsOriginalRecord,
		Copay,
		Precedence 
	from	#t_appointment_temp
------------ End of Expands Recurring Appointments -----------------





	select 	AppointmentID, 
		NAME,
		SortName, 
		dateadd(hour, @TimeOffset, StartDate) as StartDate, 
		dateadd(hour, @TimeOffset, EndDate) as EndDate, 
		AllDay, 
		PatientID,
		PatientName, 
		PatientSort, 
		Subject,
		AppointmentType, 
		PatientNumber,
		ServiceLocationName, 
		Reasons, 
		Status, 
		Notes,
		IsRecurring, 
		UniqueID,
		IsOriginalRecord,
		Copay,
		Precedence 
	from	#t_appointment_return
	where	StartDate <= @EndDate
	and	EndDate >= @BeginDate

	DROP TABLE #t_appointment_temp
	DROP TABLE #t_appointment_return
	DROP TABLE #InitialReccurrencesToDelete, #Recurrences



END
GO
