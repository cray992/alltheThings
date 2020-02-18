use Superbill_Shared
go

if NOT EXISTS (select * from information_schema.columns where table_name = 'Customer' and column_name = 'BillingStartDate')
begin
	alter table [dbo].[Customer] add [BillingStartDate] DATETIME
end
go
