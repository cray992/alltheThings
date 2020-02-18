--USE superbill_18284_dev
USE superbill_18284_prod
GO
-- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 5 -- Vendor import record created through import tool

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
		  ic.payorname , -- InsuranceCompanyName - varchar(128)
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
          ic.payorid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int  
FROM dbo.[_import_5_1_InsuranceList] ic
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted '


PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
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
	      icp.planname , -- PlanName - varchar(128)
		  icp.address ,
		  icp.city ,
		  icp.state ,
		  icp.zipcode ,
		  icp.phone ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @practiceID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.payerplanid , -- VendorID - varchar(50)
          @vendorimportid  -- VendorImportID - int
 FROM dbo.[_import_5_1_InsuranceList] icp
 INNER JOIN dbo.InsuranceCompany ic ON
	icp.payorid = ic.VendorID and
    ic.VendorImportID = @VendorImportID 
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
           WorkPhone ,
           DOB ,
           SSN ,
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
           pat.patfirstname , -- FirstName - varchar(64)
           pat.patmiddlename , -- MiddleName - varchar(64)
           pat.patlastname , -- LastName - varchar(64)
           '' , -- Suffix - varchar(16)
           pat.addline1 , -- AddressLine1 - varchar(256)
           pat.addline2 , -- AddressLine2 - varchar(256)
           pat.city , -- City - varchar(128)
           pat.state , -- State - varchar(2)
           '' , -- Country - varchar(32)
           LEFT(REPLACE(pat.zip, '-', ''), 9) , -- ZipCode - varchar(9)
           pat.sex , -- Gender - varchar(1)
           LEFT(REPLACE(REPLACE(REPLACE(pat.homephone, '(', ''), '-', ''), ')', ''), 10) , -- HomePhone - varchar(10)
           LEFT(REPLACE(REPLACE(REPLACE(pat.workphone, '(', ''), '-', ''), ')', ''), 10) ,
           CASE WHEN ISDATE(pat.dob) > 0 THEN pat.dob END , -- DOB - datetime
           LEFT(REPLACE(ssn, '-', ''), 9) , -- SSN - char(9)
           GETDATE(), -- CreatedDate - datetime
           0 , -- CreatedUserID - int
           GETDATE() , -- ModifiedDate - datetime
           0 , -- ModifiedUserID - int
           pat.accountid , -- MedicalRecordNumber - varchar(128)
           pat.patientid , -- VendorID - varchar(50)
           @VendorImportID , -- VendorImportID - int
           1  -- Active - bit
FROM dbo.[_import_5_1_Patient] pat
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
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSSN ,
          HolderDOB ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity , 
          HolderState ,
          HolderZipCode ,
          HolderGender ,
          DependentPolicyNumber,
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
          ip.memberid , -- PolicyNumber - varchar(32)
          ip.groupnum , -- GroupNumber - varchar(32)
          CASE WHEN ip.memreltosub = 'Child' THEN 'C'
			   WHEN ip.memreltosub = 'Mother' THEN 'U'
			   WHEN ip.memreltosub = 'Other Relationship' THEN 'O'
			   WHEN ip.memreltosub = 'Self' THEN 'S'
			   WHEN ip.memreltosub = 'Significant Other' THEN 'U'
			   WHEN ip.memreltosub = 'Sponsored Dependent' THEN 'C'
			   WHEN ip.memreltosub = 'Spouse' THEN 'U'
			   WHEN ip.memreltosub = 'Stepson or Stepdaughter' THEN 'C'
			   ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
		  CASE WHEN ip.memreltosub <> 'Self' THEN ip.subscriberfirstname ELSE '' END ,
		  CASE WHEN ip.memreltosub <> 'Self' THEN ip.subscribermiddlename ELSE '' END ,
		  CASE WHEN ip.memreltosub <> 'Self' THEN ip.subscriberlastname ELSE '' END ,
		  CASE WHEN ip.memreltosub <> 'Self' THEN ip.subscriberssn ELSE '' END , 
		  CASE WHEN ip.memreltosub <> 'Self' THEN ip.subscriberdob ELSE '' END ,
		  CASE WHEN ip.memreltosub <> 'Self' THEN ip.address1 ELSE '' END ,
		  CASE WHEN ip.memreltosub <> 'Self' THEN ip.address2 ELSE '' END ,
		  CASE WHEN ip.memreltosub <> 'Self' THEN ip.city ELSE '' END , 
		  CASE WHEN ip.memreltosub <> 'Self' THEN ip.[state] ELSE '' END ,
		  CASE WHEN ip.memreltosub <> 'Self' THEN LEFT(REPLACE(ip.zip, '-', ''), 9) ELSE '' END ,
		  CASE WHEN ip.memreltosub <> 'Self' THEN 
					CASE WHEN ip.subsex = 'Male' THEN 'M' WHEN ip.subsex = 'Female' THEN 'F' END  ELSE '' END ,
		  ip.subscriberid ,
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
FROM dbo.[_import_5_1_Insurance] ip
INNER JOIN dbo.[_import_5_1_Patient] p ON 
	p.coverageid = ip.coverageid
INNER JOIN dbo.PatientCase pc ON
	p.patientid = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	ip.payorplanid = icp.VendorID AND 
	icp.VendorImportID = @VendorImportID
WHERE ip.coverageid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
--SELECT coverageid, subscriberfirstname, subscriberlastname  FROM dbo.[_import_5_1_Insurance] GROUP BY coverageid, subscriberfirstname, subscriberlastname HAVING COUNT(coverageid) > 1
--SELECT * FROM dbo._import_5_1_Insurance WHERE coverageid  IN (105594,1073595,1079966,162958,742209,803478,953738) ORDER BY coverageid
--DELETE FROM dbo.[_import_5_1_Insurance] WHERE autotempid IN (1415 , 1937, 1920, 1895, 564, 1592, 1126)

COMMIT