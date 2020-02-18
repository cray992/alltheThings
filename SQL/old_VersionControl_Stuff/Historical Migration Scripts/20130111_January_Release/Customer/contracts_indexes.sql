IF NOT EXISTS(Select * from sys.Indexes where name='IX_ContractsAndFees_StandardFeeSchedule_PracticeID')
	Create Nonclustered Index IX_ContractsAndFees_StandardFeeSchedule_PracticeID ON ContractsAndFees_StandardFeeSchedule(PracticeID)

GO

If NOT Exists(Select * from sys.indexes where name='IX_ContractsAndFees_StandardFee_StandardFeeScheduleID') 
	Create Nonclustered Index IX_ContractsAndFees_StandardFee_StandardFeeScheduleID ON ContractsAndFees_StandardFee(StandardFeeScheduleID)

GO

If NOT Exists(Select * from sys.indexes where name='IX_ContractsAndFees_StandardFee_StandardFeeScheduleID_ProcedureCodeID_Modifier') 
	Create Nonclustered Index IX_ContractsAndFees_StandardFee_StandardFeeScheduleID_ProcedureCodeID_Modifier ON ContractsAndFees_StandardFee(StandardFeeScheduleID, ProcedureCodeID, ModifierID)

GO

 IF NOT Exists(Select * from sys.indexes where name='IX_ContractsAndFees_StandardFeeScheduleLink_StandardFeeScheduleID')
    CREATE NONCLUSTERED INDEX [IX_ContractsAndFees_StandardFeeScheduleLink_StandardFeeScheduleID] ON [dbo].[ContractsAndFees_StandardFeeScheduleLink] 
	(
		[StandardFeeScheduleID] ASC
	)
	INCLUDE ( [ProviderID],
	[LocationID]) ON [PRIMARY]

GO

IF NOT Exists(Select * from sys.indexes where name='IX_ContractsAndFees_ContractRateSchedule_PracticeID')
    Create Nonclustered Index IX_ContractsAndFees_ContractRateSchedule_PracticeID ON ContractsAndFees_ContractRateSchedule(PracticeID)

GO

If NOT Exists(Select * from sys.indexes where name='IX_ContractsAndFees_ContractRate_ContractRateScheduleID') 
	Create Nonclustered Index IX_ContractsAndFees_ContractRate_ContractRateScheduleID ON ContractsAndFees_ContractRate(ContractRateScheduleID)

GO

If NOT Exists(Select * from sys.indexes where name='IX_ContractsAndFees_ContractRate_ContractRateScheduleID_ProcedureCodeID_Modifier') 
	Create Nonclustered Index IX_ContractsAndFees_ContractRate_ContractRateScheduleID_ProcedureCodeID_Modifier ON ContractsAndFees_ContractRate(ContractRateScheduleID, ProcedureCodeID, ModifierID)

GO

 IF NOT Exists(Select * from sys.indexes where name='IX_ContractsAndFees_ContractRateScheduleLink_ContractRateScheduleID')
    CREATE NONCLUSTERED INDEX [IX_ContractsAndFees_ContractRateScheduleLink_ContractRateScheduleID] ON [dbo].[ContractsAndFees_ContractRateScheduleLink] 
	(
		[ContractRateScheduleID] ASC
	)
	INCLUDE ( [ProviderID],
	[LocationID]) ON [PRIMARY]

GO