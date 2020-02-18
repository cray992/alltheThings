USE superbill_35589_dev
--USE superbill_35589_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 2 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Patient Zip...'
UPDATE dbo.Patient 
SET ZipCode = CASE WHEN LEN(REPLACE(i.zip,'-','')) IN (4,8) THEN '0' + REPLACE(i.zip,'-','')
				   ELSE REPLACE(i.zip,'-','') END	
FROM dbo.Patient p  
INNER JOIN dbo.[_import_2_1_patientdemoforKareo217201] i ON
	i.patientaccountnumber = p.VendorID AND
	p.VendorImportID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( PracticeID ,
          ReferringPhysicianID ,
          Prefix ,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          AddressLine1 ,
     --   AddressLine2 ,
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
      --  EmailAddress ,
          ResponsibleDifferentThanPatient ,
      --  ResponsibleFirstName ,
      --  ResponsibleMiddleName ,
      --  ResponsibleLastName , 
      /*  ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,  
          ResponsibleCountry ,
          ResponsibleZipCode , */
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
          EmploymentStatus ,
          --InsuranceProgramCode ,
          --PatientReferralSourceID ,  
      --  PrimaryProviderID ,  
      --  DefaultServiceLocationID ,
      --  EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
      --  PrimaryCarePhysicianID ,
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
          doc.doctorID , -- ReferringPhysicianID - int  
          '' , -- Prefix - varchar(16)
          pd.patientfirstname , -- FirstName - varchar(64)
          pd.mi , -- MiddleName - varchar(64)
          pd.patientlastname , -- LastName - varchar(64)
          '' ,  -- Suffix - varchar(16)
          pd.patientstreetaddress , -- AddressLine1 - varchar(256)
     --   '' , -- AddressLine2 - varchar(256)
          pd.city , -- City - varchar(128)
          pd.state, -- State - varchar(2) , -- State - varchar(2) 
          '' , -- Country - varchar(32) 
          CASE WHEN LEN(REPLACE(pd.zip,'-','')) IN (4,8) THEN '0' + REPLACE(pd.zip,'-','')
			   ELSE REPLACE(pd.zip,'-','') END	, -- zipcode - varchar(9)	  
          CASE pd.sex WHEN '0' THEN 'U' ELSE pd.sex END , -- Gender - varchar(1)
          CASE pd.maritalstatus WHEN '0' THEN '' ELSE pd.maritalstatus END , -- MaritalStatus - varchar(1) 
          LEFT(pd.homephone,10) , -- HomePhone - varchar(10)
          CASE
		  WHEN LEN(pd.homephone) > 10 THEN LEFT(SUBSTRING(pd.homephone,11,LEN(pd.homephone)),10)
		  ELSE NULL END , -- HomePhoneExt - varchar(10)
          LEFT(pd.workphone,10) , -- WorkPhone - varchar(10)
          CASE
		  WHEN LEN(pd.workphone) > 10 THEN LEFT(SUBSTRING(pd.workphone,11,LEN(pd.workphone)),10)
		  ELSE NULL END, -- WorkPhoneExt - varchar(10) */
          pd.dob  , -- DOB - datetime
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(pd.ssn)) >= 6 THEN RIGHT ('000' + dbo.fn_RemoveNonNumericCharacters(pd.ssn) , 9) 
               ELSE '' END , -- SSN - char(9)
      --  '' , -- EmailAddress - varchar(256) 
          0 , -- ResponsibleDifferentThanPatient - BIT ,
      --  '' , -- ResponsibleFirstName - varchar(64)
      --  '' , -- ResponsibleMiddleName - varchar(64)
      --  '' , -- ResponsibleLastName - varchar(64)  
      /*  '' , -- ResponsibleRelationshipToPatient - varchar(1) 
          '' , -- ResponsibleAddressLine1 - varchar(256)
          '' , -- ResponsibleAddressLine2 - varchar(256)
          '' , -- ResponsibleCity - varchar(128)
          '' , -- ResponsibleState - varchar(2)  
          '' , -- ResponsibleCountry - varchar(32)
          '' , -- ResponsibleZipCode - varchar(9) */
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
          pd.patientaccountnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(pd.cellphone,10) ,  -- MobilePhone - varchar(10) 
          CASE
		  WHEN LEN(pd.cellphone) > 10 THEN LEFT(SUBSTRING(pd.cellphone,11,LEN(pd.cellphone)),10)
		  ELSE NULL END , -- MobilePhoneExt - varchar(10)
      --  ''  , -- PrimaryCarePhysicianID - int 
          pd.patientaccountnumber , -- VendorID - varchar(. N50)
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
      --  '' , -- LicenseNumber - varchar(64)
      --  '' , -- LicenseState - varchar(2)
      --  '' , -- Language1 - varchar(64)
      --  '' , -- Language2 - varchar(64)
FROM dbo.[_import_2_1_patientdemoforKareo217201] as pd
LEFT JOIN dbo.Doctor as doc on
      doc.vendorid = pd.refphys AND
      doc.vendorimportid = 1
WHERE pd.patientaccountnumber <> '' AND NOT EXISTS (SELECT * FROM dbo.Patient p WHERE p.VendorID = pd.patientaccountnumber)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully'

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          ReferringPhysicianID ,
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
          pat.ReferringPhysicianID  , -- ReferringPhysicianID - int  
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
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted into patientcase'

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
     /*   HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,  */
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
     --   RecordTimeStamp ,
      /*  HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState , */
          HolderCountry ,
      /*  HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt , 
          DependentPolicyNumber , */
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
          pd.primarypolicy , -- PolicyNumber - varchar(32)
          pd.primarygroup , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit    
          'S' , -- PatientRelationshipToInsured - varchar(1) 
          '' , -- HolderPrefix - varchar(16)
      /*  '' , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          '' , -- HolderLastName - varchar(64)  */
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
      --  NULL , -- RecordTimeStamp - timestamp
      /*  '' , -- HolderGender - char(1)
          '' , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          '' , -- HolderCity - varchar(128)
          '' , -- HolderState - varchar(2) */
          '' , -- HolderCountry - varchar(32)
      /*  '' , -- HolderZipCode - varchar(9)
          '' , -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10) 
          '' , -- DependentPolicyNumber - varchar(32) */
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
          pd.primarypolicy, -- VendorID - varchar(50)  
          @VendorImportID  -- VendorImportID - int
      --  0 , -- InsuranceProgramTypeID - int
      --  ''  -- GroupName - varchar(14)
      /*  '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_2_1_patientdemoforKareo217201] as pd
INNER JOIN dbo.PatientCase AS patcase ON
        patCase.vendorID = pd.patientaccountnumber  AND
        patcase.VendorImportID = @vendorimportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = pd.primaryinsuranceco AND 
		inscoplan.VendorImportID = 1 
WHERE pd.primarypolicy <> ''
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
     /*   HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,  */
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
     --   RecordTimeStamp ,
      /*  HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState , */
          HolderCountry ,
      /*  HolderZipCode ,
          HolderPhone ,
          HolderPhoneExt , 
          DependentPolicyNumber , */
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
          pd.secondarypolicy , -- PolicyNumber - varchar(32)
          pd.secondarygroup , -- GroupNumber - varchar(32)
      --  '' , -- PolicyStartDate - datetime
      --  '' , -- PolicyEndDate - datetime
      --  NULL , -- CardOnFile - bit    
          'S' , -- PatientRelationshipToInsured - varchar(1) 
          '' , -- HolderPrefix - varchar(16)
      /*  '' , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          '' , -- HolderLastName - varchar(64)  */
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
      --  NULL , -- RecordTimeStamp - timestamp
      /*  '' , -- HolderGender - char(1)
          '' , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          '' , -- HolderCity - varchar(128)
          '' , -- HolderState - varchar(2) */
          '' , -- HolderCountry - varchar(32)
      /*  '' , -- HolderZipCode - varchar(9)
          '' , -- HolderPhone - varchar(10)
          '' , -- HolderPhoneExt - varchar(10) 
          '' , -- DependentPolicyNumber - varchar(32) */
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
          pd.secondarypolicy, -- VendorID - varchar(50)  
          @VendorImportID  -- VendorImportID - int
      --  0 , -- InsuranceProgramTypeID - int
      --  ''  -- GroupName - varchar(14)
      /*  '' , -- ReleaseOfInformation - varchar(1)
          NULL , -- SyncWithEHR - bit
          NULL  -- InsurancePolicyGuid - uniqueidentifier */
FROM dbo.[_import_2_1_patientdemoforKareo217201] as pd
INNER JOIN dbo.PatientCase AS patcase ON
        patCase.vendorID = pd.patientaccountnumber  AND
        patcase.VendorImportID = @vendorimportID
INNER JOIN dbo.insurancecompanyplan as inscoplan ON
        inscoplan.VendorID = pd.secondaryinsuranceco AND 
		inscoplan.VendorImportID = 1 
WHERE pd.secondarypolicy <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted SecondaryInsurancePolicy '

PRINT '' 
PRINT 'updating patient case with PayerScenarioID'
update dbo.patientcase set PayerScenarioID=11, name='Self Pay' from dbo.patientcase as patcase 
LEFT JOIN dbo.insurancepolicy as ip ON
ip.patientcaseID = patcase.patientcaseID 
where patcase.VendorImportID = @vendorImportID AND
ip.patientcaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated into patient case '

--COMMIT
--ROLLBACK