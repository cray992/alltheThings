
---------------------------- These are the ones needed to update in Dev ----------------------------

--USE superbill_10780_dev 
--GO
--BEGIN TRANSACTION

--UPDATE p SET 
--p.CollectionCategoryID=pr.CollectionCategoryID
--FROM dbo.Patient p 
--INNER JOIN superbill_10780_restore2.dbo.Patient pr ON pr.PatientID=p.PatientID
--WHERE p.PracticeID=28 AND pr.CollectionCategoryID IS NOT NULL 
--AND pr.CollectionCategoryID<>p.CollectionCategoryID 

--UPDATE p SET 
--p.CollectionCategoryID=pr.CollectionCategoryID
--FROM dbo.Patient p 
--INNER JOIN superbill_10780_restore2.dbo.Patient pr ON pr.PatientID=p.PatientID
--WHERE p.PracticeID=34 AND pr.CollectionCategoryID IS NOT NULL 
--AND pr.CollectionCategoryID<>p.CollectionCategoryID 



---------------------------- These are the ones needed to update in Prod ----------------------------

--USE superbill_10780_prod
--GO
--BEGIN TRANSACTION 

--UPDATE p SET 
--p.CollectionCategoryID=pr.CollectionCategoryID
--FROM dbo.Patient p 
--INNER JOIN restore_10780_prod.dbo.Patient pr ON pr.PatientID=p.PatientID
--WHERE p.PracticeID=28 AND pr.CollectionCategoryID IS NOT NULL 
--AND pr.CollectionCategoryID<>p.CollectionCategoryID

--UPDATE p SET 
--p.CollectionCategoryID=pr.CollectionCategoryID
--FROM dbo.Patient p 
--INNER JOIN restore_10780_prod.dbo.Patient pr ON pr.PatientID=p.PatientID
--WHERE p.PracticeID=34 AND pr.CollectionCategoryID IS NOT NULL 
--AND pr.CollectionCategoryID<>p.CollectionCategoryID


--rollback
--commit