USE superbill_28138_dev
--USE superbill_28138_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))




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
          i.reason , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          i.reason , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_2_1_UpdatedAppointment] i
WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE i.reason = ar.Name)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

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
FROM dbo.[_import_2_1_UpdatedAppointment] i
	INNER JOIN dbo.Appointment a ON
		CAST(i.startdate AS DATETIME) = a.StartDate AND
		i.patientfirstname + ' ' + i.patientlastname + ' - ' + i.providercode = a.[Subject]
	INNER JOIN dbo.AppointmentReason ar ON
		ar.Name = i.reason
WHERE a.AppointmentID NOT IN (SELECT AppointmentID FROM dbo.AppointmentToAppointmentReason)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

--COMMIT
--ROLLBACK
