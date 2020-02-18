USE superbill_62559_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--ALTER TABLE dbo.Appointment ADD vendorimportid INT 
--ALTER TABLE dbo._import_2_2_65262appts ADD startdt datetime  
--ALTER TABLE dbo._import_2_2_65262appts ADD enddt datetime   
--ALTER TABLE dbo._import_2_2_65262appts ADD durationmi datetime  

--UPDATE i SET 
--i.durationmi = DATEDIFF(MINUTE,i.appointmentstarttime,i.appointmentendtime),
--i.startdt = CAST(i.appointmentdate AS DATETIME)+i.appointmentstarttime,
--i.enddt = CAST(i.appointmentdate AS DATETIME)+i.appointmentendtime
--FROM dbo._import_2_2_65262appts i 

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
          61 , -- PracticeID - int
		  11,  -- ServiceLocationID - int
          i.startdate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentstarttime , -- StartDate - datetime
          i.enddate, --CAST(i.appointmentdate AS DATETIME)+i.appointmentendtime,  -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.reasons , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int

          CASE i.status
			WHEN 'cancelled' THEN 'X'
			WHEN 'check-In' THEN 'I'
			WHEN 'confirmed' THEN 'C'
			WHEN 'no-show' THEN 'N'
			WHEN 'rescheduled' THEN 'R'
			WHEN 'scheduled' THEN 'S'
			ELSE'' END , -- AppointmentConfirmationStatusCode - char(1)
		  0,
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.startdate AS TIME),':',''),4) AS SMALLINT), -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.enddate AS TIME),':',''),4) AS SMALLINT),  -- EndTm - smallint
		  9
		  --SELECT * FROM dbo.DateKeyToPractice WHERE PracticeID = 61
		  --SELECT distinct * FROM dbo.ServiceLocation WHERE PracticeID = 61
		  --SELECT distinct i.*
FROM _import_33_61_PatientAppointments i 
	INNER JOIN dbo._import_35_61_PatientDemographics d ON 
		d.chartnumber = i.chartnumber
	INNER JOIN dbo.Patient p ON 
		d.LastName = p.LastName AND 
		d.FirstName = p.FirstName --AND 
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = 61 AND
		DK.dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
	inner JOIN dbo.ServiceLocation sl ON
		sl.name = i.servicelocationname
WHERE p.PracticeID = 61
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
          23  -- PracticeID - int
	--SELECT *
FROM _import_8_23_PatientAppointments i
	INNER JOIN dbo.Appointment a ON 
		a.StartDate = i.startdate AND 
		a.EndDate = i.enddate AND 
		a.PracticeID = 23
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
    23,         -- PracticeID - int
    ip.appointmenttype,        -- Name - varchar(128)
    DATEDIFF(MINUTE,ip.appointmentstarttime,ip.appointmentendtime),         -- DefaultDurationMinutes - int
    null,      -- DefaultColorCode - int
    '',        -- Description - varchar(256)
    GETDATE() -- ModifiedDate - datetime
	--SELECT *
FROM _import_8_23_PatientAppointments ip
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.examreason
AND ar.PracticeID = 23
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
23 AS PracticeID
--select * 
FROM _import_8_23_PatientAppointments iapt
	INNER JOIN dbo._import_8_23_PatientDemographics pd ON 
		pd.chartnumber = iapt.chartnumber
	INNER JOIN dbo.AppointmentReason ar ON 
		ar.Name = iapt.reasons
	INNER JOIN dbo.Patient p ON 
		p.LastName = pd.lastname AND 
		p.FirstName = pd.firstname 
	INNER JOIN dbo.Appointment a ON 
		a.PatientID = p.PatientID AND 
		a.StartDate = iapt.startdate    --CONVERT(VARCHAR,CAST(iapt.appointmentdate AS DATETIME),120)+ CAST(iapt.appointmentstarttime AS DATETIME)
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
GROUP BY a.AppointmentID

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--rollback
--commit

--DELETE FROM dbo.AppointmentToAppointmentReason 
--DELETE FROM dbo.AppointmentReason
--DELETE FROM dbo.AppointmentToResource
--DELETE FROM dbo.Appointment