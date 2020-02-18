USE superbill_10590_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION 

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 23
SET @VendorImportID = 12 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))


UPDATE dbo.[_import_12_23_Precedence1]
	SET precedence = 3
	WHERE AutoTempID = 4716

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompanyPlan records deleted'
DELETE FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsuranceCompany records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'

PRINT ''
PRINT 'Inserting Into InsuranceCompany...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
		  imp.insname , -- InsuranceCompanyName - varchar(128)
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
		  imp.companycode ,	 -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18 -- InstitutionalBillingFormID - int
FROM dbo.[_import_12_23_InsuranceList] imp
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Insering Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
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
          imp.insname , -- PlanName - varchar(128)
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.state , -- State - varchar(2)
          imp.zip , -- ZipCode - varchar(9)
          imp.phone , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          IC.InsuranceCompanyID , -- InsuranceCompanyID - int
          imp.plancode , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_12_23_InsuranceList] imp
INNER JOIN dbo.InsuranceCompany IC ON
	imp.companycode = ic.VendorID AND
	CreatedPracticeID = @PracticeID 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PrimaryProviderID ,
          DefaultServiceLocationID ,
          MedicalRecordNumber ,
          MobilePhone ,
          PrimaryCarePhysicianID ,
          VendorID ,
          VendorImportID ,
          Active 
        )
SELECT DISTINCT
          @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          imp.firstname, -- FirstName - varchar(64)
          imp.middlename , -- MiddleName - varchar(64)
          imp.lastname , -- LastName - varchar(64)
          imp.suffix , -- Suffix - varchar(16)
          imp.address1 , -- AddressLine1 - varchar(256)
          imp.address2 , -- AddressLine2 - varchar(256)
          imp.city , -- City - varchar(128)
          imp.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          imp.zipcode, -- ZipCode - varchar(9)
          imp.sex , -- Gender - varchar(1)
		  imp.marstat , -- MaritalStatus
          imp.homephone, -- HomePhone - varchar(10)
          imp.dob , -- DOB - datetime
          imp.ssn , -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          7313 , -- PrimaryProviderID - int
          121 , -- DefaultServiceLocationID - int
          imp.account , -- MedicalRecordNumber - varchar(128)
          imp.mobilephone , -- MobilePhone - varchar(10)
          7313 , -- PrimaryCarePhysicianID - int
          imp.account , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- Active - bit
FROM dbo.[_import_12_23_Patients] imp
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting Into PatientCase...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT  
	      pat.PatientID, -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          CASE imp.payerscenario WHEN 'M' THEN 7
								 WHEN 'I' THEN 5
								 WHEN 'E' THEN 11
								 WHEN 'J' THEN 10
								 WHEN 'Y' THEN 5
								 WHEN 'H' THEN 6
								 WHEN 'C' THEN 22
								 WHEN 'P' THEN 5
								 WHEN 'T' THEN 10
								 WHEN 'Q' THEN 26
								 WHEN 'X' THEN 25
 								 ELSE 11 END, -- PayerScenarioID - int
          'Created via Data Import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_12_23_Patients] imp
INNER JOIN dbo.Patient pat ON 
	pat.MedicalRecordNumber = imp.account AND
	pat.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Policy1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
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
          VendorImportID 
        )
SELECT DISTINCT
	      pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          imp.precedence , -- Precedence - int
          LEFT(imp.policy, 32) , -- PolicyNumber - varchar(32)
          LEFT(imp.[group], 32) , -- GroupNumber - varchar(32)
          CASE imp.relation WHEN 'S' THEN 'S'
						WHEN 'C' THEN 'C'
						WHEN 'O' THEN 'O'
						ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          LEFT(imp.subscriberfirstname, 64), -- HolderFirstName - varchar(64)
          LEFT(imp.subscribermiddlename, 64) , -- HolderMiddleName - varchar(64)
          LEFT(imp.subsriberlastname, 64) , -- HolderLastName - varchar(64)
          LEFT(imp.subscribersuffix, 64) , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.subscriberfirstname <> '' THEN LEFT(imp.policy,32) ELSE '' END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.account , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_12_23_Precedence1] imp
INNER JOIN dbo.PatientCase PC ON
	pc.VendorID = imp.account AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan ICP ON
	icp.VendorID = imp.plancode AND 
	icp.CreatedPracticeID = @PracticeID 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting Into Policy2'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
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
          VendorImportID 
        )
SELECT 
	      pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          imp.precedence , -- Precedence - int
          LEFT(imp.policy2, 32) , -- PolicyNumber - varchar(32)
          LEFT(imp.group2, 32) , -- GroupNumber - varchar(32)
          CASE imp.relation2 WHEN 'S' THEN 'S'
						WHEN 'C' THEN 'C'
						WHEN 'O' THEN 'O'
						ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          LEFT(imp.subscriberfirstname2, 64), -- HolderFirstName - varchar(64)
          LEFT(imp.subscribermiddlename2, 64) , -- HolderMiddleName - varchar(64)
          LEFT(imp.subscriberlastname2, 64) , -- HolderLastName - varchar(64)
          LEFT(imp.subscribersuffix2, 64) , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.subscriberfirstname2 <> '' THEN LEFT(imp.policy2,32) ELSE '' END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.account , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_12_23_Precedence2] imp
INNER JOIN dbo.PatientCase PC ON
	pc.VendorID = imp.account AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan ICP ON
	icp.VendorID = imp.plancode AND
	icp.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting Into Policy3'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
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
          VendorImportID 
        )
SELECT 
	      pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          imp.precedence , -- Precedence - int
          LEFT(imp.policy3, 32) , -- PolicyNumber - varchar(32)
          LEFT(imp.group3, 32) , -- GroupNumber - varchar(32)
          CASE imp.relation3 WHEN 'S' THEN 'S'
						WHEN 'C' THEN 'C'
						WHEN 'O' THEN 'O'
						ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          LEFT(imp.subscriberfirstname3, 64), -- HolderFirstName - varchar(64)
          LEFT(imp.subscribermiddlename3, 64) , -- HolderMiddleName - varchar(64)
          LEFT(imp.subscribermiddlename3, 64) , -- HolderLastName - varchar(64)
          LEFT(imp.subscribersuffix3, 64) , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN imp.subscriberfirstname3 <> '' THEN LEFT(imp.policy3,32) ELSE '' END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          imp.account , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_12_23_Precedence3] imp
INNER JOIN dbo.PatientCase PC ON
	pc.VendorID = imp.account AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan ICP ON
	icp.VendorID = imp.plancode AND
	icp.VendorImportID = @VendorImportID
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



COMMIT

