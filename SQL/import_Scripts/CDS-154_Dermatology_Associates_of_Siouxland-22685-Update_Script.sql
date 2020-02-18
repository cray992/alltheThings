USE superbill_22685_dev 
GO
--USE superbill_22685_prod GO

SET XACT_ABORT ON
 
BEGIN TRANSACTION
 
SET NOCOUNT ON
 
DECLARE @PracticeID INT
DECLARE @VendorImportID INT
 
SET @PracticeID = 1
SET @VendorImportID = 1

DELETE FROM dbo.PatientAlert WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE PracticeID = @PracticeID AND VendorImportID = @VendorImportID)
PRINT '    ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' Patient Alert records deleted'


PRINT ''
PRINT 'Inserting into Patient Alert...'
INSERT INTO dbo.PatientAlert
        ( PatientID ,
          AlertMessage ,
          ShowInPatientFlag ,
          ShowInAppointmentFlag ,
          ShowInEncounterFlag ,
          CreatedDate ,
          CreatedUserID ,
          ModifiedDate ,
          ModifiedUserID ,
          ShowInClaimFlag ,
          ShowInPaymentFlag ,
          ShowInPatientStatementFlag
        )
SELECT DISTINCT
		  pat.PatientID , -- PatientID - int
          imp.patientnotes , -- AlertMessage - text
          1 , -- ShowInPatientFlag - bit
          0 , -- ShowInAppointmentFlag - bit
          0 , -- ShowInEncounterFlag - bit
          GETDATE() , -- CreatedDate - datetime
          0 , -- CreatedUserID - int
          GETDATE() , -- ModifiedDate - datetime
          0 , -- ModifiedUserID - int
          0 , -- ShowInClaimFlag - bit
          0 , -- ShowInPaymentFlag - bit
          0  -- ShowInPatientStatementFlag - bit
FROM dbo.[_import_1_1_PatientDemographic] AS imp
INNER JOIN dbo.Patient AS pat ON
	pat.VendorID = imp.accountnumber AND
	pat.VendorImportID = @VendorImportID AND
	pat.PracticeID = @PracticeID
WHERE imp.patientnotes <> ''
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records inserted'


PRINT ''
PRINT 'Updating Appointment Records...'
UPDATE dbo.Appointment
	SET StartDate = DATEADD(hh , -2 , StartDate) ,
		EndDate = DATEADD(hh , -2 , EndDate) ,
		StartTm = StartTm - 200 ,
		EndTm = EndTm - 200
	WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = @VendorImportID AND PracticeID = @PracticeID)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'


PRINT ''
PRINT 'Updating Patient Employers...'
UPDATE dbo.patient
	SET EmployerID = CASE WHEN imp.employer <> '' THEN (SELECT TOP 1 employerid FROM dbo.employers WHERE imp.employer = EmployerName) ELSE NULL END 
	FROM dbo.Patient pat
	INNER JOIN dbo.[_import_1_1_PatientDemographic] imp ON
					imp.accountnumber = pat.VendorID
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

--ROLLBACK TRANSACTION
COMMIT
