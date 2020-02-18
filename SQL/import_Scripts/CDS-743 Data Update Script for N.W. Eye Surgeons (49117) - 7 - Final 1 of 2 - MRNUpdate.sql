--USE superbill_49117_dev
USE superbill_49117_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID1 INT
DECLARE @VendorImportID2 INT
DECLARE @VendorImportID3 INT
DECLARE @VendorImportID4 INT
DECLARE @VendorImportID5 INT

SET @PracticeID = 1
SET @VendorImportID1 = 0
SET @VendorImportID2 = 5
SET @VendorImportID3 = 6
SET @VendorImportID4 = 7
SET @VendorImportID5 = 8

SET NOCOUNT ON 

CREATE TABLE #temppat (personid VARCHAR(50) , mrn VARCHAR(50))

INSERT INTO	#temppat
        ( personid , mrn ) 
SELECT DISTINCT    
		  i.personid , -- personid - varchar(50)
		  i.medrecnbrchartnumber 
FROM dbo.[_import_14_1_491171PatientDemoUpdate1] i

UNION

SELECT DISTINCT    
		  i.personid , -- personid - varchar(50)
		  i.medrecnbrchartnumber
FROM dbo.[_import_17_1_491171PatientDemoUpdate2] i

PRINT ''
PRINT 'Updating Existing Patients with Demographic Info from Most Recent Export from NGProd...'
UPDATE dbo.Patient 
	SET MedicalRecordNumber = CASE WHEN i.mrn <> p.MedicalRecordNumber THEN i.mrn ELSE p.MedicalRecordNumber END 
FROM dbo.Patient p 
	INNER JOIN #temppat i ON 
		p.VendorID = i.personid AND 
		p.PracticeID = @PracticeID AND 
        p.VendorImportID IN (@VendorImportID1,@VendorImportID2,@VendorImportID3,@VendorImportID4,@VendorImportID5)
WHERE p.MedicalRecordNumber = '' AND i.mrn <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #temppat

--ROLLBACK
--COMMIT

