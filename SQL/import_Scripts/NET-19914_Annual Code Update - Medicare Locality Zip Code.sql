USE superbill_shared
GO
BEGIN TRAN 

SELECT *FROM dbo.MedicareFeeScheduleZipGPCILink WHERE dbo.MedicareFeeScheduleZipGPCILink.MedicareFeeScheduleZipGPCILinkBatchID=8

PRINT''
PRINT'Insert into Zip Batch...'
INSERT INTO dbo.MedicareFeeScheduleZipGPCILinkBatch
(
    EffectiveStart
)
VALUES
(
'2018-01-01 00:00:00.000' -- EffectiveStart - datetime
    )

PRINT''
PRINT'Insert into Zip...'
INSERT INTO dbo.MedicareFeeScheduleZipGPCILink
(
    MedicareFeeScheduleZipGPCILinkBatchID,
    ZipCode,
    Carrier,
    Locality
)
SELECT DISTINCT
    8,  -- MedicareFeeScheduleZipGPCILinkBatchID - int
    z.Zip_Code, -- ZipCode - char(5)
    z.carrier,  -- Carrier - int
    z.locality   -- Locality - int
FROM medicare_zip2018$ z

--rollback
--commit

--SELECT * FROM dbo.MedicareFeeScheduleZipGPCILink WHERE MedicareFeeScheduleZipGPCILinkBatchID=7
--SELECT * FROM dbo.MedicareFeeScheduleZipGPCILinkBatch

--UPDATE a SET 
--a.EffectiveStart='2017-12-01 00:00:00.000'
----SELECT * 
--FROM dbo.MedicareFeeScheduleZipGPCILinkBatch a 
--WHERE a.MedicareFeeScheduleZipGPCILinkBatchID=7
