use superbill_0108_prod
go

declare
	@PracticeID int

-- find the PracticeID
select @PracticeID=PracticeID from Practice where [Name] like '%Phillips%'

-- Patient
select PatientID, Prefix, FirstName, MiddleName, LastName, Suffix, 
	IsNull(AddressLine1, '') AddressLine1, IsNull(AddressLine2, '') AddressLine2, IsNull(City, '') City, IsNull(State, '') State, IsNull(Country, '') Country, IsNull(Zipcode, '') ZipCode, 
	Gender, MaritalStatus, IsNull(HomePhone, '') HomePhone, IsNull(HomePhoneExt, '') HomePhoneExt, IsNull(WorkPhone, '') WorkPhone, IsNull(WorkPhoneExt, '') WorkPhoneExt,
	IsNull(DOB, '') DOB, IsNull(SSN, '') SSN, IsNull(EmailAddress, '') EmailAddress,
	ResponsibleDifferentThanPatient, IsNull(ResponsiblePrefix, '') ResponsiblePrefix, IsNull(ResponsibleFirstName, '') ResponsibleFirstName, IsNull(ResponsibleMiddleName, '') ResponsibleMiddleName, IsNull(ResponsibleLastName, '') ResponsibleLastName, IsNull(ResponsibleSuffix, '') ResponsibleSuffix,  
	IsNull(ResponsibleAddressLine1, '') ResponsibleAddressLine1, IsNull(ResponsibleAddressLine2, '') ResponsibleAddressLine2, IsNull(ResponsibleCity, '') ResponsibleCity, IsNull(ResponsibleState, '') ResponsibleState, IsNull(ResponsibleCountry, '') ResponsibleCountry, IsNull(ResponsibleZipcode, '') ResponsibleZipcode, 
	IsNull(EmploymentStatus, '') EmploymentStatus
from Patient where PracticeID=@PracticeID

-- Procedures
select 
	E.PatientID as PatientID, P.FirstName, P.LastName, E.EncounterID,
	E.DateOfService, PD.ProcedureCode, IsNull(PD.LocalName, PD.OfficialName), EP.ServiceUnitCount, EP.ServiceChargeAmount, EP.ServiceUnitCount * EP.ServiceChargeAmount as TotalCharge
from EncounterProcedure EP
	inner join Encounter E on E.EncounterID=EP.EncounterID
	inner join Patient P on P.PatientID=E.PatientID
	inner join ProcedureCodeDictionary PD on Ep.ProcedureCodeDictionaryID=PD.ProcedureCodeDictionaryID
where 
	P.PatientID in (select PatientID from Patient where PracticeID=@PracticeID)
order by P.PatientID, E.EncounterID, EP.EncounterProcedureID

select MaritalStatus, LongName from MaritalStatus
select EmploymentStatusCode, StatusName from EmploymentStatus

select PatientID, Prefix, FirstName, MiddleName, LastName, Suffix, 
	IsNull(AddressLine1, '') AddressLine1, IsNull(AddressLine2, '') AddressLine2, IsNull(City, '') City, IsNull(State, '') State, IsNull(Country, '') Country, IsNull(Zipcode, '') ZipCode, 
	Gender, MaritalStatus, IsNull(HomePhone, '') HomePhone, IsNull(HomePhoneExt, '') HomePhoneExt, IsNull(WorkPhone, '') WorkPhone, IsNull(WorkPhoneExt, '') WorkPhoneExt,
	IsNull(DOB, '') DOB, IsNull(SSN, '') SSN, IsNull(EmailAddress, '') EmailAddress,
	ResponsibleDifferentThanPatient, IsNull(ResponsiblePrefix, '') ResponsiblePrefix, IsNull(ResponsibleFirstName, '') ResponsibleFirstName, IsNull(ResponsibleMiddleName, '') ResponsibleMiddleName, IsNull(ResponsibleLastName, '') ResponsibleLastName, IsNull(ResponsibleSuffix, '') ResponsibleSuffix,  
	IsNull(ResponsibleAddressLine1, '') ResponsibleAddressLine1, IsNull(ResponsibleAddressLine2, '') ResponsibleAddressLine2, IsNull(ResponsibleCity, '') ResponsibleCity, IsNull(ResponsibleState, '') ResponsibleState, IsNull(ResponsibleCountry, '') ResponsibleCountry, IsNull(ResponsibleZipcode, '') ResponsibleZipcode, 
	IsNull(EmploymentStatus, '') EmploymentStatus
from Patient where PatientID in
(select RecordID from DMSDocumentToRecordAssociation where RecordID in (select PatientID from patient where PracticeID=3) and RecordTypeID=1 )

select * from DMSRecordType