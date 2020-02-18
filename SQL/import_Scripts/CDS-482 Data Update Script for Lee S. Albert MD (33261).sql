USE superbill_33261_dev
--USE superbill_XXX_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 3 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Patient Referring Phyisician ID...'
UPDATE dbo.Patient
SET ReferringPhysicianID = d.doctorid
FROM dbo.[_import_4_1_PatientDemos] i
INNER JOIN dbo.Patient p ON 
i.mrn = p.PatientID AND 
p.VendorImportID = @VendorImportID
INNER JOIN dbo.Doctor d ON
i.rdr = d.VendorID AND
d.VendorImportID = @VendorImportID AND
d.[External] = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

