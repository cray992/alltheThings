USE Superbill_14371_dev
-- USE Superbill_14371_prod
GO

SELECT * FROM dbo.Appointment WHERE ModifiedDate = '2013-01-24 14:37:29.163'


UPDATE dbo.Appointment 
SET	
	StartDate = DATEADD(HOUR, -3, StartDate),
	EndDate = DATEADD(HOUR, -3, EndDate),
	ModifiedDate = GETDATE()
WHERE
	ModifiedDate = '2013-01-24 14:37:29.163'

SELECT * FROM dbo.Appointment