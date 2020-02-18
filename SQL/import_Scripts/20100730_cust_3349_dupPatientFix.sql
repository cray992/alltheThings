
-- drop table zz_datafix_dupPatient_20100730
select practiceID, lastname, firstName, isnull(ssn, 0) as ssn, MedicalRecordNumber, min(patientId) patientId
into zz_datafix_dupPatient_20100730
from patient
where practiceID=45
group by practiceID,  lastname, firstName, ssn, MedicalRecordNumber
having count(*)>1
order by 1



select p.*
into zz_datafix_dupPatient_20100730_deleted
from patient p
	inner join zz_datafix_dupPatient_20100730 z
		on p.practiceID=z.practiceID
		and p.lastname=z.lastname
		and p.firstName=z.firstName
		and isnull(p.ssn, 0) = isnull(z.ssn, 0)
		and p.MedicalRecordNumber=z.MedicalRecordNumber
WHERE p.patientId<>z.patientId
order by p.lastname, p.firstName


delete ip
from patientCase pc
	inner join zz_datafix_dupPatient_20100730_deleted z
		on z.patientId=pc.patientId
	inner join insurancePolicy ip
		on ip.patientCaseId=pc.patientCaseId
		
		
delete pc
from patientCase pc
	inner join zz_datafix_dupPatient_20100730_deleted z
		on z.patientId=pc.patientId


delete pjn
from zz_datafix_dupPatient_20100730_deleted z
	inner join patient p
		on p.patientId=z.patientId
	inner join patientJournalNote pjn
		on pjn.patientId=p.patientID
				
				
delete p
from zz_datafix_dupPatient_20100730_deleted z
	inner join patient p
		on p.patientId=z.patientId
		