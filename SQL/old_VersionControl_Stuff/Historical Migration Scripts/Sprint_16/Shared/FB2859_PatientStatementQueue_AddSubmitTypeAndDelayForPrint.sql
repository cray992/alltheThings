USE [Superbill_Shared]
GO

IF EXISTS(select * from sys.columns where Name = N'DelayForPrint'  
            AND Object_ID = Object_ID(N'PatientStatementQueue'))
BEGIN

	ALTER TABLE PatientStatementQueue
	DROP COLUMN DelayForPrint
	
END

IF EXISTS(select * from sys.columns where Name = N'DateProcessed'  
            AND Object_ID = Object_ID(N'PatientStatementQueue'))
BEGIN

	ALTER TABLE PatientStatementQueue
	DROP COLUMN DateProcessed
	
END

IF NOT EXISTS(select * from sys.columns where Name = N'DateToDrop'  
            AND Object_ID = Object_ID(N'PatientStatementQueue'))
BEGIN

	ALTER TABLE PatientStatementQueue
	ADD DateToDrop DATETIME null
	
END
GO

IF NOT EXISTS(select * from sys.columns where Name = N'SubmitType'  
            AND Object_ID = Object_ID(N'PatientStatementQueue'))
BEGIN

	ALTER TABLE PatientStatementQueue
	ADD SubmitType CHAR(1) null
	
END
GO

UPDATE PatientStatementQueue
SET SubmitType = 'P'

ALTER TABLE PatientStatementQueue
ALTER COLUMN SubmitType CHAR(1) NOT NULL
GO

IF EXISTS(select * from sys.columns where Name = N'XmlSnapshot'  
            AND Object_ID = Object_ID(N'PatientStatementQueue'))
BEGIN

	ALTER TABLE PatientStatementQueue
	DROP COLUMN XmlSnapshot
	
END

IF NOT EXISTS(select * from sys.columns where Name = N'XmlSnapshot'  
            AND Object_ID = Object_ID(N'PatientStatementQueue'))
BEGIN

	ALTER TABLE PatientStatementQueue
	ADD XmlSnapshot VARCHAR(MAX)
	
END

IF NOT EXISTS(select * from sys.columns where Name = N'DateDropped'  
            AND Object_ID = Object_ID(N'PatientStatementQueue'))
BEGIN

	ALTER TABLE PatientStatementQueue
	ADD DateDropped DATETIME NULL
	
END

IF NOT EXISTS(select * from sys.columns where Name = N'PatientCount'  
            AND Object_ID = Object_ID(N'PatientStatementQueue'))
BEGIN
	ALTER TABLE PatientStatementQueue
	ADD PatientCount INT null
END

IF NOT EXISTS(select * from sys.columns where Name = N'AdditionalPageCount'  
            AND Object_ID = Object_ID(N'PatientStatementQueue'))
BEGIN
	ALTER TABLE PatientStatementQueue
	ADD AdditionalPageCount INT NULL
END

GO

 