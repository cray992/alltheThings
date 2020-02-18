if not exists (select * from PlaceOfService where PlaceOfServiceCode='09')
	insert into PlaceOfService (PlaceOfServiceCode, [Description]) values ('09', 'Prison-Correctional Facility')
