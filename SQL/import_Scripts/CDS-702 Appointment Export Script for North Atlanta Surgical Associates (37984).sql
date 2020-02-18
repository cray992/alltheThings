USE superbill_37984_dev
GO

DECLARE @PracticeID INT

SET @PracticeID = 1

SELECT
a.PracticeID ,
a.appointmentid AS [id] ,
p.FirstName + ' ' + p.MiddleName + ' ' + p.LastName AS [patientname] ,
CASE WHEN Reas1.AppointmentID IS NOT NULL THEN ar1.Name ELSE '' END AS [Reason1] ,
CASE WHEN Reas2.AppointmentID IS NOT NULL THEN ar2.Name ELSE '' END AS [Reason2] ,
--CASE WHEN Reas3.AppointmentID IS NOT NULL THEN ar3.Name END AS [Reason3] ,
--CASE WHEN Reas4.AppointmentID IS NOT NULL THEN ar4.Name END AS [Reason4] ,
CASE WHEN Res1.AppointmentID IS NOT NULL THEN CASE WHEN Res1.AppointmentResourceTypeID = 1 THEN d1.FirstName + ' ' + d1.LastName 
												   WHEN Res1.AppointmentResourceTypeID = 2 THEN pr1.ResourceName ELSE '' END ELSE '' END AS [Resource1] ,
CASE WHEN Res2.AppointmentID IS NOT NULL THEN CASE WHEN Res2.AppointmentResourceTypeID = 1 THEN d2.FirstName + ' ' + d2.LastName 
												   WHEN Res2.AppointmentResourceTypeID = 2 THEN pr2.ResourceName ELSE '' END ELSE '' END AS [Resource2] ,
--CASE WHEN Res3.AppointmentID IS NOT NULL THEN CASE WHEN Res3.AppointmentResourceTypeID = 1 THEN d3.FirstName + ' ' + d3.LastName 
--												   WHEN Res3.AppointmentResourceTypeID = 2 THEN pr3.ResourceName END END AS [Resource3] ,
--CASE WHEN Res4.AppointmentID IS NOT NULL THEN CASE WHEN Res4.AppointmentResourceTypeID = 1 THEN d4.FirstName + ' ' + d4.LastName 
--												   WHEN Res4.AppointmentResourceTypeID = 2 THEN pr4.ResourceName END END AS [Resource4] ,
RIGHT(CONVERT(varchar(15),CAST(a.StartDate AS TIME),100),2) AS [ampm] ,
CASE a.AppointmentType WHEN 'P' THEN 'Patient' WHEN 'O' THEN 'Other' END AS [appointmenttype] ,
sl.name AS [schedulelocation] , 
CAST(a.startdate AS DATE) AS [appointmentdate] , 
LEFT(CAST(a.startdate AS TIME),5) AS [starttime] , 
LEFT(CAST(a.EndDate AS TIME),5) AS [endtime] , 
DATEDIFF(MINUTE,a.StartDate,enddate) AS [duration2],
CASE WHEN a.AppointmentType = 'O' THEN a.[subject] ELSE '' END AS [Subject]  , 
REPLACE(REPLACE(CAST(a.notes AS VARCHAR(MAX)),CHAR(13),' '),CHAR(10),'') AS [Comments] ,
CASE WHEN a.AppointmentType = 'P' THEN a.patientid ELSE '' END AS [acctno] , 
CASE a.AppointmentConfirmationStatusCode 
	WHEN 'C' THEN 'Confirmed'
	WHEN 'E' THEN 'Seen'
	WHEN 'I' THEN 'Check-in'
	WHEN 'N' THEN 'No-show'
	WHEN 'O' THEN 'Check-out'
	WHEN 'R' THEN 'Rescheduled'
	WHEN 'S' THEN 'Scheduled'
	WHEN 'T' THEN 'Tentative'
	WHEN 'X' THEN 'Cancelled'
END AS [appt status] ,
CAST(a.CreatedDate AS DATE) AS [date entered],
LEFT(CAST(a.CreatedDate AS TIME), 5) AS [time entered],
CAST(a.ModifiedDate AS DATE) AS [edit date],
LEFT(CAST(a.ModifiedDate AS TIME), 5) AS [edit time] ,	
CASE ar.[type] WHEN 'D' THEN 'Daily'
			WHEN 'W' THEN 'Weekly'
			WHEN 'M' THEN 'Monthly'
			WHEN 'Y' THEN 'Yearly'
END AS [Recurrence Type] ,
CASE WHEN ar.[type] = 'W' THEN 'Recur every ' + CAST(ar.WeeklyNumWeeks AS VARCHAR) + ' week(s) on ' + 
					CASE WHEN ar.WeeklyOnSunday = 0 THEN '' ELSE 'Sunday, ' END +
					CASE WHEN ar.WeeklyOnMonday = 0 THEN '' ELSE 'Monday, ' END +
					CASE WHEN ar.WeeklyOnTuesday = 0 THEN '' ELSE 'Tuesday, ' END +
					CASE WHEN ar.WeeklyOnWednesday = 0 THEN '' ELSE 'Wednesday, ' END + 
					CASE WHEN ar.WeeklyOnThursday = 0 THEN '' ELSE 'Thursday, ' END +
					CASE WHEN ar.WeeklyOnFriday = 0 THEN '' ELSE 'Friday, ' END +
					CASE WHEN ar.WeeklyOnSaturday = 0 THEN '' ELSE 'Sunday, ' END +
					CASE ar.RangeType 
						WHEN 'N' THEN '' 
						WHEN 'D' THEN ' until | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR)
						WHEN 'O' THEN ' until ' + CAST(ar.RangeEndOccurrences AS VARCHAR) + ' ocurrences on | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR)  END
     WHEN ar.[type] = 'D' THEN 'Recur every ' +
					CASE ar.DailyType 
						WHEN 'X' THEN CAST(DailyNumDays AS VARCHAR) + ' days' 
					    WHEN 'W' THEN 'Weekday' END +
					CASE ar.RangeType 
						WHEN 'N' THEN '' 
						WHEN 'D' THEN ' until | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR)
						WHEN 'O' THEN ' until ' + CAST(ar.RangeEndOccurrences AS VARCHAR) + ' ocurrences on | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR) END
	WHEN ar.[type] = 'M' THEN 
					CASE ar.monthlytype 
						WHEN 'D' THEN 'Recur every ' + CAST(ar.MonthlyDayOfMonth AS VARCHAR) +
									CASE WHEN ar.MonthlyDayOfMonth % 100 IN (11,12,13) THEN CAST(ar.MonthlyDayOfMonth AS VARCHAR) + 'th'
										 WHEN ar.MonthlyDayOfMonth % 10 = 1 THEN 'st'
										 WHEN ar.MonthlyDayOfMonth % 10 = 2 THEN 'nd'
										 WHEN ar.MonthlyDayOfMonth % 10 = 3 THEN 'rd'
									ELSE 'th' END + ' day ' + CASE WHEN ar.MonthlyNumMonths = 1 THEN 'every month' ELSE ' for every ' + CAST(ar.monthlynummonths AS VARCHAR) + ' months' END 
						WHEN 'T' THEN 'Recur every ' + CASE ar.monthlyweektypeofmonth 
														WHEN '1' THEN 'first '
														WHEN '2' THEN 'second '
														WHEN '3' THEN 'third '
														WHEN '4' THEN 'forth '
														WHEN 'L' THEN 'last ' 
													   END 
					END +
					CASE ar.monthlytypeofday 
						WHEN 'D' THEN 'day '
						WHEN 'K' THEN 'weekday '
						WHEN 'E' THEN 'weekend day '
						WHEN 'S' THEN 'Sunday '
						WHEN 'M' THEN 'Monday '
						WHEN 'T' THEN 'Tuesday '
						WHEN 'W' THEN 'Wednesday '
						WHEN 'R' THEN 'Thursday '
						WHEN 'F' THEN 'Friday '
						WHEN 'A' THEN 'Saturday '
						ELSE '' 
					END +
					CASE ar.RangeType 
						WHEN 'N' THEN '' 
						WHEN 'D' THEN ' until | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR)
						WHEN 'O' THEN ' for ' + CAST(ar.RangeEndOccurrences AS VARCHAR) + ' ocurrences until | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR) END				
	WHEN ar.[type] = 'Y' THEN 
					CASE ar.yearlytype 
						WHEN 'D' THEN 'Recur every ' + CAST(ar.YearlyDayOfMonth AS VARCHAR) +
									CASE WHEN ar.YearlyDayOfMonth % 100 IN (11,12,13) THEN CAST(ar.YearlyDayOfMonth AS VARCHAR) + 'th'
										 WHEN ar.YearlyDayOfMonth % 10 = 1 THEN 'st'
										 WHEN ar.YearlyDayOfMonth % 10 = 2 THEN 'nd'
										 WHEN ar.YearlyDayOfMonth % 10 = 3 THEN 'rd'
									ELSE 'th' END + ' day '
						 WHEN 'T' THEN 'Recur every ' + CASE ar.YearlyDayTypeOfMonth 
														 WHEN '1' THEN 'first '
														 WHEN '2' THEN 'second '
														 WHEN '3' THEN 'third '
														 WHEN '4' THEN 'forth '
														 WHEN 'L' THEN 'last ' 
														END 
					END +
					CASE ar.YearlyTypeofDay 
						WHEN 'D' THEN 'day '
						WHEN 'K' THEN 'weekday '
						WHEN 'E' THEN 'weekend day '
						WHEN 'S' THEN 'Sunday '
						WHEN 'M' THEN 'Monday '
						WHEN 'T' THEN 'Tuesday '
						WHEN 'W' THEN 'Wednesday '
						WHEN 'R' THEN 'Thursday '
						WHEN 'F' THEN 'Friday '
						WHEN 'A' THEN 'Saturday '
						ELSE '' 
					END +
					CASE ar.YearlyMonth
						WHEN '1' THEN 'of January'
						WHEN '2' THEN 'of February'
						WHEN '3' THEN 'of March'
						WHEN '4' THEN 'of April'
						WHEN '5' THEN 'of May'
						WHEN '6' THEN 'of June'
						WHEN '7' THEN 'of July'
						WHEN '8' THEN 'of August'
						WHEN '9' THEN 'of September'
						WHEN '10' THEN 'of October'
						WHEN '11' THEN 'of November'
						WHEN '12' THEN 'of December'
					END +
					CASE ar.RangeType 
						WHEN 'N' THEN '' 
						WHEN 'D' THEN ' until | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR)
						WHEN 'O' THEN ' for ' + CAST(ar.RangeEndOccurrences AS VARCHAR) + ' ocurrences until | ' + CAST(CAST(ar.RangeEndDate AS DATE) AS VARCHAR) END				
END AS [Recurrence Pattern]
FROM dbo.Appointment a 
LEFT JOIN  (
SELECT AppointmentID, AppointmentToResourceID, AppointmentResourceTypeID , ResourceID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToResourceID DESC) AS ResNum FROM dbo.AppointmentToResource
		   ) AS Res1  ON a.AppointmentID = Res1.AppointmentID AND Res1.ResNum = 1
LEFT JOIN  (
SELECT AppointmentID, AppointmentToResourceID, AppointmentResourceTypeID , ResourceID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToResourceID DESC) AS ResNum FROM dbo.AppointmentToResource
		   ) AS Res2  ON a.AppointmentID = Res2.AppointmentID AND Res2.ResNum = 2
--LEFT JOIN  (
--SELECT AppointmentID, AppointmentToResourceID, AppointmentResourceTypeID , ResourceID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToResourceID DESC) AS ResNum FROM dbo.AppointmentToResource
--		   ) AS Res3  ON a.AppointmentID = Res3.AppointmentID AND Res3.ResNum = 3
--LEFT JOIN  (
--SELECT AppointmentID, AppointmentToResourceID, AppointmentResourceTypeID , ResourceID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToResourceID DESC) AS ResNum FROM dbo.AppointmentToResource
--		   ) AS Res4  ON a.AppointmentID = Res4.AppointmentID AND Res4.ResNum = 4
LEFT JOIN  (
SELECT AppointmentToAppointmentReasonID, AppointmentID, AppointmentReasonID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToAppointmentReasonID DESC) AS ReasNum FROM dbo.AppointmentToAppointmentReason
		   ) AS Reas1 ON a.AppointmentID = Reas1.AppointmentID AND Reas1.ReasNum = 1
LEFT JOIN  (
SELECT AppointmentToAppointmentReasonID, AppointmentID, AppointmentReasonID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToAppointmentReasonID DESC) AS ReasNum FROM dbo.AppointmentToAppointmentReason
		   ) AS Reas2 ON a.AppointmentID = Reas2.AppointmentID AND Reas2.ReasNum = 2
--LEFT JOIN  (
--SELECT AppointmentToAppointmentReasonID, AppointmentID, AppointmentReasonID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToAppointmentReasonID DESC) AS ReasNum FROM dbo.AppointmentToAppointmentReason
--		   ) AS Reas3 ON a.AppointmentID = Reas3.AppointmentID AND Reas3.ReasNum = 3
--LEFT JOIN  (
--SELECT AppointmentToAppointmentReasonID, AppointmentID, AppointmentReasonID , ROW_NUMBER() OVER(PARTITION BY AppointmentID ORDER BY AppointmentToAppointmentReasonID DESC) AS ReasNum FROM dbo.AppointmentToAppointmentReason
--		   ) AS Reas4 ON a.AppointmentID = Reas4.AppointmentID AND Reas4.ReasNum = 4
LEFT JOIN dbo.AppointmentReason ar1 ON ar1.AppointmentReasonID = Reas1.AppointmentReasonID
LEFT JOIN dbo.AppointmentReason ar2 ON ar2.AppointmentReasonID = Reas2.AppointmentReasonID
--LEFT JOIN dbo.AppointmentReason ar3 ON ar3.AppointmentReasonID = Reas3.AppointmentReasonID
--LEFT JOIN dbo.AppointmentReason ar4 ON ar4.AppointmentReasonID = Reas4.AppointmentReasonID
LEFT JOIN dbo.PracticeResource pr1 ON Res1.ResourceID = pr1.PracticeResourceID AND Res1.AppointmentResourceTypeID = 2
LEFT JOIN dbo.PracticeResource pr2 ON Res2.ResourceID = pr2.PracticeResourceID AND Res2.AppointmentResourceTypeID = 2
--LEFT JOIN dbo.PracticeResource pr3 ON Res3.ResourceID = pr3.PracticeResourceID AND Res3.AppointmentResourceTypeID = 2
--LEFT JOIN dbo.PracticeResource pr4 ON Res4.ResourceID = pr4.PracticeResourceID AND Res4.AppointmentResourceTypeID = 2
LEFT JOIN dbo.Doctor d1 ON Res1.ResourceID = d1.DoctorID AND Res1.AppointmentResourceTypeID = 1 AND d1.[External] = 0
LEFT JOIN dbo.Doctor d2 ON Res2.ResourceID = d2.DoctorID AND Res2.AppointmentResourceTypeID = 1 AND d2.[External] = 0
--LEFT JOIN dbo.Doctor d3 ON Res3.ResourceID = d3.DoctorID AND Res3.AppointmentResourceTypeID = 1 AND d3.[External] = 0
--LEFT JOIN dbo.Doctor d4 ON Res4.ResourceID = d4.DoctorID AND Res4.AppointmentResourceTypeID = 1 AND d4.[External] = 0
INNER JOIN dbo.servicelocation sl ON a.ServiceLocationID = sl.servicelocationid
LEFT JOIN dbo.Patient p ON a.patientid = p.PatientID AND p.PracticeID = @PracticeID
LEFT JOIN dbo.AppointmentRecurrence ar ON a.AppointmentID = ar.AppointmentID
WHERE a.PracticeID = @PracticeID AND (d1.DoctorID IN (2,20,7,10) OR d2.DoctorID IN (2,20,7,10)) AND (a.CreatedDate >= '2015-11-24 00:00:00.000' OR a.ModifiedDate >= '2015-11-24 00:00:00.000')
ORDER BY a.AppointmentID

