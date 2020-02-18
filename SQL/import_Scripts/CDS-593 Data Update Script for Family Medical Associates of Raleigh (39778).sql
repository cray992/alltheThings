USE superbill_39778_dev
--USE superbill_39778_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Update Patient Case...'
UPDATE dbo.PatientCase 
	SET PayerScenarioID = CASE i.casepayerscenario 
							WHEN 'Medicaid' THEN 8
							WHEN 'Medicare Advantage Plan' THEN 18
							WHEN 'Tricare or ChampVa' THEN 12
							WHEN 'Commercial' THEN 5
							WHEN 'Medicare' THEN 7
							WHEN 'BCBS' THEN 3
					      END
FROM dbo.PatientCase pc 
INNER JOIN dbo._import_2_1_CasePayerScenario i ON
	pc.VendorID = i.medicalrecordnummber AND 
	pc.VendorImportID = @VendorImportID
LEFT JOIN dbo.InsurancePolicy ip ON 
	pc.PatientCaseID = ip.PatientCaseID
WHERE pc.PayerScenarioID <> 11 AND ip.InsurancePolicyID IS NOT NULL AND i.casepayerscenario NOT IN ('Self Pay' , '')
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

