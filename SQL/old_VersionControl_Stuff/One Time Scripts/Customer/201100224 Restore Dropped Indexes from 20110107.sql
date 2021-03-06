/*
Run this script on:

        kdev-db03.superbill_2736_dev_indexes    -  This database will be modified

to synchronize it with:

        kdev-db03.superbill_2736_prod_indexes

You are recommended to back up your database before running this script

Script created by SQL Compare version 8.50.10 from Red Gate Software Ltd at 2/24/2011 5:11:22 PM

*/

RETURN - insanity check


SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
PRINT N'Refreshing [dbo].[SyncroDataProvider_vInsurancePaymentDate]'
GO
EXEC sp_refreshview N'[dbo].[SyncroDataProvider_vInsurancePaymentDate]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Appointment_RecurrenceInfo] on [dbo].[Appointment]'
GO
CREATE NONCLUSTERED INDEX [IX_Appointment_RecurrenceInfo] ON [dbo].[Appointment] ([Recurrence], [RecurrenceStartDate], [RangeEndDate], [RangeType])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_BillClaim_ClaimTransactionID] on [dbo].[BillClaim]'
GO
CREATE NONCLUSTERED INDEX [IX_BillClaim_ClaimTransactionID] ON [dbo].[BillClaim] ([ClaimTransactionID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Claim_ClearinghouseProcessingStatus] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_ClearinghouseProcessingStatus] ON [dbo].[Claim] ([ClearinghouseProcessingStatus])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Claim_ClearinghouseTrackingNumber] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_ClearinghouseTrackingNumber] ON [dbo].[Claim] ([ClearinghouseTrackingNumber])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Claim_CreatedDate] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_CreatedDate] ON [dbo].[Claim] ([CreatedDate])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Claim_CurrentPayerProcessingStatusTypeCode] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_CurrentPayerProcessingStatusTypeCode] ON [dbo].[Claim] ([CurrentPayerProcessingStatusTypeCode])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Claim_NonElectronicOverrideFlag] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_NonElectronicOverrideFlag] ON [dbo].[Claim] ([NonElectronicOverrideFlag])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Claim_PayerProcessingStatus] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_PayerProcessingStatus] ON [dbo].[Claim] ([PayerProcessingStatus])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Claim_PayerTrackingNumber] on [dbo].[Claim]'
GO
CREATE NONCLUSTERED INDEX [IX_Claim_PayerTrackingNumber] ON [dbo].[Claim] ([PayerTrackingNumber])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_ClaimAccounting_EncounterProcedureID] on [dbo].[ClaimAccounting]'
GO
CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_EncounterProcedureID] ON [dbo].[ClaimAccounting] ([EncounterProcedureID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_ClaimAccounting_ProviderID] on [dbo].[ClaimAccounting]'
GO
CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_ProviderID] ON [dbo].[ClaimAccounting] ([ProviderID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_ClaimAccounting_Assignments_LastAssignment] on [dbo].[ClaimAccounting_Assignments]'
GO
CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_Assignments_LastAssignment] ON [dbo].[ClaimAccounting_Assignments] ([LastAssignment])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_ClaimAccounting_Assignments_Status] on [dbo].[ClaimAccounting_Assignments]'
GO
CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_Assignments_Status] ON [dbo].[ClaimAccounting_Assignments] ([Status])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_ClaimAccounting_Billings_Status] on [dbo].[ClaimAccounting_Billings]'
GO
CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_Billings_Status] ON [dbo].[ClaimAccounting_Billings] ([Status])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_ClaimTransaction_Practice_CreatedDate_ClaimID] on [dbo].[ClaimTransaction]'
GO
CREATE NONCLUSTERED INDEX [IX_ClaimTransaction_Practice_CreatedDate_ClaimID] ON [dbo].[ClaimTransaction] ([PracticeID], [CreatedDate], [ClaimID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_ContractFeeSchedule_Modifier] on [dbo].[ContractFeeSchedule]'
GO
CREATE NONCLUSTERED INDEX [IX_ContractFeeSchedule_Modifier] ON [dbo].[ContractFeeSchedule] ([Modifier])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_DMSDocument_DocumentLabelTypeID] on [dbo].[DMSDocument]'
GO
CREATE NONCLUSTERED INDEX [IX_DMSDocument_DocumentLabelTypeID] ON [dbo].[DMSDocument] ([DocumentLabelTypeID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_DMSDocument_DocumentName] on [dbo].[DMSDocument]'
GO
CREATE NONCLUSTERED INDEX [IX_DMSDocument_DocumentName] ON [dbo].[DMSDocument] ([DocumentName])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Patient_AddressLine1] on [dbo].[Patient]'
GO
CREATE NONCLUSTERED INDEX [IX_Patient_AddressLine1] ON [dbo].[Patient] ([AddressLine1])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Patient_AddressLine2] on [dbo].[Patient]'
GO
CREATE NONCLUSTERED INDEX [IX_Patient_AddressLine2] ON [dbo].[Patient] ([AddressLine2])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Patient_City] on [dbo].[Patient]'
GO
CREATE NONCLUSTERED INDEX [IX_Patient_City] ON [dbo].[Patient] ([City])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Patient_HomePhone] on [dbo].[Patient]'
GO
CREATE NONCLUSTERED INDEX [IX_Patient_HomePhone] ON [dbo].[Patient] ([HomePhone])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Patient_State] on [dbo].[Patient]'
GO
CREATE NONCLUSTERED INDEX [IX_Patient_State] ON [dbo].[Patient] ([State])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Patient_ZipCode] on [dbo].[Patient]'
GO
CREATE NONCLUSTERED INDEX [IX_Patient_ZipCode] ON [dbo].[Patient] ([ZipCode])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [IX_Payment_PaymentNumber] on [dbo].[Payment]'
GO
CREATE NONCLUSTERED INDEX [IX_Payment_PaymentNumber] ON [dbo].[Payment] ([PaymentNumber])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE #tmpErrors
GO
