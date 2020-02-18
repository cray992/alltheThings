if not exists ( select * from sys.columns
	where name = N'CreatedFromEhr' and Object_ID = Object_ID(N'Doctor') )
begin
	alter table Doctor
	add CreatedFromEhr bit not null
	constraint DF_Doctor_CreatedFromEhr default 0
end