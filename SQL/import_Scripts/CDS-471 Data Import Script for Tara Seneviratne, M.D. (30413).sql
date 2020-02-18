USE superbill_30413_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1 
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Inserting Into Appointment...'
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
	      p.PatientID ,
          @PracticeID ,
          1 ,
          i.startdate ,
          i.EndDate ,
          'P' ,
          i.AppointmentID ,
          CASE WHEN i.examreason = '' THEN '' ELSE 'Exam Reason: ' + i.examreason END ,
          GETDATE() ,
          -50 ,
          GETDATE() ,
          -50 ,
          1 ,
          CASE i.appointmentstatus 
			WHEN 'checkedOUT' THEN 'O'
			WHEN 'scheduled' THEN 'S'
			WHEN 'checkIn' THEN 'I'
			WHEN 'withDr' THEN 'I'
			WHEN 'inRoom' THEN 'I'
			WHEN 'cancelled' THEN 'X'
			WHEN 'billed' THEN 'E'
			WHEN 'confimed' THEN 'C'
		  ELSE 'S' END ,
          pc.PatientCaseID ,
          dk.DKPracticeID ,
          dk.DKPracticeID ,
          i.StartTm ,
          i.EndTm 
FROM dbo._import_1_1_Appointment i 
	INNER JOIN dbo.Patient p ON
		p.MedicalRecordNumber = i.patientid AND
		p.VendorImportID = @VendorImportID
	LEFT JOIN dbo.PatientCase pc ON
		pc.PatientID = p.patientid AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.DateKeyToPractice AS dk ON 
		dk.PracticeID = @PracticeID AND 
		dk.Dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted'

PRINT ''
PRINT 'Inserting Into Appointment Reason...'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode ,
          Description ,
          ModifiedDate 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          i.appointmenttype , -- Name - varchar(128)
          0 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          i.appointmenttype , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo._import_1_1_Appointment i 
WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ar.Name = i.appointmenttype) AND i.appointmenttype <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted'

PRINT ''
PRINT 'Inserting Into Appointment to Appointment Reason...'
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
FROM dbo.Appointment a
	INNER JOIN dbo._import_1_1_Appointment i ON
		a.[Subject] = i.appointmentid AND
		a.PracticeID = @PracticeID
	INNER JOIN dbo.AppointmentReason ar ON
		ar.Name = i.appointmenttype AND
		ar.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted'
 
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
          1 , -- AppointmentResourceTypeID - int
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.Appointment a 
	INNER JOIN dbo._import_1_1_Appointment i ON
		a.[Subject] = i.appointmentid AND
		a.PracticeID = @PracticeID	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted'        

--COMMIT
--ROLLBACK


