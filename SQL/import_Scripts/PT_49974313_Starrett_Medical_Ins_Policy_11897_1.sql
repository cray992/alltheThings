USE superbill_11897_dev
--USE superbill_11897_prod
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
PRINT ''
	
DELETE FROM dbo.InsurancePolicy WHERE (PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Policy records deleted '

DELETE FROM dbo.PatientCase WHERE (PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '   ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Case records deleted'

DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Company Plans records deleted '

DELETE FROM dbo.InsuranceCompany WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT '   ' + CAST(@@rowcount AS varchar(10)) + ' Insurance Companies records deleted '


PRINT ''
PRINT 'Inserting into Insurance Company ...'	
INSERT INTO dbo.InsuranceCompany 
        ( InsuranceCompanyName ,
          Notes ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactFirstName ,
          Phone ,
          PhoneExt ,
          Fax ,
          BillSecondaryInsurance ,
          EClaimsAccepts ,
          BillingFormID ,
          InsuranceProgramCode ,
          HCFADiagnosisReferenceFormatCode ,
          HCFASameAsInsuredFormatCode ,
          ReviewCode ,
          CompanyTextID ,
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
SELECT    ic.name , -- InsuranceCompanyName - varchar(128)
          '' , -- Notes - text
          ic.street1 , -- AddressLine1 - varchar(256)
          ic.street2 , -- AddressLine2 - varchar(256)
          ic.city , -- City - varchar(128)
          ic.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
          LEFT(REPLACE(ic.zipcode, '-', ''), 9) , -- ZipCode - varchar(9)
          ic.contact , -- Contact First Name
          LEFT(REPLACE(REPLACE(REPLACE(ic.phone, '(', ''), ')', ''), '-', ''), 10) , -- Phone - varchar(10)
          ic.extension , -- PhoneExt - varchar(10)
          LEFT(REPLACE(REPLACE(REPLACE(ic.fax, '(', ''), ')', ''), '-', ''), 10)  , -- Fax - varchar(10)
          0 , -- BillSecondaryInsurance - bit
          0 , -- EClaimsAccepts - bit
          13 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          '' , -- ReviewCode - char(1)
          '' , -- CompanyTextID - varchar(10)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          13 , -- SecondaryPrecedenceBillingFormID - int
          ic.code , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM dbo.[_import_1_1_Insurances] ic 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Insurance Company Plan ...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
          ContactPrefix ,
          ContactFirstName ,
          ContactMiddleName ,
          ContactLastName ,
          ContactSuffix ,
          Phone ,
          PhoneExt ,
          Notes ,
          MM_CompanyID ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ReviewCode ,
          CreatedPracticeID ,
          Fax ,
          InsuranceCompanyID ,
          ADS_CompanyID ,
          Copay ,
          Deductible ,
          VendorID ,
          VendorImportID 
        )
SELECT    CASE WHEN icp.planname <> '' THEN icp.planname ELSE icp.NAME END  , -- PlanName - varchar(128)
          icp.street1 , -- AddressLine1 - varchar(256)
          icp.street2 , -- AddressLine2 - varchar(256)
          ic.city , -- City - varchar(128)
          ic.state , -- State - varchar(2)
          '' , -- Country - varchar(32)
		  ic.zipcode , -- ZipCode - varchar(9)
          '' , -- ContactPrefix - varchar(16)
          ic.contactfirstname , -- ContactFirstName - varchar(64)
          '' , -- ContactMiddleName - varchar(64)
          '' , -- ContactLastName - varchar(64)
          '' , -- ContactSuffix - varchar(16)
          ic.phone , -- Phone - varchar(10)
          ic.phoneext, -- PhoneExt - varchar(10)
          '' , -- Notes - text
          '' , -- MM_CompanyID - varchar(10)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE()  , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '' , -- ReviewCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          ic.fax , -- Fax - varchar(10)
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          '' , -- ADS_CompanyID - varchar(10)
          0 , -- Copay - money
          0 , -- Deductible - money
          icp.code , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_Insurances] icp
INNER JOIN dbo.InsuranceCompany ic ON
	icp.code = ic.VendorID AND
	ic.CreatedPracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into Patient Case ....'
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
          pc.description , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          'Created via data Import, please review.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          pc.casenumber , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_CaseInformation] pc
INNER JOIN dbo.Patient pat ON
	pat.MedicalRecordNumber = pc.chartnumber
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


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
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          ip.PolicyNumber1 , -- PolicyNumber - varchar(32)
          ip.GroupNumber1 , -- GroupNumber - varchar(32)
          CASE WHEN ip.insuredrelationship1 = 'Self' THEN 'S' 
			   WHEN ip.insuredrelationship1 = 'Spouse' THEN 'U'
               WHEN ip.insuredrelationship1 = 'Child' THEN 'C'
               WHEN ip.insuredrelationship1 = 'Other' THEN 'O'
               END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.insuredrelationship1 <> 'Self' THEN pat.FirstName ELSE '' END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.insuredrelationship1 <> 'Self' THEN pat.MiddleName ELSE '' END, -- HolderMiddleName - varchar(64)
          CASE WHEN ip.insuredrelationship1 <> 'Self' THEN pat.LastName ELSE '' END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN ip.insuredrelationship1 <> 'Self' THEN pat.DOB ELSE '' END , -- HolderDOB - datetime
          CASE WHEN ip.insuredrelationship1 <> 'Self' THEN pat.SSN ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN ip.insuredrelationship1 <> 'Self' THEN pat.Gender ELSE '' END , -- HolderGender - char(1)
          CASE WHEN ip.insuredrelationship1 <> 'Self' THEN pat.AddressLine1 ELSE '' END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ip.insuredrelationship1 <> 'Self' THEN pat.AddressLine2 ELSE '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ip.insuredrelationship1 <> 'Self' THEN pat.City ELSE '' END , -- HolderCity - varchar(128)
          CASE WHEN ip.insuredrelationship1 <> 'Self' THEN pat.State ELSE '' END , -- HolderState - varchar(2)
          CASE WHEN ip.insuredrelationship1 <> 'Self' THEN pat.Country ELSE '' END , -- HolderCountry - varchar(32)
          CASE WHEN ip.insuredrelationship1 <> 'Self' THEN pat.Zipcode ELSE '' END , -- HolderZipCode - varchar(9)
          CASE WHEN ip.insuredrelationship1 <> 'Self' THEN pat.HomePhone ELSE '' END , -- HolderPhone - varchar(10)
          ip.PolicyNumber1 , -- DependentPolicyNumber - varchar(32)
          ip.copaymentamount , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.casenumber + 1 , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_CaseInformation] ip
INNER JOIN dbo.patient pat ON
	ip.insured1 = pat.MedicalRecordNumber AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = ip.casenumber AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = ip.insurancecarrier1 AND
	icp.CreatedPracticeID = @PracticeID
WHERE ip.insured1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




PRINT ''
PRINT 'Inserting into Insurance Policy 2 ...'
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
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          ip.PolicyNumber2 , -- PolicyNumber - varchar(32)
          ip.GroupNumber2 , -- GroupNumber - varchar(32)
          CASE WHEN ip.insuredrelationship2 = 'Self' THEN 'S' 
			   WHEN ip.insuredrelationship2 = 'Spouse' THEN 'U'
               WHEN ip.insuredrelationship2 = 'Child' THEN 'C'
               WHEN ip.insuredrelationship2 = 'Other' THEN 'O'
               END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.insuredrelationship2 <> 'Self' THEN pat.FirstName ELSE '' END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.insuredrelationship2 <> 'Self' THEN pat.MiddleName ELSE '' END, -- HolderMiddleName - varchar(64)
          CASE WHEN ip.insuredrelationship2 <> 'Self' THEN pat.LastName ELSE '' END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN ip.insuredrelationship2 <> 'Self' THEN pat.DOB ELSE '' END , -- HolderDOB - datetime
          CASE WHEN ip.insuredrelationship2 <> 'Self' THEN pat.SSN ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN ip.insuredrelationship2 <> 'Self' THEN pat.Gender ELSE '' END , -- HolderGender - char(1)
          CASE WHEN ip.insuredrelationship2 <> 'Self' THEN pat.AddressLine1 ELSE '' END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ip.insuredrelationship2 <> 'Self' THEN pat.AddressLine2 ELSE '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ip.insuredrelationship2 <> 'Self' THEN pat.City ELSE '' END , -- HolderCity - varchar(128)
          CASE WHEN ip.insuredrelationship2 <> 'Self' THEN pat.State ELSE '' END , -- HolderState - varchar(2)
          CASE WHEN ip.insuredrelationship2 <> 'Self' THEN pat.Country ELSE '' END , -- HolderCountry - varchar(32)
          CASE WHEN ip.insuredrelationship2 <> 'Self' THEN pat.Zipcode ELSE '' END , -- HolderZipCode - varchar(9)
          CASE WHEN ip.insuredrelationship2 <> 'Self' THEN pat.HomePhone ELSE '' END , -- HolderPhone - varchar(10)
          ip.PolicyNumber2 , -- DependentPolicyNumber - varchar(32)
          ip.copaymentamount , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.casenumber + 2 , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_CaseInformation] ip
INNER JOIN dbo.patient pat ON
	ip.insured2 = pat.MedicalRecordNumber AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = ip.casenumber AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = ip.insurancecarrier2 AND
	icp.CreatedPracticeID = @PracticeID
WHERE ip.insured2 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



PRINT ''
PRINT 'Inserting into Insurance Policy 3 ...'
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
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          HolderPhone ,
          DependentPolicyNumber ,
          Copay ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID 
        )
SELECT    pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          ip.PolicyNumber3 , -- PolicyNumber - varchar(32)
          ip.GroupNumber3 , -- GroupNumber - varchar(32)
          CASE WHEN ip.insuredrelationship3 = 'Self' THEN 'S' 
			   WHEN ip.insuredrelationship3 = 'Spouse' THEN 'U'
               WHEN ip.insuredrelationship3 = 'Child' THEN 'C'
               WHEN ip.insuredrelationship3 = 'Other' THEN 'O'
               END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN ip.insuredrelationship3 <> 'Self' THEN pat.FirstName ELSE '' END , -- HolderFirstName - varchar(64)
          CASE WHEN ip.insuredrelationship3 <> 'Self' THEN pat.MiddleName ELSE '' END, -- HolderMiddleName - varchar(64)
          CASE WHEN ip.insuredrelationship3 <> 'Self' THEN pat.LastName ELSE '' END , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN ip.insuredrelationship3 <> 'Self' THEN pat.DOB ELSE '' END , -- HolderDOB - datetime
          CASE WHEN ip.insuredrelationship3 <> 'Self' THEN pat.SSN ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN ip.insuredrelationship3 <> 'Self' THEN pat.Gender ELSE '' END , -- HolderGender - char(1)
          CASE WHEN ip.insuredrelationship3 <> 'Self' THEN pat.AddressLine1 ELSE '' END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN ip.insuredrelationship3 <> 'Self' THEN pat.AddressLine2 ELSE '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN ip.insuredrelationship3 <> 'Self' THEN pat.City ELSE '' END , -- HolderCity - varchar(128)
          CASE WHEN ip.insuredrelationship3 <> 'Self' THEN pat.State ELSE '' END , -- HolderState - varchar(2)
          CASE WHEN ip.insuredrelationship3 <> 'Self' THEN pat.Country ELSE '' END , -- HolderCountry - varchar(32)
          CASE WHEN ip.insuredrelationship3 <> 'Self' THEN pat.Zipcode ELSE '' END , -- HolderZipCode - varchar(9)
          CASE WHEN ip.insuredrelationship3 <> 'Self' THEN pat.HomePhone ELSE '' END , -- HolderPhone - varchar(10)
          ip.PolicyNumber3 , -- DependentPolicyNumber - varchar(32)
          ip.copaymentamount , -- Copay - money
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          ip.casenumber + 3 , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.[_import_1_1_CaseInformation] ip
INNER JOIN dbo.patient pat ON
	ip.insured3 = pat.MedicalRecordNumber AND
	pat.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON
	pc.VendorID = ip.casenumber AND
	pc.PracticeID = @PracticeID
INNER JOIN dbo.InsuranceCompanyPlan icp ON
	icp.VendorID = ip.insurancecarrier3 AND
	icp.CreatedPracticeID = @PracticeID
WHERE ip.insured3 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'




COMMIT