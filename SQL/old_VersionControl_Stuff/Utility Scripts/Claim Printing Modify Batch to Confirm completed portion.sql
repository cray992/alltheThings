DECLARE @DocumentBatchID INT
DECLARE @LastProcessedDocRID INT
SET @DocumentBatchID=997
SET @LastProcessedDocRID=287

CREATE TABLE #ProcessList(RID INT IDENTITY(1,1), DocumentID INT, Prefix VARCHAR(128), FirstName VARCHAR(128),
MiddleName VARCHAR(128), LastName VARCHAR(128), Suffix VARCHAR(128))
INSERT INTO #ProcessList(DocumentID, Prefix, FirstName, MiddleName, LastName, Suffix)
EXEC BillDataProvider_GetDocumentsByBatch @DocumentBatchID

DELETE DHC
FROM #ProcessList PL INNER JOIN Document_HCFA DH
ON PL.DocumentID=DH.DocumentID
INNER JOIN Document_HCFAClaim DHC
ON DH.Document_HCFAID=DHC.Document_HCFAID
WHERE RID>@LastProcessedDocRID

DELETE DH
FROM #ProcessList PL INNER JOIN Document_HCFA DH
ON PL.DocumentID=DH.DocumentID
WHERE RID>@LastProcessedDocRID

DELETE DBR
FROM #ProcessList PL INNER JOIN Document_BusinessRules DBR
ON PL.DocumentID=DBR.DocumentID
WHERE RID>@LastProcessedDocRID

DELETE D
FROM #ProcessList PL INNER JOIN Document D
ON PL.DocumentID=D.DocumentID
WHERE RID>@LastProcessedDocRID

DROP TABLE #ProcessList

EXEC BillDataProvider_ConfirmHCFABatch @DocumentBatchID