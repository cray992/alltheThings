USE superbill_29698_dev
--USE superbill_29698_prod
GO
 
SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1 -- Vendor import record created through import tool
 
PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

--DELETE FROM dbo.ContractsAndFees_ContractRateScheduleLink
--DELETE FROM dbo.ContractsAndFees_ContractRate
--DELETE FROM dbo.ContractsAndFees_ContractRateSchedule

--SELECT * FROM dbo.ContractsAndFees_ContractRate
--SELECT * FROM dbo.ContractsAndFees_ContractRateSchedule
--SELECT * FROM dbo.ContractsAndFees_ContractRateScheduleLink


PRINT ''
PRINT 'Inserting Into ContractRateScedule... '	
	--ContractRateSchedule
	INSERT INTO dbo.ContractsAndFees_ContractRateSchedule
        ( PracticeID ,
          InsuranceCompanyID ,
          EffectiveStartDate ,
          EffectiveEndDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
          MedicareFeeScheduleGPCICarrier ,
          MedicareFeeScheduleGPCILocality ,
          MedicareFeeScheduleGPCIBatchID ,
          MedicareFeeScheduleRVUBatchID ,
          AddPercent ,
          AnesthesiaTimeIncrement ,
          Capitated
        )
	SELECT DISTINCT
		  @PracticeID , -- PracticeID - int
          InsuranceCompanyID , -- InsuranceCompanyID - int
          GETDATE() , -- EffectiveStartDate - datetime
          DATEADD(dd, -1, DATEADD(yy, 1, GETDATE())) , -- EffectiveEndDate - datetime
          'f' , -- SourceType - char(1)
          'Import file' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          NULL , -- MedicareFeeScheduleGPCICarrier - int
          NULL , -- MedicareFeeScheduleGPCILocality - int
          NULL , -- MedicareFeeScheduleGPCIBatchID - int
          NULL , -- MedicareFeeScheduleRVUBatchID - int
          0 , -- AddPercent - decimal
          15 , -- AnesthesiaTimeIncrement - int
          0  -- Capitated - bit
	FROM dbo.InsuranceCompany
WHERE InsuranceCompanyName = 'Medicare'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted'

PRINT ''
PRINT 'Inserting Into Contract Rate...'
	--ContractRate
	INSERT INTO dbo.ContractsAndFees_ContractRate
        ( ContractRateScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
	SELECT  
		  crs.ContractRateScheduleID , -- ContractRateScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          pm.ProcedureModifierID , -- ModifierID - int
          i.fee , -- SetFee - money
          0  -- AnesthesiaBaseUnits - int
	FROM dbo.[_import_3_1_FeeSchedule] i
	INNER JOIN dbo.InsuranceCompany ic ON 
		ic.InsuranceCompanyName = 'Medicare' AND
		ic.CreatedPracticeID = @PracticeID
	INNER JOIN dbo.ContractsAndFees_ContractRateSchedule crs ON
		crs.InsuranceCompanyID = ic.InsuranceCompanyID
	INNER JOIN dbo.[ProcedureCodeDictionary] pcd ON
		i.[procedure] = pcd.ProcedureCode 
	LEFT JOIN dbo.ProcedureModifier pm ON
		i.modifier = pm.ProcedureModifierCode
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted'

PRINT ''
PRINT 'Inserting Into Contract Rate Schedule Link...'
	--ContractRateScheduleLink
	INSERT INTO dbo.ContractsAndFees_ContractRateScheduleLink
        ( ProviderID ,
          LocationID ,
          ContractRateScheduleID
        )
	SELECT 
		  doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          crs.ContractRateScheduleId  -- ContractRateScheduleID - int
	FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_ContractRateSchedule crs
	WHERE doc.PracticeID = @PracticeID AND
		doc.[External] = 0 AND 
		sl.PracticeID = @PracticeID AND
		crs.SourceFileName = 'Import file'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + 'records inserted'

--COMMIT 
--ROLLBACK

