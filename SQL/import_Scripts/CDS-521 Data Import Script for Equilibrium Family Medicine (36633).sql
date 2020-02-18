USE superbill_36633_dev
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


PRINT ''
PRINT 'Inserting Into Insurance Policy 1...'
INSERT INTO dbo.InsurancePolicy
( 
	PatientCaseID , InsuranceCompanyPlanID , Precedence , PolicyNumber , GroupNumber , PolicyStartDate , PolicyEndDate , CardOnFile , PatientRelationshipToInsured , 
	HolderPrefix , HolderFirstName , HolderMiddleName , HolderLastName , HolderSuffix , HolderDOB , HolderSSN , HolderThroughEmployer , HolderEmployerName , 
	PatientInsuranceStatusID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , HolderGender , HolderAddressLine1 , HolderAddressLine2 , HolderCity , 
	HolderState , HolderZipCode , HolderPhone , HolderPhoneExt , DependentPolicyNumber , Notes , Copay , Deductible , Active , PracticeID , VendorID , 
	VendorImportID , GroupName , ReleaseOfInformation
)
SELECT DISTINCT
	PC.PatientCaseID , -- PatientCaseID - int
	icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
	1 , -- Precedence - int
	LEFT(i.policynumber1,32), -- PolicyNumber - varchar(32)
	LEFT(i.groupnumber1,32), -- GroupNumber - varchar(32)
	CASE WHEN ISDATE(i.policy1startdate) = 1 AND i.policy1startdate <> '1900-01-01' THEN i.policy1startdate ELSE NULL END,
	CASE WHEN ISDATE(i.policy1enddate) = 1 AND i.policy1enddate <> '1900-01-01' THEN i.policy1enddate ELSE NULL END,
	0, -- CardOnFile - bit
	CASE
		WHEN i.patientrelationship1 IN ('C','Child') THEN 'C'
		WHEN i.patientrelationship1 IN ('O','Other') THEN 'O'
		WHEN i.patientrelationship1 IN ('U','Spouse') THEN 'U'
		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
	'', -- HolderPrefix - varchar(16)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN LEFT(i.holder1firstname,64) ELSE NULL END, -- HolderFirstName - varchar(64)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN LEFT(i.holder1middlename,64) ELSE NULL END, -- HolderMiddleName - varchar(64)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN LEFT(i.holder1lastname,64) ELSE NULL END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN CASE WHEN ISDATE(i.holder1dateofbirth) = 1 AND i.holder1dateofbirth <> '1/1/1900' THEN i.holder1dateofbirth ELSE NULL END END, -- HolderDOB - datetime
	CASE WHEN i.patientrelationship1 <> 'Self' THEN CASE WHEN LEN(i.holder1ssn)>= 6 THEN RIGHT('000' + i.holder1ssn, 9) ELSE NULL END ELSE NULL END, -- HolderSSN
	0 , -- HolderThroughEmployer - bit
	NULL , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN i.patientrelationship1 <> 'Self' THEN CASE WHEN i.holder1gender IN ('M','Male') THEN 'M' WHEN i.holder1gender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN LEFT(i.holder1street1,256) END, -- HolderAddressLine1 - varchar(256)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN LEFT(i.holder1street2,256) END , -- HolderAddressLine2 - varchar(256)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN LEFT(i.holder1city,128) END, -- HolderCity - varchar(128)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN UPPER(LEFT(i.holder1state,2)) END, -- HolderState
	CASE WHEN i.patientrelationship1 <> 'Self' THEN CASE 
		WHEN LEN(i.holder1zipcode) IN (5,9) THEN i.holder1zipcode
		WHEN LEN(i.holder1zipcode) = 4 THEN '0' + i.holder1zipcode
		ELSE '' END END, -- HolderZipCode - varchar(9)
	'', -- HolderPhone - varchar(10)
	'' , -- HolderPhoneExt - varchar(10)
	CASE WHEN i.patientrelationship1 <> 'Self' THEN LEFT(i.policynumber1, 32) ELSE NULL END , -- DependentPolicyNumber - varchar(32)
	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
	i.policy1copay, -- Copay - money
	i.policy1deductible, -- Deductible - money
	1, -- Active - bit
	@PracticeID , -- PracticeID - int
	i.chartnumber , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	'' , -- GroupName - varchar(14)
	'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_2_1_PatientDemographics] AS i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = i.insurancecode1 AND
		icp.VendorImportID = 1
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorID = i.chartnumber AND
		pc.VendorImportID = 1
WHERE i.insurancecode1 <> '' AND NOT EXISTS (SELECT * FROM dbo.InsurancePolicy ip WHERE i.policynumber1 = ip.PolicyNumber AND ip.Precedence = 1)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


PRINT ''
PRINT 'Updating PatientCase...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 5
WHERE ModifiedUserID = 0 AND PatientCaseID IN 
(SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE ModifiedUserID = 0 AND PayerScenarioID <> 5)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--ROLLBACK
--COMMIT
	

