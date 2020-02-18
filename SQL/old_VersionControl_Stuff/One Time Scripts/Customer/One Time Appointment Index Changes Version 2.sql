alter table AppointmentToAppointmentReason add PracticeID INT
go
alter table AppointmentToResource add PracticeID INT
go

UPDATE ATA SET PracticeID=A.PracticeID
FROM AppointmentToAppointmentReason ATA
INNER JOIN Appointment A ON ATA.AppointmentID=A.AppointmentID

UPDATE ATR SET PracticeID=A.PracticeID
FROM AppointmentToResource ATR
INNER JOIN Appointment A ON ATR.AppointmentID=A.AppointmentID

alter table AppointmentToAppointmentReason alter Column PracticeID INT NOT NULL
go
alter table AppointmentToResource alter Column PracticeID INT NOT NULL
go

alter table AppointmentToAppointmentReason DROP CONSTRAINT FK_AppointmentToAppointmentReason_Appointment
go
alter table AppointmentToResource DROP CONSTRAINT FK_AppointmentToResource_Appointment
go

alter table AppointmentRecurrence DROP CONSTRAINT FK_AppointmentRecurrence_Appointment
go

alter table AppointmentRecurrenceException DROP CONSTRAINT FK_AppointmentRecurrenceException_Appointment
go

alter table AppointmentToAppointmentReason DROP CONSTRAINT PK_AppointmentToAppointmentReason
go
alter table AppointmentToResource DROP CONSTRAINT PK_AppointmentToResource
go

alter table AppointmentToAppointmentReason ADD CONSTRAINT PK_AppointmentToAppointmentReason 
PRIMARY KEY NONCLUSTERED (AppointmentToAppointmentReasonID)
go
alter table AppointmentToResource ADD CONSTRAINT PK_AppointmentToResource
PRIMARY KEY NONCLUSTERED (AppointmentToResourceID)
go

alter table Appointment DROP CONSTRAINT PK_Appointment
go
alter table Appointment ADD CONSTRAINT PK_Appointment PRIMARY KEY NONCLUSTERED (AppointmentID)
go

CREATE UNIQUE CLUSTERED  INDEX CI_AppointmentToAppointmentReason
ON AppointmentToAppointmentReason (PracticeID, AppointmentID, AppointmentToAppointmentReasonID)
go

CREATE UNIQUE CLUSTERED  INDEX CI_AppointmentToResource
ON AppointmentToResource (PracticeID, AppointmentID, AppointmentToResourceID)
go

CREATE UNIQUE CLUSTERED  INDEX CI_Appointment
ON Appointment (PracticeID, ServiceLocationID, StartDate, EndDate, AppointmentID)
go

CREATE NONCLUSTERED INDEX IX_Appointment_StartDate
ON Appointment (StartDate)
go

CREATE NONCLUSTERED INDEX IX_Appointment_EndDate
ON Appointment (EndDate)
go

CREATE NONCLUSTERED INDEX IX_Appointment_ServiceLocationID
ON Appointment (ServiceLocationID)
go

CREATE NONCLUSTERED INDEX IX_Appointment_AppointmentConfirmationStatusCode
ON Appointment (AppointmentConfirmationStatusCode)
go

CREATE NONCLUSTERED INDEX IX_AppointmentRecurrenceException_AppointmentID
ON AppointmentRecurrenceException (AppointmentID)
go

CREATE NONCLUSTERED INDEX IX_AppointmentRecurrenceException_ExceptionDate
ON AppointmentRecurrenceException (ExceptionDate)
go

CREATE NONCLUSTERED INDEX IX_AppointmentToAppointmentReason_AppointmentID
ON AppointmentToAppointmentReason (AppointmentID)
go

CREATE NONCLUSTERED INDEX IX_AppointmentToResource_AppointmentID
ON AppointmentToResource (AppointmentID)
go

CREATE NONCLUSTERED INDEX IX_AppointmentToResource_AppointmentResourceTypeID
ON AppointmentToResource (AppointmentResourceTypeID)
go

CREATE NONCLUSTERED INDEX IX_AppointmentToResource_ResourceID
ON AppointmentToResource (ResourceID)
go

CREATE NONCLUSTERED INDEX IX_AppointmentRecurrence_RangeType
ON AppointmentRecurrence (RangeType)
go

CREATE NONCLUSTERED INDEX IX_AppointmentRecurrence_RangeEndDate
ON AppointmentRecurrence (RangeEndDate)
go

ALTER TABLE [dbo].[AppointmentToAppointmentReason] ADD CONSTRAINT [FK_AppointmentToAppointmentReason_Appointment] FOREIGN KEY 
	(
		[AppointmentID]
	) REFERENCES [Appointment] (
		[AppointmentID]
	)
GO

ALTER TABLE [dbo].[AppointmentToResource] ADD CONSTRAINT [FK_AppointmentToResource_Appointment] FOREIGN KEY 
	(
		[AppointmentID]
	) REFERENCES [Appointment] (
		[AppointmentID]
	)
GO

ALTER TABLE [dbo].[AppointmentRecurrence] ADD CONSTRAINT [FK_AppointmentRecurrence_Appointment] FOREIGN KEY 
	(
		[AppointmentID]
	) REFERENCES [Appointment] (
		[AppointmentID]
	)
GO

ALTER TABLE [dbo].[AppointmentRecurrenceException] ADD CONSTRAINT [FK_AppointmentRecurrenceException_Appointment] FOREIGN KEY 
	(
		[AppointmentID]
	) REFERENCES [Appointment] (
		[AppointmentID]
	)
GO

DBCC DBREINDEX(Appointment)
GO
DBCC DBREINDEX(AppointmentToAppointmentReason)
GO
DBCC DBREINDEX(AppointmentToResource)
GO

UPDATE STATISTICS Appointment
GO
UPDATE STATISTICS AppointmentToAppointmentReason
GO
UPDATE STATISTICS AppointmentToResource
GO