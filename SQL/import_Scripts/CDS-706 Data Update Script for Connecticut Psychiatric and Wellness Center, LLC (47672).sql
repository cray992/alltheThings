--USE superbill_47672_dev
USE superbill_47672_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 3

SET NOCOUNT ON 

PRINT 'PracticeID = ' + CAST(@PracticeID AS VARCHAR(10))
PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))

PRINT ''
PRINT 'Updating Appointment...'
UPDATE dbo.Appointment 
	SET ServiceLocationID = 2
FROM dbo.Appointment a 
	INNER JOIN dbo.Patient p ON 
		a.PatientID = p.PatientID AND
        a.PracticeID = @PracticeID
	INNER JOIN dbo.[_import_3_1_Athenaapptswlocation] i ON 
		p.FirstName = i.patient AND
        p.LastName = i.name AND
		a.StartDate = CAST(i.StartDateEst AS DATETIME)
WHERE a.ModifiedDate = '2015-12-01 02:14:09.280' AND i.[svcdprtmnt] = 'Woodbridge'
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT
