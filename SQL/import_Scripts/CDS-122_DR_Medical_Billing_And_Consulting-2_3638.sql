USE superbill_3638_dev
GO


UPDATE dbo.Appointment
	SET StartDate = DATEADD(hh , -6, StartDate) ,
		EndDate = DATEADD(hh , -6, EndDate) ,
		StartTm = StartTm - 300 ,
		EndTm = EndTm - 600
	WHERE PracticeID = 13 AND CreatedUserID = 0
