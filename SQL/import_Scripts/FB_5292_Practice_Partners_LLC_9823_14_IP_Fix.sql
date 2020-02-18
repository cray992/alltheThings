USE superbill_9823_dev
--USE superbill_9823_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT


-- This script ASSUMES that someone has created the first practice record.
SET @PracticeID = 14
SET @VendorImportID = 7

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

  
-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	AND precedence = 2
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'


-- Fetch the default ins plan ID
DECLARE @DefaultInsPlanID INT
SET @DefaultInsPlanID = (SELECT InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan WHERE PlanName = 'Check/Change Insurance')



-- Insurance Policy 2
PRINT ''
PRINT 'Inserting records into InsurancePolicy for secondary insurance ...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PolicyNumber,
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	PracticeID,
	VendorImportID,
	ReleaseOfInformation
)
SELECT DISTINCT
	pc.PatientCaseID
	,CASE WHEN icp.InsuranceCompanyPlanID IS NULL THEN @DefaultInsPlanID 
			ELSE icp.InsuranceCompanyPlanID END
	,2
	,impP.[sinsid]
	,'S'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,@VendorImportID
	,'Y'
FROM dbo.[_import_7_14_ClarkPatientDataSecondary] impP
INNER JOIN dbo.Patient realP ON 
	realP.VendorImportID = @VendorImportID AND
	realP.VendorID = impP.account
INNER JOIN dbo.PatientCase pc ON 
	pc.VendorImportID = @VendorImportID AND
	pc.PatientID = realP.PatientID
LEFT OUTER JOIN (
		SELECT MAX(InsuranceCompanyPlanID) AS InsuranceCompanyPlanID, PlanName FROM dbo.InsuranceCompanyPlan GROUP BY PlanName -- Had to do this because there are multiple plans with the same name
) icp ON impP.[Insurance_Plan] = icp.PlanName
WHERE impP.insurance_company <> 'No Insurance'

PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT TRAN


