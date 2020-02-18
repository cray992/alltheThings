USE superbill_31450_dev
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

/*
DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentToAppointmentReason'
DELETE FROM dbo.AppointmentReason WHERE PracticeID = @practiceID AND Name = [description]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from AppointmentReason'
DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE practiceID = @PracticeID AND VendorImportID = @VendorImportID))
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from AppointmentToResource '
DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records deleted from  Appointment '
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
DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'
DELETE FROM dbo.Doctor WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Doctor'
*/



PRINT ''
PRINT 'Inserting records into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
       -- Notes ,
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
          il.insuranceplanname, -- InsuranceCompanyName - varchar(128)
      --  '' , -- Notes - text
          CASE WHEN il.insuradd1 = 'NULL' THEN '' ELSE il.insuradd1 END , -- AddressLine1 - varchar(256)
          il.insuradd2 , -- AddressLine2 - varchar(256)
          CASE WHEN il.insurcity = 'NULL' THEN '' ELSE il.insurcity END , -- City - varchar(128)
          CASE WHEN il.insurstate = 'NULL' THEN '' 
		       WHEN il.insurstate = 'ILL'  THEN 'IL' 
			   ELSE il.insurstate END  , -- State - varchar(2)  
          '' , -- Country - varchar(32)
          CASE WHEN il.insurzip = 'NULL' THEN '' ELSE 
		  CASE WHEN LEN(il.insurzip) = 4 THEN '0' + il.insurzip ELSE 
		  LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(il.insurzip,' ','')),9)  END END,  -- ZipCode - varchar(9)  
          '' , -- ContactPrefix - varchar(16)
      /*  '' , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64) */
          '' , -- ContactSuffix - varchar(16)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(il.insurphone,' ','')),10) , -- Phone - varchar(10)
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
          '' , -- ProviderNumberTypeID - int   
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
          il.insurid, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  '' , -- DefaultAdjustmentCode - varchar(10)
      --  0 , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsList] as il
WHERE il.insuranceplanname<>''  
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
     --   Fax ,
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
          SSN ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          HomePhone ,
      --  HomePhoneExt ,
          WorkPhone ,
      --  WorkPhoneExt ,
          PagerPhone ,
      --  PagerPhoneExt ,
          MobilePhone ,
      /*  MobilePhoneExt ,
          DOB ,   
          EmailAddress ,  */ 
          Notes ,   
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      /*  RecordTimeStamp ,
          UserID , 
          Degree ,   */
      --  DefaultEncounterTemplateID ,
      --  TaxonomyCode ,
      --  DepartmentID ,  
          VendorID ,
          VendorImportID ,
          FaxNumber ,
      /*  FaxNumberExt ,
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
          id.First, -- FirstName - varchar(64)
          id.middle , -- MiddleName - varchar(64)
          id.Last , -- LastName - varchar(64)
          id.suffix , -- Suffix - varchar(16)
		  RIGHT( '000'  + id.ssn, 9), -- SSN - varchar(9)
          id.address1 , -- AddressLine1 - varchar(256)
          id.address2 , -- AddressLine2 - varchar(256)
          id.city , -- City - varchar(128)
          id.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(id.zip) = 4 THEN '0' + id.zip ELSE LEFT(id.zip, 9) END ,  -- ZipCode - varchar(9)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(id.homephone,'-','')),10)  , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(id.workphone,'-','')),10)  , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(id.pagerphone,'-','')),10) , -- PagerPhone - varchar(10)
      --  '' , -- PagerPhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(id.mobilephone,'-','')),10) , -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  '' , -- DOB - datetime
      --  '' , -- EmailAddress - varchar(256)
          CASE WHEN id.noteupin = '' THEN '' ELSE 'UPIN: ' + id.noteupin + CHAR(10) + CHAR(13) END 
			   + (CASE WHEN id.noteorgname = '' THEN '' ELSE 'ORGNAME: ' + id.noteorgname + CHAR(10) + CHAR(13) END )
               + (CASE WHEN id.notestatelicenseno = '' THEN '' ELSE 'STATE LICENSE NUMBER:' + id.notestatelicenseno + CHAR(10) + CHAR(13) END )
 			   + (CASE WHEN id.notedotid = '' THEN '' ELSE 'DOTID: ' + id.notedotid + CHAR(10) + CHAR(13) END ) , -- Notes - text 
          1 , -- ActiveDoctor - bit  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
     --   NULL , -- RecordTimeStamp - timestamp
     --   0 , -- UserID - int 
     --   '' , -- Degree - varchar(8) 
     --   0 , -- DefaultEncounterTemplateID - int
     --   '' , -- TaxonomyCode - char(10)
     --   0 , -- DepartmentID - int    
          id.refphysicianid, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(id.fax,'-','')),10)  , -- FaxNumber - varchar(10)
      --  '' , -- FaxNumberExt - varchar(10)
      --  '', -- OrigReferringPhysicianID - int 
          1 ,  -- External - bit
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(id.npi,'-','')),10)  -- NPI - varchar(10)
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
FROM dbo.[_import_1_1_doctor] as id
WHERE id.first <> '' and id.last <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into Doctors'

PRINT ''
PRINT 'Inserting records into patient'
INSERT INTO dbo.Patient
        ( 
		  PracticeID ,
          ReferringPhysicianID ,
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
          HomePhoneExt ,
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
     --   RecordTimeStamp ,
          EmploymentStatus ,
     /*   InsuranceProgramCode ,
          PatientReferralSourceID ,  
          PrimaryProviderID ,  */ 
          DefaultServiceLocationID ,
      --  EmployerID ,   
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
      --  PrimaryCarePhysicianID ,  
          VendorID ,
          VendorImportID ,
      --  CollectionCategoryID ,
          Active ,
      /*  SendEmailCorrespondence ,
          PhonecallRemindersEnabled , 
          EmergencyName ,  */
      /*  PatientGuid ,
          Ethnicity ,
          Race ,
          LicenseNumber 
          LicenseState ,
          Language1 ,
          Language2       */
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
          doc.DoctorID , -- ReferringPhysicianID - int
          pd.prefix , -- Prefix - varchar(16)
          pd.firstname , -- FirstName - varchar(64)
          pd.middlename , -- MiddleName - varchar(64)
          pd.lastname , -- LastName - varchar(64)
          pd.suffix , -- Suffix - varchar(16)
          pd.Address1, -- AddressLine1 - varchar(256)
          pd.Address2 , -- AddressLine2 - varchar(256)
          pd.city , -- City - varchar(128)
          CASE WHEN pd.state = 'KIE' THEN 'KI'
		       WHEN pd.state = 'ONT' THEN 'ON' ELSE pd.state END, -- State - varchar(2) 
          '' , -- Country - varchar(32)  
		  LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.zip,'-','')),9) , -- ZipCode - varchar(9)
          pd.sex , -- Gender - varchar(1)
          CASE pd.maritalstat WHEN 'DIVORCED' THEN 'D'
		   					    WHEN 'MARRIED' THEN 'M'
							    WHEN 'SINGLE' THEN 'S'
							    WHEN 'WIDOWED' THEN 'W'
								WHEN 'Div/Sep' THEN 'L'
								WHEN 'OTHER' THEN ''
								WHEN 'Unknown or other' THEN ''
					 END , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.home,'-','')),10) , -- HomePhone - varchar(10)
          SUBSTRING(pd.home,11,13) , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.work,'-','')),10) , -- WorkPhone - varchar(10)
          SUBSTRING(pd.work,11,15) , -- WorkPhoneExt - varchar(10)   
          pd.birthdate , -- DOB - datetime
          RIGHT( '000'  + pd.patientssn, 9) , -- SSN - char(9)
          pd.emailaddress , -- EmailAddress - varchar(256)
          0 , --  ResponsibleDifferentThanPatient - BIT 
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN pd.resppartfirst <> '' THEN pd.resppartfirst ELSE '' END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN pd.resppartfirst <> '' THEN pd.resppartmiddle ELSE '' END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN pd.resppartfirst <> '' THEN pd.resppartlast ELSE '' END , -- ResponsibleLastName - varchar(64)
          CASE WHEN pd.resppartfirst <> '' THEN pd.resppartsuffix ELSE '' END , -- ResponsibleSuffix - varchar(16)
          CASE pd.guarantorrelationship WHEN 'CHILD' THEN 'C'
			   					 WHEN 'OTHER' THEN 'O'
								 WHEN '' THEN 'O'
								 WHEN 'SPOUSE' THEN 'U' 
							END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN pd.resppartfirst <> '' THEN pd.resppartadd1 ELSE '' END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN pd.resppartfirst <> '' THEN pd.resppartadd2 ELSE '' END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN pd.resppartfirst <> '' THEN pd.resppartcity ELSE '' END , -- ResponsibleCity - varchar(128)
          CASE WHEN pd.resppartfirst <> '' THEN pd.resppartstate ELSE '' END, -- ResponsibleState - varchar(2) 
          '' , -- ResponsibleCountry - varchar(32)
          CASE WHEN pd.resppartfirst <> '' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.resppartzip,'-','')),9) ELSE '' END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
         CASE pd.Employstat WHEN 'Employed' THEN 'E'
		   					      WHEN 'Retired' THEN 'M'
							      ELSE 'U' END , -- EmploymentStatus - char(1)
      /*  '' , -- InsuranceProgramCode - char(2)
          0 , -- PatientReferralSourceID - int
          '', -- PrimaryProviderID - int*/
          1 ,  -- DefaultServiceLocationID - int
     --  '' , -- EmployerID - int     
          pd.chartnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.mobile,'-','')),10),  -- MobilePhone - varchar(10)
          SUBSTRING(pd.mobile,11,14) , -- MobilePhoneExt - varchar(10)
      --  '' , -- PrimaryCarePhysicianID - int    
          pd.chartnumber, -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  0 , -- CollectionCategoryID - int
          CASE WHEN pd.patientstatus = 'Active' THEN 1 ELSE 0 END ,  -- Active - bit
      --  NULL , -- SendEmailCorrespondence - bit
      --  NULL , -- PhonecallRemindersEnabled - bit
      --  '' , -- EmergencyName - varchar(128)
      /*  NULL , -- PatientGuid - uniqueidentifier
          '' , -- Ethnicity - varchar(64)
          '' , -- Race - varchar(64)
          '',  -- LicenseNumber - varchar(64)
          '' , -- LicenseState - varchar(2)
          '' , -- Language1 - varchar(64)
          ''  -- Language2 - varchar(64)       */
FROM dbo.[_import_1_1_PatDemo] as pd
LEFT JOIN dbo.doctor as doc ON
        doc.vendorID = pd.refphysicianid AND
        doc.PracticeID = @practiceID
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
          pd.lastvisitdate , -- EndDate - datetime
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.PatientCase AS patcase        
INNER JOIN dbo.[_import_1_1_PatDemo] as pd ON
      pd.chartnumber = patcase.VendorID AND
	  patcase.VendorImportID = @VendorImportID
WHERE pd.lastvisitdate <>''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into PatientCaseDate'

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
          ia.apptreason , -- Name - varchar(128)
      --  ia.Duration , -- DefaultDurationMinutes - int
      --  0 , -- DefaultColorCode - int
          ia.ApptReason , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
     --   NULL , -- TIMESTAMP - timestamp
     --   NULL  -- AppointmentReasonGuid - uniqueidentifier  
FROM dbo.[_import_1_1_Appointment] as ia 
where ia.ApptReason <> '' AND NOT EXISTS (select * from dbo.AppointmentReason as ar where ar.Name = ia.apptreason  AND PracticeID = @practiceID)
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
          ia.StartDate , -- StartDate - datetime
          ia.EndDate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          ia.PatientVisitId , -- Subject - varchar(64)
          ia.Notes , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          1 , -- AppointmentResourceTypeID - int
          CASE WHEN ia.ApptStatus ='Checked Out' THEN 'O'
		       WHEN ia.ApptStatus ='Cancelled' THEN 'X' ELSE 'N' END , -- AppointmentConfirmationStatusCode - char(1)
      --  NULL , -- AllDay - bit
      --  0 , -- InsurancePolicyAuthorizationID - int
          patcase.PatientCaseID , -- PatientCaseID - int
      --  NULL , -- Recurrence - bit
      --  GETDATE() , -- RecurrenceStartDate - datetime
      --  GETDATE() , -- RangeEndDate - datetime
      --  '' , -- RangeType - char(1)
          dk.DKPracticeID , -- StartDKPracticeID - int
          dk.DKPracticeID , -- EndDKPracticeID - int
          ia.StartTM , -- StartTm - smallint
          ia.EndTM  -- EndTm - smallint
      --  NULL  -- AppointmentGuid - uniqueidentifier
FROM dbo.[_import_1_1_Appointment] as ia 
INNER JOIN dbo.patient AS pat ON
  pat.VendorID = ia.ChartNumber and
  pat.practiceID = @PracticeID
LEFT JOIN dbo.patientcase AS patcase ON
  patcase.patientID = pat.patientID AND
  patcase.VendorImportID = @VendorImportID
INNER JOIN dbo.DateKeyToPractice AS dk ON 
  dk.PracticeID = @PracticeID AND 
  dk.Dt = CAST(CAST(ia.StartDate AS date) AS DATETIME)
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
FROM dbo._import_1_1_Appointment as ia
INNER JOIN dbo.Appointment as dboa ON
     dboa.practiceID = @practiceID AND
     dboa.[subject] = ia.PatientVisitId AND
     dboa.startdate = CAST(ia.startdate AS DATETIME) AND 
     dboa.enddate = CAST(ia.enddate AS DATETIME)  
INNER JOIN dbo.AppointmentReason AS ar ON 
         ar.name = ia.apptreason  
		AND ar.PracticeID = @PracticeID
		--WHERE ia.ApptReason <> '' AND EXISTS (select * from dbo.AppointmentReason as ar where ar.Name = ia.apptreason  AND PracticeID = @practiceID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Appointment To Appointment Reason'

PRINT ''
PRINT 'Inserting records into Appointment to Resource'
INSERT INTO dbo.AppointmentToResource
        ( 
		  AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
      --  TIMESTAMP ,
          PracticeID
        )
SELECT  DISTINCT 
          dboa.AppointmentID , -- AppointmentID - int
          CASE WHEN ia.Resource = 'Sophie Shirin MD' then 1 ELSE 2 END , -- AppointmentResourceTypeID - int
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @practiceID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointment] as ia 
INNER JOIN dbo.Appointment as dboa ON
      ia.PatientVisitId = dboa.[subject] AND
      dboa.PracticeID = @PracticeID AND
	  dboa.startdate = CAST(ia.startdate AS DATETIME) AND 
      dboa.enddate = CAST(ia.enddate AS DATETIME) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in Appointment to Resource'

PRINT ''
PRINT'Inserting records into Insurance Policy'
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
          HolderSSN ,
      --  HolderThroughEmployer ,
      --  HolderEmployerName ,
      --  PatientInsuranceStatusID ,
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
      /*  HolderPhone ,
          HolderPhoneExt ,
          DependentPolicyNumber ,
          Notes ,
          Phone ,
          PhoneExt ,
          Fax ,
          FaxExt ,     
          Copay , 
          Deductible , */
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
          ip.policynumber , -- PolicyNumber - varchar(32)
          ip.GroupNumber , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit
          CASE WHEN ip.subscriberrelationship = 'CHILD' THEN 'C'
		       WHEN ip.subscriberrelationship = 'SELF' THEN 'S'
			   WHEN	ip.subscriberrelationship = 'SPOUSE' THEN 'U'
			   WHEN	ip.subscriberrelationship = 'OTHER' THEN 'O'
					                           ELSE 'O'  END , -- PatientRelationshipToInsured - varchar(1) 
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.subscriberrelationship <> 'S' THEN ip.resppartfirst END, -- HolderFirstName - varchar(64)
          CASE WHEN ip.subscriberrelationship <> 'S' THEN ip.resppartmiddle END , -- HolderMiddleName - varchar(64)
          CASE WHEN ip.subscriberrelationship <> 'S' THEN ip.resppartlast END , -- HolderLastName - varchar(64)
          CASE WHEN ip.subscriberrelationship <> 'S' THEN ip.resppartsuffix END  , -- HolderSuffix - varchar(16)
          CASE WHEN ip.subscriberrelationship <> 'S' THEN ip.resppartbday END, -- HolderDOB - datetime  
          CASE WHEN ip.subscriberrelationship <> 'S'  THEN 
		  CASE WHEN LEN(ip.resppartssn) >= 6 THEN RIGHT ('000' + ip.resppartssn, 9) ELSE '' END END , -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      --  '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  '' , -- HolderGender - char(1)
          CASE WHEN ip.subscriberrelationship <> 'S' THEN ip.resppartadd1 END  , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ip.subscriberrelationship <> 'S' THEN ip.resppartadd2 END  , -- HolderAddressLine2 - varchar(256) 
          CASE WHEN ip.subscriberrelationship <> 'S' THEN ip.resppartcity END   , -- HolderCity - varchar(128)  
          CASE WHEN ip.subscriberrelationship <> 'S' THEN ip.resppartstate END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN ip.subscriberrelationship <> 'S' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.resppartzip,'-','')),9) END  , -- HolderZipCode - varchar(9)
      --  '' , -- HolderPhone - varchar(10)  
      --  '' , -- HolderPhoneExt - varchar(10)
      --  '' , -- DependentPolicyNumber - varchar(32)
      /*  '' , -- Notes - text
          '' , -- Phone - varchar(10)
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)   
          '' , -- Copay - money  
          '' , -- Deductible - money
      --  '' , -- PatientInsuranceNumber - varchar(32) */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)     */
          ip.policynumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  0 , -- InsuranceProgramTypeID - int
      --  '' , -- GroupName - varchar(14)
      --  '' , -- ReleaseOfInformation - varchar(1)
      --  NULL , -- SyncWithEHR - bit
      --  NULL  -- InsurancePolicyGuid - uniqueidentifier
FROM [dbo].[_import_1_1_Policies] as ip
INNER JOIN dbo.PatientCase AS patcase ON 
    patcase.vendorID = ip.chartnumber AND
    patcase.vendorimportID = @vendorimportID     
INNER JOIN dbo.InsuranceCompanyPlan AS inscoplan ON
    inscoplan.VendorID = ip.insurancecarriersid AND
    inscoplan.VendorImportID = @VendorImportID
WHERE ip.policynumber <>'' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into Insurance Policy Successfully'

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
        PRINT 'COMMITTED SUCCESSFULLY'
