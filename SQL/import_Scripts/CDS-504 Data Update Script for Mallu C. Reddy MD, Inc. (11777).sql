USE superbill_11777_dev
--USE superbill_11777_prod
GO

SET XACT_ABORT ON
 
BEGIN TRAN
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
 
SET @PracticeID = 1

PRINT ''
PRINT 'Updating Patient MedicalRecordNumber...'
UPDATE dbo.Patient 
SET MedicalRecordNumber = i.mrn
FROM dbo.Patient p 
INNER JOIN dbo.[_import_3_1_Patient] i ON
p.FirstName = i.firstname AND
p.LastName = i.lastname AND 
p.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME)) AND
p.PracticeID = @PracticeID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT

/*
SELECT * FROM dbo.[_import_3_1_Patient] i WHERE NOT EXISTS (SELECT * FROM dbo.Patient p WHERE
p.FirstName = i.firstname AND
p.LastName = i.lastname AND 
p.DOB = DATEADD(hh,12,CAST(i.dob AS DATETIME)) AND
p.PracticeID = 1)
*/