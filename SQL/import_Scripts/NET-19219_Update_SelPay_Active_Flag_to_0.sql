USE superbill_39795_dev
GO

SET XACT_ABORT ON
 
BEGIN TRANSACTION
 --rollback
 --commit
SET NOCOUNT ON

PRINT 'Updating Active flag to 0 for Self Pay patients...'
UPDATE pc
SET pc.Active = 0
FROM dbo.PatientCase pc 
WHERE pc.name like '%self%' AND pc.Active=1

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--SELECT * FROM dbo.PatientCase pc WHERE pc.name like '%self%' AND pc.Active=1