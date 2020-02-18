IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Practice' AND COLUMN_NAME = 'EODefaultRevenueCodeID')
BEGIN
	ALTER TABLE [dbo].[Practice] ADD [EODefaultRevenueCodeID] INT NULL

	ALTER TABLE [dbo].[Practice]  WITH CHECK ADD  CONSTRAINT [FK_Practice_EODefaultRevenueCodeID] FOREIGN KEY([EODefaultRevenueCodeID])
	REFERENCES [dbo].[RevenueCode] ([RevenueCodeID])
END