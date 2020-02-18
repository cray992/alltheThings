--Indexes for KPI Metrics
IF NOT EXISTS (
   SELECT *
   FROM sysindexes
   WHERE id = (SELECT OBJECT_ID('Payment'))
     AND name = 'ix_Payment_CreatedDate_Include_PaymentAmount'
)
BEGIN
CREATE NONCLUSTERED INDEX [ix_Payment_CreatedDate_Include_PaymentAmount]
ON [dbo].[Payment] ([CreatedDate])
INCLUDE ([PaymentAmount])
END
GO

IF EXISTS (
   SELECT *
   FROM sysindexes
   WHERE id = (SELECT OBJECT_ID('ClaimTransaction'))
     AND name = 'IX_ClaimTransaction_ClaimTransactionTypeCode'
)
BEGIN
/* Object:  Index [IX_ClaimTransaction_ClaimTransactionTypeCode] */
DROP INDEX [IX_ClaimTransaction_ClaimTransactionTypeCode] ON [dbo].[ClaimTransaction] WITH ( ONLINE = OFF )
END
GO

IF NOT EXISTS (
   SELECT *
   FROM sysindexes
   WHERE id = (SELECT OBJECT_ID('ClaimTransaction'))
     AND name = 'IX_ClaimTransaction_ClaimTransactionTypeCode_CreatedDate'
)
BEGIN
CREATE NONCLUSTERED INDEX [IX_ClaimTransaction_ClaimTransactionTypeCode_CreatedDate] ON [dbo].[ClaimTransaction] 
(
	[ClaimTransactionTypeCode] ASC,
	[CreatedDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
END
GO

/* Object:  Index [IX_Encounter_LocationID]  */
IF EXISTS (
   SELECT *
   FROM sysindexes
   WHERE id = (SELECT OBJECT_ID('Encounter'))
     AND name = 'IX_Encounter_LocationID'
)
BEGIN
DROP INDEX [IX_Encounter_LocationID] ON [dbo].[Encounter] WITH ( ONLINE = OFF )
END
GO

IF NOT EXISTS (
   SELECT *
   FROM sysindexes
   WHERE id = (SELECT OBJECT_ID('Encounter'))
     AND name = 'IX_Encounter_LocationID_CreatedDate'
)
BEGIN
CREATE NONCLUSTERED INDEX [IX_Encounter_LocationID_CreatedDate] ON [dbo].[Encounter] 
(
	[LocationID] ASC,
	[CreatedDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
END
GO

IF EXISTS (
   SELECT *
   FROM sysindexes
   WHERE id = (SELECT OBJECT_ID('ClaimAccounting'))
     AND name = 'IX_ClaimAccounting_ClaimTransactionTypeCode'
)
BEGIN
/* Object:  Index [IX_ClaimAccounting_ClaimTransactionTypeCode] */
DROP INDEX [IX_ClaimAccounting_ClaimTransactionTypeCode] ON [dbo].[ClaimAccounting] WITH ( ONLINE = OFF )
END
GO
IF NOT EXISTS (
   SELECT *
   FROM sysindexes
   WHERE id = (SELECT OBJECT_ID('ClaimAccounting'))
     AND name = 'IX_ClaimAccounting_ClaimTransactionTypeCode'
)
BEGIN
CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_ClaimTransactionTypeCode] ON [dbo].[ClaimAccounting] 
(
	[ClaimTransactionTypeCode] ASC
)
INCLUDE ( [ClaimID],
[Amount]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
END
GO

IF EXISTS (
   SELECT *
   FROM sysindexes
   WHERE id = (SELECT OBJECT_ID('ClaimAccounting_Billings'))
     AND name = 'IX_ClaimAccounting_Billings_ClaimID'
)
BEGIN
DROP INDEX [IX_ClaimAccounting_Billings_ClaimID] ON [dbo].[ClaimAccounting_Billings] WITH ( ONLINE = OFF )
END
GO
IF NOT EXISTS (
   SELECT *
   FROM sysindexes
   WHERE id = (SELECT OBJECT_ID('ClaimAccounting_Billings'))
     AND name = 'IX_ClaimAccounting_Billings_ClaimID_PostingDate'
)
BEGIN
/****** Object:  Index [IX_ClaimAccounting_Billings_ClaimID]    Script Date: 11/21/2011 12:41:13 ******/
CREATE NONCLUSTERED INDEX [IX_ClaimAccounting_Billings_ClaimID_PostingDate] ON [dbo].[ClaimAccounting_Billings] 
(
	[ClaimID] ASC,
	[PostingDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]
END
GO