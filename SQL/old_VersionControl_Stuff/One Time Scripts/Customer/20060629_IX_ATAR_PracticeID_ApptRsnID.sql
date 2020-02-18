IF EXISTS(SELECT * FROM sys.indexes WHERE name='PK_AppointmentToAppointmentReason')
	ALTER TABLE AppointmentToAppointmentReason DROP CONSTRAINT PK_AppointmentToAppointmentReason
GO

ALTER TABLE AppointmentToAppointmentReason ADD CONSTRAINT PK_AppointmentToAppointmentReason PRIMARY KEY NONCLUSTERED (AppointmentToAppointmentReasonID)
GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='IX_AppointmentToAppointmentReason_AppointmentID')
	DROP INDEX AppointmentToAppointmentReason.IX_AppointmentToAppointmentReason_AppointmentID
GO

CREATE INDEX IX_AppointmentToAppointmentReason_AppointmentID
ON AppointmentToAppointmentReason (AppointmentID)
GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='UI_AppointmentToAppointmentReason')
	DROP INDEX AppointmentToAppointmentReason.UI_AppointmentToAppointmentReason
GO

CREATE UNIQUE CLUSTERED INDEX UI_AppointmentToAppointmentReason
ON AppointmentToAppointmentReason (PracticeID, AppointmentID, PrimaryAppointment, AppointmentReasonID, AppointmentToAppointmentReasonID)
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name='FK_AppointmentToAppointmentReason_AppointmentReason' AND type='F')
	ALTER TABLE AppointmentToAppointmentReason DROP CONSTRAINT FK_AppointmentToAppointmentReason_AppointmentReason
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name='FK_AppointmentReasonDefaultResource_AppointmentReason' AND type='F')
	ALTER TABLE AppointmentReasonDefaultResource DROP CONSTRAINT FK_AppointmentReasonDefaultResource_AppointmentReason
GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='PK_AppointmentReason')
	ALTER TABLE AppointmentReason DROP CONSTRAINT PK_AppointmentReason
GO

ALTER TABLE AppointmentReason ADD CONSTRAINT PK_AppointmentReason PRIMARY KEY NONCLUSTERED (AppointmentReasonID)
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name='CI_AppointmentReason')
	DROP INDEX AppointmentReason.CI_AppointmentReason
GO

CREATE CLUSTERED INDEX CI_AppointmentReason
ON AppointmentReason (PracticeID, AppointmentReasonID)
GO

ALTER TABLE AppointmentToAppointmentReason  
WITH CHECK ADD  CONSTRAINT FK_AppointmentToAppointmentReason_AppointmentReason
FOREIGN KEY (AppointmentReasonID)
REFERENCES AppointmentReason (AppointmentReasonID)
GO

ALTER TABLE AppointmentReasonDefaultResource  
WITH CHECK ADD  CONSTRAINT FK_AppointmentReasonDefaultResource_AppointmentReason 
FOREIGN KEY(AppointmentReasonID)
REFERENCES AppointmentReason (AppointmentReasonID)
GO

IF EXISTS(SELECT * FROM sys.indexes WHERE name='IX_AppointmentReasonDefaultResource_AppointmentReasonID')
	DROP INDEX AppointmentReasonDefaultResource.IX_AppointmentReasonDefaultResource_AppointmentReasonID
GO

CREATE INDEX IX_AppointmentReasonDefaultResource_AppointmentReasonID
ON AppointmentReasonDefaultResource (AppointmentReasonID)
GO

UPDATE STATISTICS AppointmentReason
GO

UPDATE STATISTICS AppointmentReasonDefaultResource
GO

UPDATE STATISTICS AppointmentToAppointmentReason
GO