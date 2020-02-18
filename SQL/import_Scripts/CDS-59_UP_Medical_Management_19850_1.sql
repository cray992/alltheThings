--USE superbill_19850_dev
USE superbill_19850_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 3 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))



DELETE FROM dbo.InsurancePolicy WHERE (PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Policy records deleted '
DELETE FROM dbo.PatientCase WHERE PatientID IN (SELECT patientid FROM dbo.patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient Case records deleted '
DELETE FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Patient records deleted '
DELETE FROM dbo.Doctor WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS VARCHAR(10)) + ' Doctor records deleted '
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Company Plans records deleted '
DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Companies records deleted '



PRINT ''
PRINT 'Inserting into Insurance Company ....'
INSERT INTO dbo.InsuranceCompany
        ( 
			InsuranceCompanyName ,
			AddressLine1 ,
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
			ReviewCode ,
			VendorID ,
			VendorImportID ,
			NDCFormat ,
			UseFacilityID ,
			AnesthesiaType ,
			InstitutionalBillingFormID
        )
SELECT DISTINCT  
			ins.insurancecompanyname , -- InsuranceCompanyName - varchar(128)
			ins.insurancecompanyaddress ,
			ins.insurancecompanycity ,
			ins.insurancecompanystate ,
			LEFT(REPLACE(ins.insurancecompanyzip, '-', ''), 9) ,
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
			'R' , -- ReviewCode
			ins.insurancecompanynumber , -- VendorID - varchar(50)
			@VendorImportID , -- VendorImportID - int
			1 , -- NDCFormat - int
			1 , -- UseFacilityID - bit
			'U' , -- AnesthesiaType - varchar(1)
			18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_InsuranceList] AS ins
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT''
PRINT'Inserting into Insurance Company Plan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( 
			PlanName ,
			AddressLine1 ,
			AddressLine2 ,
			City ,
			State ,
			ZipCode ,
			Phone ,
			PhoneExt ,
			CreatedDate ,
			CreatedUserID ,
			ModifiedDate ,
			ModifiedUserID ,
			CreatedPracticeID ,
			InsuranceCompanyID ,
			ReviewCode ,
			VendorID ,
			VendorImportID 
        )
SELECT DISTINCT
			InsuranceCompanyName , -- PlanName - varchar(128)
			AddressLine1 ,
			AddressLine2 ,
			City ,
			State ,
			ZipCode ,
			Phone ,
			PhoneExt ,
			GETDATE() , -- CreatedDate - datetime
			0 , -- CreatedUserID - int
			GETDATE() , -- ModifiedDate - datetime
			0 , -- ModifiedUserID - int
			@PracticeID , -- CreatedPracticeID - int
			InsuranceCompanyID , -- InsuranceCompanyID - int
			'R' , -- Review Code
			VendorID , -- VendorID - varchar(50)
			@VendorImportID  -- VendorImportID - int       
FROM dbo.InsuranceCompany
WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into Doctor ...'
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
          [External] ,
          Notes ,
          NPI 
        )
SELECT    @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          ref.referringphysicianfirstname , -- FirstName - varchar(64)
          '' , -- MiddleName - varchar(64)
          ref.referringphysicianlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          ref.referringphysicianaddress1 , -- AddressLine1 - varchar(256)
          ref.referringphysicianaddress2 , -- AddressLine2 - varchar(256)
          ref.referringphysiciancity , -- City - varchar(128)
          LEFT(ref.referringphysicianstate, 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(ref.referringphysicianzipcode, 9) , -- ZipCode - varchar(9)
          LEFT(REPLACE(REPLACE(REPLACE(ref.referringphysicianworkphone, '(', ''), ')', ''), '-', ''), 10), -- WorkPhone - varchar(10)
          1 , -- ActiveDoctor - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ref.referringphysiciannumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- External - bit
          CASE WHEN ref.referringphysicianein <> '' THEN  'EIN: ' + LEFT(ref.referringphysicianein, 10) 
			ELSE '' END , -- EIN 
          LEFT(ref.referringphysiciannpi, 10)  -- NPI - varchar(10)
FROM dbo.[_import_2_1_ReferringPhysicians] ref
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient'
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
          ResponsibleDifferentThanPatient ,
          ResponsiblePrefix ,
          ResponsibleFirstName ,
          ResponsibleLastName ,
          ResponsibleMiddleName ,
          ResponsibleAddressLine1 ,
          ResponsibleCity ,
          ResponsibleZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicalRecordNumber ,
          VendorID ,
          VendorImportID ,
          Active 
        )
SELECT DISTINCT 
          @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.patientfirstname , -- FirstName - varchar(64)
          pat.patientmiddleinitial , -- MiddleName - varchar(64)
          pat.patientlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pat.address1 , -- AddressLine1 - varchar(256)
          pat.address2 , -- AddressLine2 - varchar(256)
          pat.city , -- City - varchar(128)
          LEFT(pat.state, 2) , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(pat.zip, 9) , -- ZipCode - varchar(9)
          CASE WHEN pat.gender = 'Unkown' THEN ''
				WHEN pat.gender = 'M' THEN 'M'
				WHEN pat.gender = 'F' THEN 'F' end , -- Gender - varchar(1)
          '' , -- MaritalStatus - varchar(1)
          LEFT(REPLACE(REPLACE(REPLACE(pat.homephone, '(', ''), ')', ''), '-', ''), 10) , -- HomePhone - varchar(10)
          pat.dateofbirth , -- DOB - datetime
          pat.ssn , -- SSN - char(9)
          CASE WHEN pat.guarantorfirstname = pat.patientfirstname AND pat.guarantorlastname = pat.patientlastname THEN NULL	
				ELSE 1 END , -- ResponsibleDifferentThanPatient - bit
          '' , -- ResponsiblePrefix - varchar(16)
          CASE WHEN pat.guarantorfirstname = pat.patientfirstname AND pat.guarantorlastname = pat.patientlastname THEN NULL	
				ELSE pat.guarantorfirstname END , -- ResponsibleFirstName - varchar(64)
          CASE WHEN pat.guarantorfirstname = pat.patientfirstname AND pat.guarantorlastname = pat.patientlastname THEN NULL	
				ELSE pat.guarantorlastname END , -- ResponsibleLastName - varchar(64)          
          CASE WHEN pat.guarantorfirstname = pat.patientfirstname AND pat.guarantorlastname = pat.patientlastname THEN NULL	
				ELSE pat.guarantorMiddleinitial END , -- ResponsibleMiddleName - varchar(64)
		  CASE WHEN pat.guarantorfirstname = pat.patientfirstname AND pat.guarantorlastname = pat.patientlastname THEN NULL	
				ELSE pat.guarantoraddress END , -- ResponsibleAddress - varchar(64)
		  CASE WHEN pat.guarantorfirstname = pat.patientfirstname AND pat.guarantorlastname = pat.patientlastname THEN NULL	
				ELSE pat.guarantorstate END , -- ResponsibleState - varchar(64)
		  CASE WHEN pat.guarantorfirstname = pat.patientfirstname AND pat.guarantorlastname = pat.patientlastname THEN NULL	
				ELSE pat.guarantorzip END , -- ResponsibleZip - varchar(64)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.chartnumber , -- MedicalRecordNumber - varchar(128)
          pat.chartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- Active - bit
FROM dbo.[_import_3_1_Sheet1] pat
WHERE pat.coveragepriority = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


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
SELECT    PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via data import, please review' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM dbo.Patient 
WHERE PracticeID = @PracticeID AND
	  VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting into Insurance Policy ...'
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
SELECT DISTINCT 
          pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          ip.coveragepriority , -- Precedence - int
          ip.policynumber , -- PolicyNumber - varchar(32)
          ip.groupnumber , -- GroupNumber - varchar(32)
          CASE WHEN ip.subscriberrelationship = 1 THEN 'S'
			   WHEN ip.subscriberrelationship = 2 THEN 'S'
			   WHEN ip.subscriberrelationship = 3 THEN 'U'
			   WHEN ip.subscriberrelationship = 4 THEN 'U'
			   WHEN ip.subscriberrelationship = 5 THEN 'C'
			   WHEN ip.subscriberrelationship = 6 THEN 'C'
			   ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.subscriberrelationship = 1 THEN ''
			   WHEN ip.subscriberrelationship = 2 THEN ''
			   ELSE ip.subscriberfirstname END  , -- HolderFirstName - varchar(64)
          CASE WHEN ip.subscriberrelationship = 1 THEN ''
			   WHEN ip.subscriberrelationship = 2 THEN ''
			   ELSE '' END , -- HolderMiddleName - varchar(64)
          CASE WHEN ip.subscriberrelationship = 1 THEN ''
			   WHEN ip.subscriberrelationship = 2 THEN ''
			   ELSE ip.subscriberlastname END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN ip.subscriberrelationship = 1 THEN ''
			   WHEN ip.subscriberrelationship = 2 THEN ''
			   ELSE ip.subscriberdob END , -- HolderDOB - datetime
          CASE WHEN ip.subscriberrelationship = 1 THEN ''
			   WHEN ip.subscriberrelationship = 2 THEN ''
			   ELSE ip.subscriberssn END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN ip.subscriberrelationship = 1 THEN ''
			   WHEN ip.subscriberrelationship = 2 THEN ''
			   ELSE ip.subscribergender END , -- HolderGender - char(1)
          ip.policynumber , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.chartnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_3_1_Sheet1] ip 
INNER JOIN dbo.PatientCase pc ON
	ip.chartnumber = pc.VendorID AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	ip.insurancecompanynumber = icp.VendorID AND
	icp.CreatedPracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
	

COMMIT