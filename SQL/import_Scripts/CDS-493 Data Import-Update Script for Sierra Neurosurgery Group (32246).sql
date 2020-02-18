USE superbill_32246_dev 
--USE superbill_32246_prod
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
PRINT 'Updating Patient MRN with Import PersonNumber...'
UPDATE dbo.Patient 
SET MedicalRecordNumber = i.personnumber
FROM dbo.Patient p 
INNER JOIN dbo.[_import_2_1_Sheet1] i ON
i.mrnchartnumber = p.MedicalRecordNumber AND
p.VendorImportID = 1
WHERE p.VendorID <> '{EDAD6A52-3B61-4232-A8FD-11269B9FF9D7}'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Apppointment - Patient...'
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
          CASE WHEN sl.ServiceLocationID IS NULL THEN 1 ELSE sl.ServiceLocationID END  , -- ServiceLocationID - int *************
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          i.apptnbr , -- Subject - varchar(64)
          CASE WHEN i.userdefined1 = '' THEN '' ELSE 'User Defined 1: ' + i.userdefined1 + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.userdefined2 = '' THEN '' ELSE 'User Defined 2: ' + i.userdefined2 + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.details = '' THEN '' ELSE 'Details: ' + i.details + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.notes = '' THEN '' ELSE 'Notes: ' + i.notes END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          pc.PatientCaseID , -- PatientCaseID - int
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[_import_2_1_Appointment] i
INNER JOIN dbo.Patient p ON 
i.personid = p.VendorID AND
p.VendorImportID = 1
LEFT JOIN dbo.PatientCase pc ON
p.PatientID = pc.PatientID AND 
pc.VendorImportID = 1
LEFT JOIN dbo.ServiceLocation sl ON 
sl.Name = i.locationname AND 
sl.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(i.startdate AS date) AS DATETIME) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Apppointment - Other...'
INSERT INTO dbo.Appointment
        ( 
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
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          CASE WHEN sl.ServiceLocationID IS NULL THEN 1 ELSE sl.ServiceLocationID END  , -- ServiceLocationID - int *************
          i.startdate , -- StartDate - datetime
          i.enddate , -- EndDate - datetime
          'O' , -- AppointmentType - varchar(1)
          CASE WHEN i.apptdescription = '' THEN i.[event] + ' - ' + i.apptnbr ELSE i.apptdescription + ' - ' + i.apptnbr END , -- Subject - varchar(64)
          CASE WHEN i.userdefined1 = '' THEN '' ELSE 'User Defined 1: ' + i.userdefined1 + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.userdefined2 = '' THEN '' ELSE 'User Defined 2: ' + i.userdefined2 + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.details = '' THEN '' ELSE 'Details: ' + i.details + CHAR(13) + CHAR(10) END +
		  CASE WHEN i.notes = '' THEN '' ELSE 'Notes: ' + i.notes END , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          i.starttm , -- StartTm - smallint
          i.endtm  -- EndTm - smallint
FROM dbo.[_import_2_1_Appointment] i
LEFT JOIN dbo.ServiceLocation sl ON 
sl.Name = i.locationname AND 
sl.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(i.startdate AS date) AS DATETIME) 
WHERE i.personid = ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment Reason...'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
          DefaultColorCode ,
          [Description] ,
          ModifiedDate 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          i.[event] , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          '' , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_2_1_Appointment] i
WHERE i.event <> '' AND i.personid <> '' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ar.Name = i.event)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into AppointmenttoAppointment Reason...'
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
FROM dbo.[_import_2_1_Appointment] i 
INNER JOIN dbo.Appointment a ON
a.[Subject] = i.apptnbr AND
a.StartDate = CAST(i.startdate AS DATETIME) 
INNER JOIN dbo.AppointmentReason ar ON 
i.[event] = ar.Name
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating AppointmenttoResource PracticeID'
UPDATE dbo.AppointmentToResource
SET PracticeID = @PracticeID
WHERE PracticeID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into AppointmentoResource 1 - Patient'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          TIMESTAMP ,
          PracticeID
        )
SELECT DISTINCT
		  a.AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          CASE i.providerlastname WHEN 'Leppla MD' THEN 1
								  WHEN 'Ballard APRN' THEN 2
								  WHEN 'Blake MD' THEN 3
								  WHEN 'Canner Peterson' THEN 4
								  WHEN 'Davis MD' THEN 5
								  WHEN 'Demers MD' THEN 6
								  WHEN 'Edwards MD' THEN 7
								  WHEN 'Erickson, PA-C' THEN 8
								  WHEN 'Fleming MD PhD' THEN 9
								  WHEN 'Graves, PA-C' THEN 10 
								  WHEN 'Keller APRN' THEN 11
								  WHEN 'Khosla MD' THEN 12
								  WHEN 'Lasko MD' THEN 13 
								  WHEN 'Minard APRN' THEN 14
								  WHEN 'Morgan MD' THEN 15
								  WHEN 'Sands PA C' THEN 16
								  WHEN 'Sapir APRN' THEN 17
								  WHEN 'Sekhon MD' THEN 18
								  WHEN 'Teixeira-Smith, MSN' THEN 19
								  WHEN 'Vacca MD' THEN 20
								  WHEN 'Walker MD' THEN 21
								  WHEN 'Waters' THEN 22
								  END , -- ResourceID - int **********************
          GETDATE() , -- ModifiedDate - datetime
          NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_Appointment] i 
INNER JOIN dbo.Appointment a ON
a.[Subject] = i.apptnbr AND
a.StartDate = CAST(i.startdate AS DATETIME) 
WHERE i.providerlastname NOT IN ('Halvorsen CRNFA' , 'Mandell PAC')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into AppointmentoResource 1 - Other'
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
          CASE i.providerlastname WHEN 'Leppla MD' THEN 1
								  WHEN 'Ballard APRN' THEN 2
								  WHEN 'Blake MD' THEN 3
								  WHEN 'Canner Peterson' THEN 4
								  WHEN 'Davis MD' THEN 5
								  WHEN 'Demers MD' THEN 6
								  WHEN 'Edwards MD' THEN 7
								  WHEN 'Erickson, PA-C' THEN 8
								  WHEN 'Fleming MD PhD' THEN 9
								  WHEN 'Graves, PA-C' THEN 10 
								  WHEN 'Keller APRN' THEN 11
								  WHEN 'Khosla MD' THEN 12
								  WHEN 'Lasko MD' THEN 13 
								  WHEN 'Minard APRN' THEN 14
								  WHEN 'Morgan MD' THEN 15
								  WHEN 'Sands PA C' THEN 16
								  WHEN 'Sapir APRN' THEN 17
								  WHEN 'Sekhon MD' THEN 18
								  WHEN 'Teixeira-Smith, MSN' THEN 19
								  WHEN 'Vacca MD' THEN 20
								  WHEN 'Walker MD' THEN 21
								  WHEN 'Waters' THEN 22
								  END , -- ResourceID - int **********************
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_Appointment] i 
INNER JOIN dbo.Appointment a ON
a.StartDate = CAST(i.startdate AS DATETIME) AND
a.EndDate = CAST(i.enddate AS DATETIME) AND
RIGHT(a.[Subject], 6) = RIGHT(i.apptnbr , 6)
WHERE i.providerlastname NOT IN ('Halvorsen CRNFA' , 'Mandell PAC') AND a.AppointmentType = 'O'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into AppointmentoResource 2'
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
          CASE i.providerlastname WHEN 'Halvorsen CRNFA' THEN (SELECT PracticeResourceID from dbo.PracticeResource WHERE ResourceName = 'Candace Halvorsen CRNFA')
								   WHEN 'Mandell PAC' THEN (SELECT PracticeResourceID from dbo.PracticeResource WHERE ResourceName = 'Lisa Mandell PAC') 
								   END , -- ResourceID - int **********************
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_Appointment] i 
INNER JOIN dbo.Appointment a ON
a.StartDate = CAST(i.startdate AS DATETIME) AND
a.EndDate = CAST(i.enddate AS DATETIME) AND
RIGHT(a.[Subject], 6) = RIGHT(i.apptnbr , 6)
WHERE i.providerlastname IN ('Halvorsen CRNFA' , 'Mandell PAC')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Cases with no Policies...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11 ,
		Name = 'Self Pay'
FROM dbo.PatientCase pc
LEFT JOIN dbo.InsurancePolicy ip ON
		pc.PatientCaseID = ip.PatientCaseID  
WHERE pc.VendorImportID = 1 AND
      ip.PatientCaseID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

