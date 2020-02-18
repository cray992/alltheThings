USE KareoAudit
GO

/****** Object:  Table [dbo].[ApplicationLog]    Script Date: 03/06/2012 14:42:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ApplicationLog]') AND type in (N'U'))
DROP TABLE [dbo].[ApplicationLog]
GO

/****** Object:  Table [dbo].[ApplicationLog]    Script Date: 03/06/2012 14:42:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ApplicationLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Thread] [varchar](255) NOT NULL,
	[Level] [varchar](50) NOT NULL,
	[Logger] [varchar](255) NOT NULL,
	[Message] [varchar](4000) NOT NULL,
	[Exception] [varchar](2000) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


