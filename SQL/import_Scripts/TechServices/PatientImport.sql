select * from Practice
insert into UserPractices (UserID, PracticeID) values (390, 3)

select * from Patient where PracticeID in (1, 3)

select * from ImpPat_Knobel where Len(PatNo)>5-->1
select * from ImpPat_Radha  where Len(PatNo)>5-->3
update ImpPat_Knobel set PAtNo='0'+PAtNo
update ImpPat_Radha set PAtNo='0'+PAtNo
update ImpPat_Knobel set PAtNo=Substring(PatNo, 2, 30) where Len(PatNo)>5 
update ImpPat_Radha set PAtNo=Substring(PatNo, 2, 30) where Len(PatNo)>5 

print Substring('012345', 2, 30)

select * into ImpPat_Knobel1 from ImpPat_Knobel
select * into ImpPat_Radha1 from ImpPat_Radha


alter table ImpPat_Radha drop column idno
GO
alter table ImpPat_Knobel add [ID] int Identity(1,1)
GO
alter table ImpPat_Radha add [ID] int Identity(10000,1)
GO

select * from ImpPat_Knobel where Len(FirstName)>64 
select * from ImpPat_Knobel where Len(LastName)>64 
select * from ImpPat_Knobel where Len(AddressLine1)>256 
select * from ImpPat_Knobel where Len(City)>128 
select * from ImpPat_Knobel where Len(State)>2 
select * from ImpPat_Knobel where Len(Sex)>1 
select * from ImpPat_Knobel where Len(BirthDate)>10

select * from ImpPat_Knobel where Len(SSN)>9
select * from ImpPat_Knobel where Len(Homephone)>10

select * from ImpPat_Radha where Len(FirstName)>64 
select * from ImpPat_Radha where Len(LastName)>64 
select * from ImpPat_Radha where Len(AddressLine1)>256 
select * from ImpPat_Radha where Len(City)>128 
select * from ImpPat_Radha where Len(State)>2 
select * from ImpPat_Radha where Len(Sex)>1 
select * from ImpPat_Radha where Len(BirthDate)>10

select * from ImpPat_Radha where Len(SSN)>9
select * from ImpPat_Radha where Len(Homephone)>10


select * from VendorImport

insert into VendorImport (VendorName, VendorFormat, Notes) values ('Patient Master file import', 'CSV file', 'case 2282 & 2283')


delete patient where PracticeID in (1, 3)
insert into Patient (
	PracticeID, 
	ReferringPhysicianID, 
	Prefix, 
	FirstName, 
	MiddleName, 
	LastName, 
	Suffix, 
	AddressLine1, 
	AddressLine2, 
	City, 
	State, 
	Country, 
	ZipCode,
	Gender, 
	MaritalStatus, 
	HomePhone,  
	HomePhoneExt, 
	DOB, 
	SSN, 
	ResponsibleDifferentThanPatient, 
	CreatedDate, 
	ModifiedDate,
	EmploymentStatus, 
	MedicalRecordNumber, 
	VendorID, 
	VendorImportID)

select 
	1 as PracticeID,
	NULL, -- Ref Phys
	'', -- Prefix
	LTrim(RTrim(FirstName)),
	LTrim(RTrim(MI)),
	LTrim(RTrim(LastName)),
	'', -- Suffix
	LTrim(RTrim(AddressLine1)),
	NULL, -- Addr 2
	LTrim(RTrim(City)),
	LTrim(RTrim(State)),
	NULL, -- contry
	Left(PatNo, 5),	-- ZIP
	LTrim(RTrim(Sex)),
	'U',	-- marital status
	Left(HomePhone, 10),
	NULL, -- home phone ext
	BirthDate,
	Left(SSN, 9),
	0,
	GetDate(), -- created date
	GetDate(), -- Modified date
	'U',
	AccountNo,
	[ID],
	1
from ImpPat_Knobel

union all
select 
	3 as PracticeID,
	NULL, -- Ref Phys
	'', -- Prefix
	LTrim(RTrim(FirstName)),
	LTrim(RTrim(MI)),
	LTrim(RTrim(LastName)),
	'', -- Suffix
	LTrim(RTrim(AddressLine1)),
	NULL, -- Addr 2
	LTrim(RTrim(City)),
	LTrim(RTrim(State)),
	NULL, -- contry
	Left(PatNo, 5),	-- ZIP
	LTrim(RTrim(Sex)),
	'U',	-- marital status
	Left(HomePhone, 10),
	NULL, -- home phone ext
	BirthDate,
	Left(SSN, 9),
	0,
	GetDate(), -- created date
	GetDate(), -- Modified date
	'U',
	AccountNo,
	[ID],
	1
from ImpPat_Radha


