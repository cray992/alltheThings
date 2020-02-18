USE superbill_64919_prod
GO

--SELECT * FROM dbo.Appointment where practiceid=2
--SELECT * FROM dbo._import_5_1_patientappointments where practiceid=2

BEGIN TRANSACTION
--rollback
--commit
DECLARE @targetpracticeid INT 
DECLARE @sourcePracticeID INT
DECLARE @VendorImportID INT
 
SET @targetpracticeid = 1
SET @sourcePracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON	

----Add VendorImportID
--ALTER TABLE dbo.Appointment ADD vendorimportid VARCHAR(10)


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
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm,
		  vendorimportid
        )
SELECT DISTINCT
		  p.PatientID,
          @targetpracticeid , -- PracticeID - int
          sl.ServiceLocationID,  -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.EndDate,  -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          i.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(LEFT(REPLACE(CAST(i.StartDate AS TIME),':',''),4) AS SMALLINT) , --CAST(REPLACE(RIGHT(i.StartDate,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(LEFT(REPLACE(CAST(i.EndDate AS TIME),':',''),4) AS SMALLINT), --CAST(REPLACE(RIGHT(i.EndDate,5), ':','') AS SMALLINT)  -- EndTm - smallint
		  @VendorImportID
		  --SELECT * 
FROM dbo._import_5_1_patientappointments i 
	INNER JOIN dbo.Patient p ON 
		p.VendorID = i.chartnumber
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @sourcePracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
	INNER JOIN dbo.ServiceLocation sl ON 
	--	sl.Name = i.servicelocationname AND 
		sl.ServiceLocationID = 1
		--SELECT * FROM dbo.Appointment
		--SELECT * FROM dbo._import_5_1_PatientAppointments
		--select * from servicelocation

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
          1,--CASE WHEN i.resource = 'Nurse' THEN (SELECT PracticeResourceID FROM dbo.PracticeResource WHERE ResourceName = 'Nurse' AND PracticeID = @PracticeID)
		  --ELSE (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'Irene' AND LastName = 'Edwards' AND PracticeID = @PracticeID AND [External] = 0) 
		  --END  , -- ResourceID - int
          GETDATE(),  -- ModifiedDate - datetime
          @targetpracticeid  -- PracticeID - int
	--SELECT * 
FROM dbo._import_5_1_patientappointments i
	INNER JOIN dbo.Appointment a ON 
		a.StartDate = i.startdate AND 
		a.EndDate = i.enddate 
		--a.PracticeID = 1
		WHERE a.CreatedDate > DATEADD(mi,-11,GETDATE())
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
    ip.reasons,        -- Name - varchar(128)
    DATEDIFF(MINUTE,ip.startdate,ip.enddate),         -- DefaultDurationMinutes - int
    null,      -- DefaultColorCode - int
    ip.note,        -- Description - varchar(256)
    GETDATE() -- ModifiedDate - datetime
	--SELECT * 
FROM dbo._import_5_1_patientappointments ip
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.reasons
WHERE ar.name IS null

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
SELECT DISTINCT 
    apt.AppointmentID,         -- AppointmentID - int
    ar.AppointmentReasonID,         -- AppointmentReasonID - int
    1,      -- PrimaryAppointment - bit
    GETDATE(), -- ModifiedDate - datetime
    @targetpracticeid          -- PracticeID - int
     


FROM dbo._import_5_1_PatientAppointments imp
INNER JOIN dbo.Patient pat ON
	pat.VendorID = imp.chartnumber AND
	pat.PracticeID = @targetpracticeid
INNER JOIN dbo.Appointment apt ON
	apt.PatientID = pat.PatientID AND
	apt.StartDate = imp.startdate
INNER JOIN dbo.AppointmentReason ar ON
	ar.Name = imp.reasons


PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




