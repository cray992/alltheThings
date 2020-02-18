--USE superbill_17986_dev
USE superbill_17986_prod
GO 
-- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 5		
SET @VendorImportID = 2 -- Vendor import record created through import tool

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
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
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
		  ic.insname , -- InsuranceCompanyName - varchar(128)
          ic.insaddress1 ,
          ic.insaddress2 ,
          ic.inscity ,
          ic.insstate ,
          ic.inszip ,
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
          ic.insco , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
        
FROM dbo.[_import_2_5_FlatheadUrologyDemographics] ic
WHERE ic.insname <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted '


PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          Addressline2 ,
          City ,
          State ,
          ZipCode ,
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
	      ic.addressline1 ,
	      ic.addressline2 ,
	      ic.city ,
	      ic.STATE ,
	      ic.zipcode ,
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
           WorkPhone ,
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
           MedicalRecordNumber ,
           VendorID ,
           VendorImportID ,
           Active ,
           SendEmailCorrespondence ,
           PhonecallRemindersEnabled 
         )
SELECT     @PracticeID , -- PracticeID - int
           '' , -- Prefix - varchar(16)
           pat.patfname , -- FirstName - varchar(64)
           pat.patminitial , -- MiddleName - varchar(64)
           pat.patlname , -- LastName - varchar(64)
           '' , -- Suffix - varchar(16)
           pat.pataddress1 , -- AddressLine1 - varchar(256)
           pat.pataddress2 , -- AddressLine2 - varchar(256)
           pat.patcity , -- City - varchar(128)
           pat.patstate , -- State - varchar(2)
           '' , -- Country - varchar(32)
           pat.patzip5 , -- ZipCode - varchar(9)
           pat.patsex , -- Gender - varchar(1)
           pat.homephone , -- HomePhone - varchar(10)
           pat.workphone , -- WorkPhone - varchar(10)
           pat.patbirthdate , -- DOB - datetime
           pat.patssn , -- SSN - char(9)
           pat.patemail , -- EmailAddress - varchar(256)
           CASE WHEN pat.patfname <> pat.rpfname AND pat.patlname <> pat.rpfname THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
           '' , -- ResponsiblePrefix - varchar(16)
           CASE WHEN pat.patfname <> pat.rpfname AND pat.patlname <> pat.rpfname THEN pat.rpfname END , -- ResponsibleFirstName - varchar(64)
           '' , -- ResponsibleMiddleName - varchar(64)
           CASE WHEN pat.patfname <> pat.rpfname AND pat.patlname <> pat.rpfname THEN pat.rplname END , -- ResponsibleLastName - varchar(64)
           '' , -- ResponsibleSuffix - varchar(16)
           '' , -- ResponsibleRelationshipToPatient - varchar(1)
           CASE WHEN pat.patfname <> pat.rpfname AND pat.patlname <> pat.rpfname THEN pat.rpaddress1 END , -- ResponsibleAddressLine1 - varchar(256)
           CASE WHEN pat.patfname <> pat.rpfname AND pat.patlname <> pat.rpfname THEN pat.rpaddress2 END , -- ResponsibleAddressLine2 - varchar(256)
           CASE WHEN pat.patfname <> pat.rpfname AND pat.patlname <> pat.rpfname THEN pat.rpcity END , -- ResponsibleCity - varchar(128)
           CASE WHEN pat.patfname <> pat.rpfname AND pat.patlname <> pat.rpfname THEN pat.rpstate END ,  -- ResponsibleState - varchar(2)
           '' , -- ResponsibleCountry - varchar(32)
           CASE WHEN pat.patfname <> pat.rpfname AND pat.patlname <> pat.rpfname THEN pat.rpzip5 END , -- ResponsibleZipCode - varchar(9)
           GETDATE() , -- CreatedDate - datetime
           0 , -- CreatedUserID - int
           GETDATE() , -- ModifiedDate - datetime
           0 , -- ModifiedUserID - int
           pat.pat , -- MedicalRecordNumber - varchar(128)
           pat.pat , -- VendorID - varchar(50)
           @VendorImportID , -- VendorImportID - int
           1 , -- Active - bit
           CASE WHEN pat.patemail <> '' THEN 1 ELSE 0 END , -- SendEmailCorrespondence - bit
           1  -- PhonecallRemindersEnabled - bit
FROM dbo.[_import_2_5_FlatheadUrologyDemographics] pat
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted' 
 
 
 
PRINT ''
PRINT 'Inserting into PatientCase ...' 
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
SELECT    pat.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import, please review.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient pat
WHERE pat.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted'
 
 
 PRINT ''
 PRINT 'Insert into InsurancePolicy 1 ...'
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
           DependentPolicyNumber ,
           Active ,
           PracticeID ,
           VendorID ,
           VendorImportID 
         )
 SELECT    pc.PatientCaseID , -- PatientCaseID - int
           icp.InsuranceCompanyPlanId , -- InsuranceCompanyPlanID - int
           1 , -- Precedence - int
           ip.policyid , -- PolicyNumber - varchar(32)
           ip.groupid , -- GroupNumber - varchar(32)
           CASE WHEN ip.patsubrel = 1 THEN 'S'
				WHEN ip.patsubrel = 2 THEN 'S'
				WHEN ip.patsubrel = 3 THEN 'U'
				WHEN ip.patsubrel = 4 THEN 'U'
				WHEN ip.patsubrel = 5 THEN 'C'
				WHEN ip.patsubrel = 6 THEN 'C'	
				WHEN ip.patsubrel = 31 THEN 'C'	
				WHEN ip.patsubrel = 9 THEN 'O'	
				WHEN ip.patsubrel = 47 THEN 'O'	END  , -- PatientRelationshipToInsured - varchar(1)
           '' , -- HolderPrefix - varchar(16)
           CASE WHEN ip.patfname <> ip.subfname AND ip.patlname <> ip.sublname THEN ip.subfname END , -- HolderFirstName - varchar(64)
           CASE WHEN ip.patfname <> ip.subfname AND ip.patlname <> ip.sublname THEN ip.subminit END , -- HolderMiddleName - varchar(64)
           CASE WHEN ip.patfname <> ip.subfname AND ip.patlname <> ip.sublname THEN ip.sublname END , -- HolderLastName - varchar(64)
           '' , -- HolderSuffix - varchar(16)
           CASE WHEN ip.patfname <> ip.subfname AND ip.patlname <> ip.sublname THEN ip.subdob END , -- HolderDOB - datetime
           CASE WHEN ip.patfname <> ip.subfname AND ip.patlname <> ip.sublname THEN ip.subssn END , -- HolderSSN - char(11)
           GETDATE() , -- CreatedDate - datetime
           0 , -- CreatedUserID - int
           GETDATE() , -- ModifiedDate - datetime
           0 , -- ModifiedUserID - int
           CASE WHEN ip.patfname <> ip.subfname AND ip.patlname <> ip.sublname THEN ip.subsex END , -- HolderGender - char(1)
           ip.policyid , -- DependentPolicyNumber - varchar(32)
           1 , -- Active - bit
           @PracticeID , -- PracticeID - int
           ip.pat + '1' , -- VendorID - varchar(50)
           @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_5_FlatheadUrologyDemographics] ip 
INNER JOIN dbo.PatientCase pc ON
	ip.pat = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	ip.insco = icp.VendorID AND
	icp.VendorImportID = @VendorImportID	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted'
 
 
 PRINT ''
 PRINT 'Insert into InsurancePolicy 2 ...'
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
           DependentPolicyNumber ,
           Active ,
           PracticeID ,
           VendorID ,
           VendorImportID 
         )
 SELECT    pc.PatientCaseID , -- PatientCaseID - int
           icp.InsuranceCompanyPlanId , -- InsuranceCompanyPlanID - int
           2 , -- Precedence - int
           ip.[2ndpolicyid] , -- PolicyNumber - varchar(32)
           ip.[2ndgroupid] , -- GroupNumber - varchar(32)
           CASE WHEN ip.[2ndpatsubrel] = 1 THEN 'S'
				WHEN ip.[2ndpatsubrel] = 2 THEN 'S'
				WHEN ip.[2ndpatsubrel] = 3 THEN 'U'
				WHEN ip.[2ndpatsubrel] = 4 THEN 'U'
				WHEN ip.[2ndpatsubrel] = 5 THEN 'C'
				WHEN ip.[2ndpatsubrel] = 6 THEN 'C'	
				WHEN ip.[2ndpatsubrel] = 31 THEN 'C'	
				WHEN ip.[2ndpatsubrel] = 9 THEN 'O'	
				WHEN ip.[2ndpatsubrel] = 47 THEN 'O'	END  , -- PatientRelationshipToInsured - varchar(1)
           '' , -- HolderPrefix - varchar(16)
           CASE WHEN ip.patfname <> ip.[2ndsubfname] AND ip.patlname <> ip.[2ndsublname] THEN ip.[2ndsubfname] END , -- HolderFirstName - varchar(64)
           CASE WHEN ip.patfname <> ip.[2ndsubfname] AND ip.patlname <> ip.[2ndsublname] THEN ip.[2ndsubminit] END , -- HolderMiddleName - varchar(64)
           CASE WHEN ip.patfname <> ip.[2ndsubfname] AND ip.patlname <> ip.[2ndsublname] THEN ip.[2ndsublname] END , -- HolderLastName - varchar(64)
           '' , -- HolderSuffix - varchar(16)
           CASE WHEN ip.patfname <> ip.[2ndsubfname] AND ip.patlname <> ip.[2ndsublname] THEN ip.[2ndsubdob] END , -- HolderDOB - datetime
           CASE WHEN ip.patfname <> ip.[2ndsubfname] AND ip.patlname <> ip.[2ndsublname] THEN ip.[2ndsubssn] END , -- HolderSSN - char(11)
           GETDATE() , -- CreatedDate - datetime
           0 , -- CreatedUserID - int
           GETDATE() , -- ModifiedDate - datetime
           0 , -- ModifiedUserID - int
           CASE WHEN ip.patfname <> ip.[2ndsubfname] AND ip.patlname <> ip.[2ndsublname] THEN ip.[2ndsubsex] END , -- HolderGender - char(1)
           ip.[2ndpolicyid] , -- DependentPolicyNumber - varchar(32)
           1 , -- Active - bit
           @PracticeID , -- PracticeID - int
           ip.pat + '1' , -- VendorID - varchar(50)
           @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_5_FlatheadUrologyDemographics] ip 
INNER JOIN dbo.PatientCase pc ON
	ip.pat = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	ip.[2ndinsco] = icp.VendorID AND
	icp.VendorImportID = @VendorImportID	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted'
  
 
 
 
 PRINT ''
 PRINT 'Insert into InsurancePolicy 3 ...'
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
           DependentPolicyNumber ,
           Active ,
           PracticeID ,
           VendorID ,
           VendorImportID 
         )
 SELECT    pc.PatientCaseID , -- PatientCaseID - int
           icp.InsuranceCompanyPlanId , -- InsuranceCompanyPlanID - int
           3 , -- Precedence - int
           ip.[3rdpolicyid] , -- PolicyNumber - varchar(32)
           ip.[3rdgroupid] , -- GroupNumber - varchar(32)
           CASE WHEN ip.[3rdpatsubrel] = 1 THEN 'S'
				WHEN ip.[3rdpatsubrel] = 2 THEN 'S'
				WHEN ip.[3rdpatsubrel] = 3 THEN 'U'
				WHEN ip.[3rdpatsubrel] = 4 THEN 'U'
				WHEN ip.[3rdpatsubrel] = 5 THEN 'C'
				WHEN ip.[3rdpatsubrel] = 6 THEN 'C'	
				WHEN ip.[3rdpatsubrel] = 31 THEN 'C'	
				WHEN ip.[3rdpatsubrel] = 9 THEN 'O'	
				WHEN ip.[3rdpatsubrel] = 47 THEN 'O'	END  , -- PatientRelationshipToInsured - varchar(1)
           '' , -- HolderPrefix - varchar(16)
           CASE WHEN ip.patfname <> ip.[3rdsubfname] AND ip.patlname <> ip.[3rdsublname] THEN ip.[3rdsubfname] END , -- HolderFirstName - varchar(64)
           CASE WHEN ip.patfname <> ip.[3rdsubfname] AND ip.patlname <> ip.[3rdsublname] THEN ip.[3rdsubminit] END , -- HolderMiddleName - varchar(64)
           CASE WHEN ip.patfname <> ip.[3rdsubfname] AND ip.patlname <> ip.[3rdsublname] THEN ip.[3rdsublname] END , -- HolderLastName - varchar(64)
           '' , -- HolderSuffix - varchar(16)
           CASE WHEN ip.patfname <> ip.[3rdsubfname] AND ip.patlname <> ip.[3rdsublname] THEN ip.[3rdofsubdob] END , -- HolderDOB - datetime
           CASE WHEN ip.patfname <> ip.[3rdsubfname] AND ip.patlname <> ip.[3rdsublname] THEN ip.[3rdsubssn] END , -- HolderSSN - char(11)
           GETDATE() , -- CreatedDate - datetime
           0 , -- CreatedUserID - int
           GETDATE() , -- ModifiedDate - datetime
           0 , -- ModifiedUserID - int
           CASE WHEN ip.patfname <> ip.[3rdsubfname] AND ip.patlname <> ip.[3rdsublname] THEN ip.[3rdsubsex] END , -- HolderGender - char(1)
           ip.[3rdpolicyid] , -- DependentPolicyNumber - varchar(32)
           1 , -- Active - bit
           @PracticeID , -- PracticeID - int
           ip.pat + '1' , -- VendorID - varchar(50)
           @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_5_FlatheadUrologyDemographics] ip 
INNER JOIN dbo.PatientCase pc ON
	ip.pat = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	ip.[3rdinsco] = icp.VendorID AND
	icp.VendorImportID = @VendorImportID	
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records Inserted'
 
 
 COMMIT
 