--USE superbill_5075_dev
USE superbill_5075_prod
go

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @OldPracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 8
SET @OldPracticeID = 4
SET @VendorImportID = 101

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Inserting into StandardFeeSchedule ...'
INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
        ( PracticeID ,
          Name ,
          Notes ,
          EffectiveStartDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
          MedicareFeeScheduleGPCICarrier ,
          MedicareFeeScheduleGPCILocality ,
          MedicareFeeScheduleGPCIBatchID ,
          MedicareFeeScheduleRVUBatchID ,
          AddPercent ,
          AnesthesiaTimeIncrement
        )
SELECT    @PracticeID , -- PracticeID - int
          sfs.Name , -- Name - varchar(128)
          sfs.Notes , -- Notes - varchar(1024)
          sfs.EffectiveStartDate , -- EffectiveStartDate - datetime
          sfs.SourceType , -- SourceType - char(1)
          sfs.SourceFileName , -- SourceFileName - varchar(256)
          sfs.EClaimsNoResponseTrigger , -- EClaimsNoResponseTrigger - int
          sfs.PaperClaimsNoResponseTrigger , -- PaperClaimsNoResponseTrigger - int
          sfs.MedicareFeeScheduleGPCICarrier , -- MedicareFeeScheduleGPCICarrier - int
          sfs.MedicareFeeScheduleGPCILocality , -- MedicareFeeScheduleGPCILocality - int
          sfs.MedicareFeeScheduleGPCIBatchID , -- MedicareFeeScheduleGPCIBatchID - int
          sfs.MedicareFeeScheduleRVUBatchID , -- MedicareFeeScheduleRVUBatchID - int
          sfs.AddPercent , -- AddPercent - decimal
          sfs.AnesthesiaTimeIncrement  -- AnesthesiaTimeIncrement - int
FROM dbo.ContractsAndFees_StandardFeeSchedule sfs 
WHERE sfs.PracticeID = @OldPracticeID AND
		sfs.Name = 'COMMERCIAL EFF 8/1/12'
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into StandardFee ...'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT    newsfs.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          sf.ProcedureCodeID , -- ProcedureCodeID - int
          sf.ModifierID , -- ModifierID - int
          sf.SetFee , -- SetFee - money
          sf.AnesthesiaBaseUnits  -- AnesthesiaBaseUnits - int
FROM dbo.ContractsAndFees_StandardFee sf
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule oldsfs ON
	oldsfs.PracticeID = @OldPracticeID AND
	oldsfs.StandardFeeScheduleID = sf.StandardFeeScheduleID
INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule newsfs ON
	newsfs.PracticeID = @PracticeID AND
	newsfs.NAME = oldsfs.NAME 
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'


PRINT ''
PRINT 'Inserting into ContractRateScheduleLink ...'
INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT    doc.DoctorID , -- ProviderID - int
          (SELECT ServicelocationID FROM dbo.ServiceLocation WHERE PracticeID = @PracticeID) , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.ContractsAndFees_StandardFeeSchedule sfs, dbo.Doctor doc
WHERE sfs.PracticeID = @PracticeID AND
	  doc.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'

COMMIT