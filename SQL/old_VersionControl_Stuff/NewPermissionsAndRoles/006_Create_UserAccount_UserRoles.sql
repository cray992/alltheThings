/***************************************************/
/*Create Table UserAccount_UserRoles               */
/***************************************************/
USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[UserAccount_UserRoles]    Script Date: 06/27/2012 11:44:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_UserRoles]') AND name = N'IX_UserAccount_UserRoles_RoleID')
DROP INDEX [IX_UserAccount_UserRoles_RoleID] ON [dbo].[UserAccount_UserRoles] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_UserRoles]') AND name = N'IX_UserAccount_UserRoles_UserID')
DROP INDEX [IX_UserAccount_UserRoles_UserID] ON [dbo].[UserAccount_UserRoles] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserAccount_UserRoles_UserAccount_Roles]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserAccount_UserRoles]'))
ALTER TABLE [dbo].[UserAccount_UserRoles] DROP CONSTRAINT [FK_UserAccount_UserRoles_UserAccount_Roles]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserAccount_UserRoles_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserAccount_UserRoles]'))
ALTER TABLE [dbo].[UserAccount_UserRoles] DROP CONSTRAINT [FK_UserAccount_UserRoles_Users]
GO

USE [Superbill_Shared]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_UserRoles]') AND type in (N'U'))
DROP TABLE [dbo].[UserAccount_UserRoles]
GO

CREATE TABLE [dbo].[UserAccount_UserRoles](
	[Id] [int] IDENTITY (1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
 CONSTRAINT [PK_UserAccount_UserRoles_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UserAccount_UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_UserRoles_UserAccount_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[UserAccount_Roles] ([RoleID])
GO

ALTER TABLE [dbo].[UserAccount_UserRoles] CHECK CONSTRAINT [FK_UserAccount_UserRoles_UserAccount_Roles]
GO

ALTER TABLE [dbo].[UserAccount_UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_UserRoles_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO

ALTER TABLE [dbo].[UserAccount_UserRoles] CHECK CONSTRAINT [FK_UserAccount_UserRoles_Users]
GO

/****** Object:  Index [IX_UserAccount_UserRoles_RoleID]    Script Date: 06/27/2012 11:57:26 ******/
CREATE NONCLUSTERED INDEX [IX_UserAccount_UserRoles_RoleID] ON [dbo].[UserAccount_UserRoles] 
(
	[RoleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_UserAccount_UserRoles_UserID]    Script Date: 06/27/2012 11:57:42 ******/
CREATE NONCLUSTERED INDEX [IX_UserAccount_UserRoles_UserID] ON [dbo].[UserAccount_UserRoles] 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO