--USE superbill_47172_dev
USE superbill_47172_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

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
          Recurrence ,
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
          i.apptunique , -- Subject - varchar(64)
          CASE WHEN i.remarks = '' THEN '' ELSE 'Remark: ' + i.remarks + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.comments = '' THEN '' ELSE 'Comments: ' + i.comments END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          CASE WHEN acs.AppointmentConfirmationStatusCode IS NULL THEN 'S' ELSE acs.AppointmentConfirmationStatusCode END , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          0 , -- Recurrence - bit
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[_import_3_1_PatientAppointment] i
	INNER JOIN dbo.Patient p ON 
		p.VendorID = i.patunique AND 
		p.VendorImportID = @VendorImportID
	LEFT JOIN dbo.PatientCase pc ON 
		pc.PatientCaseID = (SELECT MAX(pc2.patientcaseid) FROM dbo.PatientCase pc2
							WHERE pc2.VendorID = p.VendorID AND pc2.VendorImportID = @VendorImportID AND pc2.Name <> 'Balance Forward')
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(i.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.AppointmentConfirmationStatus acs ON 
		i.[status] = acs.AppointmentConfirmationStatusCode
WHERE i.id IN ('GR1','AB1','KA1','RC1','BC1','BI1','BM1','GC1')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment Resource...'
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
FROM dbo.[_import_3_1_PatientAppointment] i
	LEFT JOIN dbo.AppointmentReason ar ON
		i.reason = ar.Name AND 
		ar.PracticeID = @PracticeID 
WHERE ar.AppointmentReasonID IS NULL
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
		  a.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_3_1_PatientAppointment] i 
	INNER JOIN dbo.Patient p ON 
		i.patunique = p.VendorID AND 
		p.VendorImportID = @VendorImportID
	INNER JOIN dbo.Appointment a ON 
		i.apptunique = a.[Subject] AND 
		p.PatientID = a.PatientID AND 
		a.PracticeID = @PracticeID
	--INNER JOIN dbo.Appointment a ON 
	--	CAST(i.startdate AS DATETIME) = a.StartDate AND
	--	CAST(i.enddate AS DATETIME) = a.EndDate AND
	--	p.PatientID = a.PatientID AND 
	--	a.PracticeID = @PracticeID
	INNER JOIN dbo.AppointmentReason ar ON 
		i.reason = ar.Name AND 
		ar.PracticeID = @PracticeID
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
          CASE i.id 
			WHEN 'GR1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'GEORGE' AND LastName = 'RHOADS' AND [External] = 0 AND ActiveDoctor = 1 AND PracticeID = @PracticeID)
			WHEN 'AB1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'AMJAD' AND LastName = 'BAHNASSI' AND [External] = 0 AND ActiveDoctor = 1 AND PracticeID = @PracticeID)
			WHEN 'KA1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'KIMBERLY' AND LastName = 'ABDOW' AND [External] = 0 AND ActiveDoctor = 1 AND PracticeID = @PracticeID)
			WHEN 'RC1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'RODNEY' AND LastName = 'COURNOYER' AND [External] = 0 AND ActiveDoctor = 1 AND PracticeID = @PracticeID)
			WHEN 'BC1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BRENDA' AND LastName = 'CASTRICHINI' AND [External] = 0 AND ActiveDoctor = 1 AND PracticeID = @PracticeID)
			WHEN 'BI1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BETH' AND LastName = 'IRVING' AND [External] = 0 AND ActiveDoctor = 1 AND PracticeID = @PracticeID)
			WHEN 'BM1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'BRENDA' AND LastName = 'MCCARTHY-TRAYAH' AND [External] = 0 AND ActiveDoctor = 1 AND PracticeID = @PracticeID)
			WHEN 'GC1' THEN (SELECT DoctorID FROM dbo.Doctor WHERE FirstName = 'GWEN' AND LastName = 'CARELLI' AND [External] = 0 AND ActiveDoctor = 1 AND PracticeID = @PracticeID)
		  END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_3_1_PatientAppointment] i 
	INNER JOIN dbo.Patient p ON 
		i.patunique = p.VendorID AND 
		p.VendorImportID = @VendorImportID
	INNER JOIN dbo.Appointment a ON 
		i.apptunique = a.[Subject] AND 
		p.PatientID = a.PatientID AND 
		a.PracticeID = @PracticeID
	--INNER JOIN dbo.Appointment a ON 
	--	CAST(i.startdate AS DATETIME) = a.StartDate AND
	--	CAST(i.enddate AS DATETIME) = a.EndDate AND
	--	p.PatientID = a.PatientID AND 
	--	a.PracticeID = @PracticeID
WHERE i.id IN ('GR1','AB1','KA1','RC1','BC1','BI1','BM1','GC1')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT


