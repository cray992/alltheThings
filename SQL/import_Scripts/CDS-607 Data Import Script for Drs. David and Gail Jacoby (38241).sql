USE superbill_38421_dev
--USE superbill_38421_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR)

PRINT ''
PRINT 'Updating Patient...'
UPDATE dbo.Patient
	SET MedicalRecordNumber = i.chartnumber , 
		ModifiedDate = GETDATE()
FROM dbo.Patient p 
INNER JOIN dbo.[_import_3_1_PatientAppointments] i ON
	p.FirstName = i.firstname AND p.LastName = i.lastname AND p.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME))
WHERE p.MedicalRecordNumber IS NULL OR p.MedicalRecordNumber = ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

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
	          EndTm ,
			  Subject
	        )
	SELECT  DISTINCT  PAT.PatientID , -- PatientID - int
	          @PracticeID , -- PracticeID - int
	          CASE WHEN SL.ServiceLocationID IS NULL THEN SL2.ServiceLocationID ELSE SL.ServiceLocationID END , -- ServiceLocationID - int
	          PA.StartDate , -- StartDate - datetime
	          PA.EndDate , -- EndDate - datetime
	          'P' , -- AppointmentType - varchar(1)
	          PA.Note , -- Notes - text
	          GETDATE() , -- CreatedDate - datetime
	          0 , -- CreatedUserID - int
	          GETDATE() , -- ModifiedDate - datetime
	          0 , -- ModifiedUserID - int
	          1 , -- AppointmentResourceTypeID - int
	           CASE WHEN PA.[STATUS] IN ('C','Confirmed') THEN 'C' 
					WHEN PA.[STATUS] IN ('E','Seen') THEN 'E'
					WHEN PA.[STATUS] IN ('I','Check-in') THEN 'I'
					WHEN PA.[STATUS] IN ('N','No-show') THEN 'N'
					WHEN PA.[STATUS] IN ('O','Check-out') THEN 'O' 
					WHEN PA.[STATUS] IN ('R','Rescheduled') THEN 'R'
					WHEN PA.[STATUS] IN ('S','Scheduled') THEN 'S'
					WHEN PA.[STATUS] IN ('X','Cancelled') THEN 'X'
					ELSE 'S' END , -- AppointmentConfirmationStatusCode - char(1)
	          PC.PatientCaseID , -- PatientCaseID - int
	          DK.DKPracticeID , -- StartDKPracticeID - int
	          DK.DKPracticeID , -- EndDKPracticeID - int
			  CAST(REPLACE(RIGHT(PA.StartDate,5), ':','') AS SMALLINT)   , -- StartTm - smallint
	          CAST(REPLACE(RIGHT(PA.EndDate,5),  ':', '') AS SMALLINT) ,
			  pa.elationapptid
	FROM dbo.[_import_3_1_PatientAppointments] PA
	INNER JOIN dbo.Patient PAT ON 
		PA.ChartNumber = PAT.MedicalRecordNumber AND
		PAT.PracticeID = @PracticeID
	INNER JOIN dbo.PatientCase PC ON 
		pc.PatientCaseID = (SELECT TOP 1 patientcaseid FROM dbo.PatientCase pc2 WHERE pat.PatientID = pc2.PatientID AND pc2.PracticeID = @PracticeID)
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(PA.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.ServiceLocation SL ON
		SL.NAME = PA.ServiceLocationName AND
		SL.PracticeID = @PracticeID  
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @PracticeID)
WHERE NOT EXISTS (SELECT * FROM dbo.Appointment a WHERE pa.startdate = a.StartDate AND pa.enddate = a.EndDate AND pat.MedicalRecordNumber = pa.chartnumber)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into AppointmentReason...'
	INSERT INTO dbo.AppointmentReason
			( PracticeID ,
			  Name ,
			  DefaultDurationMinutes ,
			  DefaultColorCode ,
			  Description ,
			  ModifiedDate 
			)
	SELECT  DISTINCT  @PracticeID , -- PracticeID - int
			  PA.[Reasons] , -- Name - varchar(128)
			  15 , -- DefaultDurationMinutes - int
			  Null , -- DefaultColorCode - int
			  PA.[Reasons] , -- Description - varchar(256)
			  GETDATE()  -- ModifiedDate - datetime
	FROM dbo.[_import_3_1_PatientAppointments] PA
	WHERE PA.[Reasons] <> '' AND 
			NOT EXISTS (SELECT * FROM dbo.AppointmentReason WHERE Name = PA.[Reasons] AND PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Appointment To Appointment Reason...'
	INSERT INTO dbo.AppointmentToAppointmentReason
	        ( AppointmentID ,
	          AppointmentReasonID ,
	          PrimaryAppointment ,
	          ModifiedDate ,
	          PracticeID
	        )
	SELECT DISTINCT    APP.AppointmentID , -- AppointmentID - int
	          AR.AppointmentReasonID , -- AppointmentReasonID - int
	          1 , -- PrimaryAppointment - bit
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM dbo.[_import_3_1_PatientAppointments] PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.MedicalRecordNumber = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID      
	INNER JOIN dbo.Appointment APP ON 
		PAT.PatientID = APP.PatientID AND
		APP.Subject = pa.elationapptid    
	INNER JOIN dbo.AppointmentReason AR ON
		PA.[Reasons] = AR.NAME AND
		AR.PracticeID = @PracticeID
WHERE app.CreatedDate > DATEADD(mi,-1,app.CreatedDate)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	
  
PRINT ''
PRINT 'Inserting Into Appointmen to Resource...'	
	INSERT INTO dbo.AppointmentToResource
	        ( AppointmentID ,
	          AppointmentResourceTypeID ,
	          ResourceID ,
	          ModifiedDate ,
	          PracticeID
	        )
	SELECT DISTINCT  APP.AppointmentID , -- AppointmentID - int
	          1 , -- AppointmentResourceTypeID - int
	          DOC.DoctorID , -- ResourceID - int
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM dbo.[_import_3_1_PatientAppointments] PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.MedicalRecordNumber = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID    
	INNER JOIN dbo.Appointment APP ON 
		PAT.PatientID = APP.PatientID AND
		APP.Subject = pa.elationapptid    
	INNER JOIN dbo.Doctor DOC ON
		DOC.FirstName = PA.DoctorFirstName AND
		DOC.LastName = PA.DoctorLastName AND
		DOC.PracticeID = @PracticeID AND
		DOC.[EXTERNAL] = 0  AND
		DOC.ActiveDoctor = 1    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

--ROLLBACK
--COMMIT



