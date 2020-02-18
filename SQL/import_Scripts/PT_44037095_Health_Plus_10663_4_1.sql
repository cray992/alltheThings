USE superbill_10663_dev
--USE superbill_10663_prod
GO

-- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 4
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



PRINT ''
PRINT 'Inserting into Insurance Company'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
          PhoneExt ,
          Fax ,
          ContactFirstName ,
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
		  ic.[ipname] , -- InsuranceCompanyName - varchar(128)
          ic.[ipaddress1] , -- AddressLine1 - varchar(256)
          ic.[ipaddress2] , -- AddressLine2 - varchar(256)
          ic.[ipcity] , -- City - varchar(128)
          ic.[ipstate] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          ic.zpcode + ic.ipzip4,-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(ic.ipphone,'(',''),')',''),'-',''),10),-- Phone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(ic.ipphoneext,'(',''),')',''),'-',''),10),-- Phone Extension - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(ic.ipfax,'(',''),')',''),'-',''),10),-- Fax - varchar(10)
          ic.ipcontact ,
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
          ic.ipcode , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          NULL , -- DefaultAdjustmentCode - varchar(10)
          NULL , -- ReferringProviderNumberTypeID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM [dbo].[_import_1_4_InsuranceList] ic
PRINT  CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company records inserted'






PRINT ''
PRINT 'Inserting into Insurance Company Plan'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          [State] ,
          Country ,
          ZipCode ,
          Phone ,
          PhoneExt,
          Fax,
          ContactFirstName ,
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
		  icp.InsuranceCompanyName , -- PlanName - varchar(128)
          icp.AddressLine1 , -- AddressLine1 - varchar(256)
          icp.AddressLine2 , -- AddressLine2 - varchar(256)
          icp.city , -- City - varchar(128)
          icp.[state] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(icp.zipcode,'-',''),9),-- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(icp.Phone,'(',''),')',''),'-',''), ' ', ''),10),-- Phone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(icp.PhoneExt,'(',''),')',''),'-',''), ' ', ''),10),-- Phone Extension - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(icp.Fax,'(',''),')',''),'-',''), ' ', ''),10),-- Fax - varchar(10)
          icp.ContactFirstName ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID, --@PracticeID , -- CreatedPracticeID - int
          icp.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.VendorID , -- VendorID - varchar(50)
          @VendorImportID --@VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany icp
	WHERE icp.VendorImportID = @VendorImportID
			AND icp.CreatedPracticeID = @PracticeID
PRINT  CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Company Plan records inserted'


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
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          WorkPhoneExt ,
          MobilePhone ,
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
          EmergencyPhone ,
          EmergencyName ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
		  '',
          pd.pmfirstname , -- FirstName - varchar(64)
          pd.pmmi , -- MiddleName - varchar(64)
          pd.pmlastname , -- LastName - varchar(64)
          '',
          pd.pmaddress1 , -- AddressLine1 - varchar(256)
          pd.pmaddress2 , -- AddressLine2 - varchar(256)
          pd.pmcity , -- City - varchar(128)
          LEFT(pd.[pmstate], 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(pd.zpcode + pd.pmzip4, 9) ,-- ZipCode - varchar(9)
          CASE WHEN pd.pmsex = 'Male' THEN 'M' WHEN pd.pmsex = 'Female' THEN 'F' END  , -- Gender - varchar(1)
          CASE pd.pmmaritalstatus WHEN 'Unknown' THEN ''
									WHEN 'Married' THEN 'M'
									WHEN 'Divorced' THEN 'D'
									WHEN 'Widowed' THEN 'W'
									WHEN 'Legal Sep' THEN 'L'
									WHEN 'Single' THEN 'S'
									ELSE '' END ,
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pd.pmhomephone,'(',''),')',''),'-',''), ' ', ''),10), -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pd.pmworkphone,'(',''),')',''),'-',''), ' ', ''),10),-- WorkPhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pd.pmworkphoneext,'(',''),')',''),'-',''), ' ', ''),10),-- WorkPhoneExt - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(pd.pmmobilephone,'(',''),')',''),'-',''), ' ', ''),10),-- MobilePhone - varchar(10)
          CASE ISDATE(pd.pmdob) WHEN 1  -- DOB - datetime
			THEN CASE WHEN pd.pmdob > GETDATE() THEN DATEADD(yy, -100, pd.pmdob) 
			ELSE pd.pmdob END 
			ELSE NULL END,
          LEFT(REPLACE(pd.pmsocialsn,'-',''),9) , -- SSN - char(9)
          pd.pmemail , -- EmailAddress - varchar(256)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pd.[pmacct] , -- MedicalRecordNumber - varchar(128)
          pd.[pmacct] , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
           LEFT(REPLACE(REPLACE(REPLACE(pd.pmemerg,'(',''),')',''),'-',''),10),
          pd.pmemergext ,
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          1  -- PhonecallRemindersEnabled - bit
FROM [dbo].[_import_1_4_PatientDemo] pd
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient records inserted'







PRINT ''
PRINT 'Inserting into Patient Cases'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
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
		  PatientID, -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          5 , -- PayerScenarioID - int
          'Created via Import. Please Review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID, -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM  dbo.Patient 
WHERE PracticeID = @PracticeID AND
		VendorImportID = @VendorImportID

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Cases records inserted'



PRINT ''
PRINT 'Inserting into Insurance Policy  ...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
		  GroupName ,
		  PatientRelationshipToInsured ,
		  HolderLastName ,
		  HolderFirstName ,
		  HolderMiddleName ,
		  HolderAddressLine1 ,
		  HolderAddressLine2 ,
		  HolderCity ,
		  HolderState ,
		  HolderZipCode ,
		  HolderPhone ,
		  HolderDOB ,
		  HolderGender ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          Copay ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation
        )
SELECT DISTINCT
		  pc.[PatientCaseID] , -- PatientCaseID - int
          icp.[InsuranceCompanyPlanID] , -- InsuranceCompanyPlanID - int
          ip.[piinsseq] , -- Precedence - int
          ip.[piinsid] , -- PolicyNumber - varchar(32)
          ip.[piinsgrpid] , -- GroupNumber - varchar(32)
          LEFT(ip.[piinsgrpname], 14) ,-- GroupName 
          CASE WHEN ip.[pirelhold] = 'Self' THEN 'S'
			   WHEN ip.[pirelhold] = 'Spouse' THEN 'U'
			   WHEN ip.pirelhold = 'Other' THEN 'O'
			   WHEN ip.pirelhold = 'Child' THEN 'C' END ,
		  CASE WHEN ip.pirelhold = 'Self' THEN  ''
			ELSE ip.[piphlastname] END ,
		  CASE WHEN ip.pirelhold = 'Self' THEN  ''
			ELSE ip.[piphfirstname] END ,
		  CASE WHEN ip.pirelhold = 'Self' THEN  ''
			ELSE ip.[piphmi] END ,
		  CASE WHEN ip.pirelhold = 'Self' THEN  ''
			ELSE ip.[piphaddress1] END ,
		  CASE WHEN ip.pirelhold = 'Self' THEN  ''
			ELSE ip.[piphaddress2] END ,
		  CASE WHEN ip.pirelhold = 'Self' THEN  ''
			ELSE ip.[piphcity] END ,
		  CASE WHEN ip.pirelhold = 'Self' THEN  ''
			ELSE LEFT(ip.[piphstate], 2) END ,
		  CASE WHEN ip.pirelhold = 'Self' THEN  ''
			ELSE LEFT(ip.[zpcode] + [piphzip4], 9) END ,
		  CASE WHEN ip.pirelhold = 'Self' THEN  ''
			ELSE  LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ip.[piphphone],'(',''),')',''),'-',''), ' ',''),10) END ,
		  CASE WHEN ip.pirelhold <> 'Self' THEN  ip.[piphdob] END ,
		  CASE WHEN ip.pirelhold = 'Self' THEN  ''
			ELSE CASE WHEN ip.[piphsex] = 'Male' THEN 'M' 
			          WHEN ip.[piphsex] = 'Female' THEN 'F' END END ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- Notes - text
          ip.picopay , -- Copay - money
          @PracticeID , -- PracticeID - int
          ip.pmacct + ip.piinsseq , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_4_PatientInsurance] ip
LEFT JOIN dbo.PatientCase pc ON
	ip.pmacct = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
LEFT JOIN dbo.InsuranceCompanyPlan icp ON
	ip.ipcode = icp.VendorID AND
	icp.VendorImportID = @VendorImportID

PRINT  CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Insurance Policy records inserted'




-- Set cases without policies to self-pay (11)
PRINT ''
PRINT 'Setting cases without policies to Self-Pay'
UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11 
WHERE 
	@VendorImportID = VendorImportID AND 
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy) AND
	PayerScenarioID <> 11
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records updated'

COMMIT


