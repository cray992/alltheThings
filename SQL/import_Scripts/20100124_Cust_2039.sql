
insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 101306 ')


select * from vendorImport order by 1 desc

alter table dbo.zz_ContractFeeSchedule_20100124 add rowid int identity(1,1) primary key clustered

select * from practice order by name
select * from contract where practiceID=16

update zz_ContractFeeSchedule_20100124
set Modifier=nullif(Modifier, '')



-- ADVANCED DERMATOLGY & COSMETIC CARE (RASKIN OFFICE)
begin tran
declare @contractID int, @vendorImportID int
select 
	@contractID=22  -- WORK COMP
	,@vendorImportID=27

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
	,VendorID
)

select distinct 
	i.[ProcedureCode]
	,getdate()
	,0
	,getdate()
	,0
	,9
	,1
	,i.[ProcedureCode]
	,@VendorImportID
	,VendorID
from dbo.zz_ContractFeeSchedule_20100124 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[ProcedureCode]
where pcd.ProcedureCodeDictionaryID is null
	and isnumeric(Amount)=1

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
	,Amount StandardFee
	,0 as Allowable
	,0 as ExpectedReimbursement
	,0 as RVU
	,pcd.ProcedureCodeDictionaryID
	,0 as PracticeRVU
	,0 as MalpracticeRVU
	,@VendorImportID as VendorImportID
	,rowID
	,Modifier
from zz_ContractFeeSchedule_20100124 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[ProcedureCode]
WHERE isnumeric(Amount)=1

commit;





-- Aesthetic Surgery & Laser Med Center
begin tran
declare @contractID int, @vendorImportID int
select 
	@contractID=29  -- WORK COMP
	,@vendorImportID=27

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
	,VendorID
)

select distinct 
	i.[ProcedureCode]
	,getdate()
	,0
	,getdate()
	,0
	,9
	,1
	,i.[ProcedureCode]
	,@VendorImportID
	,VendorID
from dbo.zz_ContractFeeSchedule_20100124 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[ProcedureCode]
where pcd.ProcedureCodeDictionaryID is null
	and isnumeric(Amount)=1

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
	,Amount StandardFee
	,0 as Allowable
	,0 as ExpectedReimbursement
	,0 as RVU
	,pcd.ProcedureCodeDictionaryID
	,0 as PracticeRVU
	,0 as MalpracticeRVU
	,@VendorImportID as VendorImportID
	,rowID
	,Modifier
from zz_ContractFeeSchedule_20100124 i
	left join dbo.ProcedureCodeDictionary pcd
		on pcd.ProcedureCode=i.[ProcedureCode]
WHERE isnumeric(Amount)=1

commit;