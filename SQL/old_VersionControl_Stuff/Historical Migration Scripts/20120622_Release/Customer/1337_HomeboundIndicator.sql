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

IF COL_LENGTH('dbo.PatientCase','HomeboundRelatedFlag') IS NULL
	BEGIN
		ALTER TABLE dbo.PatientCase ADD
			HomeboundRelatedFlag bit NOT NULL CONSTRAINT DF_PatientCase_HomeboundRelatedFlag DEFAULT 0
	END

GO

COMMIT