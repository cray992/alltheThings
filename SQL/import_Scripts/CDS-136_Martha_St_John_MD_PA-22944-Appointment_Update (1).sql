USE superbill_22944_dev
GO

SET XACT_ABORT ON

BEGIN TRANSACTION


SET NOCOUNT ON



UPDATE dbo.Appointment
	SET StartDate = DATEADD(hh , -2, StartDate) , 
		EndDate = DATEADD(hh , -2 , EndDate) ,
		StartTm = StartTm - 200 ,
		EndTm = EndTm - 200
	WHERE PracticeID = 1 AND PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = 5 AND PracticeID = 1)
	PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' records updated'

COMMIT
