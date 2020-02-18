
USE superbill_shared
GO

BEGIN TRAN 
INSERT INTO dbo.MedicareFeeScheduleGPCIBatch
(
    EffectiveStart
)
VALUES
(
'2018-01-01 00:00:00.000' -- EffectiveStart - datetime
    )
	
BEGIN TRAN 
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
    9,   -- MedicareFeeScheduleGPCIBatchID - int
	medicare_administrative_contractor,   -- Carrier - int
    mgpci.Locality_number,   -- Locality - int
    Locality_Name,  -- LocalityName - varchar(128)
    pw_gpci, -- WorkGPCI - float
    pe_gpci, -- PracticeExpenseGPCI - float
    mp_gpci  -- MalpracticeExpenseGPCI - float
    
	FROM medicare_gpci2018$	mgpci

--commit
--SELECT * FROM dbo.MedicareFeeScheduleGPCI WHERE MedicareFeeScheduleGPCIBatchID=9
--SELECT * FROM dbo.MedicareFeeScheduleGPCIBatch
--SELECT * FROM dbo.MedicareFeeScheduleGPCI
--SELECT * FROM medicare_gpci2018$
UPDATE a SET 
a.EffectiveStart='2018-01-01 00:00:00.000'
--SELECT * 
FROM dbo.MedicareFeeScheduleGPCIBatch a 
WHERE a.MedicareFeeScheduleGPCIBatchID=9
SELECT * FROM dbo.MedicareFeeScheduleGPCI a
WHERE a.MedicareFeeScheduleGPCIBatchID=9

--commit

