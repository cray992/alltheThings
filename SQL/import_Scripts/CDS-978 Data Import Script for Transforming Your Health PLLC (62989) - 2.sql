USE superbill_62989_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 2
SET @SourcePracticeID = 1
SET @VendorImportID = 1

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
          KareoProcedureCodeDictionaryID ,
          KareoLastModifiedDate ,
          Active ,
          OfficialName ,
          LocalName ,
          OfficialDescription ,
          BillableCode ,
          DefaultUnits ,
          NDC ,
          DrugName ,
          ProcedureCodeCategoryID ,
          DefaultRevenueCodeID ,
          NOC ,
          CustomCode
        )
SELECT DISTINCT
		  i.ProcedureCode , -- ProcedureCode - varchar(16)
          GETDATE(), -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() ,-- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          i.TypeOfServiceCode , -- TypeOfServiceCode - char(1)
          0 , -- KareoProcedureCodeDictionaryID - int
          NULL , -- KareoLastModifiedDate - datetime
          i.Active , -- Active - bit
          i.OfficialName , -- OfficialName - varchar(300)
          i.LocalName , -- LocalName - varchar(100)
          i.OfficialDescription , -- OfficialDescription - varchar(1200)
          i.BillableCode , -- BillableCode - varchar(128)
          i.DefaultUnits , -- DefaultUnits - decimal(19, 4)
          i.NDC , -- NDC - varchar(300)
          i.DrugName , -- DrugName - varchar(300)
          NULL, -- ProcedureCodeCategoryID - int
          i.DefaultRevenueCodeID , -- DefaultRevenueCodeID - int
          i.NOC , -- NOC - int
          i.CustomCode  -- CustomCode - bit
FROM dbo._import_1_2_ProcedureCodeDictionary i 
	LEFT JOIN dbo.ProcedureCodeDictionary pcd ON 
		i.ProcedureCode = pcd.ProcedureCode
	INNER JOIN dbo._import_1_2_ContractsAndFees_StandardFee isf ON 
		i.ProcedureCodeDictionaryID = isf.ProcedureCodeID
WHERE pcd.ProcedureCodeDictionaryID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'

SET IDENTITY_INSERT dbo.[ContractsAndFees_StandardFeeSchedule] ON
PRINT ''
PRINT 'Inserting Into Standard Fee Schedule...'
INSERT INTO dbo.ContractsAndFees_StandardFeeSchedule
        ( StandardFeeScheduleID ,
		  PracticeID ,
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
SELECT 
		  5 , 
		  @TargetPracticeID , -- PracticeID - int
          i.Name , -- Name - varchar(128)
          i.Notes , -- Notes - varchar(1024)
          i.EffectiveStartDate , -- EffectiveStartDate - datetime
          i.SourceType , -- SourceType - char(1)
          i.SourceFileName , -- SourceFileName - varchar(256)
          i.EClaimsNoResponseTrigger , -- EClaimsNoResponseTrigger - int
          i.PaperClaimsNoResponseTrigger , -- PaperClaimsNoResponseTrigger - int
          i.MedicareFeeScheduleGPCICarrier , -- MedicareFeeScheduleGPCICarrier - int
          i.MedicareFeeScheduleGPCILocality , -- MedicareFeeScheduleGPCILocality - int
          i.MedicareFeeScheduleGPCIBatchID , -- MedicareFeeScheduleGPCIBatchID - int
          i.MedicareFeeScheduleRVUBatchID , -- MedicareFeeScheduleRVUBatchID - int
          i.AddPercent , -- AddPercent - decimal
          i.AnesthesiaTimeIncrement  -- AnesthesiaTimeIncrement - int
FROM dbo.[_import_1_2_ContractsAndFees_StandardFeeSchedule] i
WHERE i.PracticeID = @SourcePracticeID AND i.StandardFeeScheduleID = 5
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	
SET IDENTITY_INSERT dbo.[ContractsAndFees_StandardFeeSchedule] OFF

PRINT ''
PRINT 'Inserting Into Standard Fee...'
INSERT INTO dbo.ContractsAndFees_StandardFee
        ( StandardFeeScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT DISTINCT
	      sf.StandardFeeScheduleID , -- StandardFeeScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          pm.ProcedureModifierID , -- ModifierID - int
          i.SetFee , -- SetFee - money
          i.AnesthesiaBaseUnits  -- AnesthesiaBaseUnits - int
FROM dbo.[_import_1_2_ContractsAndFees_StandardFee] i
	INNER JOIN dbo.ContractsAndFees_StandardFeeSchedule sf ON
		sf.StandardFeeScheduleID = 5
	INNER JOIN dbo._import_1_2_ProcedureCodeDictionary ipcd ON 
		i.ProcedureCodeID = ipcd.ProcedureCodeDictionaryID
	INNER JOIN dbo.ProcedureCodeDictionary pcd ON
		ipcd.procedurecode = pcd.ProcedureCode
	LEFT JOIN  dbo.[_import_1_2_ProcedureModifier] ipm ON
		i.ModifierID = ipm.ProcedureModifierID
	LEFT JOIN dbo.ProcedureModifier pm ON
		ipm.proceduremodifiercode = pm.ProcedureModifierCode
WHERE pcd.ProcedureCodeDictionaryID IS NOT NULL AND i.StandardFeeScheduleID = 5 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'	

INSERT INTO dbo.ContractsAndFees_StandardFeeScheduleLink
        ( ProviderID ,
          LocationID ,
          StandardFeeScheduleID
        )
SELECT   
		  doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          sfs.StandardFeeScheduleID  -- StandardFeeScheduleID - int
FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_StandardFeeSchedule sfs
WHERE doc.PracticeID = @TargetPracticeID AND
	  doc.[External] = 0 AND
      sl.PracticeID = @TargetPracticeID AND
	  sfs.StandardFeeScheduleID = 5 AND
      sfs.PracticeID = @TargetPracticeID


--ROLLBACK
--COMMIT