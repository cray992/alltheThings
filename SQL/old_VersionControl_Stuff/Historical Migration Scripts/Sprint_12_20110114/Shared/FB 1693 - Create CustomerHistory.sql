
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CustomerHistory_Customer]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomerHistory]'))
ALTER TABLE [dbo].[CustomerHistory] DROP CONSTRAINT [FK_CustomerHistory_Customer]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CustomerHistory_DeactivationResponse]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomerHistory]'))
ALTER TABLE [dbo].[CustomerHistory] DROP CONSTRAINT [FK_CustomerHistory_DeactivationResponse]
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_CustomerHistory_ModifiedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[CustomerHistory] DROP CONSTRAINT [DF_CustomerHistory_ModifiedDate]
END

GO

/****** Object:  Table [dbo].[CustomerHistory]    Script Date: 01/11/2011 10:19:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerHistory]') AND type in (N'U'))
DROP TABLE [dbo].[CustomerHistory]
GO

/****** Object:  Table [dbo].[CustomerHistory]    Script Date: 01/11/2011 10:19:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CustomerHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[ModifiedUserID] [int] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[Cancelled] [bit] NOT NULL,
	[ResponseID] [int] NULL,
 CONSTRAINT [PK_CustomerHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_CustomerHistory_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO

ALTER TABLE [dbo].[CustomerHistory] CHECK CONSTRAINT [FK_CustomerHistory_Customer]
GO

ALTER TABLE [dbo].[CustomerHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_CustomerHistory_DeactivationResponse] FOREIGN KEY([ResponseID])
REFERENCES [dbo].[DeactivationResponse] ([ResponseID])
GO

ALTER TABLE [dbo].[CustomerHistory] CHECK CONSTRAINT [FK_CustomerHistory_DeactivationResponse]
GO

ALTER TABLE [dbo].[CustomerHistory] ADD  CONSTRAINT [DF_CustomerHistory_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO


