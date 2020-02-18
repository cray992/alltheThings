USE superbill_30864_dev
--USE superbill_30864_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 2 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


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
			  realpat.[PatientID] , -- PatientID - int
			  @PracticeID ,
			   -- PracticeID - int
			  CASE	WHEN realpat.[defaultserviceLocationID] IS NOT NULL THEN realpat.[defaultServiceLocationID] 
					ELSE (SELECT ServiceLocationID FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID AND 
										ServiceLocationID = (SELECT MIN(ServiceLocationID) FROM dbo.ServiceLocation WHERE practiceID = @PracticeID)) END , -- ServiceLocationID - int
			  impApp.startdate , -- StartDate - datetime
			  impApp.enddate  , -- EndDate - datetime
			  'P' , -- AppointmentType - varchar(1)
			  impapp.id , -- Subject - varchar(64)
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
			  impapp.starttm , -- StartTm - smallint
			  impapp.endtm -- EndTm - smallint
	FROM dbo._import_2_1_Appointments AS impApp
	INNER JOIN dbo.Patient AS realpat ON
		realpat.[VendorID] = impApp.[chartnumber] AND
		realpat.[VendorImportID] = @VendorImportID  
	LEFT JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impApp.[chartnumber] AND
		realpc.[VendorImportiD] = @VendorImportID AND 
		realpc.[PracticeID] = @PracticeID
	INNER JOIN dbo.DateKeyToPractice dk ON
		dk.[PracticeID] = @PracticeID AND
		dk.Dt = CAST(CAST(impApp.[startdate] AS DATE) AS DATETIME)   
WHERE NOT EXISTS (SELECT * FROM dbo.Appointment a WHERE a.[Subject] = impApp.id) AND realpc.Name <> 'Balance Forward' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting Into AppointmentoResource...'
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
			  realdoc.[DoctorID] , -- ResourceID - int
			  GETDATE() , -- ModifiedDate - datetime
			  @PracticeID  -- PracticeID - int
	FROM dbo._import_2_1_Appointments AS impApp
	INNER JOIN dbo.Patient AS realpat ON 
		realpat.[VendorID] = impApp.[chartnumber] AND
		realpat.[VendorImportID] = @VendorImportID
	INNER JOIN dbo.Appointment AS realapp ON
		realapp.[PatientID] = realpat.[PatientID] AND
		realapp.Subject = impapp.id AND
		realapp.CreatedDate > DATEADD(mi, -1,GETDATE())
	INNER JOIN dbo._import_2_1_Providers AS impPro ON
		impPro.[code] = impApp.[provider]
	INNER JOIN dbo.Doctor AS realdoc ON
		realdoc.[FirstName] = impPro.[firstname] AND
		realdoc.[LastName] = impPro.[lastname] AND
		realdoc.[External] = 0 AND
		realdoc.[PracticeID] = @PracticeID  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--COMMIT
--ROLLBACK