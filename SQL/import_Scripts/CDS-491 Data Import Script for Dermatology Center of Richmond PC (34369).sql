USE superbill_34369_dev
--USE superbill_XXX_prod
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 3

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

/*
DELETE FROM dbo.EncounterDiagnosis WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from EncounterDiagnosis'
DELETE FROM dbo.EncounterProcedure WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from EncounterProcedure'
DELETE FROM dbo.Encounter WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from Encounter'
DECLARE @StandardFeesToNuke TABLE (StandardFeeScheduleID INT )
INSERT INTO @StandardFeesToNuke (StandardFeeScheduleID)
(
       SELECT DISTINCT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule 
       WHERE Notes = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) 
)
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeScheduleLink records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFee records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeSchedule records deleted'
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentToAppointmentReason'
DELETE FROM dbo.AppointmentReason WHERE PracticeID = @practiceID AND Name = [description]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentReason'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from AppointmentToResource '
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from  Appointment '
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientJournalNote WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Journal Note records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Doctor'
*/

SELECT * FROM dbo.Doctor WHERE ActiveDoctor = 1 AND [External] = 0
SELECT * FROM dbo.ServiceLocation

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
          Phone ,
      --  PhoneExt ,
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
          il.patientprimaryinspkgname , -- InsuranceCompanyName - varchar(128)
     --   '' , -- Notes - text
          il.patientprimaryinspkgaddrs1 , -- AddressLine1 - varchar(256)
          il.patientprimaryinspkgaddrs2 , -- AddressLine2 - varchar(256)
          il.patientprimaryinspkgcity , -- City - varchar(128)
          il.patientprimaryinspkgstate , -- State - varchar(2) 				 
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(il.patientprimaryinspkgzip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(il.patientprimaryinspkgzip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(il.patientprimaryinspkgzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(il.patientprimaryinspkgzip)
			   ELSE '' END ,  -- ZipCode - varchar(9)  
          '' , -- ContactPrefix - varchar(16)
      /*  '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64) */
          '' , -- ContactSuffix - varchar(16)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(il.patientprimaryinspkgphn,'-','')),10) , -- Phone - varchar(10) 
      --  '' , -- PhoneExt - varchar(10)
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
          il.VendorID,-- VendorID - varchar(50)  
          @VendorImportID , -- VendorImportID - int
      --  '' , -- DefaultAdjustmentCode - varchar(10)
      --  0 , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM [dbo].[_import_3_1_InsuranceList] as il 
WHERE il.VendorID <> '' 
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
          '' , -- ContactPrefix - varchar(16)
      /*  '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64) */ 
          '' , -- ContactSuffix - varchar(16)  
          ic.Phone , -- Phone - varchar(10)  
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
      /*  '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)
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
          MobilePhone ,
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
          UserID ,
          Degree ,
          DefaultEncounterTemplateID ,
          TaxonomyCode ,
          DepartmentID ,  */
          VendorID ,
          VendorImportID ,
          FaxNumber ,
      /*  FaxNumberExt ,
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
          rp.claimrefprvdrfrstnme , -- FirstName - varchar(64)  
          '' , -- MiddleName - varchar(64)
          rp.claimrefprvdrlstnme , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
     --   '' , -- SSN - varchar(9)
          rp.claimrefprvdraddr , -- AddressLine1 - varchar(256)
          rp.claimrefprvdraddrctd , -- AddressLine2 - varchar(256)
          rp.claimrefprvdrcity , -- City - varchar(128)
          rp.claimrefprvdrstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(rp.claimrefprvdrzip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(rp.claimrefprvdrzip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(rp.claimrefprvdrzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(rp.claimrefprvdrzip)
			   ELSE '' END , -- ZipCode - varchar(9)
     /*   '' , -- HomePhone - varchar(10)
          '' , -- HomePhoneExt - varchar(10)
          '' , -- WorkPhone - varchar(10)   
          '' , -- WorkPhoneExt - varchar(10)
          '' , -- PagerPhone - varchar(10)
          '' , -- PagerPhoneExt - varchar(10)  */
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rp.claimrefprvdrph,' ','')),10) , -- MobilePhone - varchar(10)
     --   '' , -- MobilePhoneExt - varchar(10)
          GETDATE() , -- DOB - datetime
     --   '' , -- EmailAddress - varchar(256)
          CASE WHEN rp.claimrefprvdrnotes = '' THEN '' ELSE 'Notes: ' + rp.claimrefprvdrnotes + CHAR(13) + CHAR(10) END +
		  CASE WHEN rp.claimrefprvdrspclty = '' THEN '' ELSE 'Specialty: ' + rp.claimrefprvdrspclty END , -- Notes - text 
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      /*  NULL , -- RecordTimeStamp - timestamp
          0 , -- UserID - int
	      '' , -- Degree - varchar(8)
          0 , -- DefaultEncounterTemplateID - int
          '' , -- TaxonomyCode - char(10)
          0 , -- DepartmentID - int   */
          rp.claimrefprvdr , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(rp.claimrefprvdrfax,'-','')),10) ,  -- FaxNumber - varchar(10)
     --   '' , -- FaxNumberExt - varchar(10)
     --   0 , -- OrigReferringPhysicianID - int  
          1 , -- External - bit
          rp.claimrefprvdrnpino  -- NPI - varchar(10)
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
FROM dbo.[_import_3_1_referringproviderexport] as rp
where rp.claimrefprvdr <> ''
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
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,  
          ResponsibleCountry ,
          ResponsibleZipCode , 
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
          EmploymentStatus ,
      /*  InsuranceProgramCode ,
          PatientReferralSourceID ,  */
          PrimaryProviderID ,  
          DefaultServiceLocationID ,
      --  EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
      --  MobilePhoneExt ,
      --  PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          --CollectionCategoryID ,
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
SELECT  DISTINCT
          @PracticeID , -- PracticeID - int
      --  doc.DoctorID , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          ip.patientfirstname , -- FirstName - varchar(64)
          ip.patientmiddleinitial , -- MiddleName - varchar(64)
          ip.patientlastname , -- LastName - varchar(64)
          ip.patientnamesuffix ,  -- Suffix - varchar(16)
          ip.patientaddress1 , -- AddressLine1 - varchar(256)
          ip.patientaddress2 , -- AddressLine2 - varchar(256)
          ip.patientcity , -- City - varchar(128)
          ip.patientstate, -- State - varchar(2) , -- State - varchar(2) 
          '' , -- Country - varchar(32) 
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.patientzip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(ip.patientzip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.patientzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ip.patientzip)
			   ELSE '' END	, -- zipcode - varchar(9)	  
          ip.patientsex , -- Gender - varchar(1)
          CASE WHEN ip.patientmaritalstatus='SINGLE' THEN 'S'
		       WHEN ip.patientmaritalstatus='MARRIED' THEN 'M'
			   WHEN ip.patientmaritalstatus='DIVORCED' THEN 'D'
			   WHEN ip.patientmaritalstatus='PARTNER' THEN 'T'
			   WHEN ip.patientmaritalstatus='WIDOWED' THEN 'W'
			   WHEN ip.patientmaritalstatus='SEPARATED' THEN 'L'ELSE '' END , -- MaritalStatus - varchar(1) 
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.patienthomephone,' ','')),10) , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.patientworkphone,' ','')),10) , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10) 
          ip.patientdob  , -- DOB - datetime
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.patientssn)) >= 6 THEN RIGHT ('000' + dbo.fn_RemoveNonNumericCharacters(ip.patientssn) , 9) 
               ELSE '' END , -- SSN - char(9)
          ip.patientemail , -- EmailAddress - varchar(256) 
          CASE WHEN ip.patientfirstname <> ip.guarantorfrstnm THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - BIT ,
          CASE WHEN ip.patientfirstname <> ip.guarantorfrstnm THEN '' END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN ip.patientfirstname <> ip.guarantorfrstnm THEN ip.guarantorfrstnm END  , -- ResponsibleFirstName - varchar(64)
          CASE WHEN ip.patientfirstname <> ip.guarantorfrstnm THEN '' END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN ip.patientfirstname <> ip.guarantorfrstnm THEN ip.guarantorlastnm END  , -- ResponsibleLastName - varchar(64)  
          CASE WHEN ip.patientfirstname <> ip.guarantorfrstnm THEN '' END , -- ResponsibleSuffix - varchar(16) 
          CASE ip.ptntgrntrrltnshp WHEN 'Stepson or Stepdaughter' THEN 'O'
											 WHEN 'Spouse' THEN 'U'
											 ELSE 'S' END , -- ResponsibleRelationshipToPatient - varchar(1) 
          CASE WHEN ip.patientfirstname <> ip.guarantorfrstnm THEN ip.guarantoraddr END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN ip.patientfirstname <> ip.guarantorfrstnm THEN ip.guarantoraddr2 END, -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN ip.patientfirstname <> ip.guarantorfrstnm THEN ip.guarantorcity END , -- ResponsibleCity - varchar(128)
          CASE WHEN ip.patientfirstname <> ip.guarantorfrstnm THEN ip.guarantorstate END , -- ResponsibleState - varchar(2)  
          '' , -- ResponsibleCountry - varchar(32)
          CASE WHEN ip.patientfirstname <> ip.guarantorfrstnm THEN
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.guarantorzip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(ip.guarantorzip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.guarantorzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ip.guarantorzip)
			   END END , -- ResponsibleZipCode - varchar(9) 
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          'U' , -- EmploymentStatus - char(1)
      --  '' , -- InsuranceProgramCode - char(2)
      --  0  , -- PatientReferralSourceID - int
          1 , -- PrimaryProviderID - int
          1  , -- DefaultServiceLocationID - int
      --  '' , -- EmployerID - int
          ip.patientid , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.patientmobileno,' ','')),10) ,  -- MobilePhone - varchar(10) 
      --  '' , -- MobilePhoneExt - varchar(10)
      --  ''  , -- PrimaryCarePhysicianID - int 
	      ip.Patientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  0 , -- CollectionCategoryID - int
          CASE ip.[status] WHEN 'i' THEN 0 ELSE 1 END  , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0 , -- PhonecallRemindersEnabled - bit
          ip.ptntemrgncycntctname + ' | ' + ip.ptntemrgncycntctrltnshp , -- EmergencyName - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.ptntemrgncycntctph,' ','')),10)  -- EmergencyPhone - varchar(10)
      --  '' , -- EmergencyPhoneExt - varchar(10)
      --  NULL , -- PatientGuid - uniqueidentifier
      --  '' , -- Ethnicity - varchar(64)
      --  '' , -- Race - varchar(64)
      --  '' ,  -- LicenseNumber - varchar(64)
      --  '' , -- LicenseState - varchar(2)
      --  '' , -- Language1 - varchar(64)
      --  ''  -- Language2 - varchar(64)
FROM dbo.[_import_3_1_Patientdemoexport] as ip
WHERE ip.Patientid <>'' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully'

PRINT ''
PRINT'Inserting records into PatientJournalNote'
INSERT INTO dbo.PatientJournalNote
        ( CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PatientID ,
          UserName ,
          SoftwareApplicationID ,
      --  Hidden ,
          NoteMessage 
      --  AccountStatus ,
      --  NoteTypeCode ,
      --  LastNote
        )
SELECT DISTINCT
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.PatientID , -- PatientID - int
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
      --  NULL , -- Hidden - bit	
          ip.PatientNotes  -- NoteMessage - varchar(max)
      --  NULL , -- AccountStatus - bit
      --  0 , -- NoteTypeCode - int
      --  NULL  -- LastNote - bit
FROM dbo.[_import_3_1_Patientdemoexport] as ip
INNER JOIN dbo.Patient AS pat ON
     pat.VendorID = ip.patientID AND
     pat.VendorImportID =@VendorImportID
where ip.PatientNotes <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into PatientJournalNote Successfully'

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
          ia.appttype , -- Name - varchar(128)
      --  '' , -- DefaultDurationMinutes - int
      --  0 , -- DefaultColorCode - int
          ia.appttype , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
     --   NULL , -- TIMESTAMP - timestamp
     --   NULL  -- AppointmentReasonGuid - uniqueidentifier  
FROM dbo.[_import_3_1_AppointmentExport] as ia 
where ia.appttype <> '' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ia.appttype = ar.Name) 
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
          1 , -- ServiceLocationID - int
          ia.startdate , -- StartDate - datetime
          ia.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          ia.apptid , -- Subject - varchar(64) 
          ia.apptnote , -- Notes - text               
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          1 , -- AppointmentResourceTypeID - int
          CASE ia.apptstatus WHEN '5 - Check-Out' THEN 'O' 
                             WHEN '1 - Check-In' THEN 'I'      /* None in import file has been taken as 'N' */
               ELSE 'S' END  , -- AppointmentConfirmationStatusCode - char(1)  
      /*  NULL , -- AllDay - bit
          0 , -- InsurancePolicyAuthorizationID - int  */
          patcase.PatientCaseID , -- PatientCaseID - int
      /*  NULL , -- Recurrence - bit
          GETDATE() , -- RecurrenceStartDate - datetime
          GETDATE() , -- RangeEndDate - datetime
          '' , -- RangeType - char(1)   */
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          ia.starttm , -- StartTm - smallint
          ia.endtm  -- EndTm - smallint
      --  NULL  -- AppointmentGuid - uniqueidentifier
FROM dbo.[_import_3_1_AppointmentExport] as ia 
INNER JOIN dbo.patient AS pat ON
  pat.FirstName = ia.patientfirstname AND
  pat.LastName = ia.patientlastname AND
  pat.DOB = DATEADD(hh,12,CAST(ia.patientdob AS DATETIME)) AND
  pat.VendorImportID = @VendorImportID
LEFT JOIN dbo.patientcase AS patcase ON
  pat.patientID = patcase.patientID AND
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
FROM dbo.[_import_3_1_AppointmentExport] as ia 
INNER JOIN dbo.Appointment AS dboa ON
    dboa.[subject] = ia.apptid AND
    dboa.practiceID = @practiceID 
INNER JOIN dbo.AppointmentReason AS ar ON 
     ar.name = ia.appttype AND 
	 ar.PracticeID = @PracticeID
WHERE ia.appttype <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Appointment To Appointment Reason'

PRINT ''
PRINT 'Inserting records into AppointmenttoResource '
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
          dboa.AppointmentResourceTypeID , -- AppointmentResourceTypeID - int
          1 , -- ResourceID - int
		  GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_3_1_AppointmentExport] as ia 
INNER JOIN dbo.Appointment AS dboa ON
       dboa.[subject] = ia.Apptid AND
       dboa.practiceID = @practiceID  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource'



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
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,  
          HolderSuffix ,
          HolderDOB ,
      --  HolderSSN , 
      --  HolderThroughEmployer ,
      --  HolderEmployerName ,
      --  PatientInsuranceStatusID ,  
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
      /*  HolderPhone ,
          HolderPhoneExt , */
          DependentPolicyNumber , 
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
          iip.patientprimarypolicyidnumber , -- PolicyNumber - varchar(32)
          iip.patientprimarypolicygrpnu , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit    
          CASE iip.patientprimaryptnttoins WHEN 'CHILD' THEN 'C'
										  WHEN 'Mother' THEN 'C'
										  WHEN 'SPOUSE' THEN 'U'
										  WHEN 'SELF' THEN 'S' 
										  WHEN 'LIFE PARTNER' THEN 'U' 
										  WHEN 'Unknown' THEN 'O'
										  ELSE 'S'  END , -- PatientRelationshipToInsured - varchar(1) 
         CASE WHEN iip.patientprimaryptnttoins <> 'Self' AND iip.patientprimaryptnttoins <> '' THEN '' END , -- HolderPrefix - varchar(16)
         CASE WHEN iip.patientprimaryptnttoins <> 'Self' AND iip.patientprimaryptnttoins <> '' THEN iip.patientprimaryinshldrfi END , -- HolderFirstName - varchar(64)
         CASE WHEN iip.patientprimaryptnttoins <> 'Self' AND iip.patientprimaryptnttoins <> '' THEN iip.patientprimaryinshldrla END , -- HolderMiddleName - varchar(64)
         CASE WHEN iip.patientprimaryptnttoins <> 'Self' AND iip.patientprimaryptnttoins <> '' THEN iip.patientprimaryinshldrmi END , -- HolderLastName - varchar(64)
         CASE WHEN iip.patientprimaryptnttoins <> 'Self' AND iip.patientprimaryptnttoins <> '' THEN '' END , -- HolderSuffix - varchar(16)
         CASE WHEN iip.patientprimaryptnttoins <> 'Self' AND iip.patientprimaryptnttoins <> '' THEN iip.patientprimaryinshldrdob END , -- HolderDOB - datetime
      -- '' , -- HolderSSN - char(11)
      -- NULL , -- HolderThroughEmployer - bit
      -- '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE WHEN iip.patientprimaryptnttoins <> 'Self' AND iip.patientprimaryptnttoins <> '' THEN iip.patientprimaryinshldrsex END , -- HolderGender - char(1)
          CASE WHEN iip.patientprimaryptnttoins <> 'Self' AND iip.patientprimaryptnttoins <> '' THEN iip.patientprimaryinshldrad END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN iip.patientprimaryptnttoins <> 'Self' AND iip.patientprimaryptnttoins <> '' THEN iip.patientprimaryinshldrad1 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN iip.patientprimaryptnttoins <> 'Self' AND iip.patientprimaryptnttoins <> '' THEN iip.patientprimaryinshldrcity END , -- HolderCity - varchar(128)
          CASE WHEN iip.patientprimaryptnttoins <> 'Self' AND iip.patientprimaryptnttoins <> '' THEN iip.patientprimaryinshldrstate END , -- HolderState - varchar(2) 
          CASE WHEN iip.patientprimaryptnttoins <> 'Self' AND iip.patientprimaryptnttoins <> '' THEN '' END , -- HolderCountry - varchar(32)
		  CASE WHEN iip.patientprimaryptnttoins <> 'Self' AND iip.patientprimaryptnttoins <> '' THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(iip.patientprimaryinshldrzip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(iip.patientprimaryinshldrzip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(iip.patientprimaryinshldrzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(iip.patientprimaryinshldrzip)
			   ELSE '' END END , -- HolderZipCode - varchar(9)
      /*  '' , -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10) */
          CASE WHEN iip.patientprimaryptnttoins <> 'Self' AND iip.patientprimaryptnttoins <> '' THEN iip.patientprimarypolicyidnumber END , -- DependentPolicyNumber - varchar(32) 
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
          iip.patientprimarypolicyidnumber, -- VendorID - varchar(50)  
          @VendorImportID  -- VendorImportID - int
      --  0 , -- InsuranceProgramTypeID - int
      --  ''  -- GroupName - varchar(14)
      /*  '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_3_1_Patientdemoexport] as iip
INNER JOIN dbo.PatientCase AS patcase ON
        patCase.vendorID = iip.patientID  AND
        patcase.VendorImportID = @vendorimportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = iip.PrimaryInsID AND 
		inscoplan.VendorImportID = @vendorImportID 
WHERE iip.patientprimarypolicyidnumber<>'' AND iip.patientpolicyidnumber <> ''
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
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,  
          HolderSuffix ,
          HolderDOB ,
      --  HolderSSN , 
      --  HolderThroughEmployer ,
      --  HolderEmployerName ,
      --  PatientInsuranceStatusID ,  
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
      /*  HolderPhone ,
          HolderPhoneExt , */
          DependentPolicyNumber , 
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
          iip.patientsecondarypolicyidn , -- PolicyNumber - varchar(32)  
          iip.patientsecondarypolicygrp , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit    
          CASE iip.patientsecondaryptnttoi WHEN 'CHILD' THEN 'C'
										  WHEN 'Mother' THEN 'C'
										  WHEN 'SPOUSE' THEN 'U'
										  WHEN 'SELF' THEN 'S' 
										  WHEN 'LIFE PARTNER' THEN 'U' 
										  WHEN 'Unknown' THEN 'O'
										  ELSE 'S'  END  , -- PatientRelationshipToInsured - varchar(1) 
         CASE WHEN iip.patientsecondaryptnttoi <> 'Self' AND iip.patientsecondaryptnttoi <> '' THEN '' END , -- HolderPrefix - varchar(16)
         CASE WHEN iip.patientsecondaryptnttoi <> 'Self' AND iip.patientsecondaryptnttoi <> '' THEN iip.patientsecondaryinshldr4 END , -- HolderFirstName - varchar(64)
         CASE WHEN iip.patientsecondaryptnttoi <> 'Self' AND iip.patientsecondaryptnttoi <> '' THEN iip.patientsecondaryinshldr6 END , -- HolderMiddleName - varchar(64)
         CASE WHEN iip.patientsecondaryptnttoi <> 'Self' AND iip.patientsecondaryptnttoi <> '' THEN iip.patientsecondaryinshldr5 END , -- HolderLastName - varchar(64)
         CASE WHEN iip.patientsecondaryptnttoi <> 'Self' AND iip.patientsecondaryptnttoi <> '' THEN '' END , -- HolderSuffix - varchar(16)
         CASE WHEN iip.patientsecondaryptnttoi <> 'Self' AND iip.patientsecondaryptnttoi <> '' THEN iip.patientsecondaryinshldrdob END , -- HolderDOB - datetime
      -- '' , -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      -- '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE WHEN iip.patientsecondaryptnttoi <> 'Self' AND iip.patientsecondaryptnttoi <> '' THEN iip.patientsecondaryinshldrsex END , -- HolderGender - char(1)
          CASE WHEN iip.patientsecondaryptnttoi <> 'Self' AND iip.patientsecondaryptnttoi <> '' THEN iip.patientsecondaryinshldr END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN iip.patientsecondaryptnttoi <> 'Self' AND iip.patientsecondaryptnttoi <> '' THEN iip.patientsecondaryinshldr2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN iip.patientsecondaryptnttoi <> 'Self' AND iip.patientsecondaryptnttoi <> '' THEN iip.patientsecondaryinshldr3 END , -- HolderCity - varchar(128)
          CASE WHEN iip.patientsecondaryptnttoi <> 'Self' AND iip.patientsecondaryptnttoi <> '' THEN iip.patientsecondaryinshldr7 END , -- HolderState - varchar(2) 
          '' , -- HolderCountry - varchar(32)
		  CASE WHEN iip.patientsecondaryptnttoi <> 'Self' AND iip.patientsecondaryptnttoi <> '' THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(iip.patientsecondaryinshldrzip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(iip.patientsecondaryinshldrzip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(iip.patientsecondaryinshldrzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(iip.patientsecondaryinshldrzip)
			   ELSE '' END END, -- HolderZipCode - varchar(9)
      /*  '' , -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10) */
          CASE WHEN iip.patientsecondaryptnttoi <> 'Self' AND iip.patientsecondaryptnttoi <> '' THEN iip.patientsecondarypolicyidn END , -- DependentPolicyNumber - varchar(32) 
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
          iip.patientsecondarypolicyidn , -- VendorID - varchar(50)  
          @VendorImportID  -- VendorImportID - int
      --  0 , -- InsuranceProgramTypeID - int
      --  ''  -- GroupName - varchar(14)
      /*  '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_3_1_Patientdemoexport] as iip
INNER JOIN dbo.PatientCase AS patcase ON
        patCase.vendorID = iip.patientID  AND
        patcase.VendorImportID = @vendorimportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = iip.SecondaryInsID AND 
		inscoplan.VendorImportID = @vendorImportID 
WHERE iip.SecondaryInsID <> '' --and iip.patientID<>'' and  iip.SecondaryInsID <>'' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted SecondaryInsurancePolicy '


PRINT ''
PRINT 'Inserting into Standard Fee Schedule...'
INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
       ( PracticeID ,
         Name ,
         Notes ,
         EffectiveStartDate ,
         SourceType ,
         SourceFileName ,
         EClaimsNoResponseTrigger ,
         PaperClaimsNoResponseTrigger ,
         MedicareFeeScheduleGPCICarrier ,
         MedicareFeeScheduleGPCILocality ,
         MedicareFeeScheduleGPCIBatchID ,
         MedicareFeeScheduleRVUBatchID ,
         AddPercent ,
         AnesthesiaTimeIncrement
         )
VALUES  
        ( 
         @PracticeID , -- PracticeID - int
         'Default Contract' , -- Name - varchar(128)
         'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
         GETDATE() , -- EffectiveStartDate - datetime
         'F' , -- SourceType - char(1)
         'Import File' , -- SourceFileName - varchar(256)
         30 , -- EClaimsNoResponseTrigger - int
         30 , -- PaperClaimsNoResponseTrigger - int
         NULL , -- MedicareFeeScheduleGPCICarrier - int
         NULL , -- MedicareFeeScheduleGPCILocality - int
         NULL , -- MedicareFeeScheduleGPCIBatchID - int
         NULL , -- MedicareFeeScheduleRVUBatchID - int
         0 , -- AddPercent - decimal
         15  -- AnesthesiaTimeIncrement - int
         )
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Standard Fee...'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
      --  ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT DISTINCT
          sfs.[StandardFeeScheduleID], -- StandardFeeScheduleID - int
          pcd.[ProcedureCodeDictionaryID] , -- ProcedureCodeID - int
      --  '' , -- ModifierID - int
          i.FeeSchedule  , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_3_1_FeeSchedule] AS i
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule AS sfs ON
        CAST(sfs.[Notes] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
        sfs.PracticeID = @PracticeID  
INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
        pcd.[ProcedureCode] = i.cpt
WHERE CAST(i.FeeSchedule AS MONEY) > 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Standard Fee Schedule Link...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
          )
SELECT DISTINCT
          doc.[DoctorID] , -- ProviderID - int
          sl.[ServiceLocationID] , -- LocationID - int
          sfs.[StandardFeeScheduleID]  -- StandardFeeScheduleID - int
FROM dbo.Doctor AS doc, dbo.ServiceLocation AS sl, dbo.ContractsAndFees_StandardFeeSchedule AS sfs
WHERE doc.[External] = 1 AND
      doc.[PracticeID] = @PracticeID AND
      sl.PracticeID = @PracticeID AND
      sfs.[Notes] = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
      sfs.PracticeID = @PracticeID    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
          Pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  NULL , -- PregnancyRelatedFlag - bit
      --  NULL , -- StatementActive - bit
      --  NULL , -- EPSDT - bit
      --  NULL , -- FamilyPlanning - bit
      --  0 , -- EPSDTCodeID - int
      --  NULL , -- EmergencyRelated - bit
      --  NULL  -- HomeboundRelatedFlag - bit
FROM dbo.patient as pat 
INNER JOIN dbo.[_import_3_1_Patientdemoexport] AS ip ON
	   pat.VendorID = ip.Patientid 
   AND pat.vendorImportID = @VendorImportID 
   -- pat.vendorImportID = @vendorImportID 
WHERE ip.patientoutstanding <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted into patientcase- Balance Forward'

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
          patcase.PatientID , -- PatientID - int
          1 , -- DoctorID - int
      --  '' , -- AppointmentID - int
          1 , -- LocationID - int
      --  '' , -- PatientEmployerID - int
          GETDATE() , -- DateOfService - datetime
          GETDATE() , -- DateCreated - datetime
          Convert(Varchar(10), GETDATE(),101) + ': Balance Forward' , -- Notes - text
          2 , -- EncounterStatusID - int
     --   '' , -- AdminNotes - text
     --   '' , -- AmountPaid - money
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
      --  '' , -- ReferringPhysicianID - int
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
      --  app.startdate , -- AppointmentStartDate - datetime
      --  '' , -- BatchID - varchar(50)
      --  0 , -- SchedulingProviderID - int
          0 , -- DoNotSendElectronicSecondary - bit
      --  0 , -- PaymentCategoryID - int
          0 , -- overrideClosingDate - bit
      --  '' , -- Box10d - varchar(40)
          0 , -- ClaimTypeID - int
     /*   0 , -- OperatingProviderID - int
     --   0 , -- OtherProviderID - int
     --   0 , -- PrincipalDiagnosisCodeDictionaryID - int
     --   0 , -- AdmittingDiagnosisCodeDictionaryID - int
     --   0 , -- PrincipalProcedureCodeDictionaryID - int
     --   0 , -- DRGCodeID - int
     --   GETDATE() , -- ProcedureDate - datetime
     --   0 , -- AdmissionTypeID - int
     --   GETDATE() , -- AdmissionDate - datetime
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
      /*    '' , -- DocumentControlNumberCMS1500 - varchar(26)
          '' , -- DocumentControlNumberUB04 - varchar(26)
          '' , -- EDIClaimNoteReferenceCodeCMS1500 - char(3)
          '' , -- EDIClaimNoteReferenceCodeUB04 - char(3)
          '' , -- EDIClaimNoteCMS1500 - varchar(1600)
          '' , -- EDIClaimNoteUB04 - varchar(1600)
          NULL , -- EncounterGuid - uniqueidentifier      */
          0  -- PatientCheckedIn - bit
     --   ''  -- RoomNumber - varchar(32)
FROM dbo.PatientCase AS patcase
WHERE patcase.Name = 'Balance Forward' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Encounter' 

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
     --   RecordTimeStamp ,
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
      --  NULL , -- RecordTimeStamp - timestamp
          ip.patientoutstanding , -- ServiceChargeAmount - money   
          '1.000' , -- ServiceUnitCount - decimal
     /*   '' , -- ProcedureModifier1 - varchar(16)
          '' , -- ProcedureModifier2 - varchar(16)
          '' , -- ProcedureModifier3 - varchar(16)
          '' , -- ProcedureModifier4 - varchar(16)   */
          GETDATE() , -- ProcedureDateOfService - datetime
          @PracticeID , -- PracticeID - int
          ed.EncounterDiagnosisID , -- EncounterDiagnosisID1 - int
     /*   0 , -- EncounterDiagnosisID2 - int
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
     /*   ''  , -- StartTime - datetime
          '' , -- EndTime - datetime   */
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
INNER JOIN [dbo].[_import_3_1_patientdemoexport] as ip ON 
   ip.patientID = enc.vendorID 
    AND enc.PracticeID = @PracticeID 
--where ip.patientoutstanding <>''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into EncounterProcedure'

PRINT '' 
PRINT 'updating patient case with PayerScenarioID'
update dbo.patientcase set PayerScenarioID=11, name='Self Pay' from dbo.patientcase as patcase 
LEFT JOIN dbo.insurancepolicy as ip ON
ip.patientcaseID = patcase.patientcaseID 
where patcase.VendorImportID = @vendorImportID AND
ip.patientcaseID IS NULL AND patcase.Name <> 'Balance Forward'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated into patient case '



--ROLLBACK
--COMMIT TRANSACTION


