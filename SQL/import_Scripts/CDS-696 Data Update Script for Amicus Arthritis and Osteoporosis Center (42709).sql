--USE superbill_42709_dev
USE superbill_42709_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT

SET @PracticeID = 1

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Patient Case - Case Name to Match Insurance Company...'
UPDATE dbo.PatientCase 
	SET Name = CASE WHEN pc.Name <> ic.InsuranceCompanyName THEN ic.InsuranceCompanyName ELSE pc.Name END
FROM dbo.PatientCase pc 
INNER JOIN dbo.InsurancePolicy ip ON 
pc.PatientCaseID = ip.PatientCaseID AND
ip.PracticeID = @PracticeID AND
ip.Precedence = 1
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
ip.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID 
INNER JOIN dbo.InsuranceCompany ic ON 
icp.InsuranceCompanyID = ic.InsuranceCompanyID 
WHERE pc.PracticeID = @PracticeID 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT 

