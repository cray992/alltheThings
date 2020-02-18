IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimTransaction]') AND name = N'IX_ClaimTransaction_Practice_CreatedDate_ClaimID')
	DROP INDEX [IX_ClaimTransaction_Practice_CreatedDate_ClaimID] ON [dbo].[ClaimTransaction] WITH ( ONLINE = OFF )
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimTransaction]') AND name = N'IX_ClaimTransaction_PatientID_ClaimTransactionTypeCode')
	DROP INDEX [IX_ClaimTransaction_PatientID_ClaimTransactionTypeCode] ON [dbo].[ClaimTransaction] WITH ( ONLINE = OFF )
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting]') AND name = N'IX_ClaimAccounting_EncounterProcedureID')
	DROP INDEX [IX_ClaimAccounting_EncounterProcedureID] ON [dbo].[ClaimAccounting] WITH ( ONLINE = OFF )
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting]') AND name = N'IX_ClaimAccounting_ProviderID')
	DROP INDEX [IX_ClaimAccounting_ProviderID] ON [dbo].[ClaimAccounting] WITH ( ONLINE = OFF )	
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Claim]') AND name = N'IX_Claim_ClearinghouseProcessingStatus')
	DROP INDEX [IX_Claim_ClearinghouseProcessingStatus] ON [dbo].[Claim] WITH ( ONLINE = OFF )	
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Claim]') AND name = N'IX_Claim_ClearinghouseTrackingNumber')
	DROP INDEX [IX_Claim_ClearinghouseTrackingNumber] ON [dbo].[Claim] WITH ( ONLINE = OFF )	
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Claim]') AND name = N'IX_Claim_CurrentPayerProcessingStatusTypeCode')
	DROP INDEX [IX_Claim_CurrentPayerProcessingStatusTypeCode] ON [dbo].[Claim] WITH ( ONLINE = OFF )	

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Claim]') AND name = N'IX_Claim_PayerProcessingStatus')
	DROP INDEX [IX_Claim_PayerProcessingStatus] ON [dbo].[Claim] WITH ( ONLINE = OFF )	
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Claim]') AND name = N'IX_Claim_PayerTrackingNumber')
	DROP INDEX [IX_Claim_PayerTrackingNumber] ON [dbo].[Claim] WITH ( ONLINE = OFF )	

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Claim]') AND name = N'IX_Claim_CreatedDate')
	DROP INDEX [IX_Claim_CreatedDate] ON [dbo].[Claim] WITH ( ONLINE = OFF )	
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Claim]') AND name = N'IX_Claim_NonElectronicOverrideFlag')
	DROP INDEX [IX_Claim_NonElectronicOverrideFlag] ON [dbo].[Claim] WITH ( ONLINE = OFF )	
	
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Assignments]') AND name = N'IX_ClaimAccounting_Assignments_Status')
	DROP INDEX [IX_ClaimAccounting_Assignments_Status] ON [dbo].[ClaimAccounting_Assignments] WITH ( ONLINE = OFF )	

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Assignments]') AND name = N'IX_ClaimAccounting_Assignments_LastAssignment')
	DROP INDEX [IX_ClaimAccounting_Assignments_LastAssignment] ON [dbo].[ClaimAccounting_Assignments] WITH ( ONLINE = OFF )	

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Billings]') AND name = N'IX_ClaimAccounting_Billings_Status')
	DROP INDEX [IX_ClaimAccounting_Billings_Status] ON [dbo].[ClaimAccounting_Billings] WITH ( ONLINE = OFF )	

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[BillClaim]') AND name = N'IX_BillClaim_ClaimTransactionID')
	DROP INDEX [IX_BillClaim_ClaimTransactionID] ON [dbo].[BillClaim] WITH ( ONLINE = OFF )	
