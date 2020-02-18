USE superbill_30408_dev
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
DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Doctor'
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
      /*  Phone ,
          PhoneExt ,
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
          inc.payername , -- InsuranceCompanyName - varchar(128)
     --   '' , -- Notes - text
          inc.addressline1 , -- AddressLine1 - varchar(256)
          inc.addressline2 , -- AddressLine2 - varchar(256)
          inc.city , -- City - varchar(128)
          CASE WHEN  inc.state = 'NULL' THEN '' 
		             ELSE inc.state END, -- State - varchar(2) 				 
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(inc.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(inc.zip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(inc.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(inc.zip)
			   ELSE '' END ,  -- ZipCode - varchar(9)  
          '' , -- ContactPrefix - varchar(16)
      /*  '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64) */
          '' , -- ContactSuffix - varchar(16)
      /*  '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
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
          inc.payerid,-- VendorID - varchar(50)  
          @VendorImportID , -- VendorImportID - int
      --  '' , -- DefaultAdjustmentCode - varchar(10)
      --  0 , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM [dbo].[_import_1_1_Insurances] as inc 
WHERE inc.payerid<>'' 
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
      /*  ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,*/
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
     --   ReviewCode ,
          CreatedPracticeID ,
      /*  Fax ,
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
SELECT  DISTINCT
          ic.InsuranceCompanyName , -- PlanName - varchar(128)
          ic.AddressLine1 , -- AddressLine1 - varchar(256)
          ic.AddressLine2 , -- AddressLine2 - varchar(256)
          ic.City , -- City - varchar(128)
          ic.State , -- State - varchar(2)
      --  '' , -- Country - varchar(32)
          ic.zipcode , -- ZipCode - varchar(9)
      /*  '' , -- ContactPrefix - varchar(16)
          '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64) */ 
          '' , -- ContactSuffix - varchar(16)  
      --  '' , -- Phone - varchar(10)  
      --  '' , -- PhoneExt - varchar(10)
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
          ic.vendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int6
      --  NULL  -- InsuranceCompanyPlanGuid - uniqueidentifier
FROM dbo.InsuranceCompany as ic
WHERE VendorImportID=@VendorImportID AND CreatedPracticeID=@PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company plan'

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
          --HomePhone ,
          --HomePhoneExt ,
          WorkPhone ,
   /*       WorkPhoneExt ,
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
     --   RecordTimeStamp ,
     --   UserID ,
          Degree ,  
     /*   DefaultEncounterTemplateID ,
          TaxonomyCode ,
          DepartmentID ,  */
          VendorID ,
          VendorImportID ,
      /*  FaxNumber ,
          FaxNumberExt ,
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
          rp.firstname, -- FirstName - varchar(64)
          rp.middlename , -- MiddleName - varchar(64)
          rp.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
      --  '' , -- SSN - varchar(9)
          rp.refaddress1 , -- AddressLine1 - varchar(256)
          rp.refaddress2 , -- AddressLine2 - varchar(256)
          rp.refcity , -- City - varchar(128)
          rp.refstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(rp.refzip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(rp.refzip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(rp.refzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(rp.refzip)
			   ELSE '' END , -- zipcode - varchar(9)	
    --      LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rp.refphone,'-','')),10)  , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rp.refphone,'-','')),10)  , -- WorkPhone - varchar(10)
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
          rp.degree , -- Degree - varchar(8) 
      /*  0 , -- DefaultEncounterTemplateID - int
          '' , -- TaxonomyCode - char(10)
          0 , -- DepartmentID - int    */
          rp.vendorID, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  '' , -- FaxNumber - varchar(10)
      --  '' , -- FaxNumberExt - varchar(10)
      --  '', -- OrigReferringPhysicianID - int 
          1 ,  -- External - bit
          rp.refnpi -- NPI - varchar(10)
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
FROM [dbo].[_import_1_1_ReferringProviders] as rp
WHERE rp.vendorID <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Doctors'

PRINT ''
PRINT 'Updating ReferringPhysicianID for Patients...'
UPDATE dbo.Patient SET ReferringPhysicianID = rp.DoctorID
FROM dbo.[_import_1_1_PatientCase] i
INNER JOIN dbo.patient as pat ON 
    pat.firstname = i.patientfirst AND
	pat.lastname = i.patientlast AND
	pat.dob = DATEADD(hh,12,CAST(i.patientdob AS DATETIME))
INNER JOIN dbo.Doctor rp ON
	i.refname = rp.VendorID AND
	rp.VendorImportID = @VendorImportID
WHERE pat.ReferringPhysicianID IS NULL 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


PRINT ''
PRINT 'Inserting into PatientCase'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          --ReferringPhysicianID ,
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
          --doc.doctorID , -- ReferringPhysicianID - int
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
          pc.patientfirst+pc.patientlast+pc.patientdob , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  NULL , -- PregnancyRelatedFlag - bit
      --  NULL , -- StatementActive - bit
      --  NULL , -- EPSDT - bit
      --  NULL , -- FamilyPlanning - bit
      --  0 , -- EPSDTCodeID - int
      --  NULL , -- EmergencyRelated - bit
      --  NULL  -- HomeboundRelatedFlag - bit
FROM [dbo].[_import_1_1_PatientCase] as pc
INNER JOIN dbo.patient as pat ON 
    pat.firstname = pc.patientfirst AND
	pat.lastname = pc.patientlast AND
	pat.dob = DATEADD(hh,12,CAST(pc.patientdob AS DATETIME))
--where pc.patientlast <>'' and pat.lastname<>''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase'

PRINT ''
PRINT'Inserting records into InsurancePolicy'
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
      /*  HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,  */
          HolderSuffix ,
      --  HolderDOB ,
       -- HolderSSN , 
      --  HolderThroughEmployer ,
      --  HolderEmployerName ,
      --  PatientInsuranceStatusID ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     --   RecordTimeStamp ,
     --   HolderGender ,
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
          FaxExt , 
          Copay ,  */
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
          VendorImportID ,
     --   InsuranceProgramTypeID ,
          GroupName 
      /*  ReleaseOfInformation ,
          SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patcase.PatientCaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          pc.precedence , -- Precedence - int
          pc.Policynbr , -- PolicyNumber - varchar(32)
          pc.Groupnbr , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit    
         'S' , -- PatientRelationshipToInsured - varchar(1) 
         '' , -- HolderPrefix - varchar(16)
      /* ''  , -- HolderFirstName - varchar(64)
         '' , -- HolderMiddleName - varchar(64)
         '' , -- HolderLastName - varchar(64)*/
         '' , -- HolderSuffix - varchar(16)
     /*  '' , -- HolderDOB - datetime
         '' , -- HolderSSN - char(11)*/
      --  NULL , -- HolderThroughEmployer - bit
      -- '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- HolderGender - char(1)
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
          '' , -- FaxExt - varchar(10) 
          '' , -- Copay - money  */
       /* NULL , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32) */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16) */
          pc.Policynbr, -- VendorID - varchar(50)  
          @VendorImportID , -- VendorImportID - int
      --  0 , -- InsuranceProgramTypeID - int
          left(pc.groupname,14)  -- GroupName - varchar(14)
      /*  '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_1_1_PatientCase] as pc
INNER JOIN dbo.PatientCase AS patcase ON
        patCase.vendorID = pc.patientfirst+pc.patientlast+pc.patientdob  AND
        patcase.VendorImportID = @vendorimportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = pc.payerID AND 
		inscoplan.VendorImportID = @vendorImportID 
WHERE pc.Policynbr <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Insurance Policy'


--ROLLBACK
--COMMIT TRANSACTION

