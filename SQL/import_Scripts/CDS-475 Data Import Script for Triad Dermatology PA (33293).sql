USE superbill_33293_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 4 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

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
DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCaseDate'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCase'
DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'
DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Doctor'
*/




PRINT ''
PRINT 'Inserting records into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
     /*   Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,  */ 
          Country ,
      --  ZipCode ,  
          ContactPrefix ,
       /* ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,   */
          ContactSuffix ,
       /* Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,   */ 
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
      --  LocalUseFieldTypeCode ,
          ReviewCode ,  
      /*  ProviderNumberTypeID ,
          GroupNumberTypeID ,
          LocalUseProviderNumberTypeID ,
          CompanyTextID ,
          ClearinghousePayerID ,   */ 
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
          il.insurancename, -- InsuranceCompanyName - varchar(128)
      /*  '' , -- Notes - text
          '' , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          '' , -- City - varchar(128)
          '' , -- State - varchar(2)  */
          '' , -- Country - varchar(32)
     --   '' ,  -- ZipCode - varchar(9)   
          '' , -- ContactPrefix - varchar(16)
     /*   '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64) */
          '' , -- ContactSuffix - varchar(16)
      /*  '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10) */
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)	
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
     --   '' , -- LocalUseFieldTypeCode - char(5)
          'R' , -- ReviewCode - char(1)  
      /*  '' , -- ProviderNumberTypeID - int   
          0 , -- GroupNumberTypeID - int
          0 , -- LocalUseProviderNumberTypeID - int
          '' , -- CompanyTextID - varchar(10)
          0 , -- ClearinghousePayerID - int */
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      /*  0 , -- KareoInsuranceCompanyID - int
          GETDATE() , -- KareoLastModifiedDate - datetime
          NULL , -- RecordTimeStamp - timestamp   */
          13 , -- SecondaryPrecedenceBillingFormID - int
          il.insurancename, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      /*  '' , -- DefaultAdjustmentCode - varchar(10)
          0 , -- ReferringProviderNumberTypeID - int   */
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM  [dbo].[_import_4_1_InsuranceList] as il
WHERE il.insurancename<>''  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company'

PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
      /*  AddressLine1 ,
          AddressLine2 ,
          City ,
          State , */
          Country ,
      --  ZipCode ,
          ContactPrefix ,
      /*  ContactFirstName ,
          ContactMiddleName ,
          ContactLastName , */
          ContactSuffix , 
      --  Phone ,
      --  PhoneExt ,
      --  Notes ,
      --  MM_CompanyID ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     --   RecordTimeStamp ,
          ReviewCode ,
          CreatedPracticeID ,
      --  Fax ,
       /* FaxExt ,
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
      /*  '' , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          '' , -- City - varchar(128)
          '' , -- State - varchar(2)  */
          '' , -- Country - varchar(32)
      --  '' , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
      /*  '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)  */  
          '' , -- ContactSuffix - varchar(16)  
      /*  '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Notes - text
          '' , -- MM_CompanyID - varchar(10) */
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          'R' , -- ReviewCode - char(1)
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
          @VendorImportID  -- VendorImportID - int6
      --  NULL  -- InsuranceCompanyPlanGuid - uniqueidentifier
FROM dbo.Insurancecompany as ic
WHERE VendorImportID=@VendorImportID AND CreatedPracticeID=@PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company plan'

PRINT ''
PRINT 'Inserting Into Doctor'
INSERT INTO dbo.Doctor
        ( PracticeID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
      --  SSN ,
      /*  AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          HomePhone , */
      --  HomePhoneExt ,
      --  WorkPhone ,
      --  WorkPhoneExt ,
      --  PagerPhone ,
     /*   PagerPhoneExt ,
          MobilePhone ,
          MobilePhoneExt ,
          DOB ,
          EmailAddress ,  */
      --  Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
      --  UserID ,
      --  Degree ,
      --  DefaultEncounterTemplateID ,
      --  TaxonomyCode ,
      --  DepartmentID ,
          VendorID ,
          VendorImportID ,
      --  FaxNumber 
     /*   FaxNumberExt ,
          OrigReferringPhysicianID ,  */
          [External] 
      /*  NPI ,
          ProviderTypeID ,
          ProviderPerformanceReportActive ,
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
SELECT  DISTINCT
          @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          id.firstname , -- FirstName - varchar(64)
          id.middlename , -- MiddleName - varchar(64)
          id.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
      /*  '' , -- SSN - varchar(9)
          '' , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          '' , -- City - varchar(128)
          '' , -- State - varchar(2)
          '' , -- Country - varchar(32)
          '' , -- ZipCode - varchar(9)
          '' , -- HomePhone - varchar(10)
          '' , -- HomePhoneExt - varchar(10)
          '' , -- WorkPhone - varchar(10)   */
      --  '' , -- WorkPhoneExt - varchar(10)
      --  '' , -- PagerPhone - varchar(10)
      --  '' , -- PagerPhoneExt - varchar(10)
      --  '' , -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  GETDATE() , -- DOB - datetime
      --  '' , -- EmailAddress - varchar(256)
      --  '' , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  0 , -- UserID - int
	  --  '' , -- Degree - varchar(8)
      --  0 , -- DefaultEncounterTemplateID - int
      --  '' , -- TaxonomyCode - char(10)
      --  0 , -- DepartmentID - int
          LEFT(vendorid, 50) , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  '' ,  -- FaxNumber - varchar(10)
     /*   '' , -- FaxNumberExt - varchar(10)
          0 , -- OrigReferringPhysicianID - int  */
          1  -- External - bit
     /*   '' , -- NPI - varchar(10)
          0 , -- ProviderTypeID - int
          NULL , -- ProviderPerformanceReportActive - bit
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
          NULL  -- ActivateAfterWizard - bit   */       
FROM dbo.[_import_4_1_Doctor] as id
where id.firstname <>'' and id.lastname <>''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Doctor'

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
      --  WorkPhone ,
      --  WorkPhoneExt ,
          DOB ,
          SSN ,
      --  EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
     /*   ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName , */
          ResponsibleSuffix ,
      --  ResponsibleRelationshipToPatient ,
      /*  ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,  
          ResponsibleCountry ,
          ResponsibleZipCode ,  */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     /*   RecordTimeStamp ,
          EmploymentStatus ,
          InsuranceProgramCode ,
          PatientReferralSourceID ,  */
      --  PrimaryProviderID ,  
      --  DefaultServiceLocationID ,
      --  EmployerID ,
          MedicalRecordNumber ,
      --  MobilePhone ,
      --  MobilePhoneExt ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
   --       CollectionCategoryID ,
          Active 
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
          pdp.firstname , -- FirstName - varchar(64)
          pdp.middlename , -- MiddleName - varchar(64)
          pdp.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pdp.address1 , -- AddressLine1 - varchar(256)
          pdp.address2 , -- AddressLine2 - varchar(256)
          pdp.city , -- City - varchar(128)
          pdp.state , -- State - varchar(2) 
          '' , -- Country - varchar(32)  
		  CASE WHEN LEN(pdp.zipcode) = 4 THEN '0' + pdp.zipcode ELSE 
		  LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.zipcode,'-','')),9)  END, -- ZipCode - varchar(9)
          CASE pdp.gender WHEN 'FEMALE' THEN 'F'
                          WHEN 'MALE' THEN 'M'
                          ELSE 'U' END , -- Gender - varchar(1)
      --  '' , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.phone,'-','')),10) , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
      --  '' , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
          CASE WHEN ISDATE(pdp.DOB) = 1 THEN pdp.dob ELSE NULL END ,    /*************************************/
          CASE WHEN LEN(pdp.ssn) >= 6 THEN RIGHT('000' + pdp.ssn, 9) ELSE '' END , -- SSN - char(9)
      --  '' , -- EmailAddress - varchar(256)
          0	 , --  ResponsibleDifferentThanPatient - BIT 
          '' , -- ResponsiblePrefix - varchar(16)
      /*  '' , -- ResponsibleFirstName - varchar(64)
          '' , -- ResponsibleMiddleName - varchar(64)
          '' , -- ResponsibleLastName - varchar(64)  */
          '' , -- ResponsibleSuffix - varchar(16)
      --  '' , -- ResponsibleRelationshipToPatient - varchar(1)
      /*  '' , -- ResponsibleAddressLine1 - varchar(256)
          '' , -- ResponsibleAddressLine2 - varchar(256)
          '' , -- ResponsibleCity - varchar(128)
          '' , -- ResponsibleState - varchar(2)
          '' , -- ResponsibleCountry - varchar(32)
          '' , -- ResponsibleZipCode - varchar(9)  */
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- EmploymentStatus - char(1)
      --  '' , -- InsuranceProgramCode - char(2)
      --  0 , -- PatientReferralSourceID - int
      --  '' , -- PrimaryProviderID - int
      --  '' , -- DefaultServiceLocationID - int
      --  '' , -- EmployerID - int
          pdp.acctnum, -- MedicalRecordNumber - varchar(128)  
      --  '',  -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
          doc.DoctorID, -- PrimaryCarePhysicianID - int  ******************************************
          pdp.acctnum , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
         -- , -- CollectionCategoryID - int  ***we have 1 & 2 values in import file but 2 is not listed in collectioncat table****
          pdp.status  -- Active - bit
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
FROM dbo.[_import_4_1_PatDemoPolicy] as pdp
LEFT JOIN dbo.Doctor AS doc ON
LEFT(pdp.primarycarephysician, 50) = doc.lastname + ',' + doc.firstname + ' ' + doc.middlename     
where pdp.acctnum <>'' AND pdp.firstname <> '' AND pdp.lastname <> '' --and pdp.primarycarephysician <>''
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
SELECT  DISTINCT
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
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into patientcase'

PRINT ''
PRINT 'Inserting into PatientCaseDate'
INSERT INTO dbo.PatientCaseDate
        ( PracticeID ,
          PatientCaseID ,
          PatientCaseDateTypeID ,
          StartDate ,
          EndDate ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID
        )
SELECT DISTINCT 
          @practiceID , -- PracticeID - int
          patcase.patientcaseid , -- PatientCaseID - int
          8 , -- PatientCaseDateTypeID - int
          pdp.lastvisitdate , -- StartDate - datetime  
          NULL , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_4_1_PatDemoPolicy] AS pdp
INNER JOIN dbo.patientcase as patcase ON
        patcase.vendorID = pdp.acctnum AND
		patcase.VendorImportID = @VendorImportID
WHERE pdp.lastvisitdate <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into patientcaseDate'

PRINT ''
PRINT 'Inserting Into InsurancePolicy primary' 
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
      --  PolicyStartDate ,
      --  PolicyEndDate ,
      --  CardOnFile ,
          PatientRelationshipToInsured ,
      --  HolderPrefix ,
      /*  HolderFirstName ,
          HolderMiddleName ,
          HolderLastName , */
      --  HolderSuffix ,
      --  HolderDOB ,
      --  HolderSSN ,
      /*  HolderThroughEmployer ,
          HolderEmployerName ,
          PatientInsuranceStatusID ,  */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
      /*  HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState , 
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt ,
          DependentPolicyNumber , */
      --  Notes ,
      /*  Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,  */
          Copay ,
      --  Deductible ,
      --  PatientInsuranceNumber ,
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
          GroupName ,
          ReleaseOfInformation ,
          SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patcase.patientcaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          pd.primaryinspolicy , -- PolicyNumber - varchar(32)
          pd.primaryinsgroupno , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime 
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
      --  '' , -- HolderPrefix - varchar(16)
      /*  '' , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          '', -- HolderLastName - varchar(64) */
      --  '' , -- HolderSuffix - varchar(16)
      --  '' , -- HolderDOB - datetime
      --  '' , -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      --  '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      /*  '' , -- HolderGender - char(1)
          '' , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          '' , -- HolderCity - varchar(128)
          '' , -- HolderState - varchar(2)  
          '' , -- HolderCountry - varchar(32)  */
      --  '' , -- HolderZipCode - varchar(9)
      --  '' , -- HolderPhone - varchar(10)
      --  '' , -- HolderPhoneExt - varchar(10)
      --  '' , -- DependentPolicyNumber - varchar(32)
      --  '' , -- Notes - text    
      --  '' , -- PhoneExt - varchar(10)
      --  '' , -- Fax - varchar(10)
      --  '' , -- FaxExt - varchar(10)
          pd.primaryinscopays , -- Copay - money
      --  '' , -- Deductible - money
      --  '' , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)  */
          pd.primaryinspolicy , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      /*  0 , -- InsuranceProgramTypeID - int
          '' , -- GroupName - varchar(14)
          '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_4_1_PatDemoPolicy] as pd
INNER JOIN dbo.patientcase as patcase ON
        patcase.VendorID = pd.acctnum  AND
        patcase.practiceID = @practiceID 
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = pd.primaryinsurancename  AND
		inscoplan.CreatedPracticeID = @practiceID 
WHERE pd.primaryinspolicy <>'' AND pd.primaryinspolicy<>'000-00-0000'    
PRINT CAST(@@ROWCOUNT AS VARCHAR ) + ' records inserted into InsurancePolicy primary'


PRINT ''
PRINT 'Inserting Into InsurancePolicy secondary' 
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
     --     PolicyNumber ,
      --    GroupNumber ,
      --  PolicyStartDate ,
      --  PolicyEndDate ,
      --  CardOnFile ,
          PatientRelationshipToInsured ,
      --  HolderPrefix ,
      /*  HolderFirstName ,
          HolderMiddleName ,
          HolderLastName , */
      --  HolderSuffix ,
      --  HolderDOB ,
      --  HolderSSN ,
      /*  HolderThroughEmployer ,
          HolderEmployerName ,
          PatientInsuranceStatusID ,  */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
      /*  HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState , 
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt ,
          DependentPolicyNumber , */
      --  Notes ,
      /*  Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,  */
     --     Copay ,
      --  Deductible ,
      --  PatientInsuranceNumber ,
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
          GroupName ,
          ReleaseOfInformation ,
          SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patcase.patientcaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
      --    pd.primaryinspolicy , -- PolicyNumber - varchar(32)
      --    pd.primaryinsgroupno , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime 
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
      --  '' , -- HolderPrefix - varchar(16)
      /*  '' , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          '', -- HolderLastName - varchar(64) */
      --  '' , -- HolderSuffix - varchar(16)
      --  '' , -- HolderDOB - datetime
      --  '' , -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      --  '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      /*  '' , -- HolderGender - char(1)
          '' , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          '' , -- HolderCity - varchar(128)
          '' , -- HolderState - varchar(2)  
          '' , -- HolderCountry - varchar(32)  */
      --  '' , -- HolderZipCode - varchar(9)
      --  '' , -- HolderPhone - varchar(10)
      --  '' , -- HolderPhoneExt - varchar(10)
      --  '' , -- DependentPolicyNumber - varchar(32)
      --  '' , -- Notes - text    
      --  '' , -- PhoneExt - varchar(10)
      --  '' , -- Fax - varchar(10)
      --  '' , -- FaxExt - varchar(10)
      --    pd.primaryinscopays , -- Copay - money
      --  '' , -- Deductible - money
      --  '' , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)  */
          patcase.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      /*  0 , -- InsuranceProgramTypeID - int
          '' , -- GroupName - varchar(14)
          '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_4_1_PatDemoPolicy] as pd
INNER JOIN dbo.patientcase as patcase ON
        patcase.VendorID = pd.acctnum  AND
        patcase.practiceID = @practiceID 
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = pd.secondaryinsurance  AND
		inscoplan.CreatedPracticeID = @practiceID  
PRINT CAST(@@ROWCOUNT AS VARCHAR ) + ' records inserted into InsurancePolicy secondary'

PRINT ''
PRINT 'Inserting into AppointmentReason'
INSERT INTO dbo.AppointmentReason
        ( PracticeID ,
          Name ,
      --  DefaultDurationMinutes ,
      --  DefaultColorCode ,
          Description ,
          ModifiedDate 
      --  TIMESTAMP ,
      --  AppointmentReasonGuid
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
          ia.apptreason , -- Name - varchar(128)
      --  '' , -- DefaultDurationMinutes - int
      --  0 , -- DefaultColorCode - int
          ia.apptreason , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
     --   NULL , -- TIMESTAMP - timestamp
     --   NULL  -- AppointmentReasonGuid - uniqueidentifier  
FROM dbo.[_import_4_1_Appointment] as ia 
where ia.ApptReason <> '' AND NOT EXISTS (select * from dbo.AppointmentReason as ar where ar.Name = ia.apptreason  AND PracticeID = @practiceID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into AppointmentReason'


PRINT ''
PRINT 'Inserting records into PracticeResource'  
INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
     --   PracticeResourceGuid ,
          ModifiedDate ,
          CreatedDate
        )
SELECT  DISTINCT
          3 , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          ia.practiceresource , -- ResourceName - varchar(50)
	 --   '' ,  -- PracticeResourceGuid - uniqueidentifier
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
FROM dbo.[_import_4_1_Appointment] as ia 
where ia.practiceresource <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in PracticeResource'

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
       --   Notes ,
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
          ia.locationID , -- ServiceLocationID - int
          ia.startdate , -- StartDate - datetime
          ia.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          ia.ticket , -- Subject - varchar(64) *****************we took ticket column as subject******************
      --    ia.notes , -- Notes - text               ***********************************
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE WHEN ia.practiceresource <> '' THEN 2 ELSE 1 END, -- AppointmentResourceTypeID - int
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
FROM dbo.[_import_4_1_Appointment] as ia 
INNER JOIN dbo.patient AS pat ON
  pat.VendorID = ia.acctnum and
  pat.practiceID = @PracticeID
LEFT JOIN dbo.patientcase AS patcase ON
  patcase.patientID = pat.patientID AND
  patcase.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(ia.startdate AS date) AS DATETIME) 
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
FROM  dbo.[_import_4_1_Appointment] as ia 
INNER JOIN dbo.Appointment AS dboa ON
    dboa.practiceID = @practiceID  AND
	dboa.[subject] = ia.ticket 
INNER JOIN dbo.AppointmentReason AS ar ON 
       ar.name = ia.apptreason 
   AND ar.PracticeID = @PracticeID
WHERE ia.apptreason <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Appointment To Appointment Reason'

PRINT ''
PRINT 'Inserting records into AppointmenttoResource Type -1'
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
          2 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo._import_4_1_Appointment as ia
INNER JOIN dbo.Appointment AS dboa ON
       dboa.practiceID = @practiceID  AND
	   dboa.[subject] = ia.ticket 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource'


PRINT ''
PRINT 'Inserting records into AppointmenttoResource Type 2'
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
          2 , -- AppointmentResourceTypeID - int
          pr.PracticeResourceID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo._import_4_1_Appointment as ia
INNER JOIN dbo.Appointment AS dboa ON
     dboa.practiceID = @practiceID AND
	 dboa.[subject] = ia.ticket 
INNER JOIN dbo.PracticeResource pr ON
	pr.ResourceName = ia.practiceresource AND
	pr.PracticeID = @PracticeID
WHERE ia.practiceresource <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource'



PRINT '' 
PRINT 'updating patient case with PayerScenarioID'
update dbo.patientcase set PayerScenarioID=11, name='Self Pay' from dbo.patientcase as patcase 
LEFT JOIN dbo.insurancepolicy as ip ON
ip.patientcaseID = patcase.patientcaseID 
where patcase.VendorImportID = @vendorImportID AND
ip.patientcaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated into patient case '


--ROLLBACK
--COMMIT TRANSACTION
--PRINT 'COMMITTED SUCCESSFULLY'
