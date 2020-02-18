USE superbill_18526_dev
--USE superbill_18526_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT


SET @PracticeID = 1
SET @VendorImportID = 7

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Updating Duplicated inserted as ZZZ+LastName by removing the VendorID...'
	UPDATE dbo.Patient 
		SET VendorID = NULL ,
			ModifiedDate = GETDATE()
	FROM dbo.Patient p 
WHERE p.LastName LIKE 'zzz%'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '

PRINT ''
PRINT 'Updating VendorID for Patient Records that were not inserted from @VendorImportID..'
	UPDATE dbo.Patient
		SET VendorID = i.patientid , 
			VendorImportID = @VendorImportID ,
			ModifiedDate = GETDATE() 
	FROM dbo.Patient p
		INNER JOIN dbo.[_import_7_1_PatientDemoPolicy] i ON
			p.FirstName = i.patientfirstname AND
			p.LastName  = i.patientlastname AND
			p.dob = DATEADD(hh,12,CAST(CAST(i.dob AS DATE)AS DATETIME))
		WHERE p.VendorID IS NULL
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '
													

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
			  @PracticeID , -- PracticeID - int
			  1, -- ServiceLocationID - int
			  impApp.startdate , -- StartDate - datetime
			  impApp.enddate , -- EndDate - datetime
			  'P' , -- AppointmentType - varchar(1)
			  impApp.patientname + ' - ' + impApp.provider , -- Subject - varchar(64)
			  impApp.ReasonForVisit , -- Notes - text
			  GETDATE() , -- CreatedDate - datetime
			  -50 , -- CreatedUserID - int
			  GETDATE() , -- ModifiedDate - datetime
			  -50 , -- ModifiedUserID - int
			  1 , -- AppointmentResourceTypeID - int
			  impApp.[status] , -- AppointmentConfirmationStatusCode - char(1)
			  realpc.[PatientCaseID] , -- PatientCaseID - int
			  dk.[DKPracticeID] , -- StartDKPracticeID - int
			  dk.[DKPracticeID] , -- EndDKPracticeID - int
			  impApp.starttm, -- StartTm - smallint
			  impApp.endtm -- EndTm - smallint
	FROM dbo.[_import_9_1_Appointment] AS impApp
	INNER JOIN dbo.Patient AS realpat ON
		realpat.[VendorID] = impApp.patientid AND
		realpat.[VendorImportID] = @VendorImportID  
	LEFT JOIN dbo.PatientCase AS realpc ON
		realpc.[VendorID] = impApp.patientid AND
		realpc.[VendorImportiD] = @VendorImportID AND 
		realpc.[PracticeID] = @PracticeID
	INNER JOIN dbo.DateKeyToPractice dk ON
		dk.[PracticeID] = @PracticeID AND
		dk.Dt = CAST(CAST(impApp.[startdate] AS DATE) AS DATETIME)   
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Appointment to Resource...'
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
			  impApp.provider , -- ResourceID - int
			  GETDATE() , -- ModifiedDate - datetime
			  @PracticeID  -- PracticeID - int
	FROM dbo.[_import_9_1_Appointment] AS impApp
	INNER JOIN dbo.Patient AS realpat ON 
		realpat.[VendorID] = impApp.patientid AND
		realpat.[VendorImportID] = @VendorImportID
	INNER JOIN dbo.Appointment AS realapp ON
		realapp.[PatientID] = realpat.[PatientID] AND
		realapp.[StartDate] = CAST(impApp.startdate AS DATETIME) AND
		realapp.EndDate = CAST(impApp.enddate AS DATETIME ) AND
		realapp.[Subject] = impApp.patientname + ' - ' + impApp.provider 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


--ROLLBACK
--COMMIT





