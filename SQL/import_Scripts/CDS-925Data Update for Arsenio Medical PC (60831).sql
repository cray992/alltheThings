USE superbill_60831_prod
GO

BEGIN TRAN

UPDATE p
SET firstname = 'FAKE' + p.FirstName ,
	LastName = 'FAKE' + p.LastName , 
	Active = 0
FROM dbo.Patient p 
INNER JOIN dbo._import_3_1_RenamePatients i ON
p.PatientID = i.kareoid
WHERE p.PatientID = i.kareoid

--ROLLBACK
--COMMIT

