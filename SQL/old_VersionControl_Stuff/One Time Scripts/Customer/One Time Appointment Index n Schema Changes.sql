--*****
DROP INDEX Appointment.CI_Appointment

DROP INDEX Appointment.IX_Appointment_AppointmentConfirmationStatusCode

DROP INDEX Appointment.IX_Appointment_EndDate

DROP INDEX Appointment.IX_Appointment_StartDate

DROP INDEX Appointment.IX_Appointment_PatientID

DROP INDEX Appointment.IX_Appointment_ServiceLocationID

CREATE UNIQUE CLUSTERED INDEX [CI_Appointment] ON [dbo].[Appointment] 
(
	[StartDate] ASC,
	[EndDate] ASC,
	[PracticeID] ASC,
	[AppointmentConfirmationStatusCode] ASC,
	[ServiceLocationID] ASC,
	[PatientID] ASC,
	[AppointmentID] ASC
)
--*****

--*****
DROP INDEX AppointmentToResource.CI_AppointmentToResource

CREATE UNIQUE INDEX UI_AppointmentToResource
ON AppointmentToResource (AppointmentID, AppointmentResourceTypeID, ResourceID, AppointmentToResourceID, PracticeID)
--*****

--*****

ALTER TABLE AppointmentRecurrence ADD StartDate DATETIME
GO

UPDATE AR SET StartDate=A.StartDate
FROM Appointment A INNER JOIN AppointmentRecurrence AR
ON A.AppointmentID=AR.AppointmentID

DROP INDEX AppointmentRecurrence.IX_AppointmentRecurrence_RangeEndDate

DROP INDEX AppointmentRecurrence.IX_AppointmentRecurrence_RangeType

CREATE UNIQUE INDEX UI_AppointmentRecurrence
ON AppointmentRecurrence (StartDate, RangeEndDate, RangeType, AppointmentID)

--*****

--*****
DROP INDEX AppointmentToAppointmentReason.CI_AppointmentToAppointmentReason

DROP INDEX AppointmentToAppointmentReason.IX_AppointmentToAppointmentReason_AppointmentID

CREATE UNIQUE INDEX UI_AppointmentToAppointmentReason
ON AppointmentToAppointmentReason (AppointmentID, AppointmentReasonID, AppointmentToAppointmentReasonID, PrimaryAppointment, PracticeID)
--*****

--*****
update statistics AppointmentToResource

update statistics Appointment

update statistics AppointmentRecurrence

update statistics AppointmentToAppointmentReason
--*****
