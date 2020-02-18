USE [Superbill_Shared]
GO

IF NOT EXISTS(select * from sys.columns where Name = N'DateToDrop'  
            AND Object_ID = Object_ID(N'PatientStatementLog'))
BEGIN

	ALTER TABLE PatientStatementLog
	ADD DateToDrop DATETIME null
	
END
GO

IF EXISTS(select * from sys.columns where Name = N'DateProcessed'  
            AND Object_ID = Object_ID(N'PatientStatementLog'))
BEGIN

	ALTER TABLE PatientStatementLog
	DROP COLUMN DateProcessed
	
END
go


IF NOT EXISTS(select * from sys.columns where Name = N'SubmitType'  
            AND Object_ID = Object_ID(N'PatientStatementLog'))
BEGIN

	ALTER TABLE PatientStatementLog
	ADD SubmitType CHAR(1) null
	
END
GO

UPDATE PatientStatementLog
SET SubmitType = 'P'

ALTER TABLE PatientStatementLog
ALTER COLUMN SubmitType CHAR(1) NOT NULL

IF EXISTS(select * from sys.columns where Name = N'XmlSnapshot'  
            AND Object_ID = Object_ID(N'PatientStatementLog'))
BEGIN

	ALTER TABLE PatientStatementLog
	DROP COLUMN XmlSnapshot
	
END


IF NOT EXISTS(select * from sys.columns where Name = N'XmlSnapshot'  
            AND Object_ID = Object_ID(N'PatientStatementLog'))
BEGIN

	ALTER TABLE PatientStatementLog
	ADD XmlSnapshot VARCHAR(MAX) NULL
	
END

IF NOT EXISTS(select * from sys.columns where Name = N'FollowUpBatchID'  
            AND Object_ID = Object_ID(N'PatientStatementLog'))
BEGIN

	ALTER TABLE PatientStatementLog
	ADD FollowUpBatchID INT NULL
	
END

IF NOT EXISTS(select * from sys.columns where Name = N'DateDropped'  
            AND Object_ID = Object_ID(N'PatientStatementLog'))
BEGIN

	ALTER TABLE PatientStatementLog
	ADD DateDropped DATETIME NULL
	
END

IF NOT EXISTS(select * from sys.columns where Name = N'PatientCount'  
            AND Object_ID = Object_ID(N'PatientStatementLog'))
BEGIN
	ALTER TABLE PatientStatementLog
	ADD PatientCount INT null
END

IF NOT EXISTS(select * from sys.columns where Name = N'AdditionalPageCount'  
            AND Object_ID = Object_ID(N'PatientStatementLog'))
BEGIN
	ALTER TABLE PatientStatementLog
	ADD AdditionalPageCount INT NULL
END

GO

 