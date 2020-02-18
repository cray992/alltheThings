USE superbill_50294_dev
--USE superbill_50294_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

/*==========================================================================*/
 --FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--

--CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9), VendorID VARCHAR(50))
--INSERT INTO #updatepat (PatientID, DateofBirth, SSN) 
--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 dbo.fn_RemoveNonNumericCharacters(i.ssn)  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo.[_import_1_1_PatientDemographics] i ON p.PatientID = i.id

--PRINT ''
--PRINT 'Updating Existing Patients Demographics...'
--UPDATE dbo.Patient 
--	SET DOB = i.DateofBirth  ,
--		SSN = i.ssn
--FROM #updatepat i 
--INNER JOIN dbo.Patient p ON
--	p.PatientID = i.patientid
--PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--DROP TABLE #updatepat


/*==========================================================================*/

PRINT ''
PRINT 'Updating Patients with VendorID...'
UPDATE dbo.Patient 
	SET VendorID = i.pernbr
FROM dbo.Patient p 
INNER JOIN dbo.[_import_1_1_import] i ON 
	p.FirstName = i.firstname AND 
	p.LastName = i.lastname AND 
	p.DOB = DATEADD(hh,12,CAST(i.birthdt AS DATETIME))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
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
          NDCFormat ,
          UseFacilityID ,
          AnesthesiaType ,
          InstitutionalBillingFormID 
        )
SELECT DISTINCT
		  payername ,
          1 ,
          13 ,
          'CI' ,
          'C' ,
          'D' ,
          @PracticeID ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          13 ,
          payername ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18
FROM dbo.[_import_1_1_import]
WHERE payername <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
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
		  InsuranceCompanyName ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          CreatedPracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          VendorImportID 
FROM dbo.InsuranceCompany
WHERE VendorImportID = @VendorImportID     
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
	'Self Pay' , -- Name - varchar(128)
	1 , -- Active - bit
	11 , -- PayerScenarioID - int
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
	PAT.VendorID , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	0, -- PregnncyRelatedFlag - bit
	1, -- StatementActive - bit
	0, -- EPSDT - bit
	0, -- FamilyPlanning - bit
	1 , -- EPSDTCodeID - int
	0 , -- EmergencyRelated - bit
	0 -- HomeboundRelatedFlag
FROM dbo.Patient PAT
	LEFT JOIN dbo.PatientCase pc ON PAT.PatientID = pc.PatientID AND pc.PracticeID = @PracticeID
WHERE pc.PatientCaseID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 1 of 3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
          ReleaseOfInformation ,
		  GroupName  ,
		  GroupNumber      )
SELECT DISTINCT	
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          1 ,
          i.polnbr ,
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
          'Y' ,
		  LEFT(i.groupname , 14) , 
		  i.[group]
FROM dbo.PatientCase pc
	INNER JOIN 
		(
		SELECT pernbr , payername , polnbr , groupname , [GROUP] , ROW_NUMBER() OVER(PARTITION BY pernbr ORDER BY payername DESC) 
		AS DupePat FROM dbo.[_import_1_1_import] 
		) AS i ON pc.VendorID = i.pernbr
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.payername = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID 
WHERE i.DupePat = 1 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 2 of 3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
          ReleaseOfInformation ,
		  GroupName  ,
		  GroupNumber      )
SELECT DISTINCT	
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          2 ,
          i.polnbr ,
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
          'Y' ,
		  LEFT(i.groupname , 14) , 
		  i.[group]
FROM dbo.PatientCase pc
	INNER JOIN 
		(
		SELECT pernbr , payername , polnbr , groupname , [GROUP] , ROW_NUMBER() OVER(PARTITION BY pernbr ORDER BY payername DESC) 
		AS DupePat FROM dbo.[_import_1_1_import] 
		) AS i ON pc.VendorID = i.pernbr
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.payername = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID 
WHERE i.DupePat = 2 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 3 of 3...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
          ReleaseOfInformation ,
		  GroupName  ,
		  GroupNumber      )
SELECT DISTINCT	
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          3 ,
          i.polnbr ,
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
          'Y' ,
		  LEFT(i.groupname , 14) , 
		  i.[group]
FROM dbo.PatientCase pc
	INNER JOIN 
		(
		SELECT pernbr , payername , polnbr , groupname , [GROUP] , ROW_NUMBER() OVER(PARTITION BY pernbr ORDER BY payername DESC) 
		AS DupePat FROM dbo.[_import_1_1_import] 
		) AS i ON pc.VendorID = i.pernbr
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.payername = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID 
WHERE i.DupePat = 3 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase
	SET Name = 'Default Case' , PayerScenarioID = 5
FROM dbo.PatientCase pc 
LEFT JOIN dbo.InsurancePolicy ip ON
	pc.PatientCaseID = ip.PatientCaseID AND 
	ip.VendorImportID = @VendorImportID
WHERE pc.VendorImportID = @VendorImportID AND ip.InsurancePolicyID IS NOT NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'



--ROLLBACK
--COMMIT
