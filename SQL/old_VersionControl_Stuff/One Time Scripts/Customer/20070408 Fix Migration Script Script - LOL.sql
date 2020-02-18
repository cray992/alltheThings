CREATE TABLE #RES(RID INT IDENTITY(1,1), PracticeID INT, ClaimID INT, PaymentID INT, PayerTypeCode CHAR(1), InsurancePolicyID INT, ClaimTransactionID INT, PostingDate DATETIME)
INSERT INTO #RES(PracticeID, ClaimID, PaymentID, PayerTypeCode, InsurancePolicyID, ClaimTransactionID,  PostingDate)
SELECT CT.PracticeID, CT.ClaimID, CT.PaymentID, P.PayerTypeCode, PC.EOBXml.value('(eob/insurancePolicyID)[1]','INT') InsurancePolicy, CT.ClaimTransactionID, CT.PostingDate
FROM ClaimTransaction CT INNER JOIN PaymentClaim PC
ON CT.PracticeID=PC.PracticeID AND CT.ClaimID=PC.ClaimID AND CT.PaymentID=PC.PaymentID
INNER JOIN Payment P
ON PC.PracticeID=P.PracticeID AND PC.PaymentID=P.PaymentID
WHERE ClaimTransactionTypeCode='RES'

CREATE TABLE #RES_References(RID INT, ReferenceID INT)
INSERT INTO #RES_References(RID, ReferenceID)
SELECT R.RID, MAX(CAB.ClaimTransactionID) ReferenceID
FROM #RES R INNER JOIN ClaimAccounting_Billings CAB
ON R.PracticeID=CAB.PracticeID AND R.ClaimID=CAB.ClaimID
INNER JOIN ClaimAccounting_Assignments CAA
ON CAB.PracticeID=CAA.PracticeID AND CAB.ClaimID=CAA.ClaimID AND R.InsurancePolicyID=CAA.InsurancePolicyID AND R.PostingDate>=CAB.PostingDate
AND ((CAB.ClaimTransactionID>CAA.ClaimTransactionID AND CAB.ClaimTransactionID<CAA.EndClaimTransactionID)
OR (CAA.EndClaimTransactionID IS NULL AND CAB.ClaimTransactionID>CAA.ClaimTransactionID))
GROUP BY R.RID

INSERT INTO #RES_References(RID, ReferenceID)
SELECT R.RID, MAX(CAB.ClaimTransactionID) ReferenceID
FROM #RES R INNER JOIN ClaimAccounting_Billings CAB
ON R.PracticeID=CAB.PracticeID AND R.ClaimID=CAB.ClaimID
INNER JOIN ClaimAccounting_Assignments CAA
ON CAB.PracticeID=CAA.PracticeID AND CAB.ClaimID=CAA.ClaimID 
AND R.PayerTypeCode=CASE WHEN BatchType<>'S' OR BatchType IS NULL THEN 'I' ELSE 'P' END
AND R.PostingDate>=CAB.PostingDate																				
AND ((CAB.ClaimTransactionID>CAA.ClaimTransactionID AND CAB.ClaimTransactionID<CAA.EndClaimTransactionID)
OR (CAA.EndClaimTransactionID IS NULL AND CAB.ClaimTransactionID>CAA.ClaimTransactionID))
LEFT JOIN #RES_References RR
ON R.RID=RR.RID
WHERE RR.RID IS NULL
GROUP BY R.RID

ALTER TABLE ClaimTransaction DISABLE TRIGGER ALL

UPDATE CT SET ReferenceID=RR.ReferenceID
FROM #RES R INNER JOIN #RES_References RR
ON R.RID=RR.RID
INNER JOIN ClaimTransaction CT
ON R.ClaimTransactionID=CT.ClaimTransactionID

UPDATE CT SET ReferenceID=
CASE WHEN CHARINDEX('BATCH',CAST(Notes AS VARCHAR(300)))<>0 THEN 
RIGHT(CAST(Notes AS VARCHAR(300)),LEN(CAST(Notes AS VARCHAR(300)))-(CHARINDEX('BATCH',CAST(Notes AS VARCHAR(300)))+5))
ELSE NULL END
FROM ClaimTransaction CT
WHERE ClaimTransactionTypeCode='BLL' AND CHARINDEX('BATCH',CAST(Notes AS VARCHAR(300)))<>0

ALTER TABLE ClaimTransaction ENABLE TRIGGER ALL

--ALTER TABLE ClaimAccounting_Billings ADD ResponsePostingDate DATETIME

CREATE TABLE #MAX_ResponsePostingDate(ReferenceID INT, ResponsePostingDate DATETIME)
INSERT INTO #MAX_ResponsePostingDate(ReferenceID, ResponsePostingDate)
SELECT RR.ReferenceID, MAX(R.PostingDate) PostingDate
FROM #RES R INNER JOIN #RES_References RR
ON R.RID=RR.RID
GROUP BY RR.ReferenceID

UPDATE CAB SET ResponsePostingDate=MR.ResponsePostingDate
FROM #MAX_ResponsePostingDate MR INNER JOIN ClaimAccounting_Billings CAB
ON MR.ReferenceID=CAB.ClaimTransactionID

DROP TABLE #RES
DROP TABLE #RES_References
DROP TABLE #MAX_ResponsePostingDate