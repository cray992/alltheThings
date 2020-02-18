USE superbill_31853_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID =  1 -- Vendor import record created through import tool
 
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
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from InsurancePolicy'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Insurance Company Plan'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from Insurance'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCase'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientAlert'
DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'
DELETE FROM dbo.Employers WHERE CreatedUserID = -50
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Employer'
*/


PRINT ''
PRINT 'Inserting records into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
      --  Notes ,
          AddressLine1 ,
      --  AddressLine2 ,
          City ,
          State ,   
          Country ,
          ZipCode ,  
          ContactPrefix ,
      /*  ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,   */
          ContactSuffix ,
          Phone ,
      /*  PhoneExt ,
          Fax ,
          FaxExt ,  */  
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
      /*  LocalUseFieldTypeCode ,
          ReviewCode ,
          ProviderNumberTypeID ,
          GroupNumberTypeID ,
          LocalUseProviderNumberTypeID ,
          CompanyTextID ,
          ClearinghousePayerID ,  */   
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      /*  KareoInsuranceCompanyID ,
          KareoLastModifiedDate ,
          RecordTimeStamp ,  */  
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
      /*  DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,  */
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
          il.name , -- InsuranceCompanyName - varchar(128)
      --  '' , -- Notes - text
          il.address1 , -- AddressLine1 - varchar(256)
      --  '' , -- AddressLine2 - varchar(256)
          il.city , -- City - varchar(128)
          il.state , -- State - varchar(2) */ 
          '' , -- Country - varchar(32)
          CASE WHEN LEN(il.zip) = 4 THEN '0' + il.zip ELSE LEFT(il.zip, 9) END ,  -- ZipCode - varchar(9)  
          '' , -- ContactPrefix - varchar(16)
      /*  '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64) */
          '' , -- ContactSuffix - varchar(16)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(il.phone,' ','')),10)  , -- Phone - varchar(10)
      /*  '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)  */
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
     /*   '' , -- LocalUseFieldTypeCode - char(5)
          '' , -- ReviewCode - char(1)
          0 , -- ProviderNumberTypeID - int
          0 , -- GroupNumberTypeID - int
          0 , -- LocalUseProviderNumberTypeID - int
          '' , -- CompanyTextID - varchar(10)
          0 , -- ClearinghousePayerID - int */
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  0 , -- KareoInsuranceCompanyID - int
      --  GETDATE() , -- KareoLastModifiedDate - datetime
      --  NULL , -- RecordTimeStamp - timestamp
          13 , -- SecondaryPrecedenceBillingFormID - int
          il.vendorID,-- VendorID - varchar(50)  
          @VendorImportID , -- VendorImportID - int
      --  '' , -- DefaultAdjustmentCode - varchar(10)
      --  0 , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceList] as il
INNER JOIN dbo.[_import_1_1_Policy] ip ON
	il.vendorid = ip.insvendorid 
INNER JOIN dbo.[_import_1_1_PatDemo] pd ON
	ip.patvendorid = pd.patvendorid
WHERE il.name<>'' -- and il.inscoid<>'' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company'

PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
      --  AddressLine2 ,
          City ,
          State , 
          Country ,
          ZipCode ,
          ContactPrefix ,
      /*  ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,  */
          ContactSuffix ,
          Phone ,
      /*  PhoneExt ,
          Notes ,
          MM_CompanyID ,  */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     --   RecordTimeStamp ,
     --   ReviewCode ,
          CreatedPracticeID ,
     /*   Fax ,
          FaxExt ,
          KareoInsuranceCompanyPlanID ,
          KareoLastModifiedDate ,  */
          InsuranceCompanyID ,
     /*   ADS_CompanyID ,
          Copay ,
          Deductible ,  */
          VendorID ,
          VendorImportID 
      --  InsuranceCompanyPlanGuid
        )
SELECT DISTINCT
          ic.InsuranceCompanyName , -- PlanName - varchar(128)
          ic.AddressLine1 , -- AddressLine1 - varchar(256)
      --  '' , -- AddressLine2 - varchar(256)
          ic.city , -- City - varchar(128)
          ic.state , -- State - varchar(2)  
          '' , -- Country - varchar(32)
          ic.ZipCode , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
      /*  '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)  */
          '' , -- ContactSuffix - varchar(16)
          ic.phone , -- Phone - varchar(10)
     /*   '' , -- PhoneExt - varchar(10)
          '' , -- Notes - text
          '' , -- MM_CompanyID - varchar(10)  */
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
      /*  '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)
          0 , -- KareoInsuranceCompanyPlanID - int
          GETDATE() , -- KareoLastModifiedDate - datetime  */
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
      /*  '' , -- ADS_CompanyID - varchar(10)
          NULL , -- Copay - money
          NULL , -- Deductible - money   */
          ic.vendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  NULL  -- InsuranceCompanyPlanGuid - uniqueidentifier
FROM dbo.InsuranceCompany as ic
WHERE VendorImportID=@VendorImportID AND CreatedPracticeID=@PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company plan'

PRINT ''
PRINT 'Inserting Into Employers'
INSERT INTO dbo.Employers
        ( EmployerName ,
      /*  AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,   */
          Country ,
      --  ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
      --  RecordTimeStamp
        )
SELECT DISTINCT
          pol.employer , -- EmployerName - varchar(128)
      /*  '' , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          '' , -- City - varchar(128)
          '' , -- State - varchar(2)    */
          '' , -- Country - varchar(32)
      --  '' , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
      --  NULL  -- RecordTimeStamp - timestamp
FROM dbo.[_import_1_1_policy] as pol
WHERE pol.employer <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into Employers Successfully'



PRINT ''
PRINT 'Inserting records into patient'
INSERT INTO dbo.Patient
        ( PracticeID ,
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
      --  WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
      /*  ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName , */
          ResponsibleSuffix ,
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
          EmploymentStatus ,
      /*  InsuranceProgramCode ,
          PatientReferralSourceID ,  */
      --  PrimaryProviderID ,  
      --  DefaultServiceLocationID ,
          EmployerID ,
          MedicalRecordNumber ,
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
      --  LicenseNumber ,
      --  LicenseState ,
      --  Language1 ,
      --  Language2
        )
SELECT  DISTINCT
          @PracticeID , -- PracticeID - int
      --  '' , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          pd.firstname , -- FirstName - varchar(64)
          pd.middle , -- MiddleName - varchar(64)
          pd.lastname , -- LastName - varchar(64)
          '' ,  -- Suffix - varchar(16)
          pd.street1 , -- AddressLine1 - varchar(256)
          pd.street2 , -- AddressLine2 - varchar(256)
          pd.city , -- City - varchar(128)
          pd.state , -- State - varchar(2)
          '' , -- Country - varchar(32)   
          CASE WHEN LEN(pd.zipcode) = 4 THEN '0' + pd.zipcode ELSE LEFT(pd.zipcode, 9) END , -- ZipCode - varchar(9)
          pd.gender  , -- Gender - varchar(1)
      --  '' , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.homephone,' ','')),10) , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.work,' ','')),10) , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
          pd.dateofbirth  , -- DOB - datetime
		  CASE WHEN LEN(pd.ssn) >= 6 THEN RIGHT ('000' + pd.ssn , 9) ELSE '' END , -- SSN - char(9)
          pd.email , -- EmailAddress - varchar(256) 
          0 , --  ResponsibleDifferentThanPatient - BIT ,
          '' , -- ResponsiblePrefix - varchar(16)
      /*  '' , -- ResponsibleFirstName - varchar(64)
          '' , -- ResponsibleMiddleName - varchar(64)
          '' , -- ResponsibleLastName - varchar(64)  */
          '' , -- ResponsibleSuffix - varchar(16)
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
          CASE WHEN pol.employer <> '' THEN 'E' ELSE 'U' END , -- EmploymentStatus - char(1)
      --  '' , -- InsuranceProgramCode - char(2)
      --  0  , -- PatientReferralSourceID - int
      --  '' , -- PrimaryProviderID - int
      --  0  , -- DefaultServiceLocationID - int
          emp.EmployerID , -- EmployerID - int
          pd.medicalrecordnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.cell,' ','')),10) ,  -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  '' , -- PrimaryCarePhysicianID - int
          pd.patVendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  0 , -- CollectionCategoryID - int
          1  -- Active - bit
      --  NULL , -- SendEmailCorrespondence - bit
      --  NULL , -- PhonecallRemindersEnabled - bit
      --  '' , -- EmergencyName - varchar(128)
      --  '' , -- EmergencyPhone - varchar(10)
      --  '' , -- EmergencyPhoneExt - varchar(10)
      --  NULL , -- PatientGuid - uniqueidentifier
      --  '' , -- Ethnicity - varchar(64)
      --  '' , -- Race - varchar(64)
      --  '' ,  -- LicenseNumber - varchar(64)
      --  '' , -- LicenseState - varchar(2)
      --  '' , -- Language1 - varchar(64)
      --  ''  -- Language2 - varchar(64)
FROM dbo.[_import_1_1_PatDemo] as pd
LEFT JOIN dbo.[_import_1_1_Policy] as pol ON
    pol.patvendorid = pd.patVendorID
LEFT JOIN dbo.Employers as emp ON
      emp.employername = pol.employer 	  
where pd.firstname <> '' and pd.lastname <>'' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully'

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
SELECT DISTINCT
          pat.patientID , -- PatientID - int
          pd.alertonlyonstatements , -- AlertMessage - text
          0 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          1  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_1_1_PatDemo] as pd
INNER JOIN dbo.Patient as pat on
         pat.VendorID = pd.patvendorid
     AND pat.VendorImportID = @VendorImportID	
WHERE pd.alertonlyonstatements  <> ''
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
PRINT 'Inserting into AppointmentReason'
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
          ia.AppointmentReason , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
      --  0 , -- DefaultColorCode - int
          ia.appointmentreason , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
     --   NULL , -- TIMESTAMP - timestamp
     --   NULL  -- AppointmentReasonGuid - uniqueidentifier  
FROM dbo.[_import_1_1_Appointment] as ia 
WHERE ia.AppointmentReason <> '' AND NOT EXISTS (select * from dbo.AppointmentReason ar where ar.name = ia.AppointmentReason)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into AppointmentReason'


PRINT ''
PRINT'Inserting records into Appointment'
INSERT INTO dbo.Appointment
        ( PatientID ,
          PracticeID ,
          ServiceLocationID ,
          StartDate ,
          EndDate ,
          AppointmentType ,
          Subject ,
      --  Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
          AppointmentResourceTypeID ,
          AppointmentConfirmationStatusCode ,
      /*  AllDay ,
          InsurancePolicyAuthorizationID ,   */
          PatientCaseID ,
      /*  Recurrence ,
          RecurrenceStartDate ,
          RangeEndDate ,
          RangeType ,    */
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
          ia.StartDate , -- StartDate - datetime
          ia.EndDate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          CAST(ia.AutoTempID AS VARCHAR) + ia.PatVendorID , -- Subject - varchar(64)
      --  '' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
       /* NULL , -- AllDay - bit
          0 , -- InsurancePolicyAuthorizationID - int    */
          patcase.PatientCaseID , -- PatientCaseID - int
      /*  NULL , -- Recurrence - bit
          GETDATE() , -- RecurrenceStartDate - datetime
          GETDATE() , -- RangeEndDate - datetime
          '' , -- RangeType - char(1)    */
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          ia.StartTM , -- StartTm - smallint
          ia.EndTM  -- EndTm - smallint
      --  NULL  -- AppointmentGuid - uniqueidentifier
FROM dbo.[_import_1_1_Appointment] as ia 
INNER JOIN dbo.patient AS pat ON
  pat.VendorID = ia.PatVendorID AND
  pat.practiceID = @PracticeID
LEFT JOIN dbo.patientcase AS patcase ON
  patcase.patientID = pat.patientID AND
  patcase.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(ia.StartDate AS date) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted into Appointment Successfully'

PRINT ''
PRINT 'Inserting into Appointment To Appointment Reason'
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
FROM dbo.[_import_1_1_Appointment] as ia 
--LEFT JOIN dbo.patient AS pat ON
--  pat.VendorID = ia.PatVendorID AND
--  pat.practiceID = @PracticeID
INNER JOIN dbo.Appointment AS dboa ON
    dboa.Subject = CAST(ia.AutoTempID AS VARCHAR) + ia.PatVendorID AND
    dboa.PracticeID = @PracticeID AND
    dboa.startdate = CAST(ia.StartDate AS DATETIME) AND 
    dboa.enddate = CAST(ia.EndDate AS DATETIME) 
INNER JOIN dbo.AppointmentReason AS ar ON 
    ar.Name = ia.AppointmentReason AND 
    ar.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted AppointmentToAppointmentReason'

PRINT ''
PRINT 'Inserting records into AppointmenttoResource '
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
          dboa.AppointmentResourceTypeID , -- AppointmentResourceTypeID - int
          2 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointment] as ia 
--LEFT JOIN dbo.patient AS pat ON
--  pat.VendorID = ia.PatVendorID AND
--  pat.practiceID = @PracticeID
INNER JOIN dbo.Appointment AS dboa ON
    dboa.Subject = CAST(ia.AutoTempID AS VARCHAR) + ia.PatVendorID AND
    dboa.PracticeID = @PracticeID AND
    dboa.startdate = CAST(ia.StartDate AS DATETIME) AND 
    dboa.enddate = CAST(ia.EndDate AS DATETIME) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource '

PRINT ''
PRINT'Inserting records into InsurancePolicy PRIMARY'
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
      /*  HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,  */
      --    HolderEmployerName ,
      --  PatientInsuranceStatusID ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     /*   RecordTimeStamp ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,
          Copay ,
          Deductible ,
          PatientInsuranceNumber ,   */
          Active ,
          PracticeID ,
      /*  AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,  */
          VendorID ,
          VendorImportID 
      /*  InsuranceProgramTypeID ,
          GroupName 
          ReleaseOfInformation 
          SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patcase.PatientCaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          pol.Precedence , -- Precedence - int
          pol.[policy] , -- PolicyNumber - varchar(32)
          LEFT(pol.[group], 32) , -- GroupNumber - varchar(32)
      /*  '' , -- PolicyStartDate - datetime
          '' , -- PolicyEndDate - datetime
          '' , -- CardOnFile - bit    */
          pol.PrimarySubscriberRelationship , -- PatientRelationshipToInsured - varchar(1)
      /*  '' , -- HolderPrefix - varchar(16)
          '' , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          '' , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          '' , -- HolderDOB - datetime
          '' , -- HolderSSN - char(11)   
          '' , -- HolderThroughEmployer - bit   */
      --    pol.Employer , -- HolderEmployerName - varchar(128)
      --  '' , -- PatientInsuranceStatusID - int  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      /*  NULL , -- RecordTimeStamp - timestamp
          '' , -- HolderGender - char(1)
          '' , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          '' , -- HolderCity - varchar(128)
          '' , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          '' , -- HolderZipCode - varchar(9)
          '' , -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10)
          '' , -- DependentPolicyNumber - varchar(32) 
          '' , -- Notes - text 
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' ,-- FaxExt - varchar(10)
          '' , -- Copay - money
          '' , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32)   */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)    */
          pol.patvendorid , -- VendorID - varchar(50)  
          @VendorImportID  -- VendorImportID - int
       /* pol.InsuranceProgramTypeID , -- InsuranceProgramTypeID - int
          pol.Group -- GroupName - varchar(14)
          pol.ReleaseOfInformation  -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier    */
FROM dbo.[_import_1_1_Policy] as pol
INNER JOIN dbo.PatientCase AS patCase ON 
    patCase.VendorID = pol.PatVendorID  AND
	patCase.PracticeID = @PracticeID 
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
       inscoplan.VendorID = pol.InsVendorID AND
	   inscoplan.vendorimportID = @vendorimportID  	
WHERE pol.Policy <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted Insurance Policy PRIMARY'

--PRINT ''
--PRINT'Inserting records into InsurancePolicy SECONDARY'
--INSERT INTO dbo.InsurancePolicy
--        ( PatientCaseID ,
--          InsuranceCompanyPlanID ,
--          Precedence ,
--          PolicyNumber ,
--          GroupNumber ,
--      /*  PolicyStartDate ,
--          PolicyEndDate ,
--          CardOnFile ,   */
--          PatientRelationshipToInsured ,
--      /*  HolderPrefix ,
--          HolderFirstName ,
--          HolderMiddleName ,
--          HolderLastName ,
--          HolderSuffix ,
--          HolderDOB ,
--          HolderSSN ,
--          HolderThroughEmployer ,  */
--          HolderEmployerName ,
--      --  PatientInsuranceStatusID ,  
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--     /*   RecordTimeStamp ,
--          HolderGender ,
--          HolderAddressLine1 ,
--          HolderAddressLine2 ,
--          HolderCity ,
--          HolderState ,
--          HolderCountry ,
--          HolderZipCode ,
--          HolderPhone ,
--          HolderPhoneExt ,
--          DependentPolicyNumber ,
--          Notes ,
--          Phone ,
--          PhoneExt ,
--          Fax ,
--          FaxExt ,
--          Copay ,
--          Deductible ,
--          PatientInsuranceNumber ,   */
--          Active ,
--          PracticeID ,
--      /*  AdjusterPrefix ,
--          AdjusterFirstName ,
--          AdjusterMiddleName ,
--          AdjusterLastName ,
--          AdjusterSuffix ,  */
--          VendorID ,
--          VendorImportID  
--      /*  InsuranceProgramTypeID ,
--          GroupName 
--          ReleaseOfInformation 
--          SyncWithEHR ,
--          InsurancePolicyGuid  */
--        )
--SELECT DISTINCT
--          patcase.PatientCaseID , -- PatientCaseID - int
--          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
--          pol.Precedence , -- Precedence - int
--          pol.[Policy] , -- PolicyNumber - varchar(32)
--          LEFT(pol.[group], 32) , -- GroupNumber - varchar(32)
--      /*  '' , -- PolicyStartDate - datetime
--          '' , -- PolicyEndDate - datetime
--          '' , -- CardOnFile - bit    */
--          pol.SecondarySubscriberRelationship , -- PatientRelationshipToInsured - varchar(1)
--      /*  '' , -- HolderPrefix - varchar(16)
--          '' , -- HolderFirstName - varchar(64)
--          '' , -- HolderMiddleName - varchar(64)
--          '' , -- HolderLastName - varchar(64)
--          '' , -- HolderSuffix - varchar(16)
--          '' , -- HolderDOB - datetime
--          '' , -- HolderSSN - char(11)   
--          '' , -- HolderThroughEmployer - bit   */
--          pol.Employer , -- HolderEmployerName - varchar(128)
--      --  '' , -- PatientInsuranceStatusID - int  
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--      /*  NULL , -- RecordTimeStamp - timestamp
--          '' , -- HolderGender - char(1)
--          '' , -- HolderAddressLine1 - varchar(256)
--          '' , -- HolderAddressLine2 - varchar(256)
--          '' , -- HolderCity - varchar(128)
--          '' , -- HolderState - varchar(2)
--          '' , -- HolderCountry - varchar(32)
--          '' , -- HolderZipCode - varchar(9)
--          '' , -- HolderPhone - varchar(10)
--          '' , -- HolderPhoneExt - varchar(10)
--          '' , -- DependentPolicyNumber - varchar(32) 
--          '' , -- Notes - text 
--          '' , -- Phone - varchar(10)
--          '' , -- PhoneExt - varchar(10)
--          '' , -- Fax - varchar(10)
--          '' , -- FaxExt - varchar(10)
--          '' , -- Copay - money
--          '' , -- Deductible - money
--          '' , -- PatientInsuranceNumber - varchar(32)   */
--          1 , -- Active - bit
--          @PracticeID , -- PracticeID - int
--      /*  '' , -- AdjusterPrefix - varchar(16)
--          '' , -- AdjusterFirstName - varchar(64)
--          '' , -- AdjusterMiddleName - varchar(64)
--          '' , -- AdjusterLastName - varchar(64)
--          '' , -- AdjusterSuffix - varchar(16)    */
--          pol.patvendorid , -- VendorID - varchar(50)  
--          @VendorImportID  -- VendorImportID - int
--       /* pol.InsuranceProgramTypeID , -- InsuranceProgramTypeID - int
--          pol.Group -- GroupName - varchar(14)
--          pol.ReleaseOfInformation  -- ReleaseOfInformation - varchar(1)
--          NULL , -- SyncWithEHR - bit
--          NULL  -- InsurancePolicyGuid - uniqueidentifier    */
--FROM dbo.[_import_1_1_Policy] as pol
--INNER JOIN dbo.PatientCase AS patCase ON 
--    patCase.VendorID = pol.PatVendorID  AND
--	patCase.PracticeID = @PracticeID 
--INNER JOIN dbo.insurancecompanyplan as inscoplan ON
--       inscoplan.VendorID = pol.InsVendorID AND
--	   inscoplan.vendorimportID = @vendorimportID  	
--WHERE pol.Policy <> '' and pol.Precedence=2 --AND pol.insurancepolicyvendorid<>''
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted Insurance Policy SECONDARY'

--PRINT ''
--PRINT'Inserting records into InsurancePolicy TERTIARY'
--INSERT INTO dbo.InsurancePolicy
--        ( PatientCaseID ,
--          InsuranceCompanyPlanID ,
--          Precedence ,
--          PolicyNumber ,
--          GroupNumber ,
--      /*  PolicyStartDate ,
--          PolicyEndDate ,
--          CardOnFile ,   */
--          PatientRelationshipToInsured ,
--      /*  HolderPrefix ,
--          HolderFirstName ,
--          HolderMiddleName ,
--          HolderLastName ,
--          HolderSuffix ,
--          HolderDOB ,
--          HolderSSN ,
--          HolderThroughEmployer ,  */
--          HolderEmployerName ,
--      --  PatientInsuranceStatusID ,  
--          CreatedDate ,
--          CreatedUserID ,
--          ModifiedDate ,
--          ModifiedUserID ,
--     /*   RecordTimeStamp ,
--          HolderGender ,
--          HolderAddressLine1 ,
--          HolderAddressLine2 ,
--          HolderCity ,
--          HolderState ,
--          HolderCountry ,
--          HolderZipCode ,
--          HolderPhone ,
--          HolderPhoneExt ,
--          DependentPolicyNumber ,
--          Notes ,
--          Phone ,
--          PhoneExt ,
--          Fax ,
--          FaxExt ,
--          Copay ,
--          Deductible ,
--          PatientInsuranceNumber ,   */
--          Active ,
--          PracticeID ,
--      /*  AdjusterPrefix ,
--          AdjusterFirstName ,
--          AdjusterMiddleName ,
--          AdjusterLastName ,
--          AdjusterSuffix ,  */
--          VendorID ,
--          VendorImportID 
--      /*  InsuranceProgramTypeID ,
--          GroupName 
--          ReleaseOfInformation 
--          SyncWithEHR ,
--          InsurancePolicyGuid  */
--        )
--SELECT DISTINCT
--          patcase.PatientCaseID , -- PatientCaseID - int
--          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
--          pol.Precedence , -- Precedence - int
--          pol.[Policy] , -- PolicyNumber - varchar(32)
--          LEFT(pol.[group], 32) , -- GroupNumber - varchar(32)
--      /*  '' , -- PolicyStartDate - datetime
--          '' , -- PolicyEndDate - datetime
--          '' , -- CardOnFile - bit    */
--          'S' , -- PatientRelationshipToInsured - varchar(1)
--      /*  '' , -- HolderPrefix - varchar(16)
--          '' , -- HolderFirstName - varchar(64)
--          '' , -- HolderMiddleName - varchar(64)
--          '' , -- HolderLastName - varchar(64)
--          '' , -- HolderSuffix - varchar(16)
--          '' , -- HolderDOB - datetime
--          '' , -- HolderSSN - char(11)   
--          '' , -- HolderThroughEmployer - bit   */
--          pol.Employer , -- HolderEmployerName - varchar(128)
--      --  '' , -- PatientInsuranceStatusID - int  
--          GETDATE() , -- CreatedDate - datetime
--          0 , -- CreatedUserID - int
--          GETDATE() , -- ModifiedDate - datetime
--          0 , -- ModifiedUserID - int
--      /*  NULL , -- RecordTimeStamp - timestamp
--          '' , -- HolderGender - char(1)
--          '' , -- HolderAddressLine1 - varchar(256)
--          '' , -- HolderAddressLine2 - varchar(256)
--          '' , -- HolderCity - varchar(128)
--          '' , -- HolderState - varchar(2)
--          '' , -- HolderCountry - varchar(32)
--          '' , -- HolderZipCode - varchar(9)
--          '' , -- HolderPhone - varchar(10)
--          '' , -- HolderPhoneExt - varchar(10)
--          '' , -- DependentPolicyNumber - varchar(32) 
--          '' , -- Notes - text 
--          '' , -- Phone - varchar(10)
--          '' , -- PhoneExt - varchar(10)
--          '' , -- Fax - varchar(10)
--          '' , -- FaxExt - varchar(10)
--          '' , -- Copay - money
--          '' , -- Deductible - money
--          '' , -- PatientInsuranceNumber - varchar(32)   */
--          1 , -- Active - bit
--          @PracticeID , -- PracticeID - int
--      /*  '' , -- AdjusterPrefix - varchar(16)
--          '' , -- AdjusterFirstName - varchar(64)
--          '' , -- AdjusterMiddleName - varchar(64)
--          '' , -- AdjusterLastName - varchar(64)
--          '' , -- AdjusterSuffix - varchar(16)    */
--          pol.patvendorid , -- VendorID - varchar(50)  
--          @VendorImportID  -- VendorImportID - int
--       /* pol.InsuranceProgramTypeID , -- InsuranceProgramTypeID - int
--          '' -- GroupName - varchar(14)
--          pol.ReleaseOfInformation  -- ReleaseOfInformation - varchar(1)
--          NULL , -- SyncWithEHR - bit
--          NULL  -- InsurancePolicyGuid - uniqueidentifier    */
--FROM dbo.[_import_1_1_Policy] as pol
--INNER JOIN dbo.PatientCase AS patCase ON 
--    patCase.VendorID = pol.PatVendorID  AND
--	patCase.PracticeID = @PracticeID 
--INNER JOIN dbo.insurancecompanyplan as inscoplan ON
--       inscoplan.VendorID = pol.InsVendorID AND
--	   inscoplan.vendorimportID = @vendorimportID  	
--WHERE pol.Policy <> '' and pol.Precedence=3 --AND pol.insurancepolicyvendorid<>''
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted Insurance Policy TERTIARY'

PRINT '' 
PRINT 'updating patient case with PayerScenarioID'
Update dbo.patientcase set PayerScenarioID=11, name='Self Pay' from dbo.patientcase as patcase 
LEFT JOIN dbo.insurancepolicy as ip ON
ip.patientcaseID = patcase.patientcaseID 
where patcase.VendorImportID = @vendorImportID AND
ip.patientcaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated into patient case '




--ROLLBACK
--COMMIT TRANSACTION
--        PRINT 'COMMITTED SUCCESSFULLY'



SELECT COUNT(*) FROM dbo.[_import_1_1_Appointment] AS [APPOINTMENT]
SELECT COUNT(*) FROM dbo.[_import_1_1_InsuranceList]
SELECT COUNT(*) FROM dbo.[_import_1_1_PatDemo]
SELECT COUNT(*) FROM dbo.[_import_1_1_Policy]