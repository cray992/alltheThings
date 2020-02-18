-- Generic procedure for importing Diagnosis Codes
-- ***REQUIRES SYNONYM NAME set below "xDiagnosisCodeDictionary" with following column names
-- DiagnosisCode, Active, OfficialName - All can have varchar() datatype

-- ==================================================================
	IF  EXISTS (SELECT * FROM sys.synonyms WHERE name = N'xDiagnosisCodeDictionary')
	DROP SYNONYM [dbo].[xDiagnosisCodeDictionary]
    GO
    Create Synonym xDiagnosisCodeDictionary For dbo.x_Icddatame_txt
    Go
-- ==================================================================

-- Create VendorID and VendorImportId in DiagnosisCodeDictionary if they do not exist.
--IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('DiagnosisCodeDictionary') and name='VendorID')
--BEGIN
--	ALTER TABLE DiagnosisCodeDictionary ADD VendorID varchar(50)
--	PRINT 'Added column ' + 'VendorID' + ' to table ' + 'DiagnosisCodeDictionary'
--END

IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('DiagnosisCodeDictionary') and name='VendorImportID')
BEGIN
	ALTER TABLE DiagnosisCodeDictionary ADD VendorImportID int
	PRINT 'Added column ' + 'VendorImportID' + ' to table ' + 'DiagnosisCodeDictionary'
END
GO

--/////////////////////////////////////////////////////////////////////////////////

DECLARE @Message VarChar(250)
DECLARE @Rows INT
DECLARE @VendorImportID INT

-- * Test if data will be truncated
SELECT * FROM xDiagnosisCodeDictionary WHERE LEN(DiagnosisCode) > 16
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'DiagnosisCode in DiagnosisCodeDictionary will be truncated. Process aborted'
	Print @Message
	RETURN
END

-- * Test if data will be truncated
SELECT * FROM xDiagnosisCodeDictionary WHERE LEN(OfficialName) > 300
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'OfficialName in DiagnosisCodeDictionary will be truncated. Process aborted'
	Print @Message
	RETURN
END

-- * Test for duplicates in source table.
SELECT COUNT(DiagnosisCode) AS CntCode, DiagnosisCode
FROM xDiagnosisCodeDictionary
GROUP BY DiagnosisCode
HAVING (COUNT(DiagnosisCode) > 1)
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Duplicate DiagnosisCode in source data. Process aborted'
	Print @Message
	RETURN
END


BEGIN TRANSACTION
BEGIN

INSERT INTO VendorImport
    ( VendorName
      , VendorFormat
      , Notes
    )
    VALUES
    (
      'No Name'
      , 'Text - '
      , 'Import Diagnosis Codes.'
    )

SET @VendorImportID = @@IDENTITY

INSERT INTO DiagnosisCodeDictionary
(
	DiagnosisCode, 
	--CreatedDate, 
	--CreatedUserID, 
	--ModifiedDate, 
	--ModifiedUserID, 
	--RecordTimeStamp, 
	--KareoDiagnosisCodeDictionaryID, 
	--KareoLastModifiedDate, 
	Active, 
	OfficialName, 
	--LocalName, 
	--OfficialDescription,
	VendorImportID
)
SELECT 
	xDiagnosisCodeDictionary.[DiagnosisCode] AS DiagnosisCode, 
	1 AS Active,
	xDiagnosisCodeDictionary.OfficialName AS OfficialName,
	@VendorImportID AS VendorImportID
FROM DiagnosisCodeDictionary 
RIGHT OUTER JOIN xDiagnosisCodeDictionary 
ON DiagnosisCodeDictionary.DiagnosisCode = xDiagnosisCodeDictionary.DiagnosisCode
WHERE (DiagnosisCodeDictionary.DiagnosisCode IS NULL)


END
-- ROLLBACK
-- COMMIT TRANSACTION


-- *********** RollBack Script ***********************************
--	DECLARE @VendorImportID INT
--	--SET @VendorImportID = 
--	--SELECT @VendorImportID = MAX(VendorImportID) FROM VendorImport
--	DELETE FROM DiagnosisCodeDictionary WHERE VendorImportID = @VendorImportID
--	DELETE FROM VendorImport WHERE VendorImportID = @VendorImportID
-- ****************************************************************