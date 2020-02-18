
/*
-- drop table zz_Import_ScheduleFee
-- create table zz_Import_ScheduleFee(rowid int identity primary key, ProcedureCode varchar(50), Modifier varchar(16), ContractName varchar(250), Description varchar(250), Fee money )
-- create unique nonclustered index iux_zz_import_scheduleFee on zz_Import_ScheduleFee(procedureCode, modifier, ContractName )
-- drop index iux_zz_import_scheduleFee

-- delete zz_Import_ScheduleFee
insert into zz_Import_ScheduleFee ( ProcedureCode, Modifier, Description, ContractName, Fee)
SELECT 
	[CPT Code]
	,[Modifier]
	,[Description]
	,'Standard Fees'
	,[Standard Fees]
FROM [dbo].[zzz_import_davidOwens]
where isnumeric( [Standard Fees])=1


  ,[Standard Fees]
  ,[2009 Atlanta Medicare]
  ,[Cigna]
  ,[2008 Georgia Worker's Comp                                       ]
  ,[Blue Cross Blue Shield HMO POS]
  ,[Blue Cross Blue Sheild PPO]
  ,[Blue Cross Blue Sheild PAR]
  ,[Beech Street]
  ,[Atena Open PPO]
  ,[Aetna HMO]
  ,[Aetna Elect Choice EPO]
  ,[Aetna Golden Choice Plan]
  ,[Aetna Golden Choice Plan POS]
  ,[Aetna]
  ,[Aetna Managed Choice POS]
  ,[Coventry National Network]
  ,[Coventry HMO]
  ,[First Health]
  ,[Humana]
  ,[United Health Care PPO                              (Going to a New Fee Schedule on 11 15 2009)]
  ,[United Healthcare Choice Plus]
  ,[United Healthcare EPO]
  ,[United Healthcare Choice HMO]
  ,[United Healthcare Choice Plus HMO]
  ,[United Healthcare Select Plus HMO]
  ,[United Healthcare Select HMO]
  ,[NovaNet]
  ,[PHCS Multiplan]
  ,[2009 Tricare]




delete c
FROM [dbo].[zzz_import_davidOwens] c
where [CPT Code] in (
'70130',
'70150',
'70160')
and Modifier=''

update zz_Import_ScheduleFee
set Modifier='31-31' 
where modifier='31'

update zz_Import_ScheduleFee
set Modifier='51-51' 
where modifier='51'



-- 61-62, 21-24
insert into zz_Import_ScheduleFee ( ProcedureCode, Modifier, Description, ContractName, Fee)
select f.ProcedureCode, v.Modifier, f.ContractName, f.Description, f.Fee
from zz_Import_ScheduleFee f
	,( select 61 as modifier union all select 62 ) as v
where f.modifier = '61-62'

update zz_Import_ScheduleFee
set contractName=ltrim(rtrim([ContractName]))

INSERT INTO [superbill_2726_prod].[dbo].[Contract]
           ([PracticeID]
           ,[CreatedDate]
           ,[CreatedUserID]
           ,[ModifiedDate]
           ,[ModifiedUserID]
           ,[ContractName]
           ,[Description]
           ,[ContractType]
           ,[EffectiveStartDate]
           ,[EffectiveEndDate]
           ,[PolicyValidator]
           ,[NoResponseTriggerPaper]
           ,[NoResponseTriggerElectronic]
           ,[Notes]
           ,[Capitated]
           ,[AnesthesiaTimeIncrement])
select distinct
	1
	,getdate()
	,0
	,getdate()
	,0
	,ltrim(rtrim([ContractName]))
	,null
	,'S'
	,'2010-11-14 00:00:00.000'
	,'2010-11-14 00:00:00.000'
	,null [PolicyValidator]
	,45 as [NoResponseTriggerPaper]
	,45 as [NoResponseTriggerElectronic]
	,'imported' [Notes]
	,0 as [Capitated]
	,15 as [AnesthesiaTimeIncrement]
from zz_Import_ScheduleFee
where contractName not in (select contractName from contract)




*/


select *
from zz_Import_ScheduleFee
where procedureCode not in ( select procedureCode from procedureCodeDictionary )


-- 61-62, 21-24
select distinct f.modifier
from zz_Import_ScheduleFee f
where modifier not in ( select ProcedureModifierCode from dbo.ProcedureModifier )


-- 61-62, 21-24
select f.ProcedureCode, v.Modifier, f.ContractName, f.Description, f.Fee
from zz_Import_ScheduleFee f
	,( select 61 as modifier union all select 62 ) as v
where f.modifier = '61-62'



alter table dbo.zz_Import_ScheduleFee add procedureCodeDictionaryID int


update i
set procedureCodeDictionaryID = pcd.procedureCodeDictionaryID
from dbo.zz_Import_ScheduleFee i
	left join procedureCodeDictionary pcd 
		on pcd.procedureCode=cast(i.procedureCode as varchar(max))

insert into vendorImport( VendorName, Notes, VendorFormat)
values( 'Custom', 'from SF 96402', 'CSV' )

select * from vendorImport

-- MEDICARE = 15
begin tran

INSERT INTO ContractFeeSchedule(ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID, practiceRVU, malpracticeRVU, VendorImportID )
SELECT c.contractID, Modifier,'B', f.Fee, 0, 0, 0, f.ProcedureCodeDictionaryID, 0, 0, 2
FROM zz_Import_ScheduleFee f
	inner join contract c
		on c.contractName=f.contractName
		
		
		
-- rollback tran
-- commit tran
alter table ContractFeeSchedule add VendorImportID int
select * from ContractFeeSchedule

