USE superbill_28983_dev
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
 
-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from InsurancePolicy'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Insurance Company Plan'
--DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from Insurance'
--DELETE FROM dbo.PatientCaseDate WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCaseDate'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCase'
--DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientAlert'
--DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'

PRINT ''
PRINT 'Inserting records into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
      /*  Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
          Phone ,
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
      --  DefaultAdjustmentCode ,
      --  ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT  DISTINCT
          mi.insurancecompanyname, -- InsuranceCompanyName - varchar(128)
     /*   '' , -- Notes - text
          '' , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          '' , -- City - varchar(128)
          '' , -- State - varchar(2) 
          '' , -- Country - varchar(32)
          '' , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
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
          mi.insurancecompanyname, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  '' , -- DefaultAdjustmentCode - varchar(10)
      --  0 , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_4_1_mckayinsurances] as mi
where mi.insurancecompanyname <>''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into insurance company'

PRINT ''
PRINT 'Inserting Into Insurance Company Plan'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
      /*  AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,  
          Phone ,
          PhoneExt ,
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
      /*  AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          '' , -- Country - varchar(32)
          Zipcode , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)   
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
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
      --  WorkPhone ,
      --  WorkPhoneExt ,
          DOB ,
      --  SSN ,
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
          mp.firstname , -- FirstName - varchar(64)
          mp.middlename , -- MiddleName - varchar(64)
          mp.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          ma.street1 , -- AddressLine1 - varchar(256)
      --  '' , -- AddressLine2 - varchar(256)
          ma.city , -- City - varchar(128)
          ma.state , -- State - varchar(2) 
          '' , -- Country - varchar(32)  
          CASE WHEN LEN(ma.zipcode) = 4 THEN '0' + ma.zipcode ELSE LEFT(ma.zipcode, 9) END , -- ZipCode - varchar(9)
          CASE mp.sex WHEN 'FEMALE' THEN 'F'
		   			     WHEN 'MALE' THEN 'M'
						 WHEN 'UNKNOWN' THEN 'U'
	            END , -- Gender - varchar(1)
          CASE mp.maritalstatus WHEN 'DIVORCED' THEN 'D'
		   					    WHEN 'MARRIED' THEN 'M'
							    WHEN 'SINGLE' THEN 'S'
							    WHEN 'WIDOWED' THEN 'W'
								WHEN 'DOMESTIC_PARTNER' THEN 'T'
								WHEN 'LIVING_TOGETHER' THEN ''
								WHEN 'UNKNOWN' THEN ''
								WHEN 'UNSPECIFIED' THEN ''
								WHEN 'ALL_OTHER' THEN ''
            END , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(mpn.phonenumber,'-','')),10) , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
      --  '', -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
          mp.dateofbirth , -- DOB - datetime
      --  '' , -- SSN - char(9)
      --  '' , -- EmailAddress - varchar(256)
          0 , --  ResponsibleDifferentThanPatient - BIT 
          '' , -- ResponsiblePrefix - varchar(16)
      --  mi.guarantorfirstname , -- ResponsibleFirstName - varchar(64)
      --  mi.guarantormiddlename , -- ResponsibleMiddleName - varchar(64)
      --  mi.guarantorlastname , -- ResponsibleLastName - varchar(64)
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
          mp.emaid , -- MedicalRecordNumber - varchar(128)
      --  '' ,  -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  '' , -- PrimaryCarePhysicianID - int
          mp.emaid, -- VendorID - varchar(50)
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
      --  '',  -- LicenseNumber - varchar(64)
      --  '' , -- LicenseState - varchar(2)
      --  '' , -- Language1 - varchar(64)
      --  ''  -- Language2 - varchar(64)
FROM dbo.[_import_4_1_mckaypatients] as mp
LEFT JOIN dbo.[_import_4_1_mckayaddresses] as ma ON
        ma.emaid = mp.emaid 
    AND ma.city <>''
LEFT JOIN dbo.[_import_4_1_mckayphonenumbers] as mpn ON
        mpn.emaid = mp.emaid
/*INNER JOIN dbo.[_import_4_1_mckayinsurances] as mi ON
        mi.emaid = mp.emaid 
	AND mi.guarantorfirstname = mp.firstname 
	--AND mi.guarantormiddlename = mp.middlename
	--AND mi.guarantorlastname = mp.lastname */
WHERE mp.firstname <> '' AND mp.middlename <> 'fraxel' AND mp.lastname <> '' 
 --AND NOT EXISTS (SELECT * from dbo.patient as pat where ma.emaid = pat.patientID) 
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
SELECT  DISTINCT
          pat.patientID , -- PatientID - int
          mp.alertsnote , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_4_1_mckaypatients] as mp 
INNER JOIN dbo.Patient as pat on
         pat.VendorID = mp.emaid
     AND pat.PracticeID = @PracticeID
WHERE mp.alertsnote <> ''     
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
          patcase.PatientCaseID , -- PatientCaseID - int
          1 , -- PatientCaseDateTypeID - int
          GETDATE() , -- StartDate - datetime
          mp.datelastvisit , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo._import_4_1_mckaypatients as mp
INNER JOIN dbo.patientcase as patcase ON
        patcase.vendorID = mp.emaid	
where patcase.practiceID = @practiceID and vendorimportid= @vendorimportid
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcaseDate'

PRINT ''
PRINT 'Inserting Into InsurancePolicy ' 


INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
      --  GroupNumber ,
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
        --RecordTimeStamp ,
        HolderGender ,
        HolderAddressLine1 ,
        --HolderAddressLine2 ,
        HolderCity ,
        HolderState ,
  --        HolderCountry ,
        HolderZipCode ,
        HolderPhone ,
          HolderPhoneExt ,
         DependentPolicyNumber , 
  /*        Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,  
          Copay ,
          Deductible ,
          PatientInsuranceNumber , */
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
          mi.insurancerank , -- Precedence - int
          mi.PolicyNumber , -- PolicyNumber - varchar(32)
      --  '' , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit
          CASE mi.patientrelationshiptopolicyholder WHEN 'CHILD' THEN 'C'
		                                         WHEN 'SPOUSE' THEN 'U'
												 WHEN 'SELF' THEN 'S'
												 WHEN 'OTHER' THEN 'O'
		         END, -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN mi.patientrelationshiptopolicyholder <> 'SELF' THEN mi.policyholderfirstname END, -- HolderFirstName - varchar(64)
          CASE WHEN mi.patientrelationshiptopolicyholder <> 'SELF' THEN mi.policyholdermiddlename END, -- HolderMiddleName - varchar(64)
          CASE WHEN mi.patientrelationshiptopolicyholder <> 'SELF' THEN mi.policyholderlastname END, -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN mi.patientrelationshiptopolicyholder <> 'SELF' THEN CASE WHEN ISDATE(mi.policyholderdateofbirth) = 1 THEN mi.policyholderdateofbirth ELSE NULL END END, -- HolderDOB - datetime
      --  '' , -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      --  '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE WHEN mi.patientrelationshiptopolicyholder <> 'SELF' THEN 'U' END, -- HolderGender - char(1)
          CASE WHEN mi.patientrelationshiptopolicyholder <> 'SELF' THEN mi.insuredstreet1 END , -- HolderAddressLine1 - varchar(256)
--          '' , -- HolderAddressLine2 - varchar(256)
          CASE WHEN mi.patientrelationshiptopolicyholder <> 'SELF' THEN LEFT(mi.insuredcity ,128) END , -- HolderCity - varchar(128)
          CASE WHEN mi.patientrelationshiptopolicyholder <> 'SELF' THEN LEFT(mi.insuredstate, 2) END , -- HolderState - varchar(2)  
   --       '' , -- HolderCountry - varchar(32)
          CASE WHEN mi.patientrelationshiptopolicyholder <> 'SELF' THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(mi.insuredzip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(mi.insuredzip) 
																		  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(mi.insuredzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(mi.insuredzip) ELSE '' END END , -- HolderZipCode - varchar(9)
          CASE WHEN mi.patientrelationshiptopolicyholder <> 'SELF' THEN 
														                CASE WHEN LEN(REPLACE(mi.insuredphonenumber,'-',''))>= 10 THEN LEFT(REPLACE(mi.insuredphonenumber,'-',''),10) ELSE '' END END , -- HolderPhone - varchar(10)
          CASE WHEN mi.patientrelationshiptopolicyholder <> 'SELF' THEN 
			CASE WHEN LEN(REPLACE(mi.insuredphonenumber,'-','')) > 10 THEN LEFT(SUBSTRING(REPLACE(mi.insuredphonenumber,'-',''),11,LEN(REPLACE(mi.insuredphonenumber,'-',''))),10) ELSE NULL END END , -- HolderPhoneExt - varchar(10)
         
		 CASE WHEN mi.patientrelationshiptopolicyholder <> 'SELF' THEN mi.policynumber END , -- DependentPolicyNumber - varchar(32)
      --  '' , -- Notes - text
      --  '' , -- Phone - varchar(10)
      --  '' , -- PhoneExt - varchar(10)
      --  '' , -- Fax - varchar(10)
      --  '' , -- FaxExt - varchar(10)
      --  '' , -- Copay - money
      --  '' , -- Deductible - money
      --  '' , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)  */
          mi.emaid + mi.insurancerank , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      /*  0 , -- InsuranceProgramTypeID - int
          '' , -- GroupName - varchar(14)
          '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_4_1_mckayinsurances] as mi
INNER JOIN dbo.patientcase as patcase ON
        patcase.VendorID = mi.emaid 
    AND patcase.practiceID = @practiceID 

INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = mi.insurancecompanyname
		AND inscoplan.VendorImportID = @VendorImportID
WHERE mi.PolicyNumber <>''
--AND mi.guarantorlastname <> 'SCHWARTZ' AND mi.patientrelationshiptopolicyholder <>'SPOUSE'
     
--AND policynumber<> 'AJI888680296431'
--SELECT * from dbo.InsurancePolicy  as ic where ic.holderlastname = mi.policyholderlastname)
--END
PRINT CAST(@@ROWCOUNT AS VARCHAR ) + ' records inserted into InsurancePolicy '

PRINT '' 
PRINT 'updating patient case with PayerScenarioID'
Update dbo.patientcase set PayerScenarioID=11, name='Self Pay' from dbo.patientcase as patcase 
LEFT JOIN dbo.insurancepolicy as ip ON
ip.patientcaseID = patcase.patientcaseID 
where patcase.VendorImportID = @vendorImportID AND
ip.patientcaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated into patient case '

--COMMIT TRANSACTION
        --PRINT 'COMMITTED SUCCESSFULLY'


