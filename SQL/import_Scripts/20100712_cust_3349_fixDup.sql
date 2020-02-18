RETURN

select * from vendorImport

select * from practice

select *
into insuranceCompany_20100712
from insuranceCompany

select distinct p.practiceID, p.name
from practice p
	inner join patient pp
		on pp.practiceID=p.practiceID
where vendorImportId=3
order by 2

select icp.*
into zz_datafix_dupInsuranceCompanyPlan
from insuranceCompany ic
	inner join insuranceCompanyPlan icp
		on icp.insuranceCompanyId=ic.insuranceCompanyId
where ic.vendorImportId=3

select ic.*
into zz_datafix_dupInsuranceCompany
from insuranceCompany ic
where ic.vendorImportId=3


alter table zz_datafix_dupInsuranceCompanyPlan add master_insuraceCompanyPlanId int

update zz
set master_insuraceCompanyPlanId=icp.insuranceCompanyPlanId
from zz_datafix_dupInsuranceCompanyPlan zz
	inner join insuranceCompanyPlan icp
		on icp.planName=zz.planName
where icp.insuranceCompanyId not in (
	select insuranceCompanyId from zz_datafix_dupInsuranceCompany
	) 

delete zz_datafix_dupInsuranceCompanyPlan
where master_insuraceCompanyPlanId is null


delete zz_datafix_dupInsuranceCompany
where insuranceCompanyId not in (select insuranceCompanyId from zz_datafix_dupInsuranceCompanyPlan )



/*
patientID: 552369,  552401
*/

select pc.*
from insurancePolicy ip
	inner join zz_datafix_dupInsuranceCompanyPlan z
		on ip.insuranceCompanyPlanId=z.insuranceCompanyPlanId
	inner join patientcase pc
		on pc.patientCaseId=ip.patientCaseId
where ip.insuranceCompanyPlanId=2179
	and ip.practiceId=9
	
	
update ip
set insuranceCompanyPlanId=z.master_insuraceCompanyPlanId
from insurancePolicy ip
	inner join zz_datafix_dupInsuranceCompanyPlan z
		on ip.insuranceCompanyPlanId=z.insuranceCompanyPlanId

	
delete icp
from  insuranceCompanyPlan icp
	inner join zz_datafix_dupInsuranceCompanyPlan z
		on icp.insuranceCompanyPlanId=z.insuranceCompanyPlanId
	

select *
into PracticeToInsuranceCompany_20100712
from PracticeToInsuranceCompany

delete p
from insuranceCompany ic
	inner join zz_datafix_dupInsuranceCompanyPlan z
		on z.insuranceCompanyId=ic.insuranceCompanyid
	inner join PracticeToInsuranceCompany p
		on p.insuranceCompanyId=z.insuranceCompanyId
		
	
delete ic
from insuranceCompany ic
	inner join zz_datafix_dupInsuranceCompanyPlan z
		on z.insuranceCompanyId=ic.insuranceCompanyid


select top 100 * 
from dbo.zz_import_20100625_Insurance
where primary_insurance in (
'Aetna grp 981106',
'Aetna Health Plans',
'Aetna HMO 981109',
'Aetna MC PPO POS',
'Aetna PPO 981109',
'Aetna Referral',
'Affinity Claims Dept',
'Affinity Health Plan tax',
'Affinity Unicare 2500'
)


update icp
set ReviewCode='R'
from insuranceCompany ic
	inner join insuranceCompanyPlan icp
		on icp.insuranceCompanyId=ic.insuranceCompanyId
where ic.vendorImportId=3
	and icp.ReviewCode <> 'R'
	
GO



select ic.*
from insuranceCompany ic
	inner join insuranceCompanyPlan icp
		on icp.insuranceCompanyId=ic.insuranceCompanyId
--where ic.vendorImportId=3
order by insuranceCompanyName

select * from vendorImport