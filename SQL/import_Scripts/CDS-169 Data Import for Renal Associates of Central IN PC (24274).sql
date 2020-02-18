USE superbill_24274_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Purging existing records in detination tables for VendorImport ' + CAST(@@ROWCOUNT AS VARCHAR(10)) 

DECLARE @StandardFeesToNuke TABLE (StandardFeeScheduleID INT )
INSERT INTO @StandardFeesToNuke (StandardFeeScheduleID)
(
	SELECT DISTINCT StandardFeeScheduleID FROM dbo.ContractsAndFees_StandardFeeSchedule 
	WHERE Notes = 'Vendor Import ' +  CAST(@VendorImportID AS VARCHAR) 
)
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeScheduleLink records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFee WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFee records deleted'
DELETE FROM dbo.ContractsAndFees_StandardFeeSchedule WHERE StandardFeeScheduleID IN (SELECT StandardFeeScheduleID FROM @StandardFeesToNuke)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' StandardFeeSchedule records deleted'
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID AND [External] = 1
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'
DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'




PRINT ''
PRINT'Inserting Into Employers'
INSERT INTO dbo.Employers
        ( EmployerName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  imp.name , -- EmployerName - varchar(128)
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
		  CASE WHEN LEN(imp.zipcode) IN (3,7) THEN '00' + imp.zipcode 
			   WHEN LEN(imp.zipcode) IN (4,8) THEN '0' + imp.zipcode
			   WHEN LEN(imp.zipcode) IN (5,9) THEN imp.zipcode ELSE '' END  , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_1_1_Address] imp
WHERE EXISTS (SELECT * FROM dbo.[_import_1_1_Patient] imppat WHERE imppat.employercode = imp.code) AND imp.name <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Referring Doctors...'
INSERT INTO dbo.Doctor
        ( PracticeID ,
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
          WorkPhone ,
          WorkPhoneExt ,
          PagerPhone ,
          MobilePhone ,
          EmailAddress ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Degree ,
          VendorID ,
          VendorImportID ,
          FaxNumber ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          imp.firstname , -- FirstName - varchar(64)
          imp.middleinitial , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
		  CASE WHEN LEN(imp.zipcode) IN (3,7) THEN '00' + imp.zipcode 
			   WHEN LEN(imp.zipcode) IN (4,8) THEN '0' + imp.zipcode
			   WHEN LEN(imp.zipcode) IN (5,9) THEN imp.zipcode ELSE '' END  , -- ZipCode - varchar(9)
          imp.phone , -- WorkPhone - varchar(10)
          imp.extension , -- WorkPhoneExt - varchar(10)
          imp.pagerphone , -- PagerPhone - varchar(10)
          imp.mobilephone , -- MobilePhone - varchar(10)
          imp.workemail , -- EmailAddress - varchar(256)
          CASE WHEN imp.insurancecode1 <> '' THEN 'InsuranceCode1: ' + imp.insurancecode1 + ' / ' + 'InsuranceCode2: ' + imp.insurancecode2
			   ELSE '' END, -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          impref.degree , -- Degree - varchar(8)
          imp.code , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          imp.fax , -- FaxNumber - varchar(10)
          1 , -- External - bit
          imp.natprovidentifier  -- NPI - varchar(10)
FROM dbo.[_import_1_1_Address] imp
	LEFT JOIN dbo.[_import_1_1_ReferringProv] impref ON
		impref.code = imp.code
WHERE EXISTS (SELECT * FROM dbo.[_import_1_1_Patient] imppat where imppat.refphysiciancode = imp.code) OR EXISTS (SELECT * FROM dbo.[_import_1_1_Patient] imppat2 WHERE imppat2.primarycareprovide = imp.code)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into InsuranceCompany...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Phone ,
          PhoneExt ,
          Fax ,
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
		  imp.name , -- InsuranceCompanyName - varchar(128)
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(imp.zipcode) IN (3,7) THEN '00' + imp.zipcode 
			   WHEN LEN(imp.zipcode) IN (4,8) THEN '0' + imp.zipcode
			   WHEN LEN(imp.zipcode) IN (5,9) THEN imp.zipcode ELSE '' END  , -- ZipCode - varchar(9)
          imp.phone , -- Phone - varchar(10)
          imp.extension , -- PhoneExt - varchar(10)
          imp.fax , -- Fax - varchar(10)
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
          imp.code , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_Insurance] imp
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          Phone ,
          PhoneExt ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          Fax ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          [State] , -- State - varchar(2)
          Country , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          Phone , -- Phone - varchar(10)
          PhoneExt , -- PhoneExt - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          Fax , -- Fax - varchar(10)
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Insert into Patient...'
INSERT INTO dbo.Patient
        ( PracticeID ,
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
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active ,
          EmergencyName ,
          EmergencyPhone 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          CASE WHEN imp.refphysiciancode <> '' THEN doc.doctorid ELSE NULL END, -- ReferringPhysicianID - int
          '' , -- Prefix - varchar(16)
          imp.firstname , -- FirstName - varchar(64)
          imp.middleinitial , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          imp.suffix , -- Suffix - varchar(16)
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(imp.zipcode) IN (3,7) THEN '00' + imp.zipcode 
			   WHEN LEN(imp.zipcode) IN (4,8) THEN '0' + imp.zipcode
			   WHEN LEN(imp.zipcode) IN (5,9) THEN imp.zipcode ELSE '' END , -- ZipCode - varchar(9)
          CASE imp.sex WHEN '' THEN 'U' ELSE imp.sex END , -- Gender - varchar(1)
          imp.maritalstatus , -- MaritalStatus - varchar(1)
          imp.homephone , -- HomePhone - varchar(10)
          imp.workphone , -- WorkPhone - varchar(10)
          imp.workextension , -- WorkPhoneExt - varchar(10)
          imp.birthdate , -- DOB - datetime
          CASE WHEN LEN(imp.socialsecurity) >= 6 THEN RIGHT('000' + imp.socialsecurity, 9)
		  ELSE '' END , -- SSN - char(9)
          imp.homeemail , -- EmailAddress - varchar(256)
          CASE WHEN imp.responsibleis <> 1 THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN imp.responsibleis <> 1 THEN gua.firstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN imp.responsibleis <> 1 THEN gua.middleinitial END , -- ResponsibleMiddleName - varchar(64)
          CASE WHEN imp.responsibleis <> 1 THEN gua.lastname END , -- ResponsibleLastName - varchar(64)
          CASE WHEN imp.responsibleis <> 1 THEN gua.suffix END , -- ResponsibleSuffix - varchar(16)
          CASE WHEN imp.responsibleis <> 1 THEN 'O' END , -- ResponsibleRelationshipToPatient - varchar(1)
		  CASE WHEN imp.responsibleis <> 1 THEN gua.address1 END , -- ResponsibleAddressLine1 - varchar(256)
          CASE WHEN imp.responsibleis <> 1 THEN gua.address2 END , -- ResponsibleAddressLine2 - varchar(256)
          CASE WHEN imp.responsibleis <> 1 THEN gua.city END , -- ResponsibleCity - varchar(128)
          CASE WHEN imp.responsibleis <> 1 THEN gua.[state] END , -- ResponsibleState - varchar(2)
          CASE WHEN imp.responsibleis <> 1 THEN '' END , -- ResponsibleCountry - varchar(32)
          CASE WHEN imp.responsibleis <> 1 THEN gua.zipcode END , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE imp.employmentstatus WHEN 'R' THEN 'R'
									WHEN 'F' THEN 'E'
									ELSE 'U' END , -- EmploymentStatus - char(1)
          CASE imp.providercode WHEN 'RRS' THEN 2
								WHEN 'ROBIN0000' THEN 3
								ELSE NULL END , -- PrimaryProviderID - int                                          
          1 , -- DefaultServiceLocationID - int
          employ.EmployerID , -- EmployerID - int
          imp.chartnumber , -- MedicalRecordNumber - varchar(128)
          imp.mobilephone , -- MobilePhone - varchar(10)
          CASE WHEN imp.primarycareprovide <> '' THEN doc2.DoctorID ELSE NULL END, -- PrimaryCarePhysicianID - int
          imp.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
          imp.contactname , -- EmergencyName - varchar(128)
          LEFT(imp.contactphone, 10)  -- EmergencyPhone - varchar(10)
FROM dbo.[_import_1_1_Patient] imp
LEFT JOIN dbo.Doctor doc ON 
	imp.refphysiciancode = doc.VendorID 
LEFT JOIN dbo.Doctor doc2 ON
	imp.primarycareprovide = doc2.VendorID
LEFT JOIN dbo.[_import_1_1_Guarantor] gua ON
	imp.responsiblepartyguarantor = gua.code
LEFT JOIN dbo.[_import_1_1_Address] emp ON 
	emp.code = imp.employercode
LEFT JOIN dbo.Employers employ ON
	employ.EmployerName = emp.name
WHERE imp.firstname <> '' AND imp.status <> 'D'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into PatientCase...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          PregnancyRelatedFlag ,
          StatementActive ,
          EPSDT ,
          FamilyPlanning ,
          EPSDTCodeID ,
          EmergencyRelated ,
          HomeboundRelatedFlag
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient 
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into InsurancePolicy 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          imp.primarypolicy , -- PolicyNumber - varchar(32)
          imp.primarygroup , -- GroupNumber - varchar(32)
          CASE WHEN imp.primaryinsuranceeffectivedatefrom <> '' THEN imp.primaryinsuranceeffectivedatefrom ELSE NULL END  , -- PolicyStartDate - datetime
          CASE imp.primaryinsrelation WHEN 1 THEN 'S' 
									  WHEN 2 THEN 'U'
									  WHEN 3 THEN 'C'
									  WHEN 9 THEN 'O'
									  ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN imp.primaryinsrelation <> 1 THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN imp.primaryinsrelation <> 1 THEN gua.firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN imp.primaryinsrelation <> 1 THEN gua.middleinitial END , -- HolderMiddleName - varchar(64)
          CASE WHEN imp.primaryinsrelation <> 1 THEN gua.lastname END , -- HolderLastName - varchar(64)
          CASE WHEN imp.primaryinsrelation <> 1 THEN gua.suffix END , -- HolderSuffix - varchar(16)
          CASE WHEN imp.primaryinsrelation <> 1 THEN CASE WHEN ISDATE(gua.birthdate) = 1 THEN gua.birthdate ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN imp.primaryinsrelation <> 1 THEN gua.socialsecurity END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.primaryinsrelation <> 1 THEN CASE gua.sex WHEN '' THEN 'U' ELSE gua.sex END END , -- HolderGender - char(1)
          CASE WHEN imp.primaryinsrelation <> 1 THEN gua.address1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN imp.primaryinsrelation <> 1 THEN gua.address2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN imp.primaryinsrelation <> 1 THEN gua.city END , -- HolderCity - varchar(128)
          CASE WHEN imp.primaryinsrelation <> 1 THEN gua.[state] END , -- HolderState - varchar(2)
          CASE WHEN imp.primaryinsrelation <> 1 THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN imp.primaryinsrelation <> 1 THEN gua.zipcode END , -- HolderZipCode - varchar(9)
          CASE WHEN imp.primaryinsrelation <> 1 THEN gua.homephone END , -- HolderPhone - varchar(10)
          CASE WHEN imp.primaryinsrelation <> 1 THEN imp.primarypolicy END , -- DependentPolicyNumber - varchar(32)
          CASE WHEN dbo.fn_RemoveNonNumericCharacters(imp.copay) <> 'Y' THEN dbo.fn_RemoveNonNumericCharacters(imp.copay) END , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_Patient] imp
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorID = imp.chartnumber AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = imp.primarycode AND
		icp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.[_import_1_1_Guarantor] gua ON
		imp.primaryinsuredguarantor = gua.code
WHERE imp.primarycode <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into InsurancePolicy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          imp.secondarypolicy , -- PolicyNumber - varchar(32)
          imp.secondarygroup , -- GroupNumber - varchar(32)
          CASE WHEN imp.secondaryinsuranceeffectivedatefrom <> '' THEN imp.secondaryinsuranceeffectivedatefrom ELSE NULL END  , -- PolicyStartDate - datetime
          CASE imp.secondaryinsredis WHEN 1 THEN 'S' 
									  WHEN 2 THEN 'U'
									  WHEN 3 THEN 'C'
									  WHEN 9 THEN 'O'
									  ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN imp.secondaryinsredis <> 1 THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN imp.secondaryinsredis <> 1 THEN gua.firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN imp.secondaryinsredis <> 1 THEN gua.middleinitial END , -- HolderMiddleName - varchar(64)
          CASE WHEN imp.secondaryinsredis <> 1 THEN gua.lastname END , -- HolderLastName - varchar(64)
          CASE WHEN imp.secondaryinsredis <> 1 THEN gua.suffix END , -- HolderSuffix - varchar(16)
          CASE WHEN imp.secondaryinsredis <> 1 THEN CASE WHEN ISDATE(gua.birthdate) = 1 THEN gua.birthdate ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN imp.secondaryinsredis <> 1 THEN gua.socialsecurity END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.secondaryinsredis <> 1 THEN CASE gua.sex WHEN '' THEN 'U' ELSE gua.sex END END , -- HolderGender - char(1)
          CASE WHEN imp.secondaryinsredis <> 1 THEN gua.address1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN imp.secondaryinsredis <> 1 THEN gua.address2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN imp.secondaryinsredis <> 1 THEN gua.city END , -- HolderCity - varchar(128)
          CASE WHEN imp.secondaryinsredis <> 1 THEN gua.[state] END , -- HolderState - varchar(2)
          CASE WHEN imp.secondaryinsredis <> 1 THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN imp.secondaryinsredis <> 1 THEN gua.zipcode END , -- HolderZipCode - varchar(9)
          CASE WHEN imp.secondaryinsredis <> 1 THEN gua.homephone END , -- HolderPhone - varchar(10)
          CASE WHEN imp.secondaryinsredis <> 1 THEN imp.secondarypolicy END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_Patient] imp
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorID = imp.chartnumber AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = imp.secondarycode AND
		icp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.[_import_1_1_Guarantor] gua ON
		imp.secondaryinsuredguarantor = gua.code
WHERE imp.secondarycode <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into InsurancePolicy 3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          HolderSSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          imp.tertiarypolicy , -- PolicyNumber - varchar(32)
          imp.tertiarygroup , -- GroupNumber - varchar(32)
          CASE WHEN imp.tertiaryinsuranceeffectivedatefrom <> '' THEN imp.tertiaryinsuranceeffectivedatefrom ELSE NULL END  , -- PolicyStartDate - datetime
          CASE imp.tertiaryinsredis WHEN 1 THEN 'S' 
									  WHEN 2 THEN 'U'
									  WHEN 3 THEN 'C'
									  WHEN 9 THEN 'O'
									  ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN gua.firstname END , -- HolderFirstName - varchar(64)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN gua.middleinitial END , -- HolderMiddleName - varchar(64)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN gua.lastname END , -- HolderLastName - varchar(64)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN gua.suffix END , -- HolderSuffix - varchar(16)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN CASE WHEN ISDATE(gua.birthdate) = 1 THEN gua.birthdate ELSE NULL END END , -- HolderDOB - datetime
          CASE WHEN imp.tertiaryinsredis <> 1 THEN gua.socialsecurity END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.tertiaryinsredis <> 1 THEN CASE gua.sex WHEN '' THEN 'U' ELSE gua.sex END END , -- HolderGender - char(1)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN gua.address1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN gua.address2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN gua.city END , -- HolderCity - varchar(128)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN gua.[state] END , -- HolderState - varchar(2)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN gua.zipcode END , -- HolderZipCode - varchar(9)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN gua.homephone END , -- HolderPhone - varchar(10)
          CASE WHEN imp.tertiaryinsredis <> 1 THEN imp.tertiarypolicy END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_Patient] imp
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorID = imp.chartnumber AND
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = imp.secondarycode AND
		icp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.[_import_1_1_Guarantor] gua ON
		imp.tertiaryinsredis = gua.code
WHERE imp.tertiarycode <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Standard Fee Schedule...'
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
VALUES  ( @PracticeID , -- PracticeID - int
          'Standard Fees' , -- Name - varchar(128)
          'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) , -- Notes - varchar(1024)
          '2013-01-01 07:00:00' , -- EffectiveStartDate - datetime
          'F' , -- SourceType - char(1)
          'Import File' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          NULL , -- MedicareFeeScheduleGPCICarrier - int
          NULL , -- MedicareFeeScheduleGPCILocality - int
          NULL , -- MedicareFeeScheduleGPCIBatchID - int
          NULL , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          15  -- AnesthesiaTimeIncrement - int
        )
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Standard Fee...'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
		  ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT DISTINCT
		  sfs.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
		  CASE WHEN imp.modifier <> '' THEN pm.ProcedureModifierID END ,
          imp.defaultcharge , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_1_1_TransactionCode] imp
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sfs ON	
		CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
		sfs.PracticeID = @PracticeID
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
		pcd.ProcedureCode = imp.defaultcptcode
LEFT JOIN dbo.ProcedureModifier pm ON
		pm.ProcedureModifierCode = imp.modifier
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting Into Standard Fee Link...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT DISTINCT
		  doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule sfs
WHERE doc.[External] = 0 AND	
	  doc.PracticeID = @PracticeID AND
	  sl.PracticeID = @PracticeID AND
	  CAST(sfs.Notes AS VARCHAR) = 'Vendor Import ' + CAST(@VendorImportID AS VARCHAR) AND
	  sfs.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Cases to Self Pay...'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11,
	NAME = 'Self Pay'
WHERE 
	@VendorImportID = VendorImportID AND 
	@PracticeID = PracticeID AND
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID) AND
	PayerScenarioID <> 11
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated'


ROLLBACK
--COMMIT



