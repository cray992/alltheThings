USE superbill_43208_dev
--superbill_43208_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 2
SET @VendorImportID = 1

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR)


PRINT ''
PRINT 'Updating Insurance Company...'
UPDATE dbo.InsuranceCompany 
	SET CreatedPracticeID = @PracticeID ,
		ReviewCode = 'R'
WHERE CreatedPracticeID = 1 AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Practice to Insurance Company...'
UPDATE dbo.PracticeToInsuranceCompany 
	SET PracticeID = @PracticeID 
FROM dbo.PracticeToInsuranceCompany ptic 
INNER JOIN dbo.InsuranceCompany ic ON 
ptic.InsuranceCompanyID = ic.InsuranceCompanyID AND 
ic.VendorImportID = @VendorImportID
WHERE PracticeID = 1 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Insurance Company...'
UPDATE dbo.InsuranceCompanyPlan 
	SET CreatedPracticeID = @PracticeID ,
		ReviewCode = 'R'
WHERE CreatedPracticeID = 1 AND VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT


