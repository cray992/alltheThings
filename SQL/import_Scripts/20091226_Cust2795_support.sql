
use superbill_2795_prod
GO

select [Medical Record #]
from zzImport_20091226
where Gender is not null and sex is null



select * from insuranceCompany

select * from PracticeToInsuranceCompany

select * from insuranceCompanyPlan





select *
from zzImport_20091226 z
	inner join insuranceCompany ic
		on ic.insuranceCompanyName=[SecondaryInsurance]
where NOT exists(
		select * 
		from insuranceCompanyPlan icp 
		where icp.planName=z.SecondaryPlan 
			and icp.InsuranceCompanyID=ic.InsuranceCompanyID
			and isnull(icp.AddressLine1, '')=isnull([Secondary Insurance Address 1], '')
			and isnull(icp.AddressLine2, '')=isnull([Secondary Insurance Address 2], '')
			and isnull(icp.City, '')=isnull([Secondary Insurance City], '')
			and isnull(icp.ZipCode, '')=isnull(left([Secondary Insurance Postal Code],9), '')
			and isnull(icp.Phone, '')=isnull(SecondaryInsuranceMainPhone, '')
			and isnull(icp.PhoneExt, '')=isnull(SecondaryInsuranceMainPhoneExt, '')
		)
order by 1, 2

-- 2527
select PrimaryPlan
from zzImport_20091226
where PrimaryPlan is not null



-- 411
select *
from zzImport_20091226
where SecondaryPlan is not null
and rowID not in (select rowID from #t )



select 	rowID, w.*, icp.*
from zzImport_20091226 w
	inner join Patient p (nolock)
		on p.vendorID=w.rowID
	inner join PatientCase pc (nolock)
		on pc.patientID=p.patientID
		and pc.VendorID=p.VendorID
	inner join insuranceCompany ic (nolock)
		on ic.insuranceCompanyName=w.SecondaryInsurance
	inner join insuranceCompanyPlan icp (nolock)
		on icp.insuranceCompanyID=ic.insuranceCompanyID 
		and icp.PlanName=w.SecondaryPlan
where p.vendorImportID=1
	and isnull(icp.AddressLine1, '')=isnull([Secondary Insurance Address 1], '')
	and isnull(icp.AddressLine2, '')=isnull([Secondary Insurance Address 2], '')
	and isnull(icp.City, '')=isnull([Secondary Insurance City], '')
	and isnull(icp.ZipCode, '')=isnull(left([Secondary Insurance Postal Code],9), '')
	and isnull(icp.Phone, '')=isnull(SecondaryInsuranceMainPhone, '')
	and isnull(icp.PhoneExt, '')=isnull(SecondaryInsuranceMainPhoneExt, '')
group by rowID
having count(*) > 1
