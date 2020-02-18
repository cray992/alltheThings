USE superbill_33693_dev
--USE superbill_33693_prod
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
PRINT ''
PRINT 'Updating Appointment PatientIDs...'
UPDATE dbo.Appointment 
SET PatientID = p.PatientID , 
	PatientCaseID = pc.PatientCaseID ,
	ModifiedDate = GETDATE()
FROM dbo.Appointment a
INNER JOIN dbo.[_import_13_1_Appts] i ON
a.StartDate = CAST(i.startdatehwst AS DATETIME) AND
a.EndDate = CAST(i.enddatehwst AS DATETIME) AND
a.AppointmentConfirmationStatusCode = CASE i.apptstatus 
		WHEN 'Check-out' THEN (SELECT AppointmentConfirmationStatusCode FROM dbo.AppointmentConfirmationStatus WHERE Name = 'Check-out') 
		WHEN 'Cancelled' THEN (SELECT AppointmentConfirmationStatusCode FROM dbo.AppointmentConfirmationStatus WHERE Name = 'Cancelled') 
		WHEN 'Check-in' THEN (SELECT AppointmentConfirmationStatusCode FROM dbo.AppointmentConfirmationStatus WHERE Name = 'Check-in') 
	    WHEN 'No-show' THEN (SELECT AppointmentConfirmationStatusCode FROM dbo.AppointmentConfirmationStatus WHERE Name = 'No-show') 
		WHEN 'Scheduled' THEN (SELECT AppointmentConfirmationStatusCode FROM dbo.AppointmentConfirmationStatus WHERE Name = 'Scheduled') END
INNER JOIN dbo.Patient p ON
p.VendorID = i.patvendorid AND
p.VendorImportID IN (8,10) AND
p.LastName = i.lastname 
INNER JOIN dbo.PatientCase pc ON
p.PatientID = pc.PatientID AND
pc.VendorImportID IN (8,10) AND
pc.Name <> 'Balance Forward'
WHERE a.ModifiedUserID = 0 AND a.CreatedDate = '2015-03-13 09:13:31.903'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records updated'


PRINT ''
PRINT 'Inserting Into Appointment...'
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
          1 , -- PracticeID - int
          1 , -- ServiceLocationID - int
          i.startdatehwst , -- StartDate - datetime
          i.enddatehwst , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.note1 + CHAR(13) + CHAR(10) + CASE WHEN i.note2 = '' THEN '' ELSE 'Referring Provider: ' + i.note2 END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE WHEN acs.AppointmentConfirmationStatusCode IS NULL THEN 'S' ELSE acs.AppointmentConfirmationStatusCode END , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttmhwst , -- StartTm - smallint
          i.endtmhwst  -- EndTm - smallint
FROM dbo.[_import_13_1_Scheduler20150401] i
INNER JOIN dbo.Patient p ON
p.VendorID = i.patvendorid AND 
p.VendorImportID IN (8,10)
INNER JOIN dbo.PatientCase pc ON
pc.PatientID = p.PatientID AND
pc.Name <> 'Balance Forward' AND
pc.VendorImportID IN (8,10)
INNER JOIN dbo.DateKeyToPractice dk ON
dk.PracticeID = 1 AND
dk.dt = CAST(CAST(i.startdatehwst AS DATE) AS DATETIME)
LEFT JOIN dbo.AppointmentConfirmationStatus acs ON
acs.Name = i.visitstatus
WHERE NOT EXISTS (SELECT * FROM dbo.Appointment a
				  INNER JOIN dbo.Patient p ON a.PatientID = p.PatientID AND p.VendorImportID = 8
				  WHERE a.StartDate = CAST(i.startdatehwst AS DATETIME) AND a.EndDate = CAST(i.enddatehwst AS DATETIME) AND p.VendorID = i.patvendorid)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted'


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
          1  -- PracticeID - int
FROM dbo.Appointment a 
INNER JOIN dbo.Patient p ON
p.PatientID = a.PatientID AND
p.VendorImportID IN (8,10)
INNER JOIN dbo.[_import_13_1_Scheduler20150401] i ON
CAST(i.startdatehwst AS DATETIME) = a.StartDate AND
CAST(i.enddatehwst AS DATETIME) = a.EndDate AND
p.VendorID = i.patvendorid 
INNER JOIN dbo.AppointmentReason ar ON
ar.Name = i.typename AND
ar.PracticeID = 1
WHERE a.CreatedDate > DATEADD(mi,-2,GETDATE())
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
          2 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          1  -- PracticeID - int
FROM dbo.Appointment a
INNER JOIN dbo.Patient p ON
p.PatientID = a.PatientID AND
p.VendorImportID IN (8,10)
INNER JOIN dbo.[_import_13_1_Scheduler20150401] i ON
CAST(i.startdatehwst AS DATETIME) = a.StartDate AND
CAST(i.enddatehwst AS DATETIME) = a.EndDate AND
p.VendorID = i.patvendorid 
WHERE a.CreatedDate > DATEADD(mi,-2,GETDATE()) AND i.[resource] = 'KENNY R MALOTT MD'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Appointment to Resource 2...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          2 , -- AppointmentResourceTypeID - int
          2 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          1  -- PracticeID - int
FROM dbo.Appointment a
INNER JOIN dbo.Patient p ON
p.PatientID = a.PatientID AND
p.VendorImportID IN (8,10)
INNER JOIN dbo.[_import_13_1_Scheduler20150401] i ON
CAST(i.startdatehwst AS DATETIME) = a.StartDate AND
CAST(i.enddatehwst AS DATETIME) = a.EndDate AND
p.VendorID = i.patvendorid 
WHERE a.CreatedDate > DATEADD(mi,-2,GETDATE()) AND i.[resource] = 'Nurse'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



--ROLLBACK
--COMMIT

