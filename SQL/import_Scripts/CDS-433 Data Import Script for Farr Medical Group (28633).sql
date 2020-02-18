USE superbill_28633_dev
--USE superbill_28633_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
 
-- Clear out any existing records for this import, (makes the script safe to run multiple times)
--PRINT ''
--PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VEndorImportID = @VendorImportID))
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentToAppointmentReason'
--DELETE FROM dbo.AppointmentReason WHERE PracticeID = @practiceID AND Name = description
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentReason'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from AppointmentToResource '
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from  Appointment '
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCase'
--DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'

PRINT ''
PRINT 'Inserting records into Patient...'
INSERT INTO dbo.Patient
        ( PracticeID ,
      --  ReferringPhysicianID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
      --  AddressLine1 ,
      --  AddressLine2 ,
      --  City ,
      --  State ,
          Country ,
      --  ZipCode ,
      --  Gender ,
      --  MaritalStatus ,
          HomePhone ,
      --  HomePhoneExt ,
      --  WorkPhone ,
      --  WorkPhoneExt ,
      --  DOB ,
          SSN ,
      --  EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
      --  ResponsibleFirstName ,
      --  ResponsibleMiddleName ,
      --  ResponsibleLastName , 
          ResponsibleSuffix ,
      --  ResponsibleRelationshipToPatient ,
      /*  ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,  */
          ResponsibleCountry ,
      --  ResponsibleZipCode ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     /*   RecordTimeStamp ,
          EmploymentStatus ,
          InsuranceProgramCode ,
          PatientReferralSourceID ,  
          PrimaryProviderID ,  */
      --  DefaultServiceLocationID ,
      --  EmployerID ,
          MedicalRecordNumber ,
      --  MobilePhone ,
      --  MobilePhoneExt ,
      --  PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID 
      --  CollectionCategoryID ,
      --  Active 
      --  SendEmailCorrespondence ,
      --  PhonecallRemindersEnabled ,
      --  EmergencyName ,
      --  EmergencyPhone ,
      --  EmergencyPhoneExt ,
      --  PatientGuid ,
      --  Ethnicity ,
      --  Race ,
      --  LicenseNumber 
      --  LicenseState ,
      --  Language1 ,
      --  Language2
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
      --  '' , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          ia.first , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          ia.last , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
      --  '' , -- AddressLine1 - varchar(256)
      --  '' , -- AddressLine2 - varchar(256)
      --  '' , -- City - varchar(128)
      --  '' , -- State - varchar(2) 
          '' , -- Country - varchar(32)  
      --  '' , -- ZipCode - varchar(9)
      --  '' , -- Gender - varchar(1)
      --  '' , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ia.phone,'-','')),10) , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
      --  '' , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
      --  '' , -- DOB - datetime
          CASE WHEN LEN(ia.socsec) >= 6 THEN RIGHT('000' + ia.socsec, 9) ELSE '' END , -- SSN - char(9)
      --  '' , -- EmailAddress - varchar(256)
          0 , --  ResponsibleDifferentThanPatient - BIT 
          '' , -- ResponsiblePrefix - varchar(16)
      --  '' , -- ResponsibleFirstName - varchar(64)
      --  '' , -- ResponsibleMiddleName - varchar(64)
      --  '' , -- ResponsibleLastName - varchar(64)
          '' , -- ResponsibleSuffix - varchar(16)
      --  '' , -- ResponsibleRelationshipToPatient - varchar(1)
      --  '' , -- ResponsibleAddressLine1 - varchar(256)
      --  '' , -- ResponsibleAddressLine2 - varchar(256)
      --  '' , -- ResponsibleCity - varchar(128)
      --  '' , -- ResponsibleState - varchar(2)
          '' , -- ResponsibleCountry - varchar(32)
      --  '' , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- EmploymentStatus - char(1)
      --  '' , -- InsuranceProgramCode - char(2)
      --  0 , -- PatientReferralSourceID - int
      --  '', -- PrimaryProviderID - int
      --  '' , -- DefaultServiceLocationID - int
      --  '' , -- EmployerID - int
          ia.mrn , -- MedicalRecordNumber - varchar(128)
      --  '' ,  -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  '' , -- PrimaryCarePhysicianID - int
          ia.mrn , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  0  , -- CollectionCategoryID - int
      --  '' ,  -- Active - bit
      --  NULL , -- SendEmailCorrespondence - bit
      --  NULL , -- PhonecallRemindersEnabled - bit
      --  '' , -- EmergencyName - varchar(128)
      --  '' , -- EmergencyPhone - varchar(10)
      --  '' , -- EmergencyPhoneExt - varchar(10)
      --  NULL , -- PatientGuid - uniqueidentifier
      --  '' , -- Ethnicity - varchar(64)
      --  '' , -- Race - varchar(64)
      --  '',  -- LicenseNumber - varchar(64)
      --  '' , -- LicenseState - varchar(2)
      --  '' , -- Language1 - varchar(64)
      --  ''  -- Language2 - varchar(64)
FROM dbo._import_1_1_Appointment as ia
WHERE ia.mrn <> '' AND NOT EXISTS (select * from  dbo.patient where MedicalRecordNumber = ia.mrn AND PracticeID = @practiceID)
-- AND ia.first <> ''  AND ia.last <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully'


PRINT ''
PRINT 'Inserting into PatientCase...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
     --   ReferringPhysicianID ,
     --   EmploymentRelatedFlag ,
     --   AutoAccidentRelatedFlag ,
     --   OtherAccidentRelatedFlag ,
     --   AbuseRelatedFlag ,
     --   AutoAccidentRelatedState ,
          Notes ,
     --   ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
     --   CaseNumber ,
     --   WorkersCompContactInfoID ,
          VendorID ,
          VendorImportID 
     --   PregnancyRelatedFlag ,
     --   StatementActive ,
     --   EPSDT ,
     --   FamilyPlanning ,
     --   EPSDTCodeID ,
     --   EmergencyRelated ,
     --   HomeboundRelatedFlag
        )
SELECT DISTINCT
          pat.PatientID , -- PatientID - int
          'Self Pay' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
      --  0 , -- ReferringPhysicianID - int
      --  NULL , -- EmploymentRelatedFlag - bit
      --  NULL , -- AutoAccidentRelatedFlag - bit
      --  NULL , -- OtherAccidentRelatedFlag - bit
      --  NULL , -- AbuseRelatedFlag - bit
      --  '' , -- AutoAccidentRelatedState - char(2)
          'Created via data import, please review' , -- Notes - text
      --  NULL , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
      --  '' , -- CaseNumber - varchar(128)
      --  0 , -- WorkersCompContactInfoID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  NULL , -- PregnancyRelatedFlag - bit
      --  NULL , -- StatementActive - bit
      --  NULL , -- EPSDT - bit
      --  NULL , -- FamilyPlanning - bit
      --  0 , -- EPSDTCodeID - int
      --  NULL , -- EmergencyRelated - bit
      --  NULL  -- HomeboundRelatedFlag - bit
FROM dbo.Patient as pat
WHERE VendorImportID=@VendorImportID AND PracticeID=@PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase'

PRINT ''
PRINT 'Inserting into AppointmentReason...'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
      --  DefaultColorCode ,
          Description ,
          ModifiedDate 
      --  TIMESTAMP ,
      --  AppointmentReasonGuid
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
          iar.name , -- Name - varchar(128)
          iar.defaultdurationminutes , -- DefaultDurationMinutes - int
      --  0 , -- DefaultColorCode - int
          iar.name , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
     --   NULL , -- TIMESTAMP - timestamp
     --   NULL  -- AppointmentReasonGuid - uniqueidentifier  
FROM dbo._import_1_1_AppointmentReasons as iar
where iar.name <> '' -- AND NOT EXISTS (select * from dbo.AppointmentReason where Name = iar.name AND PracticeID = @practiceID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into AppointmentReason'

PRINT ''
PRINT'Inserting records into Appointment...'
INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
      --  Subject ,
      --  Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
      --  AllDay ,
      --  InsurancePolicyAuthorizationID ,
          PatientCaseID ,
      --  Recurrence ,
      --  RecurrenceStartDate ,
      --  RangeEndDate ,
      --  RangeType ,
          StartDKPracticeID ,
          EndDKPracticeID ,
          StartTm ,
          EndTm 
      --  AppointmentGuid
        )
SELECT  DISTINCT  
          pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          ia.startdate , -- StartDate - datetime
          ia.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
      --  '' , -- Subject - varchar(64)
      --  '' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          ia.appointmentresourcetype, -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
      --  NULL , -- AllDay - bit
      --  0 , -- InsurancePolicyAuthorizationID - int
          patcase.PatientCaseID , -- PatientCaseID - int
      --  NULL , -- Recurrence - bit
      --  GETDATE() , -- RecurrenceStartDate - datetime
      --  GETDATE() , -- RangeEndDate - datetime
      --  '' , -- RangeType - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          ia.StartTm , -- StartTm - smallint
          ia.EndTm  -- EndTm - smallint
      --  NULL  -- AppointmentGuid - uniqueidentifier
FROM dbo._import_1_1_Appointment as ia
INNER JOIN dbo.patient AS pat ON
  pat.MedicalRecordNumber = ia.mrn and
  pat.practiceID = @PracticeID
LEFT JOIN dbo.patientcase AS patcase ON
  patcase.patientID = pat.patientID AND
  patcase.PracticeID = @PracticeID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(ia.startdate AS date) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted into Appointment Successfully'

PRINT ''
PRINT 'Inserting into AppointmentToAppointmentReason...'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
	  --  TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT
          dboa.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
	  --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo._import_1_1_Appointment as ia
INNER JOIN dbo.Patient AS pat ON 
    pat.MedicalRecordNumber = ia.mrn AND
    pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS dboa ON
    dboa.PatientID = pat.patientid AND
    dboa.startdate = CAST(ia.startdate AS DATETIME) AND 
    dboa.enddate = CAST(ia.enddate AS DATETIME) 
INNER JOIN dbo.AppointmentReason AS ar ON 
         ar.name = ia.reason
     AND ar.PracticeID = @PracticeID
	-- AND ar.DefaultDurationMinutes = ia.duration
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted AppointmentToAppointmentReason'

PRINT ''
PRINT 'Inserting records into AppointmenttoResource...'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
      --  TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT 
          dboa.AppointmentID , -- AppointmentID - int
          ia.AppointmentResourceType , -- AppointmentResourceTypeID - int
          ia.ResourceID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @practiceID  -- PracticeID - int
FROM dbo._import_1_1_Appointment as ia 
INNER JOIN dbo.patient AS pat ON
      pat.MedicalRecordNumber = ia.mrn AND
      pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS dboa ON
    dboa.PatientID = pat.patientid AND
    dboa.startdate = CAST(ia.startdate AS DATETIME) AND 
    dboa.enddate = CAST(ia.enddate AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource'



--COMMIT TRANSACTION
--ROLLBACK  
      


