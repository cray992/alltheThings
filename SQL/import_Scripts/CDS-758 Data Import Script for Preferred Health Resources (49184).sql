--USE superbill_49184_dev 
USE superbill_49184_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @VendorImportID INT
DECLARE @PracticeID INT

SET @VendorImportID = 4
SET @PracticeID = 31 

SET NOCOUNT ON

/*==========================================================================*/
 --FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--

--CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9))
--INSERT INTO #updatepat (PatientID, DateofBirth, SSN) 
--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 i.ssn  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo.[_import_6_31_PatientDemographics] i ON p.PatientID = REPLACE(REPLACE(i.ID,',',''),'.00','') 

--PRINT ''
--PRINT 'Updating Existing Patients Demographics...'
--UPDATE dbo.Patient 
--	SET DOB = i.DateofBirth  ,
--		SSN = i.ssn
--FROM #updatepat i 
--INNER JOIN dbo.Patient p ON
--	p.PatientID = i.patientid AND 
--	p.PracticeID = @PracticeID
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--DROP TABLE #updatepat

--UPDATE dbo.[_import_4_31_BL550207] SET [last] = 'reederz' WHERE [first] = 'Wilma' AND policy = 'MA406605412'

/*==========================================================================*/


PRINT ''
PRINT 'Inserting Into Insurance Company Plan - Existing...'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName ,
	CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , CreatedPracticeID , 
	InsuranceCompanyID , VendorID , VendorImportID 
)
SELECT DISTINCT
	icp.carrier , -- PlanName - varchar(128)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	icp.carrier,  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM dbo._import_4_31_BL550207 ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.InsuranceCompanyID = (SELECT MIN(InsuranceCompanyID) FROM dbo.InsuranceCompany 
									WHERE ICP.carrier = InsuranceCompanyName AND
										  (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
/*
==========================================================================================================================================
CREATE INSURANCE COMPANIES FROM [{InsuranceCOMPANYPLANList}]
==========================================================================================================================================
*/	

PRINT ''
PRINT 'Insering Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	IICL.carrier, -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
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
	carrier , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM dbo._import_4_31_BL550207 AS IICL
WHERE 
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = IICL.carrier AND
														 (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
	AND IICL.carrier <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'
/*
==========================================================================================================================================
CREATE INSURANCE PLANS FROM [InsuranceCOMPANYPLANList]
==========================================================================================================================================
*/	

PRINT ''
PRINT 'Inserting Into Insurance Company Plan - New....'
INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName ,
	CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , CreatedPracticeID , 
	InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	ICP.carrier  , -- PlanName - varchar(128)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	ICP.carrier,  -- VendorID - varchar(50) --FIX
	@VendorImportID -- VendorImportID - int
FROM dbo._import_4_31_BL550207 ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.carrier, 50) AND
	ICP.carrier = IC.InsuranceCompanyName AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.carrier = OICP.VendorID AND
	OICP.VendorImportID = @VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DECLARE @DefaultCollectionCategory INT
SET @DefaultCollectionCategory = (SELECT CollectionCategoryID FROM dbo.CollectionCategory WHERE IsDefaultCategory = 1)

PRINT ''
PRINT 'Inserting Into Patient...'
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
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
	      @PracticeID ,
          '' ,
          [first] ,
          [middle] ,
          [last] ,
          '' ,
          [Address] ,
          '' ,
          i.City ,
          i.[State] ,
          '' ,
          CASE WHEN LEN(zip) IN (4,8) THEN '0' + zip ELSE zip END ,
          CASE WHEN sex = '' THEN 'U' ELSE sex END ,
          dbo.fn_RemoveNonNumericCharacters(home) ,
          dbo.fn_RemoveNonNumericCharacters(Work) ,
          [date] ,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(social)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(social),9) ELSE '' END ,
          0 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          'U' ,
          [first] + [last] + [date] ,
          @VendorImportID ,
          @DefaultCollectionCategory ,
          1 ,
          0 ,
          0 
FROM dbo.[_import_4_31_BL550207] i
LEFT JOIN dbo.Patient p ON 
	i.[first] = p.FirstName AND 
	i.[last] = p.LastName AND
    DATEADD(hh,12,CAST(i.[date] AS DATETIME)) = p.DOB
WHERE p.PatientID IS NULL AND i.[last] <> '' AND i.[first] <> ''
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
	PAT.PatientID , -- PatientID - int
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
	pd.[first] + pd.[last] + pd.[date] , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.[_import_4_31_BL550207] pd
	JOIN dbo.Patient AS PAT ON 
		PAT.FirstName = pd.[first] AND 
		PAT.LastName = pd.[last] AND
		PAT.DOB = DATEADD(hh,12,CAST(pd.[date] AS DATETIME)) AND
        PAT.PracticeID = @PracticeID
WHERE pd.policy <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID  ,
          icp.InsuranceCompanyPlanID ,
          1 ,
          i.policy ,
          i.[group] ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          @PracticeID ,
          pc.VendorID ,
          @VendorImportID ,
          'Y'
FROM dbo.[_import_4_31_BL550207] i
	INNER JOIN dbo.PatientCase pc ON
		pc.VendorID = i.[first] + i.[last] + i.[date] AND
        pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.carrier = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND 
		ip.PracticeID = @PracticeID 
WHERE ip.InsurancePolicyID IS NULL AND i.policy <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = 11,
	NAME = 'Self Pay'
WHERE 
	@VendorImportID = VendorImportID AND 
	@PracticeID = PracticeID AND
	PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID) AND
	PayerScenarioID <> 11
	
--ROLLBACK
--COMMIT
