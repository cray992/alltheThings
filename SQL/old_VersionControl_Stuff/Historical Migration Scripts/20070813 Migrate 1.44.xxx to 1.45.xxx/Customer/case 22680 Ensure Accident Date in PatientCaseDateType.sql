IF NOT EXISTS(SELECT * FROM PatientCaseDateType WHERE PatientCaseDateTypeID=12)
	INSERT INTO PatientCaseDatetype (PatientCaseDateTypeID, [Name], AllowDateRange, AllowMultipleDates) 
		VALUES (12, 'Accident Date', 0, 0)

GO
