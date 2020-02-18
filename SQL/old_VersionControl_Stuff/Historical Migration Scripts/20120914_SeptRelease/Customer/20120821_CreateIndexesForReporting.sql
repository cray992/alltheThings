IF EXISTS(SELECT *
FROM Sys.indexes AS i WHERE name='IX_ClaimTransaction_ClaimTransactionTYPECode_PostingDate_ClaimResponseStatusID_PracticeID')
RETURN
CREATE NONCLUSTERED INDEX IX_ClaimTransaction_ClaimTransactionTYPECode_PostingDate_ClaimResponseStatusID_PracticeID
ON [dbo].[ClaimTransaction] ([ClaimTransactionTypeCode],[PostingDate],[ClaimResponseStatusID])
INCLUDE ([PracticeID])



/****** Object:  Index [IX_ClaimAccounting_PracticeID_ClaimTransactionTypeCode_INC_ClaimID_Amount_PostingDate_PaymentId]    Script Date: 08/29/2012 08:57:56 ******/
IF EXISTS(SELECT * FROM sys.indexes WHERE name='IX_ClaimAccounting_PracticeID_ClaimTransactionTypeCode_INC_ClaimID_Amount_PostingDate_PaymentId')
DROP INDEX [IX_ClaimAccounting_PracticeID_ClaimTransactionTypeCode_INC_ClaimID_Amount_PostingDate_PaymentId] ON [dbo].[ClaimAccounting] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_PracticeID_ClaimTransactionTypeCode_INC_ClaimID_Amount_PostingDate_PaymentId] ON [dbo].[ClaimAccounting] 
(
	[PracticeID] ASC,
	[ClaimTransactionTypeCode] ASC
)
INCLUDE ( [Amount],
[PostingDate],
[PaymentID],
[ClaimID]) WITH (STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

