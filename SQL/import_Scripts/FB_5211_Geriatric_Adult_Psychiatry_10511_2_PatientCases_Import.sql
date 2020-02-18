--USE superbill_10511_dev 
USE superbill_10511_prod
GO

 -- Tell SQL to roll all operations in this script back if an error is encountered anywhere along the way
SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 1 -- Vendor import record created through import tool

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

-- Clear out any existing records for this import, (makes the script safe to run multiple times)
PRINT ''
PRINT 'Purging existing records in destination tables for VendorImport ' + CAST(@VendorImportID AS VARCHAR(10))

DELETE FROM dbo.InsurancePolicy WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' InsurancePolicy records deleted'
DELETE FROM dbo.PatientCase WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID
	PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' PatientCase records deleted'
	
	
	
	

-- Patient Case (Depends on patient records already being imported, can only run after)
PRINT ''
PRINT 'Inserting records into PatientCase ...'
INSERT INTO dbo.PatientCase (
	PatientID,
	[Name],
	PayerScenarioID,
	Notes,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	PracticeID,
	VendorID,
	VendorImportID
)
SELECT
	realP.PatientID
	,'Case ' + impCase.[carrier_name]
	,5 -- 'Commercial' (I was told this is a good default)
	,'Created via data import'
	,GETDATE()
	,0
	,GETDATE()
	,0
	,@PracticeID
	,ID -- This is our Kareo assigned ID, it's unique
	,@VendorImportID
FROM 
	dbo.[_import_1_1_rad5797C] impCase
INNER JOIN dbo.Patient realP ON 
	impCase.ID = realP.VendorID AND 
	realP.VendorImportID = @VendorImportID AND
	realP.PracticeID = @PracticeID
WHERE
	realP.PracticeID = @PracticeID AND
	realP.VendorImportID = @VendorImportID AND -- This is very important as previous vendor imports can potentially contain VendorIDs that collide with this import. 
	impCase.patient_note <> '' AND
	impCase.patient_note <> 'NON-PATIENT ACCOUNTS (MR)' AND
	impCase.patient_note <> 'Status 9 Message'
	
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'



-- Insurance Policy
PRINT ''
PRINT 'Inserting records into InsurancePolicy ...'
INSERT INTO dbo.InsurancePolicy (
	PatientCaseID,
	InsuranceCompanyPlanID,
	Precedence,
	PatientRelationshipToInsured,
	CreatedDate,
	CreatedUserID,
	ModifiedDate,
	ModifiedUserID,
	Notes,
	PracticeID,
	VendorID,
	VendorImportID,
	ReleaseOfInformation	
)
SELECT DISTINCT
	pc.PatientCaseID
	,icp.InsuranceCompanyPlanID
	,1
	,'S' 
	,GETDATE()
	,0
	,GETDATE()
	,0
	,'Record created via data import, please review.'
	,@PracticeID
	,impPI.ID -- auto ID we added to temp table
	,@VendorImportID
	,'Y'
FROM dbo.[_import_1_1_rad5797C] impPI
INNER JOIN dbo.Patient realP on impPI.ID = realP.vendorID AND
	realP.VendorImportID = @VendorImportID
	INNER JOIN dbo.PatientCase pc ON realP.PatientID = pc.PatientID AND
		 pc.VendorImportID = @VendorImportID
INNER JOIN dbo.InsuranceCompanyPlan icp ON 
	impPI.[carrier_name] = icp.PlanName AND
	icp.VendorImportID = @VendorImportID
WHERE
	pc.VendorImportID = @VendorImportID AND
	pc.PracticeID = @PracticeID


PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'