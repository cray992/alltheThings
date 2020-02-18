

-----Duplicate current schedules with new IDS
IF EXISTS(SELECT  Max(cafcrs.ContractRateScheduleID)
 FROM ContractsAndFees_ContractRateSchedule AS cafcrs WHERE cafcrs.ContractRateScheduleID IS NOT NULL HAVING Max(cafcrs.ContractRateScheduleID)<100000)
BEGIN


SET IDENTITY_INSERT ContractsAndFees_ContractRateSchedule ON
INSERT INTO ContractsAndFees_ContractRateSchedule
        (ContractRateScheduleID
        ,PracticeID
        ,InsuranceCompanyID
        ,EffectiveStartDate
        ,EffectiveEndDate
        ,SourceType
        ,SourceFileName
        ,EClaimsNoResponseTrigger
        ,PaperClaimsNoResponseTrigger
        ,MedicareFeeScheduleGPCICarrier
        ,MedicareFeeScheduleGPCILocality
        ,MedicareFeeScheduleGPCIBatchID
        ,MedicareFeeScheduleRVUBatchID
        ,AddPercent
        ,AnesthesiaTimeIncrement
        ,Capitated
        )

SELECT ContractRateScheduleID+100000
,       cafcrs.PracticeID
,       cafcrs.InsuranceCompanyID
,       cafcrs.EffectiveStartDate
,       cafcrs.EffectiveEndDate
,       cafcrs.SourceType
,       cafcrs.SourceFileName
,       cafcrs.EClaimsNoResponseTrigger
,       cafcrs.PaperClaimsNoResponseTrigger
,       cafcrs.MedicareFeeScheduleGPCICarrier
,       cafcrs.MedicareFeeScheduleGPCILocality
,       cafcrs.MedicareFeeScheduleGPCIBatchID
,       cafcrs.MedicareFeeScheduleRVUBatchID
,       cafcrs.AddPercent
,       cafcrs.AnesthesiaTimeIncrement
,       cafcrs.Capitated
FROM ContractsAndFees_ContractRateSchedule AS cafcrs
SET IDENTITY_INSERT ContractsAndFees_ContractRateSchedule OFF


UPDATE ContractsAndFees_ContractRate
SET ContractRateScheduleID=ContractRateScheduleID+100000

UPDATE ContractsAndFees_ContractRateScheduleLink
SET ContractRateScheduleID=ContractRateScheduleID+100000

-------Remove old records 

DELETE FROM ContractsAndFees_ContractRateSchedule
WHERE ContractsAndFees_ContractRateSchedule.ContractRateScheduleID<100000

END

