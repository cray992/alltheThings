USE superbill_35589_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
/*
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Doctor'
*/
PRINT ''
PRINT 'Inserting records into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
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
          Phone ,
          PhoneExt ,
      --  Fax ,
      --  FaxExt ,    
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
          i.name , -- InsuranceCompanyName - varchar(128)
          CASE WHEN phone2 = '' THEN '' ELSE 'Phone 2: ' + phone2 END , -- Notes - text
          i.address1 , -- AddressLine1 - varchar(256)
          i.address2 , -- AddressLine2 - varchar(256)
          i.city , -- City - varchar(128)
          i.state , -- State - varchar(2) 				 
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
			   ELSE '' END ,  -- ZipCode - varchar(9)  
          '' , -- ContactPrefix - varchar(16)
      /*  '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64) */
          '' , -- ContactSuffix - varchar(16)
          LEFT(phone1, 10) , -- Phone - varchar(10) 
          CASE
		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(phone1)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(phone1),11,LEN(dbo.fn_RemoveNonNumericCharacters(phone1))),10)
		  ELSE NULL END , -- PhoneExt - varchar(10)
      --  '' , -- Fax - varchar(10)
      --  '' , -- FaxExt - varchar(10) 
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
          i.ins ,-- VendorID - varchar(50)  
          @VendorImportID , -- VendorImportID - int
      --  '' , -- DefaultAdjustmentCode - varchar(10)
      --  0 , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_Insurances] as i 
WHERE i.Ins <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company'

PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
      --  Country ,
          ZipCode ,
          ContactPrefix ,
      /*  ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,*/
          ContactSuffix , 
          Phone ,
          PhoneExt ,
      --  Notes ,
      --  MM_CompanyID ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     --   RecordTimeStamp ,
     --   ReviewCode ,
          CreatedPracticeID ,
      --  Fax ,
      /*  FaxExt ,
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
SELECT  DISTINCT
          ic.InsuranceCompanyName , -- PlanName - varchar(128)
          ic.AddressLine1 , -- AddressLine1 - varchar(256)
          ic.AddressLine2 , -- AddressLine2 - varchar(256)
          ic.City , -- City - varchar(128)
          ic.State , -- State - varchar(2)
      --  '' , -- Country - varchar(32)
          ic.zipcode , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
      /*  '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64) */ 
          '' , -- ContactSuffix - varchar(16)  
          ic.Phone , -- Phone - varchar(10)  
          ic.PhoneExt , -- PhoneExt - varchar(10)
      --  '' , -- Notes - text
      --  '' , -- MM_CompanyID - varchar(10) 
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
      --  '' , -- Fax - varchar(10)
      /*  '' , -- FaxExt - varchar(10)
          0 , -- KareoInsuranceCompanyPlanID - int
          GETDATE() , -- KareoLastModifiedDate - datetime  */
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
      /*  '' , -- ADS_CompanyID - varchar(10)
          NULL , -- Copay - money
          NULL , -- Deductible - money   */
          ic.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int6
      --  NULL  -- InsuranceCompanyPlanGuid - uniqueidentifier
FROM dbo.InsuranceCompany as ic
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
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
      --  HomePhone ,
      --  HomePhoneExt ,
      --  WorkPhone ,
      --  WorkPhoneExt ,
      --  PagerPhone ,
      --  PagerPhoneExt ,
      --  MobilePhone ,
      --  MobilePhoneExt ,
          DOB ,
      --  EmailAddress ,  
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      /*  RecordTimeStamp ,
          UserID , */
          Degree ,
      /*  DefaultEncounterTemplateID ,
          TaxonomyCode ,
          DepartmentID ,  */
          VendorID ,
          VendorImportID ,
      /*  FaxNumber 
          FaxNumberExt ,
          OrigReferringPhysicianID ,  */
          [External] ,
          NPI 
      /*  ProviderTypeID ,
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
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          r.firstname , -- FirstName - varchar(64)  
          '' , -- MiddleName - varchar(64)
          r.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
     --   '' , -- SSN - varchar(9)
          r.address1 , -- AddressLine1 - varchar(256)
          r.address2 , -- AddressLine2 - varchar(256)
          r.city , -- City - varchar(128)
          r.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(r.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(r.zip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(r.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(r.zip)
			   ELSE '' END , -- ZipCode - varchar(9)
     /*   '' , -- HomePhone - varchar(10)
          '' , -- HomePhoneExt - varchar(10)
          '' , -- WorkPhone - varchar(10)   
          '' , -- WorkPhoneExt - varchar(10)
          '' , -- PagerPhone - varchar(10)
          '' , -- PagerPhoneExt - varchar(10)  
          '' , -- MobilePhone - varchar(10) */
     --   '' , -- MobilePhoneExt - varchar(10)
          GETDATE() , -- DOB - datetime
     --   '' , -- EmailAddress - varchar(256)
	     CASE WHEN r.phone1 = '' THEN '' ELSE 'PHONE1: ' + r.phone1 + CHAR(10) + CHAR(13) END 
			   + (CASE WHEN r.phone2 = '' THEN '' ELSE 'PHONE2: ' + r.phone2 + CHAR(10) + CHAR(13) END )
               + (CASE WHEN r.phone3 = '' THEN '' ELSE 'PHONE3: ' + r.phone3 + CHAR(10) + CHAR(13) END )
			   + (CASE WHEN r.upin = '' THEN '' ELSE 'UPIN: ' + r.upin + CHAR(10) + CHAR(13) END )
               + (CASE WHEN r.licence = '' THEN '' ELSE 'LICENCE: ' + r.licence END )  , -- Notes - text 
      --  r.phone1  + ' | ' + r.phone2  + ' | ' + r.phone3  + ' | ' + r.upin  + ' | ' + r.licence  , -- Notes - text 
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      /*  NULL , -- RecordTimeStamp - timestamp
          0 , -- UserID - int */
	      r.degree , -- Degree - varchar(8)
      /*  0 , -- DefaultEncounterTemplateID - int
          '' , -- TaxonomyCode - char(10)
          0 , -- DepartmentID - int   */
          r.refdrid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
     --   '' ,  -- FaxNumber - varchar(10)
     --   '' , -- FaxNumberExt - varchar(10)
     --   0 , -- OrigReferringPhysicianID - int  
          1 , -- External - bit
          r.npi  -- NPI - varchar(10)
     /*   0 , -- ProviderTypeID - int
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
FROM dbo.[_import_1_1_referring] as r
where r.refdrid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Doctor'

PRINT ''
PRINT 'Inserting records into patient'
INSERT INTO dbo.Patient
        ( PracticeID ,
          ReferringPhysicianID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
     --   AddressLine2 ,
          City ,
          State , 
          Country ,
     --   ZipCode ,
          Gender , 
          MaritalStatus ,
          HomePhone ,
        HomePhoneExt ,
          WorkPhone ,
        WorkPhoneExt ,
          DOB ,
          SSN ,
      --  EmailAddress ,
          ResponsibleDifferentThanPatient ,
      --  ResponsibleFirstName ,
      --  ResponsibleMiddleName ,
      --  ResponsibleLastName , 
      /*  ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,  
          ResponsibleCountry ,
          ResponsibleZipCode , */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
          EmploymentStatus ,
          --InsuranceProgramCode ,
          --PatientReferralSourceID ,  
      --  PrimaryProviderID ,  
      --  DefaultServiceLocationID ,
      --  EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
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
          doc.doctorID , -- ReferringPhysicianID - int  
          '' , -- Prefix - varchar(16)
          pd.firstname , -- FirstName - varchar(64)
          pd.mi , -- MiddleName - varchar(64)
          pd.lastname , -- LastName - varchar(64)
          '' ,  -- Suffix - varchar(16)
          pd.streetaddress , -- AddressLine1 - varchar(256)
     --   '' , -- AddressLine2 - varchar(256)
          pd.city , -- City - varchar(128)
          pd.state, -- State - varchar(2) , -- State - varchar(2) 
          '' , -- Country - varchar(32) 
     --   ''	, -- zipcode - varchar(9)	  
          CASE pd.sex WHEN '0' THEN 'U' ELSE pd.sex END , -- Gender - varchar(1)
          CASE pd.maritalstatus WHEN '0' THEN '' ELSE pd.maritalstatus END , -- MaritalStatus - varchar(1) 
          LEFT(pd.hometelephone,10) , -- HomePhone - varchar(10)
          CASE
		  WHEN LEN(pd.hometelephone) > 10 THEN LEFT(SUBSTRING(pd.hometelephone,11,LEN(pd.hometelephone)),10)
		  ELSE NULL END , -- HomePhoneExt - varchar(10)
          LEFT(pd.worktelephone,10) , -- WorkPhone - varchar(10)
          CASE
		  WHEN LEN(pd.worktelephone) > 10 THEN LEFT(SUBSTRING(pd.worktelephone,11,LEN(pd.worktelephone)),10)
		  ELSE NULL END, -- WorkPhoneExt - varchar(10) */
          pd.dob  , -- DOB - datetime
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pd.ssn)) >= 6 THEN RIGHT ('000' + dbo.fn_RemoveNonNumericCharacters(pd.ssn) , 9) 
               ELSE '' END , -- SSN - char(9)
      --  '' , -- EmailAddress - varchar(256) 
          0 , -- ResponsibleDifferentThanPatient - BIT ,
      --  '' , -- ResponsibleFirstName - varchar(64)
      --  '' , -- ResponsibleMiddleName - varchar(64)
      --  '' , -- ResponsibleLastName - varchar(64)  
      /*  '' , -- ResponsibleRelationshipToPatient - varchar(1) 
          '' , -- ResponsibleAddressLine1 - varchar(256)
          '' , -- ResponsibleAddressLine2 - varchar(256)
          '' , -- ResponsibleCity - varchar(128)
          '' , -- ResponsibleState - varchar(2)  
          '' , -- ResponsibleCountry - varchar(32)
          '' , -- ResponsibleZipCode - varchar(9) */
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          'U' , -- EmploymentStatus - char(1)
      --  '' , -- InsuranceProgramCode - char(2)
      --  0  , -- PatientReferralSourceID - int
      --  '' , -- PrimaryProviderID - int
      --  0  , -- DefaultServiceLocationID - int
      --  '' , -- EmployerID - int
          pd.account , -- MedicalRecordNumber - varchar(128)
          LEFT(pd.cellphone,10) ,  -- MobilePhone - varchar(10) 
          CASE
		  WHEN LEN(pd.cellphone) > 10 THEN LEFT(SUBSTRING(pd.cellphone,11,LEN(pd.cellphone)),10)
		  ELSE NULL END , -- MobilePhoneExt - varchar(10)
      --  ''  , -- PrimaryCarePhysicianID - int 
          pd.account , -- VendorID - varchar(. N50)
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
      --  '' , -- LicenseNumber - varchar(64)
      --  '' , -- LicenseState - varchar(2)
      --  '' , -- Language1 - varchar(64)
      --  '' , -- Language2 - varchar(64)
FROM dbo.[_import_1_1_PatDemos] as pd
LEFT JOIN dbo.Doctor as doc on
      doc.vendorid = pd.refphys AND
      doc.vendorimportid = @VendorImportID
WHERE pd.account <>'' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully'

PRINT ''
PRINT 'Inserting into PatientCase'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          ReferringPhysicianID ,
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
          pat.ReferringPhysicianID  , -- ReferringPhysicianID - int  
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
     /*   HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,  */
          HolderSuffix ,
      --  HolderDOB ,
      --  HolderSSN , 
      --  HolderThroughEmployer ,
      --  HolderEmployerName ,
      --  PatientInsuranceStatusID ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     --   RecordTimeStamp ,
      /*  HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState , */
          HolderCountry ,
      /*  HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt , 
          DependentPolicyNumber , */
      --  Notes ,
      --  Phone ,
      --  PhoneExt ,
      --  Fax ,
      --  FaxExt , 
      /*  Copay ,  
          Deductible ,
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
          GroupName 
          ReleaseOfInformation ,
          SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patcase.PatientCaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          pd.subscriberid , -- PolicyNumber - varchar(32)
          pd.primarygroup , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit    
          'S' , -- PatientRelationshipToInsured - varchar(1) 
          '' , -- HolderPrefix - varchar(16)
      /*  '' , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          '' , -- HolderLastName - varchar(64)  */
          '' , -- HolderSuffix - varchar(16)
      --  '' , -- HolderDOB - datetime
      --  '' , -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      --  '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      /*  '' , -- HolderGender - char(1)
          '' , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          '' , -- HolderCity - varchar(128)
          '' , -- HolderState - varchar(2) */
          '' , -- HolderCountry - varchar(32)
      /*  '' , -- HolderZipCode - varchar(9)
          '' , -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10) 
          '' , -- DependentPolicyNumber - varchar(32) */
      --  '' , -- Notes - text 
      --  '' , -- Phone - varchar(10)
      /*  '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10) 
          '' , -- Copay - money  
          NULL , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32) */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16) */
          pd.subscriberid, -- VendorID - varchar(50)  
          @VendorImportID  -- VendorImportID - int
      --  0 , -- InsuranceProgramTypeID - int
      --  ''  -- GroupName - varchar(14)
      /*  '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_1_1_PatDemos] as pd
INNER JOIN dbo.PatientCase AS patcase ON
        patCase.vendorID = pd.account  AND
        patcase.VendorImportID = @vendorimportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = pd.PrimaryIns AND 
		-- inscoplan.PlanName = pd.primaryinsurancecarrier AND
		inscoplan.VendorImportID = @vendorImportID 
WHERE pd.subscriberid <> '' and pd.PrimaryIns <>''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted PrimaryInsurancePolicy '

PRINT ''
PRINT'Inserting records into SecondaryInsurancePolicy'
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
     /*   HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,  */
          HolderSuffix ,
      --  HolderDOB ,
      --  HolderSSN , 
      --  HolderThroughEmployer ,
      --  HolderEmployerName ,
      --  PatientInsuranceStatusID ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     --   RecordTimeStamp ,
      /*  HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState , */
          HolderCountry ,
      /*  HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt , 
          DependentPolicyNumber , */
      --  Notes ,
      --  Phone ,
      --  PhoneExt ,
      --  Fax ,
      --  FaxExt , 
      /*  Copay ,  
          Deductible ,
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
          GroupName 
          ReleaseOfInformation ,
          SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patcase.PatientCaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          pd.secondarysubscriberid , -- PolicyNumber - varchar(32)
          pd.secondarygroup , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit    
          'S' , -- PatientRelationshipToInsured - varchar(1) 
          '' , -- HolderPrefix - varchar(16)
      /*  '' , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          '' , -- HolderLastName - varchar(64)  */
          '' , -- HolderSuffix - varchar(16)
      --  '' , -- HolderDOB - datetime
      --  '' , -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      --  '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      /*  '' , -- HolderGender - char(1)
          '' , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          '' , -- HolderCity - varchar(128)
          '' , -- HolderState - varchar(2) */
          '' , -- HolderCountry - varchar(32)
      /*  '' , -- HolderZipCode - varchar(9)
          '' , -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10) 
          '' , -- DependentPolicyNumber - varchar(32) */
      --  '' , -- Notes - text 
      --  '' , -- Phone - varchar(10)
      /*  '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10) 
          '' , -- Copay - money  
          NULL , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32) */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16) */
          pd.secondarysubscriberid, -- VendorID - varchar(50)  
          @VendorImportID  -- VendorImportID - int
      --  0 , -- InsuranceProgramTypeID - int
      --  ''  -- GroupName - varchar(14)
      /*  '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_1_1_PatDemos] as pd
INNER JOIN dbo.PatientCase AS patcase ON
        patCase.vendorID = pd.account  AND
        patcase.VendorImportID = @vendorimportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = pd.SecondaryIns AND 
		-- inscoplan.PlanName = pd.secondaryinsurancecarrier AND
		inscoplan.VendorImportID = @vendorImportID 
WHERE pd.secondarysubscriberid <> '' AND pd.SecondaryIns<>''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted SecondaryInsurancePolicy '

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

