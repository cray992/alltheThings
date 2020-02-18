USE superbill_10972_prod
GO

/*
-- 8,072 cases
-- 16 without policies, (we'll set to self-pay)
-- 8,056 cases to re-classify.
-- Of those 8,056, 
--		8,054	have a #1 policy, and we'll use that to reclassify their payer scenario, and
--		2		ONLY have a #2 policy, and we'll use that to reclassify their payer scenario

-- Cases that have a #1 policy - use the ins code from the #1 policy
SELECT pc.PatientCaseID, ip.PolicyNumber, icp.PlanName, pc.PayerScenarioID AS 'Assumed Payer Scenario ID', ps.PayerScenarioID AS 'Correct Payer Scenario ID', ps.Name
FROM PatientCase pc
INNER JOIN InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 1
INNER JOIN dbo.InsuranceCompanyPlan icp ON ip.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
INNER JOIN dbo.[_import_20120622_Insurance] impIns ON icp.VendorID = impIns.ins_code
INNER JOIN dbo.PayerScenario ps ON impIns.payer_scenario = ps.Name

-- Cases that don't have a #1 policy but have a #2 policy - use the ins code from the #2 policy
SELECT pc.PatientCaseID, ip.PolicyNumber, icp.PlanName, pc.PayerScenarioID AS 'Assumed Payer Scenario ID', ps.PayerScenarioID AS 'Correct Payer Scenario ID', ps.Name
FROM PatientCase pc
INNER JOIN InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 2
INNER JOIN dbo.InsuranceCompanyPlan icp ON ip.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
INNER JOIN dbo.[_import_20120622_Insurance] impIns ON icp.VendorID = impIns.ins_code
INNER JOIN dbo.PayerScenario ps ON impIns.payer_scenario = ps.Name
WHERE pc.PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE Precedence = 1)
*/

BEGIN TRAN


	DECLARE @CasePayerScenarios TABLE
	(
		PatientCaseID INT NOT NULL,
		PayerScenarioID INT NOT NULL
	)

	INSERT INTO @CasePayerScenarios
		SELECT PatientCaseID, PayerScenarioID FROM
		(
			-- Cases that have a #1 policy - use the ins code from the #1 policy
			SELECT pc.PatientCaseID, ps.PayerScenarioID
			FROM PatientCase pc
			INNER JOIN InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 1
			INNER JOIN dbo.InsuranceCompanyPlan icp ON ip.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
			INNER JOIN dbo.[_import_20120622_Insurance] impIns ON icp.VendorID = impIns.ins_code
			INNER JOIN dbo.PayerScenario ps ON impIns.payer_scenario = ps.Name
			UNION ALL
			-- Cases that don't have a #1 policy but have a #2 policy - use the ins code from the #2 policy
			SELECT pc.PatientCaseID, ps.PayerScenarioID
			FROM PatientCase pc
			INNER JOIN InsurancePolicy ip ON pc.PatientCaseID = ip.PatientCaseID AND ip.Precedence = 2
			INNER JOIN dbo.InsuranceCompanyPlan icp ON ip.InsuranceCompanyPlanID = icp.InsuranceCompanyPlanID
			INNER JOIN dbo.[_import_20120622_Insurance] impIns ON icp.VendorID = impIns.ins_code
			INNER JOIN dbo.PayerScenario ps ON impIns.payer_scenario = ps.Name
			WHERE pc.PatientCaseID NOT IN (SELECT PatientCaseID FROM dbo.InsurancePolicy WHERE Precedence = 1)
		) AS t1
		ORDER BY PatientCaseID
	
	-- UPDATE THE CASES (OMG I HOPE I HAVE MY SYNTAX RIGHT HERE)
	UPDATE 
		dbo.PatientCase
	SET	
		PatientCase.PayerScenarioID = [@CasePayerScenarios].PayerScenarioID
	FROM
		@CasePayerScenarios
	WHERE
		PatientCase.PatientCaseID = [@CasePayerScenarios].PatientCaseID
		
	
COMMIT TRAN
