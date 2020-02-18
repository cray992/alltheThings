--Customer Table to log sync jobs
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SyncJob](
	[SyncJobID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[StoredProcedure] [varchar](150) NOT NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Status] [char](1) NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_SyncJob] PRIMARY KEY CLUSTERED 
(
	[SyncJobID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[SyncJob] ADD  CONSTRAINT [DF_SyncJob_Active]  DEFAULT ((0)) FOR [Active]
GO


INSERT INTO dbo.SyncJob
           ([Name]
           ,[StoredProcedure]
           ,[Active])
     VALUES
           ('Clean Up Orphan Dms Documents'
           ,'SyncJob_CleanUpDmsDocuments'
           ,1)
GO