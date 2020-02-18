IF EXISTS(SELECT * FROM Sys.objects AS o WHERE o.name='ClaimAccounting_BillingsHistory' AND type='U')
DROP TABLE ClaimAccounting_BillingsHistory 
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ClaimAccounting_BillingsHistory](
	[PracticeID] [int] NULL,
	[ClaimID] [int] NULL,
	[ClaimTransactionID] [int] NULL,
	[Status] [bit] NULL,
	[PostingDate] [datetime] NOT NULL,
	[BatchType] [char](1) NULL,
	[LastBilled] [bit] NOT NULL,
	[EndPostingDate] [datetime] NULL,
	[LastBilledOfEndPostingDate] [bit] NULL,
	[EndClaimTransactionID] [int] NULL,
	[DKPostingDateID] [int] NULL,
	[DKEndPostingDateID] [int] NULL,
	[ResponsePostingDate] [datetime] NULL,
	[DateDeleted] DateTime DEFAULT (GETDATE())
) ON [PRIMARY]

GO

