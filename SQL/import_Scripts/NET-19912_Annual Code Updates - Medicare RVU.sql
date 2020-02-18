--medicare rvu
USE Superbill_Shared
GO

BEGIN TRAN 
INSERT INTO dbo.MedicareFeeScheduleRVUBatch
(
    ConversionFactor,
    BudgetNeutralityAdjustor,
    EffectiveStart
)
VALUES
(   35.9996,      -- ConversionFactor - float
    1,      -- BudgetNeutralityAdjustor - float
    '2018-01-01 00:00:00.000' -- EffectiveStart - datetime
    )

BEGIN TRAN 
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
    8,   -- MedicareFeeScheduleRVUBatchID - int
    mrvu.HCPCS,  -- ProcedureCode - varchar(16)
    mrvu.MOD,  -- Modifier - varchar(16)
    mrvu.work_RVU, -- WorkRVU - float
    mrvu.facitlity_PE_RVU, -- FacilityPracticeExpenseRVU - float
    mrvu.nonfacility_PE_RVU, -- NonFacilityPracticeExpenseRVU - float
    mrvu.malpractice_RVU  -- MalpracticeExpenseRVU - float
FROM dbo.[medicare_rvu$] mrvu

SELECT * 
FROM dbo.MedicareFeeScheduleRVUBatch a 
WHERE a.MedicareFeeScheduleRVUBatchID=8
SELECT * FROM dbo.MedicareFeeScheduleRVU a
WHERE a.MedicareFeeScheduleRVUBatchID=8



--COMMIT

--UPDATE a SET 
--a.EffectiveStart='2017-12-01 00:00:00.000'
----SELECT * 
--FROM dbo.MedicareFeeScheduleRVUBatch a 
--WHERE a.MedicareFeeScheduleRVUBatchID=8

--SELECT * FROM dbo.MedicareFeeScheduleRVUBatch
--SELECT * FROM dbo.MedicareFeeScheduleRVUBatch mfsrvub
--SELECT * FROM dbo.MedicareFeeScheduleRVU

--ROLLBACK 
--commit
