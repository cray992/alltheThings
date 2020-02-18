--USE superbill_14369_dev
USE superbill_14369_prod
GO




PRINT''
PRINT'Inserting into ContractFees ...'
INSERT INTO dbo.ContractsAndFees_ContractRateSchedule
        ( PracticeID ,
          InsuranceCompanyID ,
          EffectiveStartDate ,
          EffectiveEndDate ,
          SourceType ,
          SourceFileName ,
          EClaimsNoResponseTrigger ,
          PaperClaimsNoResponseTrigger ,
          AddPercent ,
          AnesthesiaTimeIncrement,
          Capitated
        )
VALUES  ( 1 , -- PracticeID - int
          32 , -- InsuranceCompanyID - int
          '2013-01-01 07:00:00' , -- EffectiveStartDate - datetime
          DATEADD(yy, 1, '2013-01-01 07:00:00') , -- EffectiveEndDate - datetime
          'F' , -- SourceType - char(1)
          'Import File' , -- SourceFileName - varchar(256)
          45 , -- EClaimsNoResponseTrigger - int
          45 , -- PaperClaimsNoResponseTrigger - int
          0 , -- AddPercent - decimal
          15 ,  -- AnesthesiaTimeIncrement - int
          0
        )
PRINT CAST(@@ROWCOUNt AS VARCHAR) + ' record'


PRINT''
PRINT'Inserting into Contract Rate ....' 
INSERT INTO dbo.ContractsAndFees_ContractRate
        ( ContractRateScheduleID ,
          ProcedureCodeID ,
          ModifierID ,
          SetFee ,
          AnesthesiaBaseUnits
        )
SELECT    crs.ContractRateScheduleID , -- ContractRateScheduleID - int
          pcd.ProcedureCodeDictionaryID , -- ProcedureCodeID - int
          pm.ProcedureModifierID , -- ModifierID - int
          iss.standardfee , -- SetFee - money
          0 
FROM dbo.[_import_1_1_InsuranceSpecificSchedule] iss
INNER JOIN dbo.ContractsAndFees_ContractRateSchedule crs ON
	crs.InsuranceCompanyID = iss.insurancecompanyid AND
	crs.SourceFileName = 'Import File'
INNER JOIN dbo.ProcedureCodeDictionary pcd ON
	iss.cpt = pcd.ProcedureCode
LEFT JOIN dbo.ProcedureModifier pm ON
	iss.modifier = pm.ProcedureModifierCode
PRINT CAST(@@ROWCOUNt AS VARCHAR) + ' records inserted'




PRINT''
PRINT'Inserting into Contract Rate Schedule Link ...'
INSERT INTO dbo.ContractsAndFees_ContractRateScheduleLink
        ( ProviderID ,
          LocationID ,
          ContractRateScheduleID
        )
SELECT    doc.DoctorID , -- ProviderID - int
          sl.ServiceLocationID , -- LocationID - int
          crs.ContractRateScheduleID  -- ContractRateScheduleID - int
FROM dbo.Doctor doc, dbo.ServiceLocation sl, dbo.ContractsAndFees_ContractRateSchedule crs
WHERE doc.ActiveDoctor = 1 AND
	doc.PracticeID = 1 AND
	doc.[External] = 0 AND
	sl.PracticeID = 1 AND
	crs.PracticeID = 1 AND
	crs.SourceFileName = 'Import File'
PRINT CAST(@@ROWCOUNt AS VARCHAR) + ' records inserted'