USE superbill_11306_dev
--USE superbill_11306_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @TargetPracticeID INT
DECLARE @SourcePracticeID INT
DECLARE @VendorImportID INT

SET @TargetPracticeID = 7
SET @SourcePracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 


PRINT ''
PRINT 'Updating Existing Doctor Records with VendorID...'
UPDATE dbo.Doctor 
	SET VendorID = i.DoctorID
FROM dbo.Doctor d
INNER JOIN dbo.[_import_2_7_Doctor] i ON
	i.FirstName = d.FirstName AND
    i.LastName = d.LastName AND
    i.NPI = d.NPI 
WHERE d.PracticeID = @TargetPracticeID AND d.[External] = 0 AND d.VendorID IS NULL
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

PRINT ''
PRINT 'Updating Appointment to Resource - Doctor Resource...'
UPDATE dbo.AppointmentToResource 
	SET ResourceID = d.DoctorID
FROM dbo.AppointmentToResource atr
	INNER JOIN dbo.Appointment a ON
		atr.AppointmentID = a.AppointmentID AND 
		a.PracticeID = @TargetPracticeID
	INNER JOIN dbo.[_import_2_7_AppointmentToResource] i ON
		a.[Subject] = i.AppointmentID AND 
		i.PracticeID = @SourcePracticeID
	INNER JOIN dbo.Doctor d ON
		i.resourceid = d.VendorID AND
		d.PracticeID = @TargetPracticeID
WHERE a.CreatedDate = '2015-09-17 17:15:53.577' AND i.AppointmentResourceTypeID = 1  
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


--ROLLBACK
--COMMIT

