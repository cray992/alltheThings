-- 
/* 

-- drop table zz_import_ContractFee_20100207

select [Procedure Code] as ProcedureCode, [Modifier], [Par Fee] as Fee, 38 as contractID
into zz_import_ContractFee_20100207
from dbo.zz_import_20100207_2010GeneralFacilityRevised
union all
select  [Procedure Code], [Modifier], [Par Fee], 17 as contractID from dbo.zz_import_20100207_2010GeneralOfficeRevised
union all
select  [Procedure Code], [Modifier], [Par Fee], 19 as contractID from dbo.zz_import_20100207_2010MEDICARE_FACILITY_REVISED
union all
select  [Procedure Code], [Modifier], [Par Fee], 47 as contractID from dbo.zz_import_20100207_2010MedicareOfficeRevised


update zz_import_ContractFee_20100207
set Modifier=nullif( Modifier, '')
where Modifier is not null


alter table zz_import_ContractFee_20100207 add rowid int identity(1,1)
*/

insert into VendorImport(VendorName, VendorFormat, Notes )
values( 'Custom', 'xls', 'sf 102236' )

select * from vendorImport order by 1 desc

select * from zz_import_ContractFee_20100207

select distinct contractID
from ContractFeeSchedule where contractID in (select contractID from zz_import_ContractFee_20100207 )


select * into contractFeeSchedule_20100208 from contractFeeSchedule



begin tran

	delete contractFeeSchedule
	where contractID in (
	38,
	47,
	19,
	17)

	declare @vendorImportID int
	select @vendorImportID=29

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
		i.[ProcedureCode]
		,getdate()
		,0
		,getdate()
		,0
		,9
		,1
		,i.[ProcedureCode]
		,@vendorImportID
	from dbo.zz_import_ContractFee_20100207 i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.[ProcedureCode]
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
		,ContractID
		,'B' Gender
		,cast([Fee] as money) StandardFee
		,0 as Allowable
		,0 as ExpectedReimbursement
		,0 as RVU
		,pcd.ProcedureCodeDictionaryID
		,0 as PracticeRVU
		,0 as MalpracticeRVU
		,@VendorImportID as VendorImportID
		,rowID
		,Modifier
	from zz_import_ContractFee_20100207 i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.[ProcedureCode]
	order by fee
		
-- rollback tran
-- commit tran

select * from practice