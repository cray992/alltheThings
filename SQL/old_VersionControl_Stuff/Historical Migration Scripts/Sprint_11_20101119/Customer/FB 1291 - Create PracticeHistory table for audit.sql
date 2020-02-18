
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PracticeHistory_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PracticeHistory] DROP CONSTRAINT [DF_PracticeHistory_CreatedDate]
END

GO

/****** Object:  Table [dbo].[PracticeHistory]    Script Date: 11/06/2010 22:22:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PracticeHistory]') AND type in (N'U'))
DROP TABLE [dbo].[PracticeHistory]
GO

/****** Object:  Table [dbo].[PracticeHistory]    Script Date: 11/06/2010 22:22:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PracticeHistory](
	[PracticeID] [int] NOT NULL,
	[ModifiedUserID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModificationType] [char](10) NOT NULL,
	[Active] [bit] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


ALTER TABLE [dbo].[PracticeHistory] ADD  CONSTRAINT [DF_PracticeHistory_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO


