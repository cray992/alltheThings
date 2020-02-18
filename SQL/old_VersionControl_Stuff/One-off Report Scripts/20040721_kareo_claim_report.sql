SELECT E.DateOfService,
	C.ClaimID, 
	C.ProcedureCode, 
	COALESCE(dbo.fn_ZeroLengthStringToNull(P.LastName) + ', ','') + 
		COALESCE(dbo.fn_ZeroLengthStringToNull(P.FirstName),'') AS Patient, 
	COALESCE(dbo.fn_ZeroLengthStringToNull(D.FirstName),'') + ' ' + 
		COALESCE(dbo.fn_ZeroLengthStringToNull(D.MiddleName) + ' ','') + 
		COALESCE(dbo.fn_ZeroLengthStringToNull(D.LastName),'') + 
		COALESCE(', ' + dbo.fn_ZeroLengthStringToNull(D.Degree),'') AS Provider,
	PS.Description AS ServiceLocation,
	IPN.PlanName AS PrimaryInsurance,
	COALESCE(C.ServiceUnitCount,0) * COALESCE(C.ServiceChargeAmount, 0) AS ServiceCharge,
	COALESCE(AA.AdjAmount, 0) AS Adjustment,
	COALESCE(PA.PayAmount, 0) AS Payment	
FROM dbo.Claim C
	INNER JOIN dbo.Patient P
	ON C.PatientID = P.PatientID 
	INNER JOIN dbo.Encounter E
	ON C.EncounterID = E.EncounterID
	INNER JOIN dbo.Doctor D
	ON E.DoctorID = D.DoctorID
	INNER JOIN dbo.PlaceOfService PS
	ON C.PlaceOfServiceCode = PS.PlaceOfServiceCode
	LEFT OUTER JOIN (
			SELECT CT.ClaimID, SUM(CT.Amount) AS AdjAmount
			FROM dbo.ClaimTransaction CT
			WHERE CT.ClaimTransactionTypeCode='ADJ'
			GROUP BY CT.ClaimID ) AS AA
	ON C.ClaimID = AA.ClaimID
	LEFT OUTER JOIN (
		SELECT CT.ClaimID, SUM(CT.Amount) AS PayAmount
		FROM dbo.ClaimTransaction CT
		WHERE CT.ClaimTransactionTypeCode='PAY'
		GROUP BY CT.ClaimID ) AS PA
	ON C.ClaimID = PA.ClaimID
	LEFT OUTER JOIN (
		SELECT EPI.EncounterID, ICP.PlanName
		FROM [dbo].[EncounterToPatientInsurance] EPI
			INNER JOIN dbo.PatientInsurance PI
			ON EPI.PatientInsuranceID = PI.PatientInsuranceID
			INNER JOIN dbo.InsuranceCompanyPlan ICP
			ON PI.InsuranceCompanyPlanID = ICP.InsuranceCompanyPlanID 
		WHERE EPI.Precedence = 1) AS IPN
	ON E.EncounterID = IPN.EncounterID
WHERE 
	C.ClaimID NOT IN
		(SELECT ClaimID 
		FROM dbo.ClaimTransaction CTV
		WHERE CTV.ClaimTransactionTypeCode = 'XXX')
	AND C.PracticeID = 40
ORDER BY E.DateOfService





