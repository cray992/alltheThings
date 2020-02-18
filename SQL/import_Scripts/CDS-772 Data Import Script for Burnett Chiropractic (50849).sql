--USE superbill_50849_dev
USE superbill_50849_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
DECLARE @NewVendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 4
SET @NewVendorImportID = 5

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

SET NOCOUNT ON

PRINT ''
PRINT 'Inserting Into #tempcase...'
CREATE TABLE #tempcase (TempPatientID INT)
INSERT INTO #tempcase  ( TempPatientID )
SELECT DISTINCT pc.PatientID
FROM dbo.PatientCase pc
 	INNER JOIN dbo.InsurancePolicy ip ON
		pc.PatientCaseID = ip.PatientCaseID AND
        ip.PracticeID = @PracticeID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.PlanName = 'Self Pay' AND
        ip.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
WHERE pc.PracticeID = @PracticeID AND pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'       

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET Active = 0 
FROM dbo.PatientCase pc 
	INNER JOIN dbo.InsurancePolicy ip ON
		pc.PatientCaseID = ip.PatientCaseID AND
        ip.PracticeID = @PracticeID
	INNER JOIN dbo.InsuranceCompanyPlan icp ON
		icp.PlanName = 'Self Pay' AND
        ip.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
WHERE pc.PracticeID = @PracticeID AND pc.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Inserting Into Patient Case...'
INSERT INTO dbo.PatientCase
        ( PatientID ,
          Name ,
          Active ,
          PayerScenarioID ,
          EmploymentRelatedFlag ,
          AutoAccidentRelatedFlag ,
          OtherAccidentRelatedFlag ,
          AbuseRelatedFlag ,
          Notes ,
          ShowExpiredInsurancePolicies ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          PracticeID ,
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
		  TempPatientID , -- PatientID - int
          'Self Pay' , -- Name - varchar(128)
          1 , -- Active - bit
          11 , -- PayerScenarioID - int
          0 , -- EmploymentRelatedFlag - bit
          0 , -- AutoAccidentRelatedFlag - bit
          0 , -- OtherAccidentRelatedFlag - bit
          0 , -- AbuseRelatedFlag - bit
          '' , -- Notes - text
          0 , -- ShowExpiredInsurancePolicies - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          @PracticeID , -- PracticeID - int
          TempPatientID , -- VendorID - varchar(50)
          @NewVendorImportID , -- VendorImportID - int
          0 , -- PregnancyRelatedFlag - bit
          1 , -- StatementActive - bit
          0 , -- EPSDT - bit
          0 , -- FamilyPlanning - bit
          1 , -- EPSDTCodeID - int
          0 , -- EmergencyRelated - bit
          0  -- HomeboundRelatedFlag - bit
FROM #tempcase
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

DROP TABLE #tempcase

--ROLLBACK
--COMMIT


