
/****** Object:  Table [dbo].[PayerStatus]    Script Date: 07/25/2012 14:45:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PayerStatus]') AND type in (N'U'))
DROP TABLE [dbo].[PayerStatus]
GO

/****** Object:  Table [dbo].[PayerStatus]    Script Date: 07/25/2012 14:45:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PayerStatus](
	[PayerStatusID] [int] NOT NULL,
	[ExactMatch] [int] NOT NULL,
	[Pattern] [varchar](250) NOT NULL,
	[PayerStatusCode] [varchar](150) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


