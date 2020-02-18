USE --superbill_26959_dev
superbill_26959_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

PRINT ''
PRINT 'Updating Other...'
UPDATE dbo.Other 
	SET OtherName = LEFT(OtherName, 128)
WHERE LEN(OtherName) > 128
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT


