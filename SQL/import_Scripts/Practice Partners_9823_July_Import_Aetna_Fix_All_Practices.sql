USE superbill_9823_dev
--USE superbill_9823_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON


-- Fetch the correct aetna plan ids
DECLARE @IncorrectPPOPlanID INT
DECLARE @CorrectPPOPlanID INT

SET @IncorrectPPOPlanID = (SELECT InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan WHERE PlanName = 'Aetna PPO' AND InsuranceCompanyID = (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = 'Meritain Health (Aetna)'))
SET @CorrectPPOPlanID = (SELECT InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan WHERE PlanName = 'Aetna PPO' AND InsuranceCompanyID = (SELECT InsuranceCompanyID FROM dbo.InsuranceCompany WHERE InsuranceCompanyName = 'Aetna'))

-- SELECT @IncorrectPPOPlanID, @CorrectPPOPlanID


UPDATE dbo.InsurancePolicy
SET
	InsuranceCompanyPlanID = @CorrectPPOPlanID
WHERE
	InsuranceCompanyPlanID = @IncorrectPPOPlanID AND
	NOT (VendorImportID IS NULL)


PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records updated'

COMMIT TRAN