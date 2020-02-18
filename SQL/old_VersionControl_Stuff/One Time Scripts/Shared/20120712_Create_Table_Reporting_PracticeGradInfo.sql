USE [superbill_shared]
GO

/****** Object:  Table [dbo].[Reporting_PracticeGradInfo]    Script Date: 07/12/2012 10:38:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Reporting_PracticeGradInfo]') AND type in (N'U'))
DROP TABLE [dbo].[Reporting_PracticeGradInfo]
GO

USE [superbill_shared]
GO

/****** Object:  Table [dbo].[Reporting_PracticeGradInfo]    Script Date: 07/12/2012 10:38:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Reporting_PracticeGradInfo](
	[DatabaseName] [varchar](64) NULL,
	[PracticeCreateDate] [smalldatetime] NULL,
	[PracticeID] [int] NULL,
	[PracticeName] [varchar](128) NULL,
	[FirstInsuranceCompany] [smalldatetime] NULL,
	[FirstContract] [smalldatetime] NULL,
	[FirstERAReceived] [smalldatetime] NULL,
	[FirstPaymentPosted] [smalldatetime] NULL,
	[FirstEncounter] [smalldatetime] NULL,
	[FirstPatient] [smalldatetime] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


USE [superbill_shared]
/****** Object:  Index [CX_PracticeGradInfo_PracticeId]    Script Date: 07/12/2012 10:38:40 ******/
CREATE CLUSTERED INDEX [CX_PracticeGradInfo_PracticeId] ON [dbo].[Reporting_PracticeGradInfo] 
(
	[PracticeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


USE [superbill_shared]
/****** Object:  Index [IX_PracticeGradInfo_PracticeId_DatabaseName]    Script Date: 07/12/2012 10:38:40 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_PracticeGradInfo_PracticeId_DatabaseName] ON [dbo].[Reporting_PracticeGradInfo] 
(
	[DatabaseName] ASC,
	[PracticeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

