--USE superbill_14577_dev
USE superbill_14577_prod
GO


 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 10 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.AppointmentToResource WHERE PracticeID = @PracticeID 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
DELETE FROM dbo.Appointment WHERE PracticeID = @PracticeID 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'

PRINT ''
PRINT 'Inserting into Appointment ...'
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
          3 , -- ServiceLocationID - int
          DATEADD(mi, CAST(RIGHT(starttime, 2) AS SMALLINT) , DATEADD(hh, CAST(LEFT(starttime, 2) AS SMALLINT) , date)) , -- StartDate - datetime
          DATEADD(mi, 
				  CAST(length AS SMALLINT), 
				  DATEADD(mi, 
						  CAST(RIGHT(starttime, 2) AS SMALLINT) , 
						  DATEADD(hh, 
								  CAST(LEFT(starttime, 2) AS SMALLINT), date))) , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          '' , -- Subject - varchar(64)
          app.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(app.[length] AS SMALLINT) , -- StartTm - smallint
          (CAST(starttime AS SMALLINT) + CAST(length AS SMALLINT))  -- EndTm - smallint
FROM dbo.[_import_10_2_OHAPP] app 
LEFT JOIN dbo.Patient pat ON
	app.chartnumber = pat.VendorID AND
	pat.PracticeID = @PracticeID
LEFT JOIN dbo.PatientCase pc ON 
	pat.patientID = pc.PatientCaseID and
	pc.PracticeID = @PracticeID
LEFT JOIN dbo.DateKeyToPractice dk ON
	dk.Dt = CAST(date AS VARCHAR) AND
	dk.PracticeID = @PracticeID
WHERE date > GETDATE() AND
	pat.PatientID IS NOT NULL 
PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Insert into AppointmentToResource ...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT    AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          2 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.Appointment
PRINT CAST(@@rowcount AS VARCHAR(10)) + ' records inserted '


COMMIT



