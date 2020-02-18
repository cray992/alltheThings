USE superbill_10590_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 39
SET @VendorImportID = 24

SET NOCOUNT ON 

-- Import in NET-17162 created a list of Practice Specific insurance company and plans that were not necessary.

-- Update InsurancePolicy.InsuranceCompanyPlanID to the ID listed in the import file.		
UPDATE dbo.InsurancePolicy
SET InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
FROM dbo.InsurancePolicy ip
INNER JOIN dbo._import_24_39_HintPatients201706213 i ON 
	ip.VendorID = i.AutoTempID AND 
	ip.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	i.healthinsurancepayername = icp.InsuranceCompanyPlanID
WHERE ip.VendorImportID = @VendorImportID AND ip.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Insurance Policy records updated'	

-- Update Patient Cases where an insurance policy is present
UPDATE dbo.PatientCase
SET Name = 'Default Case' , PayerScenarioID = 5
FROM dbo.PatientCase pc
INNER JOIN dbo.InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.PracticeID = @PracticeID
WHERE pc.VendorImportID = @VendorImportID

-- Delete the plan records that were previously created
DELETE FROM dbo.InsuranceCompanyPlan WHERE CreatedPracticeID = @PracticeID AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' InsuranceCompanyPlan records deleted'

--ROLLBACK
--COMMIT


