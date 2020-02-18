
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PracticeHistory_DeactivationResponse]') AND parent_object_id = OBJECT_ID(N'[dbo].[PracticeHistory]'))
ALTER TABLE [dbo].[PracticeHistory] DROP CONSTRAINT [FK_PracticeHistory_DeactivationResponse]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PracticeHistory_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PracticeHistory] DROP CONSTRAINT [DF_PracticeHistory_CreatedDate]
END

GO


/****** Object:  Table [dbo].[PracticeHistory]    Script Date: 01/11/2011 10:15:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PracticeHistory]') AND type in (N'U'))
DROP TABLE [dbo].[PracticeHistory]
GO

/****** Object:  Table [dbo].[PracticeHistory]    Script Date: 01/11/2011 10:15:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PracticeHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PracticeID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[ModifiedUserID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Active] [bit] NOT NULL,
	[ResponseID] [int] NULL,
 CONSTRAINT [PK_PracticeHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PracticeHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_PracticeHistory_DeactivationResponse] FOREIGN KEY([ResponseID])
REFERENCES [dbo].[DeactivationResponse] ([ResponseID])
GO

ALTER TABLE [dbo].[PracticeHistory] CHECK CONSTRAINT [FK_PracticeHistory_DeactivationResponse]
GO

ALTER TABLE [dbo].[PracticeHistory] ADD  CONSTRAINT [DF_PracticeHistory_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO


