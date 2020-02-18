if exists (select * from dbo.sysindexes where name=('IX_ClaimTransaction_ClaimID_PracticeID_PaymentID'))
RETURN

ELSE 

/****** Object:  Index [IX_ClaimTransaction_ClaimID_PracticeID_PaymentID]    Script Date: 04/04/2012 15:28:14 ******/
CREATE NONCLUSTERED INDEX [IX_ClaimTransaction_ClaimID_PracticeID_PaymentID] ON [dbo].[ClaimTransaction] 
(
	[PracticeID] ASC,
	[ClaimID] ASC,
	[PaymentID] ASC
)
INCLUDE ( [Amount]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

