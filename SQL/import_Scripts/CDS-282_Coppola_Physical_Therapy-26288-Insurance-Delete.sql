USE superbill_26288_dev
--USE superbill_26288_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
SET @PracticeID = 2

PRINT ''
PRINT 'Deleting From Insurance Company Plan...'
DELETE icp FROM dbo.InsuranceCompanyPlan icp
LEFT JOIN dbo.InsurancePolicy ip ON
	ip.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
WHERE ip.InsuranceCompanyPlanID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting From Practice to Insurance Company...'
DELETE ptic FROM dbo.PracticeToInsuranceCompany ptic
WHERE ptic.InsuranceCompanyID NOT IN 
(SELECT InsuranceCompanyID FROM dbo.InsuranceCompanyPlan icp WHERE icp.CreatedPracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting From Insurance Company...'
DELETE ic FROM dbo.InsuranceCompany ic
LEFT JOIN dbo.InsuranceCompanyPlan icp ON
	ic.InsuranceCompanyID = icp.InsuranceCompanyID
LEFT JOIN dbo.EnrollmentPayer ep ON
	ic.InsuranceCompanyID = ep.InsuranceCompanyID
WHERE icp.InsuranceCompanyID IS NULL
AND ep.EnrollmentPayerID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

--ROLLBACK
--COMMIT
