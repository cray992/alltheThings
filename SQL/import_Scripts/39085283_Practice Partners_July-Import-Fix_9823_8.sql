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
SET @PracticeID = 8
SET @VendorImportID = 2 -- Spreadsheet uploaded via tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Insurance Company Planco
IF NOT EXISTS (SELECT * FROM dbo.InsuranceCompanyPlan WHERE PlanName = 'Check/Change Insurance')
BEGIN
	PRINT ''
	PRINT 'Inserting default "Check/Change Insurance" plan record into InsuranceCompanyPlan ...'
	INSERT INTO dbo.InsuranceCompanyPlan (
		PlanName,
		AddressLine1,
		AddressLine2,
		City,
		[State],
		Country,
		ZipCode,
		Phone,
		CreatedPracticeID,
		CreatedDate,
		CreatedUserID,
		ModifiedDate,
		ModifiedUserID,
		VendorID,
		VendorImportID,
		InsuranceCompanyID
	)
	SELECT
		InsuranceCompanyName
		,AddressLine1
		,AddressLine2
		,City
		,State
		,Country
		,ZipCode
		,Phone
		,CreatedPracticeID
		,GETDATE()
		,0
		,GETDATE()
		,0
		,0
		,@VendorImportID
		,InsuranceCompanyID
	FROM dbo.InsuranceCompany
	WHERE InsuranceCompanyName = 'Check/Change Insurance'

	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'
END

-- Fetch the default ins plan ID
DECLARE @DefaultInsPlanID INT
SET @DefaultInsPlanID = (SELECT TOP 1 InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan WHERE PlanName = 'Check/Change Insurance')

IF @DefaultInsPlanID > 0
BEGIN
	
	UPDATE dbo.InsurancePolicy
	SET
		InsuranceCompanyPlanID = @DefaultInsPlanID
	WHERE
		PracticeID = 8 AND
		InsuranceCompanyPlanID IN (SELECT InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan WHERE PlanName IN ('Student Assurance Service', 'Student Assurance Services'))
	
	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records updated'
	
END


COMMIT TRAN