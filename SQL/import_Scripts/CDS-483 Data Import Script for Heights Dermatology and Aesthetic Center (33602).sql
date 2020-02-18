USE superbill_33602_dev
--USE superbill_XXX_prod
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
/*
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentToAppointmentReason'
DELETE FROM dbo.AppointmentReason WHERE PracticeID = @practiceID AND Name = [description]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentReason'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from AppointmentToResource '
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from  Appointment '
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCase'
DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'
*/

SET IDENTITY_INSERT dbo.Patient ON
PRINT ''
PRINT 'Inserting records into patient'
INSERT INTO dbo.Patient
        ( PracticeID ,
		  PatientID,
      --  ReferringPhysicianID ,
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
      --  MaritalStatus ,
          HomePhone ,
      --  HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
      --  SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName , 
          ResponsibleSuffix ,
          ResponsibleRelationshipToPatient ,
      /*  ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,  */
          --ResponsibleCountry ,
      --  ResponsibleZipCode ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
      --  EmploymentStatus ,
      /*  InsuranceProgramCode ,
          PatientReferralSourceID ,  */
      --  PrimaryProviderID ,  
      --  DefaultServiceLocationID ,
      --  EmployerID ,
          --MedicalRecordNumber ,
          MobilePhone ,
      --  MobilePhoneExt ,
      --  PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
      --  CollectionCategoryID ,
          Active 
      --  SendEmailCorrespondence ,
      --  PhonecallRemindersEnabled ,
      --  EmergencyName ,
      --  EmergencyPhone 
      --  EmergencyPhoneExt ,
      --  PatientGuid ,
      --  Ethnicity ,
      --  Race ,
      --  LicenseNumber 
      --  LicenseState ,
      --  Language1 ,
      --  Language2
        )
SELECT  DISTINCT
          @PracticeID , -- PracticeID - int
		  pd.mrn , -- PatientID
      --  '' , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          pd.patientfirstname , -- FirstName - varchar(64)
          pd.patientmiddlename , -- MiddleName - varchar(64)
          pd.patientlastname , -- LastName - varchar(64)
          '' ,  -- Suffix - varchar(16)
          pd.addr1 , -- AddressLine1 - varchar(256)
          pd.addr2 , -- AddressLine2 - varchar(256)
          pd.city , -- City - varchar(128)
          pd.state , -- State - varchar(2)
          '' , -- Country - varchar(32) 
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pd.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(pd.zip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pd.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(pd.zip)
			   ELSE '' END	, -- zipcode - varchar(9)	  
          pd.gender  , -- Gender - varchar(1)
      --  '' , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.homephone,' ','')),10) , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.workphone,' ','')),10) , -- WorkPhone - varchar(10)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pd.workphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(pd.homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(pd.homephone))),10)
		  ELSE NULL END , -- WorkPhoneExt - varchar(10)
          pd.dob  , -- DOB - datetime
	  --  '' , -- SSN - char(9)
          pd.emailaddr , -- EmailAddress - varchar(256) 
          CASE WHEN pd.relationshiptoguarantor <> '' THEN 1 ELSE 0 END , --  ResponsibleDifferentThanPatient - BIT ,
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN pd.relationshiptoguarantor <> '' THEN pd.guarantorfirstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN pd.relationshiptoguarantor <> '' THEN pd.guarantormiddlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN pd.relationshiptoguarantor <> '' THEN pd.guarantorlastname END , -- ResponsibleLastName - varchar(64)  */
          '' , -- ResponsibleSuffix - varchar(16)
          CASE WHEN pd.relationshiptoguarantor='CHILD' THEN 'C'
		       WHEN pd.relationshiptoguarantor='OTHER' THEN 'O'
			   WHEN pd.relationshiptoguarantor='SPOUSE' THEN 'U' ELSE 'S' END , -- ResponsibleRelationshipToPatient - varchar(1)
      /*  '' , -- ResponsibleAddressLine1 - varchar(256)
          '' , -- ResponsibleAddressLine2 - varchar(256)
          '' , -- ResponsibleCity - varchar(128)
          '' , -- ResponsibleState - varchar(2)  */
          --'' , -- ResponsibleCountry - varchar(32)
      --  '' , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- EmploymentStatus - char(1)
      --  '' , -- InsuranceProgramCode - char(2)
      --  0  , -- PatientReferralSourceID - int
      --  '' , -- PrimaryProviderID - int
      --  0  , -- DefaultServiceLocationID - int
      --  '' , -- EmployerID - int
          --pd.mrn , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.cellphone,' ','')),10) ,  -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  '' , -- PrimaryCarePhysicianID - int
          pd.mrn , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  0 , -- CollectionCategoryID - int
          1  -- Active - bit
      --  NULL , -- SendEmailCorrespondence - bit
      --  NULL , -- PhonecallRemindersEnabled - bit
      --  '' , -- EmergencyName - varchar(128)
      --  ''   -- EmergencyPhone - varchar(10)
      --  '' , -- EmergencyPhoneExt - varchar(10)
      --  NULL , -- PatientGuid - uniqueidentifier
      --  '' , -- Ethnicity - varchar(64)
      --  '' , -- Race - varchar(64)
      --  '' ,  -- LicenseNumber - varchar(64)
      --  '' , -- LicenseState - varchar(2)
      --  '' , -- Language1 - varchar(64)
      --  ''  -- Language2 - varchar(64)
FROM dbo.[_import_1_1_Patients] as pd
WHERE pd.mrn <>'' AND NOT EXISTS (select * from  dbo.patient where MedicalRecordNumber = pd.mrn AND PracticeID = @practiceID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into patient Successfully'
SET IDENTITY_INSERT dbo.Patient OFF

PRINT ''
PRINT 'Inserting into PatientCase'
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
          pat.VendorID , -- VendorID - varchar(50)
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
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into patientcase'

PRINT ''
PRINT 'Inserting into AppointmentReason'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
       -- DefaultColorCode ,
          --Description ,
          ModifiedDate 
     --   TIMESTAMP ,
     --   AppointmentReasonGuid
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
          imapp.appointmentreason , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
      --  0 , -- DefaultColorCode - int
          --imapp.appointmentreason , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
     --   NULL , -- TIMESTAMP - timestamp
     --   NULL  -- AppointmentReasonGuid - uniqueidentifier  
FROM dbo.[_import_1_1_Appointment] as imapp
where imapp.appointmentreason<>''  AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE imapp.appointmentreason = ar.Name)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into AppointmentReason'

PRINT ''
PRINT'Inserting records into Primary Appointment'
INSERT INTO dbo.Appointment
        ( 
		  PatientID ,
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

SELECT DISTINCT   
          pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          CASE WHEN imapp.servicelocation = 'Heights Dermatology-Willowbrook' THEN '1'
		       WHEN	imapp.servicelocation = 'Lake Jackson Dermatology' THEN '2' 
			   WHEN imapp.servicelocation = 'Heights:' THEN '3' END , -- ServiceLocationID - int
          imapp.startdate , -- StartDate - datetime
          imapp.enddate , -- EndDate - datetime
          imapp.appointmenttype , -- AppointmentType - varchar(1)
          CASE WHEN imapp.appointmenttype = 'O' THEN imapp.appointmentreason  ELSE '' END , -- Subject - varchar(64)8**********
          imapp.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
           imapp.resourcetypeid , -- AppointmentResourceTypeID - int
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
          imapp.starttm , -- StartTm - smallint
          imapp.endtm  -- EndTm - smallint
      --  NULL  -- AppointmentGuid - uniqueidentifier
FROM dbo.[_import_1_1_Appointment] as imapp
INNER JOIN dbo.patient AS pat ON
   pat.PatientID = imapp.patientmrn  and
   pat.practiceID = @PracticeID
LEFT JOIN dbo.patientcase AS patcase ON
  patcase.patientID = pat.patientID AND
  patcase.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(imapp.startdate AS date) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted into Appointment Successfully'

PRINT ''
PRINT'Inserting records into Other Appointment'
INSERT INTO dbo.Appointment
        ( 
		  --PatientID ,
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
      --  RecordTimeStamp ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
      --  AllDay ,
      --  InsurancePolicyAuthorizationID ,
          --PatientCaseID ,
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

SELECT DISTINCT   
          --pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          CASE WHEN imapp.servicelocation = 'Heights Dermatology-Willowbrook' THEN '1'
		       WHEN	imapp.servicelocation = 'Lake Jackson Dermatology' THEN '2' 
			   WHEN imapp.servicelocation = 'Heights:' THEN '3' END , -- ServiceLocationID - int
          imapp.startdate , -- StartDate - datetime
          imapp.enddate , -- EndDate - datetime
          imapp.appointmenttype , -- AppointmentType - varchar(1)
          CASE WHEN imapp.appointmenttype = 'O' THEN imapp.appointmentreason ELSE '' END , -- Subject - varchar(64)8**********
          imapp.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
           imapp.resourcetypeid , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
      --  NULL , -- AllDay - bit
      --  0 , -- InsurancePolicyAuthorizationID - int
          --patcase.PatientCaseID , -- PatientCaseID - int
      --  NULL , -- Recurrence - bit
      --  GETDATE() , -- RecurrenceStartDate - datetime
      --  GETDATE() , -- RangeEndDate - datetime
      --  '' , -- RangeType - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          imapp.starttm , -- StartTm - smallint
          imapp.endtm  -- EndTm - smallint
      --  NULL  -- AppointmentGuid - uniqueidentifier
FROM dbo.[_import_1_1_Appointment] as imapp
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(imapp.startdate AS date) AS DATETIME)
WHERE imapp.appointmenttype = 'O'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted into Appointment Successfully'


PRINT ''
PRINT 'Inserting records into AppointmentToAppointmentReason'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
     --   TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT 
          a.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID -- PracticeID - int  
FROM dbo.[_import_1_1_Appointment] as imapp      
INNER JOIN dbo.Appointment AS a ON
	imapp.patientmrn = a.PatientID AND
	a.practiceID = @practiceID  AND
	CAST(imapp.startdate AS DATETIME) = a.StartDate AND
	CAST(imapp.enddate AS DATETIME) = a.EndDate
INNER JOIN dbo.AppointmentReason AS ar ON 
	ar.Name = imapp.appointmentreason
    AND ar.PracticeID = @PracticeID
WHERE a.AppointmentType='P'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in   AppointmentToAppointmentReason'

PRINT ''
PRINT 'Inserting records into AppointmenttoResource Primary'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
      --  TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT 
          a.AppointmentID , -- AppointmentID - int
          imapp.resourcetypeid , -- AppointmentResourceTypeID - int
          CASE WHEN imapp.[resource] = 'Alpesh Desai' THEN '2'
               WHEN imapp.[resource] = 'Angie Koriakos' THEN '5'
               WHEN imapp.[resource] = 'Gregory Polar' THEN '6' 
			   WHEN imapp.[resource] = 'Lana McKinley' THEN '4' 
			   WHEN imapp.[resource] = 'Tejas Desai' THEN '3' 
			   WHEN imapp.[resource] = 'Nurse Dr. A Desai' THEN (SELECT practiceresourceid FROM dbo.PracticeResource WHERE ResourceName = 'Nurse Dr. A Desai')
			   WHEN imapp.[resource] = 'Nurse Dr. T. Desai' THEN (SELECT practiceresourceid FROM dbo.PracticeResource WHERE ResourceName = 'Nurse Dr. T. Desai')
			   ELSE '1' END, -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointment] as imapp      
INNER JOIN dbo.Appointment AS a ON
	imapp.patientmrn = a.PatientID AND
	a.practiceID = @practiceID  AND
	CAST(imapp.startdate AS DATETIME) = a.StartDate AND
	CAST(imapp.enddate AS DATETIME) = a.EndDate
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource'

PRINT ''
PRINT 'Inserting records into AppointmenttoResource Other'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
      --  TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT 
          a.AppointmentID , -- AppointmentID - int
          imapp.resourcetypeid , -- AppointmentResourceTypeID - int
          CASE WHEN imapp.[resource] = 'Alpesh Desai' THEN '2'
               WHEN imapp.[resource] = 'Angie Koriakos' THEN '5'
               WHEN imapp.[resource] = 'Gregory Polar' THEN '6' 
			   WHEN imapp.[resource] = 'Lana McKinley' THEN '4' 
			   WHEN imapp.[resource] = 'Tejas Desai' THEN '3' 
			   WHEN imapp.[resource] = 'Nurse Dr. A Desai' THEN (SELECT practiceresourceid FROM dbo.PracticeResource WHERE ResourceName = 'Nurse Dr. A. Desai')
			   WHEN imapp.[resource] = 'Nurse Dr. T. Desai' THEN (SELECT practiceresourceid FROM dbo.PracticeResource WHERE ResourceName = 'Nurse Dr. T. Desai')
			   ELSE '1' END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointment] as imapp      
INNER JOIN dbo.Appointment AS a ON
	a.practiceID = @practiceID  AND
	CAST(imapp.startdate AS DATETIME) = a.StartDate AND
	CAST(imapp.enddate AS DATETIME) = a.EndDate AND 
	a.[Subject] = imapp.appointmentreason
WHERE imapp.appointmenttype = 'O'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource'

--ROLLBACK
--COMMIT TRANSACTION
        --PRINT 'COMMITTED SUCCESSFULLY'