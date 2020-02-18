USE superbill_49704_prod
--USE superbill_49704_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

PRINT ''
PRINT 'Update Patient - Active...'
UPDATE dbo.Patient 
	SET Active = 0
FROM dbo.Patient p 
INNER JOIN dbo._import_1_1_PatDemo49704 i ON 
	p.PatientID = i.id AND 
	p.PracticeID = 1
WHERE p.Active = 1
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT