USE superbill_52864_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
SET @PracticeID = 5

SET NOCOUNT ON 

INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
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
          12 , -- ServiceLocationID - int
          DATEADD(hh,-3,CAST(i.startdate AS DATETIME)) , -- StartDate - datetime
          DATEADD(mi,CAST(i.apptslotduration AS INT),DATEADD(hh,-3,CAST(i.startdate AS DATETIME))) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.apptnote  , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.apptstatus 
			WHEN '1 - Check-In' THEN 'I'
			WHEN '2 - Intake' THEN 'I'
			WHEN '3 - Exam' THEN 'E'
			WHEN '4 - Sign-Off' THEN 'O'
			WHEN '5 - Check-Out' THEN 'O'
		  ELSE 'S' END, -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(LEFT(DATEADD(hh,-3,CAST(i.startdate AS TIME)),6),':','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(LEFT(DATEADD(mi,CAST(i.apptslotduration AS INT),DATEADD(hh,-3,CAST(i.startdate AS TIME))),6),':','') AS SMALLINT) -- EndTm - smallint
FROM dbo._import_13_5_CDS877528645AppointmentsU i 
	INNER JOIN dbo.Patient p ON 
		i.patientid = p.VendorID AND 
		p.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase pc ON
		pc.PatientCaseID = (SELECT MAX(pc2.PatientCaseID) FROM dbo.PatientCase pc2
							WHERE pc2.PatientID = p.PatientID)
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.Appointment a ON 
		p.PatientID = a.PatientID AND 
		a.StartDate = DATEADD(hh,-3,CAST(i.startdate AS DATETIME)) AND
		a.EndDate = DATEADD(mi,CAST(i.apptslotduration AS INT),DATEADD(hh,-3,CAST(i.startdate AS DATETIME)))
WHERE a.AppointmentID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment Records Inserted...'
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
FROM dbo._import_13_5_CDS877528645AppointmentsU i 
	INNER JOIN dbo.Patient p ON 
		i.patientid = p.VendorID AND 
		p.PracticeID = @PracticeID 
	INNER JOIN dbo.Appointment a ON 
		p.PatientID = a.PatientID AND
		a.StartDate = DATEADD(hh,-3,CAST(i.startdate AS DATETIME)) AND
		a.EndDate = DATEADD(mi,CAST(i.apptslotduration AS INT),DATEADD(hh,-3,CAST(i.startdate AS DATETIME))) 
	INNER JOIN dbo.AppointmentReason ar ON 
		i.appttype = ar.Name AND 
		ar.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment to Appointment Reason Records Inserted...'
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
          CASE i.rndrngprvdr 
			WHEN 'SosmmeMathew' THEN 1079
			WHEN 'Boyd_R' THEN 1078
		  ELSE 1073 END, -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_13_5_CDS877528645AppointmentsU i
	INNER JOIN dbo.Patient p ON 
		i.patientid = p.VendorID AND 
		p.PracticeID = @PracticeID 
	INNER JOIN dbo.Appointment a ON 
		p.PatientID = a.PatientID AND
		a.StartDate = DATEADD(hh,-3,CAST(i.startdate AS DATETIME)) AND
		a.EndDate = DATEADD(mi,CAST(i.apptslotduration AS INT),DATEADD(hh,-3,CAST(i.startdate AS DATETIME))) AND
        a.PracticeID = @PracticeID
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment to Resource Records Inserted...'

--ROLLBACK
--COMMIT


