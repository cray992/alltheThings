--select count(*) from Doctor where PracticeID=1 and [ExterNal]=1

begin tran

-- replcate referring doctors from one practice to another
declare
	@SrcPracticeID int,
	@DestPracticeID int

set @SrcPracticeID=1
set @DestPracticeID=26 --3, 4, 7, 8, 10, 13, 14, 15, 16, 21, 22, 23, 24, 25, 26

-- delete old referring doctors
delete ProviderNumber where DoctorID in (select DoctorID from Doctor where [External]=1 and PracticeID=@DestPracticeID)
delete doctor where PracticeID=@DestPracticeID and [External]=1

select * into #Doctor from Doctor where PracticeID=@SrcPracticeID 

update #Doctor set PracticeID=@DestPracticeID, VendorID=DoctorID, VendorImportID=3, DepartmentID=null, [External]=1, OrigReferringPhysicianID=null

insert into Doctor (PracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, SSN, AddressLine1, AddressLine2, City, State, Country, ZipCode, HomePhone, HomePhoneExt, WorkPhone, WorkPhoneExt, PagerPhone, PagerPhoneExt, MobilePhone, MobilePhoneExt, DOB, EmailAddress, Notes, ActiveDoctor, CreatedDate, ModifiedDate,Degree, TaxonomyCode, VendorID, VendorImportID, DepartmentID, FaxNumber, FaxNumberExt, OrigReferringPhysicianID, [External])
select @DestPracticeID, Prefix, FirstName, MiddleName, LastName, Suffix, SSN, AddressLine1, AddressLine2, City, State, Country, ZipCode, HomePhone, HomePhoneExt, WorkPhone, WorkPhoneExt, PagerPhone, PagerPhoneExt, MobilePhone, MobilePhoneExt, DOB, EmailAddress, Notes, ActiveDoctor, GetDate(), GetDate(), Degree, TaxonomyCode, DoctorID, 3, null, FaxNumber, FaxNumberExt, OrigReferringPhysicianID, [External]
from #Doctor

insert into ProviderNumber (DoctorID, ProviderNumberTypeID, InsuranceCompanyPlanID, LocationID, ProviderNumber, AttachConditionsTypeID)
select 
	(select DoctorID from Doctor where PracticeID=@DestPracticeID and VendorID=PN.DoctorID),
	PN.ProviderNumberTypeID, PN.InsuranceCompanyPlanID, NULL, PN.ProviderNumber, PN.AttachConditionsTypeID
from ProviderNumber PN
where PN.DoctorID in (select distinct DoctorID from Doctor where [External]=1 and PracticeID=@SrcPracticeID)

drop table #Doctor

commit tran
