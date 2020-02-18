USE superbill_27126_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @Timezone INT

SET @PracticeID = 5
SET @VendorImportID = 5

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
PRINT ''

 --Appointment
 INSERT INTO dbo.Appointment
   ( PatientID , PracticeID , ServiceLocationID , StartDate , EndDate , AppointmentType , Subject , Notes , CreatedDate ,
     CreatedUserID , ModifiedDate , ModifiedUserID , AppointmentResourceTypeID , AppointmentConfirmationStatusCode , PatientCaseID ,
     StartDKPracticeID , EndDKPracticeID , StartTm , EndTm )
SELECT DISTINCT
     realpat.[PatientID] , -- PatientID - int
     @PracticeID ,
     sl.ServiceLocationID , -- ServiceLocationID - int
     CAST([date] AS DATETIME) + impApp.starttime , -- StartDate - datetime
     CAST([date] AS DATETIME) + DATEADD(n, CAST([length] AS INT) ,impApp.starttime) , -- EndDate - datetime
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
     CAST(REPLACE(impApp.starttime,':','') AS SMALLINT) , -- StartTm - smallint
     REPLACE(LTRIM(REPLACE(LEFT(REPLACE(REPLACE(CAST(DATEADD(n, CAST([length] AS INT), impApp.starttime) AS TIME),':',''),'.',''), 4),'0', ' ')),' ','0')  -- EndTm - smallint
FROM dbo._import_5_5_Appointments AS impApp
	INNER JOIN dbo._import_5_5_PatientData imPD ON 
		impApp.chartnumber = imPd.chartnumber
	INNER JOIN dbo.Patient AS realpat ON
		realpat.FirstName = imPD.firstname AND
		realpat.LastName = imPD.lastname AND
		realpat.DOB = DATEADD(hh,12,CAST(imPD.dateofbirth AS DATETIME)) AND
		realpat.PracticeID = @PracticeID
	LEFT JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impApp.[chartnumber] + impApp.casenumber AND
		realpc.[VendorImportID] = @VendorImportID AND
		realpc.[PracticeID] = @PracticeID
	INNER JOIN dbo.DateKeyToPractice dk ON
		dk.[PracticeID] = @PracticeID AND
		dk.Dt = CAST(CAST(impApp.[date] AS DATE) AS DATETIME)
	LEFT JOIN dbo.ServiceLocation sl ON
		sl.PracticeID = @PracticeID AND
		sl.ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID)
	LEFT JOIN dbo.Appointment a ON 
		CAST(impApp.[date] AS DATETIME) + impApp.starttime = a.StartDate AND
		CAST([date] AS DATETIME) + DATEADD(n, CAST([length] AS INT) ,impApp.starttime) = a.EndDate AND
		a.PatientID = realpat.PatientID
WHERE impApp.chartnumber <> '' AND a.AppointmentID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Appointments - Patient'
PRINT ''

 --AppointmentToResource
INSERT INTO dbo.AppointmentToResource
   ( AppointmentID , AppointmentResourceTypeID , ResourceID , ModifiedDate , PracticeID )
SELECT DISTINCT
     realapp.[AppointmentID] , -- AppointmentID - int
     1 , -- AppointmentResourceTypeID - int
     CASE 
		WHEN realdoc.[DoctorID] IS NULL THEN (SELECT MIN(DoctorID) FROM dbo.Doctor AS D WHERE d.PracticeID = @PracticeID AND d.[External] = 0 AND ActiveDoctor = 1)
	 ELSE realdoc.[DoctorID] END , -- ResourceID - int
     GETDATE() , -- ModifiedDate - datetime
     @PracticeID  -- PracticeID - int
FROM dbo._import_5_5_Appointments AS impApp
	INNER JOIN dbo.Appointment AS realapp ON
		impApp.id = realapp.[Subject] AND
		realapp.PracticeID = @PracticeID
	LEFT JOIN dbo._import_5_5_Providers AS impPro ON
		impPro.code = impApp.provider
	LEFT JOIN dbo.Doctor AS realdoc ON
		realdoc.[FirstName] = impPro.[firstname] AND
		realdoc.[LastName] = impPro.[lastname] AND
		realdoc.[External] = 0 AND
		realdoc.ActiveDoctor = 1 AND
		realdoc.[PracticeID] = @PracticeID  
WHERE realapp.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Appointment to Resource - Patient'
PRINT '' 



--ROLLBACK
--Commit

