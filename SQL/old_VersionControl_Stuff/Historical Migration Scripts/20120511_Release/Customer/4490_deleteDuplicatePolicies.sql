------------------------------------------------------
-- !! THIS SHOULD ONLY BE APPLIED TO CUSTOMER 9136 !!
------------------------------------------------------

IF dbo.fn_GetCustomerID() = 9136
BEGIN

	-- Use active insurance policy
	UPDATE BE
	SET BE.PayerInsurancePolicyID = IP2.InsurancePolicyID
	FROM dbo.Bill_EDI AS BE
		INNER JOIN dbo.InsurancePolicy AS IP ON IP.InsurancePolicyID = BE.PayerInsurancePolicyID
		INNER JOIN dbo.InsurancePolicy AS IP2 ON IP2.PolicyNumber = IP.PolicyNumber 
			AND IP.PatientCaseID = IP2.PatientCaseID 
			AND IP2.Active = 1
	WHERE PayerInsurancePolicyID IN (
				SELECT IP.InsurancePolicyID
				FROM dbo.InsurancePolicy AS IP
					INNER JOIN dbo.InsurancePolicy AS IP2 ON IP.PolicyNumber = IP2.PolicyNumber
						AND COALESCE(IP.GroupNumber,'') = COALESCE(IP2.GroupNumber,'')
						AND IP.PatientCaseID = IP2.PatientCaseID
						AND IP.InsuranceCompanyPlanID = IP2.InsuranceCompanyPlanID
				WHERE IP.Active = 0 AND IP2.Active = 1
			)

	-- Delete duplicates
	DELETE dbo.InsurancePolicy
	WHERE InsurancePolicyID IN (
				SELECT IP.InsurancePolicyID
				FROM dbo.InsurancePolicy AS IP
					INNER JOIN dbo.InsurancePolicy AS IP2 ON IP.PolicyNumber = IP2.PolicyNumber
						AND COALESCE(IP.GroupNumber,'') = COALESCE(IP2.GroupNumber,'')
						AND IP.PatientCaseID = IP2.PatientCaseID
						AND IP.InsuranceCompanyPlanID = IP2.InsuranceCompanyPlanID
				WHERE IP.Active = 0 AND IP2.Active = 1
			)

END			