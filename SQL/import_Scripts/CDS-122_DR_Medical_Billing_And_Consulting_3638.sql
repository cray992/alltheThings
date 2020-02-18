USE superbill_3638_dev
GO

INSERT INTO dbo.AppointmentToResource
        ( AppointmentID ,
          AppointmentResourceTypeID ,
          ResourceID ,
          ModifiedDate ,
          PracticeID
        )
SELECT
		  AppointmentID , -- AppointmentID - int
          1 , -- AppointmentResourceTypeID - int
          101 , -- ResourceID - int
          GETDATE() , -- ModifiedDate - datetime
          13  -- PracticeID - int
FROM dbo.Appointment
WHERE PracticeID = 13


UPDATE dbo.Appointment
	SET AppointmentResourceTypeID = 1
	WHERE PracticeID = 13 AND AppointmentResourceTypeID = 0