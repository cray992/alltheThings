USE superbill_33954_dev
--USE superbill_XXX_prod
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1

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
		  p.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.firstname + ' ' + i.lastname + ' - ' + i.apptreason , -- Subject - varchar(64)
          i.appointmentnotes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[_import_1_1_appointmentscs] i
INNER JOIN dbo.Patient p ON
i.firstname = p.FirstName AND
i.lastname = p.LastName
LEFT JOIN dbo.PatientCase pc ON
pc.PatientCaseID = (SELECT TOP 1 PatientCaseID FROM dbo.PatientCase pc2 WHERE 
					pc2.PatientID = p.PatientID)
INNER JOIN dbo.DateKeyToPractice AS dk ON 
dk.PracticeID = @PracticeID AND 
dk.Dt = CAST(CAST(i.startdate AS date) AS DATETIME) 
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
          1 , -- AppointmentResourceTypeID - int
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_appointmentscs] i
INNER JOIN dbo.Appointment a ON
a.[Subject] = i.firstname + ' ' + i.lastname + ' - ' + i.apptreason AND
a.StartDate = i.startdate
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
	      a.appointmentid , -- AppointmentID - int
          CASE i.apptreason WHEN 'Injection' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'Injection') 
							WHEN 'New patient' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE Name = 'New patient')
							WHEN 'Follow-up visit' THEN (SELECT AppointmentReasonID FROM dbo.AppointmentReason WHERE name = 'Follow-up visit') ELSE 80 END, -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_appointmentscs] i
INNER JOIN dbo.Appointment a ON
a.[Subject] = i.firstname + ' ' + i.lastname + ' - ' + i.apptreason AND
a.StartDate = i.startdate
WHERE i.apptreason <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT


