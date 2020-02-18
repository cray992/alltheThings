/**************************************/
/*Create Table UserAccount_Roles      */
/**************************************/
USE [Superbill_Shared]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_UserAccount_Roles_Customer]') AND parent_object_id = OBJECT_ID(N'[dbo].[UserAccount_Roles]'))
ALTER TABLE [dbo].[UserAccount_Roles] DROP CONSTRAINT [FK_UserAccount_Roles_Customer]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_Roles]') AND type in (N'U'))
DROP TABLE [dbo].[UserAccount_Roles]
GO

CREATE TABLE [dbo].[UserAccount_Roles](
	[RoleID] [int] IDENTITY (1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [varchar](1000) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ViewInKareo] [bit] NOT NULL,
	[OldSecurityGroupID] [int] NULL
 CONSTRAINT [RoleID_Primary_Id] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO