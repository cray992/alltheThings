USE superbill_31918_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 3 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))
/*
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted from PatientCase'
DELETE FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS varchar) + ' records deleted from Patient'
*/
SET IDENTITY_INSERT dbo.Patient ON
PRINT ''
PRINT 'Inserting records into patient'
INSERT INTO dbo.Patient
        ( PatientID ,
		  PracticeID ,
       -- ReferringPhysicianID ,
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
      --  EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName , 
          ResponsibleSuffix ,
      /*  ResponsibleRelationshipToPatient ,
          ResponsibleAddressLine1 ,
          ResponsibleAddressLine2 ,
          ResponsibleCity ,
          ResponsibleState ,  */
          --ResponsibleCountry ,
      --  ResponsibleZipCode ,  
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
      --  RecordTimeStamp ,
          EmploymentStatus ,
      --  InsuranceProgramCode ,
      --  PatientReferralSourceID ,   
          PrimaryProviderID ,  
      /*  DefaultServiceLocationID ,
          EmployerID ,   */
          MedicalRecordNumber ,
      --  MobilePhone ,
      --  MobilePhoneExt ,
      --  PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
      --  CollectionCategoryID ,
          Active 
      /*  SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          EmergencyName ,
          EmergencyPhone ,
          EmergencyPhoneExt */
      /*  PatientGuid ,
          Ethnicity ,
          Race ,
          LicenseNumber 
          LicenseState ,
          Language1 ,
          Language2   */
        )
SELECT  DISTINCT 
          ip.patientid , --patientID int
          @PracticeID , -- PracticeID - int
    --    '' , -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          ip.firstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          ip.lastname , -- LastName - varchar(64)
          '' ,  -- Suffix - varchar(16)
          ip.address , -- AddressLine1 - varchar(256)
          ip.address2 , -- AddressLine2 - varchar(256)
          ip.city , -- City - varchar(128)
          ip.state , -- State - varchar(2)
          '' , -- Country - varchar(32) 
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(ip.zip)  
		       WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ip.zip)
			   ELSE '' END	, -- zipcode - varchar(9)	  
          CASE ip.sex WHEN '' THEN 'U' ELSE ip.sex END , -- Gender - varchar(1)
      --  '' , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.homephone,' ','')),10) , -- HomePhone - varchar(10)
      --  '' , -- HomePhoneExt - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(REPLACE(ip.workphone,' ','')),10) , -- WorkPhone - varchar(10)
      --  '' , -- WorkPhoneExt - varchar(10)
          ip.dob  , -- DOB - datetime
		  CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ip.ssn)) >= 6 THEN RIGHT ('000' + dbo.fn_RemoveNonNumericCharacters(ip.ssn) , 9) 
               ELSE '' END , -- SSN - char(9)
      --  '' , -- EmailAddress - varchar(256) 
          CASE WHEN ip.firstname <> ip.guarantorfirstname AND ip.guarantorfirstname <> '' THEN 1 ELSE 0 END , --  ResponsibleDifferentThanPatient - BIT ,
          CASE WHEN ip.firstname <> ip.guarantorfirstname AND ip.guarantorfirstname <> ''THEN '' END, -- ResponsiblePrefix - varchar(16)
          CASE WHEN ip.firstname <> ip.guarantorfirstname AND ip.guarantorfirstname <> ''THEN ip.GuarantorFirstName END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN ip.firstname <> ip.guarantorfirstname AND ip.guarantorfirstname <> ''THEN ip.guarantormiddleinitial END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN ip.firstname <> ip.guarantorfirstname AND ip.guarantorfirstname <> ''THEN ip.Guarantorlastname END , -- ResponsibleLastName - varchar(64) 
          CASE WHEN ip.firstname <> ip.guarantorfirstname AND ip.guarantorfirstname <> ''THEN '' END , -- ResponsibleSuffix - varchar(16)
      /*  '' , -- ResponsibleRelationshipToPatient - varchar(1)
          '' , -- ResponsibleAddressLine1 - varchar(256)
          '' , -- ResponsibleAddressLine2 - varchar(256)
          '' , -- ResponsibleCity - varchar(128)
          '' , -- ResponsibleState - varchar(2)  */
          --'' , -- ResponsibleCountry - varchar(32)
      --  '' , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
      --  NULL , -- RecordTimeStamp - timestamp
          'U' , -- EmploymentStatus - char(1)
      --  '' , -- InsuranceProgramCode - char(2)
      --  0  , -- PatientReferralSourceID - int
          1 , -- PrimaryProviderID - int
      --  0  , -- DefaultServiceLocationID - int
      --  '' , -- EmployerID - int
          ip.mrn , -- MedicalRecordNumber - varchar(128)
      --  '' ,  -- MobilePhone - varchar(10)
      --  '' , -- MobilePhoneExt - varchar(10)
      --  '' , -- PrimaryCarePhysicianID - int
          ip.PatientID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
      --  0 , -- CollectionCategoryID - int
          1  -- Active - bit
      --  NULL , -- SendEmailCorrespondence - bit
      --  NULL , -- PhonecallRemindersEnabled - bit
      --  '' , -- EmergencyName - varchar(128)
      --  '' ,   -- EmergencyPhone - varchar(10)
      --  '' , -- EmergencyPhoneExt - varchar(10)
      --  NULL , -- PatientGuid - uniqueidentifier
      --  '' , -- Ethnicity - varchar(64)
      --  '' , -- Race - varchar(64)
      --  '' ,  -- LicenseNumber - varchar(64)
      --  '' , -- LicenseState - varchar(2)
      --  '' , -- Language1 - varchar(64)
      --  ''  -- Language2 - varchar(64)
FROM dbo.[_import_3_1_Patients] as ip 
WHERE ip.PatientID <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Inserted into patient Successfully'
SET IDENTITY_INSERT dbo.Patient OFF

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
         'Self Pay' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
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

--ROLLBACK
--COMMIT TRANSACTION



