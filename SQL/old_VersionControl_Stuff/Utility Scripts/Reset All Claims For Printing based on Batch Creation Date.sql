DECLARE @PracticeID INT
SET @PracticeID=4

DECLARE @CreatedDate DATETIME
SET @CreatedDate='1-20-06'

UPDATE C SET ClaimStatusCode='R'
FROM DocumentBatch DB INNER JOIN Document D
ON DB.DocumentBatchID=D.DocumentBatchID
INNER JOIN Document_HCFA DH
ON D.DocumentID=DH.DocumentID
INNER JOIN Document_HCFAClaim DHC
ON DH.Document_HCFAID=DHC.Document_HCFAID
INNER JOIN Claim C
ON DHC.ClaimID=C.ClaimID
WHERE DB.PracticeID=@PracticeID AND ConfirmedDate IS NOT NULL AND CAST(CONVERT(CHAR(10),DB.CreatedDate,110) AS DATETIME)=@CreatedDate
