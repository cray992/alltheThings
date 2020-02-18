


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContractToDoctor_Contract]') AND parent_object_id = OBJECT_ID(N'[dbo].[obs_ContractToDoctor]'))
ALTER TABLE [dbo].[obs_ContractToDoctor] DROP CONSTRAINT [FK_ContractToDoctor_Contract]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContractToInsurancePlan_Contract]') AND parent_object_id = OBJECT_ID(N'[dbo].[obs_ContractToInsurancePlan]'))
ALTER TABLE [dbo].[obs_ContractToInsurancePlan] DROP CONSTRAINT [FK_ContractToInsurancePlan_Contract]
GO


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ContractToServiceLocation_Contract]') AND parent_object_id = OBJECT_ID(N'[dbo].[obs_ContractToServiceLocation]'))
ALTER TABLE [dbo].[obs_ContractToServiceLocation] DROP CONSTRAINT [FK_ContractToServiceLocation_Contract]
GO






IF EXISTS (SELECT * FROM sys.tables WHERE name='DoctorHistoryObsolete') Begin Drop Table DoctorHistoryObsolete End
IF EXISTS (SELECT * FROM sys.tables WHERE name='obs_Contract') Begin Drop Table obs_Contract End
IF EXISTS (SELECT * FROM sys.tables WHERE name='obs_ContractFeeSchedule') Begin Drop Table obs_ContractFeeSchedule End
IF EXISTS (SELECT * FROM sys.tables WHERE name='obs_ContractFeeSchedule_deletes') Begin Drop Table obs_ContractFeeSchedule_deletes End
IF EXISTS (SELECT * FROM sys.tables WHERE name='obs_ContractToDoctor') Begin Drop Table obs_ContractToDoctor End
IF EXISTS (SELECT * FROM sys.tables WHERE name='obs_ContractToInsurancePlan') Begin Drop Table obs_ContractToInsurancePlan End
IF EXISTS (SELECT * FROM sys.tables WHERE name='obs_ContractToServiceLocation') Begin Drop Table obs_ContractToServiceLocation End
IF EXISTS (SELECT * FROM sys.tables WHERE name='PracticeHistoryObsolete') Begin Drop Table PracticeHistoryObsolete End