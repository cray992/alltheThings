USE superbill_30202_dev
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
 
---- Clear out any existing records for this import, (makes the script safe to run multiple times)
--PRINT ''
--PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VEndorImportID = @VendorImportID))
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentToAppointmentReason'
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
--DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientJournalNotes'
--DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'
--DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Doctor'
--DELETE FROM dbo.servicelocation WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from servicelocation'
--DELETE FROM dbo.PracticeResource WHERE ResourceName = 'Missing Provider'
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Practice Resource'
--DELETE FROM dbo.AppointmentReason where ModifiedDate > '2014-08-22 11:05:41.000'
--PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Appointment Reason'

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
      --  ContactFirstName ,
      --  ContactMiddleName ,
      --  ContactLastName ,
          ContactSuffix ,
      --  Phone ,
      --  PhoneExt ,
          Fax ,
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
      --  DefaultAdjustmentCode ,
      --  ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT  DISTINCT
          ic.carriername, -- InsuranceCompanyName - varchar(128)
          CASE WHEN ic.noteeligibilityphonenumber = '' THEN '' ELSE 'ELIGIBILITY PHONE NUMBER: ' + ic.noteeligibilityphonenumber + CHAR(10) + CHAR(13) END 
               + (CASE WHEN ic.noteproviderrelationsphonenumber = '' THEN '' ELSE 'PROVIDER RELATION PHONE NUMBER: ' + ic.noteproviderrelationsphonenumber + CHAR(10) + CHAR(13) END )
			   + (CASE WHEN ic.noteemailaddress = '' THEN '' ELSE 'EMAIL ADDRESS: ' + ic.noteemailaddress END ), -- Notes - text
		  ic.address1 , -- AddressLine1 - varchar(256)
          ic.address2 , -- AddressLine2 - varchar(256)
          ic.city , -- City - varchar(128)
          ic.state , -- State - varchar(2) 
          '' , -- Country - varchar(32)
          CASE WHEN LEN(ic.zipcode) = 4 THEN '0' + ic.zipcode ELSE LEFT(ic.zipcode, 9) END , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
      --  '' , -- ContactFirstName - varchar(64)
      --  '' , -- ContactMiddleName - varchar(64)
      --  '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
      --  LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ic.noteproviderrelationsphonenumber,'-','')),10)  , -- Phone - varchar(10)
      --  '' , -- PhoneExt - varchar(10)
          ic.faxnumber , -- Fax - varchar(10)
      --  '' , -- FaxExt - varchar(10) */
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
          ic.carrieruid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  '' , -- DefaultAdjustmentCode - varchar(10)
      --  0 , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_InsuranceCompanies] as ic
where ic.carriername <>''
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
      --  ContactFirstName ,
      --  ContactMiddleName ,
      --  ContactLastName ,
          ContactSuffix ,  
      --  Phone ,
      --  PhoneExt ,
          Notes ,
      --  MM_CompanyID ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
      --  ReviewCode ,
          CreatedPracticeID ,
          Fax ,
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
SELECT 
          InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          State , -- State - varchar(2)
          '' , -- Country - varchar(32)
          Zipcode , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
      /*  '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)  */
          '' , -- ContactSuffix - varchar(16)   
      --  Phone , -- Phone - varchar(10)
      --  '' , -- PhoneExt - varchar(10)
          Notes , -- Notes - text
      --  '' , -- MM_CompanyID - varchar(10)  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          Fax , -- Fax - varchar(10)
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
      --  HomePhone ,
      --  HomePhoneExt ,
          WorkPhone ,
      /*  WorkPhoneExt ,
          PagerPhone ,
          PagerPhoneExt ,
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
     /*   DefaultEncounterTemplateID ,
          TaxonomyCode ,
          DepartmentID ,  */
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          FaxNumberExt ,
      --  OrigReferringPhysicianID , 
          [External] ,
          NPI ,
          ProviderTypeID 
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
          '' , -- MiddleName - varchar(64)
          rp.Lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
      --  '' , -- SSN - varchar(9)
          rp.Address1 , -- AddressLine1 - varchar(256)
          rp.Address2 , -- AddressLine2 - varchar(256)
          rp.City , -- City - varchar(128)
          rp.State , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rp.zipcode,'-','')),9) , -- ZipCode - varchar(9)
      --  '' , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          rp.officephone , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
      --  '' , -- PagerPhone - varchar(10)
      --  '' , -- PagerPhoneExt - varchar(10)
      --  '' , -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  '' , -- DOB - datetime
      --  '' , -- EmailAddress - varchar(256)
          rp.notepracticename , -- Notes - text 
          1 , -- ActiveDoctor - bit  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
     --   NULL , -- RecordTimeStamp - timestamp
     --   0 , -- UserID - int 
          rp.Degree , -- Degree - varchar(8)
      /*  0 , -- DefaultEncounterTemplateID - int
          '' , -- TaxonomyCode - char(10)
          0 , -- DepartmentID - int    */
          rp.referringprovideruid, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          rp.Fax , -- FaxNumber - varchar(10)
          '' , -- FaxNumberExt - varchar(10)
      --  '', -- OrigReferringPhysicianID - int 
          1 ,  -- External - bit
          rp.npinumber , -- NPI - varchar(10)
          rp.referringprovideruid  -- ProviderTypeID - int
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
FROM dbo._import_2_1_ReferringProviders as rp
WHERE rp.firstname <> '' and rp.lastname <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Doctors'

PRINT ''
PRINT 'Inserting Into ServiceLocation'
INSERT INTO dbo.ServiceLocation
        (
    	  PracticeID ,
          Name ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
      --  PlaceOfServiceCode ,
          BillingName ,
          Phone ,
      --  PhoneExt ,
      --  FaxPhone ,
      --  FaxPhoneExt ,
      --  HCFABox32FacilityID ,
      --  CLIANumber ,
      --  RevenueCode ,
          VendorImportID ,
          VendorID 
      --  NPI 
       /* FacilityIDType ,
          TimeZoneID ,
          PayToName ,
          PayToAddressLine1 ,
          PayToAddressLine2 ,
          PayToCity ,
          PayToState ,
          PayToCountry ,
          PayToZipCode ,
          PayToPhone ,
          PayToPhoneExt ,
          PayToFax ,
          PayToFaxExt ,
          EIN ,
          BillTypeID ,
          ServiceLocationGuid */
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          f.facilityname , -- Name - varchar(128)
          f.address1 , -- AddressLine1 - varchar(256)
          f.address2 , -- AddressLine2 - varchar(256)
          f.City , -- City - varchar(128)
          f.State , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(f.zipcode,'-','')),9) , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '', -- PlaceOfServiceCode - char(2) 
          f.facilityname , -- BillingName - varchar(128)
          LEFT(f.officephone, 10) , -- Phone - varchar(10)
      --  '' , -- PhoneExt - varchar(10)
      --  '' , -- FaxPhone - varchar(10)
      --  '' , -- FaxPhoneExt - varchar(10)
      --  '' , -- HCFABox32FacilityID - varchar(50)
      --  '' , -- CLIANumber - varchar(30)
      --  '' , -- RevenueCode - varchar(4)
          @VendorImportID , -- VendorImportID - int
          f.facilityuid  -- VendorID - int
      --  ''  -- NPI - varchar(10)
      /*  0 , -- FacilityIDType - int
          0 , -- TimeZoneID - int
          '' , -- PayToName - varchar(25)
          '' , -- PayToAddressLine1 - varchar(256)
          '' , -- PayToAddressLine2 - varchar(256)
          '' , -- PayToCity - varchar(128)
          '' , -- PayToState - varchar(2)
          '' , -- PayToCountry - varchar(32)
          '' , -- PayToZipCode - varchar(9)
          '' , -- PayToPhone - varchar(10)
          '' , -- PayToPhoneExt - varchar(10)
          '' , -- PayToFax - varchar(10)
          '' , -- PayToFaxExt - varchar(10)
          '' , -- EIN - varchar(9)
          0 , -- BillTypeID - int
          NULL  -- ServiceLocationGuid - uniqueidentifier  */
