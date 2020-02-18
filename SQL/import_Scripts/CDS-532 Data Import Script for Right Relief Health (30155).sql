USE superbill_30155_dev
--USE superbill_30155_prod
go

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          ReferringPhysicianID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          AutoAccidentRelatedState ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
          CaseNumber ,
          WorkersCompContactInfoID ,
          VendorID ,
          VendorImportID ,
          PregnancyRelatedFlag ,
          StatementActive ,
          EPSDT ,
          FamilyPlanning ,
          EPSDTCodeID ,
          EmergencyRelated ,
          HomeboundRelatedFlag
        )
SELECT DISTINCT
	      p.PatientID , -- PatientID - int 
          'Default Case' , -- Name - varchar(128)
          1 , -- Active - bit
          5 , -- PayerScenarioID - int
          NULL , -- ReferringPhysicianID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          NULL , -- AutoAccidentRelatedState - char(2)
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.'  , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          NULL , -- CaseNumber - varchar(128)
          NULL , -- WorkersCompContactInfoID - int
          i.chartid , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM dbo.[_import_1_2_patientlist03312015] i	
	INNER JOIN dbo.Patient p ON p.FirstName = i.firstname AND p.LastName = i.lastname AND p.DOB = DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME))
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Insurance Company Records to TempTables...'

CREATE TABLE #tempins
( NAME VARCHAR(250) ) 


INSERT INTO #tempins
        ( NAME )
SELECT DISTINCT
	    insurancecompany  -- NAME - varchar(250)
FROM dbo.[_import_1_2_patientlist03312015]    
WHERE insurancecompany <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

INSERT INTO #tempins
        ( NAME )
SELECT DISTINCT
	    secondaryinsurance  -- NAME - varchar(250)
FROM dbo.[_import_1_2_patientlist03312015] i
WHERE secondaryinsurance <> '' AND NOT EXISTS (SELECT * FROM #tempins t WHERE i.secondaryinsurance = t.NAME)
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
		  name + ' - I',
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
          LEFT(NAME, 50) ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18 
FROM #tempins
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
          @PracticeID ,
          InsuranceCompanyID ,
          VendorID ,
          @VendorImportID 
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Policy 1 of 2...'
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
          HolderSSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
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
          i.insuranceidnumber , -- PolicyNumber - varchar(32)
          i.insurancegroupnumber , -- GroupNumber - varchar(32)
          1 , -- CardOnFile - bit
          CASE WHEN i.insurancesubscribername <> '' THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN i.insurancesubscribername <> '' THEN i.insurancesubscribername ELSE '' END , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          '' , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN i.insurancesubscribername <> '' THEN i.secondaryinsurancesubscriberdateofbirth ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN i.insurancesubscribername <> '' THEN i.insurancesubscriberssn ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.insurancesubscribername <> '' THEN i.insuranceidnumber ELSE '' END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          i.chartid + i.insuranceidnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_2_patientlist03312015] i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = LEFT(i.insurancecompany, 50) AND
		icp.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON 
		pc.VendorID = i.chartid AND
		pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Policy 2 of 2...'
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
          HolderSSN ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
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
          i.secondaryinsuranceidnumber , -- PolicyNumber - varchar(32)
          i.secondaryinsurancegroupnumber , -- GroupNumber - varchar(32)
          1 , -- CardOnFile - bit
          CASE WHEN i.secondaryinsurancesubscribername <> '' THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          '' , -- HolderPrefix - varchar(16)
          CASE WHEN i.secondaryinsurancesubscribername <> '' THEN i.secondaryinsurancesubscribername ELSE '' END , -- HolderFirstName - varchar(64)
          '' , -- HolderMiddleName - varchar(64)
          '' , -- HolderLastName - varchar(64)
          '' , -- HolderSuffix - varchar(16)
          CASE WHEN i.secondaryinsurancesubscribername <> '' THEN i.secondaryinsurancesubscriberdateofbirth ELSE NULL END , -- HolderDOB - datetime
          CASE WHEN i.secondaryinsurancesubscribername <> '' THEN i.secondaryinsurancesubscriberssn ELSE '' END , -- HolderSSN - char(11)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.secondaryinsurancesubscribername <> '' THEN i.secondaryinsuranceidnumber ELSE '' END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          i.chartid + i.secondaryinsuranceidnumber , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_1_2_patientlist03312015] i
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.VendorID = LEFT(i.secondaryinsurance, 50) AND
		icp.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON 
		pc.VendorID = i.chartid AND
		pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


DROP TABLE #tempins

--ROLLBACK
--COMMIT