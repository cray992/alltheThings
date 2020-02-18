USE superbill_61964_prod
GO

SET XACT_ABORT ON
 
BEGIN TRANSACTION
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

CREATE TABLE #InsuranceCompanyPlanList ( VendorID INT , Name VARCHAR(128) )

INSERT INTO #InsuranceCompanyPlanList
        ( VendorID , 
		  Name 
        )
SELECT DISTINCT
		  patientprimaryinspkgid ,
		  patientprimaryinspkgname  -- Name - varchar(128)
FROM dbo._import_1_1_PatientDemographics i
WHERE patientprimaryinspkgname <> '' AND 
	  patientprimaryinspkgname <> '*SELF PAY*' 

INSERT INTO #InsuranceCompanyPlanList
        ( VendorID ,
		  Name 
        )
SELECT DISTINCT
		  patientsecondaryinspkgid ,
		  patientsecondaryinspkgname  -- Name - varchar(128)
FROM dbo._import_1_1_PatientDemographics i
WHERE i.patientsecondaryinspkgname <> '' AND 
	  i.patientsecondaryinspkgname <> '*SELF PAY*' AND
	  NOT EXISTS (SELECT * FROM #InsuranceCompanyPlanList icp 
				  WHERE i.patientsecondaryinspkgid = icp.VendorID)

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
		  i.Name , -- PlanName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          ic.InsuranceCompanyID , -- InsuranceCompanyID - int
          i.VendorID , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM #InsuranceCompanyPlanList i 
	INNER JOIN dbo.InsuranceCompany ic ON 
		ic.InsuranceCompanyID = (SELECT MIN(ic2.InsuranceCompanyID) FROM dbo.InsuranceCompany ic2 
				  WHERE i.Name = ic2.InsuranceCompanyName AND (ic2.CreatedPracticeID = @PracticeID OR ic2.ReviewCode = 'R'))

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
		  i.Name , -- PlanName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          oic.InsuranceCompanyID , -- InsuranceCompanyID - int
		  i.VendorID , -- VendorID - varchar(50)
          @VendorImportID -- VendorImportID - int
FROM #InsuranceCompanyPlanList i 
	INNER JOIN dbo.InsuranceCompany oic ON 
         CASE WHEN LEN(i.Name) <= 40 THEN i.Name 
		 ELSE  LEFT(i.Name,10) + SUBSTRING(i.Name,40,20) + RIGHT(i.Name,20)
		 END = oic.VendorID AND 
		oic.VendorImportID = @VendorImportID
	LEFT JOIN dbo.InsuranceCompanyPlan icp ON 
		i.VendorID = icp.VendorID AND 
		icp.VendorImportID = @VendorImportID
WHERE icp.InsuranceCompanyPlanID IS NULL

PRINT ''
PRINT 'Updating Existing Patient Records with VendorID...'
UPDATE dbo.Patient 
	SET VendorID = i.patientid , 
		VendorImportID = @VendorImportID
