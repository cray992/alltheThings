
USE [KareoMaintenance]
GO




IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SqlExceptionLog]') AND name = N'IX_SqlExceptionLog_DatabaseName')
DROP INDEX [IX_SqlExceptionLog_DatabaseName] ON [dbo].[SqlExceptionLog] WITH ( ONLINE = OFF )



IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SqlExceptionLog]') AND name = N'IX_SqlExceptionLog_Date_DatabaseName_StoredProcedure')
DROP INDEX [IX_SqlExceptionLog_Date_DatabaseName_StoredProcedure] ON [dbo].[SqlExceptionLog] WITH ( ONLINE = OFF )


IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SqlExceptionLog]') AND name = N'PK_SqlExceptionLog')
ALTER TABLE [dbo].[SqlExceptionLog] DROP CONSTRAINT [PK_SqlExceptionLog]


--EXEC sp_rename ExceptionLog 'SqlExceptionLog'

BEGIN TRAN
ALTER TABLE dbo.SqlExceptionLog
ALTER COLUMN DatabaseName VARCHAR(128) NULL  

ALTER TABLE dbo.SqlExceptionLog
ALTER COLUMN DatabaseServerName VARCHAR(128) NULL  

ALTER TABLE dbo.SqlExceptionLog
ALTER COLUMN StoredProcedure VARCHAR(200) NULL   

ALTER TABLE dbo.SqlExceptionLog
ALTER COLUMN StackTrace VARCHAR(max) NULL 

ALTER TABLE dbo.SqlExceptionLog
ADD ExceptionType VARCHAR(100) NOT NULL DEFAULT('SQL')
  
ALTER TABLE dbo.SqlExceptionLog
ADD SourceFile varchar(200) NULL
COMMIT TRAN



ALTER TABLE [dbo].[SqlExceptionLog] ADD  CONSTRAINT [PK_SqlExceptionLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


CREATE NONCLUSTERED INDEX [IX_SqlExceptionLog_DatabaseName] ON [dbo].[SqlExceptionLog] 
(
	[DatabaseName] ASC
)
INCLUDE ( [AppServerName],
[DatabaseServerName]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 100) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_SqlExceptionLog_Date_DatabaseName_StoredProcedure] ON [dbo].[SqlExceptionLog] 
(
	[Date] ASC,
	[DatabaseName] ASC,
	[StoredProcedure] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

GO



