USE superbill_56908_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 1

SET NOCOUNT ON 

-- Update all amounts from import file
PRINT 'Updating Encounter Procedure....'
UPDATE dbo.EncounterProcedure 
	SET ServiceChargeAmount = i.ticketbalance
FROM dbo.EncounterProcedure ep 
	INNER JOIN dbo._import_5_1_Balfwd i ON 
		i.ticket = ep.VendorID AND 
		ep.VendorImportID = @VendorImportID
WHERE ep.VendorImportID = @VendorImportID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

-- Update all but 1 record with a 0 amount 
CREATE TABLE #epids (EpID INT)
INSERT INTO #epids  ( EpID )
SELECT DISTINCT ep1.EncounterProcedureID 
FROM dbo._import_5_1_Balfwd i
INNER JOIN (
	SELECT EncounterProcedureID , ProcedureCodeDictionaryID , VendorID , VendorImportID, ROW_NUMBER() OVER(PARTITION BY VendorID ORDER BY EncounterProcedureID ASC) AS EpNum FROM dbo.EncounterProcedure WHERE VendorImportID = @VendorImportID
		  ) AS Ep1 ON i.ticket = Ep1.VendorID 
WHERE ep1.EpNum > 1

PRINT ''
PRINT 'Updating Encounter Procedure....'
UPDATE dbo.EncounterProcedure 
	SET ServiceChargeAmount = '0.00'
FROM dbo.EncounterProcedure ep 
INNER JOIN #epids i ON 
	ep.EncounterProcedureID = i.EpID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

DROP TABLE #epids

--ROLLBACK
--COMMIT