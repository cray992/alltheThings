--USE superbill_14052_dev
USE superbill_14052_prod
GO

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
PRINT 'Inserting records into InsuranceCompany ...'
INSERT INTO dbo.InsuranceCompany(
    InsuranceCompanyName,
	Phone,
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
	ic.[1payername]
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ic.[1payerphone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,@PracticeID
	,GETDATE()
	,0
	,GETDATE()
	,0
	,LEFT(ic.[1payername], 50)  -- Hope it's unique!
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
FROM dbo.[_import_1_1_PatientsGuarantorsandInsur] ic
WHERE ic.[1payername] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting records into InsuranceCompany 2...'
INSERT INTO dbo.InsuranceCompany(
    InsuranceCompanyName,
	Phone,
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
	ic.[2payername]
	,LEFT(REPLACE(REPLACE(REPLACE(REPLACE(ic.[2payerphone], '-', ''), '(', ''), ')', ''), ' ', ''), 10)
	,1
	,GETDATE()
	,0
	,GETDATE()
	,0
	,LEFT(ic.[2payername], 50)  -- Hope it's unique!
	,1
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
FROM dbo.[_import_1_1_PatientsGuarantorsandInsur] ic
WHERE ic.[2payername] NOT IN (SELECT [1payername] FROM dbo.[_import_1_1_PatientsGuarantorsandInsur]) 
	AND ic.[1payername] <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'





--InsuranceCompanyPlan
PRINT ''
PRINT 'Inserting into InsuranceCompanyPlan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
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
		  icp.InsuranceCompanyName , -- PlanName - varchar(128)
          LEFT(REPLACE(REPLACE(REPLACE(REPLACE(icp.Phone, '-', ''), '(', ''), ')', ''), ' ', ''), 10) , -- Phone - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          icp.InsuranceCompanyID , -- InsuranceCompanyID - int
          icp.InsuranceCompanyID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany icp 
WHERE icp.CreatedPracticeID = @PracticeID AND 
	icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



--Patient
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
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          Active 
        )
SELECT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          pat.pat_FirstName , -- FirstName - varchar(64)
          pat.pat_Middle , -- MiddleName - varchar(64)
          pat.pat_LastName , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          pat.patientaddress , -- AddressLine1 - varchar(256)
          '' , -- AddressLine2 - varchar(256)
          pat.patientcity , -- City - varchar(128)
          pat.patientstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(pat.patientzip, '-', ''), 9) , -- ZipCode - varchar(9)
          LEFT(pat.patientgender, 1) , -- Gender - varchar(1)
          CASE pat.patientmaritalstatus WHEN 'Married' THEN 'M'
										WHEN 'Divorced' THEN 'D'
										WHEN 'Widowed' THEN 'W'
										WHEN 'Domestic Partner' THEN 'T'
										WHEN 'Separated' THEN 'L'
										ELSE '' END , -- MaritalStatus - varchar(1)
          LEFT(REPLACE(REPLACE(REPLACE(pat.patienthomephone, '(', ''), '(', ''), '-', ''), 9) , -- HomePhone - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(pat.patienthomephone, '(', ''), '(', ''), '-', ''), 9) , -- WorkPhone - varchar(10)
          CASE WHEN ISDATE(pat.patientdob) = 1 THEN pat.patientdob ELSE NULL END , -- DOB - datetime
          LEFT(REPLACE(pat.patientssn, '-', ''), 9) , -- SSN - char(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          pat.patientchartnumber , -- MedicalRecordNumber - varchar(128)
           LEFT(REPLACE(REPLACE(REPLACE(pat.patientcellphone, '(', ''), '(', ''), '-', ''), 9) , -- MobilePhone - varchar(10)
           pat.patientchartnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1  -- Active - bit
FROM dbo.[_import_1_1_PatientsGuarantorsandInsur] pat
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--PatientCase
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
          'Created via data import, please review.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pat.VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient pat
WHERE pat.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--InsurancePolicy #1
PRINT ''
PRINT 'Inserting into InsurancePolicy 1...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          ip.[1insuranceid] , -- PolicyNumber - varchar(32)
          ip.[1plangroupno] , -- GroupNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          DATEADD(year, 1, GETDATE()) , -- PolicyEndDate - datetime
          CASE WHEN ip.[1patientrelationshiptoinsured] = 'Self' THEN 'S'
			   WHEN ip.[1patientrelationshiptoinsured] = 'Spouse' THEN 'U'
			   WHEN ip.[1patientrelationshiptoinsured] = 'Other' THEN 'O'
			   WHEN ip.[1patientrelationshiptoinsured] = 'Child' THEN 'C'
			   ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.[1patientrelationshiptoinsured] = 'Self' THEN ''
				WHEN ip.insured1first LIKE '%(%' THEN SUBSTRING(ip.insured1first, 0, CHARINDEX('(', ip.insured1first, 1))
				ELSE  ip.insured1first END , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          CASE WHEN ip.[1patientrelationshiptoinsured] = 'Self' THEN ''
				ELSE ip.insured1last END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
		   CASE WHEN ip.[1patientrelationshiptoinsured] = 'Self' THEN ''
				ELSE CASE WHEN ISDATE([1insureddob]) = 1 THEN [1insureddob] END END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
           CASE WHEN ip.[1patientrelationshiptoinsured] = 'Self' THEN ''
				ELSE [1insuredaddress] END , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ip.[1patientrelationshiptoinsured] = 'Self' THEN ''
				ELSE [1insuredcity] END , -- HolderCity - varchar(128)
          CASE WHEN ip.[1patientrelationshiptoinsured] = 'Self' THEN ''
				ELSE [1insuredstate] END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN ip.[1patientrelationshiptoinsured] = 'Self' THEN ''
				ELSE [1insuredzip] END , -- HolderZipCode - varchar(9)
          CASE WHEN ip.[1patientrelationshiptoinsured] = 'Self' THEN ''
				ELSE LEFT(REPLACE(REPLACE(REPLACE([1insuredphone], '(', ''), '(', ''), '-', ''), 9) END , -- HolderPhone - varchar(10)
          CASE WHEN ip.[1patientrelationshiptoinsured] = 'Self' THEN ''
				ELSE ip.[1insuranceid] END , -- DependentPolicyNumber - varchar(32)
          'Recored created via data import, please review.' , -- Notes
          ip.[1copay] , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.ID + 1 , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(ip.[1groupname], 14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_PatientsGuarantorsandInsur] ip
LEFT JOIN dbo.InsuranceCompanyPlan icp ON
	ip.[1payername] = icp.PlanName AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.PatientCase pc ON
	ip.patientchartnumber = pc.VendorID
WHERE LEN(ip.[1payername]) > 1
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


--InsurancePolicy #2
PRINT ''
PRINT 'Inserting into InsurancePolicy 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
          PatientRelationshipToInsured ,
          HolderPrefix ,
          HolderFirstName ,
          HolderMiddleName ,
          HolderLastName ,
          HolderSuffix ,
          HolderDOB ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Notes ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          ip.[2insuranceid] , -- PolicyNumber - varchar(32)
          ip.[2plangroupno] , -- GroupNumber - varchar(32)
          GETDATE() , -- PolicyStartDate - datetime
          DATEADD(year, 1, GETDATE()) , -- PolicyEndDate - datetime
          CASE WHEN ip.[2patientrelationshiptoinsured] = 'Self' THEN 'S'
			   WHEN ip.[2patientrelationshiptoinsured] = 'Spouse' THEN 'U'
			   WHEN ip.[2patientrelationshiptoinsured] = 'Other' THEN 'O'
			   WHEN ip.[2patientrelationshiptoinsured] = 'Child' THEN 'C'
			   ELSE 'O' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.[2patientrelationshiptoinsured] = 'Self' THEN ''
				WHEN ip.insured2first LIKE '%(%' THEN  SUBSTRING(ip.insured2first, 0, CHARINDEX('(', ip.insured2first, 1)) -- HolderFirstName - varchar(64)
				ELSE ip.insured2first END ,
          '' , -- HolderMiddleName - varchar(64)
          CASE WHEN ip.[2patientrelationshiptoinsured] = 'Self' THEN ''
				ELSE ip.insured2last END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
		  CASE WHEN ip.[2patientrelationshiptoinsured] = 'Self' THEN ''
			ELSE CASE WHEN ISDATE([2insureddob]) = 1 THEN [2insureddob] END END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN ip.[2patientrelationshiptoinsured] = 'Self' THEN ''
				ELSE [2insuredaddress] END , -- HolderAddressLine1 - varchar(256)
          '' , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ip.[2patientrelationshiptoinsured] = 'Self' THEN '' 
				ELSE [2insuredcity] END , -- HolderCity - varchar(128)
          CASE WHEN ip.[2patientrelationshiptoinsured] = 'Self' THEN ''
				ELSE [2insuredstate] END , -- HolderState - varchar(2)
          '' , -- HolderCountry - varchar(32)
          CASE WHEN ip.[2patientrelationshiptoinsured] = 'Self' THEN ''
				ELSE [2insuredzip] END , -- HolderZipCode - varchar(9)
          CASE WHEN ip.[2patientrelationshiptoinsured] = 'Self' THEN ''
				ELSE LEFT(REPLACE(REPLACE(REPLACE([2insuredphone], '(', ''), '(', ''), '-', ''), 9) END , -- HolderPhone - varchar(10)
          CASE WHEN ip.[2patientrelationshiptoinsured] = 'Self' THEN ''
				ELSE ip.[2insuranceid] END , -- DependentPolicyNumber - varchar(32)
          'Recored created via data import, please review.' , -- Notes
          ip.[2copay] , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.ID + 1 , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          LEFT(ip.[2groupname], 14) , -- GroupName - varchar(14)
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_1_PatientsGuarantorsandInsur] ip
LEFT JOIN dbo.InsuranceCompanyPlan icp ON
	ip.[2payername] = icp.PlanName AND
	icp.VendorImportID = @VendorImportID
LEFT JOIN dbo.PatientCase pc ON
	ip.patientchartnumber = pc.VendorID
WHERE LEN(ip.[2payername]) > 2
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



COMMIT