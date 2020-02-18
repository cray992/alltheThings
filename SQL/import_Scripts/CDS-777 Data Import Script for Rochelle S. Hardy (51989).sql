--USE superbill_51989_dev
USE superbill_51989_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

SET NOCOUNT ON

/*==========================================================================*/
-- FOR DB-13 ONLY -- 
--UPDATE PATIENTS WITH CORRECT DEMOGRAPHIC INFO FROM SUPPORT TOOLS EXPORT--

--CREATE TABLE #updatepat (PatientID INT , DateofBirth DATETIME , SSN VARCHAR(9))
--INSERT INTO #updatepat (PatientID, DateofBirth, SSN) 
--SELECT DISTINCT
--		     p.PatientID , -- PatientID - int
--			 DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) , -- DateofBirth - 
--			 i.ssn  -- SSN - varchar(9)
--FROM dbo.Patient p 
--INNER JOIN dbo.[_import_1_1_PatientDemographics] i ON p.PatientID = REPLACE(REPLACE(i.id,'.00',''),',','')

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
SELECT DISTINCT
          pat.PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          i.mrn , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.Patient as pat 
INNER JOIN dbo._import_1_1_patient AS i ON
   pat.FirstName = i.firstname AND 
   pat.LastName = i.lastname AND
   pat.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME))
WHERE pat.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

CREATE TABLE #tempins (insname VARCHAR(128) , address1 VARCHAR(256) , city VARCHAR(128) , [state] VARCHAR(2) , zip VARCHAR(9))
INSERT INTO #tempins ( insname , address1 , city , [state] , zip)
SELECT DISTINCT i.caseinsname1 , i.insaddress1 , i.inscity , i.inssate , CASE WHEN LEN(i.inszip) IN (4,8) THEN + '0' + i.inszip ELSE i.inszip END
FROM dbo.[_import_1_1_patient] i
INNER JOIN dbo.Patient p ON
	i.firstname = p.FirstName AND 
	i.lastname = p.LastName AND 
	DATEADD(hh,12,CAST(i.dob AS DATETIME)) = p.dob 
WHERE i.caseinsname1 <> '' AND i.caseinsname1 <> 'Self Pay'

INSERT INTO #tempins ( insname , address1 , city , [state] , zip)
SELECT DISTINCT i.caseinsname2  , i.ins2address1 , i.ins2city , i.ins2sate , CASE WHEN LEN(i.ins2zip) IN (4,8) THEN + '0' + i.ins2zip ELSE i.ins2zip END
FROM dbo.[_import_1_1_patient] i 
INNER JOIN dbo.Patient p ON
	i.firstname = p.FirstName AND 
	i.lastname = p.LastName AND 
	DATEADD(hh,12,CAST(i.dob AS DATETIME)) = p.dob 
WHERE i.caseinsname2 <> '' AND i.caseinsname2 <> 'Self Pay' AND NOT EXISTS
	                                 (SELECT * FROM #tempins ti WHERE ti.insname = i.caseinsname2 AND ti.address1 = i.ins2address1)

/*
==========================================================================================================================================
CREATE INSURANCE COMPANIES FROM [_import_1_1_InsuranceCOMPANYPLANList]
==========================================================================================================================================
*/	

PRINT ''
PRINT 'Inserting Into InsuranceCompany...'
INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	IICL.insname , -- InsuranceCompanyName - varchar(128)
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
	LEFT(IICL.insname,25) + LEFT(IICL.address1,25) , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM #tempins AS IICL
WHERE 
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = IICL.insname AND
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
	PlanName , AddressLine1 , AddressLine2 , City , [State] , ZipCode , Country , CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	InsuranceCompanyID , VendorID , VendorImportID 
)
SELECT DISTINCT
	ICP.insname , -- PlanName - varchar(128)
	ICP.address1 , 
	'' ,
	ICP.city , 
	ICP.[state] ,
	ICP.zip ,
	'' ,
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	LEFT(ICP.insname, 25) + LEFT(icp.address1,25) , -- VendorID - varchar(50) --FIX
	@VendorImportID -- VendorImportID - int
FROM #tempins ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = LEFT(ICP.insname, 25) + LEFT(icp.address1,25) AND
	IC.VendorImportID = @VendorImportID  
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

PRINT ''
PRINT 'Inserting Into Insurance Policy 1 of 2...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          CardOnFile ,
          PatientRelationshipToInsured ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          1 ,
          i.policy1 ,
          i.group1 ,
          CASE WHEN ISDATE(i.ins1startdate) = 1 THEN i.ins1startdate END ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' ,
          1 ,
          @PracticeID ,
          pc.VendorID ,
          @VendorImportID ,
          'Y'
FROM dbo.[_import_1_1_patient] i
	INNER JOIN dbo.PatientCase pc ON 
		i.mrn = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		LEFT(i.caseinsname1,25) + LEFT(i.insaddress1,25) = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
WHERE i.policy1 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 2 of 2...'
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
          Notes ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          2 ,
          i.policy2 ,
          i.group2 ,
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' ,
          1 ,
          @PracticeID ,
          pc.VendorID ,
          @VendorImportID ,
          'Y'
FROM dbo.[_import_1_1_patient] i
	INNER JOIN dbo.PatientCase pc ON 
		i.mrn = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		LEFT(i.caseinsname2,25) + LEFT(i.insaddress1,25) = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
WHERE i.policy2 <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Update Patient Case...'
UPDATE dbo.PatientCase 
	SET Name = 'Self Pay' , PayerScenarioID = 11
FROM dbo.PatientCase pc 
LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.PracticeID = @PracticeID
WHERE ip.InsurancePolicyID IS NULL AND pc.PracticeID = @PracticeID AND pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT