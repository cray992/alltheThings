DROP INDEX [IX_ClaimAccounting_PaymentID] ON [dbo].[ClaimAccounting] WITH ( ONLINE = OFF )


GO
CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_PaymentID] ON [dbo].[ClaimAccounting] 
(
	[PaymentID] ASC,
	[ClaimTransactionTypeCode] ASC
)
INCLUDE ( [Amount]) 


