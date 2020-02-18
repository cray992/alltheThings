USE --superbill_37189_dev
superbill_37189_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 3

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR)

PRINT ''
PRINT 'Inserting Into Insurance Company 1...'
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
		  i.patcv1carriername ,
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
          i.patcv1carriername ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18 
FROM dbo.[_import_3_2_rad6ACE3] i
LEFT JOIN dbo.InsuranceCompany ic ON 
	i.patcv1carriername = ic.InsuranceCompanyName AND 
	(ic.ReviewCode = 'R' OR ic.CreatedPracticeID = @PracticeID)
WHERE i.patcv1carriername <> '' AND ic.InsuranceCompanyID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Company 2...'
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
		  i.patcv2carriername ,
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
          i.patcv2carriername ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18 
FROM dbo.[_import_3_2_rad6ACE3] i
LEFT JOIN dbo.InsuranceCompany ic ON 
	i.patcv2carriername = ic.InsuranceCompanyName AND 
	(ic.ReviewCode = 'R' OR ic.CreatedPracticeID = @PracticeID)
WHERE i.patcv2carriername <> '' AND ic.InsuranceCompanyID IS NULL
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
		  InsuranceCompanyName , -- PlanName - varchar(128)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- CreatedPracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          VendorID , -- VendorID - varchar(50)
          @VendorImportID  -- VendorImportID - int
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID AND CreatedPracticeID = @PracticeID
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          1 , -- Precedence - int
          i.policy1claimmemberid , -- PolicyNumber - varchar(32)
          i.policy1groupnbr , -- GroupNumber - varchar(32)
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          @PracticeID ,
          pc.PatientCaseID ,
          @VendorImportID ,
          LEFT(i.policy1groupname, 14) ,
          'Y' 
FROM dbo.[_import_3_2_rad6ACE3] i
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.patcv1carriername = icp.PlanName AND 
	icp.CreatedPracticeID = @PracticeID 
INNER JOIN dbo.Patient p ON 
	i.patfirstname = p.FirstName AND 
	i.patlastname = p.LastName AND 
	DATEADD(hh,12,CAST(i.patdob AS DATETIME)) = p.dob AND
    p.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON 
	p.PatientID = pc.PatientID AND
    pc.PracticeID = @PracticeID
LEFT JOIN dbo.InsurancePolicy ip ON 
	pc.PatientCaseID = ip.PatientCaseID AND 
	ip.Precedence = 1 AND 
	ip.PracticeID = @PracticeID
WHERE ip.InsurancePolicyID IS NULL AND i.policy1claimmemberid <> ''
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
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          Active ,
          PracticeID ,
          VendorID ,
          VendorImportID ,
          GroupName ,
          ReleaseOfInformation 
        )
SELECT DISTINCT
		  pc.PatientCaseID , -- PatientCaseID - int
          icp.InsuranceCompanyPlanID , -- InsuranceCompanyPlanID - int
          2 , -- Precedence - int
          i.policy2claimmemberid , -- PolicyNumber - varchar(32)
          i.policy2groupnbr , -- GroupNumber - varchar(32)
          0 ,
          'S' ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          1 ,
          @PracticeID ,
          pc.PatientCaseID ,
          @VendorImportID ,
          LEFT(i.policy2groupname, 14) ,
          'Y' 
FROM dbo.[_import_3_2_rad6ACE3] i
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.patcv2carriername = icp.PlanName AND 
	icp.CreatedPracticeID = @PracticeID 
INNER JOIN dbo.Patient p ON 
	i.patfirstname = p.FirstName AND 
	i.patlastname = p.LastName AND 
	DATEADD(hh,12,CAST(i.patdob AS DATETIME)) = p.dob AND
    p.PracticeID = @PracticeID
INNER JOIN dbo.PatientCase pc ON 
	p.PatientID = pc.PatientID AND
    pc.PracticeID = @PracticeID
LEFT JOIN dbo.InsurancePolicy ip ON 
	pc.PatientCaseID = ip.PatientCaseID AND 
	ip.Precedence = 2 AND 
	ip.PracticeID = @PracticeID
WHERE ip.InsurancePolicyID IS NULL AND i.policy2claimmemberid <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET Name = 'Default Case' ,
		PayerScenarioID = 5
FROM dbo.PatientCase pc 
LEFT JOIN dbo.InsurancePolicy ip ON 
	pc.PatientCaseID = ip.PatientCaseID AND 
	ip.VendorImportID = @VendorImportID AND 
	ip.PracticeID = @PracticeID
WHERE ip.InsurancePolicyID IS NOT NULL AND pc.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

