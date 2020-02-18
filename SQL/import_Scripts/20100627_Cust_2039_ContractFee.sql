
select * from practice
select * from contract where practiceID=19
select * from vendorImport order by 1


alter table dbo.zz_import_20100627_commerical add rowid int identity(1,1)
alter table dbo.zz_import_20100627_Medicare add rowid int identity(1,1)

insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 123185')


begin tran

	-- MEDICARE - 2010
	declare @vendorImportID int, @contractID int
	select @vendorImportID=37, @contractID=55
	

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
	from dbo.zz_import_20100627_Medicare i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.Code
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
		,@contractID
		,'B' Gender
		,cast(amount as money) StandardFee
		,0 as Allowable
		,0 as ExpectedReimbursement
		,0 as RVU
		,pcd.ProcedureCodeDictionaryID
		,0 as PracticeRVU
		,0 as MalpracticeRVU
		,@VendorImportID as VendorImportID
		,rowID
		,null Modifier
	from zz_import_20100627_Medicare i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.Code

	
-- commit;
-- rollback tran

GO



begin tran
	-- GENERAL - 2010
	declare @vendorImportID int, @contractID int
	select @vendorImportID=37, @contractID=54
	

-- delete ContractFeeSchedule where vendorImportID=36 and contractID=52
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
	from dbo.zz_import_20100627_commerical i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.Code
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
		,@contractID
		,'B' Gender
		,cast(amount as money) StandardFee
		,0 as Allowable
		,0 as ExpectedReimbursement
		,0 as RVU
		,pcd.ProcedureCodeDictionaryID
		,0 as PracticeRVU
		,0 as MalpracticeRVU
		,@VendorImportID as VendorImportID
		,rowID
		,null Modifier
	from dbo.zz_import_20100627_commerical i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.Code

commit;
