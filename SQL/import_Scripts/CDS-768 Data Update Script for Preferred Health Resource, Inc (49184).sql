--USE superbill_49184_dev
USE superbill_49184_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON 

--Patient Cases for all practices were inadvertently updated to Self Pay. 
--This update will revert the name and payer scenario based on most recent backfile and where the case has not been modified by the user

PRINT ''
PRINT 'Updating Patient Case - Name and PayerScenarioID...'
UPDATE dbo.PatientCase 
	SET Name = pcu.name ,
		PayerScenarioID = pcu.payerscenarioid
FROM dbo.PatientCase pc
INNER JOIN dbo.[_import_6_46_PatientCaseUpdate] pcu ON 
	pc.PatientCaseID = pcu.patientcaseid AND
    pc.PatientID = pcu.patientid
WHERE pc.ModifiedDate < '2016-04-06 18:07:33.283'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

