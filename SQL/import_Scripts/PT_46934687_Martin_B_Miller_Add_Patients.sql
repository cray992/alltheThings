--USE superbill_14862_dev
USE superbill_14862_prod
GO


 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

	
	DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
	DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
	DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'





--Patient
PRINT ''
PRINT 'Inserting into Patient'
INSERT INTO dbo.Patient
        ( PracticeID ,
		  Prefix,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Gender ,
          HomePhone ,
          DOB ,
          SSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled ,
          ReferringPhysicianID
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
		  '',
          pd.[firstname] , -- FirstName - varchar(64)
          pd.[mi] , -- MiddleName - varchar(64)
          pd.[lastname] , -- LastName - varchar(64)
          '',
          pd.[street1] , -- AddressLine1 - varchar(256)
          pd.[street2] , -- AddressLine2 - varchar(256)
          pd.[city] , -- City - varchar(128)
          LEFT(pd.[state], 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(pd.[zip], '-', ''), 9)  , -- ZipCode - varchar(9)
          pd.[sex] , -- Gender - varchar(1)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pd.[phone],'(',''),')',''),'-',''), ' ', ''), 10), -- HomePhone - varchar(10)
          CASE WHEN ISDATE(pd.[dob]) > 0 THEN pd.[dob] END , -- DOB - datetime
          LEFT(REPLACE(pd.[ss],'-',''),9) , -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pd.chart , -- MedicalRecordNumber - varchar(128)
          pd.chart , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          1 , -- PhonecallRemindersEnabled - bit
          doc.DoctorID
FROM [dbo].[_import_2_1_Sheet1] pd
LEFT JOIN dbo.Doctor doc ON
	pd.refprovider = doc.VendorID AND
	doc.VendorImportID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records inserted'



PRINT ''
PRINT 'Inserting into Patient Cases'
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
		   p.PatientID, -- PatientID - int
		   'Default Case' , -- Name - varchar(128)
           1 ,
           5 , -- PayerScenarioID - int
           'Created via Import. Please Review' , -- Notes - text
            GETDATE() , -- CreatedDate - datetime
           0 , -- CreatedUserID - int
           GETDATE() , -- ModifiedDate - datetime
           0 , -- ModifiedUserID - int
           @PracticeID , -- PracticeID - int
           p.VendorID, -- VendorID - varchar(50)
           @VendorImportID -- VendorImportID - int
FROM  dbo.Patient p 
WHERE p.VendorImportID = @VendorImportID

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Cases records inserted'



PRINT ''
PRINT 'Inserting into Insurance Policy  1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderLastName ,
          HolderAddressLine1 ,
          HolderCity ,
          HolderState ,
          HolderZipCode ,
          HolderDOB ,
          DependentPolicyNumber ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          ip.policy1 , -- PolicyNumber - varchar(32)
          ip.group1 , -- GroupNumber - varchar(32)
          CASE WHEN ip.sub1firstn = ip.firstname AND ip.sub1lastn = ip. lastname THEN 'S'
			   WHEN ip.sub1rel = 'H' THEN 'U'
			   WHEN ip.sub1rel = 'W' THEN 'U'
			   WHEN ip.sub1rel = 'W' THEN 'U'
			   WHEN ip.sub1rel = 'X' THEN 'U'
			   WHEN ip.sub1rel = 'L' THEN 'C'
			   WHEN ip.sub1rel = 'M' THEN 'C'
			   WHEN ip.sub1rel = 'P' THEN 'C'
			   WHEN ip.sub1rel = 'C' THEN 'C'
			   WHEN ip.sub1rel = 'O' THEN 'O'
			   ELSE 'S' END , -- RelationshiptoInured
		  CASE WHEN ip.sub1firstn = ip.firstname AND ip.sub1lastn = ip. lastname THEN ''
			   WHEN ip.sub1rel = '7' THEN ''
			   WHEN ip.sub1rel = '' THEN ''
			   WHEN ip.sub1rel = ' ' THEN ''
			   ELSE ip.sub1firstn END ,
		  CASE WHEN ip.sub1firstn = ip.firstname AND ip.sub1lastn = ip. lastname THEN ''
			   WHEN ip.sub1rel = '7' THEN ''
			   WHEN ip.sub1rel = '' THEN ''
			   WHEN ip.sub1rel = ' ' THEN ''
			   ELSE ip.sub1lastn END ,				   
		  CASE WHEN ip.sub1firstn = ip.firstname AND ip.sub1lastn = ip. lastname THEN ''
			   WHEN ip.sub1rel = '7' THEN ''
			   WHEN ip.sub1rel = '' THEN ''
			   WHEN ip.sub1rel = ' ' THEN ''
			   ELSE ip.sub1street1 END ,				   
		  CASE WHEN ip.sub1firstn = ip.firstname AND ip.sub1lastn = ip. lastname THEN ''
			   WHEN ip.sub1rel = '7' THEN ''
			   WHEN ip.sub1rel = '' THEN ''
			   WHEN ip.sub1rel = ' ' THEN ''
			   ELSE ip.sub1city END ,				   
		  CASE WHEN ip.sub1firstn = ip.firstname AND ip.sub1lastn = ip. lastname THEN ''
			   WHEN ip.sub1rel = '7' THEN ''
			   WHEN ip.sub1rel = '' THEN ''
			   WHEN ip.sub1rel = ' ' THEN ''
			   ELSE LEFT(ip.sub1state, 2) END ,				   
		  CASE WHEN ip.sub1firstn = ip.firstname AND ip.sub1lastn = ip. lastname THEN ''
			   WHEN ip.sub1rel = '7' THEN ''
			   WHEN ip.sub1rel = '' THEN ''
			   WHEN ip.sub1rel = ' ' THEN ''
			   ELSE LEFT(REPLACE(ip.sub1zip, '-', ''), 9) END ,				   
		  CASE WHEN ip.sub1firstn = ip.firstname AND ip.sub1lastn = ip. lastname THEN ''
			   WHEN ip.sub1rel = '7' THEN ''
			   WHEN ip.sub1rel = '' THEN ''
			   WHEN ip.sub1rel = ' ' THEN ''
			   ELSE ip.sub1dob END ,				   
		  CASE WHEN ip.sub1firstn = ip.firstname AND ip.sub1lastn = ip. lastname THEN ''
			   WHEN ip.sub1rel = '7' THEN ''
			   WHEN ip.sub1rel = '' THEN ''
			   WHEN ip.sub1rel = ' ' THEN ''
			   ELSE ip.policy1  END ,				   
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- Notes - text
          @PracticeID , -- PracticeID - int
          ip.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_2_1_Sheet1] ip
JOIN dbo.PatientCase pc ON
	ip.chart = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	ip.ins1code = icp.VendorID AND 	
	icp.VendorImportID = 1
WHERE ins1code <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
	

PRINT ''
PRINT 'Inserting into Insurance Policy  2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderLastName ,
          HolderAddressLine1 ,
          HolderCity ,
          HolderState ,
          HolderZipCode ,
          HolderDOB ,
          DependentPolicyNumber ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          ip.policy2 , -- PolicyNumber - varchar(32)
          ip.group2 , -- GroupNumber - varchar(32)
          CASE WHEN ip.sub2firstn = ip.firstname AND ip.sub2lastn = ip. lastname THEN 'S'
			   WHEN ip.sub2rel = 'H' THEN 'U'
			   WHEN ip.sub2rel = 'W' THEN 'U'
			   WHEN ip.sub2rel = 'W' THEN 'U'
			   WHEN ip.sub2rel = 'X' THEN 'U'
			   WHEN ip.sub2rel = 'L' THEN 'C'
			   WHEN ip.sub2rel = 'M' THEN 'C'
			   WHEN ip.sub2rel = 'P' THEN 'C'
			   WHEN ip.sub2rel = 'C' THEN 'C'
			   WHEN ip.sub2rel = 'O' THEN 'O'
			   ELSE 'S' END , -- RelationshiptoInured
		  CASE WHEN ip.sub2firstn = ip.firstname AND ip.sub2lastn = ip. lastname THEN ''
			   WHEN ip.sub2rel = '7' THEN ''
			   WHEN ip.sub2rel = '' THEN ''
			   WHEN ip.sub2rel = ' ' THEN ''
			   ELSE ip.sub1firstn END ,
		  CASE WHEN ip.sub2firstn = ip.firstname AND ip.sub2lastn = ip. lastname THEN ''
			   WHEN ip.sub2rel = '7' THEN ''
			   WHEN ip.sub2rel = '' THEN ''
			   WHEN ip.sub2rel = ' ' THEN ''
			   ELSE ip.sub2lastn END ,				   
		  CASE WHEN ip.sub2firstn = ip.firstname AND ip.sub2lastn = ip. lastname THEN ''
			   WHEN ip.sub2rel = '7' THEN ''
			   WHEN ip.sub2rel = '' THEN ''
			   WHEN ip.sub2rel = ' ' THEN ''
			   ELSE ip.sub2street1 END ,				   
		  CASE WHEN ip.sub2firstn = ip.firstname AND ip.sub2lastn = ip. lastname THEN ''
			   WHEN ip.sub2rel = '7' THEN ''
			   WHEN ip.sub2rel = '' THEN ''
			   WHEN ip.sub2rel = ' ' THEN ''
			   ELSE ip.sub2city END ,				   
		  CASE WHEN ip.sub2firstn = ip.firstname AND ip.sub2lastn = ip. lastname THEN ''
			   WHEN ip.sub2rel = '7' THEN ''
			   WHEN ip.sub2rel = '' THEN ''
			   WHEN ip.sub2rel = ' ' THEN ''
			   ELSE LEFT(ip.sub2state, 2) END ,				   
		  CASE WHEN ip.sub2firstn = ip.firstname AND ip.sub2lastn = ip. lastname THEN ''
			   WHEN ip.sub2rel = '7' THEN ''
			   WHEN ip.sub2rel = '' THEN ''
			   WHEN ip.sub2rel = ' ' THEN ''
			   ELSE LEFT(REPLACE(ip.sub2zip, '-', ''), 9) END ,				   
		  CASE WHEN ip.sub2firstn = ip.firstname AND ip.sub2lastn = ip. lastname THEN ''
			   WHEN ip.sub2rel = '7' THEN ''
			   WHEN ip.sub2rel = '' THEN ''
			   WHEN ip.sub2rel = ' ' THEN ''
			   ELSE ip.sub2dob END ,				   
		  CASE WHEN ip.sub2firstn = ip.firstname AND ip.sub2lastn = ip. lastname THEN ''
			   WHEN ip.sub2rel = '7' THEN ''
			   WHEN ip.sub2rel = '' THEN ''
			   WHEN ip.sub2rel = ' ' THEN ''
			   ELSE ip.policy2  END ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- Notes - text
          @PracticeID , -- PracticeID - int
          ip.AutoTempID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_2_1_Sheet1] ip
JOIN dbo.PatientCase pc ON
	ip.chart = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	ip.ins2code = icp.VendorID AND 	
	icp.VendorImportID = 1	
WHERE ins2code <> ''	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

PRINT ''
PRINT 'Updating PatientCase'
UPDATE dbo.PatientCase
	SET PayerScenarioID = 11,
		NAME = 'Self Pay'
	WHERE PatientCaseID NOT IN (SELECT PatientCaseID FROM InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
	AND dbo.PatientCase.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	


COMMIT
