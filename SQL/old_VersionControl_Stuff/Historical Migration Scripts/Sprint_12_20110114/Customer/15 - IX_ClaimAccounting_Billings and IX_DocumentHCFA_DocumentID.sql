IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting_Billings]') AND name = N'IX_ClaimAccounting_Billings_ClaimTransactionID_INC_ClaimID_PostingDate')
	DROP INDEX [IX_ClaimAccounting_Billings_ClaimTransactionID_INC_ClaimID_PostingDate] ON [dbo].[ClaimAccounting_Billings] WITH ( ONLINE = OFF )
GO
	
CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_Billings_ClaimTransactionID_INC_ClaimID_PostingDate] ON [dbo].[ClaimAccounting_Billings] 
(
	[ClaimTransactionID] ASC
)
INCLUDE ([ClaimID], [PostingDate])
GO


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Document_HCFA]') AND name = N'IX_Document_HCFA_DocumentID')
	DROP INDEX [IX_Document_HCFA_DocumentID] ON [dbo].[Document_HCFA] WITH ( ONLINE = OFF )
GO
	
CREATE NONCLUSTERED INDEX [IX_Document_HCFA_DocumentID] ON [dbo].[Document_HCFA] 
(
	[DocumentID] ASC
)
GO