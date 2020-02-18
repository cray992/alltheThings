-- add preferred flag
if NOT Exists(select * from sys.columns where Name = N'Preferred' and Object_ID = Object_ID(N'TimeZone'))
	ALTER TABLE dbo.TimeZone ADD Preferred BIT DEFAULT 0 NOT NULL

GO

-- update values
UPDATE dbo.TimeZone SET Preferred = 1 WHERE TimeZoneID IN (5, 9, 11, 16, 19, 18, 24, 34, 33, 37, 48, 53, 50, 55, 56, 64, 62, 67, 72, 73, 78, 81, 83, 84, 89)