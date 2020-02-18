USE superbill_30681_dev
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
--DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from Patient'

PRINT ''
PRINT 'Deleting "PRIVATE PAY/NO INSURANCE" from import insurance list...'
DELETE FROM _import_1_1_insurancelist WHERE name = 'PRIVATE PAY/NO INSURANCE'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from Patient'


PRINT ''
PRINT 'Inserting records into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( 
		  InsuranceCompanyName ,
     --   Notes ,
          AddressLine1 ,
     --   AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactPrefix ,
     /*   ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,  */
          ContactSuffix ,
          Phone ,
     --   PhoneExt ,
          Fax ,
     --   FaxExt , 
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
     /*   LocalUseFieldTypeCode ,
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
     /*   KareoInsuranceCompanyID ,
          KareoLastModifiedDate ,
          RecordTimeStamp ,  */
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
     --   DefaultAdjustmentCode ,
     --   ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
          il.name , -- InsuranceCompanyName - varchar(128)
      --  '' , -- Notes - text
          il.address , -- AddressLine1 - varchar(256)
      --  '' , -- AddressLine2 - varchar(256)
          il.city , -- City - varchar(128)
          il.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(il.zip) = 4 THEN '0' + il.zip ELSE LEFT(il.zip, 9) END ,  -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
     /*   '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)  */
          '' , -- ContactSuffix - varchar(16)
          il.InsurancePhone , -- Phone - varchar(10)
      --  '' , -- PhoneExt - varchar(10)
          il.InsuranceFax , -- Fax - varchar(10)
      --  '' , -- FaxExt - varchar(10)  */
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
          il.id, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  '' , -- DefaultAdjustmentCode - varchar(10)
      --  0 , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceList] as il
WHERE ID <>'' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company'



PRINT ''
PRINT 'Inserting records into InsuranceCompanyPlan'
INSERT INTO dbo.InsuranceCompanyPlan
        (
   		  PlanName ,
          AddressLine1 ,
      --  AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
      /*  ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,   */
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
          Fax ,
     /*   FaxExt ,
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
          ic.City , -- City - varchar(128)
          ic.State , -- State - varchar(2)
          ic.Country , -- Country - varchar(32)
          ic.zipcode , -- ZipCode - varchar(9)
     /*   '' , -- ContactPrefix - varchar(16)
          '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)   */
          ic.Phone , -- Phone - varchar(10)
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
          ic.Fax , -- Fax - varchar(10)
      --  '' , -- FaxExt - varchar(10)
      --  0 , -- KareoInsuranceCompanyPlanID - int
      --  GETDATE() , -- KareoLastModifiedDate - datetime  */
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
      /*  '' , -- ADS_CompanyID - varchar(10)
          NULL , -- Copay - money
          NULL , -- Deductible - money   */
          ic.vendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  NULL  -- InsuranceCompanyPlanGuid - uniqueidentifier
FROM dbo.InsuranceCompany as ic
WHERE VendorImportID=@VendorImportID AND 
      CreatedPracticeID=@PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance CompanyPlan'

PRINT ''
PRINT 'Inserting records into patient'
INSERT INTO dbo.Patient
        ( 
		  PracticeID ,
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
      /*  HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,    */
          DOB ,
      /*  SSN ,
          EmailAddress ,   */
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName ,  
          ResponsibleSuffix ,
          ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
     --   ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,    
          ResponsibleCountry ,
          ResponsibleZipCode ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     --   RecordTimeStamp ,
          EmploymentStatus ,
     /*   InsuranceProgramCode ,
          PatientReferralSourceID ,  
          PrimaryProviderID ,  
          DefaultServiceLocationID ,
          EmployerID ,   */
          MedicalRecordNumber ,
      /*  MobilePhone ,
          MobilePhoneExt ,
          PrimaryCarePhysicianID ,   */
          VendorID ,
          VendorImportID 
      /*  CollectionCategoryID ,
          Active 
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone ,
          EmergencyPhoneExt ,
          PatientGuid ,
          Ethnicity ,
          Race ,
          LicenseNumber 
          LicenseState ,
          Language1 ,
          Language2       */
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
      --  '' , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          pd.firstname , -- FirstName - varchar(64)
          pd.middleinit , -- MiddleName - varchar(64)
          pd.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pd.Address , -- AddressLine1 - varchar(256)
      --  '' , -- AddressLine2 - varchar(256)
          pd.city , -- City - varchar(128)
          pd.state , -- State - varchar(2) 
          '' , -- Country - varchar(32)  
		  LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.zip,'-','')),9) , -- ZipCode - varchar(9)
          pd.sex , -- Gender - varchar(1)
          CASE pd.maritalstatus WHEN 'O' THEN '' ELSE pd.maritalstatus END , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.homephone,'-','')),10) , -- HomePhone - varchar(10)
     /*   '' , -- HomePhoneExt - varchar(10)
          '' , -- WorkPhone - varchar(10)
          '' , -- WorkPhoneExt - varchar(10)   */
          CASE WHEN pd.dateofbirth='9/04/660' THEN '' 
               ELSE pd.dateofbirth END , -- DOB - datetime
     --   '' , -- SSN - char(9)
     --   '' , -- EmailAddress - varchar(256)
          CASE WHEN pd.Guarantor <> '' THEN 1 ELSE 0 END , --  ResponsibleDifferentThanPatient - BIT 
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN pd.Guarantor <> '' THEN irp.InsuredsFirstName ELSE '' END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN pd.Guarantor <> '' THEN irp.InsuredsMiddleInit ELSE '' END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN pd.Guarantor <> '' THEN irp.InsuredsLastName ELSE '' END , -- ResponsibleLastName - varchar(64)
          '' , -- ResponsibleSuffix - varchar(16)
          CASE WHEN pd.Guarantor <> '' THEN 'O' ELSE 'S' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN pd.Guarantor <> '' THEN irp.InsuredsAddress ELSE '' END , -- ResponsibleAddressLine1 - varchar(256)
     --   '' , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN pd.Guarantor <> '' THEN irp.InsuredCity ELSE '' END , -- ResponsibleCity - varchar(128)
          CASE WHEN pd.Guarantor <> '' THEN 
		     CASE WHEN irp.insuredstate='NaN' THEN '' ELSE
			  irp.insuredstate END ELSE '' END , -- ResponsibleState - varchar(2) 
          '' , -- ResponsibleCountry - varchar(32)
          CASE WHEN pd.Guarantor <> '' THEN irp.InsuredsZip ELSE '' END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          pd.EmploymentStatus , -- EmploymentStatus - char(1)
      /*  '' , -- InsuranceProgramCode - char(2)
          0 , -- PatientReferralSourceID - int
          '', -- PrimaryProviderID - int
          '' , -- DefaultServiceLocationID - int
          '' , -- EmployerID - int     */
          pd.MedicalRecordNumber , -- MedicalRecordNumber - varchar(128)
      /*  '' ,  -- MobilePhone - varchar(10)
          '' , -- MobilePhoneExt - varchar(10)
          '' , -- PrimaryCarePhysicianID - int    */
          pd.medicalrecordnumber, -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      /*  0 , -- CollectionCategoryID - int
          '' ,  -- Active - bit
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
          ''  -- Language2 - varchar(64)       */
FROM dbo.[_import_1_1_PatientDemo] as pd
LEFT JOIN dbo.[_import_1_1_InsuredandResponsibleParty] AS irp ON
   irp.InsuredNumber = pd.Guarantor 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Recodrs inserted into patient Successfully'

	
PRINT ''
PRINT 'Inserting into PatientCase'
INSERT INTO dbo.PatientCase
        (  
		  PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
     /*   ReferringPhysicianID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          AutoAccidentRelatedState ,   */
          Notes ,
     --   ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
     /*   CaseNumber ,
          WorkersCompContactInfoID ,   */
          VendorID ,
          VendorImportID 
     /*   PregnancyRelatedFlag ,
          StatementActive ,
          EPSDT ,
          FamilyPlanning ,
          EPSDTCodeID ,
          EmergencyRelated ,
          HomeboundRelatedFlag  */
        )
SELECT DISTINCT
          pat.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
      /*  0 , -- ReferringPhysicianID - int
          NULL , -- EmploymentRelatedFlag - bit
          NULL , -- AutoAccidentRelatedFlag - bit
          NULL , -- OtherAccidentRelatedFlag - bit
          NULL , -- AbuseRelatedFlag - bit
          '' , -- AutoAccidentRelatedState - char(2)    */
          'Created via data import, please review' , -- Notes - text
      --  NULL , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
      /*  '' , -- CaseNumber - varchar(128)
          0 , -- WorkersCompContactInfoID - int   */
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      /*  NULL , -- PregnancyRelatedFlag - bit
          NULL , -- StatementActive - bit
          NULL , -- EPSDT - bit
          NULL , -- FamilyPlanning - bit
          0 , -- EPSDTCodeID - int
          NULL , -- EmergencyRelated - bit
          NULL  -- HomeboundRelatedFlag - bit   */
FROM dbo.Patient as pat
WHERE pat.VendorImportID=@VendorImportID AND 
      pat.PracticeID=@PracticeID
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
SELECT
          @PracticeID , -- PracticeID - int
          patcase.PatientCaseID , -- PatientCaseID - int
          8 , -- PatientCaseDateTypeID - int
          GETDATE() , -- StartDate - datetime
          pd.DateLastSeen , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.PatientCase AS patcase        
INNER JOIN dbo.[_import_1_1_PatientDemo] as pd ON
      pd.medicalrecordnumber = patcase.VendorID AND
	  patcase.VendorImportID = @VendorImportID
WHERE pd.datelastseen <>''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into PatientCaseDate'
		
PRINT ''
PRINT 'Inserting into InsurancePolicy Primary'
INSERT INTO dbo.InsurancePolicy
        ( 
		  PatientCaseID ,
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
      /*  HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
          PatientInsuranceStatusID ,  */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     --   RecordTimeStamp ,
          HolderGender ,
          HolderAddressLine1 ,
      --  HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
      --  HolderPhoneExt ,
          DependentPolicyNumber ,
          --Notes ,
          --Phone ,
          --PhoneExt ,
          --Fax ,
          --FaxExt ,
          Copay ,
          --Deductible ,
          --PatientInsuranceNumber ,  
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
          InsurancePolicyGuid ,
          MedicareFormularyID  */
        )
SELECT DISTINCT 
          patcase.patientcaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          CASE WHEN pd.primaryinsuredrelationship = 'S' THEN pd.primaryinsuredsidno 
		       WHEN pd.primaryinsuredrelationship <> 'S' THEN irp.insuredsidno END , -- PolicyNumber - varchar(32)
          CASE WHEN pd.primaryinsuredrelationship = 'S' THEN '' 
		        WHEN pd.primaryinsuredrelationship <> 'S' THEN irp.Groupnumber END , -- GroupNumber - varchar(32)
      /*  GETDATE() , -- PolicyStartDate - datetime
          GETDATE() , -- PolicyEndDate - datetime
          NULL , -- CardOnFile - bit    */
          CASE WHEN pd.PrimaryInsuredRelationship = 'P' THEN 'C'
		       WHEN pd.PrimaryInsuredRelationship = '' THEN 'O'    ELSE 
		            pd.PrimaryInsuredRelationship END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN pd.PrimaryInsuredRelationship <> 'S' THEN irp.InsuredsFirstName END , -- HolderFirstName - varchar(64)
          CASE WHEN pd.PrimaryInsuredRelationship <> 'S' THEN irp.InsuredsMiddleInit END , -- HolderMiddleName - varchar(64)
          CASE WHEN pd.PrimaryInsuredRelationship <> 'S' THEN irp.InsuredsLastName END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN pd.PrimaryInsuredRelationship <> 'S' THEN irp.DateofBirth END , -- HolderDOB - datetime
      /*  '' , -- HolderSSN - char(11)
          NULL , -- HolderThroughEmployer - bit
          '' , -- HolderEmployerName - varchar(128)
          0 , -- PatientInsuranceStatusID - int  */
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
     --   NULL , -- RecordTimeStamp - timestamp
          CASE WHEN pd.PrimaryInsuredRelationship <> 'S' THEN irp.sex END , -- HolderGender - char(1)
          CASE WHEN pd.PrimaryInsuredRelationship <> 'S' THEN irp.insuredsaddress END , -- HolderAddressLine1 - varchar(256)
      --    '' , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pd.PrimaryInsuredRelationship <> 'S' THEN insuredcity END , -- HolderCity - varchar(128)
          CASE WHEN pd.PrimaryInsuredRelationship <> 'S' THEN insuredstate end , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pd.PrimaryInsuredRelationship <> 'S' THEN insuredszip END , -- HolderZipCode - varchar(9)
          CASE WHEN pd.PrimaryInsuredRelationship <> 'S' THEN insuredphone END , -- HolderPhone - varchar(10)
      --  '' , -- HolderPhoneExt - varchar(10)
          CASE WHEN pd.primaryinsuredrelationship <> 'S' THEN irp.insuredsidno END , -- DependentPolicyNumber - varchar(32)
        --'' , -- Notes - text
        --  '' , -- Phone - varchar(10)
        --  '' , -- PhoneExt - varchar(10)
        --  '' , -- Fax - varchar(10)
        --  '' , -- FaxExt - varchar(10)
          pd.primarycopay , -- Copay - money
          --NULL , -- Deductible - money
          --'' , -- PatientInsuranceNumber - varchar(32)  
          1 , -- Active - bit
          @practiceID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)  */
          MedicalRecordNumber + '1' , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      /*   0 , -- InsuranceProgramTypeID - int
          '' , -- GroupName - varchar(14)
          '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL , -- InsurancePolicyGuid - uniqueidentifier
          0  -- MedicareFormularyID - int */
FROM dbo.[_import_1_1_PatientDemo] as pd
INNER JOIN dbo.insuranceCompanyplan as inscoplan ON
        inscoplan.vendorID = pd.PrimaryInsuranceCompany AND
		inscoplan.vendorimportID = @vendorimportID      
INNER JOIN dbo.patientcase as patcase ON
        patcase.VendorID = pd.medicalrecordnumber AND
        patcase.vendorimportID = @vendorimportID      
LEFT JOIN dbo.[_import_1_1_InsuredandResponsibleParty] AS irp ON
        irp.InsuredNumber = pd.primaryinsured 
WHERE pd.primaryinsuredsidno <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurancepolicy primary'


PRINT ''
PRINT 'Inserting into InsurancePolicy Secondary'
INSERT INTO dbo.InsurancePolicy
        ( 
		  PatientCaseID ,
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
      /*  HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
          PatientInsuranceStatusID ,  */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     --   RecordTimeStamp ,
          HolderGender ,
          HolderAddressLine1 ,
     --   HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
     --  HolderPhoneExt ,
          DependentPolicyNumber ,
     /*     Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,
          Copay ,
          Deductible ,
          PatientInsuranceNumber ,  */
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
          InsurancePolicyGuid ,
          MedicareFormularyID  */
        )
SELECT DISTINCT 
          patcase.patientcaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          CASE WHEN pd.secondaryinsuredrelationship = 'S' THEN pd.secondaryinsuredidno 
		       WHEN pd.secondaryinsuredrelationship  <> 'S' THEN irp.insuredsidno END ,-- PolicyNumber - varchar(32)
          CASE WHEN pd.secondaryinsuredrelationship = 'S' THEN '' 
		        WHEN pd.secondaryinsuredrelationship <> 'S' THEN irp.Groupnumber END , -- GroupNumber - varchar(32)
      /*  GETDATE() , -- PolicyStartDate - datetime
          GETDATE() , -- PolicyEndDate - datetime
          NULL , -- CardOnFile - bit    */
          CASE WHEN pd.SecondaryInsuredRelationship = 'P' THEN 'O'
		       WHEN pd.SecondaryInsuredRelationship = '' THEN 'O' ELSE 
		            pd.SecondaryInsuredRelationship END , -- PatientRelationshipToInsured - varchar(1)
		  '' , -- HolderPrefix - varchar(16)
          CASE WHEN pd.SecondaryInsuredRelationship <> 'S' THEN irp.InsuredsFirstName END , -- HolderFirstName - varchar(64)
          CASE WHEN pd.SecondaryInsuredRelationship <> 'S' THEN irp.InsuredsMiddleInit END , -- HolderMiddleName - varchar(64)
          CASE WHEN pd.SecondaryInsuredRelationship <> 'S' THEN irp.InsuredsLastName END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN pd.SecondaryInsuredRelationship <> 'S' THEN irp.DateofBirth END , -- HolderDOB - datetime
      /*  '' , -- HolderSSN - char(11)
          NULL , -- HolderThroughEmployer - bit
          '' , -- HolderEmployerName - varchar(128)
          0 , -- PatientInsuranceStatusID - int  */
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
     --   NULL , -- RecordTimeStamp - timestamp
          CASE WHEN pd.SecondaryInsuredRelationship <> 'S' THEN irp.sex END , -- HolderGender - char(1)
          CASE WHEN pd.SecondaryInsuredRelationship <> 'S' THEN irp.insuredsaddress END , -- HolderAddressLine1 - varchar(256)
     --   '' , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pd.SecondaryInsuredRelationship <> 'S' THEN irp.insuredcity END , -- HolderCity - varchar(128)
          CASE WHEN pd.SecondaryInsuredRelationship <> 'S' THEN irp.insuredstate END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pd.SecondaryInsuredRelationship <> 'S' THEN irp.insuredszip END , -- HolderZipCode - varchar(9)
          CASE WHEN pd.SecondaryInsuredRelationship <> 'S' THEN irp.insuredphone END , -- HolderPhone - varchar(10)
      -- '' , -- HolderPhoneExt - varchar(10)
          CASE WHEN pd.secondaryinsuredrelationship <> 'S' THEN irp.insuredsidno END , -- DependentPolicyNumber - varchar(32)
      /*    '' , -- Notes - text
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)
          NULL , -- Copay - money
          NULL , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32)  */
          1 , -- Active - bit
          @practiceID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)  */
          MedicalRecordNumber + '2' , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      /*   0 , -- InsuranceProgramTypeID - int
          '' , -- GroupName - varchar(14)
          '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL , -- InsurancePolicyGuid - uniqueidentifier
          0  -- MedicareFormularyID - int */
FROM dbo.[_import_1_1_PatientDemo] as pd
INNER JOIN dbo.insuranceCompanyplan as inscoplan ON
        inscoplan.vendorID = pd.SecondInsuranceCompany AND
		inscoplan.vendorimportID = @vendorimportID      
INNER JOIN dbo.patientcase as patcase ON
        patcase.VendorID = pd.medicalrecordnumber AND
        patcase.vendorimportID = @vendorimportID      
LEFT JOIN dbo.[_import_1_1_InsuredandResponsibleParty] AS irp ON
        irp.InsuredNumber = pd.secondaryinsured
WHERE pd.secondaryinsuredidno <> ''

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurancepolicy Secondary'

PRINT '' 
PRINT 'updating patient case with PayerScenarioID'
Update dbo.patientcase set PayerScenarioID=11, name='Self Pay' from dbo.patientcase as patcase 
LEFT JOIN dbo.insurancepolicy as ip ON
ip.patientcaseID = patcase.patientcaseID 
where patcase.VendorImportID = @vendorImportID AND
ip.patientcaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records updated into patient case '

--PRINT ''

--ROLLBACK
--COMMIT TRANSACTION

--        PRINT 'COMMITTED SUCCESSFULLY'