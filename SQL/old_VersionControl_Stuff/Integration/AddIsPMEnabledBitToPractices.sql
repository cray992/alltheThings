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

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='IsPMEnabled' AND COLUMNS.TABLE_NAME='Practice')
ALTER TABLE dbo.Practice ADD
	IsPMEnabled bit NOT NULL CONSTRAINT DF_Practice_IsPMEnabled DEFAULT 1
GO
COMMIT
