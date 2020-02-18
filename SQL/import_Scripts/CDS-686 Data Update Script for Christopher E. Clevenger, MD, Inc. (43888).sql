USE superbill_43888_dev
--superbill_43888_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR)

PRINT ''
PRINT 'Updating Patient - HomePhone...'
UPDATE dbo.Patient 
	SET HomePhone = i.guartele
FROM dbo.[_import_2_1_phoneupdate] i
INNER JOIN dbo.Patient p ON 
	i.accountno = p.VendorID AND 
	p.PracticeID = @PracticeID
WHERE p.HomePhone IS NULL AND i.guartele <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT



