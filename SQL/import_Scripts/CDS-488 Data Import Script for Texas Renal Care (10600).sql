USE superbill_10600_dev
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
DELETE FROM dbo.PracticeResource WHERE PracticeID=@PracticeID AND ModifiedDate > DATEADD(d, -5, GETDATE())
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from practice resource'
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
PRINT 'Updating Existing Patient Records with MRN...'
UPDATE dbo.Patient SET medicalrecordnumber = pd.medicalrecordnumber FROM dbo.Patient AS pat
INNER JOIN dbo.[_import_1_1_PatientDemographics] as pd ON
    pd.firstname = pat.firstname AND
    pd.lastname = pat.lastname AND
    DATEADD(hh,12,CAST(pd.dateofbirth AS DATETIME)) = pat.DOB 
WHERE pat.medicalrecordnumber = '' OR pat.MedicalRecordNumber IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Updated into patient Successfully '   


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
      /*  AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          HomePhone , */
      --  HomePhoneExt ,
      --  WorkPhone ,
      --  WorkPhoneExt ,
      --  PagerPhone ,
     /*   PagerPhoneExt ,
          MobilePhone ,
          MobilePhoneExt ,
          DOB ,
          EmailAddress ,  */
      --  Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
      --  UserID ,
      --  Degree ,
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
          pd.primarycarefirstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          pd.primarycarelastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
      /*  '' , -- SSN - varchar(9)
          '' , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          '' , -- City - varchar(128)
          '' , -- State - varchar(2)
          '' , -- Country - varchar(32)
          '' , -- ZipCode - varchar(9)
          '' , -- HomePhone - varchar(10)
          '' , -- HomePhoneExt - varchar(10)
          '' , -- WorkPhone - varchar(10)   */
      --  '' , -- WorkPhoneExt - varchar(10)
      --  '' , -- PagerPhone - varchar(10)
      --  '' , -- PagerPhoneExt - varchar(10)
      --  '' , -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  GETDATE() , -- DOB - datetime
      --  '' , -- EmailAddress - varchar(256)
      --  '' , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      --  0 , -- UserID - int
	  --  '' , -- Degree - varchar(8)
      --  0 , -- DefaultEncounterTemplateID - int
      --  '' , -- TaxonomyCode - char(10)
      --  0 , -- DepartmentID - int
          pd.primarycarefirstname+pd.primarycarelastname , -- VendorID - varchar(50)
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
FROM dbo.[_import_1_1_PatientDemographics] as pd
where pd.primarycarefirstname <>'' OR pd.primarycarelastname <>'' 
AND NOT EXISTS (SELECT * FROM dbo.Doctor d WHERE pd.primarycarefirstname = d.FirstName AND 
												 pd.primarycarelastname = d.LastName AND
												 d.[External] = 1)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into Doctor'


PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
		  AddressLine1 ,
		  AddressLine2 ,
		  City ,
		  State ,
		  ZipCode ,
		  Country ,
		  Phone ,
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
		  insurancename ,
		  insaddr1 ,
		  insaddr2 ,
		  inscity ,
		  insstate ,
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(inszip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(inszip)
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(inszip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(inszip) 
		  ELSE '' END ,
		  '' ,
		  RIGHT(insphone ,10) ,
          0 ,
          0 ,
          13 ,
          'CI' ,
          'C' ,
          'D' ,
          @PracticeID ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          13 ,
          LEFT(insurancename ,50) ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18
FROM dbo.[_import_1_1_InsList]
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
		  AddressLine1 ,
		  AddressLine2 ,
		  City ,
		  State ,
		  ZipCode ,
		  Country ,
		  Phone ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  InsuranceCompanyName ,
		  AddressLine1 ,
		  AddressLine2 ,
		  City ,
		  State ,
		  ZipCode ,
		  Country ,
		  Phone ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          @PracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          @VendorImportID 
FROM dbo.InsuranceCompany 
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
      --  WorkPhone ,
      --  WorkPhoneExt ,
          DOB ,
          SSN ,
      --  EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
     /*   ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName , */
          ResponsibleSuffix ,
      --  ResponsibleRelationshipToPatient ,
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
          PatientReferralSourceID ,  */
      --  PrimaryProviderID ,  
      --  DefaultServiceLocationID ,
      --  EmployerID ,
          MedicalRecordNumber ,
      --  MobilePhone ,
      --  MobilePhoneExt ,
          PrimaryCarePhysicianID ,
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
          @PracticeID , -- PracticeID - int
      --  '' , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          pd.firstname , -- FirstName - varchar(64)
          pd.middlename , -- MiddleName - varchar(64)
          pd.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pd.addr1 , -- AddressLine1 - varchar(256)
          pd.addr2 , -- AddressLine2 - varchar(256)
          pd.city , -- City - varchar(128)
          pd.state , -- State - varchar(2) 
          '' , -- Country - varchar(32)  
		  CASE WHEN LEN(pd.zip) = 4 THEN '0' + pd.zip ELSE 
		  LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.zip,'-','')),9)  END, -- ZipCode - varchar(9)
          CASE pd.gender  WHEN 'FEMALE' THEN 'F'
                          WHEN 'MALE' THEN 'M'
                          ELSE 'U' END , -- Gender - varchar(1)
          CASE WHEN pd.maritalstatus = 'MARRIED' THEN 'M'
		       WHEN pd.maritalstatus = 'Domestic Partner' THEN 'T' 
			   WHEN pd.maritalstatus = 'Legally Separated' THEN 'L'
			   WHEN pd.maritalstatus = 'DIVORCED' THEN 'D'
			   WHEN pd.maritalstatus = 'WIDOWED' THEN 'W'
			   WHEN pd.maritalstatus = 'SINGLE' THEN 'S'
			   WHEN pd.maritalstatus = '' THEN '' END , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(pd.phonenumber,'-','')),10) , -- HomePhone - varchar(10)
      /*  '' , -- HomePhoneExt - varchar(10)
          '' , -- WorkPhone - varchar(10)
          '' , -- WorkPhoneExt - varchar(10)  */
          CASE WHEN ISDATE(pd.dateofbirth) = 1 THEN pd.dateofbirth ELSE NULL END , -- DOB - datetime 
          CASE WHEN LEN(pd.ssn) >= 6 THEN RIGHT('000' + pd.ssn, 9) ELSE '' END , -- SSN - char(9)
      --  '' , -- EmailAddress - varchar(256)
          0	 , --  ResponsibleDifferentThanPatient - BIT 
          '' , -- ResponsiblePrefix - varchar(16)
      /*  '' , -- ResponsibleFirstName - varchar(64)
          '' , -- ResponsibleMiddleName - varchar(64)
          '' , -- ResponsibleLastName - varchar(64)  */
          '' , -- ResponsibleSuffix - varchar(16)
      --  '' , -- ResponsibleRelationshipToPatient - varchar(1)
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
          '' , -- PrimaryProviderID - int
          '' , -- DefaultServiceLocationID - int
          '' , -- EmployerID - int   */
          pd.medicalrecordnumber , -- MedicalRecordNumber - varchar(128)  
      /*  '',  -- MobilePhone - varchar(10)
          '' , -- MobilePhoneExt - varchar(10)  */
          doc.DoctorID , -- PrimaryCarePhysicianID - int  
          pd.medicalrecordnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      --  '' , -- CollectionCategoryID - int  
      --  '' , -- Active - bit
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
FROM dbo.[_import_1_1_PatientDemographics] as pd
LEFT JOIN dbo.Doctor AS doc ON
    pd.primarycarefirstname + pd.primarycarelastname = doc.VendorID AND
	doc.VendorImportID = @VendorImportID
where pd.medicalrecordnumber <> '' AND NOT EXISTS (select * from  dbo.patient p where p.MedicalRecordNumber = pd.medicalrecordnumber)
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
SELECT  DISTINCT
          pat.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
      /*  0 , -- ReferringPhysicianID - int
          NULL , -- EmploymentRelatedFlag - bit
          NULL , -- AutoAccidentRelatedFlag - bit
          NULL , -- OtherAccidentRelatedFlag - bit
          NULL , -- AbuseRelatedFlag - bit
          '' , -- AutoAccidentRelatedState - char(2)  */
          'Created via data import, please review' , -- Notes - text
      --  NULL , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
      /*  '' , -- CaseNumber - varchar(128)
          0 , -- WorkersCompContactInfoID - int  */
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      /*  NULL , -- PregnancyRelatedFlag - bit
          NULL , -- StatementActive - bit
          NULL , -- EPSDT - bit
          NULL , -- FamilyPlanning - bit
          0 , -- EPSDTCodeID - int
          NULL , -- EmergencyRelated - bit
          NULL  -- HomeboundRelatedFlag - bit  */
FROM dbo.Patient as pat
WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted into patientcase'


PRINT ''
PRINT 'Inserting Into InsurancePolicy' 
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
    --    CardOnFile ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
      /*  HolderFirstName ,
          HolderMiddleName ,
          HolderLastName , */
          HolderSuffix ,
      /*  HolderDOB ,
          HolderSSN ,
          HolderThroughEmployer ,
          HolderEmployerName ,
          PatientInsuranceStatusID ,  */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      /*  RecordTimeStamp ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState , 
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt ,
          DependentPolicyNumber , 
          Notes ,
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
          CASE WHEN pd.insrank = 'Primary' THEN  1
               WHEN pd.insrank = 'Secondary' THEN  2 
			   WHEN pd.insrank = 'Tertiary' THEN 3 END , -- Precedence - int
          pd.policyid , -- PolicyNumber - varchar(32)
          pd.groupid , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(pd.planeffectivedate) = 1 THEN pd.planeffectivedate ELSE NULL END , -- PolicyStartDate - datetime 
          CASE WHEN ISDATE(pd.planexpirationdate) = 1 THEN pd.planexpirationdate ELSE NULL END, -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit
          'S' , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
      /*  '' , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          '', -- HolderLastName - varchar(64) */
          '' , -- HolderSuffix - varchar(16)
      /*  '' , -- HolderDOB - datetime
          '' , -- HolderSSN - char(11)
          NULL , -- HolderThroughEmployer - bit
          '' , -- HolderEmployerName - varchar(128)
          0 , -- PatientInsuranceStatusID - int   */
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
      /*  '' , -- HolderGender - char(1)
          '' , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          '' , -- HolderCity - varchar(128)
          '' , -- HolderState - varchar(2)  
          '' , -- HolderCountry - varchar(32)  
          '' , -- HolderZipCode - varchar(9)
          '' , -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10)
          '' , -- DependentPolicyNumber - varchar(32)
          '' , -- Notes - text    
          '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10)
          '' , -- Copay - money
          '' , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32)  */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16)  */
          patcase.VendorID + pd.policyid , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
      /*  0 , -- InsuranceProgramTypeID - int
          '' , -- GroupName - varchar(14)
          '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_1_1_PatientDemographics] as pd
INNER JOIN dbo.patientcase as patcase ON
        patcase.VendorID = pd.medicalrecordnumber  AND
        patcase.VendorImportID = @VendorImportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = LEFT(pd.insurancename,50)  AND
		inscoplan.VendorImportID = @vendorImportID 
WHERE pd.policyid <> '' AND pd.insrank <> '' AND pd.insurancename<>'' AND pd.medicalrecordnumber<>''
PRINT CAST(@@ROWCOUNT AS VARCHAR ) + ' records inserted into InsurancePolicy'


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
          ia.reason , -- Name - varchar(128)
      --  '' , -- DefaultDurationMinutes - int
      --  0 , -- DefaultColorCode - int
          ia.reason , -- Description - varchar(256)
          GETDATE()  -- ModifiedDate - datetime
     --   NULL , -- TIMESTAMP - timestamp
     --   NULL  -- AppointmentReasonGuid - uniqueidentifier  
FROM dbo.[_import_1_1_Appointment] as ia 
where ia.reason <> '' AND NOT EXISTS (SELECT * FROM dbo.AppointmentReason ar WHERE ia.reason = ar.Name)
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
       --   Notes ,
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
          CASE WHEN ia.officelocation = 'BAYLOR/ CARROLLTON OFFICE' THEN 4
		       WHEN ia.officelocation = 'FRISCO- OFFICE' THEN 14
			   WHEN ia.officelocation = 'GREENVILLE OFFICE' THEN 11
			   WHEN ia.officelocation = 'HIGHLAND VILLAGE DIALYSIS' THEN 21
               WHEN ia.officelocation = 'McKinney' THEN 10 END , -- ServiceLocationID - int
          ia.startdate , -- StartDate - datetime
          ia.enddate , -- EndDate - datetime
          'P' , -- AppointmentType - varchar(1)
          ia.appointmentid , -- Subject - varchar(64) 
      --    ia.notes , -- Notes - text               
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          1 , -- AppointmentResourceTypeID - int
          'S' , -- AppointmentConfirmationStatusCode - char(1)
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
FROM dbo.[_import_1_1_Appointment] as ia 
INNER JOIN dbo.patient AS pat ON
  pat.MedicalRecordNumber = ia.medicalrecordnumber and
  pat.practiceID = @PracticeID
LEFT JOIN dbo.patientcase AS patcase ON
  patcase.patientID = pat.patientID AND
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
FROM dbo.[_import_1_1_Appointment] as ia 
INNER JOIN dbo.Appointment AS dboa ON
    dboa.practiceID = @practiceID  AND
	dboa.[subject] = ia.appointmentid 
INNER JOIN dbo.AppointmentReason AS ar ON 
     ar.name = ia.reason AND 
	 ar.PracticeID = @PracticeID
WHERE ia.reason <> ''
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
          CASE WHEN ia.providername = 'Butt, Salman' THEN 3 
               WHEN ia.providername = 'Ijaz, Adeel' THEN 2 
			   WHEN ia.providername = 'Kazi, Fareha' THEN 189 END , -- ResourceID - int
		  GETDATE() , -- ModifiedDate - datetime
      --  NULL , -- TIMESTAMP - timestamp
          @PracticeID  -- PracticeID - int
FROM dbo.[_import_1_1_Appointment] as ia 
INNER JOIN dbo.patient as pat ON
       pat.MedicalRecordNumber = ia.medicalrecordnumber AND
	   pat.PracticeID = @PracticeID
INNER JOIN dbo.Appointment AS dboa ON
       dboa.practiceID = @practiceID  AND
	   dboa.[subject] = ia.appointmentid
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records inserted in AppointmenttoResource'

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