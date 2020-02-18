IF NOT EXISTS(SELECT *
FROM ContractsAndFees_ContractRateSchedule AS cafcrs)


DBCC CHECKIDENT(ContractsAndFees_ContractRateSchedule,RESEED,100000)

