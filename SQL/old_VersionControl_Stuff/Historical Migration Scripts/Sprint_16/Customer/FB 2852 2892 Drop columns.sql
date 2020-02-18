----------------------------------------------------
--DROP Practice.MerchantAccountEnabled
----------------------------------------------------
DECLARE @default SYSNAME, @sql NVARCHAR(MAX)
SELECT @default = name 
FROM sys.default_constraints 
WHERE parent_object_id = object_id('Practice')
	AND TYPE = 'D'
	AND parent_column_id = (
		SELECT column_id 
		FROM sys.columns 
		WHERE object_id = object_id('Practice')
		AND name = 'MerchantAccountEnabled' 
		)

SET @sql = N'ALTER TABLE Practice DROP CONSTRAINT ' + @default
EXEC sp_executesql @sql

GO 

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Practice' AND COLUMN_NAME = 'MerchantAccountEnabled')
BEGIN
	ALTER TABLE dbo.Practice
	DROP COLUMN MerchantAccountEnabled
END


----------------------------------------------------
--DROP Practice.MerchantAccountEnabledDate
----------------------------------------------------
DECLARE @default SYSNAME, @sql NVARCHAR(MAX)
SELECT @default = name 
FROM sys.default_constraints 
WHERE parent_object_id = object_id('Practice')
	AND TYPE = 'D'
	AND parent_column_id = (
		SELECT column_id 
		FROM sys.columns 
		WHERE object_id = object_id('Practice')
		AND name = 'MerchantAccountEnabledDate' 
		)

SET @sql = N'ALTER TABLE Practice DROP CONSTRAINT ' + @default
EXEC sp_executesql @sql

GO 

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Practice' AND COLUMN_NAME = 'MerchantAccountEnabledDate')
BEGIN
	ALTER TABLE dbo.Practice
	DROP COLUMN MerchantAccountEnabledDate
END


----------------------------------------------------
--Drop Appointment.SendReminder
----------------------------------------------------

DECLARE @default SYSNAME, @sql1 NVARCHAR(MAX)
SELECT @default = name 
FROM sys.default_constraints 
WHERE parent_object_id = object_id('Appointment')
	AND TYPE = 'D'
	AND parent_column_id = (
		SELECT column_id 
		FROM sys.columns 
		WHERE object_id = object_id('Appointment')
		AND name = 'SendAppointmentReminder' 
		)
SET @sql1 = N'ALTER TABLE Appointment DROP CONSTRAINT ' + @default
EXEC sp_executesql @sql1
 
Go 

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Appointment' AND COLUMN_NAME = 'SendAppointmentReminder')
BEGIN
	ALTER TABLE dbo.Appointment
	DROP COLUMN SendAppointmentReminder
END


----------------------------------------------------
--Drop dbo.MerchantAccountConfig
----------------------------------------------------

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME = 'MerchantAccountConfig')
BEGIN
	DROP TABLE dbo.MerchantAccountConfig
END


