USE superbill_65262_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--add vendorimportid to appointments table
--ALTER TABLE dbo.Appointment ADD vendorimportid INT 
--ALTER TABLE dbo._import_2_2_65262appts ADD startdt datetime  
--ALTER TABLE dbo._import_2_2_65262appts ADD enddt datetime   
--ALTER TABLE dbo._import_2_2_65262appts ADD durationmi datetime  

--UPDATE i SET 
--i.durationmi = DATEDIFF(MINUTE,i.appointmentstarttime,i.appointmentendtime),
--i.startdt = CAST(i.appointmentdate AS DATETIME)+i.appointmentstarttime,
--i.enddt = CAST(i.appointmentdate AS DATETIME)+i.appointmentendtime
--FROM dbo._import_2_2_65262appts i 

--INSERT INTO dbo.AppointmentConfirmationStatus
--(
--    AppointmentConfirmationStatusCode,
--    Name,
--    ModifiedDate
--)
--VALUES
--(   'D',       -- AppointmentConfirmationStatusCode - char(1)
--    'With-Doctor',       -- Name - varchar(64)
--    GETDATE() -- ModifiedDate - datetime
--    )
--INSERT INTO dbo.AppointmentConfirmationStatus
--(
--    AppointmentConfirmationStatusCode,
--    Name,
--    ModifiedDate
--)
--VALUES
--(   'H',       -- AppointmentConfirmationStatusCode - char(1)
--    'In-Room',       -- Name - varchar(64)
--    GETDATE() -- ModifiedDate - datetime
--    )
--INSERT INTO dbo.AppointmentConfirmationStatus
--(
--    AppointmentConfirmationStatusCode,
--    Name,
--    ModifiedDate
--)
--VALUES
--(   'G',       -- AppointmentConfirmationStatusCode - char(1)
--    'Not-Seen',       -- Name - varchar(64)
--    GETDATE() -- ModifiedDate - datetime
--    )
--INSERT INTO dbo.AppointmentConfirmationStatus
--(
--    AppointmentConfirmationStatusCode,
--    Name,
--    ModifiedDate
--)
--VALUES
--(   'V',       -- AppointmentConfirmationStatusCode - char(1)
--    'Vitals-Taken',       -- Name - varchar(64)
--    GETDATE() -- ModifiedDate - datetime
--    )


DECLARE @sourcepracticeID INT 
DECLARE @targetPracticeID INT
DECLARE @VendorImportID INT

SET @sourcepracticeID = 1
SET @targetPracticeID = 2
SET @VendorImportID = 9

PRINT 'PracticeID = ' + CAST(@targetPracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
PRINT ''
PRINT 'Inserting Into Appointments...'
INSERT INTO dbo.Appointment
        ( PatientID,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
		  Recurrence,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm,
		  vendorimportid
        )
		

SELECT DISTINCT
		  p.PatientID,
          @targetPracticeID , -- PracticeID - int
          sl.ServiceLocationID,  -- ServiceLocationID - int
          i.startdt, --CAST(i.appointmentdate AS DATETIME)+i.appointmentstarttime , -- StartDate - datetime
          i.enddt, --CAST(i.appointmentdate AS DATETIME)+i.appointmentendtime,  -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.examreason , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int

          CASE i.appointmentstatus
			WHEN 'cancelled' THEN 'X'
			WHEN 'checkedIn' THEN 'I'
			WHEN 'checkedOut' THEN 'O'
			WHEN 'confirmed' THEN 'C'
			WHEN 'inRoom' THEN 'H'
			WHEN 'notSeen' THEN 'G'
			WHEN 'scheduled' THEN 'S'
			WHEN 'vitalsTaken' THEN 'V'
			WHEN 'withDr' THEN 'D'
			ELSE'' END , -- AppointmentConfirmationStatusCode - char(1)
		  0,
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.appointmentstarttime AS TIME),':',''),4) AS SMALLINT), -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.appointmentendtime AS TIME),':',''),4) AS SMALLINT),  -- EndTm - smallint
		  @vendorimportid
		  --SELECT *
FROM dbo._import_2_2_65262appts i 
	INNER JOIN dbo.Patient p ON 
		i.LastName = p.LastName AND 
		i.FirstName = p.FirstName --AND 
		--i.MiddleName = p.MiddleName
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @targetPracticeID AND
		DK.dt = CAST(CAST(i.appointmentdate AS DATE) AS DATETIME)
	INNER JOIN dbo.ServiceLocation sl ON
		sl.PracticeID=2 
WHERE p.PracticeID = @targetPracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT	
		  a.AppointmentID , -- AppointmentID - int
          1,--CASE WHEN i.resource = 'Nurse' THEN 2 ELSE 1 END , -- AppointmentResourceTypeID - int
          CASE i.assignedphysician
			WHEN 'Bruce Gollub, M.D.' THEN 2 ELSE ''END ,-- ResourceID - int
          GETDATE(),  -- ModifiedDate - datetime
          @targetpracticeid  -- PracticeID - int
	--SELECT *
FROM dbo._import_2_2_65262appts i
	INNER JOIN dbo.Appointment a ON 
		a.StartDate = i.startdt AND 
		a.EndDate = i.enddt AND 
		a.PracticeID = 2
	--INNER JOIN dbo.Doctor d ON 
	--	d.LastName = i.assignedphysician
		WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Appointment Reasons...'

INSERT INTO dbo.AppointmentReason
(
    PracticeID,
    Name,
    DefaultDurationMinutes,
    DefaultColorCode,
    Description,
    ModifiedDate

)
SELECT DISTINCT	
    @targetpracticeid,         -- PracticeID - int
    ip.appointmenttype,        -- Name - varchar(128)
    DATEDIFF(MINUTE,ip.appointmentstarttime,ip.appointmentendtime),         -- DefaultDurationMinutes - int
    null,      -- DefaultColorCode - int
    '',        -- Description - varchar(256)
    GETDATE() -- ModifiedDate - datetime
	--SELECT *
FROM dbo._import_2_2_65262appts ip
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.examreason
AND ar.PracticeID = @targetPracticeID
WHERE ar.name IS NULL 

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT''
PRINT'Inserting into Appointment to Appointment Reasons...'

INSERT INTO dbo.AppointmentToAppointmentReason
(
    AppointmentID,
    AppointmentReasonID,
    PrimaryAppointment,
    ModifiedDate,
    PracticeID
)

SELECT DISTINCT a.AppointmentID, 
MIN(ar.AppointmentReasonID) AS AppointmentReasonID, 
1 ,
GETDATE() ,
2 AS PracticeID

FROM dbo._import_2_2_65262appts iapt
	INNER JOIN dbo.AppointmentReason ar ON 
		ar.Name = iapt.appointmenttype
	INNER JOIN dbo.Patient p ON 
		p.LastName = iapt.lastname AND 
		p.FirstName = iapt.firstname 
	INNER JOIN dbo.Appointment a ON 
		a.PatientID = p.PatientID AND 
		a.StartDate = CONVERT(VARCHAR,CAST(iapt.appointmentdate AS DATETIME),120)+ CAST(iapt.appointmentstarttime AS DATETIME)
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
GROUP BY a.AppointmentID

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--rollback
--commit

--DELETE FROM dbo.AppointmentToAppointmentReason 
--DELETE FROM dbo.AppointmentReason
--DELETE FROM dbo.AppointmentToResource
--DELETE FROM dbo.Appointment