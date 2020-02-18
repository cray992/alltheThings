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

CREATE TABLE #temppat (vendorid VARCHAR(25) , legacyprovidercode VARCHAR(10))

INSERT INTO #temppat
        ( vendorid, legacyprovidercode )
SELECT DISTINCT		
          patientlegacyaccountnumber , -- vendorid - varchar(25)
          ptassignedprovider  -- legacyprovidercode - varchar(10)
FROM dbo.[_import_4_1_patient] 

INSERT INTO #temppat
        ( vendorid, legacyprovidercode )
SELECT DISTINCT		
          i.patientlegacyaccountnumber , -- vendorid - varchar(25)
          i.ptassignedprovider  -- legacyprovidercode - varchar(10)
FROM dbo.[_import_5_1_Patient2] i 
WHERE NOT EXISTS (SELECT * FROM #temppat temp WHERE i.patientlegacyaccountnumber = temp.vendorid)

PRINT ''
PRINT 'Update Patient...'
UPDATE dbo.Patient 
	SET PrimaryProviderID = CASE i.legacyprovidercode 
								WHEN 'ADP' THEN 13
								WHEN 'AJR' THEN 16
								WHEN 'AJRI' THEN 16
								WHEN 'AJRE' THEN 16
								WHEN 'CRC' THEN 3
								WHEN 'CRCI' THEN 3
								WHEN 'CRCE' THEN 3
								WHEN 'DMR' THEN 17
								WHEN 'DMRI' THEN 17
								WHEN 'DMRE' THEN 17
								WHEN 'MMW1' THEN 17
								WHEN 'DDP' THEN 14
								WHEN 'GAL' THEN 11
								WHEN 'GWS' THEN 18
								WHEN 'GWSI' THEN 18
								WHEN 'GWSE' THEN 18
								WHEN 'IG' THEN 6
								WHEN 'IGI' THEN 6
								WHEN 'IGE' THEN 6
								WHEN 'MMW3' THEN 6
								WHEN 'AKB3' THEN 2
								WHEN 'JCC' THEN 2
								WHEN 'JSF' THEN 5
								WHEN 'DPB 4' THEN 5
								WHEN 'JMS' THEN 19
								WHEN 'JGT' THEN 20
								WHEN 'AKB1' THEN 20
								WHEN 'JSH' THEN 8
								WHEN 'JSHE' THEN 8
								WHEN 'JSHI' THEN 8
								WHEN 'JPD' THEN 4
								WHEN 'MMW2' THEN 12
								WHEN 'JPLI' THEN 12
								WHEN 'JPLE' THEN 12
								WHEN 'LRP' THEN 15
								WHEN 'LTW' THEN 23
								WHEN 'DPB 3' THEN 23
								WHEN 'LAG' THEN 7
								WHEN 'AKB2' THEN 7
								WHEN 'MBWI' THEN 21
								WHEN 'MBWE' THEN 21
								WHEN 'MBW' THEN 21
								WHEN 'MMW' THEN 25
								WHEN 'MAHE' THEN 9
								WHEN 'MAH1' THEN 9
								WHEN 'MAH' THEN 9
								WHEN 'AKB4' THEN 10
								WHEN 'PJK' THEN 10
								WHEN 'DPB 2' THEN 22
								WHEN 'RAW' THEN 22
								WHEN 'TWW' THEN 24
								WHEN 'TWWI' THEN 24
								WHEN 'TWWE' THEN 24
							ELSE NULL END ,
			ModifiedDate = GETDATE()
FROM dbo.Patient p 
INNER JOIN #temppat t ON 
	p.VendorID = t.vendorid AND 
	p.VendorImportID = @VendorImportID
INNER JOIN dbo.[_import_1_1_importprovider] i ON
	t.legacyprovidercode = i.legacyprovidercode
WHERE p.PrimaryProviderID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Encounter...'
UPDATE dbo.Encounter 
	SET DoctorID = p.PrimaryProviderID
FROM dbo.Encounter e 
INNER JOIN dbo.Patient p ON 
	e.PatientID = p.PatientID AND 
	p.VendorImportID = @VendorImportID
WHERE e.VendorImportID = @VendorImportID AND EncounterStatusID = 2 AND p.PrimaryProviderID IS NOT NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT



