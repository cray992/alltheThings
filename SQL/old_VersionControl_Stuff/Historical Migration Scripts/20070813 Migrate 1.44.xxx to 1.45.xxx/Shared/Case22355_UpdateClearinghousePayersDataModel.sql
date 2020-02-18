/*-----------------------------------------------------------------------------

Case 22355 - Practice/Provider Setup: Automate updates to electronic payer 
connections using MedAvant API  

-----------------------------------------------------------------------------*/

/* Modify ClearinghousePayersList table ... */

ALTER TABLE dbo.ClearinghousePayersList ADD
	AutoUpdateDate datetime NULL
GO

/* Add PayerTransactionSetType table ... */

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayerTransactionSet_PayerTransactionSetTypeID]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayerTransactionSet]'))
ALTER TABLE [dbo].[PayerTransactionSet] DROP CONSTRAINT [FK_PayerTransactionSet_PayerTransactionSetTypeID]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayerTransactionSetType]') AND type in (N'U'))
DROP TABLE [dbo].[PayerTransactionSetType]
GO

CREATE TABLE [dbo].[PayerTransactionSetType](
	[PayerTransactionSetTypeID] [int] NOT NULL,
	[PayerTransactionSetTypeCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PayerTransactionSetTypeName] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SortOrder] [smallint] NULL,
 CONSTRAINT [PK_PayerTransactionSetType] PRIMARY KEY CLUSTERED 
(
	[PayerTransactionSetTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/* Insert known payer transaction types ... */

/* E-claims */
INSERT INTO [dbo].[PayerTransactionSetType] (
	[PayerTransactionSetTypeID],
	[PayerTransactionSetTypeCode],
	[PayerTransactionSetTypeName],
	[SortOrder] )
VALUES (
	1,
	'CLE',
	'E-claims',
	0 )

/* ERA */
INSERT INTO [dbo].[PayerTransactionSetType] (
	[PayerTransactionSetTypeID],
	[PayerTransactionSetTypeCode],
	[PayerTransactionSetTypeName],
	[SortOrder] )
VALUES (
	2,
	'ERA',
	'ERA',
	5 )

/* Eligibility */
INSERT INTO [dbo].[PayerTransactionSetType] (
	[PayerTransactionSetTypeID],
	[PayerTransactionSetTypeCode],
	[PayerTransactionSetTypeName],
	[SortOrder] )
VALUES (
	3,
	'ELI',
	'Eligibility',
	10 )

/* Add PayerTransactionSet table ... */

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PayerTransactionSet_ClearinghousePayerID]') AND parent_object_id = OBJECT_ID(N'[dbo].[PayerTransactionSet]'))
ALTER TABLE [dbo].[PayerTransactionSet] DROP CONSTRAINT [FK_PayerTransactionSet_ClearinghousePayerID]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayerTransactionSet]') AND type in (N'U'))
DROP TABLE [dbo].[PayerTransactionSet]
GO

CREATE TABLE [dbo].[PayerTransactionSet](
	[PayerTransactionSetID] [int] IDENTITY(1,1) NOT NULL,
	[PayerTransactionSetTypeID] [int] NOT NULL,
	[ClearinghousePayerID] [int] NOT NULL,
	[IsIndAgreeRequired] [bit] NOT NULL CONSTRAINT [DF_PayerTransactionSet_IsIndAgreeRequired]  DEFAULT ((0)),
	[IsGrpAgreeRequired] [bit] NOT NULL CONSTRAINT [DF_PayerTransactionSet_IsGrpAgreeRequired]  DEFAULT ((0)),
	[IsIndIdRequired] [bit] NOT NULL CONSTRAINT [DF_PayerTransactionSet_IsIndIdRequired]  DEFAULT ((0)),
	[IsGroupIdRequired] [bit] NOT NULL CONSTRAINT [DF_PayerTransactionSet_IsGroupIdRequired]  DEFAULT ((0)),
	[AgreementURL] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_PayerTransactionSet] PRIMARY KEY CLUSTERED 
(
	[PayerTransactionSetID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PayerTransactionSet]  WITH CHECK ADD  CONSTRAINT [FK_PayerTransactionSet_ClearinghousePayerID] FOREIGN KEY([ClearinghousePayerID])
REFERENCES [dbo].[ClearinghousePayersList] ([ClearinghousePayerID])
GO

ALTER TABLE [dbo].[PayerTransactionSet] CHECK CONSTRAINT [FK_PayerTransactionSet_ClearinghousePayerID]
GO

ALTER TABLE [dbo].[PayerTransactionSet]  WITH CHECK ADD  CONSTRAINT [FK_PayerTransactionSet_PayerTransactionSetTypeID] FOREIGN KEY([PayerTransactionSetTypeID])
REFERENCES [dbo].[PayerTransactionSetType] ([PayerTransactionSetTypeID])
GO

ALTER TABLE [dbo].[PayerTransactionSet] CHECK CONSTRAINT [FK_PayerTransactionSet_PayerTransactionSetTypeID]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PayerTransactionSet]') AND name = N'IX_PayerTransactionSet_ClearinghousePayerID')
DROP INDEX [IX_PayerTransactionSet_ClearinghousePayerID] ON [dbo].[PayerTransactionSet] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IX_PayerTransactionSet_ClearinghousePayerID] ON [dbo].[PayerTransactionSet] 
(
	[ClearinghousePayerID] ASC
)
INCLUDE ( [PayerTransactionSetID],
[PayerTransactionSetTypeID],
[IsIndAgreeRequired],
[IsGrpAgreeRequired],
[IsIndIdRequired],
[IsGroupIdRequired],
[AgreementURL]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO