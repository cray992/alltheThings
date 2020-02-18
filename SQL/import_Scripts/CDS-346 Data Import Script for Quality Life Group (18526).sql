USE superbill_18526_dev
--USE superbill_18526_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT


SET @PracticeID = 1
SET @VendorImportID = 7

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
--DELETE FROM dbo.Employers WHERE CreatedUserID = -50 AND ModifiedUserID = -50
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Employer records deleted'

PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
		  primaryinsurance , -- InsuranceCompanyName - varchar(128)
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          primaryinsurance , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_7_1_PatientDemoPolicy] 
WHERE primaryinsurance <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
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
          CreatedDate , -- CreatedDate - datetime
          CreatedUserID , -- CreatedUserID - int
          ModifiedDate , -- ModifiedDate - datetime
          ModifiedUserID , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany where VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Employer...'
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
	      i.employername , -- EmployerName - varchar(128)
          i.employeraddress , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          i.employercity , -- City - varchar(128)
          i.employercity , -- State - varchar(2)
          '' , -- Country - varchar(32)
          i.employerzip , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50  -- ModifiedUserID - int
FROM dbo.[_import_7_1_PatientDemoPolicy] i
WHERE NOT EXISTS (SELECT * FROM dbo.Employers e WHERE i.employername = e.EmployerName) AND i.employername <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Patient as Duplicates (zzz + Last Name)...'
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
          MaritalStatus ,
          HomePhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          EmployerID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          EmergencyName ,
          EmergencyPhone ,
		  ResponsibleDifferentThanPatient , 
		  ResponsibleFirstName , 
		  ResponsibleLastName
        )
SELECT DISTINCT
	      @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          i.patientfirstname , -- FirstName - varchar(64)
          i.patientmiddlename , -- MiddleName - varchar(64)
          'zzz' + i.patientlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.patientaddress , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          i.patientcity , -- City - varchar(128)
          i.patientstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          i.patientzip , -- ZipCode - varchar(9)
          'U' , -- Gender - varchar(1)
          '' , -- MaritalStatus - varchar(1)
          i.patienthomephone , -- HomePhone - varchar(10)
          CASE WHEN ISDATE(i.dob) = 1 THEN i.dob ELSE NULL END , -- DOB - datetime
          i.ssn , -- SSN - char(9)
          i.email , -- EmailAddress - varchar(256)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          1 , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          e.EmployerID , -- EmployerID - int
          i.patientid , -- MedicalRecordNumber - varchar(128)
          i.patientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          i.emergencycontact , -- EmergencyName - varchar(128)
          i.emergencyphone , -- EmergencyPhone - varchar(10)
		  CASE WHEN i.guarantorfirstname <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
		  CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorfirstname ELSE NULL END ,
		  CASE WHEN i.guarantorlastname <> '' THEN i.guarantorlastname ELSE NULL END
FROM dbo.[_import_7_1_PatientDemoPolicy] i
LEFT JOIN dbo.Employers e ON
	i.employername = e.EmployerName
WHERE EXISTS (SELECT * FROM dbo.Patient p WHERE i.patientfirstname = p.FirstName AND 
													i.patientlastname = p.LastName AND 
													p.dob = DATEADD(hh,12,CAST(CAST(i.dob AS DATE)AS DATETIME)))
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
          MaritalStatus ,
          HomePhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          EmployerID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          EmergencyName ,
          EmergencyPhone ,
		  ResponsibleDifferentThanPatient , 
		  ResponsibleFirstName , 
		  ResponsibleLastName
        )
SELECT DISTINCT
	      @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          i.patientfirstname , -- FirstName - varchar(64)
          i.patientmiddlename , -- MiddleName - varchar(64)
          i.patientlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.patientaddress , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          i.patientcity , -- City - varchar(128)
          i.patientstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          i.patientzip , -- ZipCode - varchar(9)
          'U' , -- Gender - varchar(1)
          '' , -- MaritalStatus - varchar(1)
          i.patienthomephone , -- HomePhone - varchar(10)
          CASE WHEN ISDATE(i.dob) = 1 THEN i.dob ELSE NULL END , -- DOB - datetime
          i.ssn , -- SSN - char(9)
          i.email , -- EmailAddress - varchar(256)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          1 , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          e.EmployerID , -- EmployerID - int
          i.patientid , -- MedicalRecordNumber - varchar(128)
          i.patientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          i.emergencycontact , -- EmergencyName - varchar(128)
          i.emergencyphone , -- EmergencyPhone - varchar(10)
		  CASE WHEN i.guarantorfirstname <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
		  CASE WHEN i.guarantorfirstname <> '' THEN i.guarantorfirstname ELSE NULL END ,
		  CASE WHEN i.guarantorlastname <> '' THEN i.guarantorlastname ELSE NULL END
FROM dbo.[_import_7_1_PatientDemoPolicy] i
LEFT JOIN dbo.Employers e ON
	i.employername = e.EmployerName
WHERE NOT EXISTS (SELECT * FROM dbo.Patient p WHERE i.patientfirstname = p.FirstName AND 
													i.patientlastname = p.LastName AND 
													p.dob = DATEADD(hh,12,CAST(CAST(i.dob AS DATE)AS DATETIME)))
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
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
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
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          i.primaryinsuredid , -- PolicyNumber - varchar(32)
          CASE WHEN i.primaryinsuredrel = 'O' THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.primaryinsuredrel = 'O' THEN '' ELSE NULL END , -- HolderPrefix - varchar(16)
          CASE WHEN i.primaryinsuredrel = 'O' THEN i.primaryinsuredfirstname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN i.primaryinsuredrel = 'O' THEN i.primaryinsuredpatientmiddlename ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.primaryinsuredrel = 'O' THEN i.primaryinsuredpatientlastname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN i.primaryinsuredrel = 'O' THEN '' ELSE NULL END , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN i.primaryinsuredrel = 'O' THEN i.primaryinsuredid ELSE NULL END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_7_1_PatientDemoPolicy] i 
INNER JOIN dbo.PatientCase pc ON
	i.patientid = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	i.primaryinsurance = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
WHERE i.primaryinsurance <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Inserting Into Insurance Policy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          i.secinsuredid , -- PolicyNumber - varchar(32)
          'S' , -- PatientRelationshipToInsured - varchar(1)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_7_1_PatientDemoPolicy] i 
INNER JOIN dbo.PatientCase pc ON
	i.patientid = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	i.secinsurance = icp.VendorID AND
	icp.VendorImportID = @VendorImportID
WHERE i.secinsurance <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID AND
              ip.PatientCaseID IS NULL AND
			  pc.PayerScenarioID = 5
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT