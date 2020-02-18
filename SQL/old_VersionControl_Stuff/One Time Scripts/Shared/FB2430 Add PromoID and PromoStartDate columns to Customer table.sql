use Superbill_Shared
go

if not exists (select * from information_schema.columns where table_name = 'Customer' and column_name = 'PromoID')
begin
	alter table Customer add PromoID int
end
go

if not exists (select * from information_schema.columns where table_name = 'Customer' and column_name = 'PromoStartDate')
begin
	alter table Customer add PromoStartDate datetime
end
go

