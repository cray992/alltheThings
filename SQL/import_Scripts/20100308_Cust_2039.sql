/*
insert into VendorImport(VendorName, VendorFormat, Notes )
values( 'Custom', 'xls', 'sf 105807' )

select * from VendorImport order by 1 desc

alter table zz_import_contractFee_20100308_15 add rowID int identity(1,1)

select *
into contractFeeSchedule_20100309
from contractFeeSchedule

select *
from contractFeeSchedule cfs
where contractID=38

select * from contract where contractID=33

select * from contractFeeSchedule where vendorImportID=34

delete contractFeeSchedule where vendorImportID=34 and contractID=33


INSERT INTO [superbill_2039_prod].[dbo].[ContractFeeSchedule]
           ([CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[ContractID]
           ,[Modifier]
           ,[Gender]
           ,[StandardFee]
           ,[Allowable]
           ,[ExpectedReimbursement]
           ,[RVU]
           ,[ProcedureCodeDictionaryID]
           ,[DiagnosisCodeDictionaryID]
           ,[PracticeRVU]
           ,[MalpracticeRVU]
           ,[VendorImportID]
           ,[VendorID])
select [CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[ContractID]
           ,[Modifier]
           ,[Gender]
           ,[StandardFee]
           ,[Allowable]
           ,[ExpectedReimbursement]
           ,[RVU]
           ,[ProcedureCodeDictionaryID]
           ,[DiagnosisCodeDictionaryID]
           ,[PracticeRVU]
           ,[MalpracticeRVU]
           ,[VendorImportID]
           ,[VendorID]
from contractFeeSchedule_20100309 where contractID=33
*/



begin tran

	declare @vendorImportID int, @contractID int
	select @vendorImportID=33, @contractID=38
	
	delete contractFeeSchedule
	where contractID=@contractID

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
	from dbo.zz_import_contractFee_20100308_15 i
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
	from zz_import_contractFee_20100308_15 i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.[ProcedureCode]

	
-- commit;
-- rollback tran

select @@trancount