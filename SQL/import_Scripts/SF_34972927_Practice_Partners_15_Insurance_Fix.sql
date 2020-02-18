DECLARE @ChangePlanID INT
DECLARE @VendorImportID INT

SET @VendorImportID = 3

IF NOT EXISTS (SELECT * FROM dbo.InsuranceCompanyPlan WHERE PlanName = 'Check/Change Insurance')
BEGIN
	PRINT ''
	PRINT 'Inserting default "Check/Change Insurance" plan record into InsuranceCompanyPlan ...'
	INSERT INTO dbo.InsuranceCompanyPlan (
		PlanName,
		AddressLine1,
		AddressLine2,
		City,
		[State],
		Country,
		ZipCode,
		Phone,
		CreatedPracticeID,
		CreatedDate,
		CreatedUserID,
		ModifiedDate,
		ModifiedUserID,
		VendorID,
		VendorImportID,
		InsuranceCompanyID
	)
	SELECT
		InsuranceCompanyName
		,AddressLine1
		,AddressLine2
		,City
		,State
		,Country
		,ZipCode
		,Phone
		,CreatedPracticeID
		,GETDATE()
		,0
		,GETDATE()
		,0
		,0
		,@VendorImportID
		,InsuranceCompanyID
	FROM dbo.InsuranceCompany
	WHERE InsuranceCompanyName = 'Check/Change Insurance'

	PRINT CAST(@@ROWCOUNT AS VARCHAR(10)) + ' records inserted'
END

-- Grab the new ID
SET @ChangePlanID = (SELECT InsuranceCompanyPlanID FROM dbo.InsuranceCompanyPlan WHERE PlanName = 'Check/Change Insurance')

PRINT 'ChangePlanID = ' + CAST(@ChangePlanID AS VARCHAR(10))


DECLARE @InsPoliciesToChange TABLE (InsurancePolicyID INT)

INSERT INTO @InsPoliciesToChange
	SELECT DISTINCT InsurancePolicyID FROM
	(
		SELECT IP.Precedence, IP.InsurancePolicyID, IP.PolicyNumber, PC.PatientCaseID, p.PatientID, P.FirstName, p.LastName, p.VendorID, imp.pfirstname, imp.plastname, imp.pinsid, imp.account
		FROM 
			dbo.InsurancePolicy IP 
		INNER JOIN dbo.PatientCase PC ON IP.PatientCaseID = pc.PatientCaseID AND pc.VendorImportID = @VendorImportID
		INNER JOIN dbo.Patient P ON PC.PatientID = P.PatientID AND p.VendorImportID = @VendorImportID
		INNER JOIN [_import_3_15_BernsteinPatientDataPrimary] imp ON P.VendorID = imp.account AND ip.Precedence = 1
		WHERE 
			IP.VendorImportID = @VendorImportID AND
			imp.insurance_plan LIKE '%change%' OR
			(
				imp.insurance_plan <> 'No Insurance' AND
				imp.insurance_plan NOT IN (SELECT PlanName FROM dbo.InsuranceCompanyPlan) 
			)
		UNION
		SELECT IP.Precedence, IP.InsurancePolicyID, IP.PolicyNumber, PC.PatientCaseID, p.PatientID, P.FirstName, p.LastName, p.VendorID, imp.pfirstname, imp.plastname, imp.sinsid, imp.account
		FROM 
			dbo.InsurancePolicy IP 
		INNER JOIN dbo.PatientCase PC ON IP.PatientCaseID = pc.PatientCaseID AND pc.VendorImportID = @VendorImportID
		INNER JOIN dbo.Patient P ON PC.PatientID = P.PatientID AND p.VendorImportID = @VendorImportID
		INNER JOIN [_import_3_15_BernsteinPatientDataSecondar] imp ON P.VendorID = imp.account AND ip.Precedence = 2
		WHERE 
			IP.VendorImportID = @VendorImportID AND
			imp.insurance_plan LIKE '%change%' OR
			(
				imp.insurance_plan <> 'No Insurance' AND
				imp.insurance_plan NOT IN (SELECT PlanName FROM dbo.InsuranceCompanyPlan) 
			)
	) t1

-- Update the policies
/*
UPDATE dbo.InsurancePolicy 
SET 
	InsuranceCompanyPlanID = @ChangePlanID
WHERE 
	InsurancePolicyID IN (SELECT InsurancePolicyID FROM @InsPoliciesToChange)
	Print CAST(@@ROWCOUNT AS VARCHAR(10)) + ' insurance policies updated'

*/

