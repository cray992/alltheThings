-- *** NEED PRACTICEID ******SEE BELOW****************************
-- Insert data into ProcedureCodeDictionary, Contract, ContractFeeSchedule
-- Chuck B.
-- 11/6/06
-- Designed to be a generic import.
-- REQUIRES TABLE NAME "xContractFeeSchedule" with following datatypes
-- Put Create Table def here - TODO???
-- REQUIRES PRACTICEID

DECLARE @ContractID INT
DECLARE @PracticeID INT
DECLARE @Message VarChar(250)
DECLARE @Rows INT
DECLARE @VendorImportID INT

-- *** NEED PRACTICEID **********************************
-- ==================================================================
SET @PracticeID = 10
--SELECT @PracticeID = PracticeID
--FROM dbo.Practice
--WHERE ([Name] = 'Test F')
-- ==================================================================

-- First do diagnostic testing
-- * Test for existence of source table.
-- * Test for proper datatypes in source table.
-- * Test if data will be truncated
-- * Test for duplicates in source table.
-- * Test for duplicates in destination table. (Not Required)

-- * Test for existence of source table.
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[xContractFeeSchedule]') AND type in (N'U'))
BEGIN
	-- No Source Table
	SET @Message = 'Unable to locate source table. Processs is aborted'
	Print @Message
	RETURN
END


-- * Test for proper datatypes in source table.
-- Only need to test Rate Column
SELECT * FROM xContractFeeSchedule WHERE ISNUMERIC(RATE) = 0
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in RATE column must be numeric. Process is aborted'
	Print @Message
	RETURN
END


-- * Test if data will be truncated
SELECT * FROM xContractFeeSchedule WHERE LEN(CODE) > 16
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in CODE will be truncated. Process aborted'
	Print @Message
	RETURN
END


SELECT * FROM xContractFeeSchedule WHERE LEN(DESCRIPTION) > 300
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Values in DESCRIPTION will be truncated. Process aborted'
	Print @Message
	RETURN
END

-- * Test for duplicates in source table.
SELECT COUNT(CODE) AS CntCode, CODE
FROM xContractFeeSchedule
GROUP BY CODE
HAVING (COUNT(CODE) > 1)
Select @Rows = @@RowCount
IF @Rows > 0
BEGIN
	-- No Source Table
	SET @Message = 'Duplicate procedure codes in source data. Process aborted'
	Print @Message
	RETURN
END

-- Create VendorID and VendorImportId in ProcedureCodeDictionary if they do not exist.
--IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('ProcedureCodeDictionary') and name='VendorID')
--BEGIN
--	ALTER TABLE ProcedureCodeDictionary ADD VendorID varchar(50)
--	PRINT 'Added column ' + 'VendorID' + ' to table ' + 'ProcedureCodeDictionary'
--END

IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('ProcedureCodeDictionary') and name='VendorImportID')
BEGIN
	ALTER TABLE ProcedureCodeDictionary ADD VendorImportID int
	PRINT 'Added column ' + 'VendorImportID' + ' to table ' + 'ProcedureCodeDictionary'
END

-- Create VendorID and VendorImportId in ContractFeeSchedule if they do not exist.
--IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('ContractFeeSchedule') and name='VendorID')
--BEGIN
--	ALTER TABLE ProcedureCodeDictionary ADD VendorID varchar(50)
--	PRINT 'Added column ' + 'VendorID' + ' to table ' + 'ContractFeeSchedule'
--END

IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('ContractFeeSchedule') and name='VendorImportID')
BEGIN
	ALTER TABLE ProcedureCodeDictionary ADD VendorImportID int
	PRINT 'Added column ' + 'VendorImportID' + ' to table ' + 'ContractFeeSchedule'
END

-- Create VendorID and VendorImportId in Contract if they do not exist.
--IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Contract') and name='VendorID')
--BEGIN
--	ALTER TABLE ProcedureCodeDictionary ADD VendorID varchar(50)
--	PRINT 'Added column ' + 'VendorID' + ' to table ' + 'Contract'
--END

IF NOT EXISTS (SELECT * FROM syscolumns where id=object_id('Contract') and name='VendorImportID')
BEGIN
	ALTER TABLE ProcedureCodeDictionary ADD VendorImportID int
	PRINT 'Added column ' + 'VendorImportID' + ' to table ' + 'Contract'
END


Begin Transaction
Begin

    Insert Into VendorImport
    ( VendorName
      , VendorFormat
      , Notes
    )
    Values
    (
      'No Name'
      , 'Text - '
      , 'Import Contract Fee Schedule.'
    )

    Set @VendorImportID = @@IDENTITY

-- INSERT Procedure Codes into ProcedureCodeDictionary that are in source data but not in destination data
INSERT INTO ProcedureCodeDictionary
(ProcedureCode, OfficialName, VendorImportID)
SELECT DISTINCT 
CONVERT(varchar(16), xContractFeeSchedule.CODE) AS ProcedureCode, 
CONVERT(varchar(300), xContractFeeSchedule.DESCRIPTION) AS OfficialName,
@VendorImportID AS VendorImportID
FROM xContractFeeSchedule 
LEFT OUTER JOIN dbo.ProcedureCodeDictionary 
ON xContractFeeSchedule.CODE = dbo.ProcedureCodeDictionary.ProcedureCode
WHERE (dbo.ProcedureCodeDictionary.ProcedureCode IS NULL)

Select @Rows = @@RowCount
Select @Message = 'Rows Added in ProcedureCodeDictionary Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--Create new record in Contract Table
INSERT INTO dbo.[Contract]
(PracticeID, ContractName, Description, ContractType, NoResponseTriggerPaper, NoResponseTriggerElectronic,
EffectiveStartDate, EffectiveEndDate)
VALUES(@PracticeID, 'Standard', 'Standard Imported', 'S', 45, 45, '11/1/2006', '10/31/2007')

SET @ContractID = SCOPE_IDENTITY()

Select @Rows = @@RowCount
Select @Message = 'Rows Added in Contract Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

--Insert data into ContractFeeSchedule
INSERT INTO ContractFeeSchedule
(ContractID, 
ProcedureCodeDictionaryID, 
StandardFee, 
Allowable,
ExpectedReimbursement,
Modifier, 
Gender, 
RVU,
VendorImportID)
SELECT DISTINCT 
@ContractID AS ContractID, 
dbo.ProcedureCodeDictionary.ProcedureCodeDictionaryID,
ContractFeeSch.StandardFee AS StandardFee,
ContractFeeSch.StandardFee AS Allowable,
ContractFeeSch.StandardFee AS ExpectedReimbursement,
NULL AS Modifier, 
'B' AS Gender, 
0 AS RVU,
@VendorImportID AS VendorImportID
FROM (SELECT 0 AS PracticeID, CONVERT(varchar(16), [CODE]) AS ProcedureCode, 
CONVERT(varchar(300), [DESCRIPTION]) AS OfficialName, ROUND(CONVERT(money, [rate]), 2) AS StandardFee 
FROM xContractFeeSchedule) AS ContractFeeSch 
INNER JOIN dbo.ProcedureCodeDictionary 
ON ContractFeeSch.ProcedureCode = dbo.ProcedureCodeDictionary.ProcedureCode

Select @Rows = @@RowCount
Select @Message = 'Rows Added in ContractFeeSchedule Table '
Print @Message + Replicate( '.' , 75 - Len( @Message ) ) + ' ' + Convert( Varchar(10) , @Rows )

End
-- ROLLBACK
-- Commit Transaction


-- *********** RollBack Script ***********************************
--	DECLARE @VendorImportID INT
--	--SET @VendorImportID = 
--	--SELECT @VendorImportID = MAX(VendorImportID) FROM VendorImport
--	DELETE FROM ProcedureCodeDictionary WHERE VendorImportID = @VendorImportID
--	DELETE FROM [Contract] WHERE VendorImportID = @VendorImportID
--	DELETE FROM ContractFeeSchedule WHERE VendorImportID = @VendorImportID
--	DELETE FROM VendorImport WHERE VendorImportID = @VendorImportID
-- ****************************************************************