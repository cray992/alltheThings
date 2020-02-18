DECLARE @ICToDelete TABLE(InsuranceCompanyID INT)
INSERT @ICToDelete(InsuranceCompanyID)
SELECT InsuranceCompanyID
FROM InsuranceCompany
WHERE CreatedDate>='4-4-06' AND VendorID IS NOT NULL

DECLARE @ICPToDelete TABLE(InsuranceCompanyPlanID INT)
INSERT @ICPToDelete(InsuranceCompanyPlanID)
SELECT InsuranceCompanyPlanID
FROM InsuranceCompanyPlan ICP INNER JOIN @ICToDelete ICD
ON ICP.InsuranceCompanyID=ICD.InsuranceCompanyID

DECLARE @DeletionExceptions TABLE(InsuranceCompanyPlanID INT, InsuranceCompanyID INT)
INSERT @DeletionExceptions(InsuranceCompanyPlanID, InsuranceCompanyID)
SELECT DISTINCT ICP.InsuranceCompanyPlanID, ICP.InsuranceCompanyID
FROM InsurancePolicy IP INNER JOIN InsuranceCompanyPlan ICP
ON IP.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID
WHERE PracticeID<>5

DELETE ICD
FROM @ICToDelete ICD INNER JOIN @DeletionExceptions DE
ON ICD.InsuranceCompanyID=DE.InsuranceCompanyID

DELETE ICPD
FROM @ICPToDelete ICPD INNER JOIN @DeletionExceptions DE
ON ICPD.InsuranceCompanyPlanID=DE.InsuranceCompanyPlanID

DELETE IP
FROM Patient P INNER JOIN PatientCase PC
ON P.PracticeID=PC.PracticeID AND P.PatientID=PC.PatientID
INNER JOIN InsurancePolicy IP
ON PC.PatientCaseID=IP.PatientCaseID
WHERE P.PracticeID=5 AND P.VendorID IS NOT NULL

DELETE PC
FROM Patient P INNER JOIN PatientCase PC
ON P.PracticeID=PC.PracticeID AND P.PatientID=PC.PatientID
WHERE P.PracticeID=5 AND P.VendorID IS NOT NULL

DELETE ICP
FROM InsuranceCompanyPlan ICP INNER JOIN @ICPToDelete ICPD
ON ICP.InsuranceCompanyPlanID=ICPD.InsuranceCompanyPlanID

DELETE IC
FROM InsuranceCompany IC INNER JOIN @ICToDelete ICD
ON IC.InsuranceCompanyID=ICD.InsuranceCompanyID



