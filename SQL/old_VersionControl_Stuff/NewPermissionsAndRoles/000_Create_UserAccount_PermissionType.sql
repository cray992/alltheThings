/*****************************************/
/*Create Table UserAccount_PermissionType*/
/*****************************************/

USE [Superbill_Shared]
GO

/****** Object:  Table [dbo].[UserAccount_PermissionType]    Script Date: 06/28/2012 14:48:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserAccount_PermissionType]') AND type in (N'U'))
DROP TABLE [dbo].[UserAccount_PermissionType]
GO

CREATE TABLE [dbo].[UserAccount_PermissionType](
	[Id] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_UserAccount_PermissionType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

INSERT INTO [Superbill_Shared].[dbo].[UserAccount_PermissionType]
           ([Id]
           ,[Name])
     VALUES
           (0,'Unknown')
GO

INSERT INTO [Superbill_Shared].[dbo].[UserAccount_PermissionType]
           ([Id]
           ,[Name])
     VALUES
           (1,'Base')
GO

INSERT INTO [Superbill_Shared].[dbo].[UserAccount_PermissionType]
           ([Id]
           ,[Name])
     VALUES
           (2,'View')
GO

INSERT INTO [Superbill_Shared].[dbo].[UserAccount_PermissionType]
           ([Id]
           ,[Name])
     VALUES
           (3,'Create')
GO

INSERT INTO [Superbill_Shared].[dbo].[UserAccount_PermissionType]
           ([Id]
           ,[Name])
     VALUES
           (4,'Edit')
GO

INSERT INTO [Superbill_Shared].[dbo].[UserAccount_PermissionType]
           ([Id]
           ,[Name])
     VALUES
           (5,'Delete')
GO

INSERT INTO [Superbill_Shared].[dbo].[UserAccount_PermissionType]
           ([Id]
           ,[Name])
     VALUES
           (6,'Find')
GO


