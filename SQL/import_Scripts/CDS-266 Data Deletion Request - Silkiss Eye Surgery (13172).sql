USE superbill_13172_dev
GO


SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

PRINT ''
PRINT 'Deleting Referring Doctor from dbo.ClaimSettings'
DELETE FROM dbo.ClaimSettings WHERE EXISTS (SELECT * FROM dbo.Doctor doc WHERE DoctorID = doc.DoctorID AND doc.[External] = 1 AND doc.NPI IS NULL) 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records deleted '

PRINT ''
PRINT 'Deleting Referring Doctor from dbo.EligibilityHistory'
DELETE FROM dbo.EligibilityHistory WHERE EXISTS (SELECT * FROM dbo.Doctor doc WHERE DoctorID = doc.DoctorID AND doc.[External] = 1 AND doc.NPI IS NULL) 
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records deleted '


PRINT ''
PRINT 'Deleting Referring Doctor from dbo.Doctor'
DELETE FROM dbo.Doctor WHERE NOT EXISTS (SELECT * FROM dbo.Encounter enc WHERE enc.ReferringPhysicianID = dbo.Doctor.DoctorID OR enc.DoctorID = dbo.Doctor.DoctorID) 
AND NOT EXISTS (SELECT * FROM  dbo.Patient pat WHERE pat.PrimaryCarePhysicianID = dbo.Doctor.DoctorID OR pat.ReferringPhysicianID = dbo.Doctor.DoctorID)
AND [External] = 1 AND NPI IS NULL
PRINT CAST (@@ROWCOUNT AS VARCHAR(10)) + ' records deleted '


--ROLLBACK
--COMMIT

