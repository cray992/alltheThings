USE superbill_37225_dev
--USE superbill_37225_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

DECLARE @PracticeID INT
DECLARE @VendorImportID INT

SET @PracticeID = 1
SET @VendorImportID = 2

SET NOCOUNT ON 

PRINT ''
PRINT 'Updating Appointment to Resource...'
UPDATE dbo.AppointmentToResource
	SET ResourceID = CASE i.providerlast WHEN 'Santa Clara' THEN 13
										 WHEN 'Stark-Bank' THEN 9 END
FROM dbo.AppointmentToResource atr
INNER JOIN dbo.Appointment a ON 
	atr.AppointmentID = a.AppointmentID AND
	a.PracticeID = @PracticeID
INNER JOIN dbo.Patient p ON 
	a.PatientID = a.PatientID AND
	p.PracticeID = @PracticeID
INNER JOIN dbo.[_import_2_1_Appointment] i ON
	LTRIM(RTRIM(i.patientfirst)) = p.FirstName AND
	LTRIM(RTRIM(i.patientlast)) = p.LastName AND
	a.StartDate = i.startdate AND 
	a.EndDate = i.enddate AND 
	a.CreatedDate = '2015-05-01 14:40:26.053' 
WHERE i.providerlast IN ('Santa Clara','Stark-Bank') 
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK
--COMMIT

