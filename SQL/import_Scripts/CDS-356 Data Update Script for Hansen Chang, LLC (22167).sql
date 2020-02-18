USE superbill_22167_dev 
--USE superbill_22167_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN

 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 8 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating PCP and PP IDS...'
UPDATE dbo.Patient 
	SET PrimaryCarePhysicianID = 4 ,
		PrimaryProviderID = 4 , 
		ModifiedDate = GETDATE() , 
		ModifiedUserID = -50
FROM dbo.Patient WHERE PrimaryCarePhysicianID = 1 OR PrimaryProviderID = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--ROLLBACK
--COMMIT