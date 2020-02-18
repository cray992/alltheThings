USE superbill_22509_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @VendorImportID INT

SET @VendorImportID = 2

PRINT 'VendorImportID = ' + CAST(@VendorImportID AS VARCHAR(10))


PRINT ''
PRINT 'Updating Appointments with Notes...'
UPDATE dbo.Appointment
      SET Notes = impApp2.Note
FROM dbo.Appointment app
INNER JOIN dbo.Patient realPat ON   
	realPat.Patientid = app.PatientID AND
    realPat.VendorIMportID = 2          
INNER JOIN dbo._import_2_1_Appointments impApp ON
    impApp.[Starttm] - 300 = app.[StartTM] and
    impApp.[EndTm] - 300 = app.[EndTm] AND
    DATEADD(hh, -3, impApp.[StartDate]) = app.StartDate and           
    impApp.[ChartNumber] = realPat.[VendorID]
INNER JOIN dbo._import_4_1_Sheet1 impApp2 ON
    impApp.[Starttm] = impApp2.[Starttm] AND
    impApp.[id] = impApp2.id AND
    impApp.[StartDate] = impApp2.[StartDate] AND
    impApp.Chartnumber = impApp2.Chartnumber
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT