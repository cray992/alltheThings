--USE superbill_42725_dev
USE superbill_42725_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Update Patient...'
UPDATE dbo.Patient 
	SET ResponsibleZipCode = CASE WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.responsiblepartyzipcode)) IN (4,8) THEN '0' + dbo.fn_RemoveNonNumericCharacters(i.responsiblepartyzipcode)
								  WHEN LEN(dbo.fn_RemoveNonNumericCharacters(i.responsiblepartyzipcode)) IN (5,9) THEN dbo.fn_RemoveNonNumericCharacters(i.responsiblepartyzipcode)
							 ELSE '' END
FROM dbo.Patient p 
	INNER JOIN dbo.[_import_3_1_PatientDemographics] i ON
		p.VendorID = i.chartnumber AND 
		p.VendorImportID = @VendorImportID
WHERE p.ResponsibleZipCode <> dbo.fn_RemoveNonNumericCharacters(i.responsiblepartyzipcode) AND p.ResponsibleZipCode <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT


