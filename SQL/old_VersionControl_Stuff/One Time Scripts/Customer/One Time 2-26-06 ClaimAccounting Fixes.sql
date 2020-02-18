CREATE TABLE #Billed(PracticeID INT, ClaimID INT)
INSERT INTO #Billed(PracticeID, ClaimID)
SELECT DISTINCT PracticeID, CT.ClaimID
FROM ClaimTransaction CT LEFT JOIN VoidedClaims VC
ON CT.ClaimID=VC.ClaimID
WHERE ClaimTransactionTypeCode='BLL' AND VC.ClaimID IS NULL

--CREATE TABLE #CT_AR(PracticeID INT, AR MONEY)
--INSERT INTO #CT_AR(PracticeID, AR)
--SELECT B.PracticeID,
--SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)-SUM(CASE WHEN ClaimTransactionTypeCode<>'CST' THEN Amount ELSE 0 END) AR
--FROM ClaimTransaction CT INNER JOIN #Billed B
--ON CT.PracticeID=B.PracticeID AND CT.ClaimID=B.ClaimID
--GROUP BY B.PracticeID
--
--CREATE TABLE #CA_AR(PracticeID INT, AR MONEY)
--INSERT INTO #CA_AR(PracticeID, AR)
--SELECT CA.PracticeID, SUM(ARAmount) AR
--FROM ClaimAccounting CA INNER JOIN #Billed B
--ON CA.PracticeID=B.PracticeID AND CA.ClaimID=B.ClaimID
--GROUP BY CA.PracticeID
--
--DECLARE @PracticesToReview TABLE(PracticeID INT)
--INSERT @PracticesToReview(PracticeID)
--SELECT CT.PracticeID
--FROM #CT_AR CT INNER JOIN #CA_AR CA
--ON CT.PracticeID=CA.PracticeID
--WHERE CT.AR<>CA.AR
--
--SELECT CT.PracticeID, CT.AR-CA.AR
--FROM #CT_AR CT INNER JOIN #CA_AR CA
--ON CT.PracticeID=CA.PracticeID
--WHERE CT.AR<>CA.AR

CREATE TABLE #CA_FirstBLL(PracticeID INT, ClaimID INT, ClaimTransactionID INT)
INSERT #CA_FirstBLL(PracticeID, ClaimID, ClaimTransactionID)
SELECT CA.PracticeID, CA.ClaimID, CA.ClaimTransactionID
FROM ClaimAccounting CA INNER JOIN #Billed B
ON CA.PracticeID=B.PracticeID AND CA.ClaimID=B.ClaimID
WHERE CA.ClaimTransactionTypeCode='BLL'

CREATE TABLE #CT_ToInsert(PracticeID INT, ClaimID INT, ProviderID INT, PatientID INT, 
						  ClaimTransactionID INT, ClaimTransactionTypeCode CHAR(3),
						  Status BIT, ProcedureCount INT, Amount MONEY, ARAmount MONEY, PostingDate DATETIME)
INSERT INTO #CT_ToInsert(PracticeID, ClaimID, ProviderID, PatientID, 
ClaimTransactionID, ClaimTransactionTypeCode, ProcedureCount, Amount, PostingDate)
SELECT CT.PracticeID, CT.ClaimID, CT.Claim_ProviderID ProviderID, CT.PatientID, 
CT.ClaimTransactionID, CT.ClaimTransactionTypeCode, 0, CT.Amount, CT.PostingDate
FROM ClaimTransaction CT LEFT JOIN ClaimAccounting CA
ON CT.PracticeID=CA.PracticeID AND CT.ClaimID=CA.ClaimID AND 
CT.ClaimTransactionID=CA.ClaimTransactionID
LEFT JOIN VoidedClaims VC
ON CT.ClaimID=VC.ClaimID
WHERE VC.ClaimID IS NULL AND CT.ClaimTransactionTypeCode IN('CST','PAY','ADJ') AND
CA.CLaimTransactionID IS NULL

--Set ARAmount to 0 if trans is before first BLL
UPDATE CT SET ARAmount=0
FROM #CT_ToInsert CT INNER JOIN #CA_FirstBLL CA
ON CT.PracticeID=CA.PracticeID AND CT.ClaimID=CA.ClaimID AND CT.ClaimTransactionID<CA.ClaimTransactionID

--Set ARAmount to -1*Amount if after first BLL
UPDATE CT SET ARAmount=-1*CT.Amount
FROM #CT_ToInsert CT INNER JOIN #CA_FirstBLL CA
ON CT.PracticeID=CA.PracticeID AND CT.ClaimID=CA.ClaimID AND CT.ClaimTransactionID>CA.ClaimTransactionID

--Set ARAmount to 0 if NULL, no BLL ever existed
UPDATE #CT_ToInsert SET ARAmount=0 WHERE ARAmount IS NULL

--Set Procedure Count if Trans is CST
UPDATE CT SET ProcedureCount=ServiceUnitCount
FROM #CT_ToInsert CT INNER JOIN Claim C
ON CT.PracticeID=C.PracticeID AND CT.ClaimID=C.ClaimID
INNER JOIN EncounterProcedure EP
ON C.EncounterProcedureID=EP.EncounterProcedureID
WHERE CT.ClaimTransactionTypeCode='CST'

--Set Status based on Claim ClaimStatusCode
UPDATE CT SET Status=CASE WHEN ClaimStatusCode<>'C' THEN 0 ELSE 1 END
FROM #CT_ToInsert CT INNER JOIN Claim C
ON CT.PracticeID=C.PracticeID AND CT.ClaimID=C.ClaimID

--Insert CT Trans that are missing from ClaimAccounting
INSERT INTO ClaimAccounting(PracticeID, ClaimID, ProviderID, PatientID, ClaimTransactionID, ClaimTransactionTypeCode, Status, ProcedureCount, Amount, ARAmount, PostingDate)
SELECT PracticeID, ClaimID, ProviderID, PatientID, ClaimTransactionID, ClaimTransactionTypeCode, Status, ProcedureCount, Amount, ARAmount, PostingDate
FROM #CT_ToInsert
ORDER BY PracticeID, ClaimTransactionID

--Clear the Amount and ARAmount from END trans in ClaimAccounting
UPDATE ClaimAccounting SET Amount=0, ARAmount=0
WHERE ClaimTransactionTypeCode='END'

--UPDATE ARAmounts to 0 for Trans that came before first BLL trans
UPDATE CA SET ARAmount=0
FROM ClaimAccounting CA INNER JOIN #CA_FirstBLL CAFB
ON CA.PracticeID=CAFB.PracticeID AND CA.ClaimID=CAFB.ClaimID AND CA.ClaimTransactionID<CAFB.ClaimTransactionID
WHERE ClaimTransactionTypeCode NOT IN ('BLL','CST','END') AND ARAmount<>0

CREATE TABLE #BLLARAmount(PracticeID INT, ClaimID INT, ClaimTransactionID INT, ARAmount MONEY)
INSERT INTO #BLLARAmount(PracticeID, ClaimID, ARAmount)
SELECT CA.PracticeID, CA.ClaimID, 
SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)-SUM(CASE WHEN ClaimTransactionTypeCode IN ('PAY','ADJ') THEN Amount ELSE 0 END)
FROM ClaimAccounting CA INNER JOIN #CA_FirstBLL CAFB
ON CA.PracticeID=CAFB.PracticeID AND CA.ClaimID=CAFB.ClaimID AND CA.ClaimTransactionID<CAFB.ClaimTransactionID
GROUP BY CA.PracticeID, CA.ClaimID

--IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClaimAccounting]') AND name = N'CI_ClaimAccounting_PracticeID_PostingDate_ClaimTransactionID')
DROP INDEX ClaimAccounting.CI_ClaimAccounting_PracticeID_PostingDate_ClaimTransactionID

UPDATE BA SET ClaimTransactionID=CAFB.ClaimTransactionID
FROM #BLLARAmount BA INNER JOIN #CA_FirstBLL CAFB
ON BA.PracticeID=CAFB.PracticeID AND BA.ClaimID=CAFB.ClaimID

UPDATE CA SET ARAmount=BA.ARAmount
FROM ClaimAccounting CA INNER JOIN #BLLARAmount BA
ON CA.PracticeID=BA.PracticeID AND CA.ClaimID=BA.ClaimID AND CA.ClaimTransactionID=BA.ClaimTransactionID

CREATE CLUSTERED INDEX CI_ClaimAccounting_PracticeID_PostingDate_ClaimTransactionID ON ClaimAccounting
(
	[PracticeID],
	[PostingDate],
	[ClaimTransactionID]
)

--Close Claims that should be settled due to having a zero balance due
DECLARE @Claims TABLE(PracticeID INT, ClaimID INT)
INSERT @Claims(PracticeID, ClaimID)
SELECT PracticeID, ClaimID
FROM ClaimAccounting
WHERE ClaimTransactionTypeCode='BLL' AND ARAmount=0

DECLARE @ClaimsToCheck TABLE (ClaimID INT)
INSERT @ClaimsToCheck(ClaimID)
SELECT CA.ClaimID
FROM ClaimAccounting CA INNER JOIN @Claims C
ON CA.PracticeID=C.PracticeID AND CA.ClaimID=C.ClaimID
WHERE CA.ClaimTransactionTypeCode='CST' AND Amount<>0

DECLARE @ClaimBalances TABLE(ClaimID INT, Amount MONEY, ARAmount MONEY)
INSERT @ClaimBalances(ClaimID, Amount, ARAmount)
SELECT CA.ClaimID, SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)-SUM(CASE WHEN ClaimTransactionTypeCode IN ('PAY','ADJ') THEN Amount ELSE 0 END) Amount, 
SUM(ARAmount) ARAmount
FROM ClaimAccounting CA INNER JOIN @ClaimsToCheck CTC
ON CA.ClaimID=CTC.ClaimID
GROUP BY CA.ClaimID
HAVING SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)-SUM(CASE WHEN ClaimTransactionTypeCode IN ('PAY','ADJ') THEN Amount ELSE 0 END) =0 AND
SUM(ARAmount)=0 AND COUNT(CASE WHEN ClaimTransactionTypeCode='END' THEN 1 ELSE NULL END)=0

INSERT ClaimTransaction(ClaimTransactionTypeCode, ClaimID, PostingDate, Notes, PracticeID, PatientID, Claim_ProviderID)
SELECT 'END', CB.ClaimID, CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(GETDATE()) AS DATETIME),110) AS DATETIME), '', C.PracticeID, C.PatientID, E.DoctorID
FROM @ClaimBalances CB INNER JOIN Claim C ON CB.ClaimID=C.ClaimID
INNER JOIN EncounterProcedure EP ON C.EncounterProcedureID=EP.EncounterProcedureID
INNER JOIN Encounter E ON EP.EncounterID=E.EncounterID

UPDATE C SET ClaimStatusCode='C'
FROM Claim C INNER JOIN @ClaimBalances CB
ON C.ClaimID=CB.ClaimID

--Correct Any incorrect Status Flags
UPDATE CA SET Status=CASE WHEN ClaimStatusCode='C' THEN 1 ELSE 0 END
FROM Claim C INNER JOIN ClaimAccounting CA
ON C.ClaimID=CA.ClaimID

UPDATE CAA SET Status=CASE WHEN ClaimStatusCode='C' THEN 1 ELSE 0 END
FROM Claim C INNER JOIN ClaimAccounting_Assignments CAA
ON C.ClaimID=CAA.ClaimID

UPDATE CAB SET Status=CASE WHEN ClaimStatusCode='C' THEN 1 ELSE 0 END
FROM Claim C INNER JOIN ClaimAccounting_Billings CAB
ON C.ClaimID=CAB.ClaimID

--Update ProcedureCounts that are NULL
UPDATE ClaimAccounting SET ProcedureCount=0
WHERE ProcedureCount IS NULL

--Update Amount that are NULL
UPDATE ClaimAccounting SET Amount=0
WHERE Amount IS NULL

--Update ARAmount that are NULL
UPDATE ClaimAccounting SET ARAmount=0
WHERE ARAmount IS NULL

--Correct Incorrect entries from VOID Claims
DECLARE @PAYToDelete TABLE(ClaimTransactionID INT)
INSERT @PAYToDelete
SELECT ClaimTransactionID
FROM ClaimAccounting CA INNER JOIN VoidedClaims VC
ON CA.ClaimID=VC.ClaimID AND ClaimTransactionTypeCode='PAY'

DELETE PCT
FROM PaymentClaimTransaction PCT INNER JOIN @PAYToDelete P
ON PCT.ClaimTransactionID=P.ClaimTransactionID

DELETE CT
FROM ClaimTransaction CT INNER JOIN @PAYToDelete P
ON CT.ClaimTransactionID=P.ClaimTransactionID

DELETE CA
FROM ClaimAccounting CA INNER JOIN VoidedClaims VC
ON CA.ClaimID=VC.ClaimID

DELETE CAA
FROM ClaimAccounting_Assignments CAA INNER JOIN VoidedClaims VC
ON CAA.ClaimID=VC.ClaimID

DELETE CAB
FROM ClaimAccounting_Billings CAB INNER JOIN VoidedClaims VC
ON CAB.ClaimID=VC.ClaimID

--DELETE #CT_AR
--
--INSERT INTO #CT_AR(PracticeID, AR)
--SELECT B.PracticeID,
--SUM(CASE WHEN ClaimTransactionTypeCode='CST' THEN Amount ELSE 0 END)-SUM(CASE WHEN ClaimTransactionTypeCode<>'CST' THEN Amount ELSE 0 END) AR
--FROM ClaimTransaction CT INNER JOIN #Billed B
--ON CT.PracticeID=B.PracticeID AND CT.ClaimID=B.ClaimID
--GROUP BY B.PracticeID
--
--DELETE #CA_AR
--
--INSERT INTO #CA_AR(PracticeID, AR)
--SELECT CA.PracticeID, SUM(ARAmount) AR
--FROM ClaimAccounting CA INNER JOIN #Billed B
--ON CA.PracticeID=B.PracticeID AND CA.ClaimID=B.ClaimID
--GROUP BY CA.PracticeID

--SELECT CT.PracticeID, CT.AR-CA.AR
--FROM #CT_AR CT INNER JOIN #CA_AR CA
--ON CT.PracticeID=CA.PracticeID
--WHERE CT.AR<>CA.AR

DROP TABLE #Billed
--DROP TABLE #CT_AR
--DROP TABLE #CA_AR
DROP TABLE #CA_FirstBLL
DROP TABLE #BLLARAmount
DROP TABLE #CT_ToInsert

