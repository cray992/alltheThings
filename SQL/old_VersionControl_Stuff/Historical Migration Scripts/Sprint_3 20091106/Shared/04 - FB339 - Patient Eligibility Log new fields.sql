IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'EligibilityTransactionLog' AND COLUMN_NAME = 'ServiceTypeCode')
BEGIN
	alter table dbo.EligibilityTransactionLog add ServiceTypeCode varchar(2) null
END

