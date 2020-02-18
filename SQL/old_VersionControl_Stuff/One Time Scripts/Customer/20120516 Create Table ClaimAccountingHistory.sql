IF EXISTS(SELECT * FROM Sys.objects AS o WHERE o.name='ClaimAccountingHistory' AND type='U')
DROP TABLE ClaimAccountingHistory 
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ClaimAccountingHistory](
	[PracticeID] [int] NOT NULL,
	[ClaimID] [int] NOT NULL,
	[ProviderID] [int] NOT NULL,
	[PatientID] [int] NOT NULL,
	[ClaimTransactionID] [int] NOT NULL,
	[ClaimTransactionTypeCode] [char](3) NULL,
	[Status] [bit] NOT NULL,
	[ProcedureCount] [decimal](19, 4) NULL,
	[Amount] [money] NULL,
	[ARAmount] [money] NULL,
	[PostingDate] [datetime] NOT NULL,
	[CreatedUserID] [int] NULL,
	[PaymentID] [int] NULL,
	[EncounterProcedureID] [int] NULL,
	[DateDeleted] DateTime DEFAULT (GETDATE())
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO





