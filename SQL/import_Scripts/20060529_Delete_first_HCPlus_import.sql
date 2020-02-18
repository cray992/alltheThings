-- Delete previously imported referring physicians, insurance policies, patient cases and patients
-- also delete some transactions, encounters, claims, claimtransactions for previously imported patients

--use Superbill_0218_dev

/*
select * from claimtransaction where claimid in (503, 106) and practiceid between 28 and 49 -- 3
select * from claim where claimid in (503, 106) and practiceid between 28 and 49 -- 2
select * from AmbulanceCertificationInformation where EncounterID in (383, 191)
select * from AmbulanceTransportInformation where EncounterID in (383, 191)
select * from EncounterProcedure where EncounterID in (383, 191)
select * from EncounterDiagnosis where EncounterID in (383, 191)
select * from encounter where encounterid in (383, 191) -- 2
select * from insurancepolicy where practiceid between 28 and 49 -- 81703
select * from patientcase where practiceid between 28 and 49 -- 55309
select * from PaymentPatient where practiceid between 28 and 49 -- 1
select * from patient where practiceid between 28 and 49 -- 24167
select * from doctor where practiceid between 28 and 49 and [External] = 1 -- 3947
*/

-- BEGIN TRANSACTION

delete from claimtransaction where practiceid between 28 and 49 -- 3
delete from claim where practiceid between 28 and 49 -- 2
delete from AmbulanceTransportInformation where EncounterID in (383, 191)
delete from AmbulanceCertificationInformation where EncounterID in (383, 191)
delete from EncounterProcedure where EncounterID in (383, 191)
delete from EncounterDiagnosis where EncounterID in (383, 191)
delete from encounter where practiceid between 28 and 49 -- 2
delete from insurancepolicy where practiceid between 28 and 49 -- 81703
delete from patientcase where practiceid between 28 and 49 -- 55309
delete  from PaymentPatient where practiceid between 28 and 49 
delete from patient where practiceid between 28 and 49 -- 24167
delete from doctor where practiceid between 28 and 49 and [External] = 1 -- 3947 -- delete only referring physicians

-- ROLLBACK
-- COMMIT




-================================================================================
/*
select ct.claimtransactionid, ct.claimid 
from claimtransaction ct 
where ct.claimid in (
select c.claimid from claim c
join patient p on p.patientid = c.patientid
where p.vendorimportid is not null)
-- transactionid 292, 293, 1477

select ct.claimtransactionid, ct.claimid 
from claimtransaction ct 
where ct.claimid in (
select c.claimid from claim c
join patient p on p.patientid = c.patientid
where p.practiceid not in (26, 27) )
-- same as above

select c.claimid, p.patientid, p.vendorimportid from claim c
join patient p on p.patientid = c.patientid
where p.vendorimportid is not null
-- claimid 503, 106 (patientid 20941, 4096; practiceid 43, 29))

select c.claimid, p.patientid, p.vendorimportid from claim c
join patient p on p.patientid = c.patientid
where p.practiceid not in (26, 27)
-- same as above

select e.encounterid, p.patientid, p.vendorimportid from encounter e
join patient p on p.patientid = e.patientid
where p.vendorimportid is not null
-- encounterid 383, 191

select e.encounterid, p.patientid, p.vendorimportid from encounter e
join patient p on p.patientid = e.patientid
where p.practiceid not in (26, 27)
-- same as above

select a.appointmentid, p.patientid, p.vendorimportid from appointment a
join patient p on p.patientid = a.patientid
where p.vendorimportid is not null
-- none

*/


--select * from vendorimport order by vendorimportid
--select * from practice where practiceID in (26, 27) -- test and quality care plus

