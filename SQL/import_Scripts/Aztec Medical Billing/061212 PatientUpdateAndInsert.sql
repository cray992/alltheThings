--alter table [pats-upd1212] add ID 
--int not null identity(1,1), 
--PracticeID int, PatientID int

declare
	@VendorImportID int

set @VendorImportID=4

update [pats-upd1212] set PracticeID=(select PracticeID from IMPPracticeMapping where OldPracticeID=Practice)
update [pats-upd1212] set PatientID=null
update [pats-upd1212] set PatientID=(select PatientID from Patient where [pats-upd1212].PracticeID=Patient.PracticeID and MedicalRecordNumber=PatientAccount)

-- populate DOB and Address for the patiets that we need to update (where PatientID is not null)
update Patient set 
	DOB=BirthDate
from Patient, [pats-upd1212] 
where [pats-upd1212].PatientID is not null and Patient.PatientID=[pats-upd1212].PatientID and DOB is null and len(BirthDate)>0

-- update address (if different)
update Patient set 
	AddressLine1=Addr1,
	AddressLine2=Addr2,
	City=[pats-upd1212].City,
	State=[pats-upd1212].State,
	ZipCode=ZIP
from Patient, [pats-upd1212] 
where [pats-upd1212].PatientID is not null and Patient.PatientID=[pats-upd1212].PatientID and AddressLine1<>Addr1 and not exists (select * from encounter where PatientID=Patient.PatientID)


---------------------------------------- CREATE NEW PATIENTS [pats-upd1212] - those where PatientID is null
if exists(select * from sys.Tables where name='IMP_NEWPAT')
begin
	drop table DBO.IMP_NEWPAT
end

if exists(select * from sys.Tables where name='IMP_NEWPAT1')
begin
	drop table DBO.IMP_NEWPAT1
end

select * into DBO.IMP_NEWPAT from DBO.[pats-upd1212] where PatientID is null

insert into Patient 
(PracticeID, ReferringPhysicianID, Prefix, FirstName, MiddleName, LastName, Suffix, 
AddressLine1, AddressLine2, City, State, Country, ZipCode, 
Gender, MaritalStatus, HomePhone, HomePhoneExt, WorkPhone, WorkPhoneExt, 
DOB, SSN, EmailAddress, 
ResponsibleDifferentThanPatient, ResponsiblePrefix, ResponsibleFirstName, ResponsibleMiddleName, ResponsibleLastName, 
ResponsibleSuffix, ResponsibleRelationshipToPatient, 
ResponsibleAddressLine1, ResponsibleAddressLine2, ResponsibleCity, ResponsibleState, ResponsibleCountry, ResponsibleZipCode, 
CreatedDate, ModifiedDate, EmploymentStatus, InsuranceProgramCode, PatientReferralSourceID, 
PrimaryProviderID, DefaultServiceLocationID, EmployerID, MedicalRecordNumber, 
MobilePhone, MobilePhoneExt, PrimaryCarePhysicianID, VendorID, VendorImportID)

select PM.PracticeID, null, '', FirstName, MiddleName, LastNamr, '',
	Addr1, Addr2, City, State, '', ZIP,
	case Gender 
		when 'F' then 'F' 
		when 'M' then 'M'
		else 'U'
	end, 'U', Phone, '', WorkPhone, WorkExtension,
	case IsDate(BirthDate) when 1 then BirthDate else NULL end, case len(SSN) when 0 then null else SSN end, null,
	null, null, null, null, null,
	null, null,  
	null, null, null, null, null, null,
	GetDate(), GetDate(), 'U', null, null, 
	null, null, null, PatientAccount,
	null, null, null, [ID], @VendorImportID
from IMP_NEWPAT, IMPPracticeMapping PM
where PM.OldPracticeID=Practice


-- for each patient create one default case
insert into PatientCase (
PatientID, [Name], Active, PayerScenarioID, ReferringPhysicianID, 
EmploymentRelatedFlag, AutoAccidentRelatedFlag, OtherAccidentRelatedFlag, AbuseRelatedFlag, AutoAccidentRelatedState, 
Notes, ShowExpiredInsurancePolicies, CreatedDate, ModifiedDate, PracticeID, 
CaseNumber, WorkersCompContactInfoID, 
VendorID, VendorImportID, 
PregnancyRelatedFlag, StatementActive, EPSDT, FamilyPlanning)
select PatientID, 'Default Case', 1, 5, null,
0, 0, 0, 0, null,
'Autocreated during data import', 1, GetDate(), GetDate(), PracticeID, null, null, 
null, @VendorImportID, 
0, 1, 0, 0
from Patient where VendorImportID=@VendorImportID


begin tran

-- import of policies
declare
	@Medicare varchar(50),
	@Medicaid varchar(50)

