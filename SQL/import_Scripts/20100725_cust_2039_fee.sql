
select * from practice order by name

-- 56, MEDICARE-2010
-- 57, GENERAL-2010
select * from contract where practiceID=18

insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 127151')

select * from vendorImport order by 1 desc

select *
into ContractFeeSchedule_20100725
from ContractFeeSchedule

delete contractfeeSchedule
where contractId in (56, 57)



-- vendorId: 40

--alter table dbo.zz_import_20100725_fee_commerical add rowid int identity(1,1)
--alter table dbo.zz_import_20100725_fee_medicare add rowid int identity(1,1)

begin tran


	-- MEDICARE - 2010
	declare @vendorImportID int, @contractID int
	select @vendorImportID=40, @contractID=56
	

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
		i.Code
		,getdate()
		,0
		,getdate()
		,0
		,9
		,1
		,i.Code
		,@vendorImportID
	from dbo.zz_import_20100725_fee_medicare i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.Code
	where pcd.ProcedureCodeDictionaryID is null
		and i.code is not null


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
		,@contractID
		,'B' Gender
		,cast(fee as money) StandardFee
		,0 as Allowable
		,0 as ExpectedReimbursement
		,0 as RVU
		,pcd.ProcedureCodeDictionaryID
		,0 as PracticeRVU
		,0 as MalpracticeRVU
		,@VendorImportID as VendorImportID
		,rowID
		,null Modifier
	from dbo.zz_import_20100725_fee_medicare i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.Code

	
-- commit;
-- rollback tran


GO




	-- 57, GENERAL-2010
	declare @vendorImportID int, @contractID int
	select @vendorImportID=40, @contractID=57
	

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
		i.Code
		,getdate()
		,0
		,getdate()
		,0
		,9
		,1
		,i.Code
		,@vendorImportID
	from dbo.zz_import_20100725_fee_commerical i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.Code
	where pcd.ProcedureCodeDictionaryID is null
		and i.code is not null


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
		,@contractID
		,'B' Gender
		,cast(fee as money) StandardFee
		,0 as Allowable
		,0 as ExpectedReimbursement
		,0 as RVU
		,pcd.ProcedureCodeDictionaryID
		,0 as PracticeRVU
		,0 as MalpracticeRVU
		,@VendorImportID as VendorImportID
		,rowID
		,null Modifier
	from dbo.zz_import_20100725_fee_commerical i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.Code

	