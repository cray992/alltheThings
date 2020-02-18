--USE superbill_13864_dev
USE superbill_13864_prod
GO
-- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
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
		  insco.insurancecarrier1 , -- InsuranceCompanyName - varchar(128)
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
          insco.insurancecarrier1 , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
        
FROM dbo.[_import_1_1_PatelCASE] InsCo
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted '

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
		  insco.insurancecarrier2 , -- InsuranceCompanyName - varchar(128)
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
          insco.insurancecarrier2 , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int   
FROM dbo.[_import_1_1_PatelCASE] InsCo
WHERE insco.insurancecarrier2 NOT IN (SELECT InsuranceCompanyName FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID)
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
	      ic.InsuranceCompanyName , -- PlanName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @practiceID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ic.VendorID , -- VendorID - varchar(50)
          @vendorimportid  -- VendorImportID - int
 FROM dbo.InsuranceCompany ic
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
           AddressLine2 ,
           City ,
           State ,
           Country ,
           ZipCode ,
           Gender ,
           HomePhone ,
           DOB ,
           SSN ,
           EmailAddress ,
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
           pat.firstname , -- FirstName - varchar(64)
           pat.middleinitial , -- MiddleName - varchar(64)
           pat.lastname , -- LastName - varchar(64)
           '' , -- Suffix - varchar(16)
           pat.street1 , -- AddressLine1 - varchar(256)
           pat.street2 , -- AddressLine2 - varchar(256)
           pat.city , -- City - varchar(128)
           pat.state , -- State - varchar(2)
           pat.country , -- Country - varchar(32)
           pat.zipcode , -- ZipCode - varchar(9)
           pat.sex , -- Gender - varchar(1)
           pat.homephone , -- HomePhone - varchar(10)
           CASE WHEN ISDATE(pat.dateofbirth) > 0 THEN pat.dateofbirth END , -- DOB - datetime
           CASE WHEN len(pat.socialsecuritynumber) = 9 THEN pat.socialsecuritynumber 
				WHEN len(pat.socialsecuritynumber) = 8 THEN CAST('0' AS varchar (9)) + Cast(pat.socialsecuritynumber AS varchar (9)) 
				WHEN len(pat.socialsecuritynumber) = 7 THEN CAST('00' AS Varchar (9)) + Cast(pat.socialsecuritynumber AS varchar (9)) 
				END , -- SSN - char(9)
           pat.email , -- EmailAddress - varchar(256)
           GETDATE(), -- CreatedDate - datetime
           0 , -- CreatedUserID - int
           GETDATE() , -- ModifiedDate - datetime
           0 , -- ModifiedUserID - int
           pat.chartnumber , -- MedicalRecordNumber - varchar(128)
           pat.chartnumber , -- VendorID - varchar(50)
           @VendorImportID , -- VendorImportID - int
           1  -- Active - bit
FROM dbo.[_import_1_1_PatelPatient] pat
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted '



PRINT ''
PRINT 'Inserting into Patient Case ...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          CaseNumber ,
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
          pc.casenumber , -- CaseNumber - int
          'Created via data import, please review.' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_PatelCASE] pc 
INNER JOIN dbo.Patient pat ON
	pc.chartnumber = pat.VendorID AND
	pat.VendorImportID = @VendorImportID
WHERE pc.insurancecarrier1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into InsurancePolicy 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
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
          ip.policynumber1 , -- PolicyNumber - varchar(32)
          ip.groupnumber1 , -- GroupNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          'S' , -- PatientRelationshipToInsured - varchar(1)
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
FROM dbo.[_import_1_1_PatelCASE] ip
INNER JOIN dbo.PatientCase pc ON
	ip.chartnumber = pc.VendorID AND
	ip.casenumber = pc.CaseNumber AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	ip.insurancecarrier1 = icp.VendorID AND 
	icp.VendorImportID = @VendorImportID
WHERE ip.insurancecarrier1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into InsurancePolicy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
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
          ip.policynumber2 , -- PolicyNumber - varchar(32)
          ip.groupnumber2 , -- GroupNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          'S' , -- PatientRelationshipToInsured - varchar(1)
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
FROM dbo.[_import_1_1_PatelCASE] ip
INNER JOIN dbo.PatientCase pc ON
	ip.chartnumber = pc.VendorID AND
	ip.casenumber = pc.CaseNumber AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	ip.insurancecarrier2 = icp.VendorID AND 
	icp.VendorImportID = @VendorImportID
WHERE ip.insurancecarrier2 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

COMMIT