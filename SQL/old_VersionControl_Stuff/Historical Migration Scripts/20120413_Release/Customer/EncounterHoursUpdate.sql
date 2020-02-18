-- we are not storing muinutes anymore therefore deducing the size of AdmissionHour and DischargeHour

-- migrate data from 
update Encounter set 
	AdmissionHour=Replace(Left(AdmissionHour, 2), ':', ''),
	DischargeHour=Replace(Left(DischargeHour, 2), ':', '')

update Encounter set
	AdmissionHour='0'+AdmissionHour 
where Len(AdmissionHour)=1

update Encounter set
	DischargeHour='0'+DischargeHour
where Len(DischargeHour)=1

-- change columns size
alter table encounter alter column AdmissionHour varchar(2) null
GO
alter table encounter alter column DischargeHour varchar(2) null
GO


/*
don't forget to include create/update encounter stored procs in migration table!!!!

*/

