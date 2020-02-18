
-- Based on the list of representative claims, taken from ProxyMed Daily reports, rebills all of them and all related.
-- To get the list (for cust 122 here): cat aaa.txt|grep 122K |sed -e 's/122K//'|sed -e 's/K9.*/,/' > aaaa.txt

DECLARE @Encounters TABLE(EncounterID INT, PracticeID INT, PatientID INT, ProviderID INT)
INSERT @Encounters(EncounterID, PracticeID, PatientID, ProviderID)
SELECT     DISTINCT EP.EncounterID, EP.PracticeID, C.PatientID, E.DoctorID
FROM       Claim C INNER JOIN EncounterProcedure EP
		   ON C.PracticeID=EP.PracticeID AND C.EncounterProcedureID=EP.EncounterProcedureID
		   INNER JOIN Encounter E
		   ON EP.PracticeID=E.PracticeID AND EP.EncounterID=E.EncounterID
WHERE     (ClaimID IN ( .........INSERT LIST HERE..........))

DECLARE @ChangeStatus_ReasonCode VARCHAR(5)
SET @ChangeStatus_ReasonCode='0'

DECLARE @ChangeStatus_Note VARCHAR(500)
SET @ChangeStatus_Note='Rebilled per CASE '

DECLARE @Claims TABLE(PracticeID INT, PatientID INT, ProviderID INT, ClaimID INT)
INSERT @Claims(PracticeID, PatientID, ProviderID, ClaimID)
SELECT E.PracticeID, E.PatientID, E.ProviderID, C.ClaimID
FROM @Encounters E INNER JOIN EncounterProcedure EP
ON E.PracticeID=EP.PracticeID AND E.EncounterID=EP.EncounterID
INNER JOIN Claim C
ON EP.PracticeID=C.PracticeID AND EP.EncounterProcedureID=C.EncounterProcedureID

INSERT	CLAIMTRANSACTION (ClaimTransactionTypeCode,	ClaimID, PostingDate, Amount,
						  Quantity, Code, ReferenceID, ReferenceData, Notes, PracticeID,
						  PatientID, Claim_ProviderID)
SELECT 'RAS', ClaimID,
CAST(CONVERT(CHAR(10),CAST(dbo.fn_ReplaceTimeInDate(GETDATE()) AS DATETIME),110) AS DATETIME),
NULL, NULL, @ChangeStatus_ReasonCode, NULL, NULL, @ChangeStatus_Note, PracticeID, PatientID, ProviderID
FROM @Claims

UPDATE C SET ClaimStatusCode = 'R',
			 CurrentClearinghouseProcessingStatus = NULL,
			 CurrentPayerProcessingStatusTypeCode = NULL,
			 ModifiedDate = GETDATE()
FROM @Claims Cs INNER JOIN Claim C
ON Cs.ClaimID=C.ClaimID

