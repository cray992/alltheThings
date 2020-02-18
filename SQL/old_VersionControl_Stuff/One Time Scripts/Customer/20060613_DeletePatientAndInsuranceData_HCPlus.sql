-- Delete patients, cases, insurance policies, insurance company plans and insurance companies from superbill_0218

delete from paymentclaimtransaction --198
delete from PaymentPatient -- 292
delete from payment -- 295
delete from claimtransaction -- 1588
delete from billclaim -- 10
delete from claim -- 512
delete from AmbulanceCertificationInformation -- 3
delete from AmbulanceTransportInformation --2
delete from EncounterProcedure -- 515
delete from EncounterDiagnosis -- 561
delete from encounter -- 384
delete from insurancepolicyauthorization -- 2
delete from insurancepolicy-- 92927
-- select * from ProviderNumber where insurancecompanyplanID is not null
-- select * from ProviderNumber where insurancecompanyplanID is not null -- 5
-- select count(*) from ProviderNumber where insurancecompanyplanID is null -- 3489
-- select count(*) from ProviderNumber -- 3494

--BEGIN TRANSACTION
update ProviderNumber
set InsuranceCompanyPlanID = NULL
where InsuranceCompanyPlanID IS NOT NULL
-- COMMIT
-- ROLLBACK
-- SELECT * FROM CONTRACTTOINSURANCEPLAN WHERE PlanID is not null -- 1

delete from ContractToInsurancePlan --1
delete from insurancecompanyplan -- 2889
-- select * from PracticeToInsuranceCompany -- 52
delete from PracticeToInsuranceCompany -- 52
delete from insurancecompany -- 2626
delete from patientcase -- 63499
-- select * from PatientJournalNote -- 3
delete from PatientJournalNote -- 3
-- select * from PatientAlert
delete from PatientAlert -- 3
delete from patient -- 27814

-- select * from practice