set @Medicare = 'Medicare Of So. Cal.'
set @Medicaid = 'Calif. Medi-Cal' --312450

-- create carbon copy in order to do insurance companies transformations without the data loss
select * into dbo.IMP_NEWPAT1 from IMP_NEWPAT

-- shifting insurance info

-- create temp tables
create table #Case1 (ID int)
create table #Case2 (ID int)
create table #Case3 (ID int)
create table #Case4 (ID int)
create table #Case5 (ID int)

insert into #Case1 (ID) select ID from IMP_NEWPAT1 where MedicareID>'' and MedicalID='' and PrimaryInsuranceName=''
insert into #Case2 (ID) select ID from IMP_NEWPAT1 where MedicareID='' and MedicalID>'' and PrimaryInsuranceName=''
insert into #Case3 (ID) select ID from IMP_NEWPAT1 where MedicareID>'' and MedicalID>'' and PrimaryInsuranceName=''
insert into #Case4 (ID) select ID from IMP_NEWPAT1 where MedicareID>'' and MedicalID='' and PrimaryInsuranceName>''
insert into #Case5 (ID) select ID from IMP_NEWPAT1 where MedicareID='' and MedicalID>'' and PrimaryInsuranceName>''

-- 1. MedicareID only 
update IMP_NEWPAT1 set 
	PrimaryInsuranceName=@Medicare,
	PrimaryGroupNumber=null,
	PrimaryMemberNumber=MedicareID,
	PrimaryGuarantorFirstName=null,
	PrimaryGuarantorLastName=null,
	PrimaryGarantorRelation=null
where ID in (select ID from #Case1)

-- 2. MedicalID only
update IMP_NEWPAT1 set 
	PrimaryInsuranceName=@Medicaid,
	PrimaryGroupNumber=null,
	PrimaryMemberNumber=MedicalID,
	PrimaryGuarantorFirstName=null,
	PrimaryGuarantorLastName=null,
	PrimaryGarantorRelation=null
where ID in (select ID from #Case2)

-- 3. MedicareID and MedicalID
update IMP_NEWPAT1 set 
	SecondInsuranceName=@Medicaid,
	SecondGroupNumber=null,
	SecondMemberNumber=MedicalID,
	SecondGuarantorFirstName=null,
	SecondGuarantorLastName=null,
	SecondGuarantorRelation=null
where ID in (select ID from #Case3)

update IMP_NEWPAT1 set 
	PrimaryInsuranceName=@Medicare,
	PrimaryGroupNumber=null,
	PrimaryMemberNumber=MedicareID,
	PrimaryGuarantorFirstName=null,
	PrimaryGuarantorLastName=null,
	PrimaryGarantorRelation=null
where ID in (select ID from #Case3)

-- 4. MedicareID and Primary
print '4'
update IMP_NEWPAT1 set
	SecondInsuranceName=PrimaryInsuranceName,
	SecondGroupNumber=PrimaryGroupNumber,
	SecondMemberNumber=PrimaryMemberNumber,
	SecondGuarantorFirstName=PrimaryGuarantorFirstName,
	SecondGuarantorLastName=PrimaryGuarantorLastName,
	SecondGuarantorRelation=PrimaryGarantorRelation
where ID in (select ID from #Case4)

update IMP_NEWPAT1 set 
	PrimaryInsuranceName=@Medicare,
	PrimaryGroupNumber=null,
	PrimaryMemberNumber=MedicareID,
	PrimaryGuarantorFirstName=null,
	PrimaryGuarantorLastName=null,
	PrimaryGarantorRelation=null
where ID in (select ID from #Case4)

-- 5. MedicalID and Primary
print '5'
update IMP_NEWPAT1 set
	SecondInsuranceName=PrimaryInsuranceName,
	SecondGroupNumber=PrimaryGroupNumber,
	SecondMemberNumber=PrimaryMemberNumber,
	SecondGuarantorFirstName=PrimaryGuarantorFirstName,
	SecondGuarantorLastName=PrimaryGuarantorLastName,
	SecondGuarantorRelation=PrimaryGarantorRelation
where ID in (select ID from #Case5)

update IMP_NEWPAT1 set 
	PrimaryInsuranceName=@Medicaid,
	PrimaryGroupNumber=null,
	PrimaryMemberNumber=MedicalID,
	PrimaryGuarantorFirstName=null,
	PrimaryGuarantorLastName=null,
	PrimaryGarantorRelation=null
where ID in (select ID from #Case5)

drop table #Case1 
drop table #Case2 
drop table #Case3 
drop table #Case4 
drop table #Case5 



-- insurance policy - Primary
insert into InsurancePolicy (
PatientCaseID, 
InsuranceCompanyPlanID, 
Precedence, PolicyNumber, GroupNumber, 
PolicyStartDate, PolicyEndDate, CardOnFile,
PatientRelationshipToInsured,

HolderFirstName,
HolderLastName,
HolderAddressLine1,
HolderAddressLine2,
HolderCity,
HolderState,
HolderCountry,
HolderZipCode,
HolderGender,

PracticeID, 
VendorID, VendorImportID)
select
(select PatientCaseID from PatientCase where patientID in (select PatientID from Patient where VendorID=Pat.ID and VendorImportID=@VendorImportID)), 
(select InsuranceCompanyPlanID from InsuranceCompanyPlan where VendorID=(select ID from ImportInsWohl where RecordKey=PrimaryInsuranceName)),
1, PrimaryMemberNumber, PrimaryGroupNumber,
'2000-01-01', '2009-12-31', 0,
case PrimaryGarantorRelation
	when 'C' then 'C'
	when 'I' then 'S'
	when 'S' then 'U'
	else 'S'
end,

case IsNull(PrimaryGuarantorFirstName, '') when '' then NULL else PrimaryGuarantorFirstName end,
case IsNull(PrimaryGuarantorLastName, '') when '' then NULL else PrimaryGuarantorLastName end,
case IsNull(PrimaryGuarantorLastName, '') when '' then NULL else Addr1 end,
case IsNull(PrimaryGuarantorLastName, '') when '' then NULL else Addr2 end,
case IsNull(PrimaryGuarantorLastName, '') when '' then NULL else City end,
case IsNull(PrimaryGuarantorLastName, '') when '' then NULL else State end,
NULL,
case IsNull(PrimaryGuarantorLastName, '') when '' then NULL else ZIP end,
'U',

(select PracticeID from IMPpracticeMapping where OldPracticeID=Pat.Practice),
null, @VendorImportID

from IMP_NEWPAT1 Pat
where RTrim(LTrim(PrimaryMemberNumber))>'' and PrimaryInsuranceName in (select RecordKey from ImportInsWohl)

-- insurance policy - Secondary
insert into InsurancePolicy (
PatientCaseID, 
InsuranceCompanyPlanID, 
Precedence, PolicyNumber, GroupNumber, 
PolicyStartDate, PolicyEndDate, CardOnFile,
PatientRelationshipToInsured,

HolderFirstName,
HolderLastName,
HolderAddressLine1,
HolderAddressLine2,
HolderCity,
HolderState,
HolderCountry,
HolderZipCode,
HolderGender,

PracticeID, 
VendorID, VendorImportID)
select
(select PatientCaseID from PatientCase where patientID in (select PatientID from Patient where VendorID=Pat.ID and VendorImportID=@VendorImportID)), 
(select InsuranceCompanyPlanID from InsuranceCompanyPlan where VendorID=(select ID from ImportInsWohl where RecordKey=SecondInsuranceName)),
2, SecondMemberNumber, SecondGroupNumber,
'2000-01-01', '2009-12-31', 0,
case SecondGuarantorRelation
	when 'C' then 'C'
	when 'I' then 'S'
	when 'S' then 'U'
	else 'S'
end,

case IsNull(SecondGuarantorFirstName, '') when '' then NULL else SecondGuarantorFirstName end,
case IsNull(SecondGuarantorLastName, '') when '' then NULL else SecondGuarantorLastName end,
case IsNull(SecondGuarantorLastName, '') when '' then NULL else Addr1 end,
case IsNull(SecondGuarantorLastName, '') when '' then NULL else Addr2 end,
case IsNull(SecondGuarantorLastName, '') when '' then NULL else City end,
case IsNull(SecondGuarantorLastName, '') when '' then NULL else State end,
NULL,
case IsNull(SecondGuarantorLastName, '') when '' then NULL else ZIP end,
'U',

(select PracticeID from IMPpracticeMapping where OldPracticeID=Pat.Practice),
null, @VendorImportID

from IMP_NEWPAT1 Pat
where RTrim(LTrim(SecondMemberNumber))>'' and SecondInsuranceName in (select RecordKey from ImportInsWohl)

update InsurancePolicy set
	HolderFirstName=null,
	HolderLastName=null,
	HolderAddressLine1=null,
	HolderAddressLine2=null,
	HolderCity=null,
	HolderState=null,
	HolderCountry=null,
	HolderZipCode=null,
	HolderGender=null
where PatientRelationshipToInsured='S' and VendorImportID=@vendorimportID

-- disable patient statement for specific insurance plan
update PatientCase set StatementActive=0 where PatientCaseID in (select PatientCaseID from InsurancePolicy where InsuranceCompanyPlanID=312450) and PatientID in (select PatientID from Patient where VendorImportID=@VendorImportID)

commit tran