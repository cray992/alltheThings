IF NOT EXISTS(SELECT 1 FROM sys.indexes where name='ci_AppointmentToResource')
BEGIN
	CREATE CLUSTERED INDEX [ci_AppointmentToResource] ON [dbo].[AppointmentToResource] 
	(
		[PracticeID] ASC,
		[AppointmentID] ASC
	)
END