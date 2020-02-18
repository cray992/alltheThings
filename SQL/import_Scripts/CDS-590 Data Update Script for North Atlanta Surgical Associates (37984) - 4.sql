USE superbill_37984_dev
--USE superbill_37984_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

CREATE TABLE #temppat2 (vendorid VARCHAR(25) , legacyprovidercode VARCHAR(10))

INSERT INTO #temppat2
        ( vendorid, legacyprovidercode )
SELECT DISTINCT		
          patientlegacyaccountnumber , -- vendorid - varchar(25)
          ptassignedprovider  -- legacyprovidercode - varchar(10)
FROM dbo.[_import_4_1_patient] 

INSERT INTO #temppat2
        ( vendorid, legacyprovidercode )
SELECT DISTINCT		
          i.patientlegacyaccountnumber , -- vendorid - varchar(25)
          i.ptassignedprovider  -- legacyprovidercode - varchar(10)
FROM dbo.[_import_5_1_Patient2] i 
WHERE NOT EXISTS (SELECT * FROM #temppat2 temp WHERE i.patientlegacyaccountnumber = temp.vendorid)

PRINT ''
PRINT 'Update Patient...'
UPDATE dbo.Patient 
	SET PrimaryProviderID = CASE i.legacyprovidercode 
								WHEN 'JPL' THEN 12
							ELSE NULL END ,
			ModifiedDate = GETDATE()
FROM dbo.Patient p 
INNER JOIN #temppat2 t ON 
	p.VendorID = t.vendorid AND 
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.[_import_1_1_importprovider] i ON
	t.legacyprovidercode = i.legacyprovidercode
WHERE p.PrimaryProviderID IS NULL AND t.legacyprovidercode = 'JPL'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #temppat2

--ROLLBACK
--COMMIT



