/*
	Practice Name: ADVANCED DERMATOLOGY & COSMETIC CARE (RASKIN OFFICE) 

	File Name: RASKIN 2010 Southern California Area 18 Medicare Physician Fee Schedule(NOT FACILITY OR COMM).XLS 

	Par Fee into Medicare Contract (Not Medicare - Facility) 
*/


update dbo.zz_ContractFee_20091228_01
set Notes=nullif(Notes, '')
	,Modifier=nullif(Modifier,'')

insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 99434 ')

alter table dbo.zz_ContractFee_20091228_01 add rowid int identity(1,1) primary key clustered


update p
set VendorImportID=23
from ProcedureCodeDictionary p
where createdDate='2009-12-28 23:48:23.780'


begin tran

declare @contractID int, @vendorImportID int
select @contractID=18, @vendorImportID=23

insert into dbo.ProcedureCodeDictionary(
	ProcedureCode
	,CreatedDate
	,CreatedUserID
	,ModifiedDate
	,ModifiedUserID
	,TypeOfServiceCode
	,Active
	,OfficialName
	,VendorImportID
)

select distinct 
	[Procedure Code]
	,getdate()
	,0
	,getdate()
	,0
	,9
	,1
	,[Procedure Code]
	,@VendorImportID
from dbo.zz_ContractFee_20091228_01 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[Procedure Code]
where pcd.ProcedureCodeDictionaryID is null


INSERT INTO dbo.ContractFeeSchedule(
	CreatedDate
	,CreatedUserID
	,ModifiedDate
	,ModifiedUserID
	,ContractID
	,Gender
	,StandardFee
	,Allowable
	,ExpectedReimbursement
	,RVU
	,ProcedureCodeDictionaryID
	,PracticeRVU
	,MalpracticeRVU
	,VendorImportID
	,VendorID
	,Modifier
	)
select 
	getdate() CreatedDate
	,0 as CreatedUserID
	,getdate() ModifiedDate
	,0 ModifiedUserID
	,@contractID as ContractID
	,'B' Gender
	,[Par Fee] StandardFee
	,0 as Allowable
	,0 as ExpectedReimbursement
	,0 as RVU
	,pcd.ProcedureCodeDictionaryID
	,0 as PracticeRVU
	,0 as MalpracticeRVU
	,@VendorImportID as VendorImportID
	,rowID
	,Modifier
from zz_ContractFee_20091228_01 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[Procedure Code]
commit;

















--==============================================
--
--==============================================

/*
Practice Name: ADVANCED DERMATOLOGY & COSMETIC CARE (RASKIN OFFICE) 

File Name: RASKIN COMM FEE SCHEDULE 2010 Southern California Area 18 Medicare Physician Fee Schedule.XLS 

Comm Fee into General Contract 
*/

update dbo.zz_ContractFee_20091228_02
set Notes=nullif(Notes, '')
	,Modifier=nullif(Modifier,'')

begin tran

declare @contractID int, @vendorImportID int
select @contractID=17, @vendorImportID=23

insert into dbo.ProcedureCodeDictionary(
	ProcedureCode
	,CreatedDate
	,CreatedUserID
	,ModifiedDate
	,ModifiedUserID
	,TypeOfServiceCode
	,Active
	,OfficialName
	,VendorImportID
)

select distinct 
	[Procedure Code]
	,getdate()
	,0
	,getdate()
	,0
	,9
	,1
	,[Procedure Code]
	,@VendorImportID
from dbo.zz_ContractFee_20091228_02 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[Procedure Code]
where pcd.ProcedureCodeDictionaryID is null


INSERT INTO dbo.ContractFeeSchedule(
	CreatedDate
	,CreatedUserID
	,ModifiedDate
	,ModifiedUserID
	,ContractID
	,Gender
	,StandardFee
	,Allowable
	,ExpectedReimbursement
	,RVU
	,ProcedureCodeDictionaryID
	,PracticeRVU
	,MalpracticeRVU
	,VendorImportID
	,VendorID
	,Modifier
	)
select 
	getdate() CreatedDate
	,0 as CreatedUserID
	,getdate() ModifiedDate
	,0 ModifiedUserID
	,@contractID as ContractID
	,'B' Gender
	,[Comm Fee] StandardFee
	,0 as Allowable
	,0 as ExpectedReimbursement
	,0 as RVU
	,pcd.ProcedureCodeDictionaryID
	,0 as PracticeRVU
	,0 as MalpracticeRVU
	,@VendorImportID as VendorImportID
	,rowID
	,Modifier
from zz_ContractFee_20091228_02 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[Procedure Code]
-- rollback tran
commit;







--==============================================
--
--==============================================

/*
Practice Name: ADVANCED DERMATOLOGY & COSMETIC CARE (RASKIN OFFICE) 
File Name: RASKIN FACILITY FILTERED 2010 Southern California Area 18 Medicare Physician Fee Schedule.XLS 
Par Fee into Medicare-Facility Contract 
*/


alter table dbo.zz_ContractFee_20091228_03 add rowid int identity(1,1) primary key clustered

update dbo.zz_ContractFee_20091228_03
set Notes=nullif(Notes, '')
	,Modifier=nullif(Modifier,'')


begin tran

declare @contractID int, @vendorImportID int
select @contractID=19, @vendorImportID=23

insert into dbo.ProcedureCodeDictionary(
	ProcedureCode
	,CreatedDate
	,CreatedUserID
	,ModifiedDate
	,ModifiedUserID
	,TypeOfServiceCode
	,Active
	,OfficialName
	,VendorImportID
)

select distinct 
	[Procedure Code]
	,getdate()
	,0
	,getdate()
	,0
	,9
	,1
	,[Procedure Code]
	,@VendorImportID
from dbo.zz_ContractFee_20091228_03 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[Procedure Code]
where pcd.ProcedureCodeDictionaryID is null


INSERT INTO dbo.ContractFeeSchedule(
	CreatedDate
	,CreatedUserID
	,ModifiedDate
	,ModifiedUserID
	,ContractID
	,Gender
	,StandardFee
	,Allowable
	,ExpectedReimbursement
	,RVU
	,ProcedureCodeDictionaryID
	,PracticeRVU
	,MalpracticeRVU
	,VendorImportID
	,VendorID
	,Modifier
	)
select 
	getdate() CreatedDate
	,0 as CreatedUserID
	,getdate() ModifiedDate
	,0 ModifiedUserID
	,@contractID as ContractID
	,'B' Gender
	,[Par Fee] StandardFee
	,0 as Allowable
	,0 as ExpectedReimbursement
	,0 as RVU
	,pcd.ProcedureCodeDictionaryID
	,0 as PracticeRVU
	,0 as MalpracticeRVU
	,@VendorImportID as VendorImportID
	,rowID
	,Modifier
from zz_ContractFee_20091228_03 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[Procedure Code]

commit;

















--==============================================
--
--==============================================

/*
Practice Name: AESTHETIC SURGERY & LASER MED CENTER (RASKIN FACILITY) 
File Name: AMBULATORY SURGERY CENTER LOS ANGELES MEDICARE FEE SCHEDULE 37100.xls 
Amount into Medicare-Facility Contract 
*/

alter table dbo.zz_ContractFee_20091228_04 add rowid int identity(1,1) primary key clustered

update dbo.zz_ContractFee_20091228_04
set [HCPCS Modifier]=nullif([HCPCS Modifier], '')
	,Amount=replace(Amount, '$', '')


-- rollback tran
begin tran

declare @contractID int, @vendorImportID int
select @contractID=20, @vendorImportID=23

insert into dbo.ProcedureCodeDictionary(
	ProcedureCode
	,CreatedDate
	,CreatedUserID
	,ModifiedDate
	,ModifiedUserID
	,TypeOfServiceCode
	,Active
	,OfficialName
	,VendorImportID
)

select distinct 
	[HCPCS CPT Code]
	,getdate()
	,0
	,getdate()
	,0
	,9
	,1
	,[HCPCS CPT Code]
	,@VendorImportID
from dbo.zz_ContractFee_20091228_04 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[HCPCS CPT Code]
where pcd.ProcedureCodeDictionaryID is null


INSERT INTO dbo.ContractFeeSchedule(
	CreatedDate
	,CreatedUserID
	,ModifiedDate
	,ModifiedUserID
	,ContractID
	,Gender
	,StandardFee
	,Allowable
	,ExpectedReimbursement
	,RVU
	,ProcedureCodeDictionaryID
	,PracticeRVU
	,MalpracticeRVU
	,VendorImportID
	,VendorID
	,Modifier
	)
select 
	getdate() CreatedDate
	,0 as CreatedUserID
	,getdate() ModifiedDate
	,0 ModifiedUserID
	,@contractID as ContractID
	,'B' Gender
	,[Amount] StandardFee
	,0 as Allowable
	,0 as ExpectedReimbursement
	,0 as RVU
	,pcd.ProcedureCodeDictionaryID
	,0 as PracticeRVU
	,0 as MalpracticeRVU
	,@VendorImportID as VendorImportID
	,rowID
	,[HCPCS Modifier]
from zz_ContractFee_20091228_04 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[HCPCS CPT Code]

commit;











--==============================================
--
--==============================================

/*
Practice Name: AESTHETIC SURGERY & LASER MED CENTER (RASKIN FACILITY) 
File Name: AMBULATORY SURGERY CENTER LOS ANGELES COMMERCIAL FEE SCHEDULE 37100.xls 
Comm Fee into General Contract 
*/

alter table dbo.zz_ContractFee_20091228_05 add rowid int identity(1,1) primary key clustered

update dbo.zz_ContractFee_20091228_05
set [HCPCS Modifier]=nullif([HCPCS Modifier], '')
	,Amount=replace(Amount, '$', '')


-- rollback tran
begin tran

declare @contractID int, @vendorImportID int
select @contractID=21, @vendorImportID=23

insert into dbo.ProcedureCodeDictionary(
	ProcedureCode
	,CreatedDate
	,CreatedUserID
	,ModifiedDate
	,ModifiedUserID
	,TypeOfServiceCode
	,Active
	,OfficialName
	,VendorImportID
)

select distinct 
	[HCPCS CPT Code]
	,getdate()
	,0
	,getdate()
	,0
	,9
	,1
	,[HCPCS CPT Code]
	,@VendorImportID
from dbo.zz_ContractFee_20091228_05 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[HCPCS CPT Code]
where pcd.ProcedureCodeDictionaryID is null


INSERT INTO dbo.ContractFeeSchedule(
	CreatedDate
	,CreatedUserID
	,ModifiedDate
	,ModifiedUserID
	,ContractID
	,Gender
	,StandardFee
	,Allowable
	,ExpectedReimbursement
	,RVU
	,ProcedureCodeDictionaryID
	,PracticeRVU
	,MalpracticeRVU
	,VendorImportID
	,VendorID
	,Modifier
	)
select 
	getdate() CreatedDate
	,0 as CreatedUserID
	,getdate() ModifiedDate
	,0 ModifiedUserID
	,@contractID as ContractID
	,'B' Gender
	,[COMM FEE] StandardFee
	,0 as Allowable
	,0 as ExpectedReimbursement
	,0 as RVU
	,pcd.ProcedureCodeDictionaryID
	,0 as PracticeRVU
	,0 as MalpracticeRVU
	,@VendorImportID as VendorImportID
	,rowID
	,[HCPCS Modifier]
from zz_ContractFee_20091228_05 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[HCPCS CPT Code]

commit;


RETURN




/*
delete ContractFeeSchedule
where vendorImportID=23


select count(*)
from ContractFeeSchedule
where vendorImportID=23
*/