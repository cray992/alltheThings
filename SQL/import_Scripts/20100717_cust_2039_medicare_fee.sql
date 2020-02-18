
/*
select p.name, c.contractName, * from contract c
	inner join practice p
		on p.practiceID=c.practiceId
-- where getdate() between isnull(effectiveStartDate, '1/1/2010') and isnull(effectiveEndDate, '12/31/2010')
order by 1, 2

declare @t table( contractId int, procedureCode varchar(255), Fee float )

insert into @t
select 19, [Procedure Code], [Fee]
from dbo.[zz_import_20100717_fee_19_ADCC FAC# MEDICARE FEE SCHEDULE$']


insert into @t
select 20, [Procedure Code], [Fee]
from dbo.[zz_import_20100717_fee_20_ASLMC MEDICARE FEE SCHEDULE$']

insert into @t
select 55, [Procedure Code], [Fee]
from dbo.[zz_import_20100717_fee_55_DELRAY MEDICARE FEE SCHEDULE$']

insert into @t
select 39, [Procedure Code], [Fee]
from dbo.[zz_import_20100717_fee_39_FINESMITH MEDICARE FEE SCHEDULE$']

insert into @t
select 44, [Procedure Code], [Fee]
from dbo.[zz_import_20100717_fee_44_KAUFMAN MEDICARE FEE SCHEDULE$']

insert into @t
select 46, [Procedure Code], [Fee]
from dbo.[zz_import_20100717_fee_46_KURGIS MEDICARE FEE SCHEDULE$']

insert into @t
select 40, [Procedure Code], [Fee]
from dbo.[zz_import_20100717_fee_40_Madison Medicare Fee Schedule]

insert into @t
select 42, [Procedure Code], [Fee]
from dbo.[zz_import_20100717_fee_42_RAND MEDICARE FEE SCHEDULE$']

insert into @t
select 47, [Code], [Fee]
from dbo.[zz_import_20100717_fee_47_RASKIN OFF# MEDICARE FEE SCHED#$']

insert into @t
select 41, [Procedure Code], [Fee]
from dbo.[zz_import_20100717_fee_41_SHAMBAN MEDICARE FEE SCHEDULE$']

insert into @t
select 51, [Procedure Code], [Fee]
from dbo.[zz_import_20100717_fee_51_SPOKANE MEDICARE FEE SCHEDULE$']

insert into @t
select 58, [Procedure Code], [Fee]
from dbo.[zz_import_20100717_fee_58_WILSON MEDICARE FEE SCHEDULE$']

insert into @t
select 45, [Procedure Code], [Fee]
from dbo.[zz_import_20100717_fee_45_YOUNG MEDICARE FEE SCHEDULE$']


select *
into zz_import_20100717_fee_master
from  @t
*/



insert into vendorImport( VendorName, VendorFormat, DateCreated, Notes)
values( 'Custom', 'xls', getdate(), 'sf 124693, 126211')


select * from vendorImport order by 1

alter table zz_import_20100717_fee_master add rowid int identity(1,1)


alter table zz_import_20100717_fee_master add amount money

update zz_import_20100717_fee_master
set Amount = round(fee, 2)

-- backup
select *
into ContractFeeSchedule_20100717
from ContractFeeSchedule

-- backup
select *
into ProcedureCodeDictionary_20100717
from ProcedureCodeDictionary


-- delete the current medicare fee

delete cfs
from ContractFeeSchedule cfs
where contractId in (select contractId from zz_import_20100717_fee_master )


begin tran

	-- MEDICARE - 2010
	declare @vendorImportID int
	select @vendorImportID=38
	

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
		i.procedureCode
		,getdate()
		,0
		,getdate()
		,0
		,9
		,1
		,i.procedureCode
		,@vendorImportID
	from dbo.zz_import_20100717_fee_master i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.procedureCode
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
		,i.contractID
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
	from zz_import_20100717_fee_master i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.procedureCode

	
-- commit;
-- rollback tran
select @@trancount
GO