FROM dbo._import_2_1_facility as f
WHERE f.facilityname <> '' AND f.facilityuid <> 746
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into ServiceLocation'

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
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName , 
          ResponsibleSuffix ,
      --  ResponsibleRelationshipToPatient ,
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
     /*   RecordTimeStamp ,
          EmploymentStatus ,
          InsuranceProgramCode ,
          PatientReferralSourceID ,  
          PrimaryProviderID ,  */
      --  DefaultServiceLocationID ,
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
          ip.title , -- Prefix - varchar(16)
          ip.firstname , -- FirstName - varchar(64)
          ip.middlename , -- MiddleName - varchar(64)
          ip.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          ip.address2 , -- AddressLine1 - varchar(256)
          ip.address1 , -- AddressLine2 - varchar(256)
          ip.city , -- City - varchar(128)
          ip.state , -- State - varchar(2) 
          '' , -- Country - varchar(32)  
		  LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.zipcode,'-','')),9) , -- ZipCode - varchar(9)
          ip.gender , -- Gender - varchar(1)
          ip.maritalstatus , -- MaritalStatus - varchar(1)
          ip.homephone , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.officephone,'-','')),10) , -- WorkPhone - varchar(10)
          ip.officeextension , -- WorkPhoneExt - varchar(10)
          ip.dob , -- DOB - datetime
          ip.ssn , -- SSN - char(9)
          ip.email , -- EmailAddress - varchar(256)
          CASE WHEN ip.relationship = 1 THEN 0 ELSE 1 END , --  ResponsibleDifferentThanPatient - BIT 
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN ip.relationship <> 1 THEN rp.firstname END, -- ResponsibleFirstName - varchar(64)
          CASE WHEN ip.relationship <> 1 THEN rp.middlename END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN ip.relationship <> 1 THEN rp.lastname END , -- ResponsibleLastName - varchar(64)
          '' , -- ResponsibleSuffix - varchar(16)
      --  '' , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN ip.relationship <> 1 THEN rp.address1 END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN ip.relationship <> 1 THEN rp.address2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN ip.relationship <> 1 THEN rp.city END , -- ResponsibleCity - varchar(128)
          CASE WHEN ip.relationship <> 1 THEN rp.state END , -- ResponsibleState - varchar(2)
          '' , -- ResponsibleCountry - varchar(32)
          CASE WHEN ip.relationship <> 1 THEN rp.zipcode END , -- ResponsibleZipCode - varchar(9)
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
          ip.medicalrecordnumber , -- MedicalRecordNumber - varchar(128)
          ip.cell ,  -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  '' , -- PrimaryCarePhysicianID - int
          ip.patientuid, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  0 , -- CollectionCategoryID - int
          ip.active  -- Active - bit
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
FROM dbo.[_import_2_1_patientinfo] as ip
LEFT JOIN dbo._import_2_1_responsibleparties as rp ON
     rp.responsiblepartyuid = ip.responsiblepartyfid
WHERE ip.firstname <> '' AND ip.lastname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully'

PRINT ''
PRINT 'Inserting Into PatientJournalNote' 
INSERT INTO dbo.PatientJournalNote
        (
     	  CreatedDate ,
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
SELECT DISTINCT
          jn.createdate , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- timestamp - timestamp
          pat.PatientID , -- PatientID - int
          jn.createuser, -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
           0 , -- Hidden - bit
          jn.note  -- NoteMessage - varchar(max)  
      --  NULL , -- AccountStatus - bit
      --  0 , -- NoteTypeCode - int
      --  NULL  -- LastNote - bit
FROM dbo._import_2_1_Patientjournalnote as jn
LEFT JOIN dbo.Patient as pat on
        pat.VendorID =  jn.patientfid
    AND pat.PracticeID = @PracticeID
WHERE jn.note <> ''
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
          ModifiedDate 
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
          reason , -- Name - varchar(128)
          GETDATE()  -- ModifiedDate - datetime
FROM dbo._import_2_1_Appointments as ia 
WHERE ia.reason <> '' AND ia.reason <> 'NaN' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ar.Name = ia.reason)

-- I will start making a separate sheet for appointment reasons
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
          CASE WHEN ia.facilityfid = 746 THEN 1 ELSE sl.ServiceLocationID END ,
		  ia.startdate , -- StartDate - datetime
          ia.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          ia.appointmentuid , -- Subject - varchar(64)
          ia.notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          ia.resourcetype, -- AppointmentResourceTypeID - int
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
FROM dbo._import_2_1_Appointments as ia
INNER JOIN dbo.patient AS pat ON
  pat.VendorID = ia.patientfid and --- CHANGED to pat.VendorID
  pat.practiceID = @PracticeID
LEFT JOIN dbo.patientcase AS patcase ON
  patcase.PatientID = pat.PatientID AND
  patcase.VendorImportID = @VendorImportID
LEFT JOIN dbo.ServiceLocation sl ON 
  ia.facilityfid = sl.VendorID AND
  sl.VendorImportID = @VendorImportID
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
FROM dbo._import_2_1_Appointments as ia
INNER JOIN dbo.Patient AS pat ON 
    pat.VendorID = ia.patientfid AND
    pat.VendorImportID = @vendorImportID
INNER JOIN dbo.Appointment AS dboa ON
    dboa.PatientID = pat.PatientID AND  
    dboa.practiceID = @practiceID AND
	dboa.[subject] = ia.appointmentuid AND
    dboa.startdate = CAST(ia.startdate AS DATETIME) AND 
    dboa.enddate = CAST(ia.enddate AS DATETIME) 
INNER JOIN dbo.AppointmentReason AS ar ON 
	ar.name = ia.reason AND 
	ar.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting records into AppointmenttoResource Type 1'
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
          ia.resourcetype , -- AppointmentResourceTypeID - int
          ia.doctorid , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo._import_2_1_Appointments as ia
INNER JOIN dbo.Patient AS pat ON 
    pat.VendorID = ia.patientfid AND
    pat.VendorImportID = @vendorImportID
INNER JOIN dbo.Appointment AS dboa ON
    dboa.PatientID = pat.PatientID AND  
    dboa.practiceID = @practiceID AND
	dboa.[subject] = ia.appointmentuid AND
    dboa.startdate = CAST(ia.startdate AS DATETIME) AND 
    dboa.enddate = CAST(ia.enddate AS DATETIME) 
WHERE ia.resourcetype = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource'


PRINT ''
PRINT 'Inserting records into PracticeResource'
IF NOT EXISTS (SELECT * FROM dbo.PracticeResource WHERE ResourceName = 'Missing Provider')  
INSERT INTO dbo.PracticeResource
        ( PracticeResourceTypeID ,
          PracticeID ,
          ResourceName ,
          ModifiedDate ,
          CreatedDate
        )
VALUES  ( 3 , -- PracticeResourceTypeID - int
          @PracticeID , -- PracticeID - int
          'Missing Provider' , -- ResourceName - varchar(50)
          GETDATE() , -- ModifiedDate - datetime
          GETDATE()  -- CreatedDate - datetime
        )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in PracticeResource'




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
          ia.resourcetype , -- AppointmentResourceTypeID - int
          pr.PracticeResourceID , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo._import_2_1_Appointments as ia
INNER JOIN dbo.Patient AS pat ON 
    pat.VendorID = ia.patientfid AND
    pat.VendorImportID = @vendorImportID
INNER JOIN dbo.Appointment AS dboa ON
    dboa.PatientID = pat.PatientID AND  
    dboa.practiceID = @practiceID AND
	dboa.[subject] = ia.appointmentuid AND
    dboa.startdate = CAST(ia.startdate AS DATETIME) AND 
    dboa.enddate = CAST(ia.enddate AS DATETIME) 
INNER JOIN dbo.PracticeResource pr ON
	pr.ResourceName = 'Missing Provider'
WHERE ia.resourcetype = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource'


PRINT ''
PRINT 'Inserting Into InsurancePolicy ' 
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
      --  HolderThroughEmployer ,
      --  HolderEmployerName ,
      --  PatientInsuranceStatusID ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState , 
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
      --  HolderPhoneExt ,
          DependentPolicyNumber , 
      /*  Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt , */
          Copay ,
          Deductible ,
      --  PatientInsuranceNumber , 
          Active ,
          PracticeID ,
      /*  AdjusterPrefix ,
          AdjusterFirstName ,
          AdjusterMiddleName ,
          AdjusterLastName ,
          AdjusterSuffix ,  */
          VendorID ,
          VendorImportID ,
      --  InsuranceProgramTypeID ,
          GroupName 
      /*  ReleaseOfInformation ,
          SyncWithEHR ,
          InsurancePolicyGuid  */
        )
