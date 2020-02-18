if NOT EXISTS (select * from information_schema.columns where table_name = 'Doctor' and column_name = 'ExternalBillingID')
begin
	alter table [dbo].[Doctor] add [ExternalBillingID] VARCHAR(50)
end
go
