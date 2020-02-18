USE superbill_31313_dev
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

--DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentToAppointmentReason'
--DELETE FROM dbo.AppointmentReason WHERE PracticeID = @practiceID AND Name = [description]
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentReason'
--DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
--PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from AppointmentToResource '
--DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from  Appointment '
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
--DELETE FROM dbo.Employers WHERE CreatedUserID = -50
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Employer'
--DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Doctor'
--DELETE FROM dbo.PracticeResource 


PRINT ''
PRINT 'Inserting records into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
      /*  Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,   */
          Country ,
     --   ZipCode ,
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
          il.[1payername] , -- InsuranceCompanyName - varchar(128)
      /*  '' , -- Notes - text
          il.plan1address1 , -- AddressLine1 - varchar(256)
          il.plan1address2 , -- AddressLine2 - varchar(256)
          il.plan1city , -- City - varchar(128)
          il.plan1state , -- State - varchar(2) */ 
          '' , -- Country - varchar(32)
      --  '' ,  -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
     /*   '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)  */
          '' , -- ContactSuffix - varchar(16)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(il.[1payerphone],'-','')),10), -- Phone - varchar(10)
     /*   '' , -- PhoneExt - varchar(10)
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
          LEFT (il.[1payername] , 50) ,-- VendorID - varchar(50)  
          @VendorImportID , -- VendorImportID - int
      --  '' , -- DefaultAdjustmentCode - varchar(10)
      --  0 , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceList] as il
WHERE il.[1payername]<>''
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
      /*  '' , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          '' , -- City - varchar(128)
          '' , -- State - varchar(2)  */
          '' , -- Country - varchar(32)
     --   '' , -- ZipCode - varchar(9)
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
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Insurance Company'

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
          --WorkPhoneExt ,
          --PagerPhone ,
          --PagerPhoneExt ,
          --MobilePhone ,
          --MobilePhoneExt ,
          --DOB ,   
          --EmailAddress ,  
          --Notes ,   */
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      /*  RecordTimeStamp ,
          UserID ,
          Degree ,  
          DefaultEncounterTemplateID ,
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
          rp.FirstName, -- FirstName - varchar(64)
          rp.middlename , -- MiddleName - varchar(64)
          rp.Lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
      --  '' , -- SSN - varchar(9)
          rp.referringprovideraddress1 , -- AddressLine1 - varchar(256)
          rp.referringprovideraddress2 , -- AddressLine2 - varchar(256)
          rp.referringprovidercity , -- City - varchar(128)
          rp.referringproviderstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(rp.referringproviderzip) = 4 THEN '0' + rp.referringproviderzip ELSE LEFT(rp.referringproviderzip, 9) END ,  -- ZipCode - varchar(9)
      --    LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rp.referringproviderphone,'-','')),10)  , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rp.referringproviderphone,'-','')),10), -- WorkPhone - varchar(10)
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
     --     LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rp.degree,'.','')),10), -- Degree - varchar(8) ***********************
      /*  0 , -- DefaultEncounterTemplateID - int
          '' , -- TaxonomyCode - char(10)
          0 , -- DepartmentID - int    */
          rp.vendorid, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  '' , -- FaxNumber - varchar(10)
      --  '' , -- FaxNumberExt - varchar(10)
      --  '', -- OrigReferringPhysicianID - int 
          1 ,  -- External - bit
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rp.referringprovidernpi,'-','')),10)  -- NPI - varchar(10)
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
FROM dbo.[_import_1_1_ReferringPhys] as rp
WHERE rp.vendorid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Doctors'

PRINT ''
PRINT 'Inserting Into Employers'
INSERT INTO dbo.Employers
        ( EmployerName ,
      --  AddressLine1 ,
          AddressLine2 ,
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
SELECT DISTINCT
          pd.patientemployername , -- EmployerName - varchar(128)
          pd.patientemployeraddress1 , -- AddressLine1 - varchar(256)
      --  '' , -- AddressLine2 - varchar(256)
          pd.patientemployercity , -- City - varchar(128)
          pd.patientemployerstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(pd.patientemployerzip) = 4 THEN '0' + pd.patientemployerzip ELSE LEFT(pd.patientemployerzip, 9) END , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
      --  NULL  -- RecordTimeStamp - timestamp
FROM dbo.[_import_1_1_PatDemoPolicy] as pd
WHERE pd.patientemployername <> '' AND pd.patientemployername <> '`' 
AND NOT EXISTS (SELECT * FROM dbo.Employers e WHERE pd.patientemployername = e.EmployerName)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into Employers Successfully'


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
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName ,  
          ResponsibleSuffix ,
          ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
      --  ResponsibleAddressLine2 ,
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
        --  InsuranceProgramCode ,
        --  PatientReferralSourceID ,   
          PrimaryProviderID ,  
          DefaultServiceLocationID ,  
          EmployerID ,
          MedicalRecordNumber ,  
          MobilePhone ,
   /*     MobilePhoneExt ,
          PrimaryCarePhysicianID ,   */
          VendorID ,
          VendorImportID ,
      --  CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,       
          EmergencyPhone 
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
          d.DoctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          pdp.patientfirstname , -- FirstName - varchar(64)
          pdp.patientmiddlename , -- MiddleName - varchar(64)
          pdp.patientlastname , -- LastName - varchar(64)
          pdp.suffix , -- Suffix - varchar(16)
          pdp.patientaddress , -- AddressLine1 - varchar(256)
      --  '' , -- AddressLine2 - varchar(256)
          pdp.patientcity , -- City - varchar(128)
          pdp.patientstate , -- State - varchar(2) 
          '' , -- Country - varchar(32)  
		  LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.patientzipcode,'-','')),9) , -- ZipCode - varchar(9)
          CASE pdp.patientgender WHEN 'FEMALE' THEN 'F' 
                                 WHEN 'MALE' THEN 'M'
                                 WHEN 'Undifferentiated' THEN 'U' END , -- Gender - varchar(1)
          CASE pdp.patientmaritalstatus WHEN 'Married' THEN 'M'
		                         WHEN 'Separated' THEN 'L'
								 WHEN 'Domestic Partner' THEN 'T'
								 WHEN 'Divorced' THEN 'D'
                                 WHEN 'Widowed' THEN 'W'
                                 WHEN 'Never Married' THEN 'S' END , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.patienthomephone,'-','')),10) , -- HomePhone - varchar(10)
     --   '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.patientworkphone,'-','')),10) , -- WorkPhone - varchar(10)
     --   '' , -- WorkPhoneExt - varchar(10)
          pdp.patientdateofbirth , -- DOB - datetime
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.patientssn,'-','')),9), -- SSN - char(9)
          pdp.patientemail , -- EmailAddress - varchar(256)
          CASE WHEN pdp.patientresponsiblerelationship = 'O' then 1 ELSE 0 END , --  ResponsibleDifferentThanPatient - BIT 
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN pdp.patientresponsiblerelationship = 'O' then pdp.guarantorfirstname END, -- ResponsibleFirstName - varchar(64)
          CASE WHEN pdp.patientresponsiblerelationship = 'O' then pdp.guarantormiddlename  END, -- ResponsibleMiddleName - varchar(64)
          CASE WHEN pdp.patientresponsiblerelationship = 'O' then pdp.guarantorlastname  END, -- ResponsibleLastName - varchar(64)
          '' , -- ResponsibleSuffix - varchar(16)
          pdp.patientresponsiblerelationship , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN pdp.patientresponsiblerelationship = 'O' then pdp.guarantoraddress END , -- ResponsibleAddressLine1 - varchar(256)
      --  '' , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN pdp.patientresponsiblerelationship = 'O' then pdp.guarantorcity END, -- ResponsibleCity - varchar(128)
          CASE WHEN pdp.patientresponsiblerelationship = 'O' then pdp.guarantorstate END, -- ResponsibleState - varchar(2)  
          '' , -- ResponsibleCountry - varchar(32)
          CASE WHEN pdp.patientresponsiblerelationship = 'O' then 
		  LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.patientzipcode,'-','')),10) END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE pdp.patientemploymentstatus WHEN 'Unemployed' THEN 'U'
                                    WHEN 'Part-time Student' THEN 'T'
                                    WHEN 'Full-time Student' THEN 'S'
                                    WHEN 'Other' THEN 'U'
                                    WHEN 'Employed' THEN 'E'
                                    WHEN '' THEN 'U' END, -- EmploymentStatus - char(1)
    /*    '' , -- InsuranceProgramCode - char(2)
      --  0 , -- PatientReferralSourceID - int*/
          CASE pdp.patientassociatedprovider WHEN 'MCDONALD, KATE' THEN 3 WHEN 'WEIL, MICHAEL' THEN 2 ELSE NULL END , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int    
          em.EmployerID , -- EmployerID - int
          pdp.patientchartnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.patientcellphone,'-','')),10) ,  -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
        --'' , -- PrimaryCarePhysicianID - int
          pdp.patientchartnumber, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  0 , -- CollectionCategoryID - int
          1 ,  -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
          pdp.PatientEmergencyFirstName + ' ' + pdp.PatientEmergencyLastName + ' | ' + pdp.PatientEmergencyRelation , -- EmergencyName - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.patientemergencyphone,'-','')),10)  -- EmergencyPhone - varchar(10)
      --  '' , -- EmergencyPhoneExt - varchar(10)
      --  NULL , -- PatientGuid - uniqueidentifier
      --  '' , -- Ethnicity - varchar(64)
      --  '' , -- Race - varchar(64)
      --  '',  -- LicenseNumber - varchar(64)
      --  '' , -- LicenseState - varchar(2)
      --  '' , -- Language1 - varchar(64)
      --  ''  -- Language2 - varchar(64)
FROM dbo.[_import_1_1_PatDemoPolicy] as pdp
LEFT JOIN dbo.Employers AS em ON
    em.EmployerID = (SELECT TOP 1 em2.EmployerID FROM dbo.Employers em2 WHERE em2.EmployerName = pdp.patientemployername) 
LEFT JOIN dbo.Doctor d ON 
    pdp.patientreferringprovider = d.VendorID AND
	d.VendorImportID = @VendorImportID AND
	d.[External] = 1
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
          ia.appointmentreason , -- Name - varchar(128)
      --  '' , -- DefaultDurationMinutes - int
      --  0 , -- DefaultColorCode - int
          ia.appointmentreason , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
     --   NULL , -- TIMESTAMP - timestamp
     --   NULL  -- AppointmentReasonGuid - uniqueidentifier  
FROM dbo.[_import_1_1_Appointment] AS ia
where ia.appointmentreason <> '' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ia.appointmentreason = ar.Name)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into AppointmentReason'


PRINT ''
PRINT'Inserting records into Appointment'
INSERT INTO dbo.Appointment
        ( 
		  PatientID ,
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
     --     PatientCaseID ,
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
          ia.startdate , -- StartDate - datetime
          ia.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          ia.appointmentid , -- Subject - varchar(64)
          ia.note , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          ia.resourcetypeid, -- AppointmentResourceTypeID - int
          ia.AppointmentConfirmationStatus , -- AppointmentConfirmationStatusCode - char(1)
      --  NULL , -- AllDay - bit
      --  0 , -- InsurancePolicyAuthorizationID - int
      --    patcase.PatientCaseID , -- PatientCaseID - int
      --  NULL , -- Recurrence - bit
      --  GETDATE() , -- RecurrenceStartDate - datetime
      --  GETDATE() , -- RangeEndDate - datetime
      --  '' , -- RangeType - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          ia.StartTm , -- StartTm - smallint
          ia.EndTm  -- EndTm - smallint
      --  NULL  -- AppointmentGuid - uniqueidentifier
FROM dbo.[_import_1_1_Appointment] as ia
INNER JOIN dbo.patient AS pat ON
  pat.vendorid = ia.chartnumber and
  pat.VendorImportID = @VendorImportID
LEFT JOIN dbo.patientcase AS patcase ON
  patcase.PatientID = pat.PatientID AND
  patcase.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(ia.startdate AS date) AS DATETIME)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted into Appointment Successfully'


--PRINT ''
--PRINT 'Inserting records into PracticeResource'
--INSERT INTO dbo.PracticeResource
--        ( 
--		  PracticeResourceTypeID ,
--          PracticeID ,
--          ResourceName ,
--     --   PracticeResourceGuid ,
--          ModifiedDate ,
--          CreatedDate
--        )
--values
--        (
--  		  '1' , -- PracticeResourceTypeID - int
--          @practiceID , -- PracticeID - int
--          'LASER AND MICRODERM' , -- ResourceName - varchar(50)
--      --  NULL , -- PracticeResourceGuid - uniqueidentifier
--          GETDATE() , -- ModifiedDate - datetime
--          GETDATE()  -- CreatedDate - datetime
--         )
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in PracticeResource'

PRINT ''
PRINT 'Inserting into Appointment To Appointment Reason'
INSERT INTO dbo.AppointmentToAppointmentReason
        ( 
		  AppointmentID ,
          AppointmentReasonID ,
          PrimaryAppointment ,
          ModifiedDate ,
	  --  TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT
          a.AppointmentID , -- AppointmentID - int
          ar.AppointmentReasonID , -- AppointmentReasonID - int
          1 , -- PrimaryAppointment - bit
          GETDATE() , -- ModifiedDate - datetime
	  --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo.Appointment a 
INNER JOIN dbo.[_import_1_1_appointment] i ON
	a.[Subject] = i.appointmentid AND
	a.PracticeID = @PracticeID
INNER JOIN dbo.AppointmentReason ar ON
	i.AppointmentReason = ar.Name 
	AND ar.practiceID = @practiceID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Appointment To Appointment Reason'


PRINT ''
PRINT 'Inserting records into AppointmenttoResource'
INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
      --  TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT 
          a.AppointmentID , -- AppointmentID - int
          CASE WHEN ia.ResourceID = 'Laser and MicroDerm' THEN 2 ELSE 1 END  , -- AppointmentResourceTypeID - int
          CASE ia.ResourceID WHEN 'Laser and MicroDerm' THEN pr.PracticeResourceID  ELSE ia.resourceID  END , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointment] as ia
INNER JOIN dbo.Appointment as a ON
	ia.appointmentid = a.[Subject] AND
	a.PracticeID = @PracticeID
LEFT JOIN dbo.PracticeResource AS pr ON
    pr.ResourceName = ia.ResourceID AND
	pr.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource'


PRINT ''
PRINT'Inserting records into InsurancePolicy Primary'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
     /*   PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,     */
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
          PatientInsuranceStatusID ,   */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
          HolderGender ,
          HolderAddressLine1 ,
      --  HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
       -- HolderPhoneExt ,
          DependentPolicyNumber ,
      --    Notes ,   
          Phone ,
      /*  PhoneExt ,
          Fax ,
          FaxExt ,   */
          Copay ,
      /*  Deductible ,
          PatientInsuranceNumber ,   */
          Active ,
          PracticeID ,
      /*  AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,    */
          VendorID ,
          VendorImportID ,
          --InsuranceProgramTypeID ,
          GroupName 
      /*  ReleaseOfInformation 
          SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patcase.PatientCaseID , -- PatientCaseID - int  
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int 
          1 , -- Precedence - int
          pdp.[1insuranceid] , -- PolicyNumber - varchar(32)
          pdp.[1plangroupno] , -- GroupNumber - varchar(32)
      /*  '' , -- PolicyStartDate - datetime
          '' , -- PolicyEndDate - datetime
          '' , -- CardOnFile - bit    */
          CASE WHEN pdp.[1patientrelationshiptoinsured] = 'child' THEN 'C'
               WHEN pdp.[1patientrelationshiptoinsured] = 'spouse' THEN 'U'
               WHEN pdp.[1patientrelationshiptoinsured] = 'self' THEN 'S'
               WHEN pdp.[1patientrelationshiptoinsured] = 'other' THEN 'O'
               WHEN pdp.[1patientrelationshiptoinsured] = '' THEN 'O'	
			END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN pdp.[1patientrelationshiptoinsured] <> 'SELF' THEN pdp.[1holderfirstname] END, -- HolderFirstName - varchar(64)
          CASE WHEN pdp.[1patientrelationshiptoinsured] <> 'SELF' THEN pdp.[1holdermiddlename] END, -- HolderMiddleName - varchar(64)
          CASE WHEN pdp.[1patientrelationshiptoinsured] <> 'SELF' THEN pdp.[1holderlastname] END, -- HolderLastName -- varchar(64) 
          '' , -- HolderSuffix - varchar(16) 
          CASE WHEN pdp.[1patientrelationshiptoinsured] <> 'SELF' THEN pdp.[1holderdateofbirth] END, -- HolderDOB - datetime
      /*  '' , -- HolderSSN - char(11)
          '' , -- HolderThroughEmployer - bit
          '' , -- HolderEmployerName - varchar(128)
          '' , -- PatientInsuranceStatusID - int    */
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE WHEN pdp.[1patientrelationshiptoinsured] <> 'SELF' THEN pdp.[1holdergender] END, -- HolderGender - char(1)
          CASE WHEN pdp.[1patientrelationshiptoinsured] <> 'SELF' THEN pdp.[1holderaddress] END , -- HolderAddressLine1 - varchar(256)
      --  '' , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pdp.[1patientrelationshiptoinsured] <> 'SELF' THEN pdp.[1holdercity] END, -- HolderCity - varchar(128)
          CASE WHEN pdp.[1patientrelationshiptoinsured] <> 'SELF' THEN pdp.[1holderstate] END, -- HolderState - varchar(2)  
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pdp.[1patientrelationshiptoinsured] <> 'SELF' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.[1holderzipcode],'-','')),9) END, -- HolderZipCode - varchar(9)
          CASE WHEN pdp.[1patientrelationshiptoinsured] <> 'SELF' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.[1holderphone],'-','')),10) END, -- HolderPhone - varchar(10)
         -- '' , -- HolderPhoneExt - varchar(10)
          CASE WHEN pdp.[1patientrelationshiptoinsured] <> 'SELF' THEN [1insuranceid] ELSE '' END , -- DependentPolicyNumber - varchar(32)  
        --  '' , -- Notes - text  
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.[1payerphone],'-','')),10)  , -- Phone - varchar(10)
      /*  '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)   */
          pdp.[1copay] , -- Copay - money
      /*  '' , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32)   */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)      */
          patcase.VendorID + '1' , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  '' , -- InsuranceProgramTypeID - int
          LEFT(pdp.[1GroupName] , 14) -- GroupName - varchar(14)
      /*  '' -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier    */
FROM dbo.[_import_1_1_PatDemoPolicy] as pdp
INNER JOIN dbo.patientcase as patcase ON
       patcase.VendorID = pdp.patientchartnumber AND
	   patcase.VendorImportID = @vendorimportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
       inscoplan.VendorID = pdp.[1payername] AND
	   inscoplan.vendorimportID = @vendorimportID  
WHERE pdp.[1insuranceid] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR ) + ' records inserted into InsurancePolicy Primary'


PRINT ''
PRINT'Inserting records into InsurancePolicy Secondary'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
     /*   PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,     */
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
          PatientInsuranceStatusID ,   */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
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
       --   Notes ,   
          Phone ,
      /*  PhoneExt ,
          Fax ,
          FaxExt ,   */
          Copay ,
      /*  Deductible ,
          PatientInsuranceNumber ,   */
          Active ,
          PracticeID ,
      /*  AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,    */
          VendorID ,
          VendorImportID ,
          --InsuranceProgramTypeID ,
          GroupName 
      /*  ReleaseOfInformation 
          SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patcase.PatientCaseID , -- PatientCaseID - int  
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int 
          2 , -- Precedence - int
          pdp.[2Insuranceid] , -- PolicyNumber - varchar(32)
          pdp.[2plangroupno] , -- GroupNumber - varchar(32)
      /*  '' , -- PolicyStartDate - datetime
          '' , -- PolicyEndDate - datetime
          '' , -- CardOnFile - bit    */
          CASE WHEN pdp.[2PatientRelationshipToInsured]= 'child' THEN 'C'
               WHEN pdp.[2PatientRelationshipToInsured]= 'spouse' THEN 'U'
               WHEN pdp.[2PatientRelationshipToInsured]= 'self' THEN 'S'
               WHEN pdp.[2PatientRelationshipToInsured]= 'other' THEN 'O'
               WHEN pdp.[2PatientRelationshipToInsured]= '' THEN 'O'	  
			END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN pdp.[2PatientRelationshipToInsured]<> 'SELF' THEN pdp.[2holderfirstname] END, -- HolderFirstName - varchar(64)
          CASE WHEN pdp.[2PatientRelationshipToInsured]<> 'SELF' THEN pdp.[2holdermiddlename] END, -- HolderMiddleName - varchar(64)
          CASE WHEN pdp.[2PatientRelationshipToInsured]<> 'SELF' THEN pdp.[2holderlastname] END, -- HolderLastName -- varchar(64) 
          '' , -- HolderSuffix - varchar(16) 
          CASE WHEN pdp.[2PatientRelationshipToInsured]<> 'SELF' THEN pdp.[2holderdateofbirth] END, -- HolderDOB - datetime
      /*  '' , -- HolderSSN - char(11)
          '' , -- HolderThroughEmployer - bit
          '' , -- HolderEmployerName - varchar(128)
          '' , -- PatientInsuranceStatusID - int    */
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE WHEN pdp.[2PatientRelationshipToInsured]<> 'SELF' THEN pdp.[2holdergender] END, -- HolderGender - char(1)
          CASE WHEN pdp.[2PatientRelationshipToInsured]<> 'SELF' THEN pdp.[2holderaddress] END , -- HolderAddressLine1 - varchar(256)
      --  '' , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pdp.[2PatientRelationshipToInsured]<> 'SELF' THEN pdp.[2holdercity] END, -- HolderCity - varchar(128)
          CASE WHEN pdp.[2PatientRelationshipToInsured]<> 'SELF' THEN pdp.[2holderstate] END, -- HolderState - varchar(2)  
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pdp.[2PatientRelationshipToInsured]<> 'SELF' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.[2holderzipcode],'-','')),9) END, -- HolderZipCode - varchar(9)
          CASE WHEN pdp.[2PatientRelationshipToInsured]<> 'SELF' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.[2holderphone],'-','')),10) END, -- HolderPhone - varchar(10)
         -- '' , -- HolderPhoneExt - varchar(10)
          CASE WHEN pdp.[2PatientRelationshipToInsured]<> 'SELF' THEN pdp.[2insuranceid] ELSE NULL END , -- DependentPolicyNumber - varchar(32)  
          --'' , -- Notes - text  
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.[2payerphone],'-','')),10)  , -- Phone - varchar(10)
      /*  '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)   */
          pdp.[2Copay] , -- Copay - money
      /*  '' , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32)   */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)      */
          patcase.VendorID + '2', -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  '' , -- InsuranceProgramTypeID - int
          LEFT(pdp.[2GroupName], 14)  -- GroupName - varchar(14)
      /*  '' -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier    */
FROM dbo.[_import_1_1_PatDemoPolicy] as pdp
INNER JOIN dbo.patientcase as patcase ON
       patcase.VendorID = pdp.patientchartnumber AND
	   patcase.VendorImportID = @vendorimportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
       inscoplan.VendorID = pdp.[2payername] AND
	   inscoplan.vendorimportID = @vendorimportID  
WHERE pdp.[2Insuranceid] <> '' --AND NOT EXISTS (SELECT * FROM dbo.InsurancePolicy as ip where ip.vendorimportid = @vendorimportid)
PRINT CAST(@@ROWCOUNT AS VARCHAR ) + ' records inserted into InsurancePolicy Secondary'
   

