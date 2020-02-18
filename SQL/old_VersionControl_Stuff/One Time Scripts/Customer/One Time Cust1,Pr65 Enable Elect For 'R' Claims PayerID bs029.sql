update c set NonElectronicOverrideFlag=0
from claim c inner join claimaccounting_assignments caa
on c.claimid=caa.claimid
INNER JOIN InsuranceCompanyPlan ICP
ON caa.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
where c.practiceid=65 and claimstatuscode='R' and lastassignment=1 --and NonElectronicOverrideFlag=0
and insurancecompanyid IN (365,654) --AND C.PatientID NOT IN (282652,282738)



