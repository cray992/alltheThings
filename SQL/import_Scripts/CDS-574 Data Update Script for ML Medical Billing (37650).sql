USE superbill_37650_dev
--USE superbill_37650_prod
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 5
SET @VendorImportID = 8

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR)
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR)

PRINT ''
PRINT 'Updating Patient DOB...'
UPDATE dbo.Patient
	SET DOB = i.dob
FROM dbo.Patient p 
INNER JOIN dbo.[_import_8_5_koblinDOBimporterror] i ON
	p.VendorID = i.vendorid AND p.VendorImportID = 6
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT