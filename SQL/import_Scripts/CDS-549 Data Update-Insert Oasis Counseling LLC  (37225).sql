USE superbill_37225_dev
--USE superbill_37225_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          DOB ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  @PracticeID ,
          '' ,
          RTRIM(LTRIM(i.FirstName)) ,
          '' ,
          RTRIM(LTRIM(i.LastName)) ,
          '' ,
          i.[Address] ,
          '' ,
          i.City ,
          i.[State] ,
          '' ,
          i.zipcode ,
          i.Gender ,
		  '' ,
          dbo.fn_RemoveNonNumericCharacters(i.phonenumber) ,
          i.dob ,
          0 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          'U' ,
          i.patientid ,
          i.patientid ,
          @VendorImportID ,
          1 ,
          1 ,
          0 ,
          0 
FROM dbo.[_import_2_1_PatientList2] i
LEFT JOIN dbo.Patient p ON 
	i.patientid = p.VendorID AND p.VendorImportID = 1
WHERE p.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          PregnancyRelatedFlag ,
          StatementActive ,
          EPSDT ,
          FamilyPlanning ,
          EPSDTCodeID ,
          EmergencyRelated ,
          HomeboundRelatedFlag
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Selp Pay' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
		  p.PatientID ,
          @PracticeID ,
          1 ,
          i.StartDate ,
          i.EndDate ,
          'P' ,
          '' ,
          CASE WHEN i.note = '' THEN '' ELSE i.note + CHAR(13) + CHAR(10) END + i.textbox14  ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          CASE i.[status] WHEN 'cancellation' THEN 'X' WHEN 'Present' THEN 'I' ELSE 'S' END,
          pc.PatientCaseID ,
          dk.DKPracticeID ,
          dk.DKPracticeID ,
          i.StartTm ,
          i.EndTm 
FROM dbo.[_import_2_1_Appointment] i
INNER JOIN dbo.Patient p ON 
	RTRIM(LTRIM(i.patientfirst)) = RTRIM(LTRIM(p.FirstName)) AND 
	RTRIM(LTRIM(i.patientlast)) = RTRIM(LTRIM(p.LastName)) AND
	p.VendorImportID IN (1,@VendorImportID)
LEFT JOIN dbo.PatientCase pc ON
	p.PatientID = pc.PatientCaseID AND
	pc.VendorImportID IN (1,@VendorImportID)
INNER JOIN dbo.DateKeyToPractice dk ON
    dk.[PracticeID] = @PracticeID AND
    dk.Dt = CAST(CAST(i.startdate AS DATE) AS DATETIME)
LEFT JOIN dbo.Appointment a ON 
	a.PatientID = p.PatientID AND 
	a.StartDate = i.StartDate AND
	a.EndDate = i.EndDate
WHERE a.AppointmentID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Appointment Reason...'
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
          i.reasons , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
          0 , -- DefaultColorCode - int
          i.reasons , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo.[_import_2_1_Appointment] i WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ar.name = i.reasons AND ar.PracticeID = @PracticeID) AND i.reasons <> ''
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
		  a.AppointmentID, -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_Appointment] i
INNER JOIN dbo.AppointmentReason ar ON 
	i.reasons = ar.Name AND
	ar.PracticeID = @PracticeID
INNER JOIN dbo.Patient p ON 
	RTRIM(LTRIM(p.FirstName)) = RTRIM(LTRIM(i.patientfirst)) AND 
	RTRIM(LTRIM(p.LastName)) = RTRIM(LTRIM(p.LastName)) AND
	p.PracticeID = @PracticeID
INNER JOIN dbo.Appointment a ON 
	p.PatientID = a.PatientID AND
	a.PracticeID = @PracticeID AND
	a.StartDate = i.startdate AND 
	a.EndDate = i.enddate
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
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
		  a.appointmentid , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          CASE WHEN d.DoctorID IS NULL THEN 2 ELSE d.DoctorID END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_2_1_Appointment] i
INNER JOIN dbo.Patient p ON 
	p.FirstName = RTRIM(LTRIM(i.patientfirst)) AND 
	p.LastName = RTRIM(LTRIM(p.LastName)) AND
	p.PracticeID = @PracticeID
INNER JOIN dbo.Appointment a ON 
	p.PatientID = a.PatientID AND
	a.PracticeID = @PracticeID AND
	a.StartDate = i.startdate AND 
	a.EndDate = i.enddate
LEFT JOIN dbo.Doctor d ON 
	RTRIM(LTRIM(i.providerlast)) = d.LastName AND 
	d.[External] = 0 AND
	d.PracticeID = @PracticeID AND 
	d.ActiveDoctor = 1
WHERE a.CreatedDate > DATEADD(mi,-1,GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--COMMIT
--ROLLBACK