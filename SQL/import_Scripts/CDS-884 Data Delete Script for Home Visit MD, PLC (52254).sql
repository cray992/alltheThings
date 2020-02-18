USE superbill_52254_prod

BEGIN TRANSACTION

SET NOCOUNT  ON

DECLARE @RateScheduleRecords INT
SET @RateScheduleRecords = (SELECT COUNT(*) FROM dbo.ContractsAndFees_ContractRateScheduleLink WHERE LocationID IN 
(SELECT servicelocationid FROM dbo._import_4_1_ServiceLocations))
PRINT CAST(@RateScheduleRecords AS VARCHAR) + ' records to be deleted from Contract Fee Schedule Link'

DECLARE @RateScheduleRecords2 INT
SET @RateScheduleRecords2 = (SELECT COUNT(*) FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE LocationID IN 
(SELECT servicelocationid FROM dbo._import_4_1_ServiceLocations))
PRINT CAST(@RateScheduleRecords2 AS VARCHAR) + ' records to be deleted from Standard Fee Schedule Link'

PRINT ''
PRINT 'Deleting From Contract Fee Schedule Link...'
DELETE FROM dbo.ContractsAndFees_ContractRateScheduleLink WHERE LocationID IN (SELECT servicelocationid FROM dbo._import_4_1_ServiceLocations)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting From Standard Fee Schedule Link...'
DELETE FROM dbo.ContractsAndFees_StandardFeeScheduleLink WHERE LocationID IN (SELECT servicelocationid FROM dbo._import_4_1_ServiceLocations)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

--ROLLBACK
--COMMIT