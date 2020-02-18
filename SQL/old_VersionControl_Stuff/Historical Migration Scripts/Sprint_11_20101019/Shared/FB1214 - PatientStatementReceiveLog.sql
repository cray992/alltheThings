IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PatientStatementReceiveLog_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PatientStatementReceiveLog] DROP CONSTRAINT [DF_PatientStatementReceiveLog_CreatedDate]
END

GO

/****** Object:  Table [dbo].[PatientStatementLog]    Script Date: 11/04/2010 11:34:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PatientStatementReceiveLog]') AND type in (N'U'))
DROP TABLE [dbo].[PatientStatementReceiveLog]
GO

CREATE TABLE [dbo].[PatientStatementReceiveLog](
	[PatientStatementReceiveLogID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[PracticeID] [int] NOT NULL,
	[Filename] [varchar](100) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Duplicate] [bit] NOT NULL,
	[EmptyFile] [bit] NOT NULL,
	[Error] [bit] NOT NULL,
	[ErrorMessage] [varchar](max) NULL,
 CONSTRAINT [PK_PatientStatementReceiveLog] PRIMARY KEY CLUSTERED 
(
	[PatientStatementReceiveLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PatientStatementReceiveLog] ADD  CONSTRAINT [DF_PatientStatementReceiveLog_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO


