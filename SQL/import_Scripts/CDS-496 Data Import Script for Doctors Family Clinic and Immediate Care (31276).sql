USE superbill_31276_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
 

/*
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
          ContactFirstName ,
      /*  ContactMiddleName ,
          ContactLastName ,   */
          ContactSuffix ,
          Phone ,
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
      /*  DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,  */
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
          ic.insurancename , -- InsuranceCompanyName - varchar(128)
     --   '' , -- Notes - text
          ic.addressline1 , -- AddressLine1 - varchar(256)
          ic.addressline2 , -- AddressLine2 - varchar(256)
          ic.city , -- City - varchar(128)
          CASE WHEN  ic.state = 'NULL' THEN '' 
		             ELSE ic.state END, -- State - varchar(2) 				 
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ic.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(ic.zip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ic.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ic.zip)
			   ELSE '' END ,  -- ZipCode - varchar(9)  
          '' , -- ContactPrefix - varchar(16)
          ic.contact , -- ContactFirstName - varchar(64)
      /*  '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64) */
          '' , -- ContactSuffix - varchar(16)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ic.officephone,'-','')),10) , -- Phone - varchar(10)
      --  '' , -- PhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ic.faxphone,' ','')),10) , -- Fax - varchar(10)
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
          ic.insurancecode,-- VendorID - varchar(50)  
          @VendorImportID , -- VendorImportID - int
      --  '' , -- DefaultAdjustmentCode - varchar(10)
      --  0 , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_Insurances] as ic 
WHERE ic.insurancecode <> '' 
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
          ContactFirstName ,
      /*  ContactMiddleName ,
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
SELECT  DISTINCT
          ic.InsuranceCompanyName , -- PlanName - varchar(128)
          ic.AddressLine1 , -- AddressLine1 - varchar(256)
          ic.AddressLine2 , -- AddressLine2 - varchar(256)
          ic.City , -- City - varchar(128)
          ic.State , -- State - varchar(2)
      --  '' , -- Country - varchar(32)
          ic.zipcode , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          ic.ContactFirstName , -- ContactFirstName - varchar(64)
      /*  '' , -- ContactMiddleName - varchar(64)
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
          ic.Fax , -- Fax - varchar(10)
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
      --  MaritalStatus ,
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
      --  PrimaryProviderID ,  
      --  DefaultServiceLocationID ,
      --  EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
      --  MobilePhoneExt ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
      --  CollectionCategoryID ,
          Active 
      --  SendEmailCorrespondence ,
      --  PhonecallRemindersEnabled ,
      --  EmergencyName ,
      --  EmergencyPhone 
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
          ip.firstname , -- FirstName - varchar(64)
          ip.middleinitial , -- MiddleName - varchar(64)
          ip.lastname , -- LastName - varchar(64)
          '' ,  -- Suffix - varchar(16)
          ip.addressline1 , -- AddressLine1 - varchar(256)
          ip.addressline2 , -- AddressLine2 - varchar(256)
          ip.city , -- City - varchar(128)
          CASE WHEN  ip.state = 'NULL' THEN '' 
		             ELSE ip.state END, -- State - varchar(2) , -- State - varchar(2) 
          '' , -- Country - varchar(32) 
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(ip.zip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ip.zip)
			   ELSE '' END	, -- zipcode - varchar(9)	  
          ip.gender , -- Gender - varchar(1)
      --  '' , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.homephone,' ','')),10) , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.officephone,' ','')),10) , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10) */
          ip.birthdate  , -- DOB - datetime
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.ssn)) >= 6 THEN RIGHT ('000' + dbo.fn_RemoveNonNumericCharacters(ip.ssn) , 9) 
               ELSE '' END , -- SSN - char(9)
          ip.email1 , -- EmailAddress - varchar(256) 
          CASE WHEN ip.GuarantorFirstName3 <> '' THEN 1 ELSE 0 END , --  ResponsibleDifferentThanPatient - BIT ,
          CASE WHEN ip.GuarantorFirstName3 <> '' THEN '' END , -- ResponsiblePrefix - varchar(16)
          CASE WHEN ip.GuarantorFirstName3 <> '' THEN ip.GuarantorFirstName3 END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN ip.GuarantorFirstName3 <> '' THEN ip.GuarantorMiddleInitial4  END, -- ResponsibleMiddleName - varchar(64)
          CASE WHEN ip.GuarantorFirstName3 <> '' THEN ip.GuarantorLastName2 END , -- ResponsibleLastName - varchar(64)  
          CASE WHEN ip.GuarantorFirstName3 <> '' THEN '' END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN ip.GuarantorFirstName3 <> '' THEN 'O' END , -- ResponsibleRelationshipToPatient - varchar(1)
          CASE WHEN ip.GuarantorFirstName3 <> '' THEN ip.GuarantorAddressLine110 END, -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN ip.GuarantorFirstName3 <> '' THEN ip.GuarantorAddressLine211 END, -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN ip.GuarantorFirstName3 <> '' THEN ip.GuarantorCity12 END , -- ResponsibleCity - varchar(128)
          CASE WHEN ip.GuarantorFirstName3 <> '' THEN ip.GuarantorState13 END , -- ResponsibleState - varchar(2)  
          CASE WHEN ip.GuarantorFirstName3 <> '' THEN '' END , -- ResponsibleCountry - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.GuarantorZip14)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(ip.GuarantorZip14)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.GuarantorZip14)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ip.GuarantorZip14)
			   ELSE '' END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          'U' , -- EmploymentStatus - char(1)
      --  '' , -- InsuranceProgramCode - char(2)
      --  0  , -- PatientReferralSourceID - int
      --  '' , -- PrimaryProviderID - int
      --  0  , -- DefaultServiceLocationID - int
      --  '' , -- EmployerID - int
          ip.mrn , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.cellphone,' ','')),10) ,  -- MobilePhone - varchar(10) 
      --  '' , -- MobilePhoneExt - varchar(10)
          CASE ip.pcplastname WHEN 'BLACK' THEN 8
							  WHEN 'FYFE' THEN 4
							  WHEN 'LUCERO' THEN 6
							  WHEN 'MCCULLOCH' THEN 7
							  WHEN 'SCHWARTZ' THEN 1 
							  ELSE NULL END  , -- PrimaryCarePhysicianID - int       *******Match PCP to dbo.Doctor
          ip.PatientKey , -- VendorID - varchar(. N50)
          @VendorImportID , -- VendorImportID - int
      --  0 , -- CollectionCategoryID - int
          1  -- Active - bit
      --  NULL , -- SendEmailCorrespondence - bit
      --  NULL , -- PhonecallRemindersEnabled - bit
      --  '' , -- EmergencyName - varchar(128)
      --  ''   -- EmergencyPhone - varchar(10)
      --  '' , -- EmergencyPhoneExt - varchar(10)
      --  NULL , -- PatientGuid - uniqueidentifier
      --  '' , -- Ethnicity - varchar(64)
      --  '' , -- Race - varchar(64)
      --  '' ,  -- LicenseNumber - varchar(64)
      --  '' , -- LicenseState - varchar(2)
      --  '' , -- Language1 - varchar(64)
      --  ''  -- Language2 - varchar(64)
FROM dbo.[_import_1_1_Patients] as ip
--LEFT JOIN dbo.Doctor as doc ON
--     doc.lastname = ip.PCPLastName AND
--	 doc.FirstName = ip.firstname AND
--     doc.[External]=0 
WHERE ip.PatientKey <> '' AND NOT EXISTS  (SELECT FirstName, LastName, DOB FROM dbo.Patient p 
										   WHERE ip.firstname = p.FirstName AND 
												 ip.lastname = p.LastName AND
												 DATEADD(hh,12,CAST(ip.birthdate AS DATETIME)) = p.DOB  AND p.PracticeID = @PracticeID)
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
SELECT 
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.PatientID , -- PatientID - int
          '' , -- UserName - varchar(128)
          'K' , -- SoftwareApplicationID - char(1)
      --  NULL , -- Hidden - bit	
          p.PatientNotes  -- NoteMessage - varchar(max)
      --  NULL , -- AccountStatus - bit
      --  0 , -- NoteTypeCode - int
      --  NULL  -- LastNote - bit
FROM dbo.[_import_1_1_Patients] as p
INNER JOIN dbo.Patient AS pat ON
pat.VendorID = p.patientkey 
AND pat.vendorimportID =@vendorimportID
where p.PatientNotes <> ''
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
          'Created via data import, please review' , -- Notes - text
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
PRINT'Inserting records into InsurancePolicy'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
      /*  PolicyEndDate ,
          CardOnFile ,   */
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
     --   RecordTimeStamp ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState , 
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
      /*  HolderPhoneExt , */
          DependentPolicyNumber , 
          Notes ,
          --Phone ,
      --  PhoneExt ,
      --  Fax ,
      --  FaxExt , 
          Copay ,  
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
          iip.precedence , -- Precedence - int
          iip.policynumber , -- PolicyNumber - varchar(32)
          iip.groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ISDATE(iip.effectivedate) = 1 THEN iip.effectivedate ELSE NULL END , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit    
          CASE iip.relationshiptoinsured WHEN 'CHILD' THEN 'C'
										 WHEN 'SPOUSE' THEN 'U'
										 WHEN 'OTHER' THEN 'O' ELSE 'S'  END , -- PatientRelationshipToInsured - varchar(1) 
         '' , -- HolderPrefix - varchar(16)
         CASE WHEN iip.relationshiptoinsured <> 'Self' THEN iip.insuredfirstname END , -- HolderFirstName - varchar(64)
         CASE WHEN iip.relationshiptoinsured <> 'Self' THEN iip.insuredmiddleinitial END, -- HolderMiddleName - varchar(64)
         CASE WHEN iip.relationshiptoinsured <> 'Self' THEN iip.insuredlastname END , -- HolderLastName - varchar(64)*/
         '' , -- HolderSuffix - varchar(16)
         CASE WHEN iip.relationshiptoinsured <> 'Self' THEN iip.insuredbirthdate END , -- HolderDOB - datetime
         CASE WHEN iip.relationshiptoinsured <> 'Self' THEN iip.insuredssn END , -- HolderSSN - char(11)
      --  NULL , -- HolderThroughEmployer - bit
      -- '' , -- HolderEmployerName - varchar(128)
      --  0 , -- PatientInsuranceStatusID - int  
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          CASE WHEN iip.relationshiptoinsured <> 'Self' THEN iip.insuredgender END , -- HolderGender - char(1)
          CASE WHEN iip.relationshiptoinsured <> 'Self' THEN iip.insuredaddressline1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN iip.relationshiptoinsured <> 'Self' THEN iip.insuredaddressline2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN iip.relationshiptoinsured <> 'Self' THEN iip.insuredcity END , -- HolderCity - varchar(128)
          CASE WHEN iip.relationshiptoinsured <> 'Self' THEN iip.insuredstate END , -- HolderState - varchar(2) */
          '' , -- HolderCountry - varchar(32)
		  CASE WHEN iip.relationshiptoinsured <> 'Self' THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(iip.insuredzip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(iip.insuredzip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(iip.insuredzip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(iip.insuredzip)
			   ELSE '' END END , -- HolderZipCode - varchar(9)
          CASE WHEN iip.relationshiptoinsured <> 'Self' THEN LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(iip.insuredhomephone,' ','')),10) END , -- HolderPhone - varchar(10)
      /*  '' , -- HolderPhoneExt - varchar(10) */
          CASE WHEN iip.relationshiptoinsured <> 'Self' THEN iip.policynumber ELSE '' END , -- DependentPolicyNumber - varchar(32) 
          iip.insurancepolicynotes , -- Notes - text 
          --LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(iip.insuredofficephone,' ','')),10) , -- Phone - varchar(10)
      /*  '' , -- PhoneExt - varchar(10)
          '' , -- Fax - varchar(10)
          '' , -- FaxExt - varchar(10) */
          iip.copayamount , -- Copay - money  
       /* NULL , -- Deductible - money
          '' , -- PatientInsuranceNumber - varchar(32) */
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
      /*  '' , -- AdjusterPrefix - varchar(16)
          '' , -- AdjusterFirstName - varchar(64)
          '' , -- AdjusterMiddleName - varchar(64)
          '' , -- AdjusterLastName - varchar(64)
          '' , -- AdjusterSuffix - varchar(16) */
          iip.Policynumber, -- VendorID - varchar(50)  ****PolicyNumber & PatientKeys has duplicate values 
          @VendorImportID  -- VendorImportID - int
      --  0 , -- InsuranceProgramTypeID - int
      --  ''  -- GroupName - varchar(14)
      /*  '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_1_1_InsurancePolicies] as iip
INNER JOIN dbo.PatientCase AS patcase ON
        patCase.vendorID = iip.patientkeys  AND
        patcase.VendorImportID = @vendorimportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = iip.insurancecode AND 
		inscoplan.VendorImportID = @vendorImportID 
WHERE iip.Policynumber <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted Insurance Policy'


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
      --StandardFee
      INSERT INTO dbo.ContractsAndFees_StandardFee
                  ( StandardFeeScheduleID ,
                    ProcedureCodeID ,
                    --ModifierID ,
                    SetFee ,
                    AnesthesiaBaseUnits
                  )
      SELECT DISTINCT
                    sfs.[StandardFeeScheduleID], -- StandardFeeScheduleID - int
                    pcd.[ProcedureCodeDictionaryID] , -- ProcedureCodeID - int
                    --pm.[ProcedureModifierID] , -- ModifierID - int
                    i.FeeAmount , -- SetFee - money
                    0  -- AnesthesiaBaseUnits - int
      FROM dbo.[_import_1_1_FeeSchedule] AS i
      INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule AS sfs ON
            CAST(sfs.[Notes] AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
            sfs.PracticeID = @PracticeID  
      INNER JOIN dbo.ProcedureCodeDictionary AS pcd ON
            pcd.[ProcedureCode] = i.cptcode
      --LEFT JOIN dbo.ProcedureModifier AS pm ON
      --      pm.[ProcedureModifierCode] = i.modifier1
      WHERE CAST(i.feeamount AS MONEY) > 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Standard Fee Schedule Link...'
      --Standard Fee Schedule Link
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
      WHERE doc.[External] = 0 AND
            doc.[PracticeID] = @PracticeID AND
            sl.PracticeID = @PracticeID AND
            sfs.[Notes] = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
            sfs.PracticeID = @PracticeID    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT '' 
PRINT 'updating patient case with PayerScenarioID'
update dbo.patientcase set PayerScenarioID=11, name='Self Pay' from dbo.patientcase as patcase 
LEFT JOIN dbo.insurancepolicy as ip ON
ip.patientcaseID = patcase.patientcaseID 
where patcase.VendorImportID = @vendorImportID AND
ip.patientcaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated into patient case '

--ROLLBACK
--COMMIT TRANSACTION