FROM dbo.Patient p 
	INNER JOIN dbo._import_1_1_PatientDemographics i ON 
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
          PhonecallRemindersEnabled , 
		  EmergencyName , 
		  EmergencyPhone ,
		  ResponsibleRelationshipToPatient ,
		  ResponsiblePrefix , 
		  ResponsibleFirstName , 
		  ResponsibleMiddleName , 
		  ResponsibleLastName , 
		  ResponsibleSuffix , 
		  ResponsibleAddressLine1 , 
		  ResponsibleAddressLine2 , 
		  ResponsibleCity , 
		  ResponsibleState , 
		  ResponsibleCountry , 
		  ResponsibleZipCode
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
          ISNULL(ms.MaritalStatus,'S') , -- MaritalStatus - varchar(1)
          LEFT(dbo.fn_RemoveNonNumericCharacters(i.patienthomephone),10) , -- HomePhone - varchar(10)
          LEFT(dbo.fn_RemoveNonNumericCharacters(i.patientworkphone),10) , -- WorkPhone - varchar(10)
          i.patientdob , -- DOB - datetime
          i.patientssn , -- SSN - char(9)
          CASE WHEN i.patientemail <> 'No Email' THEN i.patientemail END , -- EmailAddress - varchar(256)
          CASE WHEN i.ptntgrntrrltnshp <> '' AND i.ptntgrntrrltnshp <> 'Self' THEN 1 ELSE 0 END , -- ResponsibleDifferentThanPatient - bit
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
          0 , -- PhonecallRemindersEnabled - bit
		  i.ptntemrgncycntctname , 
		  LEFT(dbo.fn_RemoveNonNumericCharacters(i.ptntemrgncycntctph),10) ,
		  CASE WHEN i.ptntgrntrrltnshp <> '' AND i.ptntgrntrrltnshp <> 'Self' THEN 'C' END ,
		  CASE WHEN i.ptntgrntrrltnshp <> '' AND i.ptntgrntrrltnshp <> 'Self' THEN '' END,
		  CASE WHEN i.ptntgrntrrltnshp <> '' AND i.ptntgrntrrltnshp <> 'Self' THEN i.guarantorfrstnm END, 
		  CASE WHEN i.ptntgrntrrltnshp <> '' AND i.ptntgrntrrltnshp <> 'Self' THEN i.guarantormiddleinitial END, 
		  CASE WHEN i.ptntgrntrrltnshp <> '' AND i.ptntgrntrrltnshp <> 'Self' THEN i.guarantorlastnm END, 
		  CASE WHEN i.ptntgrntrrltnshp <> '' AND i.ptntgrntrrltnshp <> 'Self' THEN i.guarantornamesuffix ELSE '' END, 
		  CASE WHEN i.ptntgrntrrltnshp <> '' AND i.ptntgrntrrltnshp <> 'Self' THEN i.guarantoraddr END, 
		  CASE WHEN i.ptntgrntrrltnshp <> '' AND i.ptntgrntrrltnshp <> 'Self' THEN i.guarantoraddr2 END, 
		  CASE WHEN i.ptntgrntrrltnshp <> '' AND i.ptntgrntrrltnshp <> 'Self' THEN i.guarantorcity END, 
		  CASE WHEN i.ptntgrntrrltnshp <> '' AND i.ptntgrntrrltnshp <> 'Self' THEN i.guarantorstate END, 
		  CASE WHEN i.ptntgrntrrltnshp <> '' AND i.ptntgrntrrltnshp <> 'Self' THEN '' END , 
		  CASE WHEN i.ptntgrntrrltnshp <> '' AND i.ptntgrntrrltnshp <> 'Self' THEN dbo.fn_RemoveNonNumericCharacters(i.guarantorzip) END
FROM dbo._import_1_1_PatientDemographics i
	LEFT JOIN dbo.Patient p ON 
		i.patientid = p.VendorID AND 
		p.VendorImportID = @VendorImportID AND 
		p.PracticeID = @PracticeID
	LEFT JOIN dbo.MaritalStatus ms ON 
		i.patientmaritalstatus = ms.LongName
WHERE i.patientfirstname <> '' AND p.PatientID IS NULL AND i.[status] = 'a'
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
FROM dbo._import_1_1_PatientDemographics i 
	INNER JOIN dbo.PatientCase pc ON 
		i.patientid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
         i.patientprimaryinspkgid = icp.VendorID  AND
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
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN 'O' ELSE 'S' END  , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN i.patientsecondaryinshldr4 END , -- HolderFirstName - varchar(64)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN '' END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN i.patientsecondaryinshldr5 END , -- HolderLastName - varchar(64)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN '' END , -- HolderSuffix - varchar(16)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN i.patientsecondaryinshldrdob END , -- HolderDOB - datetime
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN i.patientsecondaryinshldrsex END , -- HolderGender - char(1)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN i.patientsecondaryinshldr END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN i.patientsecondaryinshldr2 END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN i.patientsecondaryinshldr3 END , -- HolderCity - varchar(128)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN i.patientsecondaryinshldr6 END , -- HolderState - varchar(2)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN REPLACE(i.patientsecondaryinshldrzip,'-','') END , -- HolderZipCode - varchar(9)
          CASE WHEN i.patientfirstname <> i.patientsecondaryinshldr4 OR i.patientlastname <> i.patientsecondaryinshldr5 THEN i.patientsecondarypolicyidn END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo._import_1_1_PatientDemographics i 
	INNER JOIN dbo.PatientCase pc ON 
		i.patientid = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
         i.patientsecondaryinspkgid = icp.VendorID  AND
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


DROP TABLE #InsuranceCompanyPlanList

--ROLLBACK
--COMMIT





