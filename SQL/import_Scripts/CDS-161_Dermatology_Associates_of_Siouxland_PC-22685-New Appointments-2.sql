USE superbill_22685_dev
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
PRINT 'Purging existing records in detination tables for VendorImport ' + CAST(@@ROWCOUNT AS VARCHAR(10)) 


DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'

/*
==========================================================================================================================================
CREATE APPOINTMENT
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Appointment...'
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
		  pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          sl.ServiceLocationID , -- ServiceLocationID - int
          DATEADD(hh , -2 ,app.startdate) , -- StartDate - datetime
          DATEADD(hh , -2 ,app.enddate) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          app.appointmentnotes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          app.starttm -200 , -- StartTm - smallint
          app.endtm  -- EndTm - smallint
FROM dbo.[_import_2_1_AppointmentsWorking] AS app
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = app.patientaccountnumber AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase AS pc ON
	pc.VendorID = app.patientaccountnumber AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.ServiceLocation AS sl ON
	sl.Name = app.locationdescription AND
	sl.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice dk ON
	dk.PracticeID = @PracticeID AND
	dk.Dt = (SELECT Dt FROM dbo.DateKeyToPractice WHERE Dt = CAST(CAST(app.startdate AS DATE) AS DATETIME))   
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

/*
==========================================================================================================================================
CREATE APPOINTMENT TO RESOURCE
==========================================================================================================================================
*/

PRINT ''
PRINT 'Inserting into Appointment to Resource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  appt.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          doc.DoctorID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_AppointmentsWorking] AS app
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = app.patientaccountnumber AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS appt ON
	appt.PatientID = pat.PatientID AND
	appt.StartDate = DATEADD(hh , - 2, app.startdate)
INNER JOIN dbo.Doctor AS doc ON
	doc.FirstName = app.resourcefirstname AND
	doc.LastName = app.resourcelastname AND
	[External] = 0
WHERE appt.CreatedDate > DATEADD(mi , -1 , GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'




PRINT ''
PRINT 'Updating Appointment Records...'
UPDATE dbo.Appointment
	SET EndTm = EndTm - 200
	FROM dbo.Appointment AS app
	WHERE app.CreatedDate > DATEADD(mi , -2 , GETDATE())  	    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment Records Updated to Central Timezone'

--ROLLBACK TRAN
--COMMIT
