DECLARE @DocumentBatchID INT
SET @DocumentBatchID=997

CREATE TABLE #ProcessList(RID INT IDENTITY(1,1), DocumentID INT, Prefix VARCHAR(128), FirstName VARCHAR(128),
MiddleName VARCHAR(128), LastName VARCHAR(128), Suffix VARCHAR(128))
INSERT INTO #ProcessList(DocumentID, Prefix, FirstName, MiddleName, LastName, Suffix)
EXEC BillDataProvider_GetDocumentsByBatch @DocumentBatchID

SELECT * FROM #ProcessList

DROP TABLE #ProcessList