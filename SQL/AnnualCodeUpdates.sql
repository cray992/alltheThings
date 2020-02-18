/*ANNUAL CODE UPDATES 2019 (SharedServer)*/
/*ANNUAL CODE UPDATES 2019 (Across all customers)*/

/***====================================================================================================***/
/*											TaxonomyCode 2019											  */
/***====================================================================================================***/
------------------------------------------------------------------------------------------------------------
--Test on one customer
/*
USE superbill_63463_dev
GO

SET XACT_ABORT ON
BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--Create TaxonomyCode
PRINT ''
PRINT 'Inserting into TaxonomyCode...'
INSERT INTO dbo.TaxonomyCode
(
TaxonomyCode,
TaxonomyTypeCode,
TaxonomySpecialtyCode,
TaxonomyCodeClassification,
TaxonomyCodeDesc
)
SELECT DISTINCT
tx.TaxonomyCode,
ts.TaxonomyTypeCode,
ts.TaxonomySpecialtyCode,
tx.TaxonomyCodeClassification,
tx.TaxonomyCodeDesc
--SELECT *
FROM SHAREDSERVER.DataCollection.dbo.[taxonomyCode2019$] tx
INNER JOIN dbo.TaxonomySpecialty ts ON ts.TaxonomySpecialtyCode = tx.TaxonomySpecialtyCode
LEFT JOIN dbo.TaxonomyCode tc ON tc.TaxonomyCode = tx.TaxonomyCode
WHERE tc.TaxonomyCode IS NULL and ts.TaxonomySpecialtyCode ='11'
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 */

 --SELECT * FROM dbo.TaxonomyCode WHERE TaxonomyCode = '207RA0002X'
--TaxonomyCode Insert (connect to central management server)

DECLARE @Sql VARCHAR(MAX)
SET @SQL='
INSERT INTO dbo.TaxonomyCode
(
TaxonomyCode,
TaxonomyTypeCode,
TaxonomySpecialtyCode,
TaxonomyCodeClassification,
TaxonomyCodeDesc
)
SELECT DISTINCT
tx.TaxonomyCode,
ts.TaxonomyTypeCode,
ts.TaxonomySpecialtyCode,
tx.TaxonomyCodeClassification,
tx.TaxonomyCodeDesc
FROM SHAREDSERVER.DataCollection.dbo.[taxonomyCode2019$] tx
INNER JOIN dbo.TaxonomySpecialty ts ON ts.TaxonomySpecialtyCode = tx.TaxonomySpecialtyCode
LEFT JOIN dbo.TaxonomyCode tc ON tc.TaxonomyCode = tx.TaxonomyCode
WHERE tc.TaxonomyCode IS NULL and ts.TaxonomySpecialtyCode =''''11''''
'
DECLARE @CurrentDB INT, --Current RowNum we're working on in the #DBInfo table
@DBCount INT, --Total count of rows in the #DBInfo table
@DBName VARCHAR(50)
CREATE TABLE #DBInfo
(
RowNum INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
[DatabaseID] INT NOT NULL,
DBName VARCHAR(128) NOT NULL,
)
;
INSERT INTO #DBInfo
SELECT
distinct
d.Database_ID,
--DatabaseServerName ,
customer.DatabaseName
FROM SHAREDSERVER.superbill_shared.dbo.customer AS customer WITH(NOLOCK)
INNER JOIN sys.databases d ON customer.DatabaseName=d.name
INNER JOIN (SELECT customerid FROM SHAREDSERVER.superbill_shared.dbo.ProductDomain_ProductSubscription WITH (NOLOCK) WHERE ProductId=6 AND DeactivationDate IS NULL) bill ON customer.CustomerID=bill.customerid
WHERE CustomerType='N'
ORDER BY customer.DatabaseName
;
--===== Preset the variables
SELECT @DBCount = MAX(RowNum),
@CurrentDB = 1
FROM #DBInfo
;
DECLARE @SqlCommand VARCHAR(MAX)
WHILE @CurrentDB <= @DBCount
BEGIN
SELECT @DBName=(SELECT #DBInfo.DBName FROM #DBInfo WHERE #DBInfo.RowNum=@CurrentDB);
PRINT @DBName
PRINT @CurrentDB
SET @SqlCommand='USE ['+@DBName+ ']; EXEC ('''+@SQL+''');'
EXEC(@SQLCommand);
--SELECT @SqlCommand
--===== Get ready to read the next file row
SELECT @CurrentDB = @CurrentDB + 1
;
END
DROP TABLE #DBInfo



/***====================================================================================================***/
/*											Modifier 2019												  */
/***====================================================================================================***/

----------------------------------------------------------------------------------------------------------

--Testing on one customer
/*
USE superbill_63463_dev
GO
SET XACT_ABORT ON
BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--insert new modifiers
PRINT ''
PRINT 'Inserting into ProcedureModifier...'
INSERT INTO dbo.ProcedureModifier
(
ProcedureModifierCode,
ModifierName,
CreatedDate,
CreatedUserID,
ModifiedDate,
ModifiedUserID
)
SELECT DISTINCT
i.procedureModifierCode, -- ProcedureModifierCode - varchar(16)
i.ModifierName, -- ModifierName - varchar(250)
GETDATE(), -- CreatedDate - datetime
0, -- CreatedUserID - int
GETDATE(), -- ModifiedDate - datetime
0 -- ModifiedUserID - int
--select *
FROM SHAREDSERVER.DataCollection.dbo.Modifier2019$ i
LEFT JOIN dbo.ProcedureModifier m ON i.proceduremodifiercode = m.ProcedureModifierCode
WHERE m.ProcedureModifierCode IS NULL
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 */

--ProcedureCodeModifier Insert (connect to central management server)

DECLARE @Sql VARCHAR(MAX)
SET @SQL='
INSERT INTO dbo.ProcedureModifier
(
ProcedureModifierCode,
ModifierName,
CreatedDate,
CreatedUserID,
ModifiedDate,
ModifiedUserID
)
SELECT DISTINCT
i.procedureModifierCode, -- ProcedureModifierCode - varchar(16)
i.ModifierName, -- ModifierName - varchar(250)
GETDATE(), -- CreatedDate - datetime
0, -- CreatedUserID - int
GETDATE(), -- ModifiedDate - datetime
0 -- ModifiedUserID - int
--select *
FROM SHAREDSERVER.DataCollection.dbo.[Modifier2019$] i
LEFT JOIN dbo.ProcedureModifier m ON i.proceduremodifiercode = m.ProcedureModifierCode
WHERE m.ProcedureModifierCode IS NULL
'
DECLARE @CurrentDB INT, --Current RowNum we're working on in the #DBInfo table
@DBCount INT, --Total count of rows in the #DBInfo table
@DBName VARCHAR(50)
CREATE TABLE #DBInfo
(
RowNum INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
[DatabaseID] INT NOT NULL,
DBName VARCHAR(128) NOT NULL,
)
;
INSERT INTO #DBInfo
SELECT
distinct
d.Database_ID,
--DatabaseServerName ,
customer.DatabaseName
FROM SHAREDSERVER.superbill_shared.dbo.customer AS customer WITH(NOLOCK)
INNER JOIN sys.databases d ON customer.DatabaseName=d.name
INNER JOIN (SELECT customerid FROM SHAREDSERVER.superbill_shared.dbo.ProductDomain_ProductSubscription WITH (NOLOCK) WHERE ProductId=6 AND DeactivationDate IS NULL) bill ON customer.CustomerID=bill.customerid
WHERE CustomerType='N'
ORDER BY customer.DatabaseName
;
--===== Preset the variables
SELECT @DBCount = MAX(RowNum),
@CurrentDB = 1
FROM #DBInfo
;
DECLARE @SqlCommand VARCHAR(MAX)
WHILE @CurrentDB <= @DBCount
BEGIN
SELECT @DBName=(SELECT #DBInfo.DBName FROM #DBInfo WHERE #DBInfo.RowNum=@CurrentDB);
PRINT @DBName
PRINT @CurrentDB
SET @SqlCommand='USE ['+@DBName+ ']; EXEC ('''+@SQL+''');'
EXEC(@SQLCommand);
--SELECT @SqlCommand
--===== Get ready to read the next file row
SELECT @CurrentDB = @CurrentDB + 1
;
END
DROP TABLE #DBInfo

  /***====================================================================================================***/
/*											CARC 2019													  */
/***====================================================================================================***/

----------------------------------------------------------------------------------------------------------
--Testing on one customer
/*
USE superbill_63463_dev
GO
SET XACT_ABORT ON
BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--insert new modifiers
PRINT ''
PRINT 'Inserting into AdjustmentReason...'
INSERT INTO dbo.AdjustmentReason
(
AdjustmentReasonCode,
Description
)
SELECT distinct
i.adjustmentreasoncode, -- AdjustmentReasonCode - varchar(5)
i.description -- Description - nvarchar(250)
--select *
FROM SHAREDSERVER.DataCollection.dbo.[CARC2019$] i
LEFT JOIN dbo.AdjustmentReason a ON i.adjustmentreasoncode = a.AdjustmentReasonCode
WHERE a.AdjustmentReasonCode IS NULL
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
 */

--CARC Insert (connect to central management server)

DECLARE @Sql VARCHAR(MAX)
SET @SQL='
INSERT INTO dbo.AdjustmentReason
(
AdjustmentReasonCode,
Description
)
SELECT distinct
i.adjustmentreasoncode, -- AdjustmentReasonCode - varchar(5)
i.description -- Description - nvarchar(250)
--select *
FROM SHAREDSERVER.DataCollection.dbo.[AdjustmentReason2019$] i
LEFT JOIN dbo.AdjustmentReason a ON i.adjustmentreasoncode = a.AdjustmentReasonCode
WHERE a.AdjustmentReasonCode IS NULL
'
DECLARE @CurrentDB INT, --Current RowNum we're working on in the #DBInfo table
@DBCount INT, --Total count of rows in the #DBInfo table
@DBName VARCHAR(50)
CREATE TABLE #DBInfo
(
RowNum INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
[DatabaseID] INT NOT NULL,
DBName VARCHAR(128) NOT NULL,
)
;
INSERT INTO #DBInfo
SELECT
distinct
d.Database_ID,
--DatabaseServerName ,
customer.DatabaseName
FROM SHAREDSERVER.superbill_shared.dbo.customer AS customer WITH(NOLOCK)
INNER JOIN sys.databases d ON customer.DatabaseName=d.name
INNER JOIN (SELECT customerid FROM SHAREDSERVER.superbill_shared.dbo.ProductDomain_ProductSubscription WITH (NOLOCK) WHERE ProductId=6 AND DeactivationDate IS NULL) bill ON customer.CustomerID=bill.customerid
WHERE CustomerType='N'
ORDER BY customer.DatabaseName
;
--===== Preset the variables
SELECT @DBCount = MAX(RowNum),
@CurrentDB = 1
FROM #DBInfo
;
DECLARE @SqlCommand VARCHAR(MAX)
WHILE @CurrentDB <= @DBCount
BEGIN
SELECT @DBName=(SELECT #DBInfo.DBName FROM #DBInfo WHERE #DBInfo.RowNum=@CurrentDB);
PRINT @DBName
PRINT @CurrentDB
SET @SqlCommand='USE ['+@DBName+ ']; EXEC ('''+@SQL+''');'
EXEC(@SQLCommand);
--SELECT @SqlCommand
--===== Get ready to read the next file row
SELECT @CurrentDB = @CurrentDB + 1
;
END
DROP TABLE #DBInfo


/***====================================================================================================***/
/*											HCPCS 2019													  */
/***====================================================================================================***/

-------------------------------------------------------------------------------------------------------------
--Testing on one customer
/*
USE superbill_63463_dev
GO
SET XACT_ABORT ON
BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--insert new modifiers
PRINT ''
PRINT 'Inserting into ProcedureCodeDictionary...'
INSERT INTO dbo.ProcedureCodeDictionary
(
ProcedureCode,
CreatedDate,
CreatedUserID,
ModifiedDate,
ModifiedUserID,
TypeOfServiceCode,
Active,
OfficialName,
OfficialDescription
)
SELECT DISTINCT i.procedureCode, -- ProcedureCode - varchar(16)
GETDATE(), -- CreatedDate - datetime
0, -- CreatedUserID - int
GETDATE(), -- ModifiedDate - datetime
0, -- ModifiedUserID - int
i.TypeOfServiceCode1, -- TypeOfServiceCode - char(1)
1, -- Active - bit
i.officialName, -- OfficialName - varchar(300)
i.OfficialDescription -- OfficialDescription - varchar(1200)
--select *
FROM SHAREDSERVER.DataCollection.dbo.[HCPCS2019$] i
JOIN dbo.TypeOfService s ON i.typeofservicecode1 = s.TypeOfServiceCode
LEFT JOIN dbo.ProcedureCodeDictionary d ON i.procedurecode = d.ProcedureCode
WHERE d.ProcedureCodeDictionaryID IS null
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '
*/

--HCPCS Insert (connect to central management server)

DECLARE @Sql VARCHAR(MAX)
SET @SQL='
INSERT INTO dbo.ProcedureCodeDictionary
(
ProcedureCode,
CreatedDate,
CreatedUserID,
ModifiedDate,
ModifiedUserID,
TypeOfServiceCode,
Active,
OfficialName,
OfficialDescription
)
SELECT DISTINCT i.procedureCode, -- ProcedureCode - varchar(16)
GETDATE(), -- CreatedDate - datetime
0, -- CreatedUserID - int
GETDATE(), -- ModifiedDate - datetime
0, -- ModifiedUserID - int
i.TypeOfServiceCode1, -- TypeOfServiceCode - char(1)
1, -- Active - bit
i.officialName, -- OfficialName - varchar(300)
i.OfficialDescription -- OfficialDescription - varchar(1200)
FROM SHAREDSERVER.DataCollection.dbo.[HCPCS2019$] i
JOIN dbo.TypeOfService s ON i.typeofservicecode1 = s.TypeOfServiceCode
LEFT JOIN dbo.ProcedureCodeDictionary d ON i.procedurecode = d.ProcedureCode
WHERE d.ProcedureCodeDictionaryID IS null
'
DECLARE @CurrentDB INT, --Current RowNum we're working on in the #DBInfo table
@DBCount INT, --Total count of rows in the #DBInfo table
@DBName VARCHAR(50)
CREATE TABLE #DBInfo
(
RowNum INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
[DatabaseID] INT NOT NULL,
DBName VARCHAR(128) NOT NULL,
)
;
INSERT INTO #DBInfo
SELECT
distinct
d.Database_ID,
--DatabaseServerName ,
customer.DatabaseName
FROM SHAREDSERVER.superbill_shared.dbo.customer AS customer WITH(NOLOCK)
INNER JOIN sys.databases d ON customer.DatabaseName=d.name
INNER JOIN (SELECT customerid FROM SHAREDSERVER.superbill_shared.dbo.ProductDomain_ProductSubscription WITH (NOLOCK) WHERE ProductId=6 AND DeactivationDate IS NULL) bill ON customer.CustomerID=bill.customerid
WHERE CustomerType='N'
ORDER BY customer.DatabaseName
;
--===== Preset the variables
SELECT @DBCount = MAX(RowNum),
@CurrentDB = 1
FROM #DBInfo
;
DECLARE @SqlCommand VARCHAR(MAX)
WHILE @CurrentDB <= @DBCount
BEGIN
SELECT @DBName=(SELECT #DBInfo.DBName FROM #DBInfo WHERE #DBInfo.RowNum=@CurrentDB);
PRINT @DBName
PRINT @CurrentDB
SET @SqlCommand='USE ['+@DBName+ ']; EXEC ('''+@SQL+''');'
EXEC(@SQLCommand);
--SELECT @SqlCommand
--===== Get ready to read the next file row
SELECT @CurrentDB = @CurrentDB + 1
;
END
DROP TABLE #DBInfo

----Oracle

Insert into healthcare.cpt_references(CPT_References_ID, CODE, CODE_Type, N_DATE, TEXT, CONCEPT, CONCEPT_PARENT, Create_DT, LAST_MOD_DT,Created_BY, LAST_MOD_BY, EXTERNAL_CREATOR , External_Modifier, IS_Deleted)
Select healthcare.cpt_references_seq.nextval, cpt.procedurecode, 'CPT', '2019', cpt.OFFICIALDESCRIPTION, cpt.OFFICIALNAME, cpt.OFFICIALDESCRIPTION, sysdate, sysdate, -1, -1, 'DBA', 'DBA', 0
from ehrdba.CptFinal cpt
Left Join healthcare.cpt_references c on c.code=cpt.procedureCODE
where c.code is null and cpt.procedurecode!='HCPC';


  /***====================================================================================================***/
/*											CPT 2019													  */
/***====================================================================================================***/

------------------------------------------------------------------------------------------------------------
--Testing on one customer
/*
USE superbill_63463_dev
GO
SET XACT_ABORT ON
BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

----DELETE CODE
PRINT ''
PRINT 'Update ProcedureCodeDictionary (deactivate code)...'
UPDATE dbo.ProcedureCodeDictionary
SET Active = 0
FROM dbo.ProcedureCodeDictionary d
JOIN SHAREDSERVER.DataCollection.dbo.[CPTDeletedCodes2019$] i ON i.CODE = d.ProcedureCode
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records updated '

--SELECT active, * FROM dbo.ProcedureCodeDictionary d
--JOIN SHAREDSERVER.DataCollection.dbo.[CPTDeletedCodes2019$] i ON i.CODE = d.ProcedureCode

 --Update CODE
 PRINT ''
PRINT 'Updating ProcedureCodeDictory...'
UPDATE dbo.ProcedureCodeDictionary
SET OfficialDescription = i.description
--select *
FROM SHAREDSERVER.DataCollection.dbo.[CPTRevisedCodes2019$] i
JOIN dbo.ProcedureCodeDictionary d ON i.code = d.ProcedureCode
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records update '


  --INSERT NEW CODE
 PRINT ''
PRINT 'Inserting into ProcedureCodeDictory...'
INSERT INTO dbo.ProcedureCodeDictionary
(
    ProcedureCode,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    TypeOfServiceCode,
    Active,
    OfficialName,
    CustomCode
)
SELECT DISTINCT
   i.code,        -- ProcedureCode - varchar(16)
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    i.[TOS Code],        -- TypeOfServiceCode - char(1)
    1,      -- Active - bit
    i.DESCRIPTION,        -- OfficialName - varchar(300)
    0       -- CustomCode - bit
	--select *
    FROM SHAREDSERVER.DataCollection.dbo.[CPTNewCodes2019$] i
	LEFT JOIN dbo.ProcedureCodeDictionary p ON i.CODE = p.ProcedureCode
	WHERE p.ProcedureCodeDictionaryID IS null
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

 */


--CPT Insert/Updates (connect to central management server)


DECLARE @Sql VARCHAR(MAX)
SET @SQL='
UPDATE dbo.ProcedureCodeDictionary
SET Active = 0
FROM dbo.ProcedureCodeDictionary d
JOIN SHAREDSERVER.DataCollection.dbo.[CPTDeletedCodes2019$] i ON i.CODE = d.ProcedureCode

UPDATE dbo.ProcedureCodeDictionary
SET OfficialDescription = i.description
FROM SHAREDSERVER.DataCollection.dbo.[CPTRevisedCodes2019$] i
JOIN dbo.ProcedureCodeDictionary d ON i.code = d.ProcedureCode

INSERT INTO dbo.ProcedureCodeDictionary
(
    ProcedureCode,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID,
    TypeOfServiceCode,
    Active,
    OfficialName,
    CustomCode
)
SELECT DISTINCT
   i.code,        -- ProcedureCode - varchar(16)
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0,         -- ModifiedUserID - int
    i.[TOS Code],        -- TypeOfServiceCode - char(1)
    1,      -- Active - bit
    i.DESCRIPTION,        -- OfficialName - varchar(300)
    0       -- CustomCode - bit
    FROM SHAREDSERVER.DataCollection.dbo.[CPTNewCodes2019$] i
	LEFT JOIN dbo.ProcedureCodeDictionary p ON i.CODE = p.ProcedureCode
	WHERE p.ProcedureCodeDictionaryID IS null

'
DECLARE @CurrentDB INT, --Current RowNum we're working on in the #DBInfo table
@DBCount INT, --Total count of rows in the #DBInfo table
@DBName VARCHAR(50)
CREATE TABLE #DBInfo
(
RowNum INT IDENTITY(1,1) PRIMARY KEY NONCLUSTERED,
[DatabaseID] INT NOT NULL,
DBName VARCHAR(128) NOT NULL,
)
;
INSERT INTO #DBInfo
SELECT
distinct
d.Database_ID,
--DatabaseServerName ,
customer.DatabaseName
FROM SHAREDSERVER.superbill_shared.dbo.customer AS customer WITH(NOLOCK)
INNER JOIN sys.databases d ON customer.DatabaseName=d.name
INNER JOIN (SELECT customerid FROM SHAREDSERVER.superbill_shared.dbo.ProductDomain_ProductSubscription WITH (NOLOCK) WHERE ProductId=6 AND DeactivationDate IS NULL) bill ON customer.CustomerID=bill.customerid
WHERE CustomerType='N'
ORDER BY customer.DatabaseName
;
--===== Preset the variables
SELECT @DBCount = MAX(RowNum),
@CurrentDB = 1
FROM #DBInfo
;
DECLARE @SqlCommand VARCHAR(MAX)
WHILE @CurrentDB <= @DBCount
BEGIN
SELECT @DBName=(SELECT #DBInfo.DBName FROM #DBInfo WHERE #DBInfo.RowNum=@CurrentDB);
PRINT @DBName
PRINT @CurrentDB
SET @SqlCommand='USE ['+@DBName+ ']; EXEC ('''+@SQL+''');'
EXEC(@SQLCommand);
--SELECT @SqlCommand
--===== Get ready to read the next file row
SELECT @CurrentDB = @CurrentDB + 1
;
END
DROP TABLE #DBInfo





/***====================================================================================================***/
/*											GCPI 2019													  */
/***====================================================================================================***/

-------------------------------------------------------------------------------------------------------------

USE superbill_shared
GO

SET XACT_ABORT ON
BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--create batchID for 2019
PRINT ''
PRINT 'Inserting into MedicareFeeScheduleGPCIBatch...'
INSERT INTO dbo.MedicareFeeScheduleGPCIBatch
(
    EffectiveStart
)
Values
(  CONVERT (DATETIME, '2019-01-01') -- EffectiveStart - datetime
)
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

--INSERT NEW GCPI
PRINT ''
PRINT 'Inserting into MedicareFeeScheduleGPCI...'
INSERT INTO dbo.MedicareFeeScheduleGPCI
(
    MedicareFeeScheduleGPCIBatchID,
    Carrier,
    Locality,
    LocalityName,
    WorkGPCI,
    PracticeExpenseGPCI,
    MalpracticeExpenseGPCI
)
SELECT DISTINCT
    b.MedicareFeeScheduleGPCIBatchID,   -- MedicareFeeScheduleGPCIBatchID - int
    i.carrier,   -- Carrier - int
    i.locality,   -- Locality - int
    i.localityName,  -- LocalityName - varchar(128)
    i.workGPCI, -- WorkGPCI - float
    i.PracticeExpenseGPCI, -- PracticeExpenseGPCI - float
    i.MalpracticeExpenseGPCI  -- MalpracticeExpenseGPCI - float
	--select *
    FROM SHAREDSERVER.DataCollection.dbo.[GPCI2019$] i
	JOIN dbo.MedicareFeeScheduleGPCIBatch b ON b.EffectiveStart = CONVERT (DATETIME, '2019-01-01')
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

 --SELECT * FROM dbo.MedicareFeeScheduleGPCIBatch
 --SELECT * FROM dbo.MedicareFeeScheduleGPCI
 --WHERE MedicareFeeScheduleGPCIBatchID NOT BETWEEN 1 AND 9

/***====================================================================================================***/
/*											LocalityZip 2019											  */
/***====================================================================================================***/

-------------------------------------------------------------------------------------------------------------

USE superbill_shared
GO

SET XACT_ABORT ON
BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--create batchID for 2019
PRINT ''
PRINT 'Inserting into MedicareFeeScheduleZipGPCILinkBatch...'
INSERT INTO dbo.MedicareFeeScheduleZipGPCILinkBatch
(
    EffectiveStart
)
VALUES
( CONVERT (DATETIME, '2019-01-01')  -- EffectiveStart - datetime
    )
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

--INSERT NEW ZIPCODE
PRINT ''
PRINT 'Inserting into MedicareFeeScheduleZipGPCILink...'
INSERT INTO dbo.MedicareFeeScheduleZipGPCILink
(
    MedicareFeeScheduleZipGPCILinkBatchID,
    ZipCode,
    Carrier,
    Locality
)
SELECT distinct
    b.MedicareFeeScheduleZipGPCILinkBatchID,  -- MedicareFeeScheduleZipGPCILinkBatchID - int
    i.[ZIP CODE], -- ZipCode - char(5)
    i.carrier,  -- Carrier - int
    i.locality   -- Locality - int
	--SELECT *
FROM SHAREDSERVER.DataCollection.dbo.[LocalityZip2019$] i
JOIN dbo.MedicareFeeScheduleZipGPCILinkBatch b ON b.EffectiveStart = CONVERT (DATETIME, '2019-01-01')
WHERE i.[zip code] IS NOT NULL
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


--SELECT * FROM dbo.MedicareFeeScheduleZipGPCILinkBatch
--SELECT * FROM dbo.MedicareFeeScheduleZipGPCILink
--WHERE MedicareFeeScheduleZipGPCILinkBatchID NOT BETWEEN 1 AND 8


/***====================================================================================================***/
/*											RVU Code 2019												  */
/***====================================================================================================***/

----------------------------------------------------------------------------------------------------------
USE superbill_shared
GO

SET XACT_ABORT ON
BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--INSERT NEW RVU BATCH
PRINT ''
PRINT 'Inserting into MedicareFeeScheduleRVUBatch...'
INSERT INTO dbo.MedicareFeeScheduleRVUBatch
(
    ConversionFactor,
    BudgetNeutralityAdjustor,
    EffectiveStart
)
SELECT DISTINCT
	i.conv_factor,      -- ConversionFactor - float
	1,      -- BudgetNeutralityAdjustor - float
	CONVERT (DATETIME, '2019-01-01') -- EffectiveStart - datetime
	--select *
    FROM SHAREDSERVER.DataCollection.dbo.[rvu2019$] i
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '

--INSERT NEW RVU
PRINT ''
PRINT 'Inserting into MedicareFeeScheduleRVU...'
INSERT INTO dbo.MedicareFeeScheduleRVU
(
    MedicareFeeScheduleRVUBatchID,
    ProcedureCode,
    Modifier,
    WorkRVU,
    FacilityPracticeExpenseRVU,
    NonFacilityPracticeExpenseRVU,
    MalpracticeExpenseRVU
)
SELECT DISTINCT
    b.MedicareFeeScheduleRVUBatchID,   -- MedicareFeeScheduleRVUBatchID - int
    i.procedure_code,  -- ProcedureCode - varchar(16)
    i.modifier,  -- Modifier - varchar(16)
    i.work_rvu, -- WorkRVU - float
    i.facility_practice_expenseRVU, -- FacilityPracticeExpenseRVU - float
    i.nonfacility_practice_expenseRVU, -- NonFacilityPracticeExpenseRVU - float
    i.malpractice_expense_RVU  -- MalpracticeExpenseRVU - float
	--select *
FROM SHAREDSERVER.DataCollection.dbo.[rvu2019$] i
JOIN dbo.MedicareFeeScheduleRVUBatch b ON b.EffectiveStart = CONVERT (DATETIME, '2019-01-01')
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


 SELECT * FROM dbo.MedicareFeeScheduleRVUBatch
 SELECT * FROM dbo.MedicareFeeScheduleRVU
 WHERE MedicareFeeScheduleRVUBatchID NOT BETWEEN 1 AND 8


--Cleaned up data
-- USE superbill_shared
--GO

--SET XACT_ABORT ON
--BEGIN TRANSACTION
----rollback
----commit

--SET NOCOUNT ON

----INSERT NEW RVU BATCH
--PRINT ''
--PRINT 'Deleting MedicareFeeScheduleRVU with batchID 9...'
--DELETE FROM dbo.MedicareFeeScheduleRVU
--WHERE MedicareFeeScheduleRVUBatchID = 9
-- PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records deleted '

-- SELECT * FROM dbo.MedicareFeeScheduleRVU
-- WHERE MedicareFeeScheduleRVUBatchID = 9

--Deleting MedicareFeeScheduleRVU with batchID 9...
--16638 records deleted

 /***====================================================================================================***/
/*											RARC 2019													  */
/***====================================================================================================***/
----------------------------------------------------------------------------------------------------------
USE superbill_shared
GO

SET XACT_ABORT ON
BEGIN TRANSACTION
--rollback
--commit

SET NOCOUNT ON

--INSERT NEW MODIFIERS
PRINT ''
PRINT 'Inserting into RemittanceRemark...'
INSERT INTO dbo.RemittanceRemark
(
    RemittanceCode,
    RemittanceDescription,
    RemittanceNotes,
    CreatedDate,
    CreatedUserID,
    ModifiedDate,
    ModifiedUserID
)
SELECT distinct
    i.remittanceid,       -- RemittanceCode - nvarchar(5)
    i.description,       -- RemittanceDescription - nvarchar(2000)
    i.notes,       -- RemittanceNotes - nvarchar(100)
    GETDATE(), -- CreatedDate - datetime
    0,         -- CreatedUserID - int
    GETDATE(), -- ModifiedDate - datetime
    0         -- ModifiedUserID - int
	--select *
	FROM SHAREDSERVER.DataCollection.dbo.[RARC2019$] i
	LEFT JOIN dbo.RemittanceRemark r ON i.remittanceid = r.RemittanceCode
	WHERE r.RemittanceID IS null
 PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records inserted '


 --SELECT * FROM dbo.RemittanceRemark
