USE superbill_40519_dev
--USE superbill_40519_prod
GO

SET XACT_ABORT ON

BEGIN TRANSACTION

SET NOCOUNT ON

DECLARE @PatientVendorImportID INT
DECLARE @PracticeID INT

SET @PatientVendorImportID = 3
SET @PracticeID = 1


CREATE TABLE #patrecdelete (PatientID INT , FirstName VARCHAR(65) , LastName VARCHAR(65) , DOB DATETIME, rn INT)
INSERT INTO #patrecdelete ( PatientID , FirstName , LastName , DOB , rn)
SELECT 
  p.PatientID , p.firstname, p.lastname, p.dob, ROW_NUMBER() OVER(PARTITION BY p.FirstName, p.LastName , p.DOB ORDER BY p.PatientID DESC) AS dupecount
FROM dbo.Patient p
	LEFT JOIN dbo.Appointment a ON 
		p.PatientID = a.PatientID AND
        p.PracticeID = @PracticeID
	LEFT JOIN dbo.Encounter e ON 
		p.PatientID = e.PatientID AND 
		p.PracticeID = @PracticeID
WHERE p.PracticeID = @PracticeID AND a.AppointmentID IS NULL AND e.EncounterID IS NULL AND p.VendorImportID = @PatientVendorImportID ORDER BY p.LastName

PRINT ''
PRINT 'Deleting From Insurance Policy...'
DELETE FROM dbo.InsurancePolicy
	WHERE PatientCaseID IN (SELECT PatientCaseID from dbo.PatientCase
		WHERE PatientID IN (SELECT patientid FROM #patrecdelete WHERE rn > 1))		
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting From Patient Case Date...'
DELETE FROM dbo.PatientCaseDate
	WHERE PatientCaseID IN (SELECT PatientCaseID from dbo.PatientCase
		WHERE PatientID IN (SELECT patientid FROM #patrecdelete WHERE rn > 1))		
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting From Patient Case...'
DELETE FROM dbo.PatientCase 
	WHERE PatientID IN (SELECT patientid FROM #patrecdelete WHERE rn > 1)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting From Patient Alert...'
DELETE FROM dbo.PatientAlert 
	WHERE PatientID IN (SELECT patientid FROM #patrecdelete WHERE rn > 1)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

PRINT ''
PRINT 'Deleting From Patient...'
DELETE FROM dbo.Patient 
	WHERE PatientID IN (SELECT patientid FROM #patrecdelete WHERE rn > 1)
PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records deleted'

DROP TABLE #patrecdelete


SELECT COUNT(*) FROM dbo.Patient

--ROLLBACK
--COMMIT


/*
==============================================================
QA Query to verify all dupliate imported records were deleted |
==============================================================


CREATE TABLE #qapatrecdelete (PatientID INT , FirstName VARCHAR(65) , LastName VARCHAR(65) , DOB DATETIME, rn INT)
INSERT INTO #qapatrecdelete ( PatientID , FirstName , LastName , DOB , rn)
SELECT 
  p.PatientID , p.firstname, p.lastname, p.dob, ROW_NUMBER() OVER(PARTITION BY p.FirstName, p.LastName , p.DOB ORDER BY p.PatientID DESC) AS dupecount
FROM dbo.Patient p
	LEFT JOIN dbo.Appointment a ON 
		p.PatientID = a.PatientID AND
        p.PracticeID = 1
	LEFT JOIN dbo.Encounter e ON 
		p.PatientID = e.PatientID AND 
		p.PracticeID = 1
WHERE p.PracticeID = 1 AND a.AppointmentID IS NULL AND e.EncounterID IS NULL

SELECT p.PatientID , p.FirstName , p.LastName , p.DOB , p.VendorImportID , p.CreatedDate ,i.rn FROM dbo.Patient p INNER JOIN #qapatrecdelete i ON p.PatientID = i.patientid WHERE i.rn > 1 ORDER BY p.LastName

DROP TABLE #qapatrecdelete

Result: Only 1 imported patient record remained due to the matching duplicate being manually created by the customer. This is okay.

*/
