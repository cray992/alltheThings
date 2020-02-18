--USE superbill_18873_dev
USE superbill_18873_prod
go

SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool


PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID =  @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' InsurancePolicy records deleted'
DELETE FROM dbo.InsuranceCompanyPlan WHERE @PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' InsuranceCompanyPlan records deleted '
DELETE FROM dbo.InsuranceCompany WHERE @PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' InsuranceCompany records deleted '
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' PatientCase records deleted'
DELETE FROM dbo.Patient WHERE @PracticeID = @PracticeID AND VendorImportID = @VendorImportID 
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' Patient records deleted '

PRINT ''
PRINT 'Inserting into InsuranceCompany ...'
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
		  insco.insurancecompany , -- InsuranceCompanyName - varchar(128)
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
          insco.insurancecompany , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
        
FROM dbo.[_import_1_1_Insurances] InsCo
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted '


PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
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
	      icp.insuranceplan , -- PlanName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @practiceID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ic.VendorID , -- VendorID - varchar(50)
          @vendorimportid  -- VendorImportID - int
 FROM dbo.InsuranceCompany ic
 INNER JOIN dbo.[_import_1_1_Insurances] icp ON
	ic.InsuranceCompanyName = icp.insurancecompany
 WHERE VendorImportID = @VendorImportID 
  PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted '
 

 PRINT ''
 PRINT 'Inserting into Patient ...'
 INSERT INTO dbo.Patient
         ( PracticeID ,
           Prefix ,
           FirstName ,
           MiddleName ,
           LastName ,
           Suffix ,
           AddressLine1 ,
           City ,
           State ,
           Country ,
           ZipCode ,
           Gender ,
           HomePhone ,
           DOB ,
           CreatedDate ,
           CreatedUserID ,
           ModifiedDate ,
           ModifiedUserID ,
           MedicalRecordNumber ,
           VendorID ,
           VendorImportID ,
           Active 
         )
 SELECT    @PracticeID , -- PracticeID - int
           '' , -- Prefix - varchar(16)
           pat.patientfirstname , -- FirstName - varchar(64)
           '' , -- MiddleName - varchar(64)
           pat.patientlastname , -- LastName - varchar(64)
           '' , -- Suffix - varchar(16)
           pat.address , -- AddressLine1 - varchar(256)
           pat.city , -- City - varchar(128)
           pat.state , -- State - varchar(2)
           '' , -- Country - varchar(32)
           pat.zip , -- ZipCode - varchar(9)
           pat.gender , -- Gender - varchar(1)
           pat.homephone , -- HomePhone - varchar(10)
           CASE WHEN ISDATE(pat.dob) > 0 THEN pat.dob END , -- DOB - datetime
           GETDATE(), -- CreatedDate - datetime
           0 , -- CreatedUserID - int
           GETDATE() , -- ModifiedDate - datetime
           0 , -- ModifiedUserID - int
           pat.accno , -- MedicalRecordNumber - varchar(128)
           pat.accno , -- VendorID - varchar(50)
           @VendorImportID , -- VendorImportID - int
           1  -- Active - bit
FROM dbo.[_import_1_1_PatientDemographics] pat
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted '

 

PRINT ''
PRINT 'Inserting into Patient Case ...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pat.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via data import, please review.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient pat 
WHERE pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into InsurancePolicy 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderLastName ,
          DependentPolicyNumber ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          ip.policy , -- PolicyNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          CASE insuredpartyrelationship WHEN 'Self' THEN 'S' 
										WHEN 'Other' THEN 'O'
										WHEN 'Brian' THEN 'O' END , -- PatientRelationshipToInsured - varchar(1)
		  CASE insuredpartyrelationship WHEN 'Self' THEN '' 
					ELSE ip.insuredpartyfirstname END ,
		  CASE insuredpartyrelationship WHEN 'Self' THEN '' 
					ELSE ip.insuredpartylastname END ,
		  ip.policy ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE(), -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- Notes - text
          '' , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_Policy] ip
INNER JOIN dbo.PatientCase pc ON
	ip.account = pc.VendorID and
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	ip.[plan] = icp.VendorID AND 
	icp.VendorImportID = @VendorImportID
WHERE ip.priority = 'Primary'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



PRINT ''
PRINT 'Inserting into InsurancePolicy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderLastName ,
          DependentPolicyNumber ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          PatientInsuranceNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          ip.policy , -- PolicyNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          CASE insuredpartyrelationship WHEN 'Self' THEN 'S' 
										WHEN 'Other' THEN 'O'
										WHEN 'Brian' THEN 'O' END , -- PatientRelationshipToInsured - varchar(1)
		  CASE insuredpartyrelationship WHEN 'Self' THEN '' 
					ELSE ip.insuredpartyfirstname END ,
		  CASE insuredpartyrelationship WHEN 'Self' THEN '' 
					ELSE ip.insuredpartylastname END ,
		  ip.policy ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE(), -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- Notes - text
          '' , -- PatientInsuranceNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_Policy] ip
INNER JOIN dbo.PatientCase pc ON
	ip.account = pc.VendorID and
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	ip.[plan] = icp.VendorID AND 
	icp.VendorImportID = @VendorImportID
WHERE ip.priority = 'Secondary'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

COMMIT