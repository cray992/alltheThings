 USE superbill_42652_dev
--superbill_42652_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 3

PRINT ''
PRINT 'Updating Patient Case...'
UPDATE dbo.PatientCase 
	SET Name = 'Default Case' , 
		PayerScenarioID = 5
FROM dbo.PatientCase pc 
	LEFT JOIN dbo.InsurancePolicy ip ON 
		pc.PatientCaseID = ip.PatientCaseID AND 
		pc.PracticeID = @PracticeID AND 
		pc.VendorImportID = @VendorImportID
WHERE pc.Name = 'Self Pay' AND ip.InsurancePolicyID IS NOT NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated' 

--ROLLBACK
--COMMIT