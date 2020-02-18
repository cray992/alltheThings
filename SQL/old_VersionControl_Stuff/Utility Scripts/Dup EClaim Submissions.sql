DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
SET @StartDate='5-15-07'
SET @EndDate='5-18-07'

SET @EndDate=DATEADD(D,1,DATEADD(S,-1,@EndDate))

CREATE TABLE #MultipleBills(ClaimID INT, PayerInsurancePolicyID INT)
INSERT INTO #MultipleBills(ClaimID, PayerInsurancePolicyID)
SELECT BC.ClaimID, BE.PayerInsurancePolicyID
FROM BillBatch BB INNER JOIN Bill_EDI BE
ON BB.BillBatchID=BE.BillBatchID AND BB.BillBatchTypeCode='E'
INNER JOIN BillClaim BC
ON BE.BillID=BC.BillID AND BC.BillBatchTypeCode='E'
WHERE BB.CreatedDate BETWEEN @StartDate AND @EndDate AND ConfirmedDate IS NOT NULL
GROUP BY BC.ClaimID, BE.PayerInsurancePolicyID
HAVING COUNT(BB.BillBatchID)>1

CREATE TABLE #ClaimBatches(ClaimID INT, BillBatchID INT, PayerInsurancePolicyID INT)
INSERT INTO #ClaimBatches(ClaimID, BillBatchID, PayerInsurancePolicyID)
SELECT DISTINCT MB.ClaimID, BE.BillBatchID, BE.PayerInsurancePolicyID
FROM #MultipleBills MB INNER JOIN BillClaim BC
ON MB.ClaimID=BC.ClaimID AND BC.BillBatchTypeCode='E'
INNER JOIN Bill_EDI BE
ON BC.BillID=BE.BillID AND BC.BillBatchTypeCode='E' AND MB.PayerInsurancePolicyID=BE.PayerInsurancePolicyID
INNER JOIN BillBatch BB
ON BE.BillBatchID=BB.BillBatchID
WHERE BB.CreatedDate BETWEEN @StartDate AND @EndDate AND ConfirmedDate IS NOT NULL

CREATE TABLE #BatchStats(BillBatchID INT, ClaimID INT, PracticeID INT, CreatedDate DATETIME, ConfirmedDate DATETIME)
INSERT INTO #BatchStats(BillBatchID, ClaimID, PracticeID, CreatedDate, ConfirmedDate)
SELECT CB.BillBatchID, CB.ClaimID, BB.PracticeID, BB.CreatedDate, BB.ConfirmedDate
FROM #ClaimBatches CB INNER JOIN BillBatch BB
ON CB.BillBatchID=BB.BillBatchID
ORDER BY CB.ClaimID, CB.BillBatchID, BB.CreatedDate, BB.ConfirmedDate

--SELECT CB.BillBatchID, CB.ClaimID, BB.PracticeID, BB.CreatedDate, BB.ConfirmedDate
--FROM #ClaimBatches CB INNER JOIN BillBatch BB
--ON CB.BillBatchID=BB.BillBatchID
--ORDER BY CB.ClaimID, CB.BillBatchID, BB.CreatedDate, BB.ConfirmedDate

SELECT ClaimID, PracticeID, CAST(CONVERT(CHAR(10),CreatedDate,110) AS DATETIME) CreatedDate, COUNT(BillBatchID) Billed
FROM #BatchStats
GROUP BY ClaimID, PracticeID, CAST(CONVERT(CHAR(10),CreatedDate,110) AS DATETIME)
HAVING COUNT(BillBatchID)>1
ORDER BY PracticeID, Billed DESC, ClaimID, CAST(CONVERT(CHAR(10),CreatedDate,110) AS DATETIME)

--SELECT ClaimID, CAST(CONVERT(CHAR(10),CreatedDate,110) AS DATETIME) CreatedDate, COUNT(BillBatchID) Billed
--FROM #BatchStats
--GROUP BY ClaimID, CAST(CONVERT(CHAR(10),CreatedDate,110) AS DATETIME)
--HAVING COUNT(BillBatchID)>1
--ORDER BY Billed DESC, ClaimID, CAST(CONVERT(CHAR(10),CreatedDate,110) AS DATETIME)

DROP TABLE #MultipleBills
DROP TABLE #ClaimBatches
DROP TABLE #BatchStats