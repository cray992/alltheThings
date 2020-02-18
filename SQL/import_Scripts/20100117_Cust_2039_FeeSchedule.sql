
/*
drop table dbo.zz_Import_10_Wilson_Default_2010
drop table dbo.zz_Import_10_Wilson_Medicare_2010

drop table dbo.zz_Import_11_KAUFMAN_CDC_DEFAULT_2010
drop table dbo.[zz_Import_11_KAUFMAN_CDC_MEDICARE 2010]

drop table dbo.zz_Import_12_Young_Default_2010
drop table dbo.zz_Import_12_Young_Medicare_2010

drop table dbo.zz_Import_13_Krugis_Medicare_2010
drop table dbo.zz_Import_13_Kurgis_Default_2010

drop table dbo.zz_Import_15_Raskin_Default_2010
drop table dbo.zz_Import_15_Raskin_Medicare_2010

drop table dbo.zz_Import_2_Finesmith_Default_2010
drop table dbo.zz_Import_2_Finesmith_Medicare_2010

drop table dbo.zz_Import_3_Madison_Medicare_2010
drop table dbo.zz_Import_3_Medison_Default_2010

drop table dbo.zz_Import_5_Shamban_Default_2010
drop table dbo.zz_Import_5_Shamban_Medicare_2010

drop table dbo.zz_Import_7_Rand_Default_2010
drop table dbo.zz_Import_7_Rand_Medicare_2010
*/



select * from sys.tables
where name like 'zz_import_%'
order by 1

insert into VendorImport(VendorName, VendorFormat, Notes )
values( 'Custom', 'xls', 'sf 100807' )

select * from VendorImport order by 1

-- drop table zz_import_ContractFee_20100117
create table zz_import_ContractFee_20100117(
	ProcedureCode varchar(255)
	,ProcedureCodeName varchar(255)
	,Fee varchar(255)
	,Modifier varchar(255)
	,PracticeID INT
	,ContractID INT
	, rowid int identity(1,1) primary key clustered
	)
	
	
	
insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Modifier
	,Fee
	,PracticeID
	,ContractID
	)
select
	Code
	,[Procedure Name]
	,Modifier
	,[Standard Fee]
	,2
	,1
from dbo.zz_import_2_Finesmith_Default_2010




insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Modifier
	,Fee
	,PracticeID
	,ContractID
	)
select
	Code
	,[Procedure Name]
	,Modifier
	,[Standard Fee]
	,2
	,24
from dbo.zz_import_2_Finesmith_Medicare_2010


insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Fee
	,PracticeID
	,ContractID
	)
select
	[Procedure Code]
	,Decscription
	,Charge
	,3
	,25
from dbo.zz_import_3_Madison_Medicare_2010


insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Fee
	,PracticeID
	,ContractID
	)
select
	[Procedure Code]
	,Decscription
	,Charge
	,3
	,3	
from dbo.zz_import_3_Medison_Default_2010


insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Fee
	,PracticeID
	,ContractID
	)
select
	Code
	,[Procedure Description]
	,FEE
	,5
	,5
from dbo.zz_import_5_Shamban_Default_2010


insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Fee
	,PracticeID
	,ContractID
	)
select
	Code
	,[Procedure Description]
	,FEE
	,5
	,26
from dbo.zz_import_5_Shamban_Medicare_2010



insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Modifier
	,Fee
	,PracticeID
	,ContractID
	)
select
	Code
	,[Procedure Description]
	,[Default Modifier]
	,FEE
	,7
	,7
from dbo.zz_import_7_Rand_Default_2010

insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Modifier
	,Fee
	,PracticeID
	,ContractID
	)
select
	Code
	,[Procedure Description]
	,[Default Modifier]
	,FEE
	,7
	,27
from dbo.zz_import_7_Rand_Medicare_2010



insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Modifier
	,Fee
	,PracticeID
	,ContractID
	)
select
	Code
	,[Procedure Description]
	,[Default Modifier]
	,FEE
	,8
	,6
from dbo.zz_import_10_Wilson_Default_2010


insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Modifier
	,Fee
	,PracticeID
	,ContractID
	)
select
	Code
	,[Procedure Description]
	,[Default Modifier]
	,FEE
	,8
	,28
from dbo.zz_import_10_Wilson_Medicare_2010


insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Modifier
	,Fee
	,PracticeID
	,ContractID
	)
select
	Code
	,[Procedure Name]
	,Modifier
	,[Standard Fee]
	,11
	,10
from dbo.zz_import_11_KAUFMAN_CDC_DEFAULT_2010



insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Modifier
	,Fee
	,PracticeID
	,ContractID
	)
select
	Code
	,[Procedure Name]
	,Modifier
	,[Standard Fee]
	,11
	,11
from dbo.zz_import_11_KAUFMAN_CDC_MEDICARE_2010


insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Modifier
	,Fee
	,PracticeID
	,ContractID
	)
select
	Code
	,[Procedure Name]
	,Modifier
	,[Standard Fee]
	,12
	,12
from dbo.zz_import_12_Young_Default_2010


insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Modifier
	,Fee
	,PracticeID
	,ContractID
	)
select
	Code
	,[Procedure Name]
	,Modifier
	,[Standard Fee]
	,12
	,13
from dbo.zz_import_12_Young_Medicare_2010



insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Modifier
	,Fee
	,PracticeID
	,ContractID
	)
select
	Code
	,[Procedure Name]
	,Modifier
	,[Standard Fee]
	,13
	,15
from dbo.zz_import_13_Krugis_Medicare_2010


insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,ProcedureCodeName
	,Modifier
	,Fee
	,PracticeID
	,ContractID
	)
select
	Code
	,[Procedure Name]
	,Modifier
	,[Standard Fee]
	,13
	,16
from dbo.zz_import_13_Kurgis_Default_2010


insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,Modifier
	,Fee
	,PracticeID
	,ContractID
	)
select
	[Procedure Code]
	,Modifier
	,[Par Fee]
	,15
	,17
from dbo.zz_import_15_Raskin_Default_2010


insert into zz_import_ContractFee_20100117(
	ProcedureCode
	,Modifier
	,Fee
	,PracticeID
	,ContractID
	)
select
	[Procedure Code]
	,Modifier
	,[Par Fee]
	,15
	,18
from dbo.zz_import_15_Raskin_Medicare_2010

-- check
select practiceID, contractID, count(*)
from zz_import_ContractFee_20100117
group by practiceID, contractID
order by 1, 2


delete zz_import_ContractFee_20100117
where ProcedureCode is null

update zz_import_ContractFee_20100117
set Modifier=nullif( Modifier, '')
where Modifier is not null



begin tran

	declare @vendorImportID int
	select @vendorImportID=26

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
	from dbo.zz_import_ContractFee_20100117 i
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
	from zz_import_ContractFee_20100117 i
		left join dbo.ProcedureCodeDictionary pcd
			on pcd.ProcedureCode=i.[ProcedureCode]
	where ( isnumeric(fee)=1
		and fee <> '-'
		)
	
-- commit;
-- rollback tran

select max(VendorImportID) from ContractFeeSchedule



-- Errors.
select p.Name, c.contractName, ProcedureCode, ProcedureCodeName, fee, 'Invalid Fee'
from zz_import_ContractFee_20100117 z
	inner join practice p 
		on p.practiceID=z.practiceID
	inner join contract c
		on c.contractID=z.contractID
where not( isnumeric(fee)=1
	and fee <> '-'
	)
	


GO

select * from zz_import_contract_2010 z
	inner join practice p on p.practiceID=z.practiceID


select distinct practiceID, cfs.contractID 
into zz_import_contract_2010
from ContractFeeSchedule cfs
	inner join contract c
		on c.contractID=cfs.contractID
where vendorImportID=26
order by 1, 2


begin tran

insert into contract (practiceID, ContractName, Description, ContractType, EffectiveStartDate, EffectiveEndDate, NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated, AnesthesiaTimeIncrement)
select c.practiceID, 'DEFAULT-2010', 'Imported by Kareo 1/23/2010', ContractType, '2010-01-01 23:49:19.190', '2010-12-31 23:59:59', NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated, AnesthesiaTimeIncrement
from contract c
	inner join zz_import_contract_2010 z
		on z.contractID=c.contractID
where contractType='S'

insert into contract (practiceID, ContractName, Description, ContractType, EffectiveStartDate, EffectiveEndDate, NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated, AnesthesiaTimeIncrement)
select c.practiceID, 'MEDICARE-2010', 'Imported by Kareo 1/23/2010', ContractType, '2010-01-01 23:49:19.190', '2010-12-31 23:59:59', NoResponseTriggerPaper, NoResponseTriggerElectronic, Capitated, AnesthesiaTimeIncrement
from contract c
	inner join zz_import_contract_2010 z
		on z.contractID=c.contractID
where contractType<>'S'

commit tran	
	

select *
into contract_20100123
from contract

-- drop table contractFeeSchedule_20100123
select *
into contractFeeSchedule_20100123
from contractFeeSchedule

update cfs
set contractID=cc.contractID
from contract c
	inner join zz_import_contract_2010 z
		on z.contractID=c.contractID
	inner join contract cc
		on cc.practiceID=c.practiceID
		and c.contractType=cc.ContractType
		and cc.createdDate between '1/23/2010' and '1/24/2010'
	inner join contractFeeSchedule cfs
		on cfs.contractID=c.contractID
		and cfs.vendorImportID=26

	
	
select distinct contractID from ContractFeeSchedule
where vendorImportID=26
	and contractID not in (
		2,
		3,
		5,
		7,
		8)

select * from ContractFeeSchedule
where vendorImportID=26


select * from contract
order by 1


