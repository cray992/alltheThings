USE superbill_62032_dev
GO

SET XACT_ABORT ON
 
BEGIN TRANSACTION
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @OldVendorImportID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 2
SET @OldVendorImportID = 1

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
--INNER JOIN _import_3_1_PatientDemographics i ON p.PatientID = i.id

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

-- Temp table to combine insurances
CREATE TABLE #InsuranceCompanyPlanList (ID INT IDENTITY(1,1) PRIMARY KEY , Name VARCHAR(128) , Address1 VARCHAR(128) , Address2 VARCHAR(128) , City VARCHAR(100) , [State] VARCHAR(2) , Zip VARCHAR(9))

INSERT INTO #InsuranceCompanyPlanList
        ( 
		  Name ,
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
FROM dbo._import_2_1_CDS961printcsvreportsUpdate i
WHERE patientprimaryinspkgname <> '' AND 
	  patientprimaryinspkgname <> '*SELF PAY*' 

INSERT INTO #InsuranceCompanyPlanList
        ( 
		  Name ,
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
FROM dbo._import_2_1_CDS961printcsvreportsUpdate i
WHERE i.patientsecondaryinspkgname <> '' AND 
	  i.patientsecondaryinspkgname <> '*SELF PAY*' AND
	  NOT EXISTS (SELECT * FROM #InsuranceCompanyPlanList icp 
				  WHERE i.patientsecondaryinspkgname = icp.Name AND
						i.patientsecondaryinspkgaddrs1 = icp.Address1 AND
						REPLACE(patientsecondaryinspkgzip,'-','') = icp.Zip) 

UPDATE i
	SET PrimaryIns = icp.ID 
FROM dbo._import_2_1_CDS961printcsvreportsUpdate i
	INNER JOIN #InsuranceCompanyPlanList icp ON 
		i.patientprimaryinspkgname = icp.Name AND
		i.patientprimaryinspkgaddrs1 = icp.Address1 AND
		REPLACE(i.patientprimaryinspkgzip,'-','') = icp.Zip

UPDATE i
	SET SecondaryIns = icp.ID 
FROM dbo._import_2_1_CDS961printcsvreportsUpdate i
	INNER JOIN #InsuranceCompanyPlanList icp ON 
		i.patientsecondaryinspkgname = icp.Name AND
		i.patientsecondaryinspkgaddrs1 = icp.Address1 AND
		REPLACE(i.patientsecondaryinspkgzip,'-','') = icp.Zip


-- Insert insurance data from temp table		
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
	LEFT JOIN dbo.InsuranceCompanyPlan icp ON i.id = icp.VendorID AND icp.VendorImportID = @VendorImportID
WHERE icp.InsuranceCompanyPlanID IS NULL
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

-- Update the policy records created from the original import
PRINT ''
PRINT 'Updating InsurancePolicy - Primary...'
UPDATE ip
SET InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID , 
	ip.PolicyNumber = i.patientprimarypolicyidnumber ,
	ip.GroupNumber = i.patientprimarypolicygrpnu , 
	ip.PatientRelationshipToInsured = CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN 'C' ELSE 'S' END  , 
	ip.HolderFirstName = CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrfi END , 
	ip.HolderMiddleName = CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN '' END ,
	ip.HolderLastName = CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrla END , 
	ip.HolderDOB = CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrdob END , 
	ip.HolderGender = CASE WHEN i.patientprimaryptnttoins <> 'Self'  THEN i.patientprimaryinshldrsex END , 
	ip.HolderAddressLine1 = CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrad END , 
	ip.HolderAddressLine2 = CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrad1 END , 
	ip.HolderCity = CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrcity END ,
	ip.HolderState = CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrstate END , 
	ip.HolderCountry = CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN '' END ,
	ip.HolderZipCode = CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN REPLACE(i.patientprimaryinshldrzip,'-','') END ,
	ip.DependentPolicyNumber = CASE WHEN i.patientprimaryptnttoins <> 'Self'  THEN i.patientprimarypolicyidnumber END ,
	ip.HolderSSN = CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN REPLACE(i.patientprimaryinshldrssn,'-','') END
FROM dbo.InsurancePolicy ip
	INNER JOIN dbo.PatientCase pc ON 
		ip.PatientCaseID = pc.PatientCaseID AND 
		pc.VendorImportID = @OldVendorImportID AND
        pc.Name <> 'Balance Forward'
	INNER JOIN dbo.Patient p ON 
		pc.PatientID = p.PatientID AND 
        p.VendorImportID = @OldVendorImportID
	INNER JOIN dbo._import_2_1_CDS961printcsvreportsUpdate i ON 
		p.FirstName = i.patientfirstname AND 
		p.LastName = i.patientlastname AND 
		p.DOB = DATEADD(hh,12,CAST(i.patientdob AS DATETIME)) 
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.PrimaryIns = icp.VendorID AND 
        icp.VendorImportID = @VendorImportID
WHERE ip.VendorImportID = @OldVendorImportID AND ip.ModifiedUserID = 0 AND ip.Precedence = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating InsurancePolicy - Secondary...'
UPDATE ip
SET InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID , 
	ip.PolicyNumber = i.patientsecondarypolicyidn ,
	ip.GroupNumber = i.patientsecondarypolicygrp , 
	ip.PatientRelationshipToInsured = CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN 'C' ELSE 'S' END  , 
	ip.HolderFirstName = CASE WHEN i.patientsecondaryptnttoi <> 'Self'  THEN i.patientsecondaryinshldr END , 
	ip.HolderMiddleName = CASE WHEN i.patientsecondaryptnttoi <> 'Self'  THEN '' END ,
	ip.HolderLastName = CASE WHEN i.patientsecondaryptnttoi <> 'Self'  THEN i.patientsecondaryinshldr2 END , 
	ip.HolderDOB = CASE WHEN i.patientsecondaryptnttoi <> 'Self'  THEN i.patientsecondaryinshldrdob END , 
	ip.HolderGender = CASE WHEN i.patientsecondaryptnttoi <> 'Self'  THEN i.patientsecondaryinshldrsex END , 
	ip.HolderAddressLine1 = CASE WHEN i.patientsecondaryptnttoi <> 'Self'  THEN i.patientsecondaryinshldr3 END , 
	ip.HolderAddressLine2 = CASE WHEN i.patientsecondaryptnttoi <> 'Self'  THEN '' END , 
	ip.HolderCity = CASE WHEN i.patientsecondaryptnttoi <> 'Self'  THEN i.patientsecondaryinshldr5 END ,
	ip.HolderState = CASE WHEN i.patientsecondaryptnttoi <> 'Self'  THEN i.patientsecondaryinshldr6 END , 
	ip.HolderCountry = CASE WHEN i.patientsecondaryptnttoi <> 'Self'  THEN '' END ,
	ip.HolderZipCode = CASE WHEN i.patientsecondaryptnttoi <> 'Self'  THEN REPLACE(i.patientsecondaryinshldrzip,'-','') END ,
	ip.DependentPolicyNumber = CASE WHEN i.patientsecondaryptnttoi <> 'Self'  THEN i.patientsecondarypolicyidn END , 
	ip.HolderSSN = CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN REPLACE(i.patientsecondaryinshldrssn,'-','') END
FROM dbo.InsurancePolicy ip
	INNER JOIN dbo.PatientCase pc ON 
		ip.PatientCaseID = pc.PatientCaseID AND 
		pc.VendorImportID = @OldVendorImportID AND
        pc.Name <> 'Balance Forward'
	INNER JOIN dbo.Patient p ON 
		pc.PatientID = p.PatientID AND 
        p.VendorImportID = @OldVendorImportID
	INNER JOIN dbo._import_2_1_CDS961printcsvreportsUpdate i ON 
		p.FirstName = i.patientfirstname AND 
		p.LastName = i.patientlastname AND 
		p.DOB = DATEADD(hh,12,CAST(i.patientdob AS DATETIME)) 
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		i.SecondaryIns = icp.VendorID AND 
        icp.VendorImportID = @VendorImportID
WHERE ip.VendorImportID = @OldVendorImportID AND ip.ModifiedUserID = 0 AND ip.Precedence = 2
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

-- InsurancePlan records were created with no address information from VendorimportID 1. Deleting where no longer linked to a policy.
PRINT ''
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @OldVendorImportID AND ModifiedUserID = 0 
										   AND InsuranceCompanyPlanID NOT IN (SELECT InsuranceCompanyPlanID FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' InsuranceCompanyPlan records deleted'


 --Insert Insurance Policies where they do not already exist
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
		  HolderSSN ,
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
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN 'O' ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrfi END , -- HolderFirstName - varchar(64)
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN '' END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrla END , -- HolderLastName - varchar(64)
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrdob END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrsex END , -- HolderGender - char(1)
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrad END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrad1 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrcity END , -- HolderCity - varchar(128)
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimaryinshldrstate END , -- HolderState - varchar(2)
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN REPLACE(i.patientprimaryinshldrzip,'-','') END , -- HolderZipCode - varchar(9)
          CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN i.patientprimarypolicyidnumber END , -- DependentPolicyNumber - varchar(32)
		  CASE WHEN i.patientprimaryptnttoins <> 'Self' THEN REPLACE(i.patientprimaryinshldrssn,'-','') END ,
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo._import_2_1_CDS961printcsvreportsUpdate i 
	INNER JOIN dbo.Patient p ON 
		p.PatientID = (SELECT MAX(p2.PatientID) FROM dbo.Patient p2
					   WHERE i.patientfirstname = p2.FirstName AND 
							 i.patientlastname = p2.LastName AND 
							 DATEADD(hh,12,CAST(i.patientdob AS DATETIME)) = p2.DOB AND
							 p2.VendorImportID = @OldVendorImportID )
	INNER JOIN dbo.PatientCase pc ON 
		p.PatientID = pc.PatientID AND 
		pc.VendorImportID = @OldVendorImportID AND
		pc.Name <> 'Balance Forward'
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
         i.PrimaryIns = icp.VendorID AND
         icp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND 
        ip.Precedence = 1
WHERE ip.InsurancePolicyID IS NULL
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
		  HolderSSN , 
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
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN 'O' ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN i.patientsecondaryinshldr END , -- HolderFirstName - varchar(64)
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN '' END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN i.patientsecondaryinshldr2 END , -- HolderLastName - varchar(64)
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN i.patientsecondaryinshldrdob END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN i.patientsecondaryinshldrsex END , -- HolderGender - char(1)
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN i.patientsecondaryinshldr3 END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN i.patientsecondaryinshldr5 END , -- HolderCity - varchar(128)
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN i.patientsecondaryinshldr6 END , -- HolderState - varchar(2)
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN REPLACE(i.patientsecondaryinshldrzip,'-','') END , -- HolderZipCode - varchar(9)
          CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN i.patientsecondarypolicyidn END , -- DependentPolicyNumber - varchar(32)
		  CASE WHEN i.patientsecondaryptnttoi <> 'Self' THEN REPLACE(i.patientsecondaryinshldrssn,'-','') END ,
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo._import_2_1_CDS961printcsvreportsUpdate i 
	INNER JOIN dbo.Patient p ON 
		i.patientfirstname = p.FirstName AND 
		i.patientlastname = p.LastName AND 
        DATEADD(hh,12,CAST(i.patientdob AS DATETIME)) = p.DOB AND
		p.VendorImportID = @OldVendorImportID 
	INNER JOIN dbo.PatientCase pc ON 
		p.PatientID = pc.PatientID AND 
		pc.VendorImportID = @OldVendorImportID AND
		pc.Name <> 'Balance Forward'
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
         i.SecondaryIns = icp.VendorID AND
         icp.VendorImportID = @VendorImportID
	LEFT JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND 
        ip.Precedence = 2
WHERE ip.InsurancePolicyID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET Name = 'Default Case' , PayerScenarioID = 5
FROM dbo.PatientCase pc 
	INNER JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND 
		ip.PracticeID = @PracticeID AND 
		ip.VendorImportID IN (@OldVendorImportID , @VendorImportID)
WHERE pc.PracticeID = @PracticeID AND pc.VendorImportID = @OldVendorImportID AND pc.ModifiedUserID = 0 AND pc.Name <> 'Balance Forward'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #InsuranceCompanyPlanList


--ROLLBACK
--COMMIT


