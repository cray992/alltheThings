USE superbill_10590_dev
--USE superbill_10590_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 33
SET @VendorImportID = 19

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToResource records deleted'
--DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' AppointmentToAppointmentReason records deleted'
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Appointment records deleted'


--PRINT ''
--PRINT 'Inserting Into Appointment Reason...'
--INSERT INTO dbo.AppointmentReason
--        ( PracticeID ,
--          Name ,
--          DefaultDurationMinutes ,
--          DefaultColorCode ,
--          Description ,
--          ModifiedDate 
--        )
--SELECT DISTINCT
--		  @PracticeID , -- PracticeID - int
--          I.reasonname , -- Name - varchar(128)
--          0 , -- DefaultDurationMinutes - int
--          0 , -- DefaultColorCode - int
--          i.[description] , -- Description - varchar(256)
--          GETDATE()  -- ModifiedDate - datetime
--FROM dbo.[_import_20_33_Sheet2] i 
--LEFT JOIN dbo.AppointmentReason ar ON 
--	i.reasonname = ar.Name AND ar.PracticeID = @PracticeID
--WHERE ar.AppointmentReasonID IS NULL AND i.id = ''
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
          175 , -- ServiceLocationID - int
          i.startdateest , -- StartDate - datetime
          i.endtimeest , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.aptuniq , -- Subject - varchar(64)
          CASE WHEN ar.AppointmentReasonID IS NULL THEN 'Appointment Reason: ' + i.reason ELSE '' END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          CAST(REPLACE(RIGHT(i.startdateest,5), ':','') AS SMALLINT) , -- StartTm - smallint
          CAST(REPLACE(RIGHT(i.endtimeest,5), ':','') AS SMALLINT)   -- EndTm - smallint
FROM dbo.[_import_20_33_aptfile2] i
INNER JOIN dbo.patient AS p ON
  p.VendorID = i.aptaccount and
  p.VendorImportID = @VendorImportID
LEFT JOIN dbo.patientcase AS pc ON
  pc.patientID = p.patientID AND
  pc.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(i.startdateest AS date) AS DATETIME) 
LEFT JOIN dbo.AppointmentReason ar ON 
  i.reason = ar.Name AND 
  ar.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into AppointmenttoAppointmentReason...'
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
FROM dbo.[_import_20_33_aptfile2] i
LEFT JOIN dbo.AppointmentReason ar ON
	ar.Name = i.reason AND
	ar.PracticeID = @PracticeID
INNER JOIN dbo.Appointment a ON
	a.[Subject] = i.aptuniq AND
	a.StartDate = CAST(i.startdateest AS DATETIME) AND
	a.EndDate = CAST(i.endtimeest AS DATETIME) AND
	a.PracticeID = @PracticeID
WHERE ar.AppointmentReasonID IS NOT NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into AppointmenttoResource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
		  1, -- AppointmentResourceTypeID - int
          CASE WHEN rend.DoctorID IS NULL THEN 
											(SELECT DoctorID FROM dbo.Doctor 
											 WHERE FirstName = 'STEVEN' AND 
												   LastName = 'MICKLEY' AND 
												   PracticeID = @PracticeID AND 
												   [External] = 0 AND 
												   ActiveDoctor = 1) 
		  ELSE rend.DoctorID END, -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_20_33_aptfile2] i
INNER JOIN dbo.Appointment a ON
	a.[Subject] = i.aptuniq AND
	a.StartDate = CAST(i.startdateest AS DATETIME) AND
	a.EndDate = CAST(i.endtimeest AS DATETIME) AND
	a.PracticeID = @PracticeID
LEFT JOIN dbo.[_import_19_33_drfile] rd ON
	rd.drno = i.aptdr 
LEFT JOIN dbo.Doctor rend ON 
	rd.drfname = rend.FirstName AND 
	rd.drlname = rend.LastName AND 
	rend.PracticeID = @PracticeID AND
    rend.[External] = 0 AND 
	rend.ActiveDoctor = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT

