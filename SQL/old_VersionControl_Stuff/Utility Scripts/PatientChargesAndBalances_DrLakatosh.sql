-- PATIENT CHARGES AND BALANCES FOR DR. LAKATOSH
DECLARE @Patients TABLE(PatientID INT)
INSERT @Patients(PatientID)
SELECT PatientID
FROM Patient
WHERE PracticeID=51

DECLARE @Claims TABLE(PatientID INT, DateOfService DATETIME, ClaimID INT, ProcedureCode VARCHAR(16), OfficialName VARCHAR(300), Charge MONEY)
INSERT @Claims
SELECT C.PatientID, CAST(CONVERT(CHAR(10),ProcedureDateOfService,110) AS DATETIME) DateOfService, 
C.ClaimID, ProcedureCode, OfficialName, ServiceChargeAmount*ServiceUnitCount Charge
FROM @Patients P INNER JOIN Claim C
ON P.PatientID=C.PatientID
INNER JOIN EncounterProcedure EP
ON C.EncounterProcedureID=EP.EncounterProcedureID
INNER JOIN ProcedureCodeDictionary PCD
ON EP.ProcedureCodeDictionaryID=PCD.ProcedureCodeDictionaryID
LEFT JOIN VoidedClaims VC
ON C.ClaimID=VC.ClaimID
WHERE VC.ClaimID IS NULL

DECLARE @FinancialSummary TABLE(ClaimID INT, Adjustments MONEY, Payments MONEY)
INSERT @FinancialSummary
SELECT C.ClaimID, SUM(CASE WHEN ClaimTransactionTypeCode='ADJ' THEN Amount ELSE 0 END) Adjustments,
SUM(CASE WHEN ClaimTransactionTypeCode='PAY' THEN Amount ELSE 0 END) Payments
FROM @Claims C INNER JOIN ClaimAccounting CA
ON C.ClaimID=CA.ClaimID
GROUP BY C.ClaimID

SELECT C.*, Adjustments, Payments, Charge-(Adjustments+Payments) Balance
FROM @Claims C INNER JOIN @FinancialSummary FS
ON C.ClaimID=FS.ClaimID
