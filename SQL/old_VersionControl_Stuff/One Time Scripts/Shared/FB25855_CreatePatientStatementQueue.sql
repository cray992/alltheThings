IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PatientStatementQueue]') AND type in (N'U'))
DROP TABLE [dbo].[PatientStatementQueue]
GO

CREATE TABLE [dbo].[PatientStatementQueue](
	[QueueID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[PracticeID] [int] NOT NULL,
	[BatchID] [int] NOT NULL,
	[Filename] [varchar](100) NOT NULL,
	[UserID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_PatientStatementQueue_CreatedDate]  DEFAULT (getdate()),
	[Attempts] [int] NULL CONSTRAINT [DF_PatientStatementQueue_Attempts]  DEFAULT ((0)),
	[LastAttemptDatetime] [datetime] NULL,
	[LastErrorMessage] [varchar](max) NULL
) ON [PRIMARY]

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PatientStatementLog]') AND type in (N'U'))
DROP TABLE [dbo].[PatientStatementLog]
GO

CREATE TABLE [dbo].[PatientStatementLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[QueueID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[PracticeID] [int] NOT NULL,
	[BatchID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Filename] [varchar](100) NOT NULL,
	[QueuedDate] [datetime] NOT NULL,
	[TransmissionDate] [datetime] NULL,
	[Status] [varchar](20) NULL,
	[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_PatientStatementLog_CreatedDate]  DEFAULT (getdate()),
	[Attempts] [int] NULL,
	[LastAttemptDatetime] [datetime] NULL,
	[LastErrorMessage] [varchar](max) NULL
 CONSTRAINT [PK_PatientStatementLog] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO