USE superbill_23192_dev
--USE superbill_23192_prod
GO

INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT DISTINCT
		  AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          1 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          1  -- PracticeID - int
FROM dbo.Appointment
WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = 3 AND PracticeID = 1)


UPDATE dbo.Appointment
	SET AppointmentResourceTypeID = 1
	WHERE PatientID IN (SELECT PatientID FROM dbo.Patient WHERE VendorImportID = 3 AND PracticeID = 1)