IF NOT EXISTS(select * from sys.columns where Name = N'WizardComplete'  
            AND Object_ID = Object_ID(N'Practice'))
BEGIN

	ALTER TABLE Practice
	ADD WizardComplete BIT NULL
	
END
GO

IF NOT EXISTS(select * from sys.columns where Name = N'CurrentWizardStep'  
            AND Object_ID = Object_ID(N'Practice'))
BEGIN

	ALTER TABLE Practice
	ADD CurrentWizardStep varchar(20) NULL
	
END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Practice_WizardComplete]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Practice] DROP CONSTRAINT [DF_Practice_WizardComplete]
END

GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_Practice_CurrentWizardStep]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Practice] DROP CONSTRAINT [DF_Practice_CurrentWizardStep]
END

ALTER TABLE [dbo].[Practice] ADD  CONSTRAINT [DF_Practice_WizardComplete]  DEFAULT ((0)) FOR [WizardComplete]
GO

ALTER TABLE [dbo].[Practice] ADD  CONSTRAINT [DF_Practice_CurrentWizardStep]  DEFAULT ('') FOR [CurrentWizardStep]
GO

-- update for existing customers
UPDATE dbo.Practice
SET 
	WizardComplete = 1,
	CurrentWizardStep = ''
GO