-- Aztec Import
use superbill_0622_prod
GO
-- recreate ImportPatientWohl1
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ImportPatientWohl1]') AND type in (N'U'))
	DROP TABLE [dbo].[ImportPatientWohl1]
GO

---------------------------------------------------------------------------------
-- config info
declare
	@PracticeID int,
	@VendorImportID int

set @PracticeID=1
set @VendorImportID=1

----------------------------------------------------------------------------------
-- clear the Old Data

-- TODO: insurance company shouldn't be deleted if this is second practice to import
delete InsuranceCompanyPlan where VendorImportID=@VendorImportID
delete InsuranceCompany where VendorImportID=@VendorImportID

delete InsurancePolicy where PracticeID=@PracticeID and VendorImportID=@VendorImportID
delete PatientCase where PracticeID=@PracticeID and VendorImportID=@VendorImportID
delete Patient where PracticeID=@PracticeID and VendorImportID=@VendorImportID

delete ProviderNumber where DoctorID in (select DoctorID from Doctor where [External]=1 and PracticeID=@PracticeID and VendorImportID=@VendorImportID)
delete Doctor where [External]=1 and PracticeID=@PracticeID and VendorImportID=@VendorImportID

--referring Physicians Import
insert into Doctor (
PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, SSN, 
AddressLine1, AddressLine2, City, State, Country, ZipCode, HomePhone, HomePhoneExt, WorkPhone, WorkPhoneExt, 
PagerPhone, PagerPhoneExt, MobilePhone, MobilePhoneExt, 
DOB, EmailAddress, Notes, ActiveDoctor, 
CreatedDate, ModifiedDate, UserID, Degree, 
DefaultEncounterTemplateID, TaxonomyCode, DepartmentID, 
VendorID, VendorImportID, FaxNumber, FaxNumberExt, OrigReferringPhysicianID, [External])
select
@PracticeID, '',[ FirstName], '', [ LastName], '', null,
[ Addr1], [ Addr2], [ City], [ State], 'USA', [ ZIP], null, null, [ Phone], null,
null, null, null, null,
null, null, null, 1,
GetDate(), GetDate(), null, null,
null, null, null,
[ID], @VendorImportID, [ Fax], null, null, 1
from dbo.ImportReferringWohl


-- for imported referring phys - split degree from the LastName
update Doctor 
	set Degree=Substring(dbo.fnImportUtility_Degree(LastName), 1, 8),
	LastName=dbo.fnImportUtility_LastName(LastName)
where PracticeID=@PracticeID and VendorImportID=@VendorImportID

-- referring Providers numbers
INSERT INTO ProviderNumber (DoctorID, ProviderNumberTypeID, ProviderNumber, AttachConditionsTypeID)
select DoctorID, 24, dbo.fnImportUtility_RemoveLeading00([ PIN]), 1
from Doctor, ImportReferringWohl
where PracticeID=@PracticeID and [External]=1 and Doctor.VendorID=[ID] and Len([ PIN])>0

INSERT INTO ProviderNumber (DoctorID, ProviderNumberTypeID, ProviderNumber, AttachConditionsTypeID)
select DoctorID, 25, dbo.fnImportUtility_RemoveLeading00([ UPIN]), 1
from Doctor, ImportReferringWohl
where PracticeID=@PracticeID and [External]=1 and Doctor.VendorID=[ID] and Len([ UPIN])>0


-- patient Import
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

select @PracticeID, null, '', FirstName, MiddleName, LastNamr, '',
	Addr1, Addr2, City, State, '', ZIP,
	case Gender 
		when 'F' then 'F' 
		when 'M' then 'M'
		else 'U'
	end, 'U', Phone, '', WorkPhone, WorkExtension,
	BirthDate, SSN, null,
	null, null, null, null, null,
	null, null,  
	null, null, null, null, null, null,
	GetDate(), GetDate(), 'U', null, null, 
	null, null, null, PatientAccount,
	null, null, null, [ID], @VendorImportID
from ImportPatientWohl

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
'Autocreated during data import', 1, GetDate(), GetDate(), @PracticeID, null, null, 
null, @VendorImportID, 
0, 1, 0, 0
from Patient where VendorImportID=@VendorImportID

declare
	@Medicare varchar(50)

set @Medicare = 'Medicare Of So. Cal.'

-- add one artificially Medicare of So Cal
if not exists(select * from ImportInsWohl where [ InsuranceName]=@Medicare)
	insert into ImportInsWohl(RecordKey, [ InsuranceName]) values (@Medicare, @Medicare)

-- create Insurance Companies from ImportInsWohl
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
[ InsuranceName], 
null,
[ Addr1], [ Addr2], [ City], [ State], 'USA', [ ZIP],
null, null, null, null, null,
[ Phone], null, [ FAX], null,

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
@PracticeID,
GetDate(), GetDate(), 
1, 
'01', 
null, 
1,
[ID], @VendorImportID
from ImportInsWohl

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
	@PracticeID, 
	Fax, FaxExt,
	InsuranceCompanyID,
	VendorID, VendorImportID
from InsuranceCompany

select * into ImportPatientWohl1 from ImportPatientWohl


update ImportPatientWohl1 set 
	SecondInsuranceName=PrimaryInsuranceName,
	SecondGroupNumber=PrimaryGroupNumber,
	SecondMemberNumber=PrimaryMemberNumber,
	SecondGuarantorFirstName=PrimaryGuarantorFirstName,
	SecondGuarantorLastName=PrimaryGuarantorLastName,
	SecondGuarantorRelation=PrimaryGarantorRelation
where 
	MedicareID>'' or MedicalID>''

update ImportPatientWohl1 set 
	PrimaryInsuranceName=@Medicare,
	PrimaryGroupNumber=null,
	PrimaryMemberNumber=MedicareID,
	PrimaryGuarantorFirstName=null,
	PrimaryGuarantorLastName=null,
	PrimaryGarantorRelation=null
where 
	MedicareID>'' or MedicalID>''

-- insurance policy - Primary
insert into InsurancePolicy (
PatientCaseID, 
InsuranceCompanyPlanID, 
Precedence, PolicyNumber, GroupNumber, 
PolicyStartDate, PolicyEndDate, CardOnFile,
PatientRelationshipToInsured,

PracticeID, 
VendorID, VendorImportID)
select
(select PatientCaseID from PatientCase where patientID in (select PatientID from Patient where VendorID=Pat.ID)), 
(select InsuranceCompanyPlanID from InsuranceCompanyPlan where VendorID=(select ID from ImportInsWohl where RecordKey=PrimaryInsuranceName)),
1, PrimaryMemberNumber, PrimaryGroupNumber,
'2000-01-01', '2009-12-31', 0,
case PrimaryGarantorRelation
	when 'C' then 'C'
	when 'I' then 'S'
	when 'S' then 'U'
	else 'S'
end,

@PracticeID,
null, @VendorImportID

from ImportPatientWohl1 Pat
where RTrim(LTrim(PrimaryMemberNumber))>'' and PrimaryInsuranceName in (select RecordKey from ImportInsWohl)

-- insurance policy - Secondary
insert into InsurancePolicy (
PatientCaseID, 
InsuranceCompanyPlanID, 
Precedence, PolicyNumber, GroupNumber, 
PolicyStartDate, PolicyEndDate, CardOnFile,
PatientRelationshipToInsured,

PracticeID, 
VendorID, VendorImportID)
select
(select PatientCaseID from PatientCase where patientID in (select PatientID from Patient where VendorID=Pat.ID)), 
(select InsuranceCompanyPlanID from InsuranceCompanyPlan where VendorID=(select ID from ImportInsWohl where RecordKey=SecondInsuranceName)),
2, SecondMemberNumber, SecondGroupNumber,
'2000-01-01', '2009-12-31', 0,
case SecondGuarantorRelation
	when 'C' then 'C'
	when 'I' then 'S'
	when 'S' then 'U'
	else 'S'
end,

@PracticeID,
null, @VendorImportID

from ImportPatientWohl1 Pat
where RTrim(LTrim(SecondMemberNumber))>'' and SecondInsuranceName in (select RecordKey from ImportInsWohl)


-- Service Locations
--delete ServiceLocation where PracticeID=@PracticeID
--insert into ServiceLocation(PracticeID, [Name], 
--AddressLine1, AddressLine2, City, State, Country, ZipCode, 
--CreatedDate, ModifiedDate, PlaceOfServiceCode, BillingName, 
--Phone, PhoneExt, FaxPhone, FaxPhoneExt, HCFABox32FacilityID, CLIANumber)
--select @PracticeID, FacilityName, 
--Addr1, null, City, State, 'USA', ZIP,
--GetDate(), GetDate(), 11, FacilityName,
--null, null, null, null, null, null
--from ImportLocWohl

-- Referring Phys to patient
--update Patient set ReferringPhysicianID=(select DoctorID from Doctor where External=1 and PracticeID=@PracticeID and VendorID=(select ID from ImportReferringWohl where ))

-- Contract
declare @ContractID int
if not exists(select * from [Contract] where PracticeID=@PracticeID)
begin
	insert into [Contract] (PracticeID, CreatedDate, ModifiedDate, ContractName, Description, ContractType, EffectiveStartDate, EffectiveEndDate, PolicyValidator, NoResponseTriggerPaper, NoResponseTriggerElectronic, Notes, Capitated)
	values (@PracticeID, GetDate(), GetDate(), 'Standard', null, 'S', '2005-01-01', '2009-12-31', null, 45, 45, null, 0)
	set @ContractID=Scope_Identity()
end
else
	select top 1 @ContractID=ContractID from [Contract] where PracticeID=@PracticeID and ContractType='S' 

delete ContractFeeSchedule where ContractID=@ContractID
insert ContractFeeSchedule (CreatedDate, ModifiedDate, ContractID, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID)
select GetDate(), GetDate(), @ContractID, 'B', StdFee, 0, 0, 0, ProcedureCodeDictionaryID
from ImportFeeWohl S, ProcedureCOdeDictionary CD
where S.ProcedureCode=CD.ProcedureCode and Len(S.StdFee)>0

--end of script