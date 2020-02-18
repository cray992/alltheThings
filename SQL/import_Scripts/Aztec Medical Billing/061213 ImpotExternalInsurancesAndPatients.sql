use aztek	-- TODO: remove this line
GO

declare
	@VendorImportID int

set @VendorImportID=5

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
from [PATS-OUT1212], IMPPracticeMapping PM
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


-- create Insurance Companies
insert into InsuranceCompany ( 
InsuranceCompanyName, 
Notes, 
AddressLine1, AddressLine2, City, State, Country, ZipCode, 
ContactPrefix, ContactFirstName, ContactMiddleName, ContactLastName, ContactSuffix, 
Phone, PhoneExt, Fax, FaxExt, 

BillSecondaryInsurance, 
EClaimsAccepts, 
BillingFormID, 

InsuranceProgramCode, 
HCFADiagnosisReferenceFormatCode, 
HCFASameAsInsuredFormatCode, 

LocalUseFieldTypeCode, 
ReviewCode, 
ProviderNumberTypeID, 
GroupNumberTypeID, 
LocalUseProviderNumberTypeID, 
CompanyTextID, 
ClearinghousePayerID, 
CreatedPracticeID, 
CreatedDate, ModifiedDate, 
SecondaryPrecedenceBillingFormID, 
DefaultAdjustmentCode, 
ReferringProviderNumberTypeID, 
NDCFormat,
VendorID, VendorImportID)
select 
[InsuranceName], 
null,
[Addr1], [Addr2], [City], [State], 'USA', [ZIP],
null, null, null, null, null,
[Phone], null, [FAX], null,

1, 
0, 
1,

'CI',
'C', 
'D',

null,		-- LocalUseFieldTypeCode
' ',		-- ReviewCode
null,		-- ProviderNumberTypeID  
'21',		-- GroupNumberTypeID 
null,		-- LocalUseProviderNumberTypeID
null,		-- CompanyTextID
null, --[ ElectronicNbr],		-- ClearinghousePayerID 
PM.PracticeID,
GetDate(), GetDate(), 
1, 
'01', 
null, 
1,
[RecordKey], @VendorImportID
from [IMPINSUR-OUT1212], IMPPRacticeMapping PM where PM.OldPracticeID=Practice

insert into InsuranceCompanyPlan (
	PlanName, 
	AddressLine1, AddressLine2, City, State, Country, ZipCode, 
	ContactPrefix, ContactFirstName, ContactMiddleName, ContactLastName, ContactSuffix, 
	Phone, PhoneExt, 
	Notes, MM_CompanyID, 
	CreatedDate, ModifiedDate, ReviewCode, 
	CreatedPracticeID, 
	Fax, FaxExt, 
	InsuranceCompanyID, 
	VendorID, VendorImportID)
select 
	InsuranceCompanyName, 
	AddressLine1, AddressLine2, City, State, Country, ZipCode, 
	ContactPrefix, ContactFirstName, ContactMiddleName, ContactLastName, ContactSuffix, 
	Phone, null,
	null, null, 
	GetDate(), GetDate(), ' ',
	CreatedPracticeID, 
	Fax, FaxExt,
	InsuranceCompanyID,
	VendorID, VendorImportID
from InsuranceCompany where VendorImportID=@VendorImportID



-- import of policies
declare
	@Medicare varchar(50),
	@Medicaid varchar(50)

set @Medicare = 'Medicare Of So. Cal.'
set @Medicaid = 'Calif. Medi-Cal' --312450


-- create carbon copy in order to do insurance companies transformations without the data loss
if exists (select * from sys.Tables where name='IMPPATS-OUT1212_1')
	drop table [IMPPATS-OUT1212_1]
select * into dbo.[IMPPATS-OUT1212_1] from [PATS-OUT1212]

-- shifting insurance info
-- create temp tables
create table #Case1 (ID int)
create table #Case2 (ID int)
create table #Case3 (ID int)
create table #Case4 (ID int)
create table #Case5 (ID int)

insert into #Case1 (ID) select ID from [IMPPATS-OUT1212_1] where MedicareID>'' and MedicalID='' and PrimaryInsuranceName=''
insert into #Case2 (ID) select ID from [IMPPATS-OUT1212_1] where MedicareID='' and MedicalID>'' and PrimaryInsuranceName=''
insert into #Case3 (ID) select ID from [IMPPATS-OUT1212_1] where MedicareID>'' and MedicalID>'' and PrimaryInsuranceName=''
insert into #Case4 (ID) select ID from [IMPPATS-OUT1212_1] where MedicareID>'' and MedicalID='' and PrimaryInsuranceName>''
insert into #Case5 (ID) select ID from [IMPPATS-OUT1212_1] where MedicareID='' and MedicalID>'' and PrimaryInsuranceName>''

-- 1. MedicareID only 
update [IMPPATS-OUT1212_1] set 
	PrimaryInsuranceName=@Medicare,
	PrimaryGroupNumber=null,
	PrimaryMemberNumber=MedicareID,
	PrimaryGuarantorFirstName=null,
	PrimaryGuarantorLastName=null,
	PrimaryGarantorRelation=null
where ID in (select ID from #Case1)

-- 2. MedicalID only
update [IMPPATS-OUT1212_1] set 
	PrimaryInsuranceName=@Medicaid,
	PrimaryGroupNumber=null,
	PrimaryMemberNumber=MedicalID,
	PrimaryGuarantorFirstName=null,
	PrimaryGuarantorLastName=null,
	PrimaryGarantorRelation=null
where ID in (select ID from #Case2)

-- 3. MedicareID and MedicalID
update [IMPPATS-OUT1212_1] set 
	SecondInsuranceName=@Medicaid,
	SecondGroupNumber=null,
	SecondMemberNumber=MedicalID,
	SecondGuarantorFirstName=null,
	SecondGuarantorLastName=null,
	SecondGuarantorRelation=null
where ID in (select ID from #Case3)

update [IMPPATS-OUT1212_1] set 
	PrimaryInsuranceName=@Medicare,
	PrimaryGroupNumber=null,
	PrimaryMemberNumber=MedicareID,
	PrimaryGuarantorFirstName=null,
	PrimaryGuarantorLastName=null,
	PrimaryGarantorRelation=null
where ID in (select ID from #Case3)

-- 4. MedicareID and Primary
print '4'
update [IMPPATS-OUT1212_1] set
	SecondInsuranceName=PrimaryInsuranceName,
	SecondGroupNumber=PrimaryGroupNumber,
	SecondMemberNumber=PrimaryMemberNumber,
	SecondGuarantorFirstName=PrimaryGuarantorFirstName,
	SecondGuarantorLastName=PrimaryGuarantorLastName,
	SecondGuarantorRelation=PrimaryGarantorRelation
where ID in (select ID from #Case4)

update [IMPPATS-OUT1212_1] set 
	PrimaryInsuranceName=@Medicare,
	PrimaryGroupNumber=null,
	PrimaryMemberNumber=MedicareID,
	PrimaryGuarantorFirstName=null,
	PrimaryGuarantorLastName=null,
	PrimaryGarantorRelation=null
where ID in (select ID from #Case4)

-- 5. MedicalID and Primary
print '5'
update [IMPPATS-OUT1212_1] set
	SecondInsuranceName=PrimaryInsuranceName,
	SecondGroupNumber=PrimaryGroupNumber,
	SecondMemberNumber=PrimaryMemberNumber,
	SecondGuarantorFirstName=PrimaryGuarantorFirstName,
	SecondGuarantorLastName=PrimaryGuarantorLastName,
	SecondGuarantorRelation=PrimaryGarantorRelation
where ID in (select ID from #Case5)

update [IMPPATS-OUT1212_1] set 
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

--alter table [IMPPATS-OUT1212_1] add PrimaryPlanID int, SecondaryPlanID int

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
PC.PatientCaseID,
dbo.IMP_ResolveInsurancePlanForExternalPatients (Pat.PrimaryInsuranceName, PM.PracticeID),

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
case IsNull(PrimaryGuarantorLastName, '') when '' then NULL else Pat.City end,
case IsNull(PrimaryGuarantorLastName, '') when '' then NULL else Pat.State end,
NULL,
case IsNull(PrimaryGuarantorLastName, '') when '' then NULL else ZIP end,
'U',
PM.PracticeID,
null, @VendorImportID

from [IMPPATS-OUT1212_1] Pat, IMPpracticeMapping PM, PatientCase PC, Patient
where PM.OldPracticeID=Pat.Practice and PC.PatientID=Patient.PatientID and Patient.VendorID=Pat.ID and Patient.VendorImportID=@VendorImportID 
	and RTrim(LTrim(PrimaryMemberNumber))>'' and 
	dbo.IMP_ResolveInsurancePlanForExternalPatients (Pat.PrimaryInsuranceName, PM.PracticeID) is not null

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
PC.PatientCaseID,
dbo.IMP_ResolveInsurancePlanForExternalPatients (Pat.SecondInsuranceName, PM.PracticeID),

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
case IsNull(SecondGuarantorLastName, '') when '' then NULL else Pat.City end,
case IsNull(SecondGuarantorLastName, '') when '' then NULL else Pat.State end,
NULL,
case IsNull(SecondGuarantorLastName, '') when '' then NULL else ZIP end,
'U',
PM.PracticeID,
null, @VendorImportID

from [IMPPATS-OUT1212_1] Pat, IMPpracticeMapping PM, PatientCase PC, Patient
where PM.OldPracticeID=Pat.Practice and PC.PatientID=Patient.PatientID and Patient.VendorID=Pat.ID and Patient.VendorImportID=@VendorImportID and
	RTrim(LTrim(SecondMemberNumber))>'' and 
	dbo.IMP_ResolveInsurancePlanForExternalPatients (Pat.SecondInsuranceName, PM.PracticeID) is not null

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
where PatientRelationshipToInsured='S' and VendorImportID=@VendorImport

-- disable patient statement for specific insurance plan
update PatientCase set StatementActive=0 where PatientCaseID in (select PatientCaseID from InsurancePolicy where InsuranceCompanyPlanID=312450)

