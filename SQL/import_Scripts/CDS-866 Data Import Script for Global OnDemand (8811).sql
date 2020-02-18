USE superbill_8811_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE @PracticeID INT 
SET @PracticeID = 5 


PRINT 'PracticeID: ' + CAST(@PracticeID AS VARCHAR) PRINT ''

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
		  i.patientid , -- PatientID - int
          @PracticeID , -- PracticeID - int
          30 , -- ServiceLocationID - int
          DATEADD(hh,-2,CAST(i.starttime AS DATETIME)) , -- StartDate - datetime
          DATEADD(mi,15,DATEADD(hh,12,CAST(i.starttime AS DATETIME))) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          CASE WHEN i.[type] = '' THEN '' ELSE 'Type: ' + i.[type] + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.reason = '' THEN '' ELSE 'Reason: ' + i.reason + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.notes = '' THEN '' ELSE 'Notes: ' + i.notes + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.phonenumber = '' THEN '' ELSE 'Phone Number: ' + i.phonenumber END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(LEFT(DATEADD(hh,-2,CAST(i.starttime AS TIME)),6),':','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(LEFT(DATEADD(mi,15,DATEADD(hh,-2,CAST(i.starttime AS TIME))),6),':','') AS SMALLINT)  -- EndTm - smallint
FROM dbo._import_5_5_Sheet1 i
LEFT JOIN dbo.PatientCase pc ON 
	pc.PatientCaseID = (SELECT MAX(pc2.PatientCaseID) FROM dbo.PatientCase pc2 WHERE i.patientid = pc2.PatientID AND pc2.PracticeID = @PracticeID)
INNER JOIN dbo.DateKeyToPractice dk ON 
	dk.Dt = CAST(CAST(i.starttime AS DATE) AS DATETIME) AND
	dk.PracticeID = @PracticeID
LEFT JOIN dbo.Appointment a ON
	DATEADD(hh,-2,CAST(i.starttime AS DATETIME)) = a.StartDate AND
	i.patientid = a.PatientID AND
	a.PracticeID = @PracticeID
WHERE i.patientid <> '#N/A' AND a.AppointmentID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment Records Inserted'
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
          151 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_5_5_Sheet1 i 
INNER JOIN dbo.Appointment a ON 
	DATEADD(hh,-2,CAST(i.starttime AS DATETIME)) = a.StartDate AND
	DATEADD(mi,15,DATEADD(hh,12,CAST(i.starttime AS DATETIME))) = a.EndDate AND
	i.patientid = a.PatientID  AND
	a.PracticeID = @PracticeID
WHERE i.patientid <> '#N/A'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment to Resource Records Inserted'
PRINT ''

INSERT INTO dbo.Appointment
        ( 
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
          EndTm 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          30 , -- ServiceLocationID - int
          DATEADD(hh,-2,CAST(i.starttime AS DATETIME)) , -- StartDate - datetime
          DATEADD(mi,15,DATEADD(hh,12,CAST(i.starttime AS DATETIME))) , -- EndDate - datetime
          'O' , -- AppointmentType - varchar(1)
          i.patfirstname + ' ' + i.patlastname + ' ' + CONVERT(VARCHAR(10),i.dob,101) , -- Subject - varchar(64)
          CASE WHEN i.[type] = '' THEN '' ELSE 'Type: ' + i.[type] + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.reason = '' THEN '' ELSE 'Reason: ' + i.reason + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.notes = '' THEN '' ELSE 'Notes: ' + i.notes + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.phonenumber = '' THEN '' ELSE 'Phone Number: ' + i.phonenumber END, -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(LEFT(DATEADD(hh,-2,CAST(i.starttime AS TIME)),6),':','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(LEFT(DATEADD(mi,15,DATEADD(hh,-2,CAST(i.starttime AS TIME))),6),':','') AS SMALLINT)  -- EndTm - smallint
FROM dbo._import_5_5_Sheet1 i
LEFT JOIN dbo.PatientCase pc ON 
	pc.PatientCaseID = (SELECT MAX(pc2.PatientCaseID) FROM dbo.PatientCase pc2 WHERE i.patientid = pc2.PatientID AND pc2.PracticeID = @PracticeID)
INNER JOIN dbo.DateKeyToPractice dk ON 
	dk.Dt = CAST(CAST(i.starttime AS DATE) AS DATETIME) AND
	dk.PracticeID = @PracticeID
WHERE i.patientid = '#N/A'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Other Appointment Records Inserted'
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
          151 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo._import_5_5_Sheet1 i 
INNER JOIN dbo.Appointment a ON 
	DATEADD(hh,-2,CAST(i.starttime AS DATETIME)) = a.StartDate AND
	DATEADD(mi,15,DATEADD(hh,12,CAST(i.starttime AS DATETIME))) = a.EndDate AND
	i.patfirstname + ' ' + i.patlastname + ' ' + CONVERT(VARCHAR(10),i.dob,101) = a.[subject]  AND
	a.PracticeID = @PracticeID
WHERE i.patientid = '#N/A'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment to Resource Records Inserted'

--ROLLBACK
--COMMIT


