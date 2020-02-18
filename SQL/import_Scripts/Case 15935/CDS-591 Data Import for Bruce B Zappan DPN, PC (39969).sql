USE superbill_39969_dev
--USE superbill_39969_prod
GO


SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @OldVendorImportID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @OldVendorImportID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Inserting into Insurance Company...'
INSERT INTO dbo.InsuranceCompany
        ( InsuranceCompanyName ,
          Notes ,
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
		  otherinsuredsinsuranceplan ,
          CONVERT(VARCHAR(10),GETDATE(),101) + ': Created via data import. Please verify before use.' ,
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
          otherinsuredsinsuranceplan ,
          @VendorImportID ,
          1 ,
          1 ,
          'U' ,
          18
FROM dbo.[_import_2_1_Sheet1] i 
WHERE NOT EXISTS (SELECT * FROM dbo.InsuranceCompany ic WHERE ic.VendorID = i.otherinsuredsinsuranceplan)
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
          @VendorImportID -- VendorImportID - int
FROM dbo.InsuranceCompany WHERE VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into Insurance Policy...'
INSERT INTO dbo.InsurancePolicy
        ( PatientCaseID ,
          InsuranceCompanyPlanID ,
          Precedence ,
          PolicyNumber ,
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
		  pc.PatientCaseID ,
          icp.InsuranceCompanyPlanID ,
          2 ,
          i.otherinsuredspolicynumber ,
          0 ,
          CASE WHEN i.insuredlastname <> '' THEN 'O' ELSE 'S' END ,
          CASE WHEN i.insuredlastname <> '' THEN '' END ,
          CASE WHEN i.insuredlastname <> '' THEN i.insuredfirstname END ,
          CASE WHEN i.insuredlastname <> '' THEN i.insuredmiddlename END ,
          CASE WHEN i.insuredlastname <> '' THEN i.insuredlastname END ,
          CASE WHEN i.insuredlastname <> '' THEN '' END ,
          GETDATE() ,
          0 ,
          GETDATE() ,
          0 ,
          CASE WHEN i.insuredlastname <> '' THEN i.otherinsuredspolicynumber END ,
          1 ,
          @PracticeID ,
          pc.VendorID ,
          @VendorImportID ,
          'Y'
FROM dbo.[_import_2_1_Sheet1] i
INNER JOIN dbo.Patient p ON i.patientsaccountnumber = p.VendorID AND p.VendorImportID = @OldVendorImportID
INNER JOIN dbo.PatientCase pc ON p.PatientID = pc.PatientID AND pc.VendorImportID = @OldVendorImportID 
INNER JOIN dbo.InsuranceCompanyPlan icp ON i.otherinsuredsinsuranceplan = icp.VendorID
LEFT JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 2
WHERE ip.InsurancePolicyID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--ROLLBACK
--COMMIT