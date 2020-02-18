SELECT 
	P.FirstName,
	P.MiddleName,
	P.LastName,
	P.Gender,
	P.AddressLine1,
	P.AddressLine2,
	P.City,
	P.State,
	P.ZipCode,
	P.HomePhone,
	P.WorkPhone + ISNULL(P.WorkPhoneExt,''),
	'' AS OtherPhone,
	P.EmailAddress,
	P.DOB,
	P.SSN,
	ICP.PlanName AS InsurancePlanName,
	'' AS LastVisitDate,
	P.PatientID,
	'Richard' AS ProviderFirstName,
	'A' AS ProviderMiddleName,
	'Bernstein' AS ProviderLastName
FROM dbo.Patient P
	left OUTER JOIN dbo.PatientInsurance PI
	ON P.PatientID = PI.PatientID
		AND 1 = PI.Precedence
	LEFT OUTER JOIN dbo.InsuranceCompanyPlan ICP 
	ON PI.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID
WHERE P.PracticeID = 54
