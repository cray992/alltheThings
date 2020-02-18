
Update icp
SET icp.ReviewCode = ic.ReviewCode
from insuranceCompany ic 
	INNER JOIN InsuranceCompanyPlan icp on icp.InsuranceCompanyID = ic.InsuranceCompanyID
where ( icp.ReviewCode <> 'R' OR icp.ReviewCode  is null ) and icp.createdpracticeID is null

