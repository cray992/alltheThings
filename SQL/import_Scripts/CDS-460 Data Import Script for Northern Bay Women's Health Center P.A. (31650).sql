USE superbill_31650_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 2 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

/*
DELETE FROM dbo.EncounterDiagnosis WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from EncounterDiagnosis'
DELETE FROM dbo.EncounterProcedure WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from EncounterProcedure'
DELETE FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Encounter'
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE PracticeID = @PracticeID)
PRINT CAST(@@rowcount AS varchar(10)) + ' Standard Fee Schedule Link records deleted '
DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE PracticeID = @PracticeID)
PRINT CAST(@@rowcount AS varchar(10)) + ' Standard Fee records deleted '
DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE PracticeID = @PracticeID
PRINT CAST(@@rowcount AS varchar(10)) + ' Standard Fee Schedule records deleted '
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from InsurancePolicy'
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Insurance Company Plan'
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from Insurance'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCase'
DELETE FROM dbo.PatientAlert
DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'
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
      --  DefaultAdjustmentCode ,
      --  ReferringProviderNumberTypeID ,  
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
          il.namevendorid, -- InsuranceCompanyName - varchar(128)
          'Contact' + il.Note , -- Notes - text
          il.address , -- AddressLine1 - varchar(256)
          il.address2 , -- AddressLine2 - varchar(256)
          il.city , -- City - varchar(128)
          il.state , -- State - varchar(2) 
          '' , -- Country - varchar(32)
          CASE WHEN LEN(il.zip) = 4 THEN '0' + il.zip ELSE LEFT(il.zip, 9) END ,  -- ZipCode - varchar(9)  
          '' , -- ContactPrefix - varchar(16)
      /*  '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64) */
          '' , -- ContactSuffix - varchar(16)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(il.phone,' ','')),10)  , -- Phone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(il.phoneext,' ','')),10) , -- PhoneExt - varchar(10)
      /*  '' , -- Fax - varchar(10)
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
          il.namevendorid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  '' , -- DefaultAdjustmentCode - varchar(10)
      --  0 , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_InsuranceList] as il
WHERE il.namevendorid<>''  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company'

PRINT ''
PRINT 'Inserting records into Insurance Company 2'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
          il.insplanvendorid, -- InsuranceCompanyName - varchar(128)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          il.insplanvendorid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_Policy] il
WHERE NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic WHERE il.insplanvendorid = ic.VendorID AND ic.VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company'


PRINT ''
PRINT 'Inserting records into Insurance Company 3'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          CreatedPracticeID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          SecondaryPrecedenceBillingFormID ,
          VendorID ,
          VendorImportID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
          il.insplanvendorid, -- InsuranceCompanyName - varchar(128)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          il.insplanvendorid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_Policy2] il
WHERE NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic WHERE il.insplanvendorid = ic.VendorID AND ic.VendorImportID = @VendorImportID)
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
          ContactLastName ,
          ContactSuffix , */
          Phone ,
          PhoneExt ,
          Notes ,
      --  MM_CompanyID ,  
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
SELECT 
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
          '' , -- ContactLastName - varchar(64)  
          '' , -- ContactSuffix - varchar(16)  */
          ic.Phone , -- Phone - varchar(10)
          ic.PhoneExt , -- PhoneExt - varchar(10)
          ic.Notes , -- Notes - text
      --  '' , -- MM_CompanyID - varchar(10) 
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
PRINT'Inserting records into Employers'
INSERT INTO dbo.Employers
        ( 
		  EmployerName ,
          AddressLine1 ,
      --  AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
      --  RecordTimeStamp
        )
SELECT  DISTINCT 
          el.name , -- EmployerName - varchar(128)
          el.Address , -- AddressLine1 - varchar(256)
      --  '' , -- AddressLine2 - varchar(256)
          el.City , -- City - varchar(128)
          el.State , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(el.zip) = 5 THEN zip 
		    ELSE LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(el.zip,' ','')),9) 
		   END , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
      --  NULL  -- RecordTimeStamp - timestamp
FROM [dbo].[_import_2_1_EmployerList] as el
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into Employers Successfully'

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
          HomePhone ,
      --  HomePhoneExt ,
      --  WorkPhone ,
      --  WorkPhoneExt ,
          PagerPhone ,
     /*   PagerPhoneExt ,
          MobilePhone ,
          MobilePhoneExt ,
          DOB ,
          EmailAddress ,  */
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
      --  UserID ,
          Degree ,
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
          rd.firstname , -- FirstName - varchar(64)
          rd.middlename , -- MiddleName - varchar(64)
          rd.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
      --  '' , -- SSN - varchar(9)
          rd.address1 , -- AddressLine1 - varchar(256)
          rd.address2 , -- AddressLine2 - varchar(256)
          rd.city , -- City - varchar(128)
          rd.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(rd.zip) = 4 THEN '0' + zip ELSE LEFT(rd.zip, 9) END , -- ZipCode - varchar(9)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rd.homephone,' ','')),10) , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rd.workphone,' ','')),10) , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
      --  '' , -- PagerPhone - varchar(10)
      --  '' , -- PagerPhoneExt - varchar(10)
      --  '' , -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  GETDATE() , -- DOB - datetime
      --  '' , -- EmailAddress - varchar(256)
          'Upin: ' + rd.note , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  0 , -- UserID - int
	      LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rd.degree,'.','')),10) , -- Degree - varchar(8)
      --  0 , -- DefaultEncounterTemplateID - int
      --  '' , -- TaxonomyCode - char(10)
      --  0 , -- DepartmentID - int
          rd.firstname +' ' + rd.lastname , -- VendorID - varchar(50)
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
FROM [dbo].[_import_2_1_ReferringDoc] as rd
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into ReferringDoctor'

PRINT ''
PRINT 'Inserting records into patient 1'
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
      --  Gender ,
      --  MaritalStatus ,
      --  HomePhone ,
      --  HomePhoneExt ,
      --  WorkPhone ,
      --  WorkPhoneExt ,
          DOB ,
      --  SSN ,
      --  EmailAddress ,
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
          ResponsibleState ,  */
          ResponsibleCountry ,
      --  ResponsibleZipCode ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
     /*   RecordTimeStamp ,*/
          EmploymentStatus ,
       /*   InsuranceProgramCode ,
          PatientReferralSourceID ,  */
          PrimaryProviderID ,  
          DefaultServiceLocationID ,
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
          pd.middlename , -- MiddleName - varchar(64)
          pd.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pd.address , -- AddressLine1 - varchar(256)
          pd.address2 , -- AddressLine2 - varchar(256)
          pd.city , -- City - varchar(128)
          LEFT(pd.[STATE],2) , -- State - varchar(2)
          '' , -- Country - varchar(32)  
          CASE WHEN LEN(pd.zip) = 4 THEN '0' + pd.zip ELSE LEFT(pd.zip, 9) END , -- ZipCode - varchar(9)
      --  ''  , -- Gender - varchar(1)
      --  '' , -- MaritalStatus - varchar(1)
      --  '' , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
      --  '' , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
          pd.dob , -- DOB - datetime
      --  '' , -- SSN - char(9)
      --  '' , -- EmailAddress - varchar(256) 
          CASE WHEN pd.guarantorlastname <> '' THEN 1 ELSE 0 END, --  ResponsibleDifferentThanPatient - BIT ,
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN pd.guarantorfirstname <> '' THEN  guarantorfirstname END , -- ResponsibleFirstName - varchar(64)
      --  '' , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN pd.guarantorlastname <> '' THEN  guarantorlastname END , -- ResponsibleLastName - varchar(64)
          '' , -- ResponsibleSuffix - varchar(16)
          CASE WHEN pd.guarantorlastname <> '' THEN 'O' ELSE 'S' END , -- ResponsibleRelationshipToPatient - varchar(1)
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
          'U' , -- EmploymentStatus - char(1)
      --  '' , -- InsuranceProgramCode - char(2)
      --  0 , -- PatientReferralSourceID - int
          CASE WHEN pd.primaryprovider = 'Endelman, Irwin  R' THEN 1 ELSE NULL END , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
      --  '' , -- EmployerID - int
          pd.MedicalRecordNumber , -- MedicalRecordNumber - varchar(128)
      --  '' ,  -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  '' , -- PrimaryCarePhysicianID - int
          pd.patvendorID , -- VendorID - varchar(50)
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
FROM dbo._import_2_1_PatientDemo as pd
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully'


PRINT ''
PRINT 'Inserting records into patient 2'
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
      --  Gender ,
      --  MaritalStatus ,
      --  HomePhone ,
      --  HomePhoneExt ,
      --  WorkPhone ,
      --  WorkPhoneExt ,
          DOB ,
      --  SSN ,
      --  EmailAddress ,
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
          PatientReferralSourceID ,  */
          PrimaryProviderID ,  
          DefaultServiceLocationID ,
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
          pd.middlename , -- MiddleName - varchar(64)
          pd.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pd.address , -- AddressLine1 - varchar(256)
          pd.address2 , -- AddressLine2 - varchar(256)
          pd.city , -- City - varchar(128)
          LEFT(pd.[STATE],2) , -- State - varchar(2)
          '' , -- Country - varchar(32)  
          CASE WHEN LEN(pd.zip) = 4 THEN '0' + pd.zip ELSE LEFT(pd.zip, 9) END , -- ZipCode - varchar(9)
      --  ''  , -- Gender - varchar(1)
      --  '' , -- MaritalStatus - varchar(1)
      --  '' , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
      --  '' , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
          pd.dob , -- DOB - datetime
      --  '' , -- SSN - char(9)
      --  '' , -- EmailAddress - varchar(256) 
          CASE WHEN pd.guarantorlastname <> '' THEN 1 ELSE 0 END, --  ResponsibleDifferentThanPatient - BIT ,
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN pd.guarantorfirstname <> '' THEN  guarantorfirstname END , -- ResponsibleFirstName - varchar(64)
      --  '' , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN pd.guarantorlastname <> '' THEN  guarantorlastname END , -- ResponsibleLastName - varchar(64)
          '' , -- ResponsibleSuffix - varchar(16)
          CASE WHEN pd.guarantorlastname <> '' THEN 'O' ELSE 'S' END , -- ResponsibleRelationshipToPatient - varchar(1)
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
          CASE WHEN pd.primaryprovider = 'Endelman, Irwin  R' THEN 1 ELSE NULL END , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
      --  '' , -- EmployerID - int
          pd.MedicalRecordNumber , -- MedicalRecordNumber - varchar(128)
      --  '' ,  -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  '' , -- PrimaryCarePhysicianID - int
          pd.medicalrecordnumber + pd.patvendorID, -- VendorID - varchar(50)
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
FROM dbo._import_2_1_PatientDemo2 as pd
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully'


PRINT ''
PRINT 'Inserting into PatientCase- Default'
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
INNER JOIN dbo.[_import_2_1_PatientDemo] i ON
pat.VendorID = i.patvendorid AND
pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase-Default'


PRINT ''
PRINT 'Inserting into PatientCase- Default 2'
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
          'Self Pay' , -- Name - varchar(128)
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
INNER JOIN dbo.[_import_2_1_PatientDemo2] i ON
pat.VendorID = i.medicalrecordnumber +i.patvendorid AND
pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase-Default'



PRINT ''
PRINT'Inserting records into Insurance Policy 1'
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
      --  HolderMiddleName ,
          HolderLastName ,
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
      /*  RecordTimeStamp ,
          HolderGender ,*/
          HolderAddressLine1 ,
      /*    HolderAddressLine2 ,
          HolderCity ,  */
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
      --  HolderPhone ,
     /*   HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,       
          Copay , */
     --   Deductible ,
     --   PatientInsuranceNumber ,
          Active ,
          PracticeID ,
      /*  AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,     */
          VendorID ,
          VendorImportID 
      --  InsuranceProgramTypeID ,
      --  GroupName ,
      --  ReleaseOfInformation ,
      --  SyncWithEHR ,
      --  InsurancePolicyGuid
        )
SELECT DISTINCT
          patcase.PatientCaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          ip.precedence , -- Precedence - int
          ip.policy , -- PolicyNumber - varchar(32)
      --  '' , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit
          CASE WHEN ip.HolderLastName <> '' THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1) 
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.holderfirstname <> '' THEN ip.HolderFirstName END , -- HolderFirstName - varchar(64)
     --   '' , -- HolderMiddleName - varchar(64)
          CASE WHEN ip.HolderLastName <> '' THEN ip.HolderLastName END , -- HolderLastName - varchar(64)
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
      /*  NULL , -- RecordTimeStamp - timestamp
          '' , -- HolderGender - char(1) */
          CASE WHEN ip.holderlastname <> '' THEN ip.guarantoraddress END , -- HolderAddressLine1 - varchar(256)
        /*  '' , -- HolderAddressLine2 - varchar(256) 
          '' , -- HolderCity - varchar(128)  */
          CASE WHEN ip.HolderLastName <> '' THEN LEFT(ip.[state], 2) END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN ip.HolderLastName <> '' THEN CASE WHEN LEN(ip.zip) = 4 THEN '0' + ip.zip ELSE LEFT(ip.zip, 9) END END , -- HolderZipCode - varchar(9)
      /*  '' , -- HolderPhone - varchar(10)  
          '' , -- HolderPhoneExt - varchar(10)
          '' , -- DependentPolicyNumber - varchar(32)
          '' , -- Notes - text
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)   
          '' , -- Copay - money */
      --  NULL , -- Deductible - money
      --  '' , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)     */
          patcase.VendorID + ip.policy , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  0 , -- InsuranceProgramTypeID - int
      --  '' ,  -- GroupName - varchar(14)
      --  '' , -- ReleaseOfInformation - varchar(1)
      --  NULL , -- SyncWithEHR - bit
      --  NULL  -- InsurancePolicyGuid - uniqueidentifier
FROM [dbo].[_import_2_1_Policy] as ip
INNER JOIN dbo.PatientCase AS patcase ON 
    patcase.VendorID = ip.patvendorID AND
    patcase.vendorimportID = @vendorimportID     
--  AND  patcase.name = 'Balance Forward'	
INNER JOIN dbo.InsuranceCompanyPlan AS inscoplan ON
    inscoplan.VendorID = ip.insplanvendorid AND
    inscoplan.VendorImportID = @VendorImportID 	
where ip.policy <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into Insurance Policy Successfully'


PRINT ''
PRINT'Inserting records into Insurance Policy 2'
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
      --  HolderMiddleName ,
          HolderLastName ,
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
      /*  RecordTimeStamp ,
          HolderGender ,*/
          HolderAddressLine1 ,
      /*    HolderAddressLine2 ,
          HolderCity ,  */
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
      --  HolderPhone ,
     /*   HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,       
          Copay , */
     --   Deductible ,
     --   PatientInsuranceNumber ,
          Active ,
          PracticeID ,
      /*  AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,     */
          VendorID ,
          VendorImportID 
      --  InsuranceProgramTypeID ,
      --  GroupName ,
      --  ReleaseOfInformation ,
      --  SyncWithEHR ,
      --  InsurancePolicyGuid
        )
SELECT DISTINCT
          patcase.PatientCaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          ip.newprecedence , -- Precedence - int
          ip.policy , -- PolicyNumber - varchar(32)
      --  '' , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit
          CASE WHEN ip.HolderLastName <> '' THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1) 
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.holderfirstname <> '' THEN ip.HolderFirstName END , -- HolderFirstName - varchar(64)
     --   '' , -- HolderMiddleName - varchar(64)
          CASE WHEN ip.HolderLastName <> '' THEN ip.HolderLastName END , -- HolderLastName - varchar(64)
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
      /*  NULL , -- RecordTimeStamp - timestamp
          '' , -- HolderGender - char(1) */
          CASE WHEN ip.holderlastname <> '' THEN ip.guarantoraddress END , -- HolderAddressLine1 - varchar(256)
        /*  '' , -- HolderAddressLine2 - varchar(256) 
          '' , -- HolderCity - varchar(128)  */
          CASE WHEN ip.HolderLastName <> '' THEN ip.[state] END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN ip.HolderLastName <> '' THEN CASE WHEN LEN(ip.zip) = 4 THEN '0' + ip.zip ELSE LEFT(ip.zip, 9) END END , -- HolderZipCode - varchar(9)
      /*  '' , -- HolderPhone - varchar(10)  
          '' , -- HolderPhoneExt - varchar(10)
          '' , -- DependentPolicyNumber - varchar(32)
          '' , -- Notes - text
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)   
          '' , -- Copay - money */
      --  NULL , -- Deductible - money
      --  '' , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)     */
          patcase.VendorID + ip.policy , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  0 , -- InsuranceProgramTypeID - int
      --  '' ,  -- GroupName - varchar(14)
      --  '' , -- ReleaseOfInformation - varchar(1)
      --  NULL , -- SyncWithEHR - bit
      --  NULL  -- InsurancePolicyGuid - uniqueidentifier
FROM [dbo].[_import_2_1_Policy2] as ip
INNER JOIN dbo.PatientCase AS patcase ON 
    patcase.VendorID = ip.patvendorID AND
    patcase.vendorimportID = @vendorimportID     
--  AND  patcase.name = 'Balance Forward'	
INNER JOIN dbo.InsuranceCompanyPlan AS inscoplan ON
    inscoplan.VendorID = ip.insplanvendorid AND
    inscoplan.VendorImportID = @VendorImportID 	
where ip.policy <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into Insurance Policy Successfully'


PRINT ''
PRINT'Inserting records into ContractsAndFees_StandardFeeSchedule'
INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
        ( PracticeID ,
          Name ,
          Notes ,
          EffectiveStartDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
       /* MedicareFeeScheduleGPCICarrier ,
          MedicareFeeScheduleGPCILocality ,
          MedicareFeeScheduleGPCIBatchID ,
          MedicareFeeScheduleRVUBatchID , */
          AddPercent ,
          AnesthesiaTimeIncrement
        )
Values
          (
          @PracticeID , -- PracticeID - int
          'Default Contract' , -- Name - varchar(128)
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          GETDATE() , -- EffectiveStartDate - datetime
          'F' , -- SourceType - char(1)
          'Import File' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
        /*  0 , -- MedicareFeeScheduleGPCICarrier - int
          0 , -- MedicareFeeScheduleGPCILocality - int
          0 , -- MedicareFeeScheduleGPCIBatchID - int
          0 , -- MedicareFeeScheduleRVUBatchID - int  */
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
         )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into ContractsAndFees_StandardFeeSchedule Successfully'		

PRINT ''
PRINT'Inserting records into ContractsAndFees_StandardFee'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
      --  ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT 
          cfs.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pc.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
      --  0 , -- ModifierID - int
          fs.fee , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_2_1_FeeSchedule] as fs
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule as cfs ON
     cfs.practiceID = @practiceID AND
	 cfs.Notes = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR)
INNER JOIN dbo.procedurecodedictionary as pc ON
      pc.procedurecode = fs.ProcedureCodesList
WHERE fs.fee > '$0.00' AND PracticeID=@practiceid
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into ContractsAndFees_StandardFee Successfully'	

PRINT ''
PRINT'Inserting records into ContractsAndFees_StandardFeeScheduleLink '
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT    doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          cfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor AS doc ,dbo.ServiceLocation AS sl ,dbo.ContractsAndFees_StandardFeeSchedule AS cfs 
WHERE doc.[External] = 1 AND doc.PracticeID = @PracticeID AND sl.PracticeID = @PracticeID AND
CAST(cfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND cfs.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into ContractsAndFees_StandardFeeScheduleLink Successfully'	



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
          pd.PatVendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  NULL , -- PregnancyRelatedFlag - bit
      --  NULL , -- StatementActive - bit
      --  NULL , -- EPSDT - bit
      --  NULL , -- FamilyPlanning - bit
      --  0 , -- EPSDTCodeID - int
      --  NULL , -- EmergencyRelated - bit
      --  NULL  -- HomeboundRelatedFlag - bit
FROM dbo.[_import_2_1_PatientDemo] as pd
INNER JOIN dbo.Patient AS pat ON
pat.VendorID = pd.PatVendorID AND
pat.VendorImportID = @VendorImportID
WHERE pd.balance <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase- Balance Forward'

PRINT ''
PRINT 'Inserting into Encounter '
INSERT INTO dbo.Encounter
        ( PracticeID ,
          PatientID ,
          DoctorID ,
      --  AppointmentID ,
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
      --  AppointmentStartDate ,
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
          Patcase.PatientID , -- PatientID - int
          1 , -- DoctorID - int ************************************************************************
     --   '' , -- AppointmentID - int
          1 , -- LocationID - int
     --   emp.EmployerID , -- PatientEmployerID - int
          GETDATE() , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          'Convert(Varchar(10), GETDATE(),101) + : Creating Balance Forward' , -- Notes - text
          2 , -- EncounterStatusID - int
     --   '' , -- AdminNotes - text
     --   csf.setfee , -- AmountPaid - money
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
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
      --  '' , -- AppointmentStartDate - datetime
      --  '' , -- BatchID - varchar(50)
      --  0 , -- SchedulingProviderID - int
          0 , -- DoNotSendElectronicSecondary - bit
      --  0 , -- PaymentCategoryID - int
          0 , -- overrideClosingDate - bit
      --  '' , -- Box10d - varchar(40)
          0 , -- ClaimTypeID - int
     /*   0 , -- OperatingProviderID - int
          0 , -- OtherProviderID - int
          0 , -- PrincipalDiagnosisCodeDictionaryID - int
          0 , -- AdmittingDiagnosisCodeDictionaryID - int
          0 , -- PrincipalProcedureCodeDictionaryID - int
          0 , -- DRGCodeID - int
          GETDATE() , -- ProcedureDate - datetime
          0 , -- AdmissionTypeID - int
          GETDATE() , -- AdmissionDate - datetime
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
      /*  '' , -- DocumentControlNumberCMS1500 - varchar(26)
          '' , -- DocumentControlNumberUB04 - varchar(26)
          '' , -- EDIClaimNoteReferenceCodeCMS1500 - char(3)
          '' , -- EDIClaimNoteReferenceCodeUB04 - char(3)
          '' , -- EDIClaimNoteCMS1500 - varchar(1600)
          '' , -- EDIClaimNoteUB04 - varchar(1600)
          NULL , -- EncounterGuid - uniqueidentifier      */
          0  -- PatientCheckedIn - bit
     --   ''  -- RoomNumber - varchar(32)
FROM dbo.PatientCase AS patcase 
/*INNER JOIN dbo.ServiceLocation AS sl ON
pat.DefaultServiceLocationID = sl.servicelocationID 
INNER JOIN dbo.PatientCase as patcase ON
patcase.patientID = pat.patientID
INNER JOIN dbo._import_2_1_PatientCasePolicy as pcp ON
patcase.VendorID = pcp.chartnumber*/
WHERE patcase.Name = 'Balance Forward'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Encounter' 

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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
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
     /*   RecordTimeStamp ,*/
          ServiceChargeAmount ,   
          ServiceUnitCount ,
     /*   ProcedureModifier1 ,
          ProcedureModifier2 ,
          ProcedureModifier3 ,
          ProcedureModifier4 ,   */
          ProcedureDateOfService ,
          PracticeID ,
          EncounterDiagnosisID1 ,
     /*   EncounterDiagnosisID2 ,
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      /*  NULL , -- RecordTimeStamp - timestamp */
          i.balance , -- ServiceChargeAmount - money    
          '1.000' , -- ServiceUnitCount - decimal
     /*   '' , -- ProcedureModifier1 - varchar(16)
          '' , -- ProcedureModifier2 - varchar(16)
          '' , -- ProcedureModifier3 - varchar(16)
          '' , -- ProcedureModifier4 - varchar(16)   */
          GETDATE() , -- ProcedureDateOfService - datetime
          @PracticeID , -- PracticeID - int
          ed.EncounterDiagnosisID , -- EncounterDiagnosisID1 - int
     /*     0 , -- EncounterDiagnosisID2 - int
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
INNER JOIN dbo.[_import_2_1_PatientDemo] i ON
	enc.VendorID = i.patvendorid AND
	enc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into EncounterProcedure' 


PRINT ''
PRINT 'Inserting Into Patient Alert...'
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
          ShowInClaimFlag ,
          ShowInPaymentFlag ,
          ShowInPatientStatementFlag
        )
SELECT DISTINCT
		  p.PatientID , -- PatientID - int
          'Balance Forward Encounter is Present' , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          1 , -- ShowInAppointmentFlag - bit
          1 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
		  0 ,
          1 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_2_1_PatientDemo] i
INNER JOIN dbo.Patient p ON
p.VendorID = i.patvendorid AND
p.VendorImportID = @VendorImportID
WHERE i.balance <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into PatientAlert' 


PRINT '' 
PRINT 'updating patient case with PayerScenarioID'
Update dbo.patientcase set PayerScenarioID=11, name='Self Pay' from dbo.patientcase as patcase 
LEFT JOIN dbo.insurancepolicy as ip ON
ip.patientcaseID = patcase.patientcaseID 
where patcase.VendorImportID = @vendorImportID AND 
patcase.Name <> 'Balance Forward' AND
ip.patientcaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated into patient case '



--ROLLBACK
--COMMIT
--PRINT 'COMMIT SUCCESSFUllY'

