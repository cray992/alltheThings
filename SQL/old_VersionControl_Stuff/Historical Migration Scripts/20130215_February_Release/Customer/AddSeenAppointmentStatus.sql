
IF NOT EXISTS(SELECT * FROM AppointmentConfirmationStatus Where AppointmentConfirmationStatusCode = 'E')
	INSERT INTO [AppointmentConfirmationStatus]
			   ([AppointmentConfirmationStatusCode]
			   ,[Name]
			   ,[ModifiedDate])
		 VALUES
			   ('E'
			   ,'Seen'
			   ,'2013-1-15 22:00:09.820')