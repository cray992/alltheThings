--FB 637
GO
ALTER TABLE [dbo].[CustomerSettingsLog] ADD
[DatabaseServerName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimSettingEdition] [int] NULL,
[ClaimSettingVisible] [bit] NULL
GO