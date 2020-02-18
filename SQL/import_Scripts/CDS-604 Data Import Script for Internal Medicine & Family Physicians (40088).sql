USE superbill_40088_dev
--USE superbill_40088_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 3

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR) 
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR)

PRINT ''
PRINT 'Updating Patient...'
UPDATE dbo.Patient SET VendorID = i.chartnumber
FROM dbo.[_import_3_1_PatientData] i
INNER JOIN dbo.Patient p ON 
i.firstname = p.FirstName AND i.lastname = p.LastName AND DATEADD(hh,12,CAST(i.dateofbirth AS DATETIME)) = p.DOB
WHERE p.VendorID IS NULL  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT