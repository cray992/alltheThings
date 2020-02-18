BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='AppointmentGuid' AND COLUMNS.TABLE_NAME='Appointment')
ALTER TABLE dbo.Appointment ADD
	AppointmentGuid uniqueidentifier NOT NULL CONSTRAINT DF_Appointment_AppointmentGuid DEFAULT NEWID()
GO
COMMIT

BEGIN TRANSACTION
GO
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.Columns WHERE column_name='AppointmentReasonGuid' AND COLUMNS.TABLE_NAME='AppointmentReason')
ALTER TABLE dbo.AppointmentReason ADD
	AppointmentReasonGuid uniqueidentifier NOT NULL CONSTRAINT DF_AppointmentReason_AppointmentReasonGuid DEFAULT NEWID()
GO
COMMIT