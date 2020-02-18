USE [Superbill_Shared]
GO

--Drop SyncJobErrors
IF EXISTS ( SELECT  1
            FROM    sysobjects
            WHERE   xtype = 'u'
                    AND name = 'SyncJob' ) 
    BEGIN 
        DROP TABLE [dbo].[SyncJob]
    END

/****** Object:  Table [dbo].[SyncJob]    Script Date: 12/15/2010 16:57:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SyncJob](
	[SyncJobID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [varchar](50) NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Errors] [int] NULL,
 CONSTRAINT [PK_SyncJob_1] PRIMARY KEY CLUSTERED 
(
	[SyncJobID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[SyncJob] ADD  CONSTRAINT [DF_SyncJob_Error]  DEFAULT ((0)) FOR [Errors]
GO


