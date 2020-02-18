
CREATE TABLE #ToTag(PracticeID INT, ClaimID INT, ConfirmedDate DATETIME, BillBatchID INT, BillID INT, Type CHAR(1), PatientID INT, ProviderID INT)
INSERT INTO #ToTag(PracticeID, ClaimID, ConfirmedDate, BillBatchID, BillID, Type, PatientID, ProviderID)
SELECT	BB.PracticeID, BC.ClaimID,	BB.ConfirmedDate, BB.BillBatchID, B.BillID, CASE WHEN CAA.InsurancePolicyID IS NULL THEN 'P' ELSE 'I' END Type,
CA.PatientID, CA.ProviderID
FROM	BillBatch BB INNER JOIN Bill_Statement B 
	ON BB.BillBatchID=B.BillBatchID
	INNER JOIN BillClaim BC
	ON BC.BillID = B.BillID
	AND BC.BillBatchTypeCode = 'S'
	INNER JOIN ClaimAccounting_Assignments CAA
	ON BB.PracticeID=CAA.PracticeID AND BC.ClaimID=CAA.ClaimID
	INNER JOIN ClaimAccounting CA
	ON CAA.PracticeID=CA.PracticeID AND CAA.ClaimID=CA.ClaimID AND ClaimTransactionTypeCode='CST'
WHERE BB.BillBatchTypeCode='S' AND BB.CreatedDate>='1-07-07' AND BB.ConfirmedDate IS NOT NULL AND B.Active=1 AND CAA.Status=0 AND ((LastAssignment=1 AND InsurancePolicyID IS NULL)
		OR (LastAssignment=1 AND InsurancePolicyID IS NOT NULL AND BC.IsCopay=1))

CREATE TABLE #Tagged(BillID INT, ClaimID INT)
INSERT INTO #Tagged(BillID, ClaimID)
SELECT TT.BillID, CT.ClaimID
FROM #ToTag TT INNER JOIN ClaimTransaction CT
ON TT.PracticeID=CT.PracticeID AND TT.ClaimID=CT.ClaimID AND CT.ClaimTransactionTypeCode='BLL' AND TT.BillID=CT.ReferenceID

CREATE TABLE #ToTag_NotTagged(PracticeID INT, ClaimID INT, ConfirmedDate DATETIME, BillBatchID INT, BillID INT, Type CHAR(1), PatientID INT, ProviderID INT)
INSERT INTO #ToTag_NotTagged(PracticeID, ClaimID, ConfirmedDate, BillBatchID, BillID, Type, PatientID, ProviderID)
SELECT TT.PracticeID, TT.ClaimID, CAST(CONVERT(CHAR(10),TT.ConfirmedDate,110) AS DATETIME), TT.BillBatchID, TT.BillID, TT.Type, TT.PatientID, TT.ProviderID
FROM #ToTag TT LEFT JOIN #Tagged T
ON TT.BillID=T.BillID AND TT.ClaimID=T.ClaimID
WHERE T.ClaimID IS NULL

CREATE TABLE #StatusChanges(PracticeID INT, ClaimID INT)
INSERT INTO #StatusChanges(PracticeID, ClaimID)
SELECT CAA.PracticeID, CAA.ClaimID
FROM  #ToTag_NotTagged TTN INNER JOIN ClaimAccounting_Assignments CAA
ON TTN.PracticeID=CAA.PracticeID AND TTN.ClaimID=CAA.ClaimID AND CAA.LastAssignment=1
WHERE TTN.Type='P' AND TTN.ConfirmedDate>CAA.PostingDate

--Create Statement transaction for claim.
DECLARE @notes VARCHAR(200)
SET @notes = 'STATEMENT GENERATED WITH BATCH '

--Create the bill transaction.
INSERT INTO CLAIMTRANSACTION (ClaimTransactionTypeCode, ClaimID, PostingDate, Code, ReferenceID,
						  Notes, PracticeID, PatientID, Claim_ProviderID)
SELECT 'BLL', ClaimID, ConfirmedDate, 'S', BillID, @notes+CAST(BillBatchID AS VARCHAR), PracticeID, PatientID, ProviderID
FROM #ToTag_NotTagged

--Make sure only Patient Assigned Service Lines are set to a Pending state
UPDATE C SET ClaimStatusCode='P'
FROM #StatusChanges SC INNER JOIN Claim C
ON SC.PracticeID=C.PracticeID AND SC.ClaimID=C.ClaimID

DROP TABLE #ToTag
DROP TABLE #Tagged
DROP TABLE #ToTag_NotTagged
DROP TABLE #StatusChanges