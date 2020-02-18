USE superbill_37643_dev
--USE superbill_37343_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

PRINT ''
PRINT 'Inserting Into Procedure Code Dictionary...'
INSERT INTO dbo.ProcedureCodeDictionary
        ( ProcedureCode ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          TypeOfServiceCode ,
          Active ,
          OfficialName ,
          NOC ,
          CustomCode
        )
SELECT DISTINCT
		  i.procedureshortalias , -- ProcedureCode - varchar(16)
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          '1' , -- TypeOfServiceCode - char(1)
          1 , -- Active - bit
          i.procedurename , -- OfficialName - varchar(300)
          0 , -- NOC - int
          0  -- CustomCode - bit
FROM dbo.[_import_2_1_CosmeticFeeSchedulefromEMA] i
LEFT JOIN dbo.ProcedureCodeDictionary pcd ON 
	i.procedureshortalias = pcd.ProcedureCode
WHERE procedurename <> '' AND pcd.ProcedureCodeDictionaryID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

PRINT ''
PRINT 'Inserting Into StandardFee...'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT DISTINCT
		  sfe.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          '0' , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_2_1_CosmeticFeeSchedulefromEMA] i
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sfe ON
	sfe.SourceFileName = 'Kareo-Fee Schedule-OK.xls' AND
    sfe.Name = 'Standard Fees' AND 
	sfe.EffectiveStartDate = '2015-05-04 00:00:00.000'
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	i.procedureshortalias = pcd.ProcedureCode
WHERE NOT EXISTS (SELECT * FROM dbo.ContractsAndFees_StandardFee sf WHERE sf.ProcedureCodeID = pcd.ProcedureCodeDictionaryID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

--ROLLBACK
--COMMIT