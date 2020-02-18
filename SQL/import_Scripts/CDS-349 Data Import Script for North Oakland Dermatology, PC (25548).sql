USE superbill_25548_dev
--USE superbill_25548_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @OldVendorImportID INT


SET @PracticeID = 1
SET @VendorImportID = 2
SET @OldVendorImportID = 1



--DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
--DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
--DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
--DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
--DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
--PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'


PRINT ''
PRINT 'Updating Patient Zip Code...'
UPDATE dbo.Patient
	SET ZipCode = i.patzip5 ,
	    ModifiedDate = GETDATE() ,
		ModifiedUserID = -50
FROM dbo.Patient p
INNER JOIN dbo.[_import_2_1_Demographics] i ON
i.pat = p.MedicalRecordNumber AND
p.VendorImportID = @OldVendorImportID
WHERE i.patzip5 <> '0'
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '


PRINT ''
PRINT 'Deleting Patient Alerts for Records that Received the Zip Code Update...'
DELETE FROM dbo.PatientAlert WHERE PatientID IN 
(SELECT PatientID FROM dbo.Patient WHERE MedicalRecordNumber IN 
(SELECT pat FROM dbo.[_import_2_1_Demographics] WHERE patzip5 <> '0'))
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records deleted '


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
		  insname , -- InsuranceCompanyName - varchar(128)
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
          insco , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_2_1_Policy]
WHERE covid91 <> ''
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
          WorkPhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          Active , 
		  CollectionCategoryID
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          [first] , -- FirstName - varchar(64)
          middle , -- MiddleName - varchar(64)
          [last] , -- LastName - varchar(64)
          suffix , -- Suffix - varchar(16)
          pataddress1 , -- AddressLine1 - varchar(256)
          pataddress2 , -- AddressLine2 - varchar(256)
          patcity , -- City - varchar(128)
          patstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          patzip5 , -- ZipCode - varchar(9)
          CASE patsex WHEN 'N' THEN 'U' ELSE patsex END , -- Gender - varchar(1)
          '' , -- MaritalStatus - varchar(1)
          dbo.fn_RemoveNonNumericCharacters(homephone) , -- HomePhone - varchar(10)
          dbo.fn_RemoveNonNumericCharacters(workphone) , -- WorkPhone - varchar(10)
          patbirthdate , -- DOB - datetime
          CASE WHEN LEN(patssn) >= 6 THEN RIGHT('000' + patssn, 9) ELSE '' END , -- SSN - char(9)
          patemail , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          1 , -- PrimaryProviderID - int
          1 , -- DefaultServiceLocationID - int
          pat , -- MedicalRecordNumber - varchar(128)
          pat , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- Active - bit
		  1  -- CollectionCategoryID - int
FROM dbo.[_import_2_1_Demographics] i
WHERE i.[first] <> '' AND NOT EXISTS (SELECT * FROM dbo.Patient p WHERE p.MedicalRecordNumber = i.pat)
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
		  p.PatientID , -- PatientID - int
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
          p.MedicalRecordNumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.Patient p
INNER JOIN dbo.[_import_2_1_Policy] i ON
p.MedicalRecordNumber = i.pat AND
p.VendorImportID IN (@OldVendorImportID , @VendorImportID)
WHERE i.covid91 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



PRINT ''
PRINT 'Inserting Into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
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
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation ,
		  DependentPolicyNumber 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          i.coveragelevel , -- Precedence - int
          i.covid91 , -- PolicyNumber - varchar(32)
          i.covid92 , -- GroupNumber - varchar(32)
          i.relationship , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN relationship = 'O' THEN '' ELSE NULL END , -- HolderPrefix - varchar(16)
          CASE WHEN relationship = 'O' THEN i.subfname ELSE NULL END , -- HolderFirstName - varchar(64)
          CASE WHEN relationship = 'O' THEN i.subminit ELSE NULL END , -- HolderMiddleName - varchar(64)
          CASE WHEN relationship = 'O' THEN i.sublname ELSE NULL END , -- HolderLastName - varchar(64)
          CASE WHEN relationship = 'O' THEN '' ELSE NULL END , -- HolderSuffix - varchar(16)
          CASE WHEN relationship = 'O' THEN (CASE WHEN ISDATE(i.subdob) = 1 THEN i.subdob ELSE NULL END) ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN relationship = 'O' THEN (CASE WHEN LEN(i.subssn) >= 6 THEN RIGHT('000' + i.subssn, 9) ELSE '' END) ELSE NULL END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          -50 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          -50 , -- ModifiedUserID - int
          CASE WHEN relationship = 'O' THEN (CASE i.subsex WHEN 'N' THEN 'U' ELSE i.subsex END) END, -- HolderGender - char(1)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y' , -- ReleaseOfInformation - varchar(1)
		  CASE WHEN relationship = 'O' THEN i.covid91 ELSE NULL END -- DependentPolicyNumber 
FROM dbo.[_import_2_1_Policy] i
INNER JOIN dbo.PatientCase pc ON
	i.pat = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	i.insco = icp.VendorID AND	
	icp.VendorImportID = @VendorImportID
WHERE i.covid91 <> ''
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '



--COMMIT
--ROLLBACK

