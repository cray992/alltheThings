USE superbill_48750_prod
GO

SET XACT_ABORT ON
 
BEGIN TRANSACTION
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 3
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

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
--INNER JOIN dbo._import_2_3_PatientDemographics i ON p.PatientID = i.id

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

UPDATE dbo._import_1_3_PatDemoImport 
	SET patientprimaryinspkgname = 'Medicare-CA - Part B (Medicare)' ,
		patientsecondaryinspkgname = 'Medicare-CA - Part B (Medicare)',
		patienttertiaryinspkgname = 'Medicare-CA - Part B (Medicare)'
WHERE patientprimaryinspkgname = 'Medicare-CA - Part A (Medicare)' OR 
	  patientsecondaryinspkgname = 'Medicare-CA - Part A (Medicare)' OR 
	  patienttertiaryinspkgname = 'Medicare-CA - Part A (Medicare)' 

CREATE TABLE #InsuranceCompanyPlanList (ID INT IDENTITY(1,1) PRIMARY KEY , Name VARCHAR(128) , Address1 VARCHAR(128) , Address2 VARCHAR(128) , City VARCHAR(100) , [State] VARCHAR(2) , Zip VARCHAR(9))

PRINT ''
PRINT 'Inserting Into #InsuranceCompanyPlanList - Primary'
INSERT INTO #InsuranceCompanyPlanList
        ( Name ,
          Address1 ,
          Address2 ,
          City ,
          State ,
          Zip
        )
SELECT DISTINCT
		  patientprimaryinspkgname , -- Name - varchar(128)
          patientprimaryinspkgaddrs1 , -- Address1 - varchar(128)
          patientprimaryinspkgaddrs2 , -- Address2 - varchar(128)
          patientprimaryinspkgcity , -- City - varchar(100)
          patientprimaryinspkgstate , -- State - varchar(2)
          REPLACE(patientprimaryinspkgzip,'-','')  -- Zip - varchar(9)
FROM dbo._import_1_3_PatDemoImport i
WHERE patientprimaryinspkgname <> '' AND 
	  patientprimaryinspkgname <> '*SELF PAY*' 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into #InsuranceCompanyPlanList - Secondary'
INSERT INTO #InsuranceCompanyPlanList
        ( Name ,
          Address1 ,
          Address2 ,
          City ,
          State ,
          Zip
        )
SELECT DISTINCT
		  patientsecondaryinspkgname , -- Name - varchar(128)
          patientsecondaryinspkgaddrs1 , -- Address1 - varchar(128)
          patientsecondaryinspkgaddrs2 , -- Address2 - varchar(128)
          patientsecondaryinspkgcity , -- City - varchar(100)
          patientsecondaryinspkgstate , -- State - varchar(2)
          REPLACE(patientsecondaryinspkgzip,'-','')  -- Zip - varchar(9)
FROM dbo._import_1_3_PatDemoImport i
WHERE i.patientsecondaryinspkgname <> '' AND 
	  i.patientsecondaryinspkgname <> '*SELF PAY*' AND
	  NOT EXISTS (SELECT * FROM #InsuranceCompanyPlanList icp 
				  WHERE i.patientsecondaryinspkgname = icp.Name AND
						i.patientsecondaryinspkgaddrs1 = icp.Address1 AND
						REPLACE(patientsecondaryinspkgzip,'-','') = icp.Zip) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into #InsuranceCompanyPlanList - Tertiary'
INSERT INTO #InsuranceCompanyPlanList
        ( Name ,
          Address1 ,
          Address2 ,
          City ,
          State ,
          Zip
        )
SELECT DISTINCT
		  patienttertiaryinspkgname , -- Name - varchar(128)
          patienttertiaryinspkgaddrs1 , -- Address1 - varchar(128)
          patienttertiaryinspkgaddrs2 , -- Address2 - varchar(128)
          patienttertiaryinspkgcity , -- City - varchar(100)
          patienttertiaryinspkgstate , -- State - varchar(2)
          REPLACE(patienttertiaryinspkgzip,'-','')  -- Zip - varchar(9)
FROM dbo._import_1_3_PatDemoImport i
WHERE i.patienttertiaryinspkgname <> '' AND 
	  i.patienttertiaryinspkgname <> '*SELF PAY*' AND
	  NOT EXISTS (SELECT * FROM #InsuranceCompanyPlanList icp 
				  WHERE i.patienttertiaryinspkgname = icp.Name AND
						i.patienttertiaryinspkgaddrs1 = icp.Address1 AND
						REPLACE(patienttertiaryinspkgzip,'-','') = icp.Zip) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--ALTER TABLE dbo._import_1_3_PatDemoImport 
--	ADD PrimaryIns INT , SecondaryIns INT , TertiaryIns INT

UPDATE dbo._import_1_3_PatDemoImport
	SET PrimaryIns = icp.ID 
FROM dbo._import_1_3_PatDemoImport i
	INNER JOIN #InsuranceCompanyPlanList icp ON 
		i.patientprimaryinspkgname = icp.Name AND
		i.patientprimaryinspkgaddrs1 = icp.Address1 AND
		REPLACE(i.patientprimaryinspkgzip,'-','') = icp.Zip

UPDATE dbo._import_1_3_PatDemoImport
	SET SecondaryIns = icp.ID 
FROM dbo._import_1_3_PatDemoImport i
	INNER JOIN #InsuranceCompanyPlanList icp ON 
		i.patientsecondaryinspkgname = icp.Name AND
		i.patientsecondaryinspkgaddrs1 = icp.Address1 AND
		REPLACE(i.patientsecondaryinspkgzip,'-','') = icp.Zip

UPDATE dbo._import_1_3_PatDemoImport
	SET TertiaryIns = icp.ID 
FROM dbo._import_1_3_PatDemoImport i
	INNER JOIN #InsuranceCompanyPlanList icp ON 
		i.patienttertiaryinspkgname = icp.Name AND
		i.patienttertiaryinspkgaddrs1 = icp.Address1 AND
		REPLACE(i.patienttertiaryinspkgzip,'-','') = icp.Zip

PRINT ''
PRINT 'Inserting Into InsuranceCompanyPlan - Existing Company...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
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
		  i.Name , -- PlanName - varchar(128)
          i.Address1 , -- AddressLine1 - varchar(256)
          i.Address2 , -- AddressLine2 - varchar(256)
          i.City , -- City - varchar(128)
          i.[State] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          i.Zip , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          i.ID , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM #InsuranceCompanyPlanList i 
	INNER JOIN dbo.InsuranceCompany ic ON 
		ic.InsuranceCompanyID = (SELECT MIN(ic2.InsuranceCompanyID) FROM dbo.InsuranceCompany ic2 
				  WHERE i.Name = ic2.InsuranceCompanyName AND (ic2.CreatedPracticeID = @PracticeID OR ic2.ReviewCode = 'R'))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

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
		  i.Name , -- InsuranceCompanyName - varchar(128) 
          1 , -- EClaimsAccepts - bit
          19 , -- BillingFormID - int
          'CI' , -- InsuranceProgramCode - char(2)
          'C' , -- HCFADiagnosisReferenceFormatCode - char(1)
          'D' , -- HCFASameAsInsuredFormatCode - char(1)
          @PracticeID , -- CreatedPracticeID - int
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          19 , -- SecondaryPrecedenceBillingFormID - int
          CASE 
			WHEN LEN(i.Name) <= 40 THEN i.Name 
		  ELSE  LEFT(i.Name,10) + SUBSTRING(i.Name,40,20) + RIGHT(i.Name,20)
		  END , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- NDCFormat - int
          1 , -- UseFacilityID - bit
          'U' , -- AnesthesiaType - varchar(1)
          18  -- InstitutionalBillingFormID - int
FROM #InsuranceCompanyPlanList i
WHERE NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic 
				  WHERE i.Name = ic.InsuranceCompanyName AND
						(ic.ReviewCode = 'R' OR ic.CreatedPracticeID = @PracticeID))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company Plan...'
INSERT INTO dbo.InsuranceCompanyPlan
        ( PlanName ,
          AddressLine1 ,
          AddressLine2 ,
          City ,
          State ,
          Country ,
          ZipCode ,
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
		  i.Name , -- PlanName - varchar(128)
          i.Address1 , -- AddressLine1 - varchar(256)
          i.Address2 , -- AddressLine2 - varchar(256)
          i.City , -- City - varchar(128)
          i.[State] , -- State - varchar(2)
          '' , -- Country - varchar(32)
          i.Zip , -- ZipCode - varchar(9)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          oic.InsuranceCompanyID , -- InsuranceCompanyID - int
		  i.ID , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM #InsuranceCompanyPlanList i 
	INNER JOIN dbo.InsuranceCompany oic ON 
         CASE WHEN LEN(i.Name) <= 40 THEN i.Name 
		 ELSE  LEFT(i.Name,10) + SUBSTRING(i.Name,40,20) + RIGHT(i.Name,20)
		 END = oic.VendorID AND 
		oic.VendorImportID = @VendorImportID
	LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
		i.ID = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
WHERE icp.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Existing Patient Records with VendorID...'
UPDATE dbo.Patient 
	SET VendorID = i.patientid , 
		VendorImportID = @VendorImportID
FROM dbo.Patient p 
	INNER JOIN dbo._import_1_3_PatDemoImport i ON 
		p.FirstName = i.patientfirstname AND 
		p.LastName = i.patientlastname AND 
		p.DOB = DATEADD(hh,12,CAST(i.patientdob AS DATETIME)) 
WHERE p.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

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
          MaritalStatus ,
          HomePhone ,
          WorkPhone ,
          DOB ,
          SSN ,
          EmailAddress ,
          ResponsibleDifferentThanPatient ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          EmploymentStatus ,
          MedicalRecordNumber ,
          MobilePhone ,
          VendorID ,
          VendorImportID ,
          CollectionCategoryID ,
          Active ,
          SendEmailCorrespondence ,
          PhonecallRemindersEnabled 
        )
SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          '' , -- Prefix - varchar(16)
          i.patientfirstname , -- FirstName - varchar(64)
          i.patientmiddleinitial , -- MiddleName - varchar(64)
          i.patientlastname , -- LastName - varchar(64)
          '' , -- Suffix - varchar(16)
          i.patientaddress1 , -- AddressLine1 - varchar(256)
          i.patientaddress2 , -- AddressLine2 - varchar(256)
          i.patientcity , -- City - varchar(128)
          i.patientstate , -- State - varchar(2)
          '' , -- Country - varchar(32)
          REPLACE(i.patientzip,'-','') , -- ZipCode - varchar(9)
          i.patientsex , -- Gender - varchar(1)
          '' , -- MaritalStatus - varchar(1)
          dbo.fn_RemoveNonNumericCharacters(i.patienthomephone) , -- HomePhone - varchar(10)
          dbo.fn_RemoveNonNumericCharacters(i.patientworkphone) , -- WorkPhone - varchar(10)
          i.patientdob , -- DOB - datetime
          i.patientssn , -- SSN - char(9)
          i.patientemail , -- EmailAddress - varchar(256)
          0 , -- ResponsibleDifferentThanPatient - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          'U' , -- EmploymentStatus - char(1)
          i.patientid , -- MedicalRecordNumber - varchar(128)
          LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientmobileno),10) , -- MobilePhone - varchar(10)
          i.patientid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- CollectionCategoryID - int
          1 , -- Active - bit
          0 , -- SendEmailCorrespondence - bit
          0  -- PhonecallRemindersEnabled - bit
FROM dbo._import_1_3_PatDemoImport i
	LEFT JOIN dbo.Patient p ON 
		i.patientid = p.VendorID AND 
		p.VendorImportID = @VendorImportID AND 
		p.PracticeID = @PracticeID
WHERE i.patientfirstname <> '' AND p.PatientID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          Notes ,
		  ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          StatementActive ,
          EPSDTCodeID 
        )
SELECT DISTINCT
		  PatientID , -- PatientID - int
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' , -- Notes - text
          1 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          1 , -- StatementActive - bit
          1  -- EPSDTCodeID - int
FROM dbo.Patient
WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy - Primary...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          CardOnFile ,
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
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          i.patientprimarypolicyidnumber , -- PolicyNumber - varchar(32)
          i.patientprimarypolicygrpnu , -- GroupNumber - varchar(32)
          0 , -- CardOnFile - bit
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN 'O' ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN i.patientprimaryinshldrfi END , -- HolderFirstName - varchar(64)
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN '' END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN i.patientprimaryinshldrla END , -- HolderLastName - varchar(64)
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN i.patientprimaryinshldrdob END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN i.patientprimaryinshldrsex END , -- HolderGender - char(1)
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN i.patientprimaryinshldrad1 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN i.patientprimaryinshldrcity END , -- HolderCity - varchar(128)
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN i.patientprimaryinshldrstate END , -- HolderState - varchar(2)
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN REPLACE(i.patientprimaryinshldrzip,'-','') END , -- HolderZipCode - varchar(9)
          CASE WHEN i.patientfirstname <> i.patientprimaryinshldrfi OR i.patientlastname <> i.patientprimaryinshldrla THEN i.patientprimarypolicyidnumber END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo._import_1_3_PatDemoImport i 
	INNER JOIN dbo.PatientCase pc ON 
		i.patientid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
         i.PrimaryIns = icp.VendorID  AND
         icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy - Secondary...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          CardOnFile ,
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
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          i.patientsecondarypolicyidn , -- PolicyNumber - varchar(32)
          i.patientsecondarypolicygrp , -- GroupNumber - varchar(32) patientsecondarypolicygrpnu
          0 , -- CardOnFile - bit
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN 'O' ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN i.patientsecondaryinshldr2 END , -- HolderFirstName - varchar(64)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN '' END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN i.patientsecondaryinshldr3 END , -- HolderLastName - varchar(64)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN i.patientsecondaryinshldrdob END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN i.patientsecondaryinshldrsex END , -- HolderGender - char(1)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN i.patientsecondaryinshldr4 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN i.patientsecondaryinshldr6 END , -- HolderCity - varchar(128)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN i.patientsecondaryinshldr7 END , -- HolderState - varchar(2)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN REPLACE(i.patientsecondaryinshldrzip,'-','') END , -- HolderZipCode - varchar(9)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr2 OR i.patientlastname <> i.patientsecondaryinshldr3 THEN i.patientsecondarypolicyidn END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo._import_1_3_PatDemoImport i 
	INNER JOIN dbo.PatientCase pc ON 
		i.patientid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
         i.secondaryIns = icp.VendorID  AND
         icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy - Tertiary...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
          GroupNumber ,
          CardOnFile ,
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
          HolderGender ,
          HolderAddressLine1 ,
          HolderAddressLine2 ,
          HolderCity ,
          HolderState ,
          HolderCountry ,
          HolderZipCode ,
          DependentPolicyNumber ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          3 , -- Precedence - int
          i.patienttertiarypolicyidnu , -- PolicyNumber - varchar(32)
          i.patienttertiarypolicygrpn , -- GroupNumber - varchar(32) patientsecondarypolicygrpnu
          0 , -- CardOnFile - bit
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN 'O' ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN i.patienttertiaryinshldrf END , -- HolderFirstName - varchar(64)
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN '' END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN i.patienttertiaryinshldrl END , -- HolderLastName - varchar(64)
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN i.patienttertiaryinshldrdob END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN i.patienttertiaryinshldrsex END , -- HolderGender - char(1)
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN i.patienttertiaryinshldra END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN i.patienttertiaryinshldrcity END , -- HolderCity - varchar(128)
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN i.patienttertiaryinshldrs END , -- HolderState - varchar(2)
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN REPLACE(i.patienttertiaryinshldrzip,'-','') END , -- HolderZipCode - varchar(9)
          CASE WHEN i.patientfirstname <> i.patienttertiaryinshldrf OR i.patientlastname <> i.patienttertiaryinshldrl THEN i.patienttertiarypolicyidnu END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo._import_1_3_PatDemoImport i 
	INNER JOIN dbo.PatientCase pc ON 
		i.patientid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
         i.tertiaryIns = icp.VendorID  AND
         icp.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET Name = 'Self Pay' , PayerScenarioID = 11
FROM dbo.PatientCase pc 
	LEFT JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND 
		ip.PracticeID = @PracticeID AND 
		ip.VendorImportID = @VendorImportID
WHERE pc.PracticeID = @PracticeID AND pc.VendorImportID = @VendorImportID AND ip.InsurancePolicyID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT








