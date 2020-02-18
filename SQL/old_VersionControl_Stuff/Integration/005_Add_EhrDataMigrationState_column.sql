/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
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
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='EhrDataMigrationStatus' AND COLUMNS.TABLE_NAME='Practice')
ALTER TABLE dbo.Practice ADD
	EhrDataMigrationStatus tinyint NOT NULL CONSTRAINT DF_Practice_EhrDataMigrationStatus DEFAULT 0
GO
COMMIT