USE superbill_32387_dev
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
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))
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
DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'
*/


PRINT ''
PRINT 'Inserting records into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
      --  Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,   
          Country ,
          ZipCode ,  
          ContactPrefix ,
      /*  ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,   */
          ContactSuffix ,
      --  Phone ,
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
          il.carriername , -- InsuranceCompanyName - varchar(128)
      --  '' , -- Notes - text
          il.address1 , -- AddressLine1 - varchar(256)
          il.address2 , -- AddressLine2 - varchar(256)
          il.city , -- City - varchar(128)
          il.state , -- State - varchar(2) */ 
          '' , -- Country - varchar(32)
          CASE WHEN LEN(il.zipcode) = 4 THEN '0' + il.zipcode ELSE LEFT(il.zipcode, 9) END ,  -- ZipCode - varchar(9)  
          '' , -- ContactPrefix - varchar(16)
      /*  '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64) */
          '' , -- ContactSuffix - varchar(16)
      --  '' , -- Phone - varchar(10)
      /*  '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)  */
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          il.InsuranceProgramCode , -- InsuranceProgramCode - char(2)
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
WHERE il.carriername<>''  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company'

PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State , 
          Country ,
          ZipCode ,
          ContactPrefix ,
      /*  ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,  */
          ContactSuffix ,
      --  Phone ,
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
          ic.AddressLine2 , -- AddressLine2 - varchar(256)
          ic.city , -- City - varchar(128)
          ic.state , -- State - varchar(2)  
          '' , -- Country - varchar(32)
          ic.ZipCode , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
      /*  '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)  */
          '' , -- ContactSuffix - varchar(16)
      --  '' , -- Phone - varchar(10)
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
          MaritalStatus ,
          HomePhone ,
      --  HomePhoneExt ,
          WorkPhone ,
      --  WorkPhoneExt ,
          DOB ,
          SSN ,
      --  EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName , 
          ResponsibleSuffix ,
          ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,  
          ResponsibleCountry ,
          ResponsibleZipCode ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
          EmploymentStatus ,
      /*  InsuranceProgramCode ,
          PatientReferralSourceID ,  */
          PrimaryProviderID ,  
          DefaultServiceLocationID ,
      --  EmployerID ,
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
      --  LicenseNumber 
      --  LicenseState ,
      --  Language1 ,
      --  Language2
        )
SELECT  DISTINCT
          @PracticeID , -- PracticeID - int
      --  '' , -- ReferringPhysicianID - int
          p.prefix , -- Prefix - varchar(16)
          p.firstname , -- FirstName - varchar(64)
          p.middlename , -- MiddleName - varchar(64)
          p.lastname , -- LastName - varchar(64)
          '' ,  -- Suffix - varchar(16)
          p.address1 , -- AddressLine1 - varchar(256)
          p.address2 , -- AddressLine2 - varchar(256)
          p.city , -- City - varchar(128)
          p.state , -- State - varchar(2)
          '' , -- Country - varchar(32)   
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(p.zipcode,'-','')),9) , -- ZipCode - varchar(9)
          p.gender  , -- Gender - varchar(1)
          CASE p.maritalstatus WHEN 1 THEN 'M'
							   WHEN 2 THEN 'M'
							   WHEN 6 THEN 'M'
							   WHEN 3 THEN 'D'
							   WHEN 4 THEN 'L'
							   WHEN 5 THEN 'W'
							   ELSE 'S' END , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(p.homephone,' ','')),10) , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(p.officephone,' ','')),10) , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
          p.dob  , -- DOB - datetime
		  CASE WHEN LEN(p.ssn) >= 6 THEN RIGHT ('000' + p.ssn , 9) ELSE '' END , -- SSN - char(9)
      --  '' , -- EmailAddress - varchar(256) 
          CASE WHEN p.relationship = 'O' THEN 1 ELSE 0 END , --  ResponsibleDifferentThanPatient - BIT ,
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN p.relationship = 'O' THEN res.firstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN p.relationship = 'O' THEN res.middlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN p.relationship = 'O' THEN res.lastname END , -- ResponsibleLastName - varchar(64)  
          '' , -- ResponsibleSuffix - varchar(16)
          p.relationship , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN p.relationship = 'O' THEN res.address1 END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN p.relationship = 'O' THEN res.address2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN p.relationship = 'O' THEN res.city END , -- ResponsibleCity - varchar(128)
          CASE WHEN p.relationship = 'O' THEN res.state END , -- ResponsibleState - varchar(2)  
          '' , -- ResponsibleCountry - varchar(32)
          CASE WHEN p.relationship = 'O' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(res.zipcode,'-','')),9) END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          'U' , -- EmploymentStatus - char(1)
      --  '' , -- InsuranceProgramCode - char(2)
      --  0  , -- PatientReferralSourceID - int
          CASE WHEN p.PrimaryProviderID = '' THEN NULL ELSE p.PrimaryProviderID END , -- PrimaryProviderID - int
          1  , -- DefaultServiceLocationID - int
      --  '' , -- EmployerID - int
          p.chartnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(p.mobilephone,' ','')),10) ,  -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  '' , -- PrimaryCarePhysicianID - int
          p.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  0 , -- CollectionCategoryID - int
          1  -- Active - bit
      --  NULL , -- SendEmailCorrespondence - bit
      --  NULL , -- PhonecallRemindersEnabled - bit
      --  '' , -- EmergencyName - varchar(128)
      --  '' ,    -- EmergencyPhone - varchar(10)
      --  '' , -- EmergencyPhoneExt - varchar(10)
      --  NULL , -- PatientGuid - uniqueidentifier
      --  '' , -- Ethnicity - varchar(64)
      --  '' , -- Race - varchar(64)
      --  '' ,  -- LicenseNumber - varchar(64)
      --  '' , -- LicenseState - varchar(2)
      --  '' , -- Language1 - varchar(64)
      --  ''  -- Language2 - varchar(64)
FROM dbo.[_import_1_1_PatientInfo] as p
LEFT JOIN dbo.[_import_1_1_Responsibleparties] as res ON
     res.responsiblepartyuid = p.responsiblepartyfid
where p.firstname <> '' and p.lastname <>'' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully'



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
      --  Description ,
          ModifiedDate 
      --  TIMESTAMP ,
      --  AppointmentReasonGuid
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
          ia.AppointmentReason , -- Name - varchar(128)
          15 , -- DefaultDurationMinutes - int
      --  0 , -- DefaultColorCode - int
      --  '' , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
     --   NULL , -- TIMESTAMP - timestamp
     --   NULL  -- AppointmentReasonGuid - uniqueidentifier  
FROM dbo.[_import_1_1_appointment] as ia
WHERE ia.AppointmentReason<>'' and not exists (select * from dbo.AppointmentReason ar where ar.name = ia.AppointmentReason)
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
SELECT  DISTINCT  
          pat.PatientID , -- PatientID - int
          @PracticeID , -- PracticeID - int
          1 , -- ServiceLocationID - int
          ia.StartDate , -- StartDate - datetime
          ia.EndDate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          ia.Subject , -- Subject - varchar(64)
          ia.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          1 , -- AppointmentResourceTypeID - int
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
          ia.StartTM , -- StartTm - smallint
          ia.EndTM  -- EndTm - smallint
      --  NULL  -- AppointmentGuid - uniqueidentifier
FROM dbo.[_import_1_1_appointment] as ia
INNER JOIN dbo.patient AS pat ON
  pat.VendorID = ia.PatientVendorID AND
  pat.practiceID = @PracticeID
LEFT JOIN dbo.patientcase AS patcase ON
  patcase.patientID = pat.patientID AND
  pat.practiceID = @PracticeID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(ia.startdate AS date) AS DATETIME)
--WHERE ia.appointmentid<>'' and NOT EXISTS (select * from dbo.appointment as dboa where dboa.subject = ims.appointmentid)
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
FROM dbo.[_import_1_1_appointment] as ia
INNER JOIN dbo.Appointment AS dboa ON
    dboa.Subject = ia.Subject AND
    dboa.PracticeID = @PracticeID AND
    dboa.startdate = CAST(ia.startdate AS DATETIME) AND 
    dboa.enddate = CAST(ia.enddate AS DATETIME) 
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
          1 , -- AppointmentResourceTypeID - int
          ia.ResourceID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_appointment] as ia
INNER JOIN dbo.Appointment AS dboa ON
    dboa.Subject = ia.Subject AND
    dboa.PracticeID = @PracticeID AND
    dboa.startdate = CAST(ia.startdate AS DATETIME) AND 
    dboa.enddate = CAST(ia.enddate AS DATETIME) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource '

PRINT ''
PRINT'Inserting records into InsurancePolicy'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
      --  CardOnFile ,   
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
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          --HolderPhoneExt ,
          DependentPolicyNumber ,
     /*   Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,  */
          Copay ,
          Deductible ,
      --  PatientInsuranceNumber ,  
          Active ,
          PracticeID ,
     /*   AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,  */
          VendorID ,
          VendorImportID ,
     --   InsuranceProgramTypeID ,
          GroupName 
     /*   ReleaseOfInformation ,
          SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patCase.PatientCaseID , -- PatientCaseID - int
          insCoPlan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          pol.sequencenumber , -- Precedence - int
          pol.policy , -- PolicyNumber - varchar(32)
          pol.groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN pol.effectivestartdate = '' THEN NULL ELSE pol.effectivestartdate END , -- PolicyStartDate - datetime
          CASE WHEN pol.effectiveenddate = '' THEN NULL ELSE pol.effectiveenddate END  , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit    
          pol.relationshippatienttosubscriber , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN pol.relationshippatienttosubscriber <> 'S' THEN resp.firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN pol.relationshippatienttosubscriber <> 'S' THEN resp.middlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN pol.relationshippatienttosubscriber <> 'S' THEN resp.lastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN pol.relationshippatienttosubscriber <> 'S' THEN resp.dob END , -- HolderDOB - datetime
          CASE WHEN pol.relationshippatienttosubscriber <> 'S' THEN resp.ssn END , -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      --  '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE WHEN pol.relationshippatienttosubscriber <> 'S' THEN resp.gender END , -- HolderGender - char(1)
          CASE WHEN pol.relationshippatienttosubscriber <> 'S' THEN resp.address1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN pol.relationshippatienttosubscriber <> 'S' THEN resp.address2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pol.relationshippatienttosubscriber <> 'S' THEN resp.city END , -- HolderCity - varchar(128)
          CASE WHEN pol.relationshippatienttosubscriber <> 'S' THEN resp.state END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pol.relationshippatienttosubscriber <> 'S' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(resp.zipcode,'-','')),9) END , -- HolderZipCode - varchar(9)
          CASE WHEN pol.relationshippatienttosubscriber <> 'S' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(resp.homephone,'-','')),10) END , -- HolderPhone - varchar(10)
       --  '' , -- HolderPhoneExt - varchar(10)
          CASE WHEN pol.relationshippatienttosubscriber <> 'S' THEN pol.policy END , -- DependentPolicyNumber - varchar(32) 
     /*     '' , -- Notes - text 
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)   */
          pol.copaydollaramount , -- Copay - money
          pol.annualdeductible , -- Deductible - money
      --  '' , -- PatientInsuranceNumber - varchar(32) 
          pol.active , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16) */
          pol.vendorID , -- VendorID - varchar(50)  
          @VendorImportID , -- VendorImportID - int
      --  0 , -- InsuranceProgramTypeID - int
          pol.groupname  -- GroupName - varchar(14)
     /*   '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_1_1_Policy] as pol
INNER JOIN dbo.PatientCase AS patCase ON 
    patCase.VendorID = pol.patientvendorID  AND
	patCase.PracticeID = @PracticeID 
INNER JOIN dbo.InsuranceCompanyPlan AS insCoPlan ON
	insCoPlan.VendorID = pol.InsuranceplanvendorID AND
    insCoPlan.CreatedPracticeID = @PracticeID  
LEFT JOIN dbo.[_import_1_1_Responsibleparties] as resp ON
   resp.responsiblepartyuid = pol.responsiblepartysubscriberfid
WHERE pol.policy <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Insurance Policy'


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