SELECT DISTINCT
          patcase.patientcaseID , -- PatientCaseID - int
          inscoplan.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          pol.SequenceNumber , -- Precedence - int
          pol.subscriberidnumber , -- PolicyNumber - varchar(32)
          pol.groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(pol.effectivestartdate) = 1 THEN pol.effectivestartdate ELSE NULL END , -- PolicyStartDate - datetime
          CASE WHEN ISDATE(pol.effectiveenddate) = 1 THEN pol.effectiveenddate ELSE NULL END , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit
          CASE WHEN pol.relationshippatienttosubscriber =1 THEN 'S'
		       WHEN     pol.relationshippatienttosubscriber =2 THEN 'U'
		       WHEN     pol.relationshippatienttosubscriber =3 THEN 'C'
		       WHEN     pol.relationshippatienttosubscriber =4 THEN 'O'
                      END  , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN pol.relationshippatienttosubscriber =1 THEN ''
                    ELSE rp.firstname END, -- HolderFirstName - varchar(64)
          CASE WHEN pol.relationshippatienttosubscriber =1 THEN ''
                    ELSE rp.middlename END, -- HolderMiddleName - varchar(64)
          CASE WHEN pol.relationshippatienttosubscriber =1 THEN ''
                    ELSE rp.lastname END, -- HolderLastName -- varchar(64) 
          '' , -- HolderSuffix - varchar(16) 
          CASE WHEN pol.relationshippatienttosubscriber =1 THEN ''
                    ELSE rp.dob END, -- HolderDOB - datetime
          CASE WHEN pol.relationshippatienttosubscriber =1 THEN ''
                    ELSE rp.ssn END, -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      --  '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int  
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE WHEN pol.relationshippatienttosubscriber =1 THEN ''
                    ELSE rp.gender END, -- HolderGender - char(1)
          CASE WHEN pol.relationshippatienttosubscriber =1 THEN ''
                    ELSE rp.address1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN pol.relationshippatienttosubscriber =1 THEN ''
                    ELSE rp.address2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN pol.relationshippatienttosubscriber =1 THEN ''
                    ELSE rp.city END, -- HolderCity - varchar(128)
          CASE WHEN pol.relationshippatienttosubscriber =1 THEN ''
                    ELSE rp.state END, -- HolderState - varchar(2)  
          '' , -- HolderCountry - varchar(32)
          CASE WHEN pol.relationshippatienttosubscriber =1 THEN ''
		            ELSE LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rp.zipcode,'-','')),9) END, -- HolderZipCode - varchar(9)
          CASE WHEN pol.relationshippatienttosubscriber =1 THEN ''
                    ELSE LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rp.homephone,'-','')),10) END, -- HolderPhone - varchar(10)
      --  '' , -- HolderPhoneExt - varchar(10)
          CASE WHEN pol.relationshippatienttosubscriber =1 THEN ''
                    ELSE pol.subscriberidnumber END, -- DependentPolicyNumber - varchar(32)  
      --  '' , -- Notes - text
      --  '' , -- Phone - varchar(10)
      --  '' , -- PhoneExt - varchar(10)
      --  '' , -- Fax - varchar(10)
      --  '' , -- FaxExt - varchar(10) */
          pol.copaydollaramount , -- Copay - money
          pol.annualdeductible  , -- Deductible - money
      --  '' , -- PatientInsuranceNumber - varchar(32)
          pol.active , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)  */
          pol.PatientInsuranceCoverageuid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  0 , -- InsuranceProgramTypeID - int
          LEFT(pol.groupname,14)  -- GroupName - varchar(14)
     /*   '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_2_1_Policy] as pol
LEFT JOIN dbo._import_2_1_responsibleparties as rp ON
         pol.responsiblepartysubscriberfid = rp.responsiblepartyuid
INNER JOIN dbo.patientcase as patcase ON
        patcase.VendorID = pol.patientfid
    AND patcase.practiceID = @practiceID 
	--AND patcase.VendorImportID = @vendorimportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = pol.carrierfid
    AND inscoplan.vendorimportID = @vendorimportID	
WHERE pol.subscriberidnumber <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR ) + ' records inserted into InsurancePolicy'


PRINT '' 
PRINT 'updating patient case with PayerScenarioID'
Update dbo.patientcase set PayerScenarioID=11, name='Self Pay' from dbo.patientcase as patcase 
LEFT JOIN dbo.insurancepolicy as ip ON
ip.patientcaseID = patcase.patientcaseID 
where patcase.VendorImportID = @VendorImportID AND
ip.patientcaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated into patient case '


--ROLLBACK
--COMMIT TRANSACTION
        PRINT 'COMMITTED SUCCESSFULLY'





