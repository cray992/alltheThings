if exists (select * from dbo.sysindexes where name=('IX_ClaimAccounting_PracticeID_ClaimID_ClaimTransactionCode'))
RETURN

ELSE 

/****** Object:  Index [IX_PracticeID_ClaimID_ClaimTransactionCode]    Script Date: 04/04/2012 13:57:15 ******/
CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_PracticeID_ClaimID_ClaimTransactionCode] ON [dbo].[ClaimAccounting] 
(
	[PracticeID] ASC,
	[ClaimID] ASC,
	[ClaimTransactionTypeCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO





