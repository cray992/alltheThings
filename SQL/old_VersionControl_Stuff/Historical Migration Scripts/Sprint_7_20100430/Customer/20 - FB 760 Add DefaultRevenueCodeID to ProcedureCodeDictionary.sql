IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ProcedureCodeDictionary' AND COLUMN_NAME = 'DefaultRevenueCodeID')
BEGIN
	ALTER TABLE [dbo].[ProcedureCodeDictionary] ADD [DefaultRevenueCodeID] INT NULL

	ALTER TABLE [dbo].[ProcedureCodeDictionary]  WITH CHECK ADD  CONSTRAINT [FK_ProcedureCodeDictionary_DefaultRevenueCodeID] FOREIGN KEY([DefaultRevenueCodeID])
	REFERENCES [dbo].[RevenueCode] ([RevenueCodeID])
END