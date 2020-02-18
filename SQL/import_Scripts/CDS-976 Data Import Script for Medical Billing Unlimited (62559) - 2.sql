USE superbill_62559_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 32
SET @SourcePracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

CREATE TABLE #tempdoc (doctorid INT, firstname VARCHAR(65), lastname VARCHAR(65), NPI INT , [External] INT)
INSERT INTO #tempdoc (doctorid, firstname, lastname, NPI , [External] )
SELECT DISTINCT
		  d.doctorid ,
		  d.firstname ,-- firstname - varchar(65)
          d.lastname, -- lastname - varchar(65)
          d.npi ,  -- NPI - int
		  d.[External]
FROM dbo._import_2_32_Doctor d 
WHERE d.PracticeID = @SourcePracticeID 

PRINT ''
PRINT 'Updating Existing Rendering Doctor Records with VendorID...'
UPDATE dbo.Doctor 
	SET VendorID = i.DoctorID
FROM dbo.Doctor d
INNER JOIN #tempdoc i ON
	i.FirstName = d.FirstName AND
    i.LastName = d.LastName AND
    i.NPI = d.NPI 
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 0 AND i.[External] = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

CREATE TABLE #TimeBlockMap (TimeblockID INT , AppointmentResourceTypeID INT , ResourceID INT , ResourceName VARCHAR(256))
INSERT INTO #TimeBlockMap
        ( TimeblockID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ResourceName
        )
SELECT DISTINCT
		  i.TimeblockID , -- TimeblockID - int
          i.AppointmentResourceTypeID , -- AppointmentResourceTypeID - int
          i.ResourceID , -- ResourceID - int
          pr.ResourceName  -- ResourceName - varchar(256)
FROM dbo._import_2_32_Timeblock i
	INNER JOIN dbo._import_2_32_PracticeResource pr ON
		i.ResourceID = pr.PracticeResourceID 
WHERE (i.StartDate < '2017-07-31 00:00:00.000' OR i.StartDate > '2017-10-01 00:00:00.000') AND 
	  i.AppointmentResourceTypeID = 2

INSERT INTO #TimeBlockMap
        ( TimeblockID ,
          AppointmentResourceTypeID ,
          ResourceID 
        )
SELECT DISTINCT
		  i.TimeblockID , -- TimeblockID - int
          i.AppointmentResourceTypeID , -- AppointmentResourceTypeID - int
          d.DoctorID  -- ResourceID - int
FROM dbo._import_2_32_Timeblock i
	INNER JOIN dbo.Doctor d ON 
		i.ResourceID = d.VendorID AND
		d.PracticeID = @TargetPracticeID AND
		d.[External] = 0 
WHERE (i.StartDate < '2017-07-31 00:00:00.000' OR i.StartDate > '2017-10-01 00:00:00.000') AND 
	  i.AppointmentResourceTypeID = 1

PRINT ''
PRINT 'Inserting Into TimeBlock...'
INSERT INTO dbo.Timeblock
        ( PracticeID ,
          StartDate ,
          EndDate ,
          TimeblockName ,
          TimeblockDescription ,
          TimeblockColor ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          AllDay ,
          IsRecurring ,
          RecurrenceStartDate ,
          RangeEndDate ,
          RangeType ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          DoNotSchedule ,
          AllowOverbooking ,
          LimitTo ,
          LimitToAmount ,
          DisplayDenialExplanation ,
          DenialExplanation ,
          PermittedLocationsType ,
          PermittedReasonsType ,
          StartTm ,
          EndTm
        )
SELECT	
		  @TargetPracticeID , -- PracticeID - int
          i.StartDate , -- StartDate - datetime
          i.EndDate , -- EndDate - datetime
          i.TimeblockID , -- TimeblockName - varchar(128)
          i.TimeblockDescription , -- TimeblockDescription - varchar(512)
          i.TimeblockColor , -- TimeblockColor - int
          i.Notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.AppointmentResourceTypeID , -- AppointmentResourceTypeID - int
          CASE WHEN tbm.AppointmentResourceTypeID = 2 THEN pr.PracticeResourceID
		  ELSE tbm.ResourceID END , -- ResourceID - int
          i.AllDay , -- AllDay - bit
          i.IsRecurring , -- IsRecurring - bit
          i.RecurrenceStartDate , -- RecurrenceStartDate - datetime
          i.RangeEndDate , -- RangeEndDate - datetime
          i.RangeType , -- RangeType - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.DoNotSchedule , -- DoNotSchedule - bit
          i.AllowOverbooking , -- AllowOverbooking - bit
          i.LimitTo , -- LimitTo - bit
          i.LimitToAmount , -- LimitToAmount - int
          i.DisplayDenialExplanation , -- DisplayDenialExplanation - bit
          i.DenialExplanation , -- DenialExplanation - varchar(4096)
          i.[PermittedLocationsType] , -- PermittedLocationsType - char(1)
          i.PermittedReasonsType , -- PermittedReasonsType - char(1)
          i.StartTm , -- StartTm - smallint
          i.EndTm  -- EndTm - smallint
FROM dbo._import_2_32_Timeblock i
	INNER JOIN dbo.DateKeyToPractice dk ON
        dk.[PracticeID] = @TargetPracticeID AND
        dk.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
	INNER JOIN #TimeBlockMap tbm ON 
		i.TimeblockID = tbm.TimeblockID
	LEFT JOIN dbo.PracticeResource pr ON 
		tbm.ResourceName = pr.ResourceName AND
		pr.PracticeID = @TargetPracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into TimeBlock Recurrence...'
INSERT INTO dbo.TimeblockRecurrence
        ( TimeblockID ,
          Type ,
          WeeklyNumWeeks ,
          WeeklyOnSunday ,
          WeeklyOnMonday ,
          WeeklyOnTuesday ,
          WeeklyOnWednesday ,
          WeeklyOnThursday ,
          WeeklyOnFriday ,
          WeeklyOnSaturday ,
          DailyType ,
          DailyNumDays ,
          MonthlyType ,
          MonthlyNumMonths ,
          MonthlyDayOfMonth ,
          MonthlyWeekTypeOfMonth ,
          MonthlyTypeOfDay ,
          YearlyType ,
          YearlyDayTypeOfMonth ,
          YearlyTypeOfDay ,
          YearlyDayOfMonth ,
          YearlyMonth ,
          RangeType ,
          RangeEndOccurrences ,
          RangeEndDate ,
          ModifiedDate ,
          ModifiedUserID ,
          StartDate
        )
SELECT DISTINCT
		  t.TimeblockID , -- TimeblockID - int
          i.[Type] , -- Type - char(1)
          i.WeeklyNumWeeks , -- WeeklyNumWeeks - int
          i.WeeklyOnSunday , -- WeeklyOnSunday - bit
          i.WeeklyOnMonday , -- WeeklyOnMonday - bit
          i.WeeklyOnTuesday , -- WeeklyOnTuesday - bit
          i.WeeklyOnWednesday , -- WeeklyOnWednesday - bit
          i.WeeklyOnThursday , -- WeeklyOnThursday - bit
          i.WeeklyOnFriday , -- WeeklyOnFriday - bit
          i.WeeklyOnSaturday , -- WeeklyOnSaturday - bit
          i.DailyType , -- DailyType - char(1)
          i.DailyNumDays , -- DailyNumDays - int
          i.MonthlyType , -- MonthlyType - char(1)
          i.MonthlyNumMonths , -- MonthlyNumMonths - int
          i.MonthlyDayOfMonth , -- MonthlyDayOfMonth - int
          i.MonthlyWeekTypeOfMonth , -- MonthlyWeekTypeOfMonth - char(1)
          i.MonthlyTypeOfDay , -- MonthlyTypeOfDay - char(1)
          i.YearlyType , -- YearlyType - char(1)
          i.YearlyDayTypeOfMonth , -- YearlyDayTypeOfMonth - char(1)
          i.YearlyTypeOfDay , -- YearlyTypeOfDay - char(1)
          i.YearlyDayOfMonth , -- YearlyDayOfMonth - int
          i.YearlyMonth , -- YearlyMonth - int
          i.RangeType , -- RangeType - char(1)
          i.RangeEndOccurrences , -- RangeEndOccurrences - int
          i.RangeEndDate , -- RangeEndDate - datetime
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.StartDate  -- StartDate - datetime
FROM dbo._import_2_32_TimeblockRecurrence i
	INNER JOIN dbo.Timeblock t ON 
		i.TimeblockID = t.TimeblockName AND
        t.PracticeID = @TargetPracticeID AND
		t.CreatedDate >= DATEADD(s,-20,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into TimeBlock Recurrence Exception...'
INSERT INTO dbo.TimeblockRecurrenceException
        ( TimeblockID ,
          ExceptionDate ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT
		  t.TimeblockID , -- TimeblockID - int
          i.ExceptionDate , -- ExceptionDate - datetime
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo._import_2_32_TimeblockRecurrenceException i
	INNER JOIN dbo.Timeblock t ON 
		i.TimeblockID = t.TimeblockName AND
        t.PracticeID = @TargetPracticeID AND
		t.CreatedDate >= DATEADD(s,-20,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

UPDATE t
SET TimeblockName = i.TimeblockName
FROM dbo.Timeblock t 
INNER JOIN dbo._import_2_32_Timeblock i ON 
	i.TimeblockID = t.TimeblockName AND
	i.PracticeID = @SourcePracticeID
WHERE t.PracticeID = @TargetPracticeID AND t.CreatedDate >= DATEADD(s,-20,GETDATE())

DROP TABLE #TimeBlockMap , #tempdoc

--ROLLBACK
--COMMIT