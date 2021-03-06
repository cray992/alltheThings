-- Used by [PaymentDataProvider_GetClaimTransactionsForClaim] for associating ERAs with EDI ClaimTransactions.
CREATE NONCLUSTERED INDEX [IX_ClearinghouseReponse_PracticeID_ResponseType_FileReceiveDate] ON [dbo].[ClearinghouseResponse] 
(
	[PracticeID] ASC,
	[ResponseType] ASC,
	[FileReceiveDate] ASC
)