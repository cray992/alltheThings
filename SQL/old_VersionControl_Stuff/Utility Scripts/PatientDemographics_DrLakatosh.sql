-- PATIENT DEMOGRAPHICS EXPORT FOR DR. LAKATOSH
	DECLARE @Patients TABLE(PatientID INT)
	INSERT @Patients
	SELECT PatientID
	FROM Patient
	WHERE PracticeID=51


	DECLARE @PatientCases TABLE(PatientID INT, PatientCaseID INT)
	INSERT INTO @PatientCases(PatientID, PatientCaseID)
	SELECT PatientID, PatientCaseID
	FROM PatientCase
	WHERE PracticeID=51	

	SELECT	
		P.PatientID,
		PC.PatientCaseID,
		P.FirstName as PatientFirstName,
		P.LastName as PatientLastName,
		P.AddressLine1 as PatientAddress1,
		P.AddressLine2 as PatientAddress2,
		P.City as PatientCity,
		P.State as PatientState,
		P.ZipCode as PatientZipCode,
		P.HomePhone as PatientHomePhone,
		P.WorkPhone as PatientWorkPhone,
		P.SSN as PatientSSN,
		REPLACE(CONVERT(char(10), P.DOB,101),'/','') as PatientDOB,
		P.Gender as PatientGender,
		RP.Prefix as ReferringPhysicianPrefix,
		RP.FirstName as ReferringPhysicianFirstName,
		RP.LastName as ReferringPhysicianLastName,
		RP.Suffix as ReferringPhysicianSuffix,
		RP.UPIN as ReferringPhysicianUPIN,
		RP.AddressLine1 as ReferringPhysicianAddress1,
		RP.AddressLine2 as ReferringPhysicianAddress2,
		RP.City as ReferringPhysicianCity,
		RP.State as ReferringPhysicianState,
		RP.ZipCode as ReferringPhysicianZipCode,
		RP.WorkPhone as ReferringPhysicianWorkPhone,
		RP.FaxPhone as ReferringPhysicianFax,
		E1.EmployerName as PrimaryEmployerName,
		--'' as PrimaryEmployerContact,
		E1.AddressLine1 as PrimaryEmployerAddress1,
		E1.AddressLine2 as PrimaryEmployerAddress2,
		E1.City as PrimaryEmployerCity,
		E1.State as PrimaryEmployerState,
		E1.ZipCode as PrimaryEmployerZipCode,
		--'' as PrimaryEmployerPhone,
		--'' as PrimaryEmployerFax,
		E2.EmployerName as SecondaryEmployerName,
		--'' as SecondaryEmployerContact,
		--E2.AddressLine1 as SecondaryEmployerAddress1,
		--E2.AddressLine2 as SecondaryEmployerAddress2,
		--E2.City as SecondaryEmployerCity,
		--E2.State as SecondaryEmployerState,
		--E2.ZipCode as SecondaryEmployerZipCode,
		--'' as SecondaryEmployerPhone,
		--'' as SecondaryEmployerFax, 
		PI1.GroupNumber as PrimaryInsuranceGroup,
		PI1.PolicyNumber as PrimaryInsurancePolicy,
		ICP1.PlanName as PrimaryInsurancePlanName,
		ICP1.AddressLine1 as PrimaryInsuranceAddress1,
		ICP1.AddressLine2 as PrimaryInsuranceAddress2,
		ICP1.City as PrimaryInsuranceCity,
		ICP1.State as PrimaryInsuranceState,
		ICP1.ZipCode as PrimaryInsuranceZipCode,
		ICP1.Phone as PrimaryInsurancePhone,
		ICP1.Fax as PrimaryInsuranceFax,
		PI2.GroupNumber as SecondaryInsuranceGroup,
		PI2.PolicyNumber as SecondaryInsurancePolicy,
		ICP2.PlanName as SecondaryInsurancePlanName,
		ICP2.AddressLine1 as SecondaryInsuranceAddress1,
		ICP2.AddressLine2 as SecondaryInsuranceAddress2,
		ICP2.City as SecondaryInsuranceCity,
		ICP2.State as SecondaryInsuranceState,
		ICP2.ZipCode as SecondaryInsuranceZipCode,
		ICP2.Phone as SecondaryInsurancePhone,
		ICP2.Fax as SecondaryInsuranceFax,
		PI3.GroupNumber as TertiaryInsuranceGroup,
		PI3.PolicyNumber as TertiaryInsurancePolicy,
		ICP3.PlanName as TertiaryInsurancePlanName,
		ICP3.AddressLine1 as TertiaryInsuranceAddress1,
		ICP3.AddressLine2 as TertiaryInsuranceAddress2,
		ICP3.City as TertiaryInsuranceCity,
		ICP3.State as TertiaryInsuranceState,
		ICP3.ZipCode as TertiaryInsuranceZipCode,
		ICP3.Phone as TertiaryInsurancePhone,
		ICP3.Fax as TertiaryInsuranceFax
		--RP.ReferringPhysicianID,
		--PE1.PatientEmployerID as PrimaryEmployerID,
		--PE2.PatientEmployerID as SecondaryEmployerID,
		--PI1.InsuranceCompanyPlanID as PrimaryInsuranceID,
		--PI2.InsuranceCompanyPlanID as SecondaryInsuranceID,
		--PI3.InsuranceCompanyPlanID as TertiaryInsuranceID
	FROM	[dbo].[Patient] P
		INNER JOIN @Patients PS ON P.PatientID = PS.PatientID		
		LEFT OUTER JOIN dbo.ReferringPhysician RP
		ON P.ReferringPhysicianID = RP.ReferringPhysicianID
		LEFT OUTER JOIN dbo.PatientEmployer PE1
		ON P.PatientID = PE1.PatientID
			AND 1 = PE1.Precedence 
		LEFT OUTER JOIN dbo.Employers E1 ON PE1.EmployerID = E1.EmployerID
		LEFT OUTER JOIN dbo.PatientEmployer PE2
		ON P.PatientID = PE2.PatientID
			AND 2 = PE2.Precedence 
		LEFT OUTER JOIN dbo.Employers E2 ON PE2.EmployerID = E2.EmployerID
		LEFT JOIN @PatientCases PC ON P.PatientID=PC.PatientID
		LEFT OUTER JOIN InsurancePolicy PI1
		ON PC.PatientCaseID=PI1.PatientCaseID
		AND 1 = PI1.Precedence
		LEFT OUTER JOIN dbo.InsuranceCompanyPlan ICP1
		ON PI1.InsuranceCompanyPlanID = ICP1.InsuranceCompanyPlanID
		LEFT OUTER JOIN InsurancePolicy PI2
		ON PC.PatientCaseID=PI2.PatientCaseID
			AND 2 = PI2.Precedence
		LEFT OUTER JOIN dbo.InsuranceCompanyPlan ICP2
		ON PI2.InsuranceCompanyPlanID = ICP2.InsuranceCompanyPlanID
		LEFT OUTER JOIN InsurancePolicy PI3
		ON PC.PatientCaseID=PI3.PatientCaseID
			AND 3 = PI3.Precedence
		LEFT OUTER JOIN dbo.InsuranceCompanyPlan ICP3
		ON PI3.InsuranceCompanyPlanID = ICP3.InsuranceCompanyPlanID

	ORDER BY PatientLastName
	