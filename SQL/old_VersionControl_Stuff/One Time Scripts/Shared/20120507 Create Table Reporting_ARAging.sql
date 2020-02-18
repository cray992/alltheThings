USE [Superbill_Shared]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporting_ARAging]') AND type in (N'U'))
Begin
Drop Table Reporting_ARAging
End


BEGIN
CREATE TABLE [dbo].[Reporting_ARAging](
	[CustomerName] [varchar](256) NULL,
	[CustomerID] [int] NULL,
	[PracticeID] [int] NULL,
	[Unapplied] [money] NULL,
	[CurrentBalance] [money] NULL,
	[CBPercent] decimal(19,9) NULL,
	[Age31_60] [money] NULL,
	[Age31_60Percent] [decimal](19, 9) NULL,
	[Age61_90] [money] NULL,
	[Age61_90Percent] [decimal](19, 9) NULL,
	[Age91_120] [money] NULL,
	[Age91_120Percent] [decimal](19, 9) NULL,
	[AgeOver120] [money] NULL,
	[AgeOver120Percent] [decimal](19, 9) NULL,
	[TotalBalance] [money] NULL,
	[Credit] [money] NULL,
	[DatabaseName] [varchar](255) NULL,
	[PracticeName] [varchar](255) NULL,
	[CreateDate] [datetime] NOT NULL
) ON [PRIMARY]
END
GO

SET ANSI_PADDING OFF
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_AA_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE dbo.Reporting_ARAGing ADD  CONSTRAINT [DF_AA_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
END

GO


