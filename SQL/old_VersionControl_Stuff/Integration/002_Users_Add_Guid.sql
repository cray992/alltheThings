BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='UserGuid' AND COLUMNS.TABLE_NAME='Users')


ALTER TABLE dbo.Users ADD
	UserGuid uniqueidentifier NOT NULL CONSTRAINT DF_Users_Guid DEFAULT NEWID()
GO
COMMIT

IF NOT EXISTS(SELECT * FROM sys.indexes AS i WHERE i.name='UX_Users_Guid')
CREATE UNIQUE NONCLUSTERED INDEX [UX_Users_Guid] ON [dbo].[Users] 
(
	[UserGuid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO