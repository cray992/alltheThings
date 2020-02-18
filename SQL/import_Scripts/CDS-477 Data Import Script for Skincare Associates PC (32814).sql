USE superbill_32814_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 5 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

/*
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
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientJournalNotes'
DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'
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
      --  ReviewCode ,  
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
          il.InsuranceCompanyName , -- InsuranceCompanyName - varchar(128)
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
     --   '' , -- ReviewCode - char(1)  
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
          il.insurancecode , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      /*  '' , -- DefaultAdjustmentCode - varchar(10)
          0 , -- ReferringProviderNumberTypeID - int   */
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM  [dbo].[_import_1_1_InsuranceList] as il
WHERE il.insurancecompanyname<>''  
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
     --     ReviewCode ,
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
      --  'R' , -- ReviewCode - char(1)   ***************************
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
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
      --  ResponsibleMiddleName ,
          ResponsibleLastName , 
          ResponsibleSuffix ,
          ResponsibleRelationshipToPatient ,
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
          PatientReferralSourceID ,  
          PrimaryProviderID ,  
          DefaultServiceLocationID ,
          EmployerID ,*/
          MedicalRecordNumber ,
          MobilePhone ,
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
          @PracticeID, -- PracticeID - int
      --  doc.DoctorID , -- ReferringPhysicianID - int
          pd.prefix , -- Prefix - varchar(16)
          pd.firstname , -- FirstName - varchar(64)
          pd.middlename , -- MiddleName - varchar(64)
          pd.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pd.street1 , -- AddressLine1 - varchar(256)
          CASE WHEN pd.street2 = '0' THEN '' ELSE pd.street2 END , -- AddressLine2 - varchar(256)
          pd.city , -- City - varchar(128)
          pd.state , -- State - varchar(2) 
          '' , -- Country - varchar(32)  
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pd.zip)) IN (4,6) THEN '0' + dbo.fn_RemoveNonNumericCharacters(pd.zip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pd.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(pd.zip)
			   ELSE '' END , -- ZipCode - varchar(9) ****************
          CASE WHEN pd.sex ='FEMALE' THEN 'F'
               WHEN pd.sex ='MALE' THEN 'M'  
              ELSE 'U' END , -- Gender - varchar(1)
          CASE WHEN pd.maritalstatus='MARRIED' THEN 'M'
		       WHEN pd.maritalstatus='SINGLE' THEN 'S'
			   WHEN pd.maritalstatus='UNSPECIFIED' THEN ''
			   WHEN pd.maritalstatus='ALL_OTHER' THEN 'M'
			   WHEN pd.maritalstatus='DIVORCED' THEN 'D'
			   WHEN pd.maritalstatus='SEPARATED' THEN 'L'
			   WHEN pd.maritalstatus='UNKNOWN' THEN ''
			   WHEN pd.maritalstatus='WIDOWED' THEN 'W' END , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.homephone,'-','')),10) , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.workphone,'-','')),10) , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
          pd.dateofbirth , -- DOB - datetime
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pd.ssn)) >= 6 THEN RIGHT ('000' + dbo.fn_RemoveNonNumericCharacters(pd.ssn) , 9) -- **************
               ELSE '' END , -- SSN - char(9)
          pd.email , -- EmailAddress - varchar(256)
          CASE WHEN iip.patientrelationshiptoguarantor <> 'SELF' THEN 1 ELSE 0 END	 , -- ResponsibleDifferentThanPatient - BIT  ***********
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN iip.patientrelationshiptoguarantor<>'SELF' THEN iip.guarantorfirstname END , -- ResponsibleFirstName - varchar(64)
     --   '' , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN iip.patientrelationshiptoguarantor<>'SELF' THEN iip.guarantorlastname END , -- ResponsibleLastName - varchar(64)  
          '' , -- ResponsibleSuffix - varchar(16)
          CASE WHEN iip.patientrelationshiptoguarantor='OTHER' THEN 'O' 
               WHEN iip.patientrelationshiptoguarantor='SPOUSE' THEN 'U'      
			   WHEN iip.patientrelationshiptoguarantor='CHILD' THEN 'C' ELSE 'S' END , -- ResponsibleRelationshipToPatient - varchar(1)
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
      /*  NULL , -- RecordTimeStamp - timestamp
          '' , -- EmploymentStatus - char(1)
          '' , -- InsuranceProgramCode - char(2)
          0 , -- PatientReferralSourceID - int
          12, -- PrimaryProviderID - int
          '' , -- DefaultServiceLocationID - int
          '' , -- EmployerID - int   */
          pd.mrn, -- MedicalRecordNumber - varchar(128)  
          pd.cellphone,  -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  12 , -- PrimaryCarePhysicianID - int
          pd.emaid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      /*  0 , -- CollectionCategoryID - int
          ''  -- Active - bit
          NULL , -- SendEmailCorrespondence - bit
          NULL , -- PhonecallRemindersEnabled - bit
          '' , -- EmergencyName - varchar(128)
          '' , -- EmergencyPhone - varchar(10)
          '' , -- EmergencyPhoneExt - varchar(10)
          NULL , -- PatientGuid - uniqueidentifier
          '' , -- Ethnicity - varchar(64)
          '' , -- Race - varchar(64)
          '',  -- LicenseNumber - varchar(64)
          '' , -- LicenseState - varchar(2)
          '' , -- Language1 - varchar(64)
          ''  -- Language2 - varchar(64)   */
FROM dbo.[_import_1_1_PatientDemos] as pd
LEFT JOIN dbo.[_import_1_1_InsurancesPolicies] AS iip ON  
     iip.emaid = pd.emaid AND
     iip.newrank = 1
where pd.mrn <>'' --AND mrn<>'23394' AND mrn<>'23262' AND NOT EXISTS(SELECT * FROM dbo.Patient as pat WHERE pat.MedicalRecordNumber=pd.mrn)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully'


PRINT ''
PRINT 'Inserting Into PatientJournalNote'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  timestamp ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
          Hidden ,
          NoteMessage 
      --  AccountStatus ,
      --  NoteTypeCode ,
      --  LastNote
        )
SELECT 
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- timestamp - timestamp
          pat.PatientID , -- PatientID - int
          '' , -- UserName - varchar(128) 
          'K' , -- SoftwareApplicationID - char(1)
           0 , -- Hidden - bit
          'ID: ' + pd.emaid + CASE WHEN pd.patientnote = '' THEN '' ELSE CHAR(13) + CHAR(10) + 'Note: ' + pd.patientnote END  -- NoteMessage - varchar(max)  
      --  NULL , -- AccountStatus - bit
      --  0 , -- NoteTypeCode - int
      --  NULL  -- LastNote - bit
FROM dbo.[_import_1_1_PatientDemos] as pd
INNER JOIN dbo.Patient as pat on
        pat.VendorID =  pd.emaid AND
        pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR ) + ' records inserted into PatientJournalNote'

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
     --   Notes ,
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
          PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128) **********
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
      --  0 , -- ReferringPhysicianID - int
      --  NULL , -- EmploymentRelatedFlag - bit
      --  NULL , -- AutoAccidentRelatedFlag - bit
      --  NULL , -- OtherAccidentRelatedFlag - bit
      --  NULL , -- AbuseRelatedFlag - bit
      --  '' , -- AutoAccidentRelatedState - char(2)
      --  '' , -- Notes - text
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
FROM dbo.Patient 
WHERE VendorImportID=@VendorImportID AND
      PracticeID=@PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase'

PRINT''
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
          pd.datelastvisit , -- StartDate - datetime  
          NULL , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_1_PatientDemos] as pd
INNER JOIN dbo.patientcase as patcase ON
        patcase.vendorID = pd.emaid AND
        patcase.VendorImportID = @VendorImportID
where pd.datelastvisit <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into patientcaseDate'


PRINT ''
PRINT'Inserting records into InsurancePolicy'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
     -- /*  PolicyStartDate ,
     --     PolicyEndDate ,
     --     CardOnFile ,   */
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
     --   HolderPhone ,
     --   HolderPhoneExt ,
          DependentPolicyNumber ,
     --   Notes ,
          Phone ,
   /*     PhoneExt ,
          Fax ,
          FaxExt ,
          Copay ,
          Deductible ,
          PatientInsuranceNumber ,  */
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
          insCoPlan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          pol.newrank , -- Precedence - int
          pol.policynumber , -- PolicyNumber - varchar(32)
          pol.groupnumber , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit    
          CASE WHEN pol.patientrelationshiptopolicyholder = 'CHILD' THEN 'C'
		       WHEN pol.patientrelationshiptopolicyholder = 'SPOUSE' THEN 'U'
			   WHEN	pol.patientrelationshiptopolicyholder = 'SELF' THEN 'S' ELSE 'S'  END, -- PatientRelationshipToInsured - varchar(1) 
         '' , -- HolderPrefix - varchar(16)
         CASE WHEN pol.patientrelationshiptopolicyholder <> 'SELF' THEN pol.policyholderfirstname END  , -- HolderFirstName - varchar(64)
         CASE WHEN pol.patientrelationshiptopolicyholder <> 'SELF' THEN pol.policyholdermiddlename END , -- HolderMiddleName - varchar(64)
         CASE WHEN pol.patientrelationshiptopolicyholder <> 'SELF' THEN pol.policyholderlastname END , -- HolderLastName - varchar(64)
         '' , -- HolderSuffix - varchar(16)
         CASE WHEN pol.patientrelationshiptopolicyholder <> 'SELF' THEN pol.policyholderdateofbirth END , -- HolderDOB - datetime
         CASE WHEN pol.patientrelationshiptopolicyholder <> 'SELF' THEN 
		 CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pol.policyholderssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(pol.policyholderssn), 9) ELSE '' END END, -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      --  '' , -- HolderEmployerName - varchar(128)
      --   0 , -- PatientInsuranceStatusID - int  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE WHEN pol.patientrelationshiptopolicyholder <> 'SELF' THEN 
		   CASE pol.policyholdersex WHEN 'FEMALE' THEN 'F'
									WHEN 'MALE' THEN 'M' ELSE 'U' END END , -- HolderGender - char(1)
          CASE WHEN pol.patientrelationshiptopolicyholder <> 'SELF' THEN pol.policystreet1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN pol.patientrelationshiptopolicyholder <> 'SELF' THEN pol.policystreet2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pol.patientrelationshiptopolicyholder <> 'SELF' THEN pol.policycity END , -- HolderCity - varchar(128)
          CASE WHEN pol.patientrelationshiptopolicyholder <> 'SELF' THEN pol.policystate END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pol.patientrelationshiptopolicyholder <> 'SELF' THEN
		   CASE WHEN LEN(REPLACE(pol.policyzipcode,'-','')) IN (4,8) THEN '0' + REPLACE(pol.policyzipcode,'-','')
				WHEN LEN(REPLACE(pol.policyzipcode,'-','')) IN (5,9) THEN REPLACE(pol.policyzipcode,'-','') ELSE '' END END , -- HolderZipCode - varchar(9)
       /*   CASE WHEN pol.patientrelationshiptopolicyholder <> 'SELF' THEN 
	  	  LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pol.policyphonenumber,' ','')),10) END, -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10)*/
          CASE WHEN pol.patientrelationshiptopolicyholder <> 'SELF' THEN pol.policynumber END  , -- DependentPolicyNumber - varchar(32) 
     --     '' , -- Notes - text 
		  LEFT(dbo.fn_RemoveNonNumericCharacters(pol.policyphonenumber),10)  , -- Phone - varchar(10)
     /*     '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)
          NULL , -- Copay - money
          NULL , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32) */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16) */
          pol.emaid + pol.newrank , -- VendorID - varchar(50)  
          @VendorImportID  -- VendorImportID - int
      /*  0 , -- InsuranceProgramTypeID - int
          '' , -- GroupName - varchar(14)
          '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_1_1_InsurancesPolicies] as pol
INNER JOIN dbo.PatientCase AS patCase ON 
    patCase.VendorID = pol.emaid  AND
	patcase.vendorimportID = @vendorimportID 
INNER JOIN dbo.InsuranceCompanyPlan AS insCoPlan ON
	insCoPlan.VendorID = pol.insurancecode AND
    insCoPlan.VendorImportID = @VendorImportID
WHERE pol.policynumber <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Insurance Policy'

PRINT '' 
PRINT 'updating patient case with PayerScenarioID'
Update dbo.patientcase set PayerScenarioID=11, name='Self Pay' from dbo.patientcase as patcase 
LEFT JOIN dbo.insurancepolicy as ip ON
ip.patientcaseID = patcase.patientcaseID 
where patcase.VendorImportID = @vendorImportID AND
ip.patientcaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records updated into patient case '


--ROLLBACK
--COMMIT TRANSACTION
--PRINT 'COMMITTED SUCCESSFULLY'




