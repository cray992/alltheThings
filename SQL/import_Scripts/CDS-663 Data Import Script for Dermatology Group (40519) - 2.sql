USE superbill_40519_dev
--superbill_40519_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 3

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR)

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
	          CAST(REPLACE(RIGHT(PA.EndDate,5),  ':', '') AS SMALLINT)
	FROM dbo._import_3_1_PatientAppointments PA
	INNER JOIN dbo.Patient PAT ON 
		PA.ChartNumber = PAT.VendorID AND
		PAT.PracticeID = @PracticeID
	INNER JOIN dbo.PatientCase PC ON 
		PC.PatientID = PAT.PatientID AND
		PC.PracticeID = @PracticeID  AND
		PC.NAME <> 'Balance Forward'    
	INNER JOIN dbo.DateKeyToPractice DK ON
		DK.PracticeID = @PracticeID AND
		DK.dt = CAST(CAST(PA.StartDate AS DATE) AS DATETIME)
	LEFT JOIN dbo.ServiceLocation SL ON
		SL.NAME = PA.ServiceLocationName AND
		SL.PracticeID = @PracticeID  
	LEFT JOIN dbo.ServiceLocation SL2 ON 
		SL2.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation s WHERE s.PracticeID = @PracticeID)
WHERE ISDATE(pa.startdate) = 1 
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
	FROM dbo._import_3_1_PatientAppointments PA
	WHERE PA.[Reasons] <> '' AND 
			NOT EXISTS (SELECT * FROM dbo.AppointmentReason WHERE Name = PA.[Reasons] AND PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Practice Resource...'
	INSERT INTO dbo.PracticeResource
			( PracticeResourceTypeID,
			  PracticeID,
			  ResourceName,
			  ModifiedDate,
			  CreatedDate
			)
	SELECT DISTINCT	
			  3 , --PracticeResourceTypeID - int
			  @PracticeID , -- PracticeID - int
			  PA.PracticeResource , -- ResourceName - varchar(50)
			  GETDATE() , -- ModifiedDate - datetime
			  GETDATE() -- CreatedDate - datetime
	FROM dbo._import_3_1_PatientAppointments PA
	WHERE PA.PracticeResource <> '' AND 
			NOT EXISTS (SELECT * FROM dbo.PracticeResource AS PR WHERE PR.ResourceName = PA.PracticeResource AND PR.PracticeID = @PracticeID)
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
	FROM dbo._import_3_1_PatientAppointments PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.VendorID = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID      
	INNER JOIN dbo.Appointment APP ON 
		PAT.PatientID = APP.PatientID AND
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.ENDDate = CAST(PA.EndDate AS DateTime)      
	INNER JOIN dbo.AppointmentReason AR ON
		PA.[Reasons] = AR.NAME AND
		AR.PracticeID = @PracticeID
WHERE ISDATE(pa.startdate) = 1
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
	FROM dbo._import_3_1_PatientAppointments PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.VendorID = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID    
	INNER JOIN dbo.Appointment APP ON 
		APP.PatientId = PAT.PatientID AND 
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.EndDate = CAST(PA.EndDate AS Datetime)      
	INNER JOIN dbo.Doctor DOC ON
		DOC.FirstName = PA.DoctorFirstName AND
		DOC.LastName = PA.DoctorLastName AND
		DOC.PracticeID = @PracticeID AND
		DOC.[EXTERNAL] = 0  AND
		DOC.ActiveDoctor = 1 
WHERE ISDATE(pa.startdate) = 1   
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
	SELECT  DISTINCT  APP.AppointmentID , -- AppointmentID - int
	          2 , -- AppointmentResourceTypeID - int
	          PR.PracticeResourceID, -- ResourceID - int
	          GETDATE() , -- ModifiedDate - datetime
	          @PracticeID  -- PracticeID - int
	FROM dbo._import_3_1_PatientAppointments PA
	INNER JOIN dbo.Patient PAT ON 
		PAT.VendorID = PA.ChartNumber AND
		PAT.PracticeID = @PracticeID    
	INNER JOIN dbo.Appointment APP ON 
		APP.PatientID = PAT.PatientID AND 
		APP.StartDate = CAST(PA.StartDate AS DateTime) AND
		APP.EndDate = CAST(PA.EndDate AS Datetime)       
	INNER JOIN dbo.PracticeResource PR ON
		PR.ResourceName = PA.PracticeResource AND
		PR.PracticeID = @PracticeID  
WHERE ISDATE(pa.startdate) = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


--ROLLBACK
--COMMIT

  