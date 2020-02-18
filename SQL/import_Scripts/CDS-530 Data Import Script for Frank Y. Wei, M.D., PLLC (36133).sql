USE superbill_36133_dev
--USE superbill_36133_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 3 -- Vendor import record created through import tool

PRINT ''
PRINT 'Inserting into Appointment...'
 --Appointment
 INSERT INTO dbo.Appointment
   ( PatientID , PracticeID , ServiceLocationID , StartDate , EndDate , AppointmentType , Subject , Notes , CreatedDate ,
     CreatedUserID , ModifiedDate , ModifiedUserID , AppointmentResourceTypeID , AppointmentConfirmationStatusCode , PatientCaseID ,
     StartDKPracticeID , EndDKPracticeID , StartTm , EndTm )
SELECT DISTINCT
     realpat.[PatientID] , -- PatientID - int
     @PracticeID ,
     sl.ServiceLocationID , -- ServiceLocationID - int
     CAST([date] AS DATETIME) + starttime , -- StartDate - datetime
     CAST([date] AS DATETIME) + DATEADD(n, CAST([length] AS INT) ,starttime) , -- EndDate - datetime
     'P' , -- AppointmentType - varchar(1)
     impApp.id , -- Subject - varchar(64)
     impApp.[note] , -- Notes - text
     GETDATE() , -- CreatedDate - datetime
     0 , -- CreatedUserID - int
     GETDATE() , -- ModifiedDate - datetime
     0 , -- ModifiedUserID - int
     1 , -- AppointmentResourceTypeID - int
     'S' , -- AppointmentConfirmationStatusCode - char(1)
     realpc.[PatientCaseID] , -- PatientCaseID - int
     dk.[DKPracticeID] , -- StartDKPracticeID - int
     dk.[DKPracticeID] , -- EndDKPracticeID - int
     CAST(REPLACE(starttime,':','') AS SMALLINT) , -- StartTm - smallint
     REPLACE(LTRIM(REPLACE(LEFT(REPLACE(REPLACE(CAST(DATEADD(n, CAST([length] AS INT), starttime) AS TIME),':',''),'.',''), 4),'0', ' ')),' ','0')  -- EndTm - smallint
FROM dbo.[_import_4_1_Appointments] AS impApp
	INNER JOIN dbo.Patient AS realpat ON
		realpat.[VendorID] = impApp.[chartnumber] AND
		realpat.[VendorImportID] = @VendorImportID  
	LEFT JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impApp.[chartnumber] AND
		realpc.[VendorImportID] = @VendorImportID AND
		realpc.[PracticeID] = @PracticeID
	INNER JOIN dbo.DateKeyToPractice dk ON
		dk.[PracticeID] = @PracticeID AND
		dk.Dt = CAST(CAST(impApp.[date] AS DATE) AS DATETIME)
	LEFT JOIN dbo.ServiceLocation sl ON
		sl.PracticeID = @PracticeID AND
		sl.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID)
WHERE impApp.chartnumber <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Appointment To Resource...'
INSERT INTO dbo.AppointmentToResource
   ( AppointmentID , AppointmentResourceTypeID , ResourceID , ModifiedDate , PracticeID )
SELECT DISTINCT
     realapp.[AppointmentID] , -- AppointmentID - int
     1 , -- AppointmentResourceTypeID - int
     CASE impApp.provider 
		WHEN 1 THEN 1 
		WHEN 2 THEN 4 
		ELSE 1 END  , -- ResourceID - int
     GETDATE() , -- ModifiedDate - datetime
     @PracticeID  -- PracticeID - int
FROM dbo.[_import_4_1_Appointments] AS impApp
	INNER JOIN dbo.Appointment AS realapp ON
		impApp.id = realapp.[Subject] AND
		realapp.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Appointment with blank chart number...'
 --Appointment
 INSERT INTO dbo.Appointment
	( PracticeID , ServiceLocationID , StartDate , EndDate , AppointmentType , [Subject] , Notes , CreatedDate , CreatedUserID ,
      ModifiedDate , ModifiedUserID , AppointmentResourceTypeID , AppointmentConfirmationStatusCode , StartDKPracticeID ,
      EndDKPracticeID , StartTm , EndTm )
 SELECT DISTINCT
     @PracticeID ,
     sl.ServiceLocationID ,
	 CAST([date] AS DATETIME) + starttime , -- StartDate - datetime
     CAST([date] AS DATETIME) + DATEADD(n, CAST([length] AS INT) ,starttime) , -- EndDate - datetime
     'O' , -- AppointmentType - varchar(1)
     impApp.NAME + ' - ' + impApp.ID , -- Subject - varchar(64)
     impApp.[note] , -- Notes - text
     GETDATE() , -- CreatedDate - datetime
     0 , -- CreatedUserID - int
     GETDATE() , -- ModifiedDate - datetime
     0 , -- ModifiedUserID - int
     1 , -- AppointmentResourceTypeID - int
     'S' , -- AppointmentConfirmationStatusCode - char(1)
     dk.[DKPracticeID] , -- StartDKPracticeID - int
     dk.[DKPracticeID] , -- EndDKPracticeID - int
     CAST(REPLACE(starttime,':','') AS SMALLINT) , -- StartTm - smallint
     REPLACE(LTRIM(REPLACE(LEFT(REPLACE(REPLACE(CAST(DATEADD(n, CAST([length] AS INT), starttime) AS TIME),':',''),'.',''), 4),'0', ' ')),' ','0')  -- EndTm - smallint
FROM dbo.[_import_4_1_Appointments] AS impApp
	INNER JOIN dbo.DateKeyToPractice dk ON
		dk.[PracticeID] = @PracticeID AND
		dk.Dt = CAST(CAST(impApp.[date] AS DATE) AS DATETIME)
	LEFT JOIN dbo.ServiceLocation sl ON
		sl.PracticeID = @PracticeID AND
		sl.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID)
	LEFT JOIN dbo.Patient AS realpat ON
		realpat.[VendorID] = impApp.[chartnumber] AND
		realpat.[VendorImportID] = @VendorImportID  
WHERE impApp.chartnumber = '' OR realpat.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Appointment To Resource with blank chart number...'
 --AppointmentToResource
INSERT INTO dbo.AppointmentToResource
   ( AppointmentID ,
     AppointmentResourceTypeID ,
     ResourceID ,
     ModifiedDate ,
     PracticeID
   )
SELECT DISTINCT
     realapp.[AppointmentID] , -- AppointmentID - int
     1 , -- AppointmentResourceTypeID - int
     CASE impApp.PROVIDER 
		WHEN 1 THEN 1 
		WHEN 2 THEN 4 
		ELSE 1 END  , -- ResourceID - int
     GETDATE() , -- ModifiedDate - datetime
     @PracticeID  -- PracticeID - int
FROM dbo.[_import_4_1_Appointments] AS impApp
	INNER JOIN dbo.Appointment AS realapp ON
		impApp.NAME + ' - ' + impApp.ID = realapp.[Subject] AND
		realapp.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT