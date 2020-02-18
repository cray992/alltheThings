USE superbill_29303_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 2
SET @VendorImportID = 1 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
 
-- Clear out any existing records for this import, (makes the script safe to run multiple times)
--PRINT ''
--PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from InsurancePolicy'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Insurance Company Plan'
--DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from Insurance'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCase'
--DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'
--DELETE FROM dbo.Employers WHERE CreatedUserID = -50 AND ModifiedUserID = -50
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Employers'

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
     /*   ContactFirstName ,
          ContactMiddleName ,
          ContactLastName , */
          ContactSuffix ,
          Phone ,
        PhoneExt ,
      /*    Fax ,
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
      --  DefaultAdjustmentCode ,
      --  ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT  DISTINCT
          il.insurancecompany, -- InsuranceCompanyName - varchar(128)
     --   '' , -- Notes - text
          il.insurancestreet1 , -- AddressLine1 - varchar(256)
          il.insurancestreet2 , -- AddressLine2 - varchar(256)
          il.insurancecity , -- City - varchar(128)
          il.insurancestate , -- State - varchar(2) 
          '' , -- Country - varchar(32)
          CASE WHEN LEN(il.insurancezip) = 4 THEN '0' + il.insurancezip ELSE LEFT(il.insurancezip, 9) END  , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
      /*  '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)  */
          '' , -- ContactSuffix - varchar(16)
          LEFT(il.insurancephone,10) , -- Phone - varchar(10)
          CASE WHEN LEN(insurancephone) > 10 THEN LEFT(SUBSTRING(insurancephone,11,LEN(insurancephone)),10) ELSE NULL END , -- PhoneExt - varchar(10)
       /* '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10) */
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
          il.insurancecompany, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  '' , -- DefaultAdjustmentCode - varchar(10)
      --  0 , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_2_InsuranceList] as il
where il.insurancecompany <>''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into insurance company'

PRINT ''
PRINT 'Inserting Into Insurance Company Plan'
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
          Phone ,
      /*  PhoneExt ,
          Notes ,
          MM_CompanyID ,  */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
      --  ReviewCode ,
          CreatedPracticeID ,
      --  Fax ,
      --  FaxExt ,
      --  KareoInsuranceCompanyPlanID ,
      --  KareoLastModifiedDate ,
          InsuranceCompanyID ,
      --  ADS_CompanyID ,
      --  Copay ,
      --  Deductible ,
          VendorID ,
          VendorImportID 
      --  InsuranceCompanyPlanGuid
        )
SELECT  DISTINCT
          InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          '' , -- Country - varchar(32)
          Zipcode , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
     /*   '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)  */
          '' , -- ContactSuffix - varchar(16)   
          '' , -- Phone - varchar(10)
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
      --  '' , -- Fax - varchar(10)
      --  '' , -- FaxExt - varchar(10)
      --  0 , -- KareoInsuranceCompanyPlanID - int
      --  GETDATE() , -- KareoLastModifiedDate - datetime
          InsuranceCompanyID , -- InsuranceCompanyID - int
      --  '' , -- ADS_CompanyID - varchar(10)
      --  NULL , -- Copay - money
      --  NULL , -- Deductible - money
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  NULL  -- InsuranceCompanyPlanGuid - uniqueidentifier
FROM dbo.InsuranceCompany
WHERE VendorImportID=@VendorImportID AND CreatedPracticeID=@PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into InsuranceCompanyplan'


PRINT ''
PRINT 'Insert Into Employer...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT 
		  i.employername , -- EmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.[_import_1_2_PatDemoIns] i
WHERE employername <> '' AND NOT EXISTS (SELECT * FROM dbo.Employers e WHERE i.employername = e.EmployerName)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Employers...'


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
      --  AddressLine2 ,
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
          --ResponsiblePrefix ,
      --  ResponsibleFirstName ,
      --  ResponsibleMiddleName ,
      --  ResponsibleLastName , 
          --ResponsibleSuffix ,
      --  ResponsibleRelationshipToPatient ,
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
     /*   RecordTimeStamp ,
          EmploymentStatus ,
          InsuranceProgramCode ,
          PatientReferralSourceID ,  */
          PrimaryProviderID ,  
        DefaultServiceLocationID ,
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
          pd.first , -- FirstName - varchar(64)
          pd.middle , -- MiddleName - varchar(64)
          pd.last , -- LastName - varchar(64)
          pd.suffix , -- Suffix - varchar(16)
          pd.patientaddress , -- AddressLine1 - varchar(256)
      --  '' , -- AddressLine2 - varchar(256)
          pd.city , -- City - varchar(128)
          pd.state , -- State - varchar(2) 
          '' , -- Country - varchar(32)  
          CASE WHEN LEN(pd.zip) = 4 THEN '0' + pd.zip ELSE LEFT(pd.zip, 9) END , -- ZipCode - varchar(9)
          pd.gender , -- Gender - varchar(1)
          pd.maritalstatus , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.phone,'-','')),10) , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.workphone,'-','')),10) , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
          pd.birthdate , -- DOB - datetime
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ss)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(ss), 9) ELSE NULL END , -- SSN - char(9)
          pd.email , -- EmailAddress - varchar(256)
          0 , --  ResponsibleDifferentThanPatient - BIT 
          --'' , -- ResponsiblePrefix - varchar(16)
      --  '' , -- ResponsibleFirstName - varchar(64)
      --  '' , -- ResponsibleMiddleName - varchar(64)
      --  '' , -- ResponsibleLastName - varchar(64)
          --'' , -- ResponsibleSuffix - varchar(16)
      --  '' , -- ResponsibleRelationshipToPatient - varchar(1)
      --  '' , -- ResponsibleAddressLine1 - varchar(256)
      --  '' , -- ResponsibleAddressLine2 - varchar(256)
      --  '' , -- ResponsibleCity - varchar(128)
      --  '' , -- ResponsibleState - varchar(2)
          --'' , -- ResponsibleCountry - varchar(32)
      --  '' , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- EmploymentStatus - char(1)
      --  '' , -- InsuranceProgramCode - char(2)
      --  0 , -- PatientReferralSourceID - int
           CASE WHEN pd.defaultrenderingproviderid = '' THEN NULL ELSE pd.defaultrenderingproviderid END  , -- PrimaryProviderID - int
           2 , -- DefaultServiceLocationID - int
           e.EmployerID , -- EmployerID - int
          pd.patientid , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.cell,'-','')),10) ,  -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  '' , -- PrimaryCarePhysicianID - int
          pd.patientid, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  0 , -- CollectionCategoryID - int
          pd.active  -- Active - bit
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
FROM dbo.[_import_1_2_PatDemoIns] AS pd
	LEFT JOIN dbo.Employers e ON	
		pd.employername = e.EmployerName
WHERE NOT EXISTS (SELECT * FROM dbo.Patient p WHERE pd.[first] = p.FirstName AND
													pd.[last] = p.LastName AND
													DATEADD(hh,12,CAST(pd.birthdate AS DATETIME)) = p.DOB AND
													p.PracticeID = @PracticeID)
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
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
      --  HolderSSN ,
      /*  HolderThroughEmployer ,
          HolderEmployerName ,
          PatientInsuranceStatusID ,  */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
      --  HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
      /*  HolderPhoneExt ,
          DependentPolicyNumber , */
          Notes ,
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
          inscoplan.InsuranceCompanyPlanID, -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          pd.insuredpolicy1 , -- PolicyNumber - varchar(32)
          pd.insuredgroupno1 , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit
          CASE pd.patrel1 WHEN 'S' THEN 'S'
		                        WHEN 'O' THEN 'O'            
								WHEN '' THEN 'S'
           END, -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN pd.patrel1 <> 'S' THEN
		            pd.insuredfirstname1 END , -- HolderFirstName - varchar(64)
          CASE WHEN pd.patrel1 <> 'S' THEN
		            pd.insuredmiddlename1 END , -- HolderMiddleName - varchar(64)
          CASE WHEN pd.patrel1 <> 'S' THEN
		            pd.insuredlastname1 END , -- HolderLastName - varchar(64)
          CASE WHEN pd.patrel1 <> 'S' THEN
		            pd.insuredsuffix1 END , -- HolderSuffix - varchar(16)
          CASE WHEN pd.patrel1 <> 'S' THEN
		            pd.insured1dob END, -- HolderDOB - datetime
      --  '' , -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      --  '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- HolderGender - char(1)
          CASE WHEN pd.patrel1 <> 'S' THEN
		            pd.insured1addl1 END  , -- HolderAddressLine1 - varchar(256)
          CASE WHEN pd.patrel1 <> 'S' THEN
		            pd.insured1addl2 END, -- HolderAddressLine2 - varchar(256)
          CASE WHEN pd.patrel1 <> 'S' THEN
		            pd.insured1addcity END, -- HolderCity - varchar(128)
          CASE WHEN pd.patrel1 <> 'S' THEN
		            pd.insured1addstate END, -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pd.patrel1 <> 'S' THEN
		            pd.insured1addzip END , -- HolderZipCode - varchar(9)
          CASE WHEN pd.patrel1 <> 'S' THEN
		            LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.insured1addphone,'-','')),10) END , -- HolderPhone - varchar(10)
      --  '' , -- HolderPhoneExt - varchar(10)
      --  '' , -- DependentPolicyNumber - varchar(32)
          pd.insurancenotes1 , -- Notes - text
      --  '' , -- Phone - varchar(10)
      --  '' , -- PhoneExt - varchar(10)
      --  '' , -- Fax - varchar(10)
      --  '' , -- FaxExt - varchar(10)
          pd.Copay1 , -- Copay - money
      --  '' , -- Deductible - money
      --  '' , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)  */
          pd.patientID + '1' , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      /*  0 , -- InsuranceProgramTypeID - int
          '' , -- GroupName - varchar(14)
          '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo._import_1_2_PatDemoIns as pd
INNER JOIN dbo.patientcase as patcase ON
        patcase.VendorID = pd.patientID 
    AND patcase.practiceID = @practiceID 
INNER JOIN dbo.InsuranceCompanyPlan AS inscoplan ON
    inscoplan.VendorID = pd.insuredplanname1 AND
    inscoplan.VendorImportID = @VendorImportID 	
WHERE pd.insuredpolicy1 <>''  -- AND   pd.insuredplanname1 <> ''   
PRINT CAST(@@ROWCOUNT AS VARCHAR ) + ' records inserted into InsurancePolicy primary'

PRINT ''
PRINT 'Inserting Into InsurancePolicy secondary' 
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
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
      --  HolderSSN ,
      /*  HolderThroughEmployer ,
          HolderEmployerName ,
          PatientInsuranceStatusID ,  */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
      --  HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
      /*  HolderPhoneExt ,
          DependentPolicyNumber , */
          Notes ,
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
          2 , -- Precedence - int
          pd.insuredpolicy2 , -- PolicyNumber - varchar(32)
          pd.insuredgroupno2 , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit
          CASE pd.patrel2 WHEN 'S' THEN 'S'
		                        WHEN 'O' THEN 'O'            
								WHEN '' THEN 'S'
           END, -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN pd.patrel2 <> 'S' THEN
		            pd.insuredfirstname2 END , -- HolderFirstName - varchar(64)
          CASE WHEN pd.patrel2 <> 'S' THEN
		            pd.insuredmiddlename2 END , -- HolderMiddleName - varchar(64)
          CASE WHEN pd.patrel2 <> 'S' THEN
		            pd.insuredlastname2 END , -- HolderLastName - varchar(64)
          CASE WHEN pd.patrel2 <> 'S' THEN
		            pd.insuredsuffix2 END , -- HolderSuffix - varchar(16)   ---- WAS insuredsuffix1
          CASE WHEN pd.patrel2 <> 'S' THEN
		            pd.insured2dob END, -- HolderDOB - datetime
      --  '' , -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      --  '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- HolderGender - char(1)
          CASE WHEN pd.patrel2 <> 'S' THEN
		            pd.insured2addl2 END  , -- HolderAddressLine1 - varchar(256)
          CASE WHEN pd.patrel2 <> 'S' THEN
		            pd.insured2addl2 END, -- HolderAddressLine2 - varchar(256)
          CASE WHEN pd.patrel2 <> 'S' THEN
		            pd.insured2addcity END, -- HolderCity - varchar(128)
          CASE WHEN pd.patrel2 <> 'S' THEN
		            pd.insured2addstate END, -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pd.patrel2 <> 'S' THEN
		            pd.insured2addzip END , -- HolderZipCode - varchar(9)
          CASE WHEN pd.patrel2 <> 'S' THEN
		            LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.insured2addphone,'-','')),10) END , -- HolderPhone - varchar(10)
      --  '' , -- HolderPhoneExt - varchar(10)
      --  '' , -- DependentPolicyNumber - varchar(32)
          pd.insurancenotes2 , -- Notes - text
      --  '' , -- Phone - varchar(10)
      --  '' , -- PhoneExt - varchar(10)
      --  '' , -- Fax - varchar(10)
      --  '' , -- FaxExt - varchar(10)
          pd.Copay2 , -- Copay - money
      --  '' , -- Deductible - money
      --  '' , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)  */
          pd.patientID + '2' , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      /*  0 , -- InsuranceProgramTypeID - int
          '' , -- GroupName - varchar(14)
          '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo._import_1_2_PatDemoIns as pd
INNER JOIN dbo.patientcase as patcase ON
        patcase.VendorID = pd.patientID 
    AND patcase.practiceID = @practiceID 
INNER JOIN dbo.InsuranceCompanyPlan AS inscoplan ON
    inscoplan.VendorID = pd.insuredplanname2 AND
    inscoplan.VendorImportID = @VendorImportID
WHERE pd.insuredpolicy2 <>''  --AND pd.insuredplanname2 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR ) + ' records inserted into InsurancePolicy primary'



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
        --PRINT 'COMMITTED SUCCESSFULLY'

