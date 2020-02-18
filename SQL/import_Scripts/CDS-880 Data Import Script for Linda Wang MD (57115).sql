USE superbill_57115_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE @PracticeID INT , @VendorImportID INT
SET @PracticeID = 1 
SET @VendorImportID = 7

UPDATE dbo._import_7_1_Sheet1 SET filingorder = CASE WHEN filingorder = 'NULL' THEN '' ELSE filingorder END

INSERT INTO dbo.PatientCase
( 
	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
)
SELECT DISTINCT 
	P.PatientID , -- PatientID - int
	'Default Case' , -- Name - varchar(128)
	1 , -- Active - bit
	5 , -- PayerScenarioID - int
	NULL , -- ReferringPhysicianID - int
	0 , -- EmploymentRelatedFlag - bit
	0, -- AutoAccidentRelatedFlag - bit
	0, -- OtherAccidentRelatedFlag - bit
	0, -- AbuseRelatedFlag - bit
	NULL , -- AutoAccidentRelatedState - char(2)
	CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
	0, -- ShowExpiredInsurancePolicies - bit
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- PracticeID - int
	NULL , -- CaseNumber - varchar(128)
	NULL , -- WorkersCompContactInfoID - int
	P.PatientID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.Patient p
INNER JOIN dbo._import_7_1_Sheet1 i ON
	p.FirstName = i.firstname AND
    p.LastName = i.lastname AND
    p.DOB = DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) 
LEFT JOIN dbo.PatientCase pc ON p.PatientID = pc.PatientID
WHERE p.PracticeID = @PracticeID AND pc.PatientCaseID IS NULL AND i.policynumber1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient Case Records Inserted...'


INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , ReviewCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	CASE WHEN LEN(IICL.insurancecompanyname) > 1 THEN LEFT(LTRIM(RTRIM(IICL.insurancecompanyname)),128)
		 ELSE LEFT(LTRIM(RTRIM(IICL.planname)),128) END  , -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
	19 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	CASE scope WHEN 1 THEN 'R' ELSE '' END , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	19 , -- SecondaryPrecedenceBillingFormID - int
	LEFT(CASE 
		WHEN LEN(IICL.insurancecompanyname) > 1 THEN LTRIM(RTRIM(IICL.insurancecompanyname))
		ELSE LTRIM(RTRIM(IICL.planname)) END,50) , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int 
FROM dbo._import_7_1_Sheet1 i
LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
	i.insurancecode1 = icp.VendorID AND 
	icp.VendorImportID = 4
INNER JOIN dbo.Patient p ON 
	i.firstname = p.FirstName AND
    i.lastname = p.LastName AND
    DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) = p.DOB AND
	p.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON 
	p.PatientID = pc.PatientID AND 
	pc.VendorImportID = @VendorImportID
LEFT JOIN dbo.InsurancePolicy ip ON 
	pc.PatientCaseID = ip.PatientCaseID AND 
	ip.PracticeID = @PracticeID
INNER JOIN dbo._import_1_1_InsuranceCOMPANYPLANList iicl ON 
	i.insurancecode1 = iicl.insuranceid
WHERE ip.InsurancePolicyID IS NULL AND i.policynumber1 <> '' AND i.filingorder <> '' AND icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Comapany Records Inserted...'

INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , ContactFirstName , ContactLastName , 
	Phone , PhoneExt , Notes , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	Fax , FaxExt , InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	CASE WHEN ICP.planname <> '' THEN LEFT(LTRIM(RTRIM(ICP.planname)),128)
		 ELSE LEFT(LTRIM(RTRIM(ICP.InsuranceCompanyName)),128) END  , -- PlanName - varchar(128)
	LEFT(LTRIM(RTRIM(ICP.Address1)),256) , -- AddressLine1 - varchar(256)
	LEFT(LTRIM(RTRIM(ICP.Address2)),256) , -- AddressLine2 - varchar(256)
	UPPER(LEFT(LTRIM(RTRIM(ICP.[State])),2)), -- City - varchar(128)
	LEFT(LTRIM(RTRIM(ICP.[State])),2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.zip)
	ELSE '' END , -- ZipCode - varchar(9)
	LEFT(LTRIM(RTRIM(ICP.ContactFirstName)),64) , -- ContactFirstName - varchar(64)
	LEFT(LTRIM(RTRIM(ICP.ContactLastName)),64) , -- ContactLastName - varchar(64)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Phone),10) , -- Phone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.PhoneExt),10) , -- PhoneExt - varchar(10)
	ICP.Notes , -- Notes - text
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.Fax), 10) , -- Fax - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(ICP.FaxExt), 10) , -- FaxExt - varchar(10)
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	insuranceid,  -- VendorID - varchar(50) --FIX
	@VendorImportID -- VendorImportID - int
FROM dbo._import_1_1_InsuranceCOMPANYPLANList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(LTRIM(RTRIM(ICP.InsuranceCompanyName)), 50) AND
	LTRIM(RTRIM(ICP.Insurancecompanyname)) = LTRIM(RTRIM(IC.InsuranceCompanyName)) AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.Insuranceid = OICP.VendorID AND
	OICP.VendorImportID = @VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Company Plan records inserted'	


INSERT INTO dbo.InsurancePolicy
( 
	PatientCaseID , InsuranceCompanyPlanID , Precedence , PolicyNumber , GroupNumber , CardOnFile , PatientRelationshipToInsured ,
    HolderPrefix , HolderFirstName , HolderMiddleName , HolderLastName , HolderSuffix , HolderDOB , HolderSSN , CreatedDate ,
    CreatedUserID , ModifiedDate , ModifiedUserID , HolderGender , HolderAddressLine1 , HolderAddressLine2 , HolderCity ,
    HolderState , HolderCountry , HolderZipCode , DependentPolicyNumber , Active , PracticeID , VendorID , VendorImportID , ReleaseOfInformation 
)
SELECT DISTINCT
	pc.PatientCaseID ,
    icp.InsuranceCompanyPlanID ,
    i.filingorder ,
    LEFT(i.policynumber1,32),
    LEFT(i.groupnumber1,32) ,
    0 ,
    CASE i.patientrelationship1 
			WHEN 'Spouse' THEN 'U'
			WHEN 'Grandfather' THEN 'C'
			WHEN 'Granmother' THEN 'C'
			WHEN 'Father' THEN 'C'
			WHEN 'Uncle' THEN 'C'
			WHEN 'Mother' THEN 'C'
		  ELSE 'S' END ,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN '' END ,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN i.holder1firstname END,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN i.holder1middlename END ,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN i.holder1firstlastname END ,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN '' END ,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN CASE WHEN ISDATE(i.holder1dateofbirth) = 1 THEN i.holder1dateofbirth END END ,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.holder1ssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.holder1ssn),9) END END ,
    GETDATE() ,
    0 ,
    GETDATE() ,
    0 ,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN 
				CASE WHEN i.holder1gender = '' THEN 'U' ELSE i.holder1gender END
		  END ,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN i.holder1street1 END ,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN i.holder1street2 END ,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN i.holder1city END ,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN i.holder1state END ,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN '' END ,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN
			 CASE 
				WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.holder1zipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.holder1zipcode)
				WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.holder1zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.holder1zipcode)
			 END 
		  END ,
    CASE WHEN i.patientrelationship1 <> 'Self' OR i.patientrelationship1 <> '' THEN LEFT(i.policynumber1,32) END ,
    1 ,
    @PracticeID ,
    i.mrn ,
    @VendorImportID ,
    'Y' 
FROM dbo._import_7_1_Sheet1 i
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.insurancecode1 = icp.VendorID AND 
	icp.VendorImportID IN (4,7)
INNER JOIN dbo.Patient p ON 
	i.firstname = p.FirstName AND
    i.lastname = p.LastName AND
    DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) = p.DOB AND
	p.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON 
	p.PatientID = pc.PatientID AND 
	pc.VendorImportID = @VendorImportID
LEFT JOIN dbo.InsurancePolicy ip ON 
	pc.PatientCaseID = ip.PatientCaseID AND 
	ip.PracticeID = @PracticeID
WHERE ip.InsurancePolicyID IS NULL AND i.policynumber1 <> '' AND i.filingorder <> '' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Policy Records Inserted...'

UPDATE dbo.InsurancePolicy
SET PolicyNumber = i.policynumber1 ,
	GroupNumber = CASE WHEN ip.GroupNumber = '' THEN i.groupnumber1 ELSE ip.GroupNumber END
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND 
	pc.PracticeID = @PracticeID
INNER JOIN dbo.Patient p ON
	pc.PatientID = p.PatientID AND 
	p.PracticeID = @PracticeID
INNER JOIN dbo._import_7_1_Sheet1 i ON 
	p.FirstName = i.firstname AND 
	p.LastName = i.lastname AND 
	p.DOB = DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) AND
    p.PracticeID = @PracticeID
WHERE i.filingorder = 1 AND ip.PolicyNumber = '' AND ip.Precedence = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Primary Insurance Policy Records Updated...'


--ROLLBACK
--COMMIT

