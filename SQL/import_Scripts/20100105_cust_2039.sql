
use superbill_2039_prod
GO

/*
Practice Name: ADVANCED DERMATOLOGY & COSMETIC CARE (RASKIN OFFICE) 
File Name: RASKIN 2010 Southern California Area 18 Medicare Physician Fee Schedule(NOT FACILITY OR COMM).XLS 
Par Fee into Medicare Contract (Not Medicare - Facility) 
*/

/****** clean up

select *
into contractFeeSchedule_20100105
from contractFeeSchedule

delete contractFeeSchedule
where vendorImportID=23
	and contractID in (18, 17, 19)

*/


update dbo.zz_ContractFee_20100105_01
set Notes=nullif(Notes, '')
	,Modifier=nullif(Modifier,'')

select * from vendorImport
insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 99434, part2 ')

alter table dbo.zz_ContractFee_20100105_01 add rowid int identity(1,1) primary key clustered
alter table dbo.zz_ContractFee_20100105_02 add rowid int identity(1,1) primary key clustered
alter table dbo.zz_ContractFee_20100105_03 add rowid int identity(1,1) primary key clustered




begin tran

declare @contractID int, @vendorImportID int
select @contractID=18, @vendorImportID=24

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
from dbo.zz_ContractFee_20100105_01 i
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
from zz_ContractFee_20100105_01 i
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

update dbo.zz_ContractFee_20100105_02
set Notes=nullif(Notes, '')
	,Modifier=nullif(Modifier,'')



begin tran

declare @contractID int, @vendorImportID int
select @contractID=17, @vendorImportID=24

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
from dbo.zz_ContractFee_20100105_02 i
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
from zz_ContractFee_20100105_02 i
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



begin tran

declare @contractID int, @vendorImportID int
select @contractID=19, @vendorImportID=24

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
from dbo.zz_ContractFee_20100105_03 i
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
from zz_ContractFee_20100105_03 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[Procedure Code]

commit;





