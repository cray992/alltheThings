USE superbill_41460_dev
--superbill_41460_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR)

CREATE TABLE #tempins (id VARCHAR(15))
INSERT INTO #tempins ( id )
SELECT DISTINCT	pricode  -- id - varchar(15)
FROM dbo.[_import_3_1_Pol]

INSERT INTO #tempins ( id )
SELECT DISTINCT	i.seccode  -- id - varchar(15)
FROM dbo.[_import_3_1_Pol] i
WHERE NOT EXISTS (SELECT * FROM #tempins WHERE id = i.seccode)

PRINT ''
PRINT 'Updating Patient...'
UPDATE dbo.Patient 
	SET DOB = CASE WHEN ISDATE(i.dob) = 1 THEN i.dob ELSE NULL END
FROM dbo.Patient p 
INNER JOIN dbo.[_import_3_1_Pol] i ON
p.VendorID = i.paaccount AND 
p.VendorImportID = @VendorImportID
WHERE i.dob <> '' AND p.DOB IS NULL
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
          InstitutionalBillingFormID         )
SELECT DISTINCT
		  i.name ,
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
          i.name ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18 
FROM dbo.[_import_3_1_insurancelist] i
INNER JOIN #tempins ti ON
i.code = ti.id
WHERE i.name <> '' 
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
          VendorImportID ,
		  Phone
        )
SELECT DISTINCT
		  ic.InsuranceCompanyName ,
          i.[address] ,
          '' ,
          i.city ,
          i.[St] ,
          '' ,
          dbo.fn_RemoveNonNumericFromString(i.zip) ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          @PracticeID ,
          ic.InsuranceCompanyID ,
          i.code ,
          @VendorImportID ,
		  dbo.fn_RemoveNonNumericCharacters(i.phone)
FROM dbo.InsuranceCompany ic 
INNER JOIN dbo.[_import_3_1_insurancelist] i ON
	ic.VendorID = i.name AND 
	ic.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 1...'
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
          i.prisubscriber , -- PolicyNumber - varchar(32)
          i.prigroup , -- GroupNumber - varchar(32)
          0 , -- CardOnFile - bit
          CASE WHEN i.paname <> i.priname THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.paname <> i.priname THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.paname <> i.priname THEN i.prifirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.paname <> i.priname THEN i.primiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.paname <> i.priname THEN i.prilastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.paname <> i.priname THEN i.prisuffix END, -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.paname <> i.priname THEN i.prisubscriber END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_3_1_Pol] i 
INNER JOIN dbo.PatientCase pc ON 
	i.paaccount = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.pricode = icp.VendorID AND 
	icp.VendorImportID = @VendorImportID
WHERE  i.prisubscriber <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy 2...'
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
          i.secsubscriber , -- PolicyNumber - varchar(32)
          i.secgroup , -- GroupNumber - varchar(32)
          0 , -- CardOnFile - bit
          CASE WHEN i.paname <> i.secname THEN 'O' ELSE 'S' END , -- PatientRelationshipToInsured - varchar(1)
          CASE WHEN i.paname <> i.secname THEN '' END , -- HolderPrefix - varchar(16)
          CASE WHEN i.paname <> i.secname THEN i.secfirstname END , -- HolderFirstName - varchar(64)
          CASE WHEN i.paname <> i.secname THEN i.secmiddlename END , -- HolderMiddleName - varchar(64)
          CASE WHEN i.paname <> i.secname THEN i.seclastname END , -- HolderLastName - varchar(64)
          CASE WHEN i.paname <> i.secname THEN i.secsuffix END, -- HolderSuffix - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          CASE WHEN i.paname <> i.secname THEN i.secsubscriber END , -- DependentPolicyNumber - varchar(32)
          1 , -- Active - bit
          @PracticeID , -- PracticeID - int
          pc.VendorID , -- VendorID - varchar(50)
          @VendorImportID , -- VendorImportID - int
          'Y'  -- ReleaseOfInformation - varchar(1)
FROM dbo.[_import_3_1_Pol] i 
INNER JOIN dbo.PatientCase pc ON 
	i.paaccount = pc.VendorID AND 
	pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.seccode = icp.VendorID AND 
	icp.VendorImportID = @VendorImportID
WHERE  i.secsubscriber <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET Name = 'Default Case' ,
		PayerScenarioID = 5
FROM dbo.PatientCase pc 
LEFT JOIN dbo.InsurancePolicy ip ON 
	pc.PatientCaseID = ip.PatientCaseID AND
    pc.VendorImportID = @VendorImportID
WHERE ip.InsurancePolicyID IS NOT NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #tempins

--ROLLBACK
--COMMIT