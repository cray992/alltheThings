BEGIN TRAN

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PracticeFusionIgnoreCases'  
            and Object_ID = Object_ID(N'PracticeIntegration'))
BEGIN
	ALTER TABLE [dbo].[PracticeIntegration]
	ADD [PracticeFusionIgnoreCases] BIT NOT NULL DEFAULT(0) WITH VALUES
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PracticeFusionAutoPopulateG8Code'  
            and Object_ID = Object_ID(N'PracticeIntegration'))
BEGIN
	ALTER TABLE [dbo].[PracticeIntegration]
	ADD [PracticeFusionAutoPopulateG8Code] BIT NOT NULL DEFAULT(0) WITH VALUES
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PracticeFusionG8Code'  
            and Object_ID = Object_ID(N'PracticeIntegration'))
BEGIN
	ALTER TABLE [dbo].[PracticeIntegration]
	ADD [PracticeFusionG8Code] CHAR(7) NULL DEFAULT('G8447') WITH VALUES
END

COMMIT TRAN