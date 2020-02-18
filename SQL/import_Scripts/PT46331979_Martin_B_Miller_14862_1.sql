USE superbill_14862_dev
--USE superbill_14862_prod
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

	
	DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records deleted'
	DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records deleted'
	DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records deleted'
	DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'
	DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records deleted'
	DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR) + ' Doctor records deleted'


PRINT ''
PRINT 'Inserting into Insurance Company ..'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
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
          DefaultAdjustmentCode ,
          ReferringProviderNumberTypeID ,
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID
        )
SELECT DISTINCT
		  ic.[inscompanyname] , -- InsuranceCompanyName - varchar(128)
          ic.[street1]  , -- AddressLine1 - varchar(256)
          ic.[street2] , -- AddressLine2 - varchar(256)
          ic.[city] , -- City - varchar(128)
          LEFT(ic.[state], 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(REPLACE(ic.[zip], '-', ''), ' ', ''), 9) ,-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ic.[phone],'(',''),')',''),'-',''), ' ', ''),10),-- Phone - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13, -- SecondaryPrecedenceBillingFormID - int
          ic.[inscode] , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          NULL , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM [dbo].[_import_1_1_InsuranceCOMPANYPLANList] ic
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records inserted'




--InsuranceCompanyPlan
PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
		  AddressLine1 ,
		  AddressLine2 ,
		  city ,
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
		  icp.[insplanname] , -- PlanName - varchar(128)
		  ic.addressline1 ,
		  ic.addressline2 ,
		  ic.city ,
		  ic.[State] ,
		  ic.zipcode ,
		  ic.phone ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          ic.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_InsuranceCOMPANYPLANList] icp
INNER JOIN dbo.InsuranceCompany ic ON
	icp.inscode = ic.VendorID AND
	ic.VendorImportID = @VendorImportID
WHERE ic.CreatedPracticeID = @PracticeID  
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

PRINT''
PRINT'Inserting into Doctors ...'
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
          ActiveDoctor ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          VendorID ,
          VendorImportID ,
          [External] 
        )
SELECT DISTINCT 
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          doc.refproviderfirstname , -- FirstName - varchar(64)
          doc.refprovidermi , -- MiddleName - varchar(64)
          doc.refproviderlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          doc.refprovideraddress , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          doc.refprovidercity , -- City - varchar(128)
          doc.refproviderstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(doc.refproviderphone, '-', ''), 9) , -- ZipCode - varchar(9)
          doc.refproviderzip , -- WorkPhone - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          doc.refproviderid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- External - bit
FROM dbo.[_import_1_1_ReferringProviders] doc
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'



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
          pd.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(pd.[zip], '-', ''), 9)  , -- ZipCode - varchar(9)
          pd.[sex] , -- Gender - varchar(1)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pd.[phone],'(',''),')',''),'-',''), ' ', ''), 10), -- HomePhone - varchar(10)
          pd.[dob] , -- DOB - datetime
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
FROM [dbo].[_import_1_1_PatientDemos] pd
LEFT JOIN dbo.Doctor doc ON
	pd.refprovider = doc.VendorID AND
	doc.VendorImportID = @VendorImportID
WHERE pd.chart NOT IN ('15268.0', '12167.0', '6800.0', '25712.0', '17658.0', '19027.0', '17920.0', '23426.0', '20674.0', '18585.0')
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
FROM dbo.[_import_1_1_PatientDemos] ip
JOIN dbo.PatientCase pc ON
	ip.chart = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	ip.ins1code = icp.VendorID AND 	
	icp.VendorImportID = @VendorImportID
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
FROM dbo.[_import_1_1_PatientDemos] ip
JOIN dbo.PatientCase pc ON
	ip.chart = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
JOIN dbo.InsuranceCompanyPlan icp ON 
	ip.ins2code = icp.VendorID AND 	
	icp.VendorImportID = @VendorImportID	
WHERE ins2code <> ''	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

PRINT ''
PRINT 'Updating PatientCase'
UPDATE dbo.PatientCase
	SET PayerScenarioID = 11,
		NAME = 'Self Pay'
	WHERE PatientCaseID NOT IN (SELECT PatientCaseID FROM InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'	


COMMIT

