/***************************************************/
/*Create Table UserAccount_RoleToSecurityGroupMap  */
/***************************************************/
USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[UserAccount_RoleToSecurityGroupMap]    Script Date: 06/27/2012 11:39:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_RoleToSecurityGroupMap]') AND name = N'IX_UserAccount_RoleToSecurityGroupMap_RoleID')
DROP INDEX [IX_UserAccount_RoleToSecurityGroupMap_RoleID] ON [dbo].[UserAccount_RoleToSecurityGroupMap] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_RoleToSecurityGroupMap]') AND name = N'IX_UserAccount_RoleToSecurityGroupMap_SecurityGroupID')
DROP INDEX [IX_UserAccount_RoleToSecurityGroupMap_SecurityGroupID] ON [dbo].[UserAccount_RoleToSecurityGroupMap] WITH ( ONLINE = OFF )
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserAccount_RoleToSecurityGroupMap_SecurityGroup]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserAccount_RoleToSecurityGroupMap]'))
ALTER TABLE [dbo].[UserAccount_RoleToSecurityGroupMap] DROP CONSTRAINT [FK_UserAccount_RoleToSecurityGroupMap_SecurityGroup]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserAccount_RoleToSecurityGroupMap_UserAccount_Roles]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserAccount_RoleToSecurityGroupMap]'))
ALTER TABLE [dbo].[UserAccount_RoleToSecurityGroupMap] DROP CONSTRAINT [FK_UserAccount_RoleToSecurityGroupMap_UserAccount_Roles]
GO

USE [Superbill_Shared]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_RoleToSecurityGroupMap]') AND type in (N'U'))
DROP TABLE [dbo].[UserAccount_RoleToSecurityGroupMap]
GO


CREATE TABLE [dbo].[UserAccount_RoleToSecurityGroupMap](
	[Id] [int] IDENTITY (1,1) NOT NULL,
	[RoleID] [int] NOT NULL,
	[SecurityGroupID] [int] NOT NULL,
 CONSTRAINT [PK_UserAccount_RoleToSecurityGroupMap_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[UserAccount_RoleToSecurityGroupMap]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_RoleToSecurityGroupMap_SecurityGroup] FOREIGN KEY([SecurityGroupID])
REFERENCES [dbo].[SecurityGroup] ([SecurityGroupID])
GO

ALTER TABLE [dbo].[UserAccount_RoleToSecurityGroupMap] CHECK CONSTRAINT [FK_UserAccount_RoleToSecurityGroupMap_SecurityGroup]
GO

ALTER TABLE [dbo].[UserAccount_RoleToSecurityGroupMap]  WITH CHECK ADD  CONSTRAINT [FK_UserAccount_RoleToSecurityGroupMap_UserAccount_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[UserAccount_Roles] ([RoleID])
GO

ALTER TABLE [dbo].[UserAccount_RoleToSecurityGroupMap] CHECK CONSTRAINT [FK_UserAccount_RoleToSecurityGroupMap_UserAccount_Roles]
GO

/****** Object:  Index [IX_UserAccount_RoleToSecurityGroupMap_RoleID]    Script Date: 06/27/2012 11:54:35 ******/
CREATE NONCLUSTERED INDEX [IX_UserAccount_RoleToSecurityGroupMap_RoleID] ON [dbo].[UserAccount_RoleToSecurityGroupMap] 
(
	[RoleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_UserAccount_RoleToSecurityGroupMap_SecurityGroupID]    Script Date: 06/27/2012 11:54:54 ******/
CREATE NONCLUSTERED INDEX [IX_UserAccount_RoleToSecurityGroupMap_SecurityGroupID] ON [dbo].[UserAccount_RoleToSecurityGroupMap] 
(
	[SecurityGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO