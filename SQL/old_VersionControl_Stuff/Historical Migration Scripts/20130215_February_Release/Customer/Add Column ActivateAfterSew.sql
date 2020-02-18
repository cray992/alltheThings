IF NOT EXISTS (select * from information_schema.columns where table_name = 'Doctor' and column_name = 'ActivateAfterWizard')
BEGIN
      ALTER TABLE [dbo].[Doctor] ADD
      [ActivateAfterWizard] BIT NOT NULL CONSTRAINT DF_Doctor_ActivateAfterWizard DEFAULT 0
END
GO

