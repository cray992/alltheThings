

select *
into zz_datafix_20100710_patient_backup
from patient
where vendorImportId=2



update p
set addressLine1=v.addressLine2,
	addressLine2=v.addressLine1
from patient p
	inner join zz_datafix_20100710_patient_backup v
		on p.patientId=v.patientId



select v.practiceId, v.lastName, v.firstName, v.dob, p.ssn, p.patientID,
	rowid=row_number() over (partition by v.practiceId, v.lastName, v.firstName, v.dob order by p.ssn desc)
into zz_datafix_20100710_dupPatient
from patient p
	inner join (
		select  practiceId, lastName, firstName, dob
		from patient		
		where vendorImportId=2
		group by practiceId, lastName, firstName, dob
		having count(*)>1
			) v
		on v.practiceId=p.practiceId
		and v.lastName=p.lastName
		and v.firstName=p.firstName
		and v.dob=p.dob
where vendorImportId=2


select p.*
from patient p
	inner join zz_datafix_20100710_dupPatient d
		on d.patientId=p.patientId
where rowid>1


select ip.*
INTO zz_datafix_20100710_dupInsurancePolicy
from patientCase pc
	inner join zz_datafix_20100710_dupPatient d
		on d.patientId=pc.patientId
	inner join insurancePolicy ip
		on ip.patientCaseId=pc.patientCaseId
where d.rowId>1



select pc.*
INTO zz_datafix_20100710_duppatientCase
from patientCase pc
	inner join zz_datafix_20100710_dupPatient d
		on d.patientId=pc.patientId
where d.rowId>1

begin tran
delete pc
from zz_datafix_20100710_duppatientCase d
	inner join patientCase pc
		on pc.patientCaseId=d.patientCaseId
commit

select p.*
into zz_datafix_20100710_dupPatientAlert
from patientAlert p
	inner join zz_datafix_20100710_dupPatient d
		on d.patientId=p.patientId
where rowid>1


begin tran

delete p
from patientAlert p
	inner join zz_datafix_20100710_dupPatient d
		on d.patientId=p.patientId
where rowid>1

delete p
from patient p
	inner join zz_datafix_20100710_dupPatient d
		on d.patientId=p.patientId
where rowid>1

commit
--rollback tran




select *
from patient p
	inner join zz_datafix_20100710_dupPatient d
		on d.patientId=p.patientId
where rowid>1

select * from patient
where vendorImportId=2

select * from zz_datafix_20100710_dupPatient

select * from practice


