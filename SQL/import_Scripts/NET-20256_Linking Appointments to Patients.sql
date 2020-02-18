-- Appointments ticket 

--USE superbill_64529_dev
USE superbill_64529_prod
GO


BEGIN TRANSACTION
--rollback
--commit
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON	


--DELETE dbo._import_1_1_PatientAppointments WHERE AutoTempID=1

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
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.EndDate , -- EndDate - datetime
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
FROM dbo._import_1_1_patientappointments i
	INNER JOIN dbo.Patient p ON 
		p.MedicalRecordNumber = i.chartnumber
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
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
          @PracticeID  -- PracticeID - int
	
FROM dbo._import_1_1_PatientAppointments i
	INNER JOIN dbo.Appointment a ON 
		a.StartDate = i.startdate AND 
		a.EndDate = i.enddate
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
    @PracticeID,         -- PracticeID - int
    ip.reasons,        -- Name - varchar(128)
    DATEDIFF(MINUTE,ip.startdate,ip.enddate),         -- DefaultDurationMinutes - int
    null,      -- DefaultColorCode - int
    ip.note,        -- Description - varchar(256)
    GETDATE() -- ModifiedDate - datetime

FROM dbo._import_1_1_patientappointments ip
LEFT JOIN dbo.AppointmentReason ar ON ar.name = ip.reasons
WHERE ar.name IS null

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



