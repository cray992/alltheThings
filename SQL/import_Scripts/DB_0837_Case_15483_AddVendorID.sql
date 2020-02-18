-- DB 0837
-- Practice : Full Solution Services
-- FogBugz Case ID : 14142

----************************* Appointment Reason table
-- Add Columns if necessary

IF NOT EXISTS 
(
	SELECT
	sys.syscolumns.name "ColName"
	FROM sys.sysobjects 
	INNER JOIN sys.syscolumns 
	ON sys.sysobjects.id = sys.syscolumns.id 
	WHERE sys.sysobjects.name = 'AppointmentReason'
	AND (sys.sysobjects.xtype = 'U')
	AND sys.syscolumns.name = 'VendorID'
)
BEGIN
	ALTER TABLE [dbo].[AppointmentReason] ADD
		[VendorID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[VendorImportID] [int] NULL;
	
END


----************************* Appointment
IF NOT EXISTS 
(
	SELECT
	sys.syscolumns.name "ColName"
	FROM sys.sysobjects 
	INNER JOIN sys.syscolumns 
	ON sys.sysobjects.id = sys.syscolumns.id 
	WHERE sys.sysobjects.name = 'Appointment'
	AND (sys.sysobjects.xtype = 'U')
	AND sys.syscolumns.name = 'VendorID'
)
BEGIN
	ALTER TABLE [dbo].Appointment ADD
		[VendorID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[VendorImportID] [int] NULL;
END