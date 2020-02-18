USE superbill_33261_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 3 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
 
-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))
/*
DELETE FROM dbo.EncounterDiagnosis WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from EncounterDiagnosis'
DELETE FROM dbo.EncounterProcedure WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from EncounterProcedure'
DELETE FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from Encounter'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentToAppointmentReason'
DELETE FROM dbo.AppointmentReason WHERE PracticeID = @practiceID AND Name = [description]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentReason'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from AppointmentToResource '
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from  Appointment '
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from InsurancePolicy'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCase'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientAlert'
DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'
DELETE FROM dbo.Employers WHERE CreatedUserID = -50
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Employer'
DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Doctor'
*/
PRINT ''
PRINT 'Inserting into Employers'
INSERT INTO dbo.Employers
           (
            EmployerName ,
       --   AddressLine1 ,
       --   AddressLine2 ,
       --   City ,
       --   State ,
       --   Country ,
       --   ZipCode ,
            CreatedDate ,
            CreatedUserID ,
            ModifiedDate ,
            ModifiedUserID
           )
SELECT  DISTINCT 
           pd.empname , -- EmployerName - varchar(128)
      --   '' , -- AddressLine1 - varchar(256)
      --   '' , -- AddressLine2 - varchar(256)
      --   '' , -- City - varchar(128)
      --   '' , -- STATE - varchar(2)
      --   '' , -- Country - varchar(32)
      --   '' , -- ZipCode - varchar(9)
           GETDATE() , -- CreatedDate - datetime
           -50 , -- CreatedUserID - int
           GETDATE() , -- ModifiedDate - datetime
           0  -- ModifiedUserID - int
FROM [dbo].[_import_3_1_PatientDemos] as pd
WHERE pd.empname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting records into Doctors'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
      --  SSN ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
    --    HomePhone ,
    --    HomePhoneExt ,
          WorkPhone ,
    /*    WorkPhoneExt ,
          PagerPhone ,
          PagerPhoneExt ,
          MobilePhone ,
          MobilePhoneExt ,
          DOB ,   
          EmailAddress ,  
          Notes ,   */
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      /*  RecordTimeStamp ,
          UserID ,
          Degree ,  
          DefaultEncounterTemplateID ,
          TaxonomyCode ,
          DepartmentID ,  */
          VendorID ,
          VendorImportID ,
          FaxNumber ,
      /*  FaxNumberExt ,
          OrigReferringPhysicianID , */
          [External] ,
          NPI 
      --  ProviderTypeID 
      /*  ProviderPerformanceReportActive ,
          ProviderPerformanceScope ,
          ProviderPerformanceFrequency ,
          ProviderPerformanceDelay ,
          ProviderPerformanceCarbonCopyEmailRecipients ,
          ExternalBillingID ,
          GlobalPayToAddressFlag ,
          GlobalPayToName ,
          GlobalPayToAddressLine1 ,
          GlobalPayToAddressLine2 ,
          GlobalPayToCity ,
          GlobalPayToState ,
          GlobalPayToZipCode ,
          GlobalPayToCountry ,
          DoctorGuid ,
          CreatedFromEhr ,
          ActivateAfterWizard  */
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          rp.rdrfName, -- FirstName - varchar(64)
          rp.rdrminitial , -- MiddleName - varchar(64)
          rp.rdrlname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
      --  '' , -- SSN - varchar(9)
          rp.rdraddress1 , -- AddressLine1 - varchar(256)
          rp.rdraddress2 , -- AddressLine2 - varchar(256)
          rp.rdrcity , -- City - varchar(128)
          rp.rdrstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(rp.rdrzip5)) IN (4,5) THEN '0' + dbo.fn_RemoveNonNumericCharacters(rp.rdrzip5)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(rp.rdrzip5)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(rp.rdrzip5)
			   ELSE '' END , -- zipcode - varchar(9)	
          --  , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
		  LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rp.rdrphone,'-','')),10) , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
      --  '' , -- PagerPhone - varchar(10)
      --  '' , -- PagerPhoneExt - varchar(10)
      --  '' , -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  '' , -- DOB - datetime
      --  '' , -- EmailAddress - varchar(256)
      --  '' , -- Notes - text 
          1 , -- ActiveDoctor - bit  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
     --   NULL , -- RecordTimeStamp - timestamp
     --   0 , -- UserID - int 
     --   '' , -- Degree - varchar(8) 
      /*  0 , -- DefaultEncounterTemplateID - int
          '' , -- TaxonomyCode - char(10)
          0 , -- DepartmentID - int    */
          rp.rdr, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rp.rdrfax,'-','')),10) , -- FaxNumber - varchar(10)
      --  '' , -- FaxNumberExt - varchar(10)
      --  '', -- OrigReferringPhysicianID - int 
          1 ,  -- External - bit
          rp.rdrnpi -- NPI - varchar(10)
      --  '' ,  -- ProviderTypeID - int
      /*  NULL , -- ProviderPerformanceReportActive - bit
          0 , -- ProviderPerformanceScope - int
          '' , -- ProviderPerformanceFrequency - char(1)
          0 , -- ProviderPerformanceDelay - int
          '' , -- ProviderPerformanceCarbonCopyEmailRecipients - varchar(max)
          '' , -- ExternalBillingID - varchar(50)
          NULL , -- GlobalPayToAddressFlag - bit
          '' , -- GlobalPayToName - varchar(128)
          '' , -- GlobalPayToAddressLine1 - varchar(256)
          '' , -- GlobalPayToAddressLine2 - varchar(256)
          '' , -- GlobalPayToCity - varchar(128)
          '' , -- GlobalPayToState - varchar(2)
          '' , -- GlobalPayToZipCode - varchar(9)
          '' , -- GlobalPayToCountry - varchar(32)
          NULL , -- DoctorGuid - uniqueidentifier
          NULL , -- CreatedFromEhr - bit
          NULL  -- ActivateAfterWizard - bit */
FROM [dbo].[_import_3_1_ReferringProvider] as rp
WHERE rp.rdr <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Doctors'

SET IDENTITY_INSERT dbo.Patient ON
PRINT ''
PRINT 'Inserting records into patient'
INSERT INTO dbo.Patient
        ( PracticeID ,
		  PatientID,
          ReferringPhysicianID ,
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
      --  WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          --ResponsiblePrefix ,
          --ResponsibleFirstName ,
          --ResponsibleMiddleName ,
          --ResponsibleLastName , 
          --ResponsibleSuffix ,
      /*  ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,  */
          ResponsibleCountry ,
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
      --  MedicalRecordNumber ,
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
		  pd.MRN , -- PatientID
          doc.doctorid , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          pd.patfname , -- FirstName - varchar(64)
          pd.patminitial , -- MiddleName - varchar(64)
          pd.patlname , -- LastName - varchar(64)
          '' ,  -- Suffix - varchar(16)
          pd.pataddress1 , -- AddressLine1 - varchar(256)
          pd.pataddress2 , -- AddressLine2 - varchar(256)
          pd.patcity , -- City - varchar(128)
          pd.patstate , -- State - varchar(2)
          '' , -- Country - varchar(32) 
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pd.patzip5)) IN (4,5) THEN '0' + dbo.fn_RemoveNonNumericCharacters(pd.patzip5)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pd.patzip5)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(pd.patzip5)
			   ELSE '' END	, -- zipcode - varchar(9)	  
          CASE pd.patsex WHEN 'N' THEN 'U' ELSE pd.patsex END  , -- Gender - varchar(1)
      --  '' , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.homephone,' ','')),10) , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.workphone,' ','')),10) , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
          pd.patbirthdate  , -- DOB - datetime
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pd.patssn)) >= 6 THEN RIGHT ('000' + dbo.fn_RemoveNonNumericCharacters(pd.patssn) , 9) 
               ELSE '' END , -- SSN - char(9)
          pd.patemail , -- EmailAddress - varchar(256) 
          0 , --  ResponsibleDifferentThanPatient - BIT ,
          --'' , -- ResponsiblePrefix - varchar(16)
          --pd.rpfname , -- ResponsibleFirstName - varchar(64)
          --pd.rpminitial , -- ResponsibleMiddleName - varchar(64)
          --pd.rplname , -- ResponsibleLastName - varchar(64)  */
          --'' , -- ResponsibleSuffix - varchar(16)
      /*  '' , -- ResponsibleRelationshipToPatient - varchar(1)
          '' , -- ResponsibleAddressLine1 - varchar(256)
          '' , -- ResponsibleAddressLine2 - varchar(256)
          '' , -- ResponsibleCity - varchar(128)
          '' , -- ResponsibleState - varchar(2)  */
          '' , -- ResponsibleCountry - varchar(32)
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
      --   pd.mrn , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.patmobilephone,' ','')),10) ,  -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  '' , -- PrimaryCarePhysicianID - int
          pd.mrn , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  0 , -- CollectionCategoryID - int
          1  -- Active - bit
      --  NULL , -- SendEmailCorrespondence - bit
      --  NULL , -- PhonecallRemindersEnabled - bit
      --  pd.emergencyname , -- EmergencyName - varchar(128)
      --  LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.emergencyphone,' ','')),10)   -- EmergencyPhone - varchar(10)
      --  '' , -- EmergencyPhoneExt - varchar(10)
      --  NULL , -- PatientGuid - uniqueidentifier
      --  '' , -- Ethnicity - varchar(64)
      --  '' , -- Race - varchar(64)
      --  '' ,  -- LicenseNumber - varchar(64)
      --  '' , -- LicenseState - varchar(2)
      --  '' , -- Language1 - varchar(64)
      --  ''  -- Language2 - varchar(64)
FROM dbo.[_import_3_1_PatientDemos] as pd
LEFT JOIN dbo.Doctor as doc ON
     doc.firstname = pd.rpfname AND
     doc.lastname = pd.rplname AND
     doc.middlename	 = pd.rpminitial AND
	 doc.[external] = 1
where pd.mrn <>''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully'
SET IDENTITY_INSERT dbo.Patient OFF

PRINT ''
PRINT 'Inserting into PatientAlert'
INSERT INTO dbo.PatientAlert
        ( PatientID ,
          AlertMessage ,
          ShowInPatientFlag ,
          ShowInAppointmentFlag ,
          ShowInEncounterFlag ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
          ShowInClaimFlag ,
          ShowInPaymentFlag ,
          ShowInPatientStatementFlag
        )
SELECT  DISTINCT
          pat.patientID , -- PatientID - int
          pd.Patientalert , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          1 , -- ShowInAppointmentFlag - bit
          1 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          -0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          1 , -- ShowInClaimFlag - bit
          1 , -- ShowInPaymentFlag - bit
          1  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_3_1_PatientDemos] as pd
INNER JOIN dbo.Patient as pat ON
         pat.VendorID = pd.mrn
     AND pat.VendorImportID = @VendorImportID
WHERE pd.patientalert <> ''	 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patientAlert Successfully'

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
         'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
      --  0 , -- ReferringPhysicianID - int
      --  NULL , -- EmploymentRelatedFlag - bit
      --  NULL , -- AutoAccidentRelatedFlag - bit
      --  NULL , -- OtherAccidentRelatedFlag - bit
      --  NULL , -- AbuseRelatedFlag - bit
      --  '' , -- AutoAccidentRelatedState - char(2)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
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
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase'

PRINT ''
PRINT 'Inserting into AppointmentReason'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
          DefaultDurationMinutes ,
       -- DefaultColorCode ,
       -- Description ,
          ModifiedDate 
     --   TIMESTAMP ,
     --   AppointmentReasonGuid
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
          imapp.apptreason, -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
      --  0 , -- DefaultColorCode - int
      --  '' , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
     --   NULL , -- TIMESTAMP - timestamp
     --   NULL  -- AppointmentReasonGuid - uniqueidentifier  
FROM dbo.[_import_3_1_Appointment] as imapp
WHERE NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE imapp.apptreason = ar.Name)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into AppointmentReason'

PRINT ''
PRINT'Inserting records into Appointment'
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
      --  AppointmentResourceTypeID ,
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
          1 , -- ServiceLocationID - int
          imapp.startdate , -- StartDate - datetime
          imapp.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          imapp.[subject] , -- Subject - varchar(64)
          imapp.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- AppointmentResourceTypeID - int
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
FROM dbo.[_import_3_1_Appointment] as imapp
INNER JOIN dbo.patient AS pat ON
   pat.vendorID = imapp.mrn  and
   pat.practiceID = @PracticeID
LEFT JOIN dbo.patientcase AS patcase ON
  patcase.patientID = pat.patientID AND
  patcase.PracticeID = @PracticeID 
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(imapp.startdate AS date) AS DATETIME)
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
FROM dbo.[_import_3_1_Appointment] as imapp      
INNER JOIN dbo.Appointment AS a ON
    a.practiceID = @practiceID AND
	a.[subject] = imapp.[subject] AND
	CAST(imapp.startdate AS DATETIME) = a.StartDate AND
	CAST(imapp.enddate AS DATETIME) = a.EndDate
INNER JOIN dbo.AppointmentReason AS ar ON 
	ar.Name = imapp.Apptreason 
	AND ar.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in   AppointmentToAppointmentReason'

PRINT ''
PRINT 'Inserting records into AppointmenttoResource'
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
          1 , -- AppointmentResourceTypeID - int
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_3_1_Appointment] as imapp
INNER JOIN dbo.Appointment as a ON
    a.practiceID = @practiceID AND
	a.[subject] = imapp.[subject] AND
	CAST(imapp.startdate AS DATETIME) = a.StartDate AND
	CAST(imapp.enddate AS DATETIME) = a.EndDate
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource'

PRINT ''
PRINT'Inserting records into PrimaryInsurancePolicy'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
      /*  PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,   */
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
      --    PatientInsuranceStatusID ,  */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     --   RecordTimeStamp ,
          HolderGender ,
      /*  HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState , */
          HolderCountry ,
     /*   HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt , */
          Copay ,
      /*  Deductible ,
          PatientInsuranceNumber , */  
          Active ,
          PracticeID ,
     /*   AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,  */
          VendorID ,
          VendorImportID 
     /*   InsuranceProgramTypeID ,
          GroupName ,
          ReleaseOfInformation ,
          SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patCase.PatientCaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          pd.PolicyID , -- PolicyNumber - varchar(32)
          pd.GroupID , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit    
          CASE WHEN pd.PrimaryPatientRelationtoSub = 'CHILD' THEN 'C'
               WHEN pd.PrimaryPatientRelationtoSub = 'SPOUSE' THEN 'U'
               ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1) 
         '' , -- HolderPrefix - varchar(16)
         CASE WHEN pd.PrimaryPatientRelationtoSub <> 'SELF' THEN pd.subfname END  , -- HolderFirstName - varchar(64)
         CASE WHEN pd.PrimaryPatientRelationtoSub <> 'SELF' THEN pd.subminit END , -- HolderMiddleName - varchar(64)
         CASE WHEN pd.PrimaryPatientRelationtoSub <> 'SELF' THEN pd.Sublname END , -- HolderLastName - varchar(64)
         '' , -- HolderSuffix - varchar(16)
         CASE WHEN pd.PrimaryPatientRelationtoSub <> 'SELF' THEN pd.subdob END , -- HolderDOB - datetime
		 CASE WHEN pd.PrimaryPatientRelationtoSub <> 'SELF' THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pd.subssn)) >= 6 
                                                      THEN RIGHT ('000' + dbo.fn_RemoveNonNumericCharacters(pd.subssn) , 9) 
                                               ELSE '' END END , -- HolderSSN - char(11)
          CASE WHEN pd.empname <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
          CASE WHEN pd.empname <> '' THEN pd.empname END , -- HolderEmployerName - varchar(128)
      --   0 , -- PatientInsuranceStatusID - int  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE WHEN pd.PrimaryPatientRelationtoSub <> 'SELF' THEN CASE WHEN pd.subsex = 'N' THEN 'U' ELSE pd.subsex END END , -- HolderGender - char(1)
     /*   '' , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          '' , -- HolderCity - varchar(128)
          '' , -- HolderState - varchar(2) */
          '' , -- HolderCountry - varchar(32)
     /*   '' , -- HolderZipCode - varchar(9)
          '' , -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10)
          '' , -- DependentPolicyNumber - varchar(32) 
          '' , -- Notes - text 
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10) */
          pd.primarycopay , -- Copay - money
       /* NULL , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32) */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16) */
          patcase.VendorID + pd.policyid, -- VendorID - varchar(50)  
          @VendorImportID  -- VendorImportID - int
      /*  0 , -- InsuranceProgramTypeID - int
          '' , -- GroupName - varchar(14)
          '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_3_1_PatientDemos] as pd
INNER JOIN dbo.PatientCase AS patCase ON 
        patCase.VendorID = pd.mrn  AND
        patcase.VendorImportID = @vendorimportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = pd.primaryplanid  AND
        inscoplan.VendorImportID IN (1,2)
WHERE pd.PolicyID <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Primary Insurance Policy'

PRINT ''
PRINT'Inserting records into SecondayInsurancePolicy'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
      /*  PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,   */
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
      --  PatientInsuranceStatusID ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     --   RecordTimeStamp ,
          HolderGender ,
      /*  HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState , */
          HolderCountry ,
     /*   HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt , */
          Copay ,
      /*  Deductible ,
          PatientInsuranceNumber , */  
          Active ,
          PracticeID ,
     /*   AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,  */
          VendorID ,
          VendorImportID 
     /*   InsuranceProgramTypeID ,
          GroupName ,
          ReleaseOfInformation ,
          SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patCase.PatientCaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          pd.[2ndPolicyID] , -- PolicyNumber - varchar(32)
          pd.[2ndGroupID] , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit    
          CASE WHEN pd.[2ndPatientRelationtoSub] = 'CHILD' THEN 'C'
		       WHEN pd.[2ndPatientRelationtoSub] = 'SPOUSE' THEN 'U'
			   ELSE 'S'  END, -- PatientRelationshipToInsured - varchar(1) 
         '' , -- HolderPrefix - varchar(16)
         CASE WHEN pd.[2ndPatientRelationtoSub] <> 'SELF' THEN pd.[2ndSubFName] END  , -- HolderFirstName - varchar(64)
         CASE WHEN pd.[2ndPatientRelationtoSub] <> 'SELF' THEN pd.[2ndSubMInit] END , -- HolderMiddleName - varchar(64)
         CASE WHEN pd.[2ndPatientRelationtoSub] <> 'SELF' THEN pd.[2ndSubLName] END , -- HolderLastName - varchar(64)
         '' , -- HolderSuffix - varchar(16)
         CASE WHEN pd.[2ndPatientRelationtoSub] <> 'SELF' THEN pd.[2ndSubDob] END , -- HolderDOB - datetime
		 CASE WHEN pd.[2ndPatientRelationtoSub] <> 'SELF' THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pd.[2ndSubSSN])) >= 6 
		                                                    THEN RIGHT ('000' + dbo.fn_RemoveNonNumericCharacters(pd.[2ndSubSSN]) , 9) 
                                               ELSE '' END END , -- HolderSSN - char(11)
          CASE WHEN pd.[2ndempname] <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
          CASE WHEN pd.[2ndempname] <> '' THEN pd.[2ndempname] END , -- HolderEmployerName - varchar(128)
      --   0 , -- PatientInsuranceStatusID - int  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE WHEN pd.PrimaryPatientRelationtoSub <> 'SELF' THEN CASE WHEN pd.[2ndsubsex] = 'N' THEN 'U' ELSE pd.[2ndsubsex] END END  , -- HolderGender - char(1)
     /*   '' , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          '' , -- HolderCity - varchar(128)
          '' , -- HolderState - varchar(2) */
          '' , -- HolderCountry - varchar(32)
     /*   '' , -- HolderZipCode - varchar(9)
          '' , -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10)
          '' , -- DependentPolicyNumber - varchar(32) 
          '' , -- Notes - text 
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10) */
          pd.secondarycopay , -- Copay - money
       /* NULL , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32) */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16) */
          patcase.VendorID + pd.[2ndpolicyid] , -- VendorID - varchar(50)  
          @VendorImportID  -- VendorImportID - int
      /*  0 , -- InsuranceProgramTypeID - int
          '' , -- GroupName - varchar(14)
          '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_3_1_PatientDemos] as pd
INNER JOIN dbo.PatientCase AS patCase ON 
    patCase.VendorID = pd.mrn  AND
	patCase.PracticeID = @PracticeID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = pd.secondaryplanid  AND
		inscoplan.VendorImportID IN (1,2)
WHERE pd.[2ndPolicyID] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Secondary Insurance Policy'

PRINT ''
PRINT'Inserting records into TertiaryInsurancePolicy'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
      /*  PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,   */
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
      /*  HolderThroughEmployer ,
          HolderEmployerName ,
          PatientInsuranceStatusID ,  */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     --   RecordTimeStamp ,
          HolderGender ,
      /*  HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState , */
          HolderCountry ,
     /*   HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt , */
      --  Copay ,
      /*  Deductible ,
          PatientInsuranceNumber , */  
          Active ,
          PracticeID ,
     /*   AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,  */
          VendorID ,
          VendorImportID 
     /*   InsuranceProgramTypeID ,
          GroupName ,
          ReleaseOfInformation ,
          SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patCase.PatientCaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          pd.[3rdPolicyID] , -- PolicyNumber - varchar(32)
          pd.[3rdGroupID] , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit    
          CASE WHEN pd.[3rdPatientRelationtoSub] = 'SPOUSE' THEN 'U'
			   ELSE 'S'  END, -- PatientRelationshipToInsured - varchar(1) 
         '' , -- HolderPrefix - varchar(16)
         CASE WHEN pd.[3rdPatientRelationtoSub] <> 'SELF' THEN pd.[3rdSubFName] END  , -- HolderFirstName - varchar(64)
         CASE WHEN pd.[3rdPatientRelationtoSub] <> 'SELF' THEN pd.[3rdSubMInit] END , -- HolderMiddleName - varchar(64)
         CASE WHEN pd.[3rdPatientRelationtoSub] <> 'SELF' THEN pd.[3rdSubLName] END , -- HolderLastName - varchar(64)
         '' , -- HolderSuffix - varchar(16)
         CASE WHEN pd.[3rdPatientRelationtoSub] <> 'SELF' THEN pd.[3rdofSubDob] END , -- HolderDOB - datetime
		 CASE WHEN pd.[3rdPatientRelationtoSub] <> 'SELF' THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pd.[3rdSubSSN])) >= 6 
		                                                    THEN RIGHT ('000' + dbo.fn_RemoveNonNumericCharacters(pd.[3rdSubSSN]) , 9) 
                                               ELSE '' END END , -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      --   '' , -- HolderEmployerName - varchar(128)
      --   0 , -- PatientInsuranceStatusID - int  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE WHEN pd.PrimaryPatientRelationtoSub <> 'SELF' THEN CASE WHEN pd.[3rdsubsex] = 'N' THEN 'U' ELSE pd.[3rdsubsex] END END  , -- HolderGender - char(1)
     /*   '' , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          '' , -- HolderCity - varchar(128)
          '' , -- HolderState - varchar(2) */
          '' , -- HolderCountry - varchar(32)
     /*   '' , -- HolderZipCode - varchar(9)
          '' , -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10)
          '' , -- DependentPolicyNumber - varchar(32) 
          '' , -- Notes - text 
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10) */
    --    '' , -- Copay - money
       /* NULL , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32) */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16) */
          patcase.VendorID + pd.[3rdpolicyid] , -- VendorID - varchar(50)  
          @VendorImportID  -- VendorImportID - int
      /*  0 , -- InsuranceProgramTypeID - int
          '' , -- GroupName - varchar(14)
          '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_3_1_PatientDemos] as pd
INNER JOIN dbo.PatientCase AS patCase ON 
    patCase.VendorID = pd.mrn  AND
	patCase.VendorImportID = @VendorImportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = pd.tertiaryplanid  AND
		 inscoplan.VendorImportID IN (1,2)
WHERE pd.[3rdPolicyID] <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Teritiary Insurance Policy'

IF NOT EXISTS (SELECT * FROM dbo.DiagnosisCodeDictionary WHERE DiagnosisCode='000.00')
BEGIN
PRINT ''
PRINT 'Inserting into DiagnosisCodeDictionary' 
INSERT INTO dbo.DiagnosisCodeDictionary 
        ( 
		  DiagnosisCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      /*  RecordTimeStamp ,
          KareoDiagnosisCodeDictionaryID ,
          KareoLastModifiedDate ,   */
          Active ,
          OfficialName ,
          LocalName ,
          OfficialDescription    
        )
