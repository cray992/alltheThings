CREATE NONCLUSTERED INDEX IX_ContractFeeSchedule_ProcedureCodeDictionaryID
ON ContractFeeSchedule (ProcedureCodeDictionaryID)

CREATE NONCLUSTERED INDEX IX_ContractFeeSchedule_Modifier
ON ContractFeeSchedule (Modifier)

ALTER TABLE ContractFeeSchedule ADD CONSTRAINT PK_ContractFeeSchedule PRIMARY KEY
NONCLUSTERED (ContractFeeScheduleID)

CREATE CLUSTERED INDEX CI_ContractFeeSchedule_ContractID_ContractFeeScheduleID
ON ContractFeeSchedule(ContractID, ContractFeeScheduleID)
