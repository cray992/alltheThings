USE superbill_28697_dev
--USE superbill_28697_prod
GO


SET XACT_ABORT ON

BEGIN TRAN

SET NOCOUNT ON

DECLARE @VendorImportID INT
DECLARE @PracticeID INT
  
SET @VendorImportID = 2
SET @PracticeID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Primary Care Phyisican with Primary Provider ID...'
UPDATE dbo.Patient 
	SET PrimaryCarePhysicianID = PrimaryProviderID
WHERE VendorImportID = 2 AND PrimaryProviderID IS NOT NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


--ROLLBACK
--COMMIT


