USE superbill_35270_dev
--USE superbill_35270_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

PRINT ''
PRINT 'Updating Patient...'
UPDATE dbo.Patient
	SET HomePhone = dbo.fn_RemoveNonNumericCharacters(phone)
FROM dbo.[_import_5_1_Sheet1] i
INNER JOIN dbo.Patient p ON 
i.patientaccount = p.VendorID
WHERE p.HomePhone = ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT