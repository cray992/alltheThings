USE superbill_10600_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT

SET @PracticeID = 1

SET NOCOUNT ON 

INSERT INTO dbo.Appointment
        ( PatientID ,
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
          PatientCaseID ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          sl.ServiceLocationID , -- ServiceLocationID - int
          CAST(CONVERT(DATE,LEFT(i.appointmentdatetime,8),111) AS DATETIME) + DATEADD(hh,-2,CAST(STUFF(RIGHT(i.appointmentdatetime,4),3,0,':') AS DATETIME))  , -- StartDate - datetime
          CAST(CONVERT(DATE,LEFT(i.appointmentdatetime,8),111) AS DATETIME) + DATEADD(mi,CAST(
																					CASE WHEN 
																						i.appointmentduration = '0' THEN 15
																					ELSE i.appointmentduration END AS INT),
																	DATEADD(hh,-2,CAST(STUFF(RIGHT(i.appointmentdatetime,4),3,0,':') AS DATETIME))) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.fehrappointmentid , -- Subject - varchar(64)
          '' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
		  CAST(REPLACE(LEFT(CAST(CAST(CONVERT(DATE,LEFT(i.appointmentdatetime,8),111) AS DATETIME) + DATEADD(hh,-2,CAST(STUFF(RIGHT(i.appointmentdatetime,4),3,0,':') AS DATETIME))AS TIME),6),':','') AS SMALLINT) , -- StartTm - smallint
		  CAST(REPLACE(LEFT(CAST(CAST(CONVERT(DATE,LEFT(i.appointmentdatetime,8),111) AS DATETIME) + DATEADD(mi,CAST(
																					CASE WHEN 
																						i.appointmentduration = '0' THEN 15
																					ELSE i.appointmentduration END AS INT),
																	DATEADD(hh,-2,CAST(STUFF(RIGHT(i.appointmentdatetime,4),3,0,':') AS DATETIME))) AS TIME),6),':','') AS SMALLINT)
FROM dbo._import_6_1_AppointmentList i 
	INNER JOIN dbo.Patient p ON 
		i.patientfirstname = p.FirstName AND 
		i.patientlastname = p.LastName AND 
		CONVERT(DATE,dateofbirth,111) = CAST(p.DOB AS DATE)
	LEFT JOIN dbo.PatientCase pc ON 
		pc.PatientCaseID = (SELECT MAX(pc2.PatientCaseID) FROM dbo.PatientCase pc2
							WHERE pc2.PatientID = p.PatientID AND pc2.PracticeID = @PracticeID)
	INNER JOIN dbo.ServiceLocation sl ON
		i.appointmentlocation = sl.Name AND 
		sl.PracticeID = @PracticeID
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CONVERT(DATE,LEFT(i.appointmentdatetime,8),111)  AS DATETIME)
	LEFT JOIN dbo.Appointment a ON 
		a.StartDate = CAST(CONVERT(DATE,LEFT(i.appointmentdatetime,8),111) AS DATETIME) + DATEADD(hh,-2,CAST(STUFF(RIGHT(i.appointmentdatetime,4),3,0,':') AS DATETIME)) AND
		a.EndDate = CAST(CONVERT(DATE,LEFT(i.appointmentdatetime,8),111) AS DATETIME) + DATEADD(mi,CAST(
																					CASE WHEN 
																						i.appointmentduration = '0' THEN 15
																					ELSE i.appointmentduration END AS INT),
																	DATEADD(hh,-2,CAST(STUFF(RIGHT(i.appointmentdatetime,4),3,0,':') AS DATETIME))) AND
	   a.PatientID = p.PatientID AND
	   a.PracticeID = @PracticeID
WHERE a.AppointmentID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Appointment...'
PRINT ''

INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          d.DoctorID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_6_1_AppointmentList i 
	INNER JOIN dbo.Appointment a ON 
		i.fehrappointmentid = a.[Subject] AND
		a.PracticeID = @PracticeID
	INNER JOIN dbo.Doctor d ON 
		i.providerfirstname = d.FirstName AND 
		i.providerlastname = d.LastName AND
		d.[External] = 0 AND
		d.PracticeID = @PracticeID AND
		d.ActiveDoctor = 1
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into AppointmenttoResource...'
PRINT ''

INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_6_1_AppointmentList i
	INNER JOIN dbo.Appointment a ON 
		i.fehrappointmentid = a.[Subject] AND
        a.PracticeID = @PracticeID
	INNER JOIN dbo.AppointmentReason ar ON 
		i.appointmenttype = ar.Name AND 
		ar.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into AppointmenttoAppointmentReason...'


--ROLLBACK
--COMMIT

