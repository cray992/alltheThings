--USE superbill_20940_dev
USE superbill_20940_prod
GO

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
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany(
    InsuranceCompanyName,
	CreatedPracticeID,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	VendorID,
	VendorImportID,
	BillSecondaryInsurance ,
	EClaimsAccepts ,
	BillingFormID ,
	InsuranceProgramCode ,
	HCFADiagnosisReferenceFormatCode ,
	HCFASameAsInsuredFormatCode ,
	DefaultAdjustmentCode ,
	ReferringProviderNumberTypeID ,
	NDCFormat ,
	UseFacilityID ,
	AnesthesiaType ,
	InstitutionalBillingFormID,
	SecondaryPrecedenceBillingFormID 
)
SELECT DISTINCT
	 ic.companyname
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,ic.companyid  -- Hope it's unique!
	,@VendorImportID
	,0  -- BillSecondaryInsurance - bit
	,0 -- EClaimsAccepts - bit
	,13  -- BillingFormID - int
	,'CI'  -- InsuranceProgramCode - char(2)
	,'C'  -- HCFADiagnosisReferenceFormatCode - char(1)
	,'D'  -- HCFASameAsInsuredFormatCode - char(1)
	,NULL -- DefaultAdjustmentCode - varchar(10)
	,NULL  -- ReferringProviderNumberTypeID - int
	,1  -- NDCFormat - int
	,1 -- UseFacilityID - bit
	,'U'  -- AnesthesiaType - varchar(1)
	,18  -- InstitutionalBillingFormID - int,
	,13
FROM dbo.[_import_2_1_InsuranceList] ic   
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'     

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          Phone,
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
          icp.planname  , -- PlanName - varchar(128)
          icp.planphone ,
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID, -- CreatedPracticeID - int
          ic.InsuranceCompanyID, -- InsuranceCompanyID - int
          icp.planid  , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_InsuranceList] icp
INNER JOIN dbo.InsuranceCompany ic ON 
	ic.VendorID = icp.planid AND
	ic.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'   
 
PRINT ''
PRINT 'Inserting Into Employer...'
INSERT INTO dbo.Employers
        ( EmployerName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID 
        )
SELECT DISTINCT  
		  emp.employer   , -- EmployerName - varchar(128)
          emp.address1 , -- AddressLine1 - varchar(256)
          emp.address2 , -- AddressLine2 - varchar(256)
          emp.city , -- City - varchar(128)
          emp.state , -- State - varchar(2)
          emp.zip , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0  -- ModifiedUserID - int
FROM dbo.[_import_2_1_Employer] emp
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'   

PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
        ( PracticeID,
          FirstName ,
          MiddleName ,
          LastName ,
          Suffix ,
          Prefix ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          ZipCode ,
          Gender ,
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          ResponsibleFirstName ,
          ResponsibleMiddleName ,
          ResponsibleLastName ,
          ResponsibleAddressLine1 ,
          ResponsibleCity ,
          ResponsibleState ,
          ResponsibleZipCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          EmployerID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          EmergencyName ,
          EmergencyPhone ,
          Ethnicity ,
          Race ,
          Language1 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          imppat.firstname , -- FirstName - varchar(64)
          imppat.middlename , -- MiddleName - varchar(64)
          imppat.lastname , -- LastName - varchar(64)
          '',
          '',
          imppat.address1 , -- AddressLine1 - varchar(256)
          imppat.address2 , -- AddressLine2 - varchar(256)
          imppat.city , -- City - varchar(128)
          imppat.state , -- State - varchar(2)
          imppat.zip , -- ZipCode - varchar(9)
          imppat.gender , -- Gender - varchar(1)
          CASE WHEN imppat.maritalstatus = 'Married' THEN 'M'
               WHEN imppat.maritalstatus = 'Never Married' THEN 'S'
               WHEN imppat.maritalstatus = 'Divorced' THEN 'D'
               WHEN imppat.maritalstatus = 'Separated' THEN 'L'
               WHEN imppat.maritalstatus = 'Widowed' THEN 'W'
               ELSE ''
               End, -- MaritalStatus - varchar(1)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(imppat.home, '(', ''), ')', ''), '-', ''), ' ', ''), 10)  , -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(imppat.work, '(', ''), ')', ''), '-', ''), ' ', ''), 10)  , -- WorkPhone - varchar(10)
          imppat.dob , -- DOB - datetime
          LEFT(REPLACE(imppat.ssn, '-', ''), 9) , -- SSN - char(9)
          imppat.email , -- EmailAddress - varchar(256)
          CASE WHEN imppat.guarantorfirstname = '' THEN 0 ELSE 1 END, -- ResponsibleDifferentThanPatient - bit
          imppat.guarantorfirstname , -- ResponsibleFirstName - varchar(64)
          imppat.guarantormiddleinitial , -- ResponsibleMiddleName - varchar(64)
          imppat.guarantorlastname , -- ResponsibleLastName - varchar(64)
          imppat.guarantoraddress , -- ResponsibleAddressLine1 - varchar(256)
          imppat.guarantorcity , -- ResponsibleCity - varchar(128)
          imppat.guarantorstate , -- ResponsibleState - varchar(2)
          imppat.guarantorzip , -- ResponsibleZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          imppat.employmentstatus , -- EmploymentStatus - char(1)
          emp.EmployerID , -- EmployerID - int
          imppat.medicalrecordnumber , -- MedicalRecordNumber - varchar(128)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(Imppat.mobile, '(', ''), ')', ''), '-', ''), ' ', ''), 10)  , -- MobilePhone - varchar(10)
          imppat.medicalrecordnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          imppat.emergencynamerelation , -- EmergencyName - varchar(128)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(imppat.emegerncyphone, '(', ''), ')', ''), '-', ''), ' ', ''), 10)  , -- EmergencyPhone - varchar(10)
          imppat.patientethnicity , -- Ethnicity - varchar(64)
          imppat.patientrace , -- Race - varchar(64)
          imppat.patientlanguage  -- Language1 - varchar(64)
FROM dbo.[_import_2_1_Patients] imppat
LEFT JOIN dbo.Employers emp ON 
	emp.EmployerName = imppat.employer
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'   

PRINT ''
PRINT 'Inserting Into Patient Case...'
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
SELECT   
		  pat.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via Data Import. Please review before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.MedicalRecordNumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient pat
WHERE pat.VendorImportID = @VendorImportID AND
	  pat.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted' 


PRINT ''
PRINT 'Inserting into Patient Policy 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderDOB ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderCity ,
          HolderState ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
	      pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          ip.primarypolicy , -- PolicyNumber - varchar(32)
          ip.primarygroup , -- GroupNumber - varchar(32)
          '2013-01-01 07:00:00' , -- PolicyStartDate - datetime
          CASE WHEN ip.primaryrelationship = 'Self' THEN 'S'
			   WHEN ip.primaryrelationship = 'Child' THEN 'C'
			   WHEN ip.primaryrelationship = 'Spouse' THEN 'U'
			   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          ip.primarysubfirstname , -- HolderFirstName - varchar(64)
          ip.primarysubmiddlename , -- HolderMiddleName - varchar(64)
          ip.primarysublastname , -- HolderLastName - varchar(64)
          ip.primarysubdob , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ip.primarysubaddress1 , -- HolderAddressLine1 - varchar(256)
          ip.primarysubcity , -- HolderCity - varchar(128)
          ip.primarysubstate , -- HolderState - varchar(2)
          ip.primarysubzip , -- HolderZipCode - varchar(9)
          ip.primarysubpolicy , -- DependentPolicyNumber - varchar(32)
          ip.primarycopay , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.medicalrecordnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_InsurancePolicy] ip
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = ip.medicalrecordnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = ip.primaryplanid AND
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted' 



PRINT ''
PRINT 'Inserting into Patient Policy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PatientRelationshipToInsured ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderDOB ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderCity ,
          HolderState ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT DISTINCT
	      pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          ip.secondarypolicy , -- PolicyNumber - varchar(32)
          ip.secondarysubgroup , -- GroupNumber - varchar(32)
          '2013-01-01 07:00:00' , -- PolicyStartDate - datetime
          CASE WHEN ip.secondaryrelationship = 'Self' THEN 'S'
			   WHEN ip.secondaryrelationship = 'Child' THEN 'C'
			   WHEN ip.secondaryrelationship = 'Spouse' THEN 'U'
			   ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          ip.secondarysubfirstname , -- HolderFirstName - varchar(64)
          ip.secondarysubmiddlename , -- HolderMiddleName - varchar(64)
          ip.secondarysublastname , -- HolderLastName - varchar(64)
          ip.secondarysubdob , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          ip.secondarysubaddress , -- HolderAddressLine1 - varchar(256)
          ip.secondarysubcity , -- HolderCity - varchar(128)
          ip.secondarysubstate , -- HolderState - varchar(2)
          ip.secondarysubzip , -- HolderZipCode - varchar(9)
          ip.secondarysubpolicy , -- DependentPolicyNumber - varchar(32)
          ip.secondarycopay , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.medicalrecordnumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_2_1_InsurancePolicy] ip
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = ip.medicalrecordnumber AND
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = ip.secondaryplanid AND
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted' 

				 
COMMIT 