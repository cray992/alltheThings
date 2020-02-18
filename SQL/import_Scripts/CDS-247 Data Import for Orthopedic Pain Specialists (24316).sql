USE superbill_24316_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 4

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport 4 '


DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
DELETE FROM dbo.Employers WHERE CreatedUserID = 0 AND ModifiedUserID = 0
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID AND [External] = 1
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Doctor records deleted'

PRINT ''
PRINT 'Deleting Invalid Patient Records from [_import_4_1_PatientDemo]...' 
DELETE FROM dbo.[_import_4_1_PatientDemo] WHERE [first] = ':'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records deleted '


PRINT ''
PRINT 'Inserting Referring Provider List...'
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
          EmailAddress ,
          Notes ,
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
		  Degree ,
          TaxonomyCode ,
          VendorID ,
          VendorImportID ,
          [External] ,
          NPI 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          first1 , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          last1 , -- LastName - varchar(64)
          suffix , -- Suffix - varchar(16)
          address1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(zip)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(zip) 
			   ELSE '' END , -- ZipCode - varchar(9)
          email , -- EmailAddress - varchar(256)
          CASE WHEN adescription12 = '' THEN '' ELSE 'Description: ' + adescription12 + CHAR(13) + CHAR(10) END +
		 (CASE WHEN officecompany = '' THEN '' ELSE 'Office/Company: ' + officecompany + CHAR(13) + CHAR(10) END) +
	     (CASE WHEN phone1 = '' THEN '' ELSE phone1 + CHAR(13) + CHAR(10) END) +
	     (CASE WHEN phone2 = '' THEN '' ELSE phone2 + CHAR(13) + CHAR(10) END) +
		 (CASE WHEN phone3 = '' THEN '' ELSE phone3 + CHAR(13) + CHAR(10) END) +
	     (CASE WHEN idmedicare = '' THEN '' ELSE 'ID Medicare: ' + idmedicare + CHAR(13) + CHAR(10) END) +
 		 (CASE WHEN idbluecross = '' THEN '' ELSE 'ID BlueCross: ' + idbluecross + CHAR(13) + CHAR(10) END) +
	     (CASE WHEN idother = '' THEN '' ELSE 'ID Other: ' + idother + CHAR(13) + CHAR(10) END) +
	     (CASE WHEN idstate = '' THEN '' ELSE 'ID State: ' + idstate + CHAR(13) + CHAR(10) END)
			   , -- Notes - text
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          LEFT(degree, 8) , -- Degree - varchar(8)
          tc.TaxonomyCode , -- TaxonomyCode - char(10)
          AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- External - bit
          LEFT(idnationalprovider, 10)  -- NPI - varchar(10)
FROM dbo.[_import_4_1_ReferringProviders] imp
LEFT JOIN dbo.TaxonomyCode tc ON
imp.taxonomy = tc.TaxonomyCode
WHERE first1 <> '' AND last1 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

SET IDENTITY_INSERT dbo.Employers ON
PRINT ''
PRINT'Inserting Into Employers...'
INSERT INTO dbo.Employers
        ( EmployerID ,
		  EmployerName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT
		  employerid , --EmployerID 
		  name , -- EmployerName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_4_1_EmployerList] 
WHERE name <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
SET IDENTITY_INSERT dbo.Employers OFF



PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,	
          City ,
          State ,
          Country ,
          ZipCode ,
          Phone ,
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
		  name , -- InsuranceCompanyName - varchar(128)
          street1 , -- AddressLine1 - varchar(256)
          address2 , -- AddressLine2 - varchar(256)
          city , -- City - varchar(128)
          [state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(zip)
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(zip) 
			   ELSE dbo.fn_RemoveNonNumericCharacters(zip) END , -- ZipCode - varchar(9)
          LEFT(phone, 10) , -- Phone - varchar(10)
          13 , -- BillingFormID - int
          'CI', -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          companyid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_4_1_InsCompany]
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
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
		  InsuranceCompanyName , -- PlanName - varchar(128)
          AddressLine1 , -- AddressLine1 - varchar(256)
          AddressLine2 , -- AddressLine2 - varchar(256)
          City , -- City - varchar(128)
          [State] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ZipCode , -- ZipCode - varchar(9)
          Phone , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany
WHERE VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
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
          Gender ,
          HomePhone ,
          HomePhoneExt ,
          WorkPhone ,
          WorkPhoneExt ,
          DOB ,
          SSN ,
          EmailAddress ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          MobilePhoneExt ,
          VendorID ,
          VendorImportID ,
          Active ,
		  EmployerID ,
		  EmergencyName ,
		  EmergencyPhone ,
		  EmergencyPhoneExt		  
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          CASE WHEN imp.salute <> '' THEN imp.salute ELSE '' END , -- Prefix - varchar(16)
          imp.[first] , -- FirstName - varchar(64)
          imp.middle , -- MiddleName - varchar(64)
          imp.[last] , -- LastName - varchar(64)
          imp.suffix , -- Suffix - varchar(16)
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          CASE 
			   WHEN LEN(zip) = 4 THEN '0' + zip 
			   ELSE zip END , -- ZipCode - varchar(9)
          CASE WHEN imp.formattedsexforperson <> '' THEN imp.formattedsexforperson ELSE 'U' END , -- Gender - varchar(1)
          imp.homephone , -- HomePhone - varchar(10)
          imp.homephoneext , -- HomePhoneExt - varchar(10)
          imp.workphone , -- WorkPhone - varchar(10)
          imp.workphoneext , -- WorkPhoneExt - varchar(10)
          imp.birthday , -- DOB - datetime
          CASE WHEN LEN(imp.ssn) >= 6 THEN RIGHT('000' + imp.ssn, 9) ELSE '' END , -- SSN - char(9)
          imp.email , -- EmailAddress - varchar(256)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.defaultrenderring <> '' THEN imp.defaultrenderring ELSE NULL END , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          CASE WHEN imp.chartnumber <> '' THEN imp.chartnumber ELSE NULL END , -- MedicalRecordNumber - varchar(128)
          imp.mobilephone , -- MobilePhone - varchar(10)
          imp.mobilephoneext , -- MobilePhoneExt - varchar(10)
          imp.importvendorid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
		  CASE WHEN emplist.chartnumber <> '' THEN emp.employerid ELSE NULL END , --EmployerID
		  CASE WHEN imp.otherphone <> '' THEN 'Other Phone' END , -- EmergencyName
		  CASE WHEN imp.otherphone <> '' THEN imp.otherphone END , --EmergencyPhone
		  CASE WHEN imp.otherphone <> '' THEN imp.otherphoneext END --EmergencyPhoneExt
FROM dbo.[_import_4_1_PatientDemo] imp
LEFT JOIN dbo.[_import_4_1_EmployerList] emplist ON
	emplist.chartnumber = imp.importvendorid 
LEFT JOIN dbo.Employers emp ON
	emp.EmployerID = emplist.employerid
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Patient Case...'
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
PRINT 'Inserting Into Insurance Policy 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          imp.policy , -- PolicyNumber - varchar(32)
          imp.[group] , -- GroupNumber - varchar(32)
		  'S' , --PatientRelationshiptoInsured
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
		  pc.VendorID , --VendorID
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_1_PatPolicy] imp
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.companyid AND
	icp.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.charnumber AND
	pc.VendorImportId = @VendorImportId
WHERE imp.precedence = 0 OR imp.precedence = 1 AND imp.policy <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

PRINT ''
PRINT 'Inserting Into Insurance Policy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          imp.policy , -- PolicyNumber - varchar(32)
          imp.[group] , -- GroupNumber - varchar(32)
		  'S' , --PatientRelationshiptoInsured
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
		  pc.VendorID , --VendorID
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_1_PatPolicy] imp
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.companyid AND
	icp.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.charnumber AND
	pc.VendorImportId = @VendorImportId
WHERE imp.precedence = 2 AND imp.policy <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Policy 3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          imp.policy , -- PolicyNumber - varchar(32)
          imp.[group] , -- GroupNumber - varchar(32)
		  'S' , --PatientRelationshiptoInsured
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
		  pc.VendorID , --VendorID
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_4_1_PatPolicy] imp
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = imp.companyid AND
	icp.VendorImportID = @VendorImportID
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = imp.charnumber AND
	pc.VendorImportId = @VendorImportId
WHERE imp.precedence = 3 AND imp.policy <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Updating Patient Cases To Self-Pay That Do Not Contain Policies...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 11
	WHERE VendorImportID = @VendorImportID AND
		  PayerScenarioID = 5 AND 
		  PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--COMMIT
--ROLLBACK

