IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Appointment]') AND name = N'IX_Appointment_RecurrenceInfo')
	DROP INDEX [IX_Appointment_RecurrenceInfo] ON [dbo].[Appointment] WITH ( ONLINE = OFF )	

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ContractFeeSchedule]') AND name = N'IX_ContractFeeSchedule_Modifier')
	DROP INDEX [IX_ContractFeeSchedule_Modifier] ON [dbo].[ContractFeeSchedule] WITH ( ONLINE = OFF )	

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Payment]') AND name = N'IX_Payment_PaymentNumber')
	DROP INDEX [IX_Payment_PaymentNumber] ON [dbo].[Payment] WITH ( ONLINE = OFF )	

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DMSDocument]') AND name = N'IX_DMSDocument_DocumentLabelTypeID')
	DROP INDEX [IX_DMSDocument_DocumentLabelTypeID] ON [dbo].[DMSDocument] WITH ( ONLINE = OFF )	
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DMSDocument]') AND name = N'IX_DMSDocument_DocumentName')
	DROP INDEX [IX_DMSDocument_DocumentName] ON [dbo].[DMSDocument] WITH ( ONLINE = OFF )	
