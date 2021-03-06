USE superbill_10745_dev
--USE superbill_10745_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


UPDATE dbo.[_import_2_1_PatientDemographics] SET dateofbirth = '' WHERE dateofbirth IN ('5100939','4194955', '4110957')
UPDATE dbo.[_import_2_1_PatientDemographics] SET holder1dateofbirth = '' WHERE holder1dateofbirth IN ('1237978','5100939','4110957','4194955')
UPDATE dbo.[_import_2_1_PatientDemographics] SET holder2dateofbirth = '' WHERE holder2dateofbirth = '4194955'

/*
==========================================================================================================================================
CREATE INSURANCE PLANS FROM [Existing IC]
==========================================================================================================================================
*/	

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , ContactFirstName , ContactLastName , 
	Phone , PhoneExt , Notes , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	Fax , FaxExt , InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	CASE WHEN ICP.planname <> '' THEN LEFT(ICP.planname,128)
		 ELSE ICP.InsuranceCompanyName END  , -- PlanName - varchar(128)
	LEFT(ICP.Address1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.Address2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.City,128) , -- City - varchar(128)
	LEFT(ICP.[State],2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(ICP.ContactFirstName,64) , -- ContactFirstName - varchar(64)
	LEFT(ICP.ContactLastName,64) , -- ContactLastName - varchar(64)
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
	@VendorImportID  -- VendorImportID - int
FROM dbo._import_2_1_InsuranceCOMPANYPLANList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE ICP.InsuranceCompanyName = InsuranceCompanyName AND
										  (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

/*
==========================================================================================================================================
CREATE INSURANCE COMPANIES FROM [_import_2_1_InsuranceCOMPANYPLANList]
==========================================================================================================================================
*/	

PRINT ''
PRINT 'Inserting Into InsuranceCompany...'
INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , ReviewCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	LEFT(CASE 
		WHEN LEN(IICL.insurancecompanyname) > 1 THEN IICL.insurancecompanyname
		ELSE IICL.planname END,128)  , -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
	13 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	CASE scope WHEN 1 THEN 'R' ELSE '' END , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	13 , -- SecondaryPrecedenceBillingFormID - int
	LEFT(CASE 
		WHEN LEN(IICL.insurancecompanyname) > 1 THEN IICL.insurancecompanyname
		ELSE IICL.planname END,50) , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM dbo._import_2_1_InsuranceCOMPANYPLANList AS IICL
WHERE ( insurancecompanyname <> '' OR planname <> '') AND
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = IICL.InsuranceCompanyName AND
														 (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'															 

/*
==========================================================================================================================================
CREATE INSURANCE PLANS FROM [InsuranceCOMPANYPLANList]
==========================================================================================================================================
*/	

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , ContactFirstName , ContactLastName , 
	Phone , PhoneExt , Notes , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	Fax , FaxExt , InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	CASE WHEN ICP.planname <> '' THEN LEFT(ICP.planname,128)
		 ELSE ICP.InsuranceCompanyName END  , -- PlanName - varchar(128)
	LEFT(ICP.Address1,256) , -- AddressLine1 - varchar(256)
	LEFT(ICP.Address2,256) , -- AddressLine2 - varchar(256)
	LEFT(ICP.City,128) , -- City - varchar(128)
	LEFT(ICP.[State],2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.zip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.zip)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	LEFT(ICP.ContactFirstName,64) , -- ContactFirstName - varchar(64)
	LEFT(ICP.ContactLastName,64) , -- ContactLastName - varchar(64)
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
FROM dbo._import_2_1_InsuranceCOMPANYPLANList ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.InsuranceCompanyName, 50) AND
	ICP.Insurancecompanyname = IC.InsuranceCompanyName AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.Insuranceid = OICP.VendorID AND
	OICP.VendorImportID = @VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

CREATE TABLE #temppat (patid INT, chartnumber VARCHAR(25))

PRINT ''
PRINT 'Inserting Into #temppat'
INSERT INTO #temppat
        ( patid , chartnumber )
SELECT DISTINCT
		  PatientID ,  -- patid - int
		  i.chartnumber
FROM dbo.Patient p       
INNER JOIN dbo.[_import_2_1_PatientDemographics] i ON
i.firstname = p.FirstName AND 
i.lastname = p.LastName AND 
CASE WHEN LEN(dateofbirth) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(dateofbirth,1,1),1) + '/' + RIGHT(SUBSTRING(dateofbirth,2,2),4) + '/' + RIGHT(dateofbirth,4) AS DATETIME))
WHEN LEN(dateofbirth) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(dateofbirth,1,2),2) + '/' + RIGHT(SUBSTRING(dateofbirth,3,2),4) + '/' + RIGHT(dateofbirth,4) AS DATETIME)) END = p.DOB
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
( 
	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
)
SELECT DISTINCT 
	P.PatientID , -- PatientID - int
	CASE WHEN pd.DefaultCase = '' THEN 'Default Case' 
		ELSE LEFT(pd.DefaultCase, 128) END , -- Name - varchar(128)
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
	i.chartnumber , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo._import_2_1_PatientDemographics pd
	INNER JOIN #temppat i ON 
		i.chartnumber = pd.chartnumber 
	INNER JOIN dbo.Patient p ON 
		i.patid = p.PatientID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Patient Case Date...'
INSERT INTO dbo.PatientCaseDate
( 
	PracticeID , PatientCaseID , PatientCaseDateTypeID , StartDate , EndDate , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID
)
SELECT DISTINCT
	@PracticeID , -- PracticeID - int
	PC.PatientCaseID , -- PatientCaseID - int
	8 , -- PatientCaseDateTypeID - int
	CASE WHEN LEN(PD.datelastseen) = 7 THEN
	DATEADD(hh,12,CAST(LEFT(SUBSTRING(PD.datelastseen,1,1),1) + '/' + RIGHT(SUBSTRING(PD.datelastseen,2,2),4) + '/' + RIGHT(PD.datelastseen,4) AS DATETIME))
	WHEN LEN(PD.datelastseen) = 8 THEN
	DATEADD(hh,12,CAST(LEFT(SUBSTRING(PD.datelastseen,1,2),2) + '/' + RIGHT(SUBSTRING(PD.datelastseen,3,2),4) + '/' + RIGHT(PD.datelastseen,4) AS DATETIME))
	ELSE NULL END , -- StartDate - datetime
	NULL , -- EndDate - datetime
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0  -- ModifiedUserID - int
FROM dbo._import_2_1_PatientDemographics pd
	INNER JOIN #temppat i ON 
		i.chartnumber = pd.chartnumber 
	INNER JOIN dbo.Patient p ON 
		i.patid = p.PatientID
	INNER JOIN dbo.PatientCase PC ON 
		p.PatientID = pc.PatientID AND
		pc.VendorImportID = @VendorImportID
WHERE pd.datelastseen <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

/*
==========================================================================================================================================
TEMP TABLE FOR INSERTING CASES AND POLICIES
==========================================================================================================================================
*/	

CREATE TABLE #tempPolicies
(
	InsuranceColumnCount INT,
	PatientVendorID VARCHAR(128),
	InsuranceCode VARCHAR(128),
	PolicyNumber VARCHAR(32), 
	GroupNumber VARCHAR(32), 
	PolicyStartDate DATETIME, 
	PolicyEndDate DATETIME, 
	Copay MONEY,
	Deductible INT,
	PatientRelationshipToInsured VARCHAR(MAX), 
	HolderLastName VARCHAR(64), 
	HolderMiddleName VARCHAR(64),
	HolderFirstName VARCHAR(64), 
	HolderStreet1 VARCHAR(256), 
	HolderStreet2 VARCHAR(256), 
	HolderCity VARCHAR(128), 
	HolderState VARCHAR(2), 
	HolderZipCode VARCHAR(9), 
	HolderSSN VARCHAR(9), 
	HolderDOB DATETIME, 
	HolderGender CHAR(1),
	HolderPolicyNumber VARCHAR(32),
	Employer VARCHAR(128),
	PolicyNote VARCHAR(8000)
)


INSERT INTO #tempPolicies
( 
	InsuranceColumnCount , PatientVendorID , InsuranceCode, PolicyNumber , GroupNumber , PolicyStartDate , 
	PolicyEndDate , Copay, Deductible, PatientRelationshipToInsured, HolderLastName , HolderMiddleName , 
	HolderFirstName , HolderStreet1 , HolderStreet2 , HolderCity , HolderState , HolderZipCode , HolderSSN , 
	HolderDOB , HolderGender , HolderPolicyNumber, Employer, PolicyNote
)
SELECT DISTINCT
	InsuranceColumnCount,
	PatientVendorID,
	InsuranceCode, 
	LEFT(PolicyNumber, 32),
	LEFT(GroupNumber, 32),
	PolicyStartDate, 
	PolicyEndDate, 
	Copay,
	Deductible,
	PatientRelationshipToInsured,
	LEFT(HolderLastName, 64),
	LEFT(HolderMiddleName, 64),
	LEFT(HolderFirstName, 64),
	LEFT(HolderStreet1, 256),
	LEFT(HolderStreet2, 256),
	LEFT(HolderCity, 128),
	LEFT(HolderState, 2),
	LEFT(HolderZipCode, 9),
	LEFT(HolderSSN, 9),
	HolderDOB, 
	LEFT(HolderGender, 1),
	HolderPolicyNumber,
	Employer,
	PolicyNote
FROM
(	SELECT DISTINCT 
		1 AS InsuranceColumnCount, ChartNumber AS PatientVendorID, InsuranceCode1 AS InsuranceCode, 
		policynumber1 AS PolicyNumber, groupnumber1 AS GroupNumber, 	
		CASE WHEN LEN(policy1startdate) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy1startdate,1,1),1) + '/' + RIGHT(SUBSTRING(policy1startdate,2,2),4) + '/' + RIGHT(policy1startdate,4) AS DATETIME))
		WHEN LEN(policy1startdate) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy1startdate,1,2),2) + '/' + RIGHT(SUBSTRING(policy1startdate,3,2),4) + '/' + RIGHT(policy1startdate,4) AS DATETIME))
		ELSE NULL END AS PolicyStartDate, 
		CASE WHEN LEN(policy1enddate) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy1enddate,1,1),1) + '/' + RIGHT(SUBSTRING(policy1enddate,2,2),4) + '/' + RIGHT(policy1enddate,4) AS DATETIME))
		WHEN LEN(policy1enddate) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy1enddate,1,2),2) + '/' + RIGHT(SUBSTRING(policy1enddate,3,2),4) + '/' + RIGHT(policy1enddate,4) AS DATETIME))
		ELSE NULL END AS PolicyEndDate, 
		policy1copay AS Copay, policy1deductible AS Deductible,  patientrelationship1 AS 
		PatientRelationshipToInsured, holder1lastname AS HolderLastName, Holder1middlename AS HolderMiddleName, 
		Holder1firstname AS HolderFirstName, Holder1street1 AS HolderStreet1, holder1street2 AS HolderStreet2, 
		holder1city AS HolderCity, holder1state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder1zipcode) AS 
		HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder1ssn) AS holderSSN, 
		CASE WHEN LEN(Holder1Dateofbirth) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(Holder1Dateofbirth,1,1),1) + '/' + RIGHT(SUBSTRING(Holder1Dateofbirth,2,2),4) + '/' + RIGHT(Holder1Dateofbirth,4) AS DATETIME))
		WHEN LEN(Holder1Dateofbirth) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(Holder1Dateofbirth,1,2),2) + '/' + RIGHT(SUBSTRING(Holder1Dateofbirth,3,2),4) + '/' + RIGHT(Holder1Dateofbirth,4) AS DATETIME)) ELSE NULL END AS HolderDOB, 
	    CASE WHEN Holder1gender IN ('M','Male') THEN 'M' WHEN Holder1gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
		holder1PolicyNumber AS HolderPolicyNumber, Employer1 AS Employer, Policy1Note AS PolicyNote
	FROM dbo._import_2_1_PatientDemographics
	WHERE insurancecode1 <> ''
	
	UNION
  	
	SELECT DISTINCT 
		2 AS InsuranceColumnCount, ChartNumber AS PatientVendorID, InsuranceCode2 AS InsuranceCode, 
		policynumber2 AS PolicyNumber, groupnumber2 AS GroupNumber, 
		CASE WHEN LEN(policy2startdate) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy2startdate,1,1),1) + '/' + RIGHT(SUBSTRING(policy2startdate,2,2),4) + '/' + RIGHT(policy2startdate,4) AS DATETIME))
		WHEN LEN(policy2startdate) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy2startdate,1,2),2) + '/' + RIGHT(SUBSTRING(policy2startdate,3,2),4) + '/' + RIGHT(policy2startdate,4) AS DATETIME))
		ELSE NULL END AS PolicyStartDate, 
		CASE WHEN LEN(policy2enddate) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy2enddate,1,1),1) + '/' + RIGHT(SUBSTRING(policy2enddate,2,2),4) + '/' + RIGHT(policy2enddate,4) AS DATETIME))
		WHEN LEN(policy2enddate) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy2enddate,1,2),2) + '/' + RIGHT(SUBSTRING(policy2enddate,3,2),4) + '/' + RIGHT(policy2enddate,4) AS DATETIME))
		ELSE NULL END AS PolicyEndDate, 
		policy2copay AS Copay, policy2deductible AS Deductible,  patientrelationship2 AS
		PatientRelationshipToInsured, holder2lastname AS HolderLastName, Holder2middlename AS HolderMiddleName, 
		Holder2firstname AS HolderFirstName, Holder2street1 AS HolderStreet1, holder2street2 AS HolderStreet2, 
		holder2city AS HolderCity, holder2state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder2zipcode) 
		AS HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder2ssn) AS holderSSN, 
		CASE WHEN LEN(Holder2Dateofbirth) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(Holder2Dateofbirth,1,1),1) + '/' + RIGHT(SUBSTRING(Holder2Dateofbirth,2,2),4) + '/' + RIGHT(Holder2Dateofbirth,4) AS DATETIME))
		WHEN LEN(Holder2Dateofbirth) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(Holder2Dateofbirth,1,2),2) + '/' + RIGHT(SUBSTRING(Holder2Dateofbirth,3,2),4) + '/' + RIGHT(Holder2Dateofbirth,4) AS DATETIME)) ELSE NULL END AS HolderDOB, 
		CASE WHEN Holder2gender IN ('M','Male') THEN 'M' WHEN Holder2gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
		holder2PolicyNumber AS HolderPolicyNumber, Employer2 AS Employer, Policy2Note AS PolicyNote
	FROM dbo._import_2_1_PatientDemographics
	WHERE insurancecode2 <> ''  
	
	UNION
  	
	SELECT DISTINCT 
		3 AS InsuranceColumnCount, ChartNumber AS PatientVendorID, InsuranceCode3 AS InsuranceCode, 
		policynumber3 AS PolicyNumber, groupnumber3 AS GroupNumber, 
		CASE WHEN LEN(policy3startdate) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy3startdate,1,1),1) + '/' + RIGHT(SUBSTRING(policy3startdate,2,2),4) + '/' + RIGHT(policy3startdate,4) AS DATETIME))
		WHEN LEN(policy3startdate) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy3startdate,1,2),2) + '/' + RIGHT(SUBSTRING(policy3startdate,3,2),4) + '/' + RIGHT(policy3startdate,4) AS DATETIME))
		ELSE NULL END AS PolicyStartDate, 
		CASE WHEN LEN(policy3enddate) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy3enddate,1,1),1) + '/' + RIGHT(SUBSTRING(policy3enddate,2,2),4) + '/' + RIGHT(policy3enddate,4) AS DATETIME))
		WHEN LEN(policy3enddate) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy3enddate,1,2),2) + '/' + RIGHT(SUBSTRING(policy3enddate,3,2),4) + '/' + RIGHT(policy3enddate,4) AS DATETIME))
		ELSE NULL END AS PolicyEndDate, 
		policy3copay AS Copay, policy3deductible AS Deductible,  patientrelationship3 AS
		PatientRelationshipToInsured, holder3lastname AS HolderLastName, Holder3middlename AS HolderMiddleName, 
		Holder3firstname AS HolderFirstName, Holder3street1 AS HolderStreet1, holder3street2 AS HolderStreet2, 
		holder3city AS HolderCity, holder3state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder3zipcode) 
		AS HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder3ssn) AS holderSSN, 
		CASE WHEN LEN(Holder3Dateofbirth) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(Holder3Dateofbirth,1,1),1) + '/' + RIGHT(SUBSTRING(Holder3Dateofbirth,2,2),4) + '/' + RIGHT(Holder3Dateofbirth,4) AS DATETIME))
		WHEN LEN(Holder3Dateofbirth) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(Holder3Dateofbirth,1,2),2) + '/' + RIGHT(SUBSTRING(Holder3Dateofbirth,3,2),4) + '/' + RIGHT(Holder3Dateofbirth,4) AS DATETIME)) ELSE NULL END AS HolderDOB, 
		CASE WHEN Holder3gender IN ('M','Male') THEN 'M' WHEN Holder3gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
		holder3PolicyNumber AS HolderPolicyNumber, Employer3 AS Employer, Policy3Note AS PolicyNote
	FROM dbo._import_2_1_PatientDemographics
	WHERE  insurancecode3 <> ''  
) AS Y
ORDER BY InsuranceColumnCount



/*
==========================================================================================================================================
CREATE INSURANCE POLICIES  
==========================================================================================================================================
*/
PRINT ''
PRINT 'Inserting Into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
( 
	PatientCaseID , InsuranceCompanyPlanID , Precedence , PolicyNumber , GroupNumber , PolicyStartDate , PolicyEndDate , CardOnFile , PatientRelationshipToInsured , 
	HolderPrefix , HolderFirstName , HolderMiddleName , HolderLastName , HolderSuffix , HolderDOB , HolderSSN , HolderThroughEmployer , HolderEmployerName , 
	PatientInsuranceStatusID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , HolderGender , HolderAddressLine1 , HolderAddressLine2 , HolderCity , 
	HolderState , HolderZipCode , HolderPhone , HolderPhoneExt , DependentPolicyNumber , Notes , Copay , Deductible , Active , PracticeID , VendorID , 
	VendorImportID , GroupName , ReleaseOfInformation , SyncWithEHR 
)
SELECT DISTINCT
	PC.PatientCaseID , -- PatientCaseID - int
	ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
	TP.InsuranceColumnCount , -- case - int
	LEFT(TP.PolicyNumber,32), -- PolicyNumber - varchar(32)
	LEFT(TP.GroupNumber,32), -- GroupNumber - varchar(32)
	CASE WHEN ISDATE(TP.PolicyStartDate) = 1 AND TP.PolicyStartDate <> '1900-01-01' THEN TP.PolicyStartDate ELSE NULL END,
	CASE WHEN ISDATE(TP.PolicyEndDate) = 1 AND TP.PolicyEndDate <> '1900-01-01' THEN TP.PolicyEndDate ELSE NULL END,
	0, -- CardOnFile - bit
	CASE
		WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN 'S'
		WHEN PatientRelationshipToInsured IN ('C','Child') THEN 'C'
		WHEN PatientRelationshipToInsured IN ('O','Other') THEN 'O'
		WHEN PatientRelationshipToInsured IN ('U','Spouse') THEN 'U'
		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
	'', -- HolderPrefix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderFirstName,64) END, -- HolderFirstName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderMiddleName,64) END, -- HolderMiddleName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderLastName,64) END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN NULL ELSE CASE WHEN ISDATE(HolderDOB) = 1 AND HolderDOB <> '1/1/1900' THEN HolderDOB ELSE NULL END END, -- HolderDOB - datetime
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN LEN(HolderSSN) = 9 THEN HolderSSN ELSE NULL END END, -- HolderSSN
	CASE WHEN TP.Employer <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
	CASE WHEN TP.Employer <> '' THEN TP.Employer ELSE '' END , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN HolderGender IN ('M','Male') THEN 'M' WHEN HolderGender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(HolderStreet1,256) END, -- HolderAddressLine1 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(HolderStreet2,256) END , -- HolderAddressLine2 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(HolderCity,128) END, -- HolderCity - varchar(128)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE UPPER(LEFT(HolderState,2)) END, -- HolderState
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE 
		WHEN LEN(HolderZipCode) IN (5,9) THEN HolderZipCode
		WHEN LEN(HolderZipCode) = 4 THEN '0' + HolderZipCode
		ELSE '' END END, -- HolderZipCode - varchar(9)
	'', -- HolderPhone - varchar(10)
	'' , -- HolderPhoneExt - varchar(10)
	LEFT(TP.PolicyNumber, 32) , -- DependentPolicyNumber - varchar(32)
    TP.PolicyNote + CHAR(13) + CHAR(10) + CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
	TP.Copay, -- Copay - money
	TP.Deductible, -- Deductible - money
	1, -- Active - bit
	@PracticeID , -- PracticeID - int
	pc.VendorID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	'' , -- GroupName - varchar(14)
	'Y' , -- ReleaseOfInformation - varchar(1)
	1
FROM #tempPolicies AS TP
	JOIN dbo.PatientCase AS PC ON tp.PatientVendorID = pc.VendorID AND PC.VendorImportID = @VendorImportID
	JOIN dbo.Patient AS PAT ON pc.PatientID = PAT.PatientID AND PAT.PracticeID = @PracticeID
	JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	


/*
==========================================================================================================================================
CREATE PATIENTS
==========================================================================================================================================
*/	



DECLARE @DefaultCollectionCategory INT
SET @DefaultCollectionCategory = (SELECT CollectionCategoryID FROM dbo.CollectionCategory WHERE IsDefaultCategory = 1)
PRINT ''
PRINT 'Inserting Into Patient...'
INSERT INTO dbo.Patient
( 
	PracticeID , ReferringPhysicianID , Prefix, Suffix, FirstName , MiddleName , LastName , AddressLine1 , AddressLine2 , City , State , ZipCode , Gender , 
	MaritalStatus , HomePhone , HomePhoneExt , WorkPhone , WorkPhoneExt , DOB , SSN , EmailAddress , ResponsibleDifferentThanPatient , ResponsiblePrefix, ResponsibleFirstName,
	ResponsibleMiddleName, ResponsibleLastName, ResponsibleSuffix, ResponsibleRelationshipToPatient, ResponsibleAddressLine1, ResponsibleAddressline2, ResponsibleCity, ResponsibleState,
	ResponsibleZipCode, CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , EmploymentStatus , PrimaryProviderID , DefaultServiceLocationID , EmployerID , MedicalRecordNumber , 
	MobilePhone , MobilePhoneExt , PrimaryCarePhysicianID , VendorID , VendorImportID , CollectionCategoryID , Active , SendEmailCorrespondence , 
	PhonecallRemindersEnabled, EmergencyName, EmergencyPhone, EmergencyPhoneExt
)
SELECT DISTINCT
	@PracticeID , -- PracticeID - int
	ReferringDoc.DoctorID , -- ReferringPhysicianID - int
	'' , -- Prefix 
	LEFT(PD.suffix, 16) , -- Suffix
	LEFT(PD.firstname,64) , -- FirstName - varchar(64)
	LEFT(PD.middleinitial,64) , -- MiddleName - varchar(64)
	LEFT(PD.lastname,64) , -- LastName - varchar(64)
	LEFT(PD.address1,256) , -- AddressLine1 - varchar(256)
	LEFT(PD.address2,256) , -- AddressLine2 - varchar(256)
	LEFT(PD.city,128) , -- City - varchar(128)
	UPPER(LEFT(PD.state,2)) , -- State - varchar(2)
	CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.zipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(PD.zipcode)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.zipcode)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(PD.zipcode)
		ELSE '' END , -- ZipCode - varchar(9)
	CASE
		WHEN PD.gender IN ('M','Male') THEN 'M'
		WHEN PD.gender IN ('F','Female') THEN 'F'
		ELSE 'U' END , -- Gender - varchar(1)
	CASE 
		WHEN PD.maritalstatus IN ('D','Divorced') THEN 'D'
		WHEN PD.maritalstatus IN ('M','Married') THEN 'M'
		WHEN PD.maritalstatus IN ('S','Single') THEN 'S'
		WHEN PD.maritalstatus IN ('W','Widowed') THEN 'W'
		ELSE '' END , -- MaritalStatus - varchar(1)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.homephone),10)
		ELSE '' END, -- HomePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(PD.homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone))),10)
		ELSE NULL END , -- HomePhoneExt - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.workphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.workphone),10)
		ELSE '' END , -- WorkPhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.workphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(PD.homephone),11,LEN(dbo.fn_RemoveNonNumericCharacters(PD.homephone))),10)
		ELSE NULL END , -- WorkPhoneExt - varchar(10)
	CASE 
		WHEN LEN(dateofbirth) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(dateofbirth,1,1),1) + '/' + RIGHT(SUBSTRING(dateofbirth,2,2),4) + '/' + RIGHT(dateofbirth,4) AS DATETIME))
		WHEN LEN(dateofbirth) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(dateofbirth,1,2),2) + '/' + RIGHT(SUBSTRING(dateofbirth,3,2),4) + '/' + RIGHT(dateofbirth,4) AS DATETIME)) 
		ELSE NULL END , -- DOB - datetime
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.SSN)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(PD.SSN), 9)
		ELSE NULL END , -- SSN - char(9)
	LEFT(PD.email,256) , -- EmailAddress - varchar(256)
	CASE WHEN PD.responsiblepartyrelationship  <> '' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
	'' , -- ResponsiblePrefix - varchar(16)
	LEFT(PD.responsiblepartyfirstname, 64) , -- ResponsibleFirstName - varchar(64)
	LEFT(PD.responsiblepartymiddlename, 64) , -- ResponsibleMiddleName - varchar(64)
	LEFT(PD.responsiblepartylastname, 64) , -- ResposibleLastName - varchar(64)
	LEFT(PD.responsiblepartysuffix, 16) , -- ResponsibleSuffix - varchar(16)
	CASE WHEN PD.responsiblepartyrelationship IN ('C','Child') THEN 'C'
         WHEN PD.responsiblepartyrelationship IN ('U','Spouse') THEN 'U'
         WHEN PD.responsiblepartyrelationship IN ('O','Other') THEN 'O'
	ELSE NULL END , -- ResponsibleRelationshipToPatient (char)
	LEFT(PD.responsiblepartyaddress1, 256) , -- ResponsibleAddressLine1 - varchar(256)
	LEFT(PD.responsiblepartyaddress2, 256) , -- ResponsibleAddressLine2 - varchar(256)
	LEFT(PD.responsiblepartycity, 128) , -- ResponsibleCity - varchar(128) 
	LEFT(PD.responsiblepartystate, 2) , -- ResponsibleState - varchar(2)
	LEFT(REPLACE(PD.responsiblepartyzipcode, '-',''), 9) , -- ResponsibleZipCode - varchar(9)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	CASE
		WHEN PD.employmentstatus IN ('E','Employed') THEN 'E'
		WHEN PD.employmentstatus IN ('R','Retired') THEN 'R'
		WHEN PD.employmentstatus IN ('S','Student, Full-Time') THEN 'S'
		WHEN PD.employmentstatus IN ('T','Student, Part-Time') THEN 'T'
		ELSE 'U' END, -- EmploymentStatus - char(1)
	PrimaryProvider.DoctorID , -- PrimaryProviderID - int 
	CASE WHEN SL.ServiceLocationID IS NOT NULL THEN SL.ServiceLocationID
		ELSE SL2.ServiceLocationID END , -- DefaultServiceLocationID - int 
	E.EmployerID, -- EmployerID - int 
	LEFT(PD.chartnumber,128) , -- MedicalRecordNumber - varchar(128)
	CASE
		WHEN LEN(PD.cellphone) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.cellphone),10)
		ELSE '' END , -- MobilePhone - varchar(10)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.cellphone)) > 10 THEN LEFT(SUBSTRING(dbo.fn_RemoveNonNumericCharacters(PD.cellphone),11,LEN(dbo.fn_RemoveNonNumericCharacters(PD.cellphone))),10)
		ELSE NULL END , -- MobilePhoneExt - varchar(10)
	PrimaryCare.DoctorID , -- PrimaryCarePhysicianID - int 
	PD.ChartNumber , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	@DefaultCollectionCategory , -- CollectionCategoryID - int
	CASE 
		WHEN PD.Active IN ('0','No','N','Inactive') THEN 0
		ELSE 1 END, -- Active - bit
	1, -- SendEmailCorrespondence - bit
	0,  -- PhonecallRemindersEnabled - bit
	LEFT(PD.EmergencyName,128) , -- EmergencyName - varchar(128)
	CASE
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(PD.Emergencyphone)) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(PD.Emergencyphone),10)
		ELSE '' END , -- EmergencyPhone - varchar(10)
	LEFT(dbo.fn_RemoveNonNumericCharacters(PD.Emergencyphoneext),10) -- EmergencyPhoneExt - varchar(10)
FROM dbo._import_2_1_PatientDemographics AS PD
	LEFT JOIN dbo.Doctor AS ReferringDoc ON 
			ReferringDoc.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS RD WHERE RD.FirstName = PD.ReferringPhysicianFirstName AND 
											RD.LastName = PD.ReferringPhysicianLastName AND RD.PracticeID = @PracticeID AND RD.ActiveDoctor = 1)
	LEFT JOIN dbo.Doctor AS PrimaryProvider ON 
			PrimaryProvider.FirstName = PD.PrimaryProviderFirstName AND 
			PrimaryProvider.LastName = PD.PrimaryProviderLastName AND 
			PrimaryProvider.[External] = 0 AND 
			PrimaryProvider.PracticeID = @PracticeID AND
			PrimaryProvider.ActiveDoctor = 1
	LEFT JOIN dbo.Doctor AS PrimaryCare ON 
		PrimaryCare.DoctorID = (SELECT MIN(DoctorID) FROM dbo.Doctor AS PC WHERE PC.FirstName = PD.primarycarephysicianfirstname AND 
									PC.LastName = PD.Primarycarephysicianlastname AND PC.PracticeID = @PracticeID AND PC.ActiveDoctor = 1)
	LEFT JOIN dbo.ServiceLocation AS SL ON SL.Name = PD.defaultservicelocation
	LEFT JOIN dbo.ServiceLocation AS SL2 ON 1 = 1 AND SL2.ServiceLocationID = (SELECT TOP 1 ServiceLocationID FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID) 
	LEFT JOIN dbo.Employers AS E ON E.EmployerID = (SELECT TOP 1 E2.EmployerID FROM dbo.Employers E2 WHERE E2.EmployerName = LEFT(PD.employername,128) AND E2.AddressLine1 = LEFT(PD.employeraddress1,256) AND E2.State = LEFT(PD.employerstate,2))
WHERE PD.firstname <> '' AND PD.lastname <> '' AND
NOT EXISTS (SELECT * FROM dbo.Patient p WHERE
			p.FirstName = pd.firstname AND 
			p.LastName = pd.lastname AND 
			p.DOB = CASE 
					WHEN LEN(pd.dateofbirth) = 7 THEN
					DATEADD(hh,12,CAST(LEFT(SUBSTRING(pd.dateofbirth,1,1),1) + '/' + RIGHT(SUBSTRING(pd.dateofbirth,2,2),4) + '/' + RIGHT(pd.dateofbirth,4) AS DATETIME))
						WHEN LEN(pd.dateofbirth) = 8 THEN
					DATEADD(hh,12,CAST(LEFT(SUBSTRING(pd.dateofbirth,1,2),2) + '/' + RIGHT(SUBSTRING(pd.dateofbirth,3,2),4) + '/' + RIGHT(pd.dateofbirth,4) AS DATETIME))
					END)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
( 
	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
)
SELECT DISTINCT 
	P.PatientID , -- PatientID - int
	CASE WHEN pd.DefaultCase = '' THEN 'Default Case' 
		ELSE LEFT(pd.DefaultCase, 128) END , -- Name - varchar(128)
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
	p.VendorID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.Patient p 
INNER JOIN dbo.[_import_2_1_PatientDemographics] pd ON
	p.VendorID = pd.chartnumber AND 
	p.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

/*
==========================================================================================================================================
TEMP TABLE FOR INSERTING CASES AND POLICIES
==========================================================================================================================================
*/	

CREATE TABLE #tempPolicies2
(
	InsuranceColumnCount INT,
	PatientVendorID VARCHAR(128),
	InsuranceCode VARCHAR(128),
	PolicyNumber VARCHAR(32), 
	GroupNumber VARCHAR(32), 
	PolicyStartDate DATETIME, 
	PolicyEndDate DATETIME, 
	Copay MONEY,
	Deductible INT,
	PatientRelationshipToInsured VARCHAR(MAX), 
	HolderLastName VARCHAR(64), 
	HolderMiddleName VARCHAR(64),
	HolderFirstName VARCHAR(64), 
	HolderStreet1 VARCHAR(256), 
	HolderStreet2 VARCHAR(256), 
	HolderCity VARCHAR(128), 
	HolderState VARCHAR(2), 
	HolderZipCode VARCHAR(9), 
	HolderSSN VARCHAR(9), 
	HolderDOB DATETIME, 
	HolderGender CHAR(1),
	HolderPolicyNumber VARCHAR(32),
	Employer VARCHAR(128),
	PolicyNote VARCHAR(8000)
)


INSERT INTO #tempPolicies2
( 
	InsuranceColumnCount , PatientVendorID , InsuranceCode, PolicyNumber , GroupNumber , PolicyStartDate , 
	PolicyEndDate , Copay, Deductible, PatientRelationshipToInsured, HolderLastName , HolderMiddleName , 
	HolderFirstName , HolderStreet1 , HolderStreet2 , HolderCity , HolderState , HolderZipCode , HolderSSN , 
	HolderDOB , HolderGender , HolderPolicyNumber, Employer, PolicyNote
)
SELECT DISTINCT
	InsuranceColumnCount,
	PatientVendorID,
	InsuranceCode, 
	LEFT(PolicyNumber, 32),
	LEFT(GroupNumber, 32),
	PolicyStartDate, 
	PolicyEndDate, 
	Copay,
	Deductible,
	PatientRelationshipToInsured,
	LEFT(HolderLastName, 64),
	LEFT(HolderMiddleName, 64),
	LEFT(HolderFirstName, 64),
	LEFT(HolderStreet1, 256),
	LEFT(HolderStreet2, 256),
	LEFT(HolderCity, 128),
	LEFT(HolderState, 2),
	LEFT(HolderZipCode, 9),
	LEFT(HolderSSN, 9),
	HolderDOB, 
	LEFT(HolderGender, 1),
	HolderPolicyNumber,
	Employer,
	PolicyNote
FROM
(	SELECT DISTINCT 
		1 AS InsuranceColumnCount, ChartNumber AS PatientVendorID, InsuranceCode1 AS InsuranceCode, 
		policynumber1 AS PolicyNumber, groupnumber1 AS GroupNumber, 	
		CASE WHEN LEN(policy1startdate) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy1startdate,1,1),1) + '/' + RIGHT(SUBSTRING(policy1startdate,2,2),4) + '/' + RIGHT(policy1startdate,4) AS DATETIME))
		WHEN LEN(policy1startdate) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy1startdate,1,2),2) + '/' + RIGHT(SUBSTRING(policy1startdate,3,2),4) + '/' + RIGHT(policy1startdate,4) AS DATETIME))
		ELSE NULL END AS PolicyStartDate, 
		CASE WHEN LEN(policy1enddate) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy1enddate,1,1),1) + '/' + RIGHT(SUBSTRING(policy1enddate,2,2),4) + '/' + RIGHT(policy1enddate,4) AS DATETIME))
		WHEN LEN(policy1enddate) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy1enddate,1,2),2) + '/' + RIGHT(SUBSTRING(policy1enddate,3,2),4) + '/' + RIGHT(policy1enddate,4) AS DATETIME))
		ELSE NULL END AS PolicyEndDate, 
		policy1copay AS Copay, policy1deductible AS Deductible,  patientrelationship1 AS 
		PatientRelationshipToInsured, holder1lastname AS HolderLastName, Holder1middlename AS HolderMiddleName, 
		Holder1firstname AS HolderFirstName, Holder1street1 AS HolderStreet1, holder1street2 AS HolderStreet2, 
		holder1city AS HolderCity, holder1state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder1zipcode) AS 
		HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder1ssn) AS holderSSN, 
		CASE WHEN LEN(Holder1Dateofbirth) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(Holder1Dateofbirth,1,1),1) + '/' + RIGHT(SUBSTRING(Holder1Dateofbirth,2,2),4) + '/' + RIGHT(Holder1Dateofbirth,4) AS DATETIME))
		WHEN LEN(Holder1Dateofbirth) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(Holder1Dateofbirth,1,2),2) + '/' + RIGHT(SUBSTRING(Holder1Dateofbirth,3,2),4) + '/' + RIGHT(Holder1Dateofbirth,4) AS DATETIME)) ELSE NULL END AS HolderDOB, 
	    CASE WHEN Holder1gender IN ('M','Male') THEN 'M' WHEN Holder1gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
		holder1PolicyNumber AS HolderPolicyNumber, Employer1 AS Employer, Policy1Note AS PolicyNote
	FROM dbo._import_2_1_PatientDemographics
	WHERE insurancecode1 <> ''
	
	UNION
  	
	SELECT DISTINCT 
		2 AS InsuranceColumnCount, ChartNumber AS PatientVendorID, InsuranceCode2 AS InsuranceCode, 
		policynumber2 AS PolicyNumber, groupnumber2 AS GroupNumber, 
		CASE WHEN LEN(policy2startdate) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy2startdate,1,1),1) + '/' + RIGHT(SUBSTRING(policy2startdate,2,2),4) + '/' + RIGHT(policy2startdate,4) AS DATETIME))
		WHEN LEN(policy2startdate) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy2startdate,1,2),2) + '/' + RIGHT(SUBSTRING(policy2startdate,3,2),4) + '/' + RIGHT(policy2startdate,4) AS DATETIME))
		ELSE NULL END AS PolicyStartDate, 
		CASE WHEN LEN(policy2enddate) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy2enddate,1,1),1) + '/' + RIGHT(SUBSTRING(policy2enddate,2,2),4) + '/' + RIGHT(policy2enddate,4) AS DATETIME))
		WHEN LEN(policy2enddate) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy2enddate,1,2),2) + '/' + RIGHT(SUBSTRING(policy2enddate,3,2),4) + '/' + RIGHT(policy2enddate,4) AS DATETIME))
		ELSE NULL END AS PolicyEndDate, 
		policy2copay AS Copay, policy2deductible AS Deductible,  patientrelationship2 AS
		PatientRelationshipToInsured, holder2lastname AS HolderLastName, Holder2middlename AS HolderMiddleName, 
		Holder2firstname AS HolderFirstName, Holder2street1 AS HolderStreet1, holder2street2 AS HolderStreet2, 
		holder2city AS HolderCity, holder2state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder2zipcode) 
		AS HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder2ssn) AS holderSSN, 
		CASE WHEN LEN(Holder2Dateofbirth) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(Holder2Dateofbirth,1,1),1) + '/' + RIGHT(SUBSTRING(Holder2Dateofbirth,2,2),4) + '/' + RIGHT(Holder2Dateofbirth,4) AS DATETIME))
		WHEN LEN(Holder2Dateofbirth) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(Holder2Dateofbirth,1,2),2) + '/' + RIGHT(SUBSTRING(Holder2Dateofbirth,3,2),4) + '/' + RIGHT(Holder2Dateofbirth,4) AS DATETIME)) ELSE NULL END AS HolderDOB, 
		CASE WHEN Holder2gender IN ('M','Male') THEN 'M' WHEN Holder2gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
		holder2PolicyNumber AS HolderPolicyNumber, Employer2 AS Employer, Policy2Note AS PolicyNote
	FROM dbo._import_2_1_PatientDemographics
	WHERE insurancecode2 <> ''  
	
	UNION
  	
	SELECT DISTINCT 
		3 AS InsuranceColumnCount, ChartNumber AS PatientVendorID, InsuranceCode3 AS InsuranceCode, 
		policynumber3 AS PolicyNumber, groupnumber3 AS GroupNumber, 
		CASE WHEN LEN(policy3startdate) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy3startdate,1,1),1) + '/' + RIGHT(SUBSTRING(policy3startdate,2,2),4) + '/' + RIGHT(policy3startdate,4) AS DATETIME))
		WHEN LEN(policy3startdate) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy3startdate,1,2),2) + '/' + RIGHT(SUBSTRING(policy3startdate,3,2),4) + '/' + RIGHT(policy3startdate,4) AS DATETIME))
		ELSE NULL END AS PolicyStartDate, 
		CASE WHEN LEN(policy3enddate) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy3enddate,1,1),1) + '/' + RIGHT(SUBSTRING(policy3enddate,2,2),4) + '/' + RIGHT(policy3enddate,4) AS DATETIME))
		WHEN LEN(policy3enddate) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(policy3enddate,1,2),2) + '/' + RIGHT(SUBSTRING(policy3enddate,3,2),4) + '/' + RIGHT(policy3enddate,4) AS DATETIME))
		ELSE NULL END AS PolicyEndDate, 
		policy3copay AS Copay, policy3deductible AS Deductible,  patientrelationship3 AS
		PatientRelationshipToInsured, holder3lastname AS HolderLastName, Holder3middlename AS HolderMiddleName, 
		Holder3firstname AS HolderFirstName, Holder3street1 AS HolderStreet1, holder3street2 AS HolderStreet2, 
		holder3city AS HolderCity, holder3state AS HolderState, dbo.fn_RemoveNonNumericCharacters(Holder3zipcode) 
		AS HolderZipCode, dbo.fn_RemoveNonNumericCharacters(Holder3ssn) AS holderSSN, 
		CASE WHEN LEN(Holder3Dateofbirth) = 7 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(Holder3Dateofbirth,1,1),1) + '/' + RIGHT(SUBSTRING(Holder3Dateofbirth,2,2),4) + '/' + RIGHT(Holder3Dateofbirth,4) AS DATETIME))
		WHEN LEN(Holder3Dateofbirth) = 8 THEN DATEADD(hh,12,CAST(LEFT(SUBSTRING(Holder3Dateofbirth,1,2),2) + '/' + RIGHT(SUBSTRING(Holder3Dateofbirth,3,2),4) + '/' + RIGHT(Holder3Dateofbirth,4) AS DATETIME)) ELSE NULL END AS HolderDOB, 
		CASE WHEN Holder3gender IN ('M','Male') THEN 'M' WHEN Holder3gender IN ('F','Female') THEN 'F' ELSE 'U' END AS HolderGender,
		holder3PolicyNumber AS HolderPolicyNumber, Employer3 AS Employer, Policy3Note AS PolicyNote
	FROM dbo._import_2_1_PatientDemographics
	WHERE  insurancecode3 <> ''  
) AS Y
ORDER BY InsuranceColumnCount



/*
==========================================================================================================================================
CREATE INSURANCE POLICIES  
==========================================================================================================================================
*/
PRINT ''
PRINT 'Inserting Into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
( 
	PatientCaseID , InsuranceCompanyPlanID , Precedence , PolicyNumber , GroupNumber , PolicyStartDate , PolicyEndDate , CardOnFile , PatientRelationshipToInsured , 
	HolderPrefix , HolderFirstName , HolderMiddleName , HolderLastName , HolderSuffix , HolderDOB , HolderSSN , HolderThroughEmployer , HolderEmployerName , 
	PatientInsuranceStatusID , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , HolderGender , HolderAddressLine1 , HolderAddressLine2 , HolderCity , 
	HolderState , HolderZipCode , HolderPhone , HolderPhoneExt , DependentPolicyNumber , Notes , Copay , Deductible , Active , PracticeID , VendorID , 
	VendorImportID , GroupName , ReleaseOfInformation , SyncWithEHR 
)
SELECT DISTINCT
	PC.PatientCaseID , -- PatientCaseID - int
	ICP.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
	TP.InsuranceColumnCount , -- case - int
	LEFT(TP.PolicyNumber,32), -- PolicyNumber - varchar(32)
	LEFT(TP.GroupNumber,32), -- GroupNumber - varchar(32)
	CASE WHEN ISDATE(TP.PolicyStartDate) = 1 AND TP.PolicyStartDate <> '1900-01-01' THEN TP.PolicyStartDate ELSE NULL END,
	CASE WHEN ISDATE(TP.PolicyEndDate) = 1 AND TP.PolicyEndDate <> '1900-01-01' THEN TP.PolicyEndDate ELSE NULL END,
	0, -- CardOnFile - bit
	CASE
		WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN 'S'
		WHEN PatientRelationshipToInsured IN ('C','Child') THEN 'C'
		WHEN PatientRelationshipToInsured IN ('O','Other') THEN 'O'
		WHEN PatientRelationshipToInsured IN ('U','Spouse') THEN 'U'
		ELSE 'S' END, -- PatientRelationshipToInsured - varchar(1)
	'', -- HolderPrefix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderFirstName,64) END, -- HolderFirstName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderMiddleName,64) END, -- HolderMiddleName - varchar(64)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(TP.HolderLastName,64) END, -- HolderLastName - varchar(64)
	'', -- HolderSuffix - varchar(16)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN NULL ELSE CASE WHEN ISDATE(HolderDOB) = 1 AND HolderDOB <> '1/1/1900' THEN HolderDOB ELSE NULL END END, -- HolderDOB - datetime
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN LEN(HolderSSN) = 9 THEN HolderSSN ELSE NULL END END, -- HolderSSN
	CASE WHEN TP.Employer <> '' THEN 1 ELSE 0 END , -- HolderThroughEmployer - bit
	CASE WHEN TP.Employer <> '' THEN TP.Employer ELSE '' END , -- HolderEmployerName - varchar(128)
	0 , -- PatientInsuranceStatusID - int
	GETDATE(),
	0 , -- CreatedUserID - int
	GETDATE(),
	0 , -- ModifiedUserID - int
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE WHEN HolderGender IN ('M','Male') THEN 'M' WHEN HolderGender IN ('F','Female') THEN 'F' ELSE 'U' END END, -- HolderGender - char(1)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(HolderStreet1,256) END, -- HolderAddressLine1 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(HolderStreet2,256) END , -- HolderAddressLine2 - varchar(256)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE LEFT(HolderCity,128) END, -- HolderCity - varchar(128)
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE UPPER(LEFT(HolderState,2)) END, -- HolderState
	CASE WHEN TP.HolderFirstName = PAT.FirstName AND TP.HolderLastName = PAT.LastName THEN '' ELSE CASE 
		WHEN LEN(HolderZipCode) IN (5,9) THEN HolderZipCode
		WHEN LEN(HolderZipCode) = 4 THEN '0' + HolderZipCode
		ELSE '' END END, -- HolderZipCode - varchar(9)
	'', -- HolderPhone - varchar(10)
	'' , -- HolderPhoneExt - varchar(10)
	LEFT(TP.PolicyNumber, 32) , -- DependentPolicyNumber - varchar(32)
    TP.PolicyNote + CHAR(13) + CHAR(10) + CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
	TP.Copay, -- Copay - money
	TP.Deductible, -- Deductible - money
	1, -- Active - bit
	@PracticeID , -- PracticeID - int
	PAT.VendorID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	'' , -- GroupName - varchar(14)
	'Y' , -- ReleaseOfInformation - varchar(1)
	1
FROM #tempPolicies2 AS TP
	JOIN dbo.PatientCase AS PC ON tp.PatientVendorID = pc.VendorID AND PC.VendorImportID = @VendorImportID
	JOIN dbo.Patient AS PAT ON pc.PatientID = PAT.PatientID AND PAT.PracticeID = @PracticeID AND PAT.VendorImportID = @VendorImportID
	JOIN dbo.InsuranceCompanyPlan ICP ON TP.InsuranceCode = ICP.VendorID AND ICP.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Updating Primary Case...'
UPDATE dbo.InsurancePolicy
	SET SyncWithEHR = 0
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND
	pc.VendorImportID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records '

PRINT ''
PRINT 'Updating Primary Case...'
UPDATE dbo.InsurancePolicy
	SET SyncWithEHR = 1
FROM dbo.InsurancePolicy ip
INNER JOIN dbo.PatientCase pc ON 
	ip.PatientCaseID = pc.PatientCaseID AND
	pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records '

PRINT ''
PRINT 'Updating Patient Cases that do not have policies...'
UPDATE dbo.PatientCase 
      SET PayerScenarioID = 11 , 
		  Name = 'Self Pay'
      FROM dbo.PatientCase pc
      LEFT JOIN dbo.InsurancePolicy ip ON
            pc.PatientCaseID = ip.PatientCaseID  
      WHERE pc.VendorImportID = @VendorImportID AND
              PayerScenarioID = 5 AND 
              ip.PatientCaseID IS NULL AND
              pc.Name <> 'Balance Forward'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #temppat
DROP TABLE #tempPolicies
DROP TABLE #tempPolicies2


--ROLLBACK
--COMMIT

