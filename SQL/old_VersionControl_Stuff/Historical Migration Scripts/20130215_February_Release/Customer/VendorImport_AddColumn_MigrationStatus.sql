if not exists ( select * from sys.columns
	where name = N'EhrDataMigrationStatus' and Object_ID = Object_ID(N'VendorImport') )
begin
	alter table VendorImport
	add EhrDataMigrationStatus int not null
	default 0
end