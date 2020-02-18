/***************************************************/
/*Create Table UserAccount_RolePermissions         */
/***************************************************/
USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[UserAccount_RolePermissions]    Script Date: 06/27/2012 11:44:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_RolePermissions]') AND name = N'IX_UserAccount_RolePermissions_PermissionID')
DROP INDEX [IX_UserAccount_RolePermissions_PermissionID] ON [dbo].[UserAccount_RolePermissions] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_RolePermissions]') AND name = N'IX_UserAccount_RolePermissions_RoleID')
DROP INDEX [IX_UserAccount_RolePermissions_RoleID] ON [dbo].[UserAccount_RolePermissions] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserAccount_RolePermissions_UserAccount_Permissions]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserAccount_RolePermissions]'))
ALTER TABLE [dbo].[UserAccount_RolePermissions] DROP CONSTRAINT [FK_UserAccount_RolePermissions_UserAccount_Permissions]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserAccount_RolePermissions_UserAccount_Roles]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserAccount_RolePermissions]'))
ALTER TABLE [dbo].[UserAccount_RolePermissions] DROP CONSTRAINT [FK_UserAccount_RolePermissions_UserAccount_Roles]
GO

USE [Superbill_Shared]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_RolePermissions]') AND type in (N'U'))
DROP TABLE [dbo].[UserAccount_RolePermissions]
GO

CREATE TABLE [dbo].[UserAccount_RolePermissions](
	[Id] [int] IDENTITY (1,1) NOT NULL,
	[RoleID] [int] NOT NULL,
	[PermissionID] [int] NOT NULL,
 CONSTRAINT [PK_UserAccount_RolePermissions_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UserAccount_RolePermissions]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_RolePermissions_UserAccount_Permissions] FOREIGN KEY([PermissionID])
REFERENCES [dbo].[UserAccount_Permissions] ([PermissionID])
GO

ALTER TABLE [dbo].[UserAccount_RolePermissions] CHECK CONSTRAINT [FK_UserAccount_RolePermissions_UserAccount_Permissions]
GO

ALTER TABLE [dbo].[UserAccount_RolePermissions]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_RolePermissions_UserAccount_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[UserAccount_Roles] ([RoleID])
GO

ALTER TABLE [dbo].[UserAccount_RolePermissions] CHECK CONSTRAINT [FK_UserAccount_RolePermissions_UserAccount_Roles]
GO

/****** Object:  Index [IX_UserAccount_RolePermissions_PermissionID]    Script Date: 06/27/2012 11:58:33 ******/
CREATE NONCLUSTERED INDEX [IX_UserAccount_RolePermissions_PermissionID] ON [dbo].[UserAccount_RolePermissions] 
(
	[PermissionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_UserAccount_RolePermissions_RoleID]    Script Date: 06/27/2012 11:58:53 ******/
CREATE NONCLUSTERED INDEX [IX_UserAccount_RolePermissions_RoleID] ON [dbo].[UserAccount_RolePermissions] 
(
	[RoleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO