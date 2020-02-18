/***************************************************/
/*Create Table UserAccount_UserPermissions         */
/***************************************************/
USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[UserAccount_UserPermissions]    Script Date: 06/27/2012 11:40:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_UserPermissions]') AND name = N'IX_UserAccount_UserPermissions_CustomerID')
DROP INDEX [IX_UserAccount_UserPermissions_CustomerID] ON [dbo].[UserAccount_UserPermissions] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_UserPermissions]') AND name = N'IX_UserAccount_UserPermissions_PermissionID')
DROP INDEX [IX_UserAccount_UserPermissions_PermissionID] ON [dbo].[UserAccount_UserPermissions] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_UserPermissions]') AND name = N'IX_UserAccount_UserPermissions_UserID')
DROP INDEX [IX_UserAccount_UserPermissions_UserID] ON [dbo].[UserAccount_UserPermissions] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserAccount_UserPermissions_Permissions]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserAccount_UserPermissions]'))
ALTER TABLE [dbo].[UserAccount_UserPermissions] DROP CONSTRAINT [FK_UserAccount_UserPermissions_Permissions]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserAccount_UserPermissions_Users]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserAccount_UserPermissions]'))
ALTER TABLE [dbo].[UserAccount_UserPermissions] DROP CONSTRAINT [FK_UserAccount_UserPermissions_Users]
GO

USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[UserAccount_UserPermissions]    Script Date: 06/27/2012 16:45:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_UserPermissions]') AND type in (N'U'))
DROP TABLE [dbo].[UserAccount_UserPermissions]
GO

CREATE TABLE [dbo].[UserAccount_UserPermissions](
	[Id] [int] IDENTITY (1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
 CONSTRAINT [PK_UserAccount_UserPermissions_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UserAccount_UserPermissions]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_UserPermissions_Permissions] FOREIGN KEY([PermissionID])
REFERENCES [dbo].[UserAccount_Permissions] ([PermissionID])
GO

ALTER TABLE [dbo].[UserAccount_UserPermissions] CHECK CONSTRAINT [FK_UserAccount_UserPermissions_Permissions]
GO

ALTER TABLE [dbo].[UserAccount_UserPermissions]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_UserPermissions_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO

ALTER TABLE [dbo].[UserAccount_UserPermissions] CHECK CONSTRAINT [FK_UserAccount_UserPermissions_Users]
GO

/****** Object:  Index [IX_UserAccount_UserPermissions_CustomerID]    Script Date: 06/27/2012 11:55:39 ******/
CREATE NONCLUSTERED INDEX [IX_UserAccount_UserPermissions_CustomerID] ON [dbo].[UserAccount_UserPermissions] 
(
	[CustomerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_UserAccount_UserPermissions_PermissionID]    Script Date: 06/27/2012 11:55:53 ******/
CREATE NONCLUSTERED INDEX [IX_UserAccount_UserPermissions_PermissionID] ON [dbo].[UserAccount_UserPermissions] 
(
	[PermissionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_UserAccount_UserPermissions_UserID]    Script Date: 06/27/2012 11:56:06 ******/
CREATE NONCLUSTERED INDEX [IX_UserAccount_UserPermissions_UserID] ON [dbo].[UserAccount_UserPermissions] 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO