-- This script will replicate patients, cases, notes, alerts, referring physicians (with numbers) 
-- from one practice to another

--asfwefsdfsdfsdfsdfwerwe

declare
	@SrcPractice int,
	@DestPractice int,
	@VendorImportID int


-- TODO: specify here necessary parameters before running this script
set @SrcPractice=1--15
set @DestPractice=18--27
set @VendorImportID= 2 -- 46


delete InsurancePolicyAuthorization where  VendorImportID=@VendorImportID
delete InsurancePolicy where PracticeID=@DestPractice and VendorImportID=@VendorImportID
delete patientcase where VendorImportID=@VendorImportID and PracticeID=@DestPractice
delete PatientAlert where PatientID in (select PatientID from Patient where VendorImportID=@VendorImportID and PracticeID=@DestPractice)
delete PatientJournalNote where PatientID in (select PatientID from Patient where VendorImportID=@VendorImportID and PracticeID=@DestPractice)
delete patient where VendorImportID=@VendorImportID and PracticeID=@DestPractice
delete ProviderNumber where DoctorID in (select DoctorID from Doctor where VendorImportID=@VendorImportID and PracticeID=@DestPractice)
delete doctor where VendorImportID=@VendorImportID and PracticeID=@DestPractice
--delete ServiceLocation where VendorImportID=@VendorImportID and PracticeID=@DestPractice

select * into #Loc from ServiceLocation where PracticeID=@SrcPractice
update #Loc set PracticeID=@DestPractice, VendorID=ServiceLocationID

--insert into ServiceLocation (
--	PracticeID, [Name], AddressLine1, AddressLine2, City, State, Country, ZipCode, PlaceOfServiceCode, BillingName, Phone, PhoneExt, FaxPhone, FaxPhoneExt, HCFABox32FacilityID, CLIANumber, VendorID, VendorImportID)
--select PracticeID, [Name], AddressLine1, AddressLine2, City, State, Country, ZipCode, PlaceOfServiceCode, BillingName, Phone, PhoneExt, FaxPhone, FaxPhoneExt, HCFABox32FacilityID, CLIANumber, VendorID, @VendorImportID
--from #Loc


select src.PAtientID into #IgnPat
from Patient src
	join Patient targ on Targ.PracticeID=@DestPractice and targ.FirstName=src.FirstName and targ.LastName=src.LastName and targ.MiddleName=src.MiddleName and targ.City=src.City and targ.ZipCode=src.ZipCode and IsNull(targ.SSN, '')=IsNull(src.SSN, '')
where src.PracticeID=@SrcPractice 

select * into #pat from Patient where PracticeID=@SrcPractice and PatientID not in (select PatientID from #ignPat)

update #Pat set PracticeID=@DestPractice, VendorID=PatientID, VendorImportID=@VendorImportID, PrimaryProviderID=null, PrimaryCarePhysicianID=null

--update #Pat set DefaultServiceLocationID=(select ServiceLocationID from ServiceLocation where PracticeID=@DestPractice and VendorID=#Pat.DefaultServiceLocationID)


--select * into #Doctor from Doctor where DoctorID in 
--	(select distinct ReferringPhysicianID from #Pat 
--	union 
--	select distinct ReferringPhysicianID from PatientCase where PatientID in (select PatientID from #Pat))


select src.DoctorID into #IgnDoc
from Doctor src
	join Doctor targ on Targ.PracticeID=@DestPractice and targ.FirstName=src.FirstName and targ.LastName=src.LastName and targ.MiddleName=src.MiddleName 
where src.PracticeID=@SrcPractice 

-- copy all referring providers from Source Practice
select * into #Doctor from Doctor where PracticeID=@SrcPractice and [External]=1 and DoctorID not in (select DoctorID from #IgnDoc)

-- mark doctors that are duplicated
update Doctor 
	set Doctor.VendorID=src.DoctorID, Doctor.VendorImportID=null
from Doctor 
	join Doctor src on Src.PracticeID=@SrcPractice and src.FirstName=Doctor.FirstName and src.LAstName=Doctor.LastNAme
where Doctor.PracticeID=@DestPractice


update #Doctor set PracticeID=@DestPractice, VendorID=DoctorID, VendorImportID=@VendorImportID, DepartmentID=null, [External]=1, OrigReferringPhysicianID=null

insert into Doctor (PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, SSN, AddressLine1, AddressLine2, City, State, Country, ZipCode, HomePhone, HomePhoneExt, WorkPhone, WorkPhoneExt, PagerPhone, PagerPhoneExt, MobilePhone, MobilePhoneExt, DOB, EmailAddress, Notes, ActiveDoctor, CreatedDate, ModifiedDate,Degree, TaxonomyCode, VendorID, VendorImportID, DepartmentID, FaxNumber, FaxNumberExt, OrigReferringPhysicianID, [External])
select PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, SSN, AddressLine1, AddressLine2, City, State, Country, ZipCode, HomePhone, HomePhoneExt, WorkPhone, WorkPhoneExt, PagerPhone, PagerPhoneExt, MobilePhone, MobilePhoneExt, DOB, EmailAddress, Notes, ActiveDoctor, GetDate(), GetDate(), Degree, TaxonomyCode, DoctorID, @VendorImportID, null, FaxNumber, FaxNumberExt, OrigReferringPhysicianID, [External]
from #Doctor

insert into ProviderNumber (DoctorID, ProviderNumberTypeID, InsuranceCompanyPlanID, LocationID, ProviderNumber, AttachConditionsTypeID)
select 
	(select DoctorID from Doctor where VendorImportID=@VendorImportID and VendorID=PN.DoctorID),
	PN.ProviderNumberTypeID, PN.InsuranceCompanyPlanID, NULL, PN.ProviderNumber, PN.AttachConditionsTypeID
from ProviderNumber PN
where PN.DoctorID in (select DoctorID from #Doctor)

update #Pat set ReferringPhysicianID=(select DoctorID from Doctor where (VendorImportID=@VendorImportID and VendorID=#Pat.ReferringPhysicianID) or (VendorImportID is null and VendorID=#Pat.ReferringPhysicianID))

select * into #Case from PatientCase where PatientID in (select VendorID from #Pat)
update #Case set PracticeID=@DestPractice, VendorID=PatientCaseID, VendorImportID=@VendorImportID--, ReferringPhysicianID=null

update #Case set ReferringPhysicianID=(select DoctorID from Doctor where VendorImportID=@VendorImportID and VendorID=C.ReferringPhysicianID)
from #Case C

select * into #Policy from InsurancePolicy where PatientCaseID in (select VendorID from #Case)
update #Policy set PracticeID=@DestPractice, VendorImportID=@VendorImportID

insert into Patient 
	(PracticeID, ReferringPhysicianID, Prefix, FirstName, MiddleName, LastName, Suffix, AddressLine1, AddressLine2, City, State, Country, ZipCode, Gender, MaritalStatus, HomePhone, HomePhoneExt, WorkPhone, WorkPhoneExt, DOB, SSN, EmailAddress, 
	ResponsibleDifferentThanPatient, ResponsiblePrefix, ResponsibleFirstName, ResponsibleMiddleName, ResponsibleLastName, 
	ResponsibleSuffix, ResponsibleRelationshipToPatient, ResponsibleAddressLine1, ResponsibleAddressLine2, ResponsibleCity, 
	ResponsibleState, ResponsibleCountry, ResponsibleZipCode, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, 
	EmploymentStatus, InsuranceProgramCode, PatientReferralSourceID, PrimaryProviderID, DefaultServiceLocationID, EmployerID, 
	MedicalRecordNumber, MobilePhone, MobilePhoneExt, PrimaryCarePhysicianID, VendorID, VendorImportID)
select 
	@DestPractice, ReferringPhysicianID, Prefix, FirstName, MiddleName, LastName, Suffix, AddressLine1, AddressLine2, City, State, Country, ZipCode, Gender, MaritalStatus, HomePhone, HomePhoneExt, WorkPhone, WorkPhoneExt, DOB, SSN, EmailAddress, 
	ResponsibleDifferentThanPatient, ResponsiblePrefix, ResponsibleFirstName, ResponsibleMiddleName, ResponsibleLastName, 
	ResponsibleSuffix, ResponsibleRelationshipToPatient, ResponsibleAddressLine1, ResponsibleAddressLine2, ResponsibleCity, 
	ResponsibleState, ResponsibleCountry, ResponsibleZipCode, GetDate(), CreatedUserID, GetDate(), ModifiedUserID, 
	EmploymentStatus, InsuranceProgramCode, PatientReferralSourceID, PrimaryProviderID, NULL, /*DefaultServiceLocationID, */EmployerID, 
	MedicalRecordNumber, MobilePhone, MobilePhoneExt, PrimaryCarePhysicianID, VendorID, VendorImportID 
from #Pat

-- patient notes
insert into PatientJournalNote (PatientID, UserName, SoftwareApplicationID, Hidden, NoteMessage, AccountStatus, CreatedDate, ModifiedDate)
select 
	(select PatientID from Patient where PracticeID=@DestPractice and VendorID=PatientJournalNote.PAtientID),
	UserName, 
	SoftwareApplicationID, 
	Hidden, 
	NoteMessage, 
	AccountStatus,
	CreatedDate, 
	ModifiedDate
from PatientJournalNote where PatientID in (select PatientID from #Pat)

insert into PatientAlert (PatientID, AlertMessage, ShowInPatientFlag, ShowInAppointmentFlag, ShowInEncounterFlag, ShowInPatientStatementFlag)
select 
	(select PatientID from Patient where PracticeID=@DestPractice and VendorID=PatientAlert.PAtientID),
	AlertMessage, ShowInPatientFlag, ShowInAppointmentFlag, ShowInEncounterFlag, ShowInPatientStatementFlag
from 
	PatientAlert where PatientID in (select PatientID from #Pat)

update #case set PatientID=(select PatientID from Patient where PracticeID=@DestPractice and VendorID=c.PatientID)
from #case c

insert into PatientCase (PatientID, [Name], Active, PayerScenarioID, ReferringPhysicianID, EmploymentRelatedFlag, 
	AutoAccidentRelatedFlag, OtherAccidentRelatedFlag, AbuseRelatedFlag, AutoAccidentRelatedState, 
	Notes, ShowExpiredInsurancePolicies, CreatedDate, CreatedUserID, ModifiedDate, ModifiedUserID, PracticeID, 
	CaseNumber, WorkersCompContactInfoID, VendorID, VendorImportID, PregnancyRelatedFlag)
select PatientID, [Name], Active, PayerScenarioID, ReferringPhysicianID, EmploymentRelatedFlag, 
	AutoAccidentRelatedFlag, OtherAccidentRelatedFlag, AbuseRelatedFlag, AutoAccidentRelatedState, 
	Notes, ShowExpiredInsurancePolicies, GetDate(), CreatedUserID, GetDate(), ModifiedUserID, @DestPractice, 
	CaseNumber, WorkersCompContactInfoID, VendorID, VendorImportID, PregnancyRelatedFlag
from #Case

update #Policy set PatientCaseID=(select PatientCaseID from PatientCase where PracticeID=@DestPractice and VendorID=p.PatientCaseID)
from #Policy p

insert into InsurancePolicy (PatientCaseID, InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber, PolicyStartDate, 
	PolicyEndDate, CardOnFile, PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, 
	HolderLastName, HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName, PatientInsuranceStatusID, 
	CreatedDate, ModifiedDate, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, HolderState, 
	HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber, Notes, Phone, PhoneExt, Fax, 
	FaxExt, Copay, Deductible, PatientInsuranceNumber, Active, PracticeID, AdjusterPrefix, AdjusterFirstName, 
	AdjusterMiddleName, AdjusterLastName, AdjusterSuffix, vendorImportID, vendorid)
select PatientCaseID, InsuranceCompanyPlanID, Precedence, PolicyNumber, GroupNumber, PolicyStartDate, 
	PolicyEndDate, CardOnFile, PatientRelationshipToInsured, HolderPrefix, HolderFirstName, HolderMiddleName, 
	HolderLastName, HolderSuffix, HolderDOB, HolderSSN, HolderThroughEmployer, HolderEmployerName, PatientInsuranceStatusID, 
	CreatedDate, ModifiedDate, HolderGender, HolderAddressLine1, HolderAddressLine2, HolderCity, HolderState, 
	HolderCountry, HolderZipCode, HolderPhone, HolderPhoneExt, DependentPolicyNumber, Notes, Phone, PhoneExt, Fax, 
	FaxExt, Copay, Deductible, PatientInsuranceNumber, Active, PracticeID, AdjusterPrefix, AdjusterFirstName, 
	AdjusterMiddleName, AdjusterLastName, AdjusterSuffix, @VendorImportID, InsurancePolicyID
from #Policy


select * into #auth from InsurancePolicyAuthorization where InsurancePolicyID in (select InsurancePolicyID from #Policy)
update #auth set InsurancePolicyID=(select InsurancePolicyID from InsurancePolicy where VendorID=a.InsurancePolicyID)
from #auth a


--select * from InsurancePolicyAuthorization

insert into InsurancePolicyAuthorization (InsurancePolicyID, AuthorizationNumber, AuthorizedNumberOfVisits, 
	StartDate, EndDate, COntactFullName, ContactPhone, ContactPhoneExt, AuthorizationStatusID, Notes, 
	CreatedDate, ModifiedDate, AuthorizedNumberOfVisitsUsed, vendorImportID)
select InsurancePolicyID, AuthorizationNumber, AuthorizedNumberOfVisits, 
	StartDate, EndDate, COntactFullName, ContactPhone, ContactPhoneExt, AuthorizationStatusID, Notes, 
	CreatedDate, ModifiedDate, AuthorizedNumberOfVisitsUsed, @VendorIMportId from #auth


drop table #Pat
drop table #Case
drop table #Policy
drop table #Doctor
drop table #Loc
drop table #IgnPat
drop table #IgnDoc
drop table #auth

--select * from PatientCase where PracticeID=4


/*
delete ProviderNumber where DoctorID in (select DoctorID from Doctor where PracticeID=125 and [External]=1)
delete InsurancePolicy where PracticeID=125
alter table PatientCase disable trigger all
delete PatientCase where  PracticeID=125
alter table PatientCase enable trigger all
delete PatientJournalNote where PatientID in (select PatientID from Patient where PracticeID=125)
delete Patient where PracticeID=125
delete Doctor where PracticeID=125

*/ 