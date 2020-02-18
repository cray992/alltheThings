USE superbill_11990_dev 
--USE superbill_11990_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 5
SET @VendorImportID = 2

	
UPDATE PatientCase
	SET 
		PatientCase.Name = icp.PlanName
	FROM 
		PatientCase
		INNER JOIN InsurancePolicy ip on ip.PatientCaseID = PatientCase.PatientCaseID
		INNER JOIN InsuranceCompanyPlan icp on icp.InsuranceCompanyPlanID = ip.InsuranceCompanyPlanID
	WHERE
		PatientCase.VendorImportID = @VendorImportID AND
		PatientCase.PracticeID = @PracticeID
	
PRINT cast(@@rowcount as varchar) + ' Patient Cases updated'

COMMIT TRAN	