PRINT ''
PRINT'Inserting records into InsurancePolicy Tertiary'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
     /*   PolicyStartDate ,
          PolicyEndDate ,
          CardOnFile ,     */
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
          PatientInsuranceStatusID ,   */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
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
      --    Notes ,   
          Phone ,
      /*  PhoneExt ,
          Fax ,
          FaxExt ,   */
          Copay ,
      /*  Deductible ,
          PatientInsuranceNumber ,   */
          Active ,
          PracticeID ,
      /*  AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,    */
          VendorID ,
          VendorImportID ,
          --InsuranceProgramTypeID ,
          GroupName 
      /*  ReleaseOfInformation 
          SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patcase.PatientCaseID , -- PatientCaseID - int  
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int 
          3 , -- Precedence - int
          pdp.[3Insuranceid] , -- PolicyNumber - varchar(32)
          pdp.[3plangroupno] , -- GroupNumber - varchar(32)
      /*  '' , -- PolicyStartDate - datetime
          '' , -- PolicyEndDate - datetime
          '' , -- CardOnFile - bit    */
          CASE WHEN pdp.[3PatientRelationshipToInsured] = 'child' THEN 'C'
               WHEN pdp.[3PatientRelationshipToInsured] = 'spouse' THEN 'U'
               WHEN pdp.[3PatientRelationshipToInsured] = 'self' THEN 'S'
               WHEN pdp.[3PatientRelationshipToInsured] = 'other' THEN 'O'
               WHEN pdp.[3PatientRelationshipToInsured] = '' THEN 'O'	  
			END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN pdp.[3PatientRelationshipToInsured] <> 'SELF' THEN pdp.[3holderfirstname] END, -- HolderFirstName - varchar(64)
          CASE WHEN pdp.[3PatientRelationshipToInsured] <> 'SELF' THEN pdp.[3holdermiddlename] END, -- HolderMiddleName - varchar(64)
          CASE WHEN pdp.[3PatientRelationshipToInsured] <> 'SELF' THEN pdp.[3holderlastname] END, -- HolderLastName -- varchar(64) 
          '' , -- HolderSuffix - varchar(16) 
          CASE WHEN pdp.[3PatientRelationshipToInsured] <> 'SELF' THEN pdp.[3holderdateofbirth] END, -- HolderDOB - datetime
      /*  '' , -- HolderSSN - char(11)
          '' , -- HolderThroughEmployer - bit
          '' , -- HolderEmployerName - varchar(128)
          '' , -- PatientInsuranceStatusID - int    */
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE WHEN pdp.[3PatientRelationshipToInsured] <> 'SELF' THEN pdp.[3holdergender] END, -- HolderGender - char(1)
          CASE WHEN pdp.[3PatientRelationshipToInsured] <> 'SELF' THEN pdp.[3holderaddress] END , -- HolderAddressLine1 - varchar(256)
      --  '' , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pdp.[3PatientRelationshipToInsured] <> 'SELF' THEN pdp.[3holdercity] END, -- HolderCity - varchar(128)
          CASE WHEN pdp.[3PatientRelationshipToInsured] <> 'SELF' THEN pdp.[3holderstate] END, -- HolderState - varchar(2)  
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pdp.[3PatientRelationshipToInsured] <> 'SELF' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.[3holderzipcode],'-','')),9) END, -- HolderZipCode - varchar(9)
          CASE WHEN pdp.[3PatientRelationshipToInsured] <> 'SELF' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.[3holderphone],'-','')),10) END, -- HolderPhone - varchar(10)
   --     '' , -- HolderPhoneExt - varchar(10)
          CASE WHEN pdp.[3PatientRelationshipToInsured] <> 'SELF' THEN pdp.[3insuranceid] ELSE NULL END , -- DependentPolicyNumber - varchar(32)  
   --       '' , -- Notes - text  
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pdp.[3payerphone],'-','')),10)  , -- Phone - varchar(10)
      /*  '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)   */
          CASE WHEN pdp.[3Copay] = 'yes' THEN '' ELSE pdp.[3copay] END , -- Copay - money
      /*  '' , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32)   */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)      */
          patcase.VendorID + '3' , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  '' , -- InsuranceProgramTypeID - int
          LEFT(pdp.[3GroupName] , 14)  -- GroupName - varchar(14)
      /*  '' -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier    */
FROM dbo.[_import_1_1_PatDemoPolicy] as pdp
INNER JOIN dbo.patientcase as patcase ON
       patcase.VendorID = pdp.patientchartnumber AND
	   patcase.VendorImportID = @vendorimportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
       inscoplan.VendorID = pdp.[3payername] AND
	   inscoplan.vendorimportID = @vendorimportID  
WHERE pdp.[3Insuranceid] <> '' --AND NOT EXISTS (SELECT * FROM dbo.InsurancePolicy as ip where ip.vendorimportid = @vendorimportid)
PRINT CAST(@@ROWCOUNT AS VARCHAR ) + ' records inserted into InsurancePolicy Tertiary'   
   
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


