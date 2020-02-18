USE [Superbill_Shared]
GO

--Drop SyncJobError
IF EXISTS ( SELECT  1
            FROM    sysobjects
            WHERE   xtype = 'u'
                    AND name = 'SyncJobError' ) 
    BEGIN 
        DROP TABLE [dbo].[SyncJobError]
    END

/****** Object:  Table [dbo].[SyncJobError]    Script Date: 12/15/2010 16:58:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SyncJobError](
	[SyncJobErrorID] [int] IDENTITY(1,1) NOT NULL,
	[SyncJobID] [int] NOT NULL,
	[CustomerDB] [varchar](150) NOT NULL,
	[StoredProcedure] [varchar](150) NOT NULL,
	[ErrorProcedure] [nvarchar](150) NULL,
	[ErrorLine] int NULL,
	[ErrorMessage] [nvarchar](max) NULL,
 CONSTRAINT [PK_SyncJobs] PRIMARY KEY CLUSTERED 
(
	[SyncJobErrorID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[SyncJobError]  WITH CHECK ADD  CONSTRAINT [FK_SyncJobError_SyncJob] FOREIGN KEY([SyncJobID])
REFERENCES [dbo].[SyncJob] ([SyncJobID])
GO

ALTER TABLE [dbo].[SyncJobError] CHECK CONSTRAINT [FK_SyncJobError_SyncJob]
GO


