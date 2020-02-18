USE superbill_10600_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

DECLARE @PracticeID INT , @VendorImportID INT
SET @PracticeID = 1 
SET @VendorImportID = 6


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
--INNER JOIN dbo.[_import_9_1_PatientDemographics] i ON p.PatientID = CAST(REPLACE(REPLACE(i.id,'.',''),',','') AS INT)

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

CREATE TABLE #patdelete (PatID INT)
INSERT INTO #patdelete
        ( PatID )
SELECT DISTINCT p1.PatientID 
FROM dbo.Patient p1 
INNER JOIN (
	SELECT firstname , lastname , CAST(dob AS DATE) AS dob , COUNT(*) AS dupecount
	FROM dbo.Patient
	GROUP BY firstname , LastName , dob 
	HAVING COUNT(*)>1
		   ) dupe ON dupe.FirstName = p1.FirstName AND dupe.LastName = p1.LastName AND CAST(dupe.dob AS DATE) = CAST(p1.DOB AS DATE)
WHERE p1.Active = 1 AND p1.VendorImportID = 5

DELETE FROM dbo.InsurancePolicy WHERE PatientCaseID IN (SELECT PatientCaseID FROM dbo.PatientCase WHERE PatientID IN (SELECT PatID FROM #patdelete))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Policy Records Deleted'

DELETE FROM dbo.AppointmentToResource WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatID FROM #patdelete))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment to Resource Records Deleted'

DELETE FROM dbo.AppointmentToAppointmentReason WHERE AppointmentID IN (SELECT AppointmentID FROM dbo.Appointment WHERE PatientID IN (SELECT PatID FROM #patdelete))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment to Appointment Reason Records Deleted'

DELETE FROM dbo.Appointment WHERE PatientID IN (SELECT PatID FROM #patdelete)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Appointment Records Deleted'

DELETE FROM dbo.PatientCase WHERE PatientID IN (SELECT PatID FROM #patdelete)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient Case Records Deleted'

DELETE FROM dbo.Patient WHERE PatientID IN (SELECT PatID FROM #patdelete)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient Records Deleted'
PRINT ''
--76

INSERT INTO dbo.InsuranceCompany
(
	InsuranceCompanyName , EClaimsAccepts , BillingFormID , InsuranceProgramCode , HCFADiagnosisReferenceFormatCode , 
	HCFASameAsInsuredFormatCode , ReviewCode , CreatedPracticeID , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , SecondaryPrecedenceBillingFormID , VendorID , VendorImportID , NDCFormat , 
	UseFacilityID , AnesthesiaType , InstitutionalBillingFormID
)         
SELECT DISTINCT 
	IICL.r1insname  , -- InsuranceCompanyName - varchar(128)
	1, -- EClaimsAccepts - bit
	19 , -- BillingFormID - int
	'CI' , -- InsuranceProgramCode - char(2)
	'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
	'D' , -- HCFASameAsInsuredFormatCode - char(1)
	'' , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	19 , -- SecondaryPrecedenceBillingFormID - int
	IICL.r1insname + IICL.r1insaddress1 , -- VendorID - varchar(50)
	@VendorImportID , -- VendorImportID - int
	1 , -- NDCFormat - int
	1 , -- UseFacilityID - bit
	'U' , -- AnesthesiaType - varchar(1)
	18 -- InstitutionalBillingFormID - int
FROM dbo._import_8_1_EHR0081PATIENTSNEW AS IICL
WHERE IICL.r1insname <> '' AND
	NOT EXISTS (SELECT * FROM dbo.InsuranceCompany WHERE LTRIM(RTRIM(InsuranceCompanyName)) = LTRIM(RTRIM(IICL.r1insname)) AND
														 (ReviewCode = 'R' OR CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Company Records Inserted...'
PRINT ''

INSERT INTO dbo.InsuranceCompanyPlan
( 
	PlanName , AddressLine1 , AddressLine2 , City , State , Country , ZipCode , 
	CreatedDate , CreatedUserID , ModifiedDate , ModifiedUserID , ReviewCode , CreatedPracticeID , 
	InsuranceCompanyID , Copay , Deductible , VendorID , VendorImportID 
)
SELECT DISTINCT
	ICP.r1insname , -- PlanName - varchar(128)
	LEFT(LTRIM(RTRIM(ICP.r1insaddress1)),256) , -- AddressLine1 - varchar(256)
	LEFT(LTRIM(RTRIM(ICP.r1insaddress2)),256) , -- AddressLine2 - varchar(256)
	LEFT(LTRIM(RTRIM(ICP.r1inscity)),128) , -- City - varchar(128)
	LEFT(LTRIM(RTRIM(ICP.r1insstatecd)),2) , -- State - varchar(2)
	'' , -- Country - varchar(32)
	LEFT(CASE 
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.r1inszip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(ICP.r1inszip)
		WHEN LEN(dbo.fn_RemoveNonNumericCharacters(ICP.r1inszip)) = 4 THEN '0' + dbo.fn_RemoveNonNumericCharacters(ICP.r1inszip)
		ELSE '' END,9) , -- ZipCode - varchar(9)
	GETDATE() , -- CreatedDate - datetime
	0 , -- CreatedUserID - int
	GETDATE() , -- ModifiedDate - datetime
	0 , -- ModifiedUserID - int
	IC.ReviewCode , -- ReviewCode - char(1)
	@PracticeID , -- CreatedPracticeID - int
	IC.InsuranceCompanyID , -- InsuranceCompanyID - int
	0, -- Copay - money
	0, -- Deductible - money
	ICP.r1insname + ICP.r1insaddress1,  -- VendorID - varchar(50) --FIX
	@VendorImportID  -- VendorImportID - int
FROM dbo._import_8_1_EHR0081PATIENTSNEW ICP 
INNER JOIN dbo.InsuranceCompany IC ON 
	IC.VendorID = ICP.r1insname + ICP.r1insaddress1 AND
	ICP.r1insname = IC.InsuranceCompanyName AND
	IC.VendorImportID = @VendorImportID  
LEFT JOIN dbo.InsuranceCompanyPlan OICP ON
	ICP.r1insname + ICP.r1insaddress1 = OICP.VendorID AND
	OICP.VendorImportID = @VendorImportID
WHERE IC.CreatedPracticeID = @PracticeID AND
	  IC.VendorImportID = @VendorImportID AND
	  OICP.InsuranceCompanyPlanID IS NULL    
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Company Plan Records Inserted...'
PRINT ''			

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
          HomePhoneExt ,
          DOB ,
          SSN ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          PrimaryProviderID ,
          MedicalRecordNumber ,
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
          i.firstname ,
          i.middlename ,
          i.lastname ,
          '' ,
          i.address1 ,
          i.address2 ,
          i.city ,
          i.statecd ,
          '' ,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip) 
			   WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
		  ELSE '00000' END ,
          CASE i.gender 
			WHEN 'Female' THEN 'F'
			WHEN 'Male' THEN 'M'
		  ELSE 'U' END ,
          CASE i.maritalstatus
			WHEN 'DIVORCED' THEN 'D'
			WHEN 'LGLSEPARATN' THEN 'L'
			WHEN 'MARRIED' THEN 'M'
			WHEN 'SEPARATE' THEN 'L'
			WHEN 'SINGLE' THEN 'S'
			WHEN 'UNKNOWN' THEN 'S'
			WHEN 'WIDOWED' THEN 'W' 
		  ELSE '' END ,
          CASE
			WHEN LEN(i.hometelno) >= 10 THEN LEFT(dbo.fn_RemoveNonNumericCharacters(i.hometelno),10)
		  ELSE '' END , 
		  CASE
			WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.hometelno)) > 10 THEN LEFT(SUBSTRING(i.hometelno,11,LEN(i.hometelno)),10)
		  ELSE NULL END  ,
          CONVERT(DATETIME, CAST(i.dateofbirth AS DATE),103) ,
          CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.zip),9) ELSE '' END ,
          0 ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          'U' ,
          pp.DoctorID ,
          i.patientmrn ,
          i.fehrpatientid ,
          @VendorImportID ,
          1 ,
          1 ,
          0 ,
          0 
FROM dbo._import_8_1_EHR0081PATIENTSNEW i 
	LEFT JOIN dbo.Doctor pp ON 
		i.primaryphysfirstname = pp.FirstName AND 
		i.primaryphyslastname = pp.LastName AND
		pp.[External] = 0 AND 
		pp.ActiveDoctor = 1 AND 
		pp.PracticeID = @PracticeID
	LEFT JOIN dbo.Patient p ON 
		i.firstname = p.FirstName AND 
		i.lastname = p.LastName AND 
		DATEADD(hh,12,CONVERT(DATETIME, CAST(i.dateofbirth AS DATE),103)) = p.DOB AND
		p.PracticeID = @PracticeID
WHERE p.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient Records Inserted'
PRINT ''

INSERT INTO dbo.PatientCase
( 
	PatientID , Name , Active , PayerScenarioID , ReferringPhysicianID , EmploymentRelatedFlag , AutoAccidentRelatedFlag , OtherAccidentRelatedFlag , 
	AbuseRelatedFlag , AutoAccidentRelatedState , Notes , ShowExpiredInsurancePolicies , CreatedDate , CreatedUserID , ModifiedDate , 
	ModifiedUserID , PracticeID , CaseNumber , WorkersCompContactInfoID , VendorID , VendorImportID , PregnancyRelatedFlag , StatementActive , 
	EPSDT , FamilyPlanning , EPSDTCodeID , EmergencyRelated , HomeboundRelatedFlag
)
SELECT DISTINCT 
	PAT.PatientID ,
	'Default Case' , -- Name - varchar(128)
	1 , -- Active - bit
	PS.PayerScenarioID , -- PayerScenarioID - int
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
FROM dbo._import_8_1_EHR0081PATIENTSNEW pd
	INNER JOIN dbo.Patient AS PAT ON VendorImportID = @VendorImportID AND VendorID = pd.fehrpatientid
	INNER JOIN dbo.PayerScenario PS ON PS.Name = 'Commercial'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient Case Records Inserted...'
PRINT ''

CREATE TABLE #tempPolicies
(
	InsuranceColumnCount INT,
	PatientVendorID VARCHAR(128),
	InsuranceNamce VARCHAR(128),
	InsuranceAddress VARCHAR(128),
	PolicyNumber VARCHAR(32), 
	GroupNumber VARCHAR(32), 
	PolicyStartDate DATETIME, 
	PolicyEndDate DATETIME
)


INSERT INTO #tempPolicies
( 
	InsuranceColumnCount , PatientVendorID , InsuranceNamce, InsuranceAddress , PolicyNumber , GroupNumber , PolicyStartDate , 
	PolicyEndDate 
)
SELECT DISTINCT
	InsuranceColumnCount,
	PatientVendorID,
	InsuranceNamce, 
	InsuranceAddress ,
	LEFT(PolicyNumber, 32),
	LEFT(GroupNumber, 32),
	PolicyStartDate, 
	PolicyEndDate
FROM
(	SELECT DISTINCT 
		1 AS InsuranceColumnCount, fehrpatientid AS PatientVendorID, r1insname AS InsuranceNamce, r1insaddress1 AS InsuranceAddress,
		r1inspolicyid AS PolicyNumber, r1insgroupid AS GroupNumber, CASE WHEN r1inseffdate <> ''  
		THEN CONVERT(DATETIME, CAST(r1inseffdate AS DATE),103) ELSE NULL END AS PolicyStartDate, CASE WHEN r1insenddate <> '' 
		THEN CONVERT(DATETIME, CAST(r1insenddate AS DATE),103) ELSE NULL END AS PolicyEndDate 
	FROM dbo._import_8_1_EHR0081PATIENTSNEW
	WHERE r1insname <> ''
	
	UNION
  	
	SELECT DISTINCT 
		2 AS InsuranceColumnCount, fehrpatientid AS PatientVendorID, r2insname AS InsuranceNamce, r2insaddress1 AS InsuranceAddress,
		r2inspolicyid AS PolicyNumber, r2insgroupid AS GroupNumber, CASE WHEN r2inseffdate <> ''  
		THEN CONVERT(DATETIME, CAST(r2inseffdate AS DATE),103) ELSE NULL END AS PolicyStartDate, CASE WHEN r2insenddate <> '' 
		THEN CONVERT(DATETIME, CAST(r2insenddate AS DATE),103) ELSE NULL END AS PolicyEndDate 
	FROM dbo._import_8_1_EHR0081PATIENTSNEW
	WHERE r2insname <> ''
	
	UNION
  	
	SELECT DISTINCT 
		3 AS InsuranceColumnCount, fehrpatientid AS PatientVendorID, r3insname AS InsuranceNamce, r3insaddress1 AS InsuranceAddress,
		r3inspolicyid AS PolicyNumber, r3insgroupid AS GroupNumber, CASE WHEN r3inseffdate <> ''  
		THEN CONVERT(DATETIME, CAST(r3inseffdate AS DATE),103) ELSE NULL END AS PolicyStartDate, CASE WHEN r3insenddate <> '' 
		THEN CONVERT(DATETIME, CAST(r3insenddate AS DATE),103) ELSE NULL END AS PolicyEndDate 
	FROM dbo._import_8_1_EHR0081PATIENTSNEW
	WHERE r3insname <> ''
) AS Y
ORDER BY InsuranceColumnCount

INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          PolicyStartDate ,
          PolicyEndDate ,
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
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          i.InsuranceColumnCount ,
          i.PolicyNumber ,
          i.GroupNumber ,
          i.PolicyStartDate ,
          i.PolicyEndDate ,
          1 ,
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
FROM #tempPolicies i
	INNER JOIN dbo.PatientCase pc ON
		i.PatientVendorID = pc.VendorID AND
        pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan ICP ON 
		icp.InsuranceCompanyPlanID = (SELECT MAX(icp2.InsuranceCompanyPlanID) FROM dbo.InsuranceCompanyPlan icp2 
									  WHERE i.InsuranceNamce = ICP2.PlanName)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Policy Records Inserted...'
PRINT ''

UPDATE dbo.PatientCase 
SET 
	PayerScenarioID = PS.PayerScenarioID ,
	NAME = 'Self Pay'
FROM dbo.PatientCase pc
LEFT JOIN dbo.InsurancePolicy ip ON 
	pc.PatientCaseID = ip.PatientCaseID AND 
	ip.PracticeID = @PracticeID	
INNER JOIN dbo.PayerScenario PS ON
	PS.Name = 'Self Pay'
WHERE 
	pc.VendorImportID = @VendorImportID AND 
	pc.PracticeID = @PracticeID AND
	pc.PayerScenarioID <> ps.PayerScenarioID AND
	ip.InsurancePolicyID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Patient Case Records Updated to Self-Pay...'
PRINT ''  	

DROP TABLE #patdelete , #tempPolicies

--ROLLBACK
--COMMIT
