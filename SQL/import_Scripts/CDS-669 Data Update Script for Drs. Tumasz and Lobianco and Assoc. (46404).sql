USE superbill_46404_dev
--superbill_46404_prod
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
PRINT 'Updating Patient - HomePhone, MobilePhone, WorkPhone, and SSN...'
UPDATE dbo.Patient 
	SET SSN = CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.ssn)) >= 6 THEN RIGHT('000' + dbo.fn_RemoveNonNumericCharacters(i.ssn), 9) ELSE '' END ,
		MobilePhone = dbo.fn_RemoveNonNumericCharacters(i.cellphone)  ,
		WorkPhone = dbo.fn_RemoveNonNumericCharacters(i.workphone) 
FROM dbo.[_import_2_1_Sheet1] i 
INNER JOIN dbo.Patient p ON 
	i.account = p.VendorID AND 
	p.VendorImportID = @VendorImportID
WHERE p.ModifiedDate = '2015-10-14 16:59:55.090' AND p.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

