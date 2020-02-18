if NOT EXISTS (select * from information_schema.columns where table_name = 'Practice' and column_name = 'MerchantAccountEnabledDate')
begin
	ALTER TABLE dbo.Practice
	ADD MerchantAccountEnabledDate DATETIME NULL
end
go
UPDATE dbo.Practice
SET MerchantAccountEnabledDate = '5/1/2011'
WHERE MerchantAccountEnabled = 1 AND MerchantAccountEnabledDate IS NULL