USE superbill_8811_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 5
SET @VendorImportID = 3

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
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
          i.primarypolicy , -- PolicyNumber - varchar(32)
          i.primarygroup , -- GroupNumber - varchar(32)
          0 , -- CardOnFile - bit
          CASE WHEN i.primaryholderfirstname <> '' THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.primaryholderfirstname <> '' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.primaryholderfirstname <> '' THEN i.primaryholderfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.primaryholderfirstname <> '' THEN i.primaryholdermiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.primaryholderfirstname <> '' THEN i.primaryholderlastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.primaryholderfirstname <> '' THEN '' END , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.primaryholderfirstname <> '' THEN i.[address] END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.primaryholderfirstname <> '' THEN '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.primaryholderfirstname <> '' THEN i.city END , -- HolderCity - varchar(128)
          CASE WHEN i.primaryholderfirstname <> '' THEN i.[state] END , -- HolderState - varchar(2)
          CASE WHEN i.primaryholderfirstname <> '' THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.primaryholderfirstname <> '' THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
															 WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
														ELSE '' END END , -- HolderZipCode - varchar(9)
          CASE WHEN i.primaryholderfirstname <> '' THEN i.primarypolicy END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo._import_4_5_Sheet1 i
	INNER JOIN dbo.PatientCase pc ON	
		i.targetchartnumber = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		icp.InsuranceCompanyPlanID = (SELECT MAX(InsuranceCompanyPlanID) FROM dbo.InsuranceCompanyPlan icp2 
									  WHERE icp2.PlanName = i.primaryco AND icp2.CreatedPracticeID = @PracticeID)
WHERE i.targetchartnumber <> '#N/A' AND i.primaryco <> ''
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
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
          i.secondarypolicy , -- PolicyNumber - varchar(32)
          i.secondarygroup , -- GroupNumber - varchar(32)
          0 , -- CardOnFile - bit
          CASE WHEN i.secondaryholderfirstname <> '' THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.secondaryholderfirstname <> '' THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.secondaryholderfirstname <> '' THEN i.secondaryholderfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.secondaryholderfirstname <> '' THEN i.secondaryholdermiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.secondaryholderfirstname <> '' THEN i.secondaryholderlastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.secondaryholderfirstname <> '' THEN '' END , -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.secondaryholderfirstname <> '' THEN i.[address] END , -- HolderAddressLine1 - varchar(256)
          CASE WHEN i.secondaryholderfirstname <> '' THEN '' END , -- HolderAddressLine2 - varchar(256)
          CASE WHEN i.secondaryholderfirstname <> '' THEN i.city END , -- HolderCity - varchar(128)
          CASE WHEN i.secondaryholderfirstname <> '' THEN i.[state] END , -- HolderState - varchar(2)
          CASE WHEN i.secondaryholderfirstname <> '' THEN '' END , -- HolderCountry - varchar(32)
          CASE WHEN i.secondaryholderfirstname <> '' THEN CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.zip)
															 WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.zip)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.zip)
														ELSE '' END END , -- HolderZipCode - varchar(9)
          CASE WHEN i.secondaryholderfirstname <> '' THEN i.secondarypolicy END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo._import_4_5_Sheet1 i
	INNER JOIN dbo.PatientCase pc ON	
		i.targetchartnumber = pc.VendorID AND 
		pc.VendorImportID = @VendorImportID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON 
		icp.InsuranceCompanyPlanID = (SELECT MAX(InsuranceCompanyPlanID) FROM dbo.InsuranceCompanyPlan icp2 
									  WHERE icp2.PlanName = i.secondaryco AND icp2.CreatedPracticeID = @PracticeID)
WHERE i.targetchartnumber <> '#N/A' AND i.secondaryco <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = 5 , Name = 'Default Case' 
FROM dbo.PatientCase pc 
	INNER JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND 
		ip.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Patient Name...'
UPDATE dbo.Patient 
 SET FirstName = i.patientfirstname , 
	 MiddleName = i.patientmiddlename , 
	 LastName = i.patientlastname
FROM dbo.Patient p 
	INNER JOIN dbo._import_4_5_Sheet1 i ON 
		p.VendorID = i.targetchartnumber AND 
		p.VendorImportID = @VendorImportID
WHERE LEN(p.FirstName) <= 1 AND p.ModifiedUserID = 0
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT		
