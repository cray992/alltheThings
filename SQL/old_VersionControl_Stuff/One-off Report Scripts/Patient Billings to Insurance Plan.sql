DECLARE @PracticeID INT
SET @PracticeID=3

CREATE TABLE #ClaimAssignments(TID INT IDENTITY(1,1), PatientID INT, ClaimID INT, PostingDate DATETIME, Type CHAR(1), ClaimTransactionID INT, InsuranceCompanyPlanID INT)
INSERT INTO #ClaimAssignments(PatientID, ClaimID, PostingDate, Type, ClaimTransactionID, InsuranceCompanyPlanID)
SELECT CAA.PatientID, CAA.ClaimID, CAA.PostingDate, CASE WHEN CAA.InsurancePolicyID IS NULL THEN 'P' ELSE 'I' END Type, ClaimTransactionID, InsuranceCompanyPlanID
FROM ClaimAccounting_Assignments CAA
WHERE CAA.PracticeID=@PracticeID
ORDER BY CAA.PatientID, CAA.ClaimID, CAA.PostingDate, ClaimTransactionID

CREATE TABLE #Assignments(TID INT IDENTITY(1,1), PatientID INT, ClaimID INT, PostingDate DATETIME, CurType CHAR(1), PrevType CHAR(1), StartID INT, EndID INT, Balance MONEY, InsuranceCompanyPlanID INT)
INSERT INTO #Assignments(PatientID, ClaimID, CA1.PostingDate, CurType, StartID, EndID, InsuranceCompanyPlanID)
SELECT CA1.PatientID, CA1.ClaimID, CA1.PostingDate, CA1.Type, CA1.ClaimTransactionID, CA2.ClaimTransactionID, CA1.InsuranceCompanyPlanID
FROM #ClaimAssignments CA1 LEFT JOIN #ClaimAssignments CA2
ON CA1.ClaimID=CA2.ClaimID AND CA1.TID+1=CA2.TID

UPDATE A SET PrevType=ISNULL(A2.CurType,'P')
FROM #Assignments A LEFT JOIN #Assignments A2 ON A.ClaimID=A2.ClaimID AND A.TID-1=A2.TID

DELETE #Assignments
WHERE InsuranceCompanyPlanID NOT IN (10,12,13,14) OR InsuranceCompanyPlanID IS NULL

DECLARE @PatBills TABLE(PatientID INT, InsuranceCompanyPlanID INT, PostingDate DATETIME)
INSERT @PatBills(PatientID, InsuranceCompanyPlanID, PostingDate)
SELECT DISTINCT A.PatientID, A.InsuranceCompanyPlanID, B.PostingDate
FROM ClaimAccounting_Billings B RIGHT JOIN #Assignments A
ON B.ClaimID=A.ClaimID AND B.ClaimTransactionID>A.StartID AND B.ClaimTransactionID<A.EndID
OR B.ClaimID=A.ClaimID AND B.ClaimTransactionID>A.StartID AND A.EndID IS NULL

SELECT RTRIM(ISNULL(P.LastName + ', ', '') + ISNULL(P.FirstName,'') + ISNULL(' ' + P.MiddleName, '')) PatientFullname,
ICP.PlanName, PostingDate
FROM @PatBills PB INNER JOIN Patient P
ON PB.PatientID=P.PatientID
INNER JOIN InsuranceCompanyPlan ICP
ON PB.InsuranceCompanyPlanID=ICP.InsuranceCompanyPlanID

DROP TABLE #ClaimAssignments
DROP TABLE #Assignments