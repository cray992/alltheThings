USE superbill_63463_pk
GO

SET XACT_ABORT ON

--BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 6
SET @SourcePracticeID = 6
SET @VendorImportID = 2

SET NOCOUNT ON

PRINT ''
PRINT 'Inserting ProcedureCodes into dbo.ContractsAndFees Table...'

INSERT INTO dbo.ContractsAndFees_StandardFee
(
    StandardFeeScheduleID,
    ProcedureCodeID,
    ModifierID,
    SetFee,
    AnesthesiaBaseUnits
)
SELECT 
6, b.ProcedureCodeDictionaryID,c.ProcedureModifierID, CAST(a.standardfee AS MONEY), 0
FROM dbo._import_2_6_StandardFeeSchedule a
INNER JOIN dbo.ProcedureCodeDictionary b ON a.cpt=b.ProcedureCode
LEFT JOIN dbo.ProcedureModifier c ON a.modifier=c.ProcedureModifierCode
LEFT JOIN dbo.ContractsAndFees_StandardFee d ON b.ProcedureCodeDictionaryID=d.ProcedureCodeID 
AND (d.ModifierID=c.ProcedureModifierID or a.modifier ='')
WHERE d.StandardFeeID IS NULL

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

