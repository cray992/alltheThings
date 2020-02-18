USE superbill_32541_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 

PRINT ''
UPDATE dbo.Patient SET DefaultServiceLocationID = 1 from dbo.Patient 
WHERE VendorImportID IN (1,2) 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' Records updated into Patient Successfully'


--ROLLBACK
--COMMIT