VALUES  
       ( 
          '000.00' , -- DiagnosisCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      /*  NULL , -- KareoDiagnosisCodeDictionaryID - int
          GETDATE() , -- KareoLastModifiedDate - datetime   */
          1 , -- Active - bit
         'Miscellaneous' ,  -- OfficialName - varchar(300)
         'Miscellaneous' ,  -- LocalName - varchar(100)
          NULL  -- OfficialDescription - varchar(500) 
        )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into DiagnosisCodeDictionary ' 
END

PRINT ''
PRINT 'Inserting into PatientCase- Balance Forward'
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
          'Balance Forward' , -- Name - varchar(128)
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
          Pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  NULL , -- PregnancyRelatedFlag - bit
      --  NULL , -- StatementActive - bit
      --  NULL , -- EPSDT - bit
      --  NULL , -- FamilyPlanning - bit
      --  0 , -- EPSDTCodeID - int
      --  NULL , -- EmergencyRelated - bit
      --  NULL  -- HomeboundRelatedFlag - bit
FROM dbo.patient as pat 
INNER JOIN dbo._import_3_1_PatientDemos AS pd ON
   pat.VendorID = pd.mrn AND
   pat.VendorImportID = @VendorImportID
WHERE pd.patientbalance <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase- Balance Forward'

PRINT ''
PRINT 'Inserting into Encounter '
INSERT INTO dbo.Encounter
        ( PracticeID ,
          PatientID ,
          DoctorID ,
     --   AppointmentID ,
          LocationID ,
      --  PatientEmployerID ,
          DateOfService ,
          DateCreated ,
          Notes ,
          EncounterStatusID ,
      --  AdminNotes ,
      --  AmountPaid ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
      --  MedicareAssignmentCode ,
      --  ReleaseOfInformationCode ,
          ReleaseSignatureSourceCode ,
          PlaceOfServiceCode ,
      --  ConditionNotes ,
          PatientCaseID ,
      --  InsurancePolicyAuthorizationID ,
          PostingDate ,
          DateOfServiceTo ,
      --  SupervisingProviderID ,
      --  ReferringPhysicianID ,
          PaymentMethod ,
      --  Reference ,
          AddOns ,
      --  HospitalizationStartDT ,
      --  HospitalizationEndDT ,
      --  Box19 ,
          DoNotSendElectronic ,
          SubmittedDate ,
          PaymentTypeID ,
      --  PaymentDescription ,
      --  EDIClaimNoteReferenceCode ,
      --  EDIClaimNote ,
          VendorID ,
          VendorImportID ,
          --AppointmentStartDate ,
      --  BatchID ,
      --  SchedulingProviderID ,
          DoNotSendElectronicSecondary ,
      --  PaymentCategoryID ,
          overrideClosingDate ,
      --  Box10d ,
          ClaimTypeID ,
      /*  OperatingProviderID ,
          OtherProviderID ,
          PrincipalDiagnosisCodeDictionaryID ,
          AdmittingDiagnosisCodeDictionaryID ,
          PrincipalProcedureCodeDictionaryID ,
          DRGCodeID ,
          ProcedureDate ,
          AdmissionTypeID ,
          AdmissionDate ,
          PointOfOriginCodeID ,
          AdmissionHour ,
          DischargeHour ,
          DischargeStatusCodeID ,
          Remarks ,
          SubmitReasonID ,
          DocumentControlNumber ,
          PTAProviderID ,                 */
          SecondaryClaimTypeID ,
          SubmitReasonIDCMS1500 ,
          SubmitReasonIDUB04 ,
      /*  DocumentControlNumberCMS1500 ,
          DocumentControlNumberUB04 ,
          EDIClaimNoteReferenceCodeCMS1500 ,
          EDIClaimNoteReferenceCodeUB04 ,
          EDIClaimNoteCMS1500 ,
          EDIClaimNoteUB04 ,
          EncounterGuid ,        */
          PatientCheckedIn 
     --   RoomNumber
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          patcase.PatientID , -- PatientID - int
          1 , -- DoctorID - int
          --app.AppointmentID , -- AppointmentID - int
          1 , -- LocationID - int
      --  '' , -- PatientEmployerID - int
          GETDATE() , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          Convert(Varchar(10), GETDATE(),101) + ': Creating Balance Forward' , -- Notes - text
          2 , -- EncounterStatusID - int
     --   '' , -- AdminNotes - text
     --   '' , -- AmountPaid - money
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- MedicareAssignmentCode - char(1)
      --  '' , -- ReleaseOfInformationCode - char(1)
          'B' , -- ReleaseSignatureSourceCode - char(1)
          11 , -- PlaceOfServiceCode - char(2)
      --  '' , -- ConditionNotes - text
          patcase.PatientCaseID , -- PatientCaseID - int
      --  0 , -- InsurancePolicyAuthorizationID - int         
          GETDATE() , -- PostingDate - datetime
          GETDATE() , -- DateOfServiceTo - datetime
      --  0 , -- SupervisingProviderID - int
      --  pat.ReferringPhysicianID , -- ReferringPhysicianID - int
          'U' , -- PaymentMethod - char(1)
     --   '' , -- Reference - varchar(40)
          0 , -- AddOns - bigint
      --  GETDATE() , -- HospitalizationStartDT - datetime
      --  GETDATE() , -- HospitalizationEndDT - datetime
      --  '' , -- Box19 - varchar(51)
          0 , -- DoNotSendElectronic - bit
          GETDATE() , -- SubmittedDate - datetime
          0 , -- PaymentTypeID - int
      --  '' , -- PaymentDescription - varchar(250)
     --   '' , -- EDIClaimNoteReferenceCode - char(3)
     --   '' , -- EDIClaimNote - varchar(1600)
          patcase.VendorID , -- VendorID - varchar(50)                
          @VendorImportID , -- VendorImportID - int
          --app.startdate , -- AppointmentStartDate - datetime
      --  '' , -- BatchID - varchar(50)
      --  0 , -- SchedulingProviderID - int
          0 , -- DoNotSendElectronicSecondary - bit
      --  0 , -- PaymentCategoryID - int
          0 , -- overrideClosingDate - bit
      --  '' , -- Box10d - varchar(40)
          0 , -- ClaimTypeID - int
     /*   0 , -- OperatingProviderID - int
     --   0 , -- OtherProviderID - int
     --   0 , -- PrincipalDiagnosisCodeDictionaryID - int
     --   0 , -- AdmittingDiagnosisCodeDictionaryID - int
     --   0 , -- PrincipalProcedureCodeDictionaryID - int
     --   0 , -- DRGCodeID - int
     --   GETDATE() , -- ProcedureDate - datetime
     --   0 , -- AdmissionTypeID - int
     --   GETDATE() , -- AdmissionDate - datetime
          0 , -- PointOfOriginCodeID - int
          '' , -- AdmissionHour - varchar(2)
          '' , -- DischargeHour - varchar(2)
          0 , -- DischargeStatusCodeID - int
          '' , -- Remarks - varchar(255)
          0 , -- SubmitReasonID - int
          '' , -- DocumentControlNumber - varchar(26)
          0 , -- PTAProviderID - int                    */
          0 , -- SecondaryClaimTypeID - int
          2 , -- SubmitReasonIDCMS1500 - int
          2 , -- SubmitReasonIDUB04 - int
      /*    '' , -- DocumentControlNumberCMS1500 - varchar(26)
          '' , -- DocumentControlNumberUB04 - varchar(26)
          '' , -- EDIClaimNoteReferenceCodeCMS1500 - char(3)
          '' , -- EDIClaimNoteReferenceCodeUB04 - char(3)
          '' , -- EDIClaimNoteCMS1500 - varchar(1600)
          '' , -- EDIClaimNoteUB04 - varchar(1600)
          NULL , -- EncounterGuid - uniqueidentifier      */
          0  -- PatientCheckedIn - bit
     --   ''  -- RoomNumber - varchar(32)
FROM dbo._import_3_1_PatientDemos as pd
INNER JOIN dbo.PatientCase AS patcase ON
       patcase.VendorID = pd.mrn AND
	   patcase.VendorImportID = @VendorImportID
where patcase.Name = 'Balance Forward'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Encounter' 

PRINT ''
PRINT 'Inserting into EncounterDiagnosis '
INSERT INTO dbo.EncounterDiagnosis
        ( 
		  EncounterID ,
          DiagnosisCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          RecordTimeStamp ,
          ListSequence ,
          PracticeID ,
          VendorID ,
          VendorImportID
        )
SELECT DISTINCT
          enc.EncounterID , -- EncounterID - int
          dcd.DiagnosisCodeDictionaryID , -- DiagnosisCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          NULL , -- RecordTimeStamp - timestamp
          1 , -- ListSequence - int
          @PracticeID  , -- PracticeID - int
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Encounter as enc 
INNER JOIN dbo.DiagnosisCodeDictionary AS dcd ON
    dcd.DiagnosisCode = '000.00' AND 
    enc.PracticeID = @PracticeID        
WHERE enc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into EncounterDiagnosis' 

PRINT ''
PRINT 'Inserting into EncounterProcedure '
INSERT INTO dbo.EncounterProcedure
        ( 
		  EncounterID ,
          ProcedureCodeDictionaryID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     --   RecordTimeStamp ,
          ServiceChargeAmount ,   
          ServiceUnitCount ,
     /*   ProcedureModifier1 ,
          ProcedureModifier2 ,
          ProcedureModifier3 ,
          ProcedureModifier4 ,   */
          ProcedureDateOfService ,
          PracticeID ,
          EncounterDiagnosisID1 ,
    /*    EncounterDiagnosisID2 ,
          EncounterDiagnosisID3 ,
          EncounterDiagnosisID4 ,   */
          ServiceEndDate ,
          VendorID ,
          VendorImportID ,
     /*   ContractID ,
          Description ,
          EDIServiceNoteReferenceCode ,
          EDIServiceNote ,   */
          TypeOfServiceCode ,
          AnesthesiaTime ,
     /*   ApplyPayment ,
          PatientResp ,    */
          AssessmentDate ,
     /*   RevenueCodeID ,
          NonCoveredCharges ,     */
          DoctorID ,
     /*   StartTime ,
          EndTime ,  */
          ConcurrentProcedures 
     /*   StartTimeText ,
          EndTimeText    */
        )
SELECT DISTINCT
          enc.EncounterID  , -- EncounterID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeDictionaryID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          pd.patientbalance , -- ServiceChargeAmount - money   
          '1.000' , -- ServiceUnitCount - decimal
     /*   '' , -- ProcedureModifier1 - varchar(16)
          '' , -- ProcedureModifier2 - varchar(16)
          '' , -- ProcedureModifier3 - varchar(16)
          '' , -- ProcedureModifier4 - varchar(16)   */
          GETDATE() , -- ProcedureDateOfService - datetime
          @PracticeID , -- PracticeID - int
          ed.EncounterDiagnosisID , -- EncounterDiagnosisID1 - int
    /*    0 , -- EncounterDiagnosisID2 - int
          0 , -- EncounterDiagnosisID3 - int
          0 , -- EncounterDiagnosisID4 - int    */
          GETDATE() , -- ServiceEndDate - datetime
          enc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
     /*   0 , -- ContractID - int
          '' , -- Description - varchar(80)
          '' , -- EDIServiceNoteReferenceCode - char(3)
          '' , -- EDIServiceNote - varchar(80)     */
          '1' , -- TypeOfServiceCode - char(1)
          0 , -- AnesthesiaTime - int
     /*   NULL , -- ApplyPayment - money
          NULL , -- PatientResp - money    */
          GETDATE() , -- AssessmentDate - datetime
     /*   0 , -- RevenueCodeID - int
          NULL , -- NonCoveredCharges - money    */
          enc.DoctorID , -- DoctorID - int
     /*   app.startdate , -- StartTime - datetime
          app.enddate , -- EndTime - datetime   */
          1  -- ConcurrentProcedures - int
     /*   '' , -- StartTimeText - varchar(4)
          ''  -- EndTimeText - varchar(4)   */
FROM dbo.Encounter AS enc
INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
   pcd.OfficialName = 'Balance Forward' AND 
   enc.PracticeID = @PracticeID
INNER JOIN dbo.EncounterDiagnosis AS ed ON
   ed.vendorID = enc.VendorID AND 
   enc.VendorImportID = @VendorImportID   
INNER JOIN dbo._import_3_1_PatientDemos as pd ON 
   pd.mrn = enc.vendorID AND
   enc.PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into EncounterProcedure'

ROLLBACK
--COMMIT TRANSACTION
  --      PRINT 'COMMITTED SUCCESSFULLY'

