USE superbill_10780_dev
GO 
BEGIN TRANSACTION 
--rollback
--commit

PRINT''
PRINT'Patients updated for PracticeID 28...'
UPDATE p
SET p.CollectionCategoryID=1
FROM patient p 
WHERE PracticeID=28 
PRINT''
PRINT'Patients updated for PracticeID 34...'
UPDATE p
SET p.CollectionCategoryID=1
FROM patient p 
WHERE PracticeID=34

--SELECT CollectionCategoryID,* FROM dbo.Patient WHERE PracticeID=28
--SELECT CollectionCategoryID,* FROM dbo.Patient WHERE PracticeID=34
--SELECT * FROM dbo.CollectionCategory