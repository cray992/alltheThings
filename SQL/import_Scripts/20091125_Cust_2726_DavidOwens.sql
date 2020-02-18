
/*



-- drop table zz_master_import

SELECT top 0
	cast(null as varchar(50)) as ContractName
	,[Insurance Company]
	,[Insurance Plan]
	,[CPT Code]
	,[Modifier]
	,[Description]
	,[Allowed Amount]
	,[Standard Fees]
into zz_master_import
FROM [tempdb].[dbo].['Blue Cross Blue Shield HMO$']    

select
'
insert into zz_master_import (
	ContractName
	,[Insurance Company]
	,[Insurance Plan]
	,[CPT Code]
	,[Modifier]
	,[Description]
	,[Allowed Amount]
	,[Standard Fees]
)
SELECT 
	' + name + ' as ContractName
	,[Insurance Company]
	,[Insurance Plan]
	,[CPT Code]
	,[Modifier]
	,[Description]
	,[Allowed Amount]
	,[Standard Fees]
FROM [tempdb].[dbo].[' + name + ']
'
from sys.tables 
where name not like '#%'
	and name not like 'tmpAppointmentInterval'
	and name not like 'zz_master_import'
order by name


select *
from sys.tables 
where name not like '#%'
	and name not like 'tmpAppointmentInterval'
	and name not like 'zz_master_import'
order by name

  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Aetna Golden Choice Plan$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amounts]   ,[Standard Fees]  FROM [tempdb].[dbo].['Aetna Golden Choice Plan$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'David S Owens$' as ContractName   ,null as [Insurance Company]   ,null as [Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,null as [Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['David S Owens$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Aetna Elect Choice EPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Aetna Elect Choice EPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Aetna Golden Choice Plan POS$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Aetna Golden Choice Plan POS$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Aetna HMO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Aetna HMO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Aetna Managed Choice POS$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Aetna Managed Choice POS$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Aetna Open PPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Aetna Open PPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Aetna PPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Aetna PPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Atlanta Medicare$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Atlanta Medicare$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Beech Street PPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Beech Street PPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Blue Cross Blue Shield HMO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Blue Cross Blue Shield HMO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Blue Cross Blue Shield Par$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Blue Cross Blue Shield Par$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Blue Cross Blue Shield POS$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Blue Cross Blue Shield POS$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Blue Cross Blue Shield PPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Blue Cross Blue Shield PPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Cigna PPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Cigna PPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Coventry HMO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Coventry HMO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Coventry National Network$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Coventry National Network$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'First Health PPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['First Health PPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Georgia Workers Comp$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Georgia Workers Comp$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Humana Advantage Medicare HMO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Humana Advantage Medicare HMO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Humana Advantage Medicare POS$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Humana Advantage Medicare POS$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Humana Advantage Medicare PPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Humana Advantage Medicare PPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Humana EPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Humana EPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Humana HMO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Humana HMO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Humana POS$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Humana POS$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Humana PPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Humana PPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Multiplan PPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Multiplan PPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'NovaNet PPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['NovaNet PPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'PHCS PPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['PHCS PPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'Tricare PPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['Tricare PPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'United Health Care PPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['United Health Care PPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'United Healthca Choice Plus HMO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['United Healthca Choice Plus HMO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'United Healthcare Choice HMO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['United Healthcare Choice HMO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'United Healthcare Choice Plus$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['United Healthcare Choice Plus$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'United Healthcare EPO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['United Healthcare EPO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'United Healthcare Select HMO$' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['United Healthcare Select HMO$']  
  insert into zz_master_import (   ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  )  SELECT    'United Select Plus HMO $' as ContractName   ,[Insurance Company]   ,[Insurance Plan]   ,[CPT Code]   ,[Modifier]   ,[Description]   ,[Allowed Amount]   ,[Standard Fees]  FROM [tempdb].[dbo].['United Select Plus HMO $']  
  
  update zz_master_import
  set contractName=left(contractName, len(contractName)-1)
	  
delete zz_master_import
where [CPT Code] is null
	  
	  -- delete zz_master_import
	sp_rename 'zz_Import_ScheduleFee', 'zz_Import_ScheduleFee_20091128'
	sp_rename 'zz_Import_ScheduleFee', 'zz_Import_ScheduleFee_20091129'

	select * 
	into zz_Import_ScheduleFee
	from tempdb.dbo.zz_master_import
	
	

	update zz_Import_ScheduleFee
	set contractName=ltrim(rtrim([ContractName]))

	update f
	set  [Standard Fees]=replace( [Standard Fees], '$', '')
	from zz_Import_ScheduleFee f
	where [Standard Fees] like '%$%'
	
	-- save copy
	select *
	into contract_20091128
	from contract
	
	-- drop table ContractFeeSchedule_20091128
	select *
	into ContractFeeSchedule_20091128
	from ContractFeeSchedule
	
	delete contract where createdDate='2009-11-15 23:47:57.763'
  
	delete ContractFeeSchedule where vendorImportID = 3
  
	alter table contract add vendorImportID int
  
	insert into vendorImport(VendorName, VendorFormat, DateCreated, Notes)
	values( 'Custom', 'CSV', getdate(), 'From SF 96402' )

	select * from vendorImport
	
	
	
	

  */
  
  
  
	---- create contract template
	begin tran
	
	declare @vendorImportID int
	SET @vendorImportID=3

	INSERT INTO [dbo].[Contract]
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
	   ,[AnesthesiaTimeIncrement]
	   ,VendorImportID
	   )
	           
	select distinct
		1
		,getdate()
		,0
		,getdate()
		,0
		,ltrim(rtrim([ContractName]))
		,null
		,'P'
		,'2010-11-14 00:00:00.000'
		,'2010-11-14 00:00:00.000'
		,null [PolicyValidator]
		,45 as [NoResponseTriggerPaper]
		,45 as [NoResponseTriggerElectronic]
		,'imported' [Notes]
		,0 as [Capitated]
		,15 as [AnesthesiaTimeIncrement]
		,@VendorImportID
	from zz_Import_ScheduleFee
	where contractName not in (select contractName from contract)

	-- commit
  rollback



select vendorImportID, count(*)
from ContractFeeSchedule
group by vendorImportID


select distinct [Insurance Company], [Insurance Plan], ic.insuranceCompanyID,
	'exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'''',@program_code=N''CI'',@street_2=N'''',@deductible=0,@company_id=' + cast(insuranceCompanyID as varchar(32)) + ',@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'''',@phone_x=NULL,@contact_last_name=NULL,@city=N'''',@fax=NULL,@state=N'''',@notes=N''Imported 11/29/2009'',@contact_prefix=NULL,@name=N''' + [Insurance Plan] + ''',@country=N'''',@contact_first_name=NULL,@copay=0,@zip=N'''',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL'
from zz_Import_ScheduleFee z
	inner join insuranceCompany ic
		on ic.insuranceCompanyName=[Insurance Company]
where NOT exists(select * from insuranceCompanyPlan icp where icp.planName=z.[Insurance Plan] and icp.InsuranceCompanyID=ic.InsuranceCompanyID)
order by 1, 2

exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=4,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'Golden Choice Plan POS',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=4,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'HMO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=4,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'Managed Choice POS',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=4,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'Open PPO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=4,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'PPO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=31,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'Medicare',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=32,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'HMO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=32,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'Par',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=32,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'POS',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=32,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'PPO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=12,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'PPO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=14,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'HMO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=14,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'National Network',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=33,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'PPO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=34,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'Workers Comp',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=35,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'Advantage Medicare HMO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=35,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'Advantage Medicare POS',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=35,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'Advantage Medicare PPO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=35,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'EPO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=35,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'HMO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=35,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'POS',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=35,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'PPO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=36,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'PPO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=37,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'PPO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=38,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'PPO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=39,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'PPO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=29,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'Choice HMO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=29,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'Choice Plus',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=29,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'Choice Plus HMO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=29,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'PPO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=29,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'Select HMO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL
exec InsurancePlanDataProvider_CreateInsurancePlan @street_1=N'',@program_code=N'CI',@street_2=N'',@deductible=0,@company_id=29,@fax_x=NULL,@phone=NULL,@contact_suffix=NULL,@review_code=N'',@phone_x=NULL,@contact_last_name=NULL,@city=N'',@fax=NULL,@state=N'',@notes=N'Imported 11/29/2009',@contact_prefix=NULL,@name=N'Select Plus HMO',@country=N'',@contact_first_name=NULL,@copay=0,@zip=N'',@EClaimsAccepts=0,@practice_id=1,@contact_middle_name=NULL

declare @doctorID int
select @doctorID=1

insert into contractToDoctor( contractID, DoctorID )
SELECT distinct c.contractID, @doctorID as doctorID
FROM zz_Import_ScheduleFee f
	inner join contract c
		on c.contractName=f.contractName
where not exists(select * from contractToDoctor cd where cd.contractID=c.contractID and cd.doctorID=@doctorID )


declare @serviceLocationID int
select @serviceLocationID=1

insert into ContractToServiceLocation( contractID, ServiceLocationID )
SELECT distinct c.contractID, @serviceLocationID as ServiceLocationID
FROM zz_Import_ScheduleFee f
	inner join contract c
		on c.contractName=f.contractName
where not exists(select * from ContractToServiceLocation cd where cd.contractID=c.contractID and cd.serviceLocationID=@serviceLocationID )


insert into ContractToInsurancePlan( contractID, PlanID)
SELECT distinct c.contractID, insuranceCompanyPlanID as planID
FROM zz_Import_ScheduleFee f
	inner join contract c
		on c.contractName=f.contractName
	inner join insuranceCompany ic
		on ic.insuranceCompanyName=[Insurance Company]
	inner join insuranceCompanyPlan icp 
		on icp.planName=f.[Insurance Plan]
		and icp.insuranceCompanyID=ic.insuranceCompanyID
where not exists(select * from ContractToInsurancePlan cd where cd.contractID=c.contractID and cd.planID=icp.insuranceCompanyPlanID )







alter table zz_Import_ScheduleFee add ProcedureCode varchar(50)

update zz_Import_ScheduleFee
set ProcedureCode=[CPT Code]

select *
from zz_Import_ScheduleFee
where procedureCode not in ( select procedureCode from procedureCodeDictionary )


alter table dbo.zz_Import_ScheduleFee add procedureCodeDictionaryID int


update i
set procedureCodeDictionaryID = pcd.procedureCodeDictionaryID
from dbo.zz_Import_ScheduleFee i
	left join procedureCodeDictionary pcd 
		on pcd.procedureCode=cast(i.procedureCode as varchar(max))

alter table ContractFeeSchedule add VendorImportID int




-- MEDICARE = 15
begin tran

declare @vendorImportID int
set @vendorImportID=3

INSERT INTO ContractFeeSchedule(ContractID, Modifier, Gender, StandardFee, Allowable, ExpectedReimbursement, RVU, ProcedureCodeDictionaryID, practiceRVU, malpracticeRVU, VendorImportID )
SELECT c.contractID, Modifier,'B', isnull(f.[Standard Fees], 0), isnull([Allowed Amount], 0), 0, 0, f.ProcedureCodeDictionaryID, 0, 0, @vendorImportID
FROM zz_Import_ScheduleFee f
	inner join contract c
		on c.contractName=f.contractName

		
-- select @@trancount
-- rollback tran
-- commit tran




select * from contractFeeSchedule
where contractID=95

SELECT c.contractID, f.*
FROM zz_Import_ScheduleFee f
	inner join contract c
		on c.contractName=f.contractName
where contractID=95
and [CPT Code]='23350'