USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[DROTest]    Script Date: 05/04/2012 09:04:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporting_DRO]') AND type in (N'U'))
Begin
Drop Table Reporting_DRO
End


BEGIN
CREATE TABLE [dbo].[Reporting_DRO](
	[CustomerName] [varchar](256) NULL,
	[CustomerID] [int] NULL,
	[PracticeID] [int] NULL,
	[GrandTotalAR] [money] NULL,
	[TotalChargesFor90Days] [money] NULL,
	[DailyCharges] [money] NULL,
	[DRO] [decimal](19, 9) NULL,
	[DatabaseName] [varchar](255) NULL,
	[PracticeName] [varchar](255) NULL,
	[CreateDate] [datetime] NOT NULL
) ON [PRIMARY]
END
GO

SET ANSI_PADDING OFF
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_DRO_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE dbo.Reporting_DRO ADD  CONSTRAINT [DF_DRO_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
END

GO
