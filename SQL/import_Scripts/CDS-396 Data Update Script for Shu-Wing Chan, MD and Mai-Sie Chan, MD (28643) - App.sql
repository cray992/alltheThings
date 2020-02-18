USE superbill_28643_dev 
--USE superbill_28643_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN

 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 2 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
 

PRINT ''
PRINT 'Inserting records into Appointment'
INSERT INTO dbo.Appointment
        ( 
		  PatientID ,
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
          EndTm ,
		  Subject
        )
SELECT DISTINCT
          patcase.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          CASE WHEN i.examreason <> '' THEN 'Exam Reason: ' + i.examreason ELSE '' END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          i.appointmentstatus , -- AppointmentConfirmationStatusCode - char(1)
          patcase.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm , -- EndTm - smallint
		  i.elationchartid
FROM [dbo].[_import_5_1_Appointment] AS i
INNER JOIN dbo.patientcase AS patcase ON
  patcase.vendorID = i.patientfullname AND
  patcase.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(i.startdate AS date) AS DATETIME)
WHERE i.startdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into Appointment Successfully'


PRINT ''
PRINT 'Inserting into AppointmentReason'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          Description ,
          ModifiedDate 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          i.appointmenttype , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          i.appointmenttype , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo._import_5_1_Appointment i
WHERE i.appointmenttype <> '' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ar.Name = i.appointmenttype)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into AppointmentToAppointmentReason'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
          PracticeID
        )
SELECT    app.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.Appointment app
INNER JOIN dbo._import_5_1_Appointment impa ON
	app.StartDate = CAST (impa.startdate AS DATETIME) AND
	app.[Subject] = impa.elationchartid 
INNER JOIN dbo.AppointmentReason ar ON
	impa.appointmenttype = ar.name
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into AppointmentToResource'
INSERT INTO dbo.AppointmentToResource
	    (   AppointmentID ,
	        AppointmentResourceTypeID ,
	        ResourceID ,
	        ModifiedDate ,
	        PracticeID
	    )
SELECT     app.AppointmentID , -- AppointmentID - int
	        1 , -- AppointmentResourceTypeID - int
	        assignedphysician , -- ResourceID - int
	        GETDATE() , -- ModifiedDate - datetime
	        @PracticeID  -- PracticeID - int
FROM dbo.Appointment app
INNER JOIN dbo._import_5_1_Appointment impa ON
	app.StartDate = CAST (impa.startdate AS DATETIME) AND
	app.EndDate = CAST (impa.enddate AS DATETIME) AND
	app.[Subject] = impa.elationchartid
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--COMMIT
--ROLLBACk