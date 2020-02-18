IF NOT EXISTS (select * from information_schema.columns WHERE table_name = 'Practice' and column_name = 'ChecklistComplete')
BEGIN
	ALTER TABLE [dbo].[Practice] ADD [ChecklistComplete] BIT CONSTRAINT DF_Practice_ChecklistComplete DEFAULT 0 NOT NULL
END
GO
UPDATE dbo.Practice
SET ChecklistComplete = 1
WHERE ChecklistComplete = 0 AND WizardComplete